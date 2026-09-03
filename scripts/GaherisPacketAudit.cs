using System;
using System.Collections.Generic;
using System.Reflection;
using DOL.Events;
using DOL.GS.PacketHandler;

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
        }

        [ScriptUnloadedEvent]
        public static void OnScriptUnloaded(DOLEvent e, object sender, EventArgs args)
        {
            GameEventMgr.RemoveHandler(GamePlayerEvent.GameEntered, new DOLEventHandler(Report));
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
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("PacketAudit: " + ex.Message);
            }
        }
    }
}
