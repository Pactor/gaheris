using System;
using System.Collections.Generic;
using DOL.Events;
using DOL.GS.PacketHandler;
using DOL.GS.PlayerClass;
using DOL.GS.Spells;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// The Warlock casts two spells at once.
    ///
    /// This is the class, and none of it exists in the core. A primary spell
    /// casts in roughly double the usual time, and a secondary added during
    /// that cast lands at the same moment, at no extra cost -- two spells for
    /// one cast and one interrupt window. Three primaries exist only to change
    /// what the secondary does: Range carries it to three thousand units,
    /// Uninterruptable makes it impossible to stop at a cost to its strength,
    /// and Powerless makes it free.
    ///
    /// The data has always been ready for this. Seventy-one spells are flagged
    /// primary and thirty-six secondary, and the delve says so on many of them
    /// -- Infernal Sore reads "Cannot be cast until after a Primary spell has
    /// been cast". The engine is what is missing. Searching the whole codebase
    /// for IsPrimary and IsSecondary turns up one effectiveness penalty and
    /// this, commented out, in PowerCost:
    ///
    ///     // Warlock.
    ///     /* GameSpellEffect effect = FindEffectOnTarget(m_caster, "Powerless");
    ///     if (effect != null &amp;&amp; !m_spell.IsPrimary)
    ///         return 0;*/
    ///
    /// So every Warlock spell cast alone, primers did nothing, and secondaries
    /// could be thrown whenever the player liked in defiance of their own
    /// delve. A Warlock was a caster with a long spell list and no reason to
    /// be a Warlock.
    ///
    /// The chamber work already built most of what this needs -- something
    /// that watches a cast and takes the next spell clicked -- so this is that
    /// same idea applied to any primary rather than only to a chamber.
    /// </summary>
    public static class WarlockPairing
    {
        /// <summary>A primary in mid-cast, and whatever has been hung on it.</summary>
        private class Pairing
        {
            public Spell Primary;
            public Spell Secondary;
            public SpellLine SecondaryLine;
            public GameLiving Target;
            public long Opened;
        }

        /// <summary>
        /// A cast nobody finished should not leave a secondary hanging about
        /// waiting for one. Long enough for the slowest primary and no longer.
        /// </summary>
        private const long STALE = 20000;

        private static readonly Dictionary<string, Pairing> _open = new();
        private static readonly object _lock = new();

        [ScriptLoadedEvent]
        public static void OnScriptLoaded(DOLEvent e, object sender, EventArgs args)
        {
            GameEventMgr.AddHandler(GameLivingEvent.CastFinished, new DOLEventHandler(Landed));
            GameEventMgr.AddHandler(GameLivingEvent.CastFailed, new DOLEventHandler(Lost));
        }

        [ScriptUnloadedEvent]
        public static void OnScriptUnloaded(DOLEvent e, object sender, EventArgs args)
        {
            GameEventMgr.RemoveHandler(GameLivingEvent.CastFinished, new DOLEventHandler(Landed));
            GameEventMgr.RemoveHandler(GameLivingEvent.CastFailed, new DOLEventHandler(Lost));
        }

        /// <summary>
        /// The three primers, which are primaries in everything but the flag.
        ///
        /// They carry IsPrimary = 0 in the data, because they are not damage
        /// or control -- they exist only to change the secondary that follows.
        /// Each holds two numbers worth reading: Range, which is what the
        /// secondary may reach, and Value, which is the price in effectiveness
        /// for that reach. Perennial Range carries a spell three thousand
        /// units at half strength; Enduring Range only seventeen hundred and
        /// fifty but at full.
        /// </summary>
        public static bool IsPrimer(Spell spell)
        {
            return spell?.SpellType is eSpellType.Range
                or eSpellType.Powerless
                or eSpellType.Uninterruptable;
        }

        /// <summary>Anything a secondary may be hung on.</summary>
        public static bool Opens(Spell spell)
        {
            return spell != null && (spell.IsPrimary || IsPrimer(spell));
        }

        /// <summary>
        /// Is this the class that pairs its spells?
        ///
        /// A hired Warlock counts. The player's pairing is done by catching
        /// the packet, and a hire sends none -- so without this it saw the
        /// secondaries for what they look like on paper, instant casts with
        /// real damage, and threw them one after another with no primary at
        /// all. The class played backwards, and better than the player's
        /// version of it.
        /// </summary>
        public static bool Pairs(GameLiving living)
        {
            if (living is GamePlayer player)
                return player.CharacterClass is ClassWarlock;

            return living is GameMercenary hire &&
                   hire.Profile?.ClassId is eCharacterClass.Warlock;
        }

        /// <summary>
        /// A primary has begun casting. From here until it lands, one
        /// secondary may be hung on it.
        /// </summary>
        public static void Begin(GameLiving player, Spell primary)
        {
            if (!Pairs(player) || primary == null)
                return;

            lock (_lock)
            {
                _open[player.InternalID] = new Pairing
                {
                    Primary = primary,
                    Target = player.TargetObject as GameLiving,
                    Opened = GameLoop.GameLoopTime,
                };
            }

            // Said out loud, because the delve cannot say it. ShortDescription
            // is what the client is shown, and the handlers for lifedrain,
            // direct damage and speed decrease all override it with generated
            // text -- which is to say, all three of the Warlock's main primary
            // types. The database description those spells carry never reaches
            // the player, so from inside the game there is no way to tell a
            // primary from an ordinary spell.
            //
            // Every secondary, by contrast, states the requirement in its own
            // delve. The game has always said what a secondary needs and never
            // which spells provide it.
            (player as GamePlayer)?.Out.SendMessage(
                primary.Name + " opens a weave. Add a secondary spell.",
                eChatType.CT_Spell, eChatLoc.CL_SystemWindow);

            Console.WriteLine("Weave: " + player.Name + " opened with " + primary.Name +
                              (primary.IsPrimary ? " (primary)" : " (primer " + primary.SpellType + ")"));
        }

        /// <summary>
        /// Offer a spell to the primary being cast.
        ///
        /// Returns true when it was taken, which tells the packet handler not
        /// to cast it -- it will be released when the primary lands.
        ///
        /// A secondary offered with no primary in flight is refused outright,
        /// which is what its own delve says should happen and what stops the
        /// class being played as an ordinary caster.
        /// </summary>
        public static bool Take(GameLiving player, Spell spell, SpellLine line)
        {
            if (!Pairs(player) || spell == null || line == null)
                return false;

            if (!spell.IsSecondary)
                return false;

            Pairing pairing = Current(player);

            if (pairing == null)
            {
                (player as GamePlayer)?.Out.SendMessage(
                    spell.Name + " cannot be cast until after a primary spell.",
                    eChatType.CT_SpellResisted, eChatLoc.CL_SystemWindow);
                return true;
            }

            if (pairing.Secondary != null)
            {
                (player as GamePlayer)?.Out.SendMessage(
                    "You are already weaving " + pairing.Secondary.Name + " into this spell.",
                    eChatType.CT_SpellResisted, eChatLoc.CL_SystemWindow);
                return true;
            }

            pairing.Secondary = spell;
            pairing.SecondaryLine = line;

            Console.WriteLine("Weave: " + player.Name + " wove " + spell.Name +
                              " into " + pairing.Primary.Name);

            (player as GamePlayer)?.Out.SendMessage(
                spell.Name + " is woven into " + pairing.Primary.Name + ".",
                eChatType.CT_Spell, eChatLoc.CL_SystemWindow);

            return true;
        }

        private static Pairing Current(GameLiving player)
        {
            lock (_lock)
            {
                if (!_open.TryGetValue(player.InternalID, out Pairing pairing))
                    return null;

                if (GameLoop.GameLoopTime - pairing.Opened > STALE)
                {
                    _open.Remove(player.InternalID);
                    return null;
                }

                return pairing;
            }
        }

        private static Pairing Close(GameLiving player)
        {
            lock (_lock)
            {
                if (_open.TryGetValue(player.InternalID, out Pairing pairing))
                {
                    _open.Remove(player.InternalID);
                    return pairing;
                }
            }

            return null;
        }

        /// <summary>
        /// The primary has landed, so the secondary lands with it -- applied
        /// directly rather than cast, because "at the same time" is the whole
        /// point and a second cast would be neither simultaneous nor free.
        /// </summary>
        private static void Landed(DOLEvent e, object sender, EventArgs args)
        {
            try
            {
                if (sender is not GameLiving player || !Pairs(player))
                    return;

                if (args is not CastingEventArgs cast ||
                    cast.SpellHandler?.Spell is not Spell finished)
                    return;

                Pairing pairing = Current(player);

                if (pairing == null || pairing.Primary != finished)
                    return;

                Close(player);

                if (pairing.Secondary == null)
                    return;

                GameLiving at = player.TargetObject as GameLiving ?? pairing.Target;

                if (at == null)
                    return;

                // Range is enforced here because it cannot be enforced
                // anywhere else. The secondary is applied directly rather than
                // cast -- that is what makes it land with the primary -- and
                // applying it directly skips every check a cast would have
                // made, range among them. Without this a woven spell would
                // reach across the zone.
                //
                // A Range primer replaces the secondary's own reach with its
                // own, which is the entire point of it.
                int reach = pairing.Primary.SpellType is eSpellType.Range && pairing.Primary.Range > 0
                    ? pairing.Primary.Range
                    : pairing.Secondary.Range;

                if (reach > 0 && !player.IsWithinRadius(at, reach))
                {
                    (player as GamePlayer)?.Out.SendMessage(
                        at.GetName(0, true) + " is too far away for " +
                        pairing.Secondary.Name + ".",
                        eChatType.CT_SpellResisted, eChatLoc.CL_SystemWindow);
                    return;
                }

                // Powerless is the Witchcraft primer: it makes the secondary
                // free. Anything else and it is paid for here, because
                // applying a spell directly skips the cost the caster would
                // otherwise have met.
                if (pairing.Primary.SpellType is not eSpellType.Powerless)
                    player.Mana -= pairing.Secondary.Power;

                ISpellHandler handler =
                    ScriptMgr.CreateSpellHandler(player, pairing.Secondary, pairing.SecondaryLine);

                handler?.StartSpell(at);
            }
            catch (Exception)
            {
                // A secondary that cannot be woven is not worth an exception
                // escaping into the casting service.
            }
        }

        /// <summary>A primary that never landed takes its secondary with it.</summary>
        private static void Lost(DOLEvent e, object sender, EventArgs args)
        {
            if (sender is GameLiving living && Pairs(living))
                Close(living);
        }
    }
}
