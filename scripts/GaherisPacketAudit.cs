using System;
using System.Collections.Generic;
using System.Reflection;
using DOL.Events;
using DOL.GS.PacketHandler;
using DOL.GS.Scripts;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// Says which handler actually owns the combat-mode packet.
    ///
    /// A probe that logs nothing has two possible meanings and they lead
    /// opposite ways: either the client never sent the packet, or the probe
    /// was never installed to hear it. Without separating those, "nothing in
    /// the log" is not evidence of anything.
    ///
    /// So this reads the table rather than trusting it. PacketProcessor keeps
    /// its handlers in a static cache keyed by client version --
    ///
    ///     private static Dictionary&lt;string, IPacketHandler[]&gt;
    ///         _cachedPacketHandlerSearchResults = [];
    ///
    /// -- built the first time a client connects, which is why this reports on
    /// entering the world rather than at load. If slot 0x74 names our probe,
    /// silence means the key sent nothing and the answer is in the client. If
    /// it names the core's handler, the probe was never registered and the
    /// silence tells us nothing at all.
    /// </summary>
    public static class PacketAudit
    {
        private static bool _reported;

        [ScriptLoadedEvent]
        public static void OnScriptLoaded(DOLEvent e, object sender, EventArgs args)
        {
            GameEventMgr.AddHandler(GamePlayerEvent.GameEntered, new DOLEventHandler(Report));
            GameEventMgr.AddHandler(GameLivingEvent.CastFailed, new DOLEventHandler(CastOutcome));
            GameEventMgr.AddHandler(GameLivingEvent.CastSucceeded, new DOLEventHandler(CastOutcome));
            GameEventMgr.AddHandler(GameLivingEvent.CastFinished, new DOLEventHandler(CastOutcome));
        }

        /// <summary>
        /// What became of a hire's cast.
        ///
        /// Three explanations for the endless rebuffing have now been wrong --
        /// a slot clash between two classes, a suppressed effect the lookup
        /// could not see, and a realm mismatch (a hire takes its employer's
        /// realm, so there is none). Each was plausible and each was reasoning
        /// rather than evidence.
        ///
        /// The one thing not yet observed is what actually happens when the
        /// spell goes off, so that is what this reports: started, succeeded,
        /// finished, or failed and for which of the four reasons the core
        /// admits to. A buff that never lands has to leave a trace in one of
        /// them.
        /// </summary>
        private static void CastOutcome(DOLEvent e, object sender, EventArgs args)
        {
            if (!GaherisSettings.LOG_BUFFS || sender is not GameMercenary hire)
                return;

            string what = args is CastFailedEventArgs failed
                ? "FAILED " + failed.Reason
                : e.Name;

            string spell = (args as CastingEventArgs)?.SpellHandler?.Spell?.Name ?? "?";

            Console.WriteLine("Cast: " + hire.Name + " " + what + " : " + spell +
                              " -> " + (hire.TargetObject == null ? "none" : hire.TargetObject.Name));
        }

        [ScriptUnloadedEvent]
        public static void OnScriptUnloaded(DOLEvent e, object sender, EventArgs args)
        {
            GameEventMgr.RemoveHandler(GamePlayerEvent.GameEntered, new DOLEventHandler(Report));
            GameEventMgr.RemoveHandler(GameLivingEvent.CastFailed, new DOLEventHandler(CastOutcome));
            GameEventMgr.RemoveHandler(GameLivingEvent.CastSucceeded, new DOLEventHandler(CastOutcome));
            GameEventMgr.RemoveHandler(GameLivingEvent.CastFinished, new DOLEventHandler(CastOutcome));
        }

        private static void Report(DOLEvent e, object sender, EventArgs args)
        {
            if (_reported)
                return;

            _reported = true;

            try
            {
                FieldInfo field = typeof(PacketProcessor).GetField(
                    "_cachedPacketHandlerSearchResults",
                    BindingFlags.NonPublic | BindingFlags.Static);

                if (field?.GetValue(null) is not Dictionary<string, IPacketHandler[]> cache)
                {
                    Console.WriteLine("PacketAudit: could not read the handler cache.");
                    return;
                }

                foreach (KeyValuePair<string, IPacketHandler[]> pair in cache)
                {
                    IPacketHandler handler = pair.Value[(int) eClientPackets.PlayerAttackRequest];

                    Console.WriteLine("PacketAudit: version " + pair.Key + ", opcode 0x" +
                                      ((int) eClientPackets.PlayerAttackRequest).ToString("X2") +
                                      " -> " + (handler == null ? "NOTHING" : handler.GetType().FullName));

                    // Every code nobody claims. ProcessInboundPacket drops
                    // those without a word --
                    //
                    //     if (packetHandler == null)
                    //         return;
                    //
                    // -- so if this client sends combat mode on a code the
                    // server was never told about, it disappears exactly the
                    // way a key that sends nothing does. These are the places
                    // it could be hiding.
                    System.Text.StringBuilder free = new();

                    for (int code = 0; code < pair.Value.Length; code++)
                    {
                        if (pair.Value[code] == null)
                            free.Append(" 0x").Append(code.ToString("X2"));
                    }

                    Console.WriteLine("PacketAudit: unclaimed codes:" + free);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("PacketAudit: " + ex.Message);
            }
        }
    }
}
