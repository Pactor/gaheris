using System;
using System.Collections.Generic;
using DOL.Events;
using DOL.GS.PacketHandler;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// Where the frontier is entered, and how the old one is kept shut.
    ///
    /// Each border keep has two doors. The one facing the realm stays an
    /// ordinary door -- locking it shuts people in, which is exactly what
    /// happened when both were locked. The one facing the frontier never opens
    /// again: touching it carries you to New Frontiers instead.
    ///
    /// Which door faces which way is decided by the map, not by a heuristic.
    /// Every one of the twelve leftover frontier zones lies SOUTH of the realm
    /// interior it borders -- Forest Sauvage below Camelot Hills, Cruachan
    /// Gorge below Connacht, Yggdra Forest below West Svealand, and so on for
    /// all three realms. So at every border keep the frontier-facing door is
    /// simply the one with the lower Y, and the realm-facing one is its
    /// partner.
    ///
    /// The first attempt at this measured which door was nearer the point
    /// players land on when they come home, and that got three of the six
    /// backwards -- Vindsaul, Druim Cain and Druim Ligen -- so walking out of
    /// Druim Ligen towards Connacht threw you into the frontier instead.
    ///
    /// The crossing works by replacing the door OBJECT, not by locking it and
    /// not by intercepting packets. A locked door is worse than useless here:
    /// the core's handler reads
    ///
    ///     if (client.Account.PrivLevel == 1)
    ///         if (!door.Locked) { ... UseDoor(); }
    ///
    /// so for an ordinary player a locked door falls straight through and
    /// nothing happens at all -- which is what "clicking does nothing" was.
    /// Unlocked, that same path ends in door.Open(player), and Open is
    /// virtual. So the six doors are swapped at startup for a subclass that
    /// overrides it. DoorMgr.RegisterDoor is public and keyed by door id,
    /// which is the seam that makes the swap possible.
    /// </summary>
    public static class FrontierGates
    {
        public const ushort FRONTIER = 163;

        /// <summary>An arrival camp in New Frontiers.</summary>
        public readonly struct Camp
        {
            public readonly int X, Y, Z;
            public readonly ushort Heading;
            public readonly string Name;

            public Camp(int x, int y, int z, ushort heading, string name)
            {
                X = x; Y = y; Z = z; Heading = heading; Name = name;
            }
        }

        public static readonly Camp ForestSauvage = new(653995, 615343, 9411, 2000, "Forest Sauvage");
        public static readonly Camp Snowdonia     = new(615354, 677360, 9372, 1648, "Snowdonia");
        public static readonly Camp Uppland       = new(649670, 313898, 8797, 1006, "Uppland");
        public static readonly Camp Yggdra        = new(714416, 366163, 9096,  268, "Yggdra Forest");
        public static readonly Camp Cruachan      = new(396089, 616403, 9232, 1966, "Cruachan Gorge");
        public static readonly Camp Collory       = new(433899, 678939, 9314, 2500, "Mount Collory");

        /// <summary>
        /// The frontier-facing door of each border keep, and the camp it opens
        /// onto. Its partner -- the realm-facing one -- is deliberately absent
        /// and stays an ordinary door.
        /// </summary>
        private static readonly Dictionary<int, Camp> OuterDoors = new()
        {
            { 11020502,  ForestSauvage },   // Castle Sauvage      (partner 11020501)
            { 12000102,  Snowdonia },       // Snowdonia Fortress  (partner 12000101)
            { 102093501, Yggdra },          // Vindsaul Faste      (partner 102093502)
            { 111161301, Uppland },         // Svasud Faste        (partner 111161302)
            { 206016802, Collory },         // Druim Cain          (partner 206016801)
            { 207156902, Cruachan },        // Druim Ligen         (partner 207156901)
        };

        /// <summary>
        /// The border keeps themselves. Three of them -- Castle Sauvage,
        /// Snowdonia Fortress and Svasud Faste -- physically STAND in old
        /// frontier zones, so the safety net below has to leave a hole around
        /// each or a player could never stand on the keep they came to use.
        /// </summary>
        private static readonly (ushort Region, int X, int Y)[] BorderKeeps =
        {
            (1,   585237, 477238),   // Castle Sauvage
            (1,   528529, 358945),   // Snowdonia Fortress
            (100, 704018, 738932),   // Vindsaul Faste
            (100, 766188, 669650),   // Svasud Faste
            (200, 421251, 486389),   // Druim Cain
            (200, 334165, 420570),   // Druim Ligen
        };

        private const int KEEP_CLEARANCE = 5000;
        private const int ZONE_SIZE = 65536;

        /// <summary>
        /// The twelve leftover frontier zones, and the camp each one's strays
        /// belong in. Bounds are the zone's own, from the zones table: offset
        /// times 8192, eight by eight.
        /// </summary>
        private static readonly (ushort Region, int X, int Y, string Zone, Camp To)[] OldFrontier =
        {
            (1,   565248, 417792, "Forest Sauvage",     ForestSauvage),
            (1,   499712, 303104, "Snowdonia",          Snowdonia),
            (1,   565248, 352256, "Pennine Mountains",  ForestSauvage),
            (1,   598016, 286720, "Hadrian's Wall",     ForestSauvage),
            (100, 720896, 606208, "Uppland",            Uppland),
            (100, 655360, 671744, "Yggdra Forest",      Yggdra),
            (100, 655360, 606208, "Jamtland Mountains", Uppland),
            (100, 589824, 573440, "Odin's Gate",        Uppland),
            (200, 385024, 417792, "Mount Collory",      Collory),
            (200, 319488, 352256, "Cruachan Gorge",     Cruachan),
            (200, 385024, 352256, "Breifine",           Cruachan),
            (200, 417792, 286720, "Emain Macha",        Cruachan),
        };

        [GameServerStartedEvent]
        public static void OnServerStarted(DOLEvent e, object sender, EventArgs args)
        {
            int swapped = 0;

            // Doors are loaded by DoorMgr.Init during startup, so by now they
            // exist and can be exchanged for ours.
            foreach (KeyValuePair<int, Camp> gate in OuterDoors)
            {
                GameDoorBase old = DoorMgr.GetDoorByID(gate.Key);

                if (old?.DbDoor == null)
                    continue;

                FrontierGateDoor mine = new() { Opens = gate.Value };
                mine.LoadFromDatabase(old.DbDoor);

                old.RemoveFromWorld();
                DoorMgr.UnregisterDoor(gate.Key);

                mine.AddToWorld();
                DoorMgr.RegisterDoor(mine);
                swapped++;
            }

            int nets = 0;

            foreach ((ushort region, int x, int y, string zone, Camp to) in OldFrontier)
            {
                Region r = WorldMgr.GetRegion(region);

                if (r == null)
                    continue;

                r.AddArea(new StrayArea(zone, x, y, to));
                nets++;
            }

            Console.WriteLine("Frontier gates: " + swapped + " doors open onto New Frontiers, " +
                              nets + " old frontier zones send strays there");
        }

        /// <summary>Is this player close enough to a border keep to be left alone?</summary>
        public static bool AtABorderKeep(GamePlayer player)
        {
            foreach ((ushort region, int x, int y) in BorderKeeps)
            {
                if (player.CurrentRegionID != region)
                    continue;

                long dx = x - player.X;
                long dy = y - player.Y;

                if (dx * dx + dy * dy < (long) KEEP_CLEARANCE * KEEP_CLEARANCE)
                    return true;
            }

            return false;
        }

        public static void Send(GamePlayer player, Camp camp, string how)
        {
            player.Out.SendMessage(how, eChatType.CT_System, eChatLoc.CL_SystemWindow);
            player.MoveTo(FRONTIER, camp.X, camp.Y, camp.Z, camp.Heading);

            foreach (GameMercenary hire in MercenaryManager.GetCompany(player))
            {
                if (hire != null && hire.IsAlive)
                    hire.MoveTo(FRONTIER, camp.X + Util.Random(-250, 250),
                                camp.Y + Util.Random(-250, 250), camp.Z, camp.Heading);
            }
        }

        /// <summary>
        /// A whole leftover frontier zone, watching for anyone who ends up in
        /// it. There is no route into these any more, but a bind point, a
        /// release, a summon or a stray zonepoint could still put someone
        /// there, and the old frontier is not somewhere to be stranded.
        ///
        /// Staff are exempt: someone with a privilege level is there on
        /// purpose, probably to look at exactly this.
        /// </summary>
        private class StrayArea : Area.Square
        {
            private readonly Camp _to;

            public StrayArea(string zone, int x, int y, Camp to)
                : base("old " + zone, x, y, ZONE_SIZE, ZONE_SIZE)
            {
                _to = to;
            }

            public override void OnPlayerEnter(GamePlayer player)
            {
                base.OnPlayerEnter(player);

                if (player == null || !player.IsAlive || player.Client.Account.PrivLevel > 1)
                    return;

                // Three border keeps stand inside these zones. Someone at one
                // of them is exactly where they meant to be.
                if (AtABorderKeep(player))
                    return;

                FrontierGates.Send(player, _to,
                    "This ground was left behind when the frontier moved. " +
                    _to.Name + " takes you in.");
            }
        }
    }

    /// <summary>
    /// The frontier-facing door of a border keep. It does not open; it takes
    /// you across.
    ///
    /// Open is the seam because that is where the core's handler ends up for
    /// an ordinary player at an unlocked door -- door.Open(player), with the
    /// player passed in as the opener. Never calling base means the door never
    /// actually swings, which is the "locked" this gate needs: nobody walks
    /// through it into the old frontier.
    /// </summary>
    public class FrontierGateDoor : GameDoor
    {
        public FrontierGates.Camp Opens { get; set; }

        public override void Open(GameLiving opener = null)
        {
            if (opener is not GamePlayer player)
                return;   // Deliberately not base.Open -- this gate stays shut.

            if (player.InCombat)
            {
                player.Out.SendMessage("You cannot cross while you are fighting.",
                                       eChatType.CT_System, eChatLoc.CL_SystemWindow);
                return;
            }

            FrontierGates.Send(player, Opens,
                "The gate will not open. The frontier takes you instead, and " +
                Opens.Name + " is ahead of you.");
        }
    }
}
