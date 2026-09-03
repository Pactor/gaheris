using System;
using DOL.Events;
using DOL.GS.PacketHandler;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// The border keep airlock.
    ///
    /// Every border keep has exactly two doors -- the core keeps the list, six
    /// pairs of them -- and between them is a short passage. You open the first
    /// door, step inside, and you are in the frontier. You never reach the
    /// second switch, and the second door never opens onto the old frontier at
    /// all, because you are gone before you can touch it.
    ///
    /// It has to work by sending rather than by walking. The old frontier zones
    /// are part of the realm regions: Castle Sauvage physically stands in
    /// Forest Sauvage, region 1. Stepping out of its outer door is a walk
    /// across Albion, not a border crossing, so there is nothing to intercept
    /// and no door that can be repointed -- DoorMgr builds every door as a bare
    /// GameDoor and the table has no ClassType to override. New Frontiers is
    /// region 163, and the only way into another region is to be sent there.
    ///
    /// Each airlock opens onto the arrival camp on its own side of the map:
    ///
    ///     Castle Sauvage      -> Forest Sauvage Entrance
    ///     Snowdonia Fortress  -> Snowdonia Entrance
    ///     Svasud Faste        -> Uppland Entrance
    ///     Vindsaul Faste      -> Yggdra Forest Entrance
    ///     Druim Ligen         -> Cruachan Gorge Entrance
    ///     Druim Cain          -> Mount Collory Entrance
    ///
    /// Those are the small camps that sit on the coordinates the game's own
    /// crossings already target, so the ground is known good and each has a
    /// hastener standing on it.
    /// </summary>
    public static class FrontierGates
    {
        private const ushort FRONTIER = 163;

        /// <summary>
        /// How wide the trigger is.
        ///
        /// It was 350, because the zonepoints bringing people HOME used to
        /// land 799 to 997 units from these same passages and a wide circle
        /// would have fired them straight back. Migration 64 pushed those
        /// returns out to about 3,000, so that reason is gone -- and 350 was
        /// far too mean in practice. A border keep's own arrival spot is 684
        /// units from the passage midpoint at Druim Ligen, so a player porting
        /// in landed OUTSIDE the trigger and had to find an invisible circle
        /// on foot.
        ///
        /// The six border keeps do not arrive you at a consistent distance
        /// from their own passage: Vindsaul and Druim Cain put you about 100
        /// units away, Druim Ligen 684, and Castle Sauvage, Snowdonia and
        /// Svasud between 1,000 and 1,100. So the circle has to reach 1,100 to
        /// catch a player at any of them, and 1,200 gives that a margin while
        /// still leaving about 1,800 units of clearance to the nearest way
        /// home.
        /// </summary>
        private const int RADIUS = 1200;

        /// <summary>
        /// Seconds after arriving in a realm before an airlock will take you.
        ///
        /// The radius alone is not quite enough: someone who comes home and
        /// then walks toward the keep would be sent back before they had done
        /// anything. This gives them a moment to get clear either way.
        /// </summary>
        private const int GRACE_SECONDS = 20;

        private const string ARRIVED = "GaherisFrontierArrival";
        private const string LAST_REGION = "GaherisFrontierLastRegion";

        private readonly struct Gate
        {
            public readonly ushort Region;
            public readonly int X, Y, Z;
            public readonly int ToX, ToY, ToZ;
            public readonly ushort ToHeading;
            public readonly string Keep, Camp;

            public Gate(ushort region, int x, int y, int z,
                        int toX, int toY, int toZ, ushort toHeading,
                        string keep, string camp)
            {
                Region = region; X = x; Y = y; Z = z;
                ToX = toX; ToY = toY; ToZ = toZ; ToHeading = toHeading;
                Keep = keep; Camp = camp;
            }
        }

        /// <summary>
        /// The midpoint between each keep's two doors, from the core's own
        /// border keep door list.
        /// </summary>
        private static readonly Gate[] Gates =
        {
            new(1,   585237, 477238, 2600, 653995, 615343, 9411, 2000,
                "Castle Sauvage",     "Forest Sauvage"),
            new(1,   528529, 358945, 8320, 615354, 677360, 9372, 1648,
                "Snowdonia Fortress", "Snowdonia"),
            new(100, 766188, 669650, 5736, 649670, 313898, 8797, 1006,
                "Svasud Faste",       "Uppland"),
            new(100, 704018, 738932, 5704, 714416, 366163, 9096,  268,
                "Vindsaul Faste",     "Yggdra Forest"),
            new(200, 334165, 420570, 5336, 396089, 616403, 9232, 1966,
                "Druim Ligen",        "Cruachan Gorge"),
            new(200, 421251, 486389, 1976, 433899, 678939, 9314, 2500,
                "Druim Cain",         "Mount Collory"),
        };

        [ScriptLoadedEvent]
        public static void OnScriptLoaded(DOLEvent e, object sender, EventArgs args)
        {
            GameEventMgr.AddHandler(GamePlayerEvent.RegionChanged,
                                    new DOLEventHandler(NoteArrival));

            int placed = 0;

            foreach (Gate gate in Gates)
            {
                Region region = WorldMgr.GetRegion(gate.Region);

                if (region == null)
                    continue;

                region.AddArea(new GateArea(gate));
                placed++;
            }

            if (placed > 0)
                Console.WriteLine("Frontier airlocks: " + placed +
                                  " border keeps open onto New Frontiers");
        }

        [ScriptUnloadedEvent]
        public static void OnScriptUnloaded(DOLEvent e, object sender, EventArgs args)
        {
            GameEventMgr.RemoveHandler(GamePlayerEvent.RegionChanged,
                                       new DOLEventHandler(NoteArrival));
        }

        /// <summary>
        /// Stamp a player who has just come home FROM the frontier, so the
        /// airlock does not turn them round and send them back.
        ///
        /// Only that direction is stamped. Stamping every region change meant
        /// that porting to a border keep -- itself a region change on most
        /// routes -- put the player under the grace period at the exact moment
        /// they wanted to cross, so the airlock ignored them for twenty
        /// seconds and appeared to be broken.
        /// </summary>
        private static void NoteArrival(DOLEvent e, object sender, EventArgs args)
        {
            if (sender is not GamePlayer player)
                return;

            ushort now = player.CurrentRegionID;
            ushort was = player.TempProperties.GetProperty<ushort>(LAST_REGION);

            player.TempProperties.SetProperty(LAST_REGION, now);

            if (was == FRONTIER && now != FRONTIER)
                player.TempProperties.SetProperty(ARRIVED, GameLoop.GameLoopTime);
        }

        private static bool JustArrived(GamePlayer player)
        {
            long at = player.TempProperties.GetProperty<long>(ARRIVED);
            return at > 0 && GameLoop.GameLoopTime - at < GRACE_SECONDS * 1000L;
        }

        private class GateArea : Area.Circle
        {
            private readonly Gate _gate;

            public GateArea(Gate gate)
                : base("the way to " + gate.Camp, gate.X, gate.Y, gate.Z, RADIUS)
            {
                _gate = gate;
            }

            public override void OnPlayerEnter(GamePlayer player)
            {
                base.OnPlayerEnter(player);

                if (player == null || !player.IsAlive || JustArrived(player))
                    return;

                if (player.InCombat)
                {
                    player.Out.SendMessage(
                        "You cannot cross while you are fighting.",
                        eChatType.CT_System, eChatLoc.CL_SystemWindow);
                    return;
                }

                player.Out.SendMessage(
                    "The passage folds around you, and " + _gate.Camp + " opens ahead.",
                    eChatType.CT_System, eChatLoc.CL_SystemWindow);

                player.MoveTo(FRONTIER, _gate.ToX, _gate.ToY, _gate.ToZ, _gate.ToHeading);

                // The group crosses together. A hire left standing in the keep
                // is a hire the employer has to walk back for.
                foreach (GameMercenary hire in MercenaryManager.GetCompany(player))
                {
                    if (hire != null && hire.IsAlive)
                        hire.MoveTo(FRONTIER,
                                    _gate.ToX + Util.Random(-250, 250),
                                    _gate.ToY + Util.Random(-250, 250),
                                    _gate.ToZ, _gate.ToHeading);
                }
            }
        }
    }
}
