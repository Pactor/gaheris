using System;
using System.Collections.Generic;
using DOL.GS.PacketHandler;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// The half of the Warlock's chamber that the core lost.
    ///
    /// A chamber is loaded WHILE it is being cast, not afterwards. The chamber
    /// spell has a long cast time, and during that animation the Warlock
    /// clicks two spells -- a primary and a secondary, in that order -- which
    /// are swallowed rather than cast. When the animation ends the chamber is
    /// armed with them, and casting the chamber again later fires both at once
    /// with no cast time at all.
    ///
    /// Swallowing those two clicks used to be done by overriding CastSpell.
    /// That method no longer exists, and the core says so itself:
    ///
    ///     // Likely to be broken. It used to override 'CastSpell', but it no
    ///     // longer exists in 'SpellHanlder'.
    ///     // Can't be tested since Warlocks aren't functional.
    ///
    /// So the chamber arms with nothing in it and reports that no spells were
    /// loaded, which is exactly what loading one does today.
    ///
    /// This is the missing bookkeeping: who is loading what, and what they
    /// have put in it so far. The window is opened by the chamber's own
    /// handler when the cast begins and closed when it ends; the skill packet
    /// handler asks here whether a spell should be swallowed instead of cast.
    /// </summary>
    public static class ChamberLoader
    {
        /// <summary>What one Warlock has loaded into the chamber being cast.</summary>
        public class Loading
        {
            public Spell Chamber;
            public Spell Primary;
            public SpellLine PrimaryLine;
            public Spell Secondary;
            public SpellLine SecondaryLine;

            public bool Full => Primary != null && Secondary != null;
            public bool Empty => Primary == null && Secondary == null;
        }

        private static readonly Dictionary<string, Loading> _open = new();
        private static readonly object _lock = new();

        /// <summary>A chamber has begun casting: start taking spells for it.</summary>
        public static void Open(GamePlayer player, Spell chamber)
        {
            if (player == null || chamber == null)
                return;

            lock (_lock)
                _open[player.InternalID] = new Loading { Chamber = chamber };

            Console.WriteLine("Chamber: " + player.Name + " began loading " + chamber.Name);
        }

        /// <summary>The cast has ended, one way or another. Hand back what was collected.</summary>
        public static Loading Close(GamePlayer player)
        {
            if (player == null)
                return null;

            lock (_lock)
            {
                if (_open.TryGetValue(player.InternalID, out Loading loading))
                {
                    _open.Remove(player.InternalID);
                    return loading;
                }
            }

            return null;
        }

        /// <summary>
        /// Take a spell into the chamber being cast, if one is open and still
        /// has room. Returns true when the spell was swallowed, which is the
        /// skill handler's cue not to cast it.
        ///
        /// A chamber cannot be loaded into a chamber, and neither can anything
        /// with no cast time to speak of -- the point of the mechanic is to
        /// bank a slow spell and spend it instantly later, so banking an
        /// instant one is free damage rather than a trade.
        /// </summary>
        public static bool Take(GamePlayer player, Spell spell, SpellLine line)
        {
            if (player == null || spell == null || line == null)
                return false;

            Loading loading;

            lock (_lock)
            {
                if (!_open.TryGetValue(player.InternalID, out loading))
                {
                    // The chamber spell itself comes through here on its way to
                    // being cast, before its own handler opens the window. That
                    // is expected and not worth a line.
                    if (spell.SpellType is not eSpellType.Chamber)
                        Console.WriteLine("Chamber: " + player.Name + " clicked " + spell.Name +
                                          " with no chamber open");

                    return false;
                }
            }

            Console.WriteLine("Chamber: " + player.Name + " offering " + spell.Name +
                              " to " + loading.Chamber.Name);

            if (loading.Full)
                return false;

            if (spell.SpellType is eSpellType.Chamber)
            {
                player.Out.SendMessage("A chamber cannot be loaded into another chamber.",
                    eChatType.CT_SpellResisted, eChatLoc.CL_SystemWindow);
                return true;
            }

            if (loading.Primary == null)
            {
                loading.Primary = spell;
                loading.PrimaryLine = line;
                player.Out.SendMessage(
                    spell.Name + " is loaded. Select the second spell for your " +
                    loading.Chamber.Name + ".",
                    eChatType.CT_Spell, eChatLoc.CL_SystemWindow);
            }
            else
            {
                loading.Secondary = spell;
                loading.SecondaryLine = line;
                player.Out.SendMessage(
                    spell.Name + " is loaded.", eChatType.CT_Spell, eChatLoc.CL_SystemWindow);
            }

            return true;
        }
    }
}
