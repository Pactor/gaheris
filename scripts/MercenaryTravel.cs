using System;
using System.Collections.Generic;
using DOL.Events;
using DOL.GS.PacketHandler;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// Hired companions change region the instant their employer does, and an
    /// instance waits for them before it is torn down.
    ///
    /// They already follow across regions -- the leash tick notices the
    /// employer is elsewhere and moves them -- but that tick runs once a
    /// second, and a second is far too long when the region being left is an
    /// instance. A task dungeon is destroyed as its last player walks out
    /// (DestroyWhenEmpty), and everything still standing inside goes with it,
    /// so leaving killed the entire company: the roster read seven going in
    /// and nought coming back out.
    ///
    /// Moving them on the region change itself is most of the answer, but not
    /// all of it, because the teardown happens during the player's own exit
    /// and the companions are still inside at that moment. So the taskmaster
    /// turns DestroyWhenEmpty off, and the instance is closed here instead --
    /// once the last player has gone AND nothing that was hired is left in it.
    /// The taskmaster's delayed close remains as a backstop for the case where
    /// a companion cannot be moved at all.
    /// </summary>
    public static class MercenaryTravel
    {
        /// <summary>Where each player was, captured before they leave it.</summary>
        private static readonly Dictionary<string, Region> _leaving = new();

        [ScriptLoadedEvent]
        public static void OnScriptLoaded(DOLEvent e, object sender, EventArgs args)
        {
            GameEventMgr.AddHandler(GameLivingEvent.RegionChanging, new DOLEventHandler(Leaving));
            GameEventMgr.AddHandler(GamePlayerEvent.RegionChanged, new DOLEventHandler(Followed));
        }

        [ScriptUnloadedEvent]
        public static void OnScriptUnloaded(DOLEvent e, object sender, EventArgs args)
        {
            GameEventMgr.RemoveHandler(GameLivingEvent.RegionChanging, new DOLEventHandler(Leaving));
            GameEventMgr.RemoveHandler(GamePlayerEvent.RegionChanged, new DOLEventHandler(Followed));
        }

        /// <summary>
        /// Fired while the player is still standing in the old region, which is
        /// the only moment it can be recorded -- by the time the move is done
        /// there is nothing left pointing at where they came from.
        /// </summary>
        private static void Leaving(DOLEvent e, object sender, EventArgs args)
        {
            if (sender is GamePlayer player && player.CurrentRegion != null)
            {
                lock (_leaving)
                    _leaving[player.InternalID] = player.CurrentRegion;
            }
        }

        private static void Followed(DOLEvent e, object sender, EventArgs args)
        {
            try
            {
                if (sender is not GamePlayer player || !player.IsAlive)
                    return;

                Region left = null;

                lock (_leaving)
                {
                    if (_leaving.TryGetValue(player.InternalID, out left))
                        _leaving.Remove(player.InternalID);
                }

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

                if (brought > 0)
                    player.Out.SendMessage(
                        brought == 1 ? "Your companion follows you through."
                                     : "Your companions follow you through.",
                        eChatType.CT_System, eChatLoc.CL_SystemWindow);

                CloseIfEmpty(left);
            }
            catch (Exception)
            {
                // Never hold up a zone change over the hired help.
            }
        }

        /// <summary>
        /// Shut an instance down once everybody is clear of it, hired help
        /// included. Called after the companions have been moved, so by this
        /// point the only thing that keeps a dungeon standing is somebody
        /// still being in it.
        /// </summary>
        private static void CloseIfEmpty(Region left)
        {
            if (left is not BaseInstance instance)
                return;

            foreach (GameObject obj in instance.Objects)
            {
                if (obj is GamePlayer standing && standing.ObjectState == GameObject.eObjectState.Active)
                    return;

                if (obj is GameMercenary hire && hire.ObjectState == GameObject.eObjectState.Active)
                    return;
            }

            WorldMgr.RemoveInstance(instance);
        }
    }
}
