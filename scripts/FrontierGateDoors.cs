using System;
using System.Collections.Generic;
using DOL.GS.PacketHandler;
using DOL.GS.PacketHandler.Client.v168;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// The border keep doors are the way to New Frontiers.
    ///
    /// They are switch-operated gates that open onto the old frontier, which
    /// is not anywhere anyone should be going any more. So the switches are
    /// dead -- the doors are locked in the database, and CanBeOpenedViaInteraction
    /// is !Locked, so nothing opens them -- and clicking one crosses you
    /// instead.
    ///
    /// This intercepts the door packet rather than changing the door, because
    /// a door cannot be changed. DoorMgr builds every one as a bare GameDoor
    /// and the table has no ClassType column, so there is no way to give a
    /// door custom behaviour through data. A packet handler is the seam that
    /// does exist: PacketProcessor loads the core's handlers first and then
    /// walks ScriptMgr.Scripts into the same array, so a script handler for
    /// the same packet code replaces the core's.
    ///
    /// Everything that is not a border keep door is handed straight back to
    /// the core handler untouched. The packet is rewound first -- PacketIn is
    /// a MemoryStream, so Position is settable -- because reading the door id
    /// has already moved it and the core would otherwise read from the middle
    /// of its own packet.
    /// </summary>
    [PacketHandler(PacketHandlerType.TCP, eClientPackets.DoorRequest,
                   "Border keep doors cross to New Frontiers", eClientStatus.PlayerInGame)]
    public class FrontierGateDoors : DoorRequestHandler
    {
        private const ushort FRONTIER = 163;

        /// <summary>A border keep's two doors, and where they open onto.</summary>
        private readonly struct Gate
        {
            public readonly int ToX, ToY, ToZ;
            public readonly ushort ToHeading;
            public readonly string Camp;

            public Gate(int toX, int toY, int toZ, ushort toHeading, string camp)
            {
                ToX = toX; ToY = toY; ToZ = toZ; ToHeading = toHeading; Camp = camp;
            }
        }

        /// <summary>
        /// Door id to destination. The ids are the core's own border keep
        /// list, from GameDoor._borderKeepDoorIds -- six pairs, one pair per
        /// keep -- so this covers every border keep door there is and nothing
        /// else.
        /// </summary>
        private static readonly Dictionary<int, Gate> Gates = new()
        {
            // Castle Sauvage -> Forest Sauvage
            { 11020501, new Gate(653995, 615343, 9411, 2000, "Forest Sauvage") },
            { 11020502, new Gate(653995, 615343, 9411, 2000, "Forest Sauvage") },
            // Snowdonia Fortress -> Snowdonia
            { 12000101, new Gate(615354, 677360, 9372, 1648, "Snowdonia") },
            { 12000102, new Gate(615354, 677360, 9372, 1648, "Snowdonia") },
            // Vindsaul Faste -> Yggdra Forest
            { 102093501, new Gate(714416, 366163, 9096, 268, "Yggdra Forest") },
            { 102093502, new Gate(714416, 366163, 9096, 268, "Yggdra Forest") },
            // Svasud Faste -> Uppland
            { 111161301, new Gate(649670, 313898, 8797, 1006, "Uppland") },
            { 111161302, new Gate(649670, 313898, 8797, 1006, "Uppland") },
            // Druim Cain -> Mount Collory
            { 206016801, new Gate(433899, 678939, 9314, 2500, "Mount Collory") },
            { 206016802, new Gate(433899, 678939, 9314, 2500, "Mount Collory") },
            // Druim Ligen -> Cruachan Gorge
            { 207156901, new Gate(396089, 616403, 9232, 1966, "Cruachan Gorge") },
            { 207156902, new Gate(396089, 616403, 9232, 1966, "Cruachan Gorge") },
        };

        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            long start = packet.Position;
            int doorId = (int) packet.ReadInt();
            packet.Position = start;

            if (Gates.TryGetValue(doorId, out Gate gate) &&
                Cross(client.Player, doorId, gate))
                return;

            base.HandlePacketInternal(client, packet);
        }

        /// <summary>
        /// Take the player across. Returns false to let the core have the
        /// door back -- if they are too far away to be touching it, or busy.
        /// </summary>
        private static bool Cross(GamePlayer player, int doorId, Gate gate)
        {
            if (player == null || !player.IsAlive)
                return false;

            // Border keep doors are reached from further out than ordinary
            // ones -- the core allows WORLD_PICKUP_DISTANCE * 3 for exactly
            // these -- so match that rather than inventing a range. If the
            // door is not loaded or the player is nowhere near it, hand the
            // packet back and let the core answer however it normally would.
            GameDoorBase door = DoorMgr.GetDoorByID(doorId);

            if (door == null)
                return false;

            int reach = ServerProperties.Properties.WORLD_PICKUP_DISTANCE * 3;

            if (!player.IsWithinRadius(door, reach))
                return false;

            if (player.InCombat)
            {
                player.Out.SendMessage("You cannot cross while you are fighting.",
                                       eChatType.CT_System, eChatLoc.CL_SystemWindow);
                return true;
            }

            player.Out.SendMessage(
                "You pass through the gate, and " + gate.Camp + " opens ahead of you.",
                eChatType.CT_System, eChatLoc.CL_SystemWindow);

            player.MoveTo(FRONTIER, gate.ToX, gate.ToY, gate.ToZ, gate.ToHeading);

            // Hired companions cross with their employer.
            foreach (GameMercenary hire in MercenaryManager.GetCompany(player))
            {
                if (hire != null && hire.IsAlive)
                    hire.MoveTo(FRONTIER,
                                gate.ToX + Util.Random(-250, 250),
                                gate.ToY + Util.Random(-250, 250),
                                gate.ToZ, gate.ToHeading);
            }

            return true;
        }
    }
}

namespace DOL.GS.Scripts
{
    /// <summary>
    /// The way back out, standing in each New Frontiers arrival camp.
    ///
    /// The border keep doors only exist in the realm regions, so clicking a
    /// door to come home is not something the frontier side can offer -- there
    /// is no door there to click. This is its counterpart: the same stone, in
    /// the camp the gate delivers you to, sending you back to the keep you
    /// came through.
    ///
    /// It works out which keep from where it stands, so the six of them need
    /// no configuration beyond being placed in the right camp.
    /// </summary>
    public class FrontierReturn : GameNPC
    {
        private readonly struct Way
        {
            public readonly int CampX, CampY;
            public readonly ushort Region;
            public readonly int ToX, ToY, ToZ;
            public readonly ushort ToHeading;
            public readonly string Keep;

            public Way(int campX, int campY, ushort region,
                       int toX, int toY, int toZ, ushort toHeading, string keep)
            {
                CampX = campX; CampY = campY; Region = region;
                ToX = toX; ToY = toY; ToZ = toZ; ToHeading = toHeading; Keep = keep;
            }
        }

        private static readonly Way[] Ways =
        {
            new(653995, 615343, 1,   584151, 477177, 2600, 2000, "Castle Sauvage"),
            new(615354, 677360, 1,   527543, 358900, 8320, 1648, "Snowdonia Fortress"),
            new(649670, 313898, 100, 767242, 669591, 5736, 1006, "Svasud Faste"),
            new(714416, 366163, 100, 704110, 738883, 5704,  268, "Vindsaul Faste"),
            new(396089, 616403, 200, 334435, 419941, 5184, 1966, "Druim Ligen"),
            new(433899, 678939, 200, 421156, 486429, 1976, 2500, "Druim Cain"),
        };

        private bool Nearest(out Way found)
        {
            found = default;
            double best = double.MaxValue;

            foreach (Way w in Ways)
            {
                double dx = w.CampX - X;
                double dy = w.CampY - Y;
                double d = dx * dx + dy * dy;

                if (d < best)
                {
                    best = d;
                    found = w;
                }
            }

            return best < 4000.0 * 4000.0;
        }

        public override bool AddToWorld()
        {
            if (!base.AddToWorld())
                return false;

            if (Nearest(out Way w))
                GuildName = "Return to " + w.Keep;

            return true;
        }

        public override bool Interact(GamePlayer player)
        {
            if (!base.Interact(player))
                return false;

            if (!Nearest(out Way w))
                return false;

            if (player.InCombat)
            {
                player.Out.SendMessage("You cannot cross while you are fighting.",
                                       eChatType.CT_System, eChatLoc.CL_SystemWindow);
                return true;
            }

            player.Out.SendMessage("The stone takes you back to " + w.Keep + ".",
                                   eChatType.CT_System, eChatLoc.CL_SystemWindow);
            player.MoveTo(w.Region, w.ToX, w.ToY, w.ToZ, w.ToHeading);

            foreach (GameMercenary hire in MercenaryManager.GetCompany(player))
            {
                if (hire != null && hire.IsAlive)
                    hire.MoveTo(w.Region, w.ToX + Util.Random(-250, 250),
                                w.ToY + Util.Random(-250, 250), w.ToZ, w.ToHeading);
            }

            return true;
        }
    }
}
