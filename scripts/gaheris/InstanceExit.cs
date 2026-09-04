using System;
using DOL.GS.Quests;
using DOL.GS.Scripts;

namespace DOL.GS.PacketHandler.Client.v168
{
    /// <summary>
    /// A way out of a task dungeon.
    ///
    /// There has never been one. Leaving goes through a zonepoint, looked up
    /// by the id the client sends:
    ///
    ///     DbZonePoint zonePoint = DOLDB&lt;DbZonePoint&gt;.SelectObject(whereClause);
    ///
    ///     if (zonePoint == null)
    ///     {
    ///         ChatUtil.SendDebugMessage(client, "Invalid ZonePoint...");
    ///         return;
    ///     }
    ///
    /// -- and not one of the 120 task dungeon regions has a row. The debug
    /// message goes nowhere for an ordinary account, so the door simply shuts
    /// again and the player is sealed in with no way out but a server restart.
    /// That is how it went: stuck in Dismal Grotto, unable even to quit.
    ///
    /// The id cannot be supplied from here either. It comes out of the
    /// client's own map data, the same wall the entrances ran into, and no
    /// database we hold has it. So the exit is taken rather than described:
    /// if the door is being used from inside a task dungeon, the player goes
    /// back where the taskmaster found them.
    ///
    /// Everything else is left exactly as it was. The packet is rewound and
    /// handed to the core's handler, so every ordinary door in the world
    /// behaves as before -- this only catches the case the core answers with
    /// silence.
    ///
    /// It also records the id the client asked for. That number is the one
    /// piece of the puzzle nobody could get at, and with it these exits could
    /// one day be real zonepoint rows instead of an interception.
    /// </summary>
    [PacketHandler(PacketHandlerType.TCP, eClientPackets.PlayerRegionChangeRequest,
        "Player Region Change Request handler.", eClientStatus.PlayerInGame)]
    public class GaherisRegionChangeRequestHandler : PacketHandler
    {
        private static readonly PlayerRegionChangeRequestHandler _core = new();

        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            long start = packet.Position;

            ushort zonePointId = client.Version >= GameClient.eClientVersion.Version1126
                ? packet.ReadShortLowEndian()
                : packet.ReadShort();

            GamePlayer player = client.Player;

            if (player != null && player.CurrentRegion is BaseInstance &&
                TaskDungeon(player) != null)
            {
                Console.WriteLine("InstanceExit: " + player.Name + " used zonepoint " +
                                  zonePointId + " in region " + player.CurrentRegionID);
                LetThemOut(player);
                return;
            }

            // Not our business. Put the packet back and let the core have it.
            packet.Position = start;
            _core.HandlePacket(client, packet);
        }

        private static TaskDungeonMission TaskDungeon(GamePlayer player)
        {
            return (player.Group?.Mission ?? player.Mission) as TaskDungeonMission;
        }

        /// <summary>
        /// Back to where the taskmaster found them, or to the bind stone if
        /// that was never recorded. The companions come too -- being put
        /// outside without them is how the last several deaths happened.
        /// </summary>
        private static void LetThemOut(GamePlayer player)
        {
            GameLocation home = TaskDungeonReturn.Where(player);

            player.Out.SendMessage("You climb back out into the daylight.",
                eChatType.CT_System, eChatLoc.CL_SystemWindow);

            player.MoveTo(home.RegionID, home.X, home.Y, home.Z, home.Heading);

            foreach (GameMercenary hire in MercenaryManager.GetCompany(player))
            {
                if (hire != null && hire.IsAlive)
                    hire.MoveTo(home.RegionID,
                                home.X + Util.Random(-150, 150),
                                home.Y + Util.Random(-150, 150),
                                home.Z, home.Heading);
            }
        }
    }
}
