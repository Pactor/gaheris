using System;
using DOL.Events;
using DOL.GS.PacketHandler;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// Hired companions change region the instant their employer does.
    ///
    /// They already follow across regions -- the leash tick notices the
    /// employer is elsewhere and moves them -- but that tick runs once a
    /// second, and a second is too long when the region being left is an
    /// instance. A task dungeon is torn down as soon as the last player walks
    /// out of it, and anything still standing inside goes with it. Leaving a
    /// dungeon therefore killed the entire company, every time.
    ///
    /// So the move happens on the region change itself rather than on the next
    /// tick. The leash still handles everything else; this only closes the
    /// window where the ground disappears from under them.
    /// </summary>
    public static class MercenaryTravel
    {
        [ScriptLoadedEvent]
        public static void OnScriptLoaded(DOLEvent e, object sender, EventArgs args)
        {
            GameEventMgr.AddHandler(GamePlayerEvent.RegionChanged, new DOLEventHandler(Followed));
        }

        [ScriptUnloadedEvent]
        public static void OnScriptUnloaded(DOLEvent e, object sender, EventArgs args)
        {
            GameEventMgr.RemoveHandler(GamePlayerEvent.RegionChanged, new DOLEventHandler(Followed));
        }

        private static void Followed(DOLEvent e, object sender, EventArgs args)
        {
            try
            {
                if (sender is not GamePlayer player || !player.IsAlive)
                    return;

                int brought = 0;

                foreach (GameMercenary hire in MercenaryManager.GetCompany(player))
                {
                    if (hire == null || !hire.IsAlive)
                        continue;

                    if (hire.CurrentRegionID == player.CurrentRegionID)
                        continue;

                    hire.MoveTo(player.CurrentRegionID,
                                player.X + Util.Random(-150, 150),
                                player.Y + Util.Random(-150, 150),
                                player.Z, player.Heading);
                    brought++;
                }

                // Said out loud on purpose while this is being trusted: if
                // companions are being left behind, the count is the evidence.
                Console.WriteLine("MercenaryTravel: " + player.Name + " -> region " +
                                  player.CurrentRegionID + ", company " +
                                  MercenaryManager.GetCompany(player).Count +
                                  ", brought " + brought);

                if (brought > 0)
                    player.Out.SendMessage(
                        brought == 1 ? "Your companion follows you through."
                                     : "Your companions follow you through.",
                        eChatType.CT_System, eChatLoc.CL_SystemWindow);
            }
            catch (Exception)
            {
                // Never hold up a zone change over the hired help.
            }
        }
    }
}
