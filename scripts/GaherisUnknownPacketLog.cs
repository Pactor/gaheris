using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

namespace DOL.GS.PacketHandler.Client.v168
{
    /// <summary>
    /// A record of everything the client sends that this server does not
    /// understand.
    ///
    /// 176 of the 256 packet codes have no handler, and the server drops them
    /// without a word -- no log, no warning, no answer. Anything the client
    /// does on one of those codes is a feature that silently does nothing, and
    /// there is no way to tell that from a key that was never pressed. That is
    /// exactly the position the combat-mode toggle is in.
    ///
    /// Every one of those codes now arrives here. What is worth knowing is the
    /// first sighting of each: which code, how big, and what was in it. After
    /// that they are only counted, because a packet the client sends on a
    /// timer would otherwise bury everything else -- the useful line is the
    /// one that appears the moment somebody presses a key nobody has claimed.
    ///
    /// Written to the console, which docker keeps, and to a file next to the
    /// scripts so it survives being read at leisure.
    /// </summary>
    public static class UnknownPacketLog
    {
        /// <summary>Beside the scripts, which are mounted from the repository.</summary>
        private const string FILE = "/app/scripts/custom/unknown-packets.log";

        /// <summary>Full detail for the first few of any given code.</summary>
        private const int DETAILED = 3;

        /// <summary>Then a count, at widening intervals, so a heartbeat cannot bury the rest.</summary>
        private const int THEN_EVERY = 200;

        private static readonly Dictionary<int, int> _seen = new();
        private static readonly object _lock = new();

        public static void Note(int code, GameClient client, GSPacketIn packet)
        {
            try
            {
                int count;

                lock (_lock)
                {
                    _seen.TryGetValue(code, out count);
                    count++;
                    _seen[code] = count;
                }

                if (count > DETAILED && count % THEN_EVERY != 0)
                    return;

                string who = client?.Player?.Name ?? client?.Account?.Name ?? "?";
                StringBuilder line = new();

                line.Append(DateTime.Now.ToString("HH:mm:ss")).Append(" 0x")
                    .Append(code.ToString("X2")).Append(" from ").Append(who)
                    .Append(", ").Append(packet.PacketSize).Append(" bytes");

                if (count > DETAILED)
                    line.Append(" (seen ").Append(count).Append(" times)");
                else
                {
                    // Why it was sent is not in the packet -- nothing in it
                    // says "the tilde was pressed". What can be recorded is
                    // what was happening at that moment, which is what makes
                    // one of these lines readable weeks later: a code that
                    // only ever arrives while standing still with no target is
                    // a UI action, one that arrives mid-fight with a target is
                    // not, and one carrying readable text explains itself.
                    line.Append(Environment.NewLine).Append("    doing: ")
                        .Append(Doing(client));
                    line.Append(Environment.NewLine).Append("    bytes: ")
                        .Append(Bytes(packet));
                    line.Append(Environment.NewLine).Append("    text:  ")
                        .Append(Text(packet));
                }

                string text = "UnknownPacket: " + line;
                Console.WriteLine(text);

                // Say it to whoever caused it, as well. Otherwise finding out
                // what a key sends means pressing it, stopping, and having
                // somebody else read a log -- which is no way to hunt for a
                // keybind. This way the answer arrives in the chat window at
                // the moment the key goes down.
                client?.Player?.Out?.SendMessage(
                    "[packet] unhandled 0x" + code.ToString("X2") + ", " +
                    packet.PacketSize + " bytes",
                    eChatType.CT_Staff, eChatLoc.CL_SystemWindow);

                lock (_lock)
                {
                    try
                    {
                        File.AppendAllText(FILE, text + Environment.NewLine);
                    }
                    catch (Exception)
                    {
                        // A read-only mount is not a reason to stop logging to
                        // the console, which is where this is usually read.
                    }
                }
            }
            catch (Exception)
            {
                // Nothing here is worth interrupting a packet over.
            }
        }

        /// <summary>
        /// What the player was doing when it arrived.
        ///
        /// The nearest thing to a reason that can be had. A code that only
        /// ever turns up standing still, out of combat, with nothing targeted
        /// is something pressed on the interface; one that turns up mid-swing
        /// with a target is part of fighting; one that turns up the instant a
        /// zone changes is about the world. None of that is certain, and all
        /// of it is more than a bare hex code says.
        /// </summary>
        private static string Doing(GameClient client)
        {
            GamePlayer p = client?.Player;

            if (p == null)
                return "not in the world";

            StringBuilder s = new();

            s.Append(p.Name).Append(", ").Append(p.CharacterClass?.Name ?? "?")
             .Append(" ").Append(p.Level);
            s.Append(" | region ").Append(p.CurrentRegionID);

            if (p.CurrentZone != null)
                s.Append(" (").Append(p.CurrentZone.Description).Append(')');

            s.Append(" | target ")
             .Append(p.TargetObject == null ? "none" : p.TargetObject.Name);
            s.Append(" | weapon ").Append(p.ActiveWeaponSlot);

            if (p.InCombat) s.Append(" | in combat");
            if (p.IsCasting) s.Append(" | casting");
            if (p.IsMoving) s.Append(" | moving");
            if (p.IsSitting) s.Append(" | sitting");
            if (p.IsStealthed) s.Append(" | stealthed");
            if (!p.IsAlive) s.Append(" | dead");

            return s.ToString();
        }

        /// <summary>
        /// The payload read as text. Many client packets carry a name, a
        /// command or a line of chat, and when they do the packet explains
        /// itself far better than its bytes do.
        /// </summary>
        private static string Text(GSPacketIn packet)
        {
            try
            {
                byte[] raw = packet.ToArray();
                StringBuilder s = new();

                foreach (byte b in raw)
                    s.Append(b >= 32 && b < 127 ? (char) b : '.');

                return s.ToString();
            }
            catch (Exception)
            {
                return "(unreadable)";
            }
        }

        /// <summary>
        /// The payload as hex, capped. Enough to recognise a packet by, not so
        /// much that one chatty code fills the file.
        /// </summary>
        private static string Bytes(GSPacketIn packet)
        {
            try
            {
                byte[] raw = packet.ToArray();
                int take = Math.Min(raw.Length, 32);
                StringBuilder hex = new();

                for (int i = 0; i < take; i++)
                    hex.Append(raw[i].ToString("X2")).Append(' ');

                if (raw.Length > take)
                    hex.Append("...");

                return hex.ToString().TrimEnd();
            }
            catch (Exception)
            {
                return "(unreadable)";
            }
        }
    }
}
