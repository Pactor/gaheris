using System;
using System.Collections.Generic;
using DOL.GS.Effects;
using DOL.GS.PacketHandler;
using DOL.GS.Spells;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// The Warlock's chambers, working.
    ///
    /// The core's handler carries its own epitaph:
    ///
    ///     // Likely to be broken. It used to override 'CastSpell', but it no
    ///     // longer exists in 'SpellHanlder'.
    ///     // Can't be tested since Warlocks aren't functional.
    ///
    /// The discharge half survives -- given an armed chamber it fires what is
    /// inside. What a refactor took away is the loading half: the override
    /// that swallowed the two spells clicked during the chamber's own cast.
    /// Without it a chamber always arms empty and says so.
    ///
    /// How it is meant to go: the chamber is a long cast, and during that
    /// animation the Warlock clicks a primary and then a secondary spell,
    /// which are taken into it rather than cast. When the animation ends the
    /// chamber is armed and floats above him. Casting it again later fires
    /// both at once, instantly, and spends it.
    ///
    /// This DERIVES from the core handler rather than replacing it outright,
    /// and that is not a nicety. The packet that draws the chamber orbs does
    ///
    ///     ChamberSpellHandler chamber = (ChamberSpellHandler)effect.SpellHandler;
    ///     sortList[chamber.EffectSlot] = effect;
    ///
    /// so anything not descended from ChamberSpellHandler throws the moment a
    /// chamber arms. Inheriting also means PrimarySpell, SecondarySpell and
    /// EffectSlot are the very fields that packet reads.
    ///
    /// ScriptMgr.CacheSpellHandlerConstructor walks the compiled scripts before
    /// the core assembly and returns the first match, so this is what gets
    /// built for eSpellType.Chamber.
    /// </summary>
    [SpellHandler(eSpellType.Chamber)]
    public class WarlockChamber : ChamberSpellHandler
    {
        public WarlockChamber(GameLiving caster, Spell spell, SpellLine line)
            : base(caster, spell, line)
        {
        }

        /// <summary>
        /// Which orb this chamber occupies above the Warlock's head.
        ///
        /// The core's GetEffectSlot knows five names and three of ours are not
        /// among them -- Decimation, Lesser Fate and Creation all come back
        /// nought. That matters more than a missing icon: the packet builds a
        /// list keyed 1 to 5 and writes one byte per entry, so a nought puts a
        /// sixth entry in it and the client is handed a longer packet than it
        /// expects.
        /// </summary>
        private static readonly Dictionary<string, int> ORBS = new()
        {
            { "Chamber of Minor Fate",   1 },
            { "Chamber of Lesser Fate",  1 },
            { "Chamber of Restraint",    2 },
            { "Chamber of Creation",     2 },
            { "Chamber of Destruction",  3 },
            { "Chamber of Decimation",   3 },
            { "Chamber of Fate",         4 },
            { "Chamber of Greater Fate", 5 },
        };

        private static int Orb(string chamber)
        {
            return ORBS.TryGetValue(chamber, out int slot) ? slot : 1;
        }

        /// <summary>
        /// A loaded chamber goes off instantly. That is the entire point of
        /// one: six seconds are spent filling it so that later it costs
        /// nothing but the click.
        ///
        /// Without this the second cast simply starts the six second
        /// animation over again -- the discharge is recognised correctly and
        /// then never arrives, because the spell never finishes casting. From
        /// the outside it looks like the chamber refuses to release and tries
        /// to re-cast itself, which is exactly how it looked.
        /// </summary>
        public override int CalculateCastingTime()
        {
            return Armed() != null ? 0 : base.CalculateCastingTime();
        }

        /// <summary>An armed chamber of this name already floating above the caster.</summary>
        private GameSpellEffect Armed()
        {
            return FindEffectOnTarget(Caster, "Chamber", Spell.Name);
        }

        /// <summary>
        /// Open the loading window as the cast begins -- unless this cast is a
        /// discharge, in which case there is nothing to load and the chamber is
        /// about to be spent.
        /// </summary>
        public override bool CheckBeginCast(GameLiving selectedTarget)
        {
            if (!base.CheckBeginCast(selectedTarget))
            {
                Console.WriteLine("Chamber: " + Spell.Name + " refused before casting");
                return false;
            }

            if (Caster is not GamePlayer player)
                return true;

            if (Armed() != null)
            {
                // Already loaded, so this cast spends it rather than filling
                // it. Said out loud because from the outside the two look
                // identical and only one of them opens a window.
                Console.WriteLine("Chamber: " + player.Name + " casting " + Spell.Name +
                                  " to discharge it");
                return true;
            }

            ChamberLoader.Open(player, Spell);
            player.Out.SendMessage("Select the first spell for your " + Spell.Name + ".",
                eChatType.CT_Spell, eChatLoc.CL_SystemWindow);

            return true;
        }

        /// <summary>
        /// The animation has ended. Take what was clicked into the chamber and
        /// arm it, or say plainly that nothing went in.
        /// </summary>
        public override void FinishSpellCast(GameLiving target)
        {
            if (Caster is not GamePlayer player)
                return;

            // A discharge. This is where it has to happen: the cast finishing
            // is the only thing that runs, and returning here -- as this did --
            // means the chamber is recognised, announced, and then quietly does
            // nothing at all. Which is precisely how it behaved.
            if (Armed() != null)
            {
                StartSpell(target);
                return;
            }

            ChamberLoader.Loading loaded = ChamberLoader.Close(player);

            Console.WriteLine("Chamber: " + Spell.Name + " finished with " +
                              (loaded == null ? "no window"
                                  : (loaded.Primary?.Name ?? "-") + " / " +
                                    (loaded.Secondary?.Name ?? "-")));

            Caster.Mana -= PowerCost(target);

            if (loaded == null || loaded.Empty)
            {
                MessageToCaster("No spells were loaded into " + Spell.Name + ".",
                    eChatType.CT_Spell);
                return;
            }

            // A chamber holds a pair or it holds nothing. Every description of
            // the mechanic is of loading a primary AND a secondary, and none
            // describes banking one spell -- which makes sense, since a
            // chamber that held a single spell would be a free instant cast
            // rather than a trade.
            //
            // The core's orb packet does have a branch for a primary with no
            // secondary, which is what first suggested it was allowed. That
            // shows the client can draw such a chamber, not that the game ever
            // let you make one.
            if (loaded.Primary == null || loaded.Secondary == null)
            {
                MessageToCaster(Spell.Name + " needs both a primary and a secondary spell. " +
                                "It collapses unused.", eChatType.CT_SpellResisted);
                return;
            }

            PrimarySpell = loaded.Primary;
            PrimarySpellLine = loaded.PrimaryLine;
            SecondarySpell = loaded.Secondary;
            SecondarySpellLine = loaded.SecondaryLine;
            EffectSlot = Orb(Spell.Name);

            MessageToCaster("Your " + Spell.Name + " is ready for use.", eChatType.CT_Spell);

            GameSpellEffect effect = CreateSpellEffect(Caster, 1);
            effect.Start(Caster);
            SendEffectAnimation(Caster, 0, false, 1);
            player.Out.SendWarlockChamberEffect(player);
        }

        /// <summary>
        /// Fire what is inside. An unloaded chamber does nothing here -- the
        /// loading happened during the cast and the arming when it finished.
        /// </summary>
        public override bool StartSpell(GameLiving target)
        {
            GameSpellEffect effect = Armed();

            if (effect == null || effect.SpellHandler is not WarlockChamber chamber)
                return true;

            Console.WriteLine("Chamber: firing " + Spell.Name + " -- " +
                              (chamber.PrimarySpell?.Name ?? "-") + " / " +
                              (chamber.SecondarySpell?.Name ?? "-") + " at " +
                              ((Caster as GamePlayer)?.TargetObject?.Name ?? "no target"));

            GameLiving at = (Caster as GamePlayer)?.TargetObject as GameLiving ?? target;

            if (at == null)
            {
                MessageToCaster("You must have a target!", eChatType.CT_SpellResisted);
                return false;
            }

            // Range is measured against what the chamber FIRES, not against
            // the chamber itself. Every chamber spell carries Range 0, so the
            // ordinary check in CheckBeginCast tests nothing whatsoever, while
            // the spell banked inside reaches between 1500 and 2250. Without
            // this a chamber discharges a bolt across the zone.
            //
            // DOLSharp checked this explicitly, against the primary's own
            // handler rather than the chamber's:
            //
            //     if (!caster.IsWithinRadius(m_spellTarget,
            //             ((SpellHandler) spellhandler).CalculateSpellRange()))
            //     { MessageToCaster("That target is too far away!"); return false; }
            int reach = chamber.PrimarySpell?.Range ?? 0;

            if (reach > 0 && !Caster.IsWithinRadius(at, reach))
            {
                MessageToCaster("That target is too far away!", eChatType.CT_SpellResisted);
                return false;
            }

            Fire(chamber.PrimarySpell, chamber.PrimarySpellLine, at);
            Fire(chamber.SecondarySpell, chamber.SecondarySpellLine, at);

            // Spent. A chamber is a bank, not a buff.
            //
            // Cancel alone does not do it. It wraps its removal in
            // BeginChanges/CommitChanges, and this runs inside the casting
            // pipeline which already holds that batch open, so the effect is
            // marked expired and stays in the list -- the orb was not a stale
            // picture, it was an accurate one. Taken out of the list directly
            // as well, which is what Cancel would have done had it been able
            // to finish.
            effect.Cancel(false);
            Caster.EffectList.Remove(effect);

            Console.WriteLine("Chamber: after firing, still armed = " + (Armed() != null));

            if (Caster is GamePlayer player)
            {
                player.Out.SendWarlockChamberEffect(player);

                // And once more a moment later. The orb is drawn from a walk
                // of the effect list, and sending that while the list is still
                // settling leaves the spent chamber painted above the head
                // even though it is gone from the server.
                new ECSGameTimer(player, Repaint, 500).Start(500);
            }

            return true;
        }

        private static int Repaint(ECSGameTimer timer)
        {
            if (timer.Owner is GamePlayer player)
                player.Out.SendWarlockChamberEffect(player);

            return 0;
        }

        private void Fire(Spell spell, SpellLine line, GameLiving at)
        {
            if (spell == null || line == null)
                return;

            ScriptMgr.CreateSpellHandler(Caster, spell, line)?.StartSpell(at);
        }

        protected override GameSpellEffect CreateSpellEffect(GameLiving target, double effectiveness)
        {
            return new GameSpellEffect(this, 0, 0, effectiveness);
        }
    }
}
