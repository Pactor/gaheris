using System;
using DOL.GS.PacketHandler;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// The portal inside a border keep that sends you to New Frontiers.
    ///
    /// This is how it always worked: you opened the first door, ran in, and
    /// ported. The border keeps are the staging posts and the portal inside
    /// each one is the way across -- you never walked into the frontier.
    ///
    /// It has to be a portal rather than a door or a boundary, because the
    /// old frontier zones are part of the realm regions. Castle Sauvage
    /// physically stands in Forest Sauvage, region 1, so stepping out of its
    /// gate is a walk across Albion and there is no crossing to intercept.
    /// New Frontiers is region 163 and the only way into another region is to
    /// be sent there.
    ///
    /// Each portal knows its own destination from where it stands, so the six
    /// of them need no configuration beyond being placed:
    ///
    ///     Castle Sauvage      -> Forest Sauvage Entrance
    ///     Snowdonia Fortress  -> Snowdonia Entrance
    ///     Svasud Faste        -> Uppland Entrance
    ///     Vindsaul Faste      -> Yggdra Forest Entrance
    ///     Druim Ligen         -> Cruachan Gorge Entrance
    ///     Druim Cain          -> Mount Collory Entrance
    ///
    /// Those are the small arrival camps, which sit on the coordinates the
    /// game's own crossings already target -- known-good ground, and each has
    /// a hastener waiting.
    /// </summary>
    public class FrontierPortal : GameNPC
    {
        /// <summary>Region the frontier lives in.</summary>
        private const ushort FRONTIER = 163;

        /// <summary>A border keep and the arrival camp it opens onto.</summary>
        private readonly struct Crossing
        {
            public readonly ushort Region;
            public readonly int KeepX, KeepY;
            public readonly int ToX, ToY, ToZ;
            public readonly ushort ToHeading;
            public readonly string From, To;

            public Crossing(ushort region, int keepX, int keepY,
                            int toX, int toY, int toZ, ushort toHeading,
                            string from, string to)
            {
                Region = region; KeepX = keepX; KeepY = keepY;
                ToX = toX; ToY = toY; ToZ = toZ; ToHeading = toHeading;
                From = from; To = to;
            }
        }

        private static readonly Crossing[] Crossings =
        {
            new(1,   584151, 477177, 653995, 615343, 9411, 2000,
                "Castle Sauvage",     "Forest Sauvage"),
            new(1,   515959, 372539, 615354, 677360, 9372, 1648,
                "Snowdonia Fortress", "Snowdonia"),
            new(100, 765518, 673661, 649670, 313898, 8797, 1006,
                "Svasud Faste",       "Uppland"),
            new(100, 704110, 738883, 714416, 366163, 9096,  268,
                "Vindsaul Faste",     "Yggdra Forest"),
            new(200, 334435, 419941, 396089, 616403, 9232, 1966,
                "Druim Ligen",        "Cruachan Gorge"),
            new(200, 421156, 486429, 433899, 678939, 9314, 2500,
                "Druim Cain",         "Mount Collory"),
        };

        /// <summary>
        /// Which crossing this portal is standing in, by proximity. Nothing to
        /// configure per portal: place it in a border keep and it knows.
        /// </summary>
        private bool Nearest(out Crossing found)
        {
            found = default;
            double best = double.MaxValue;

            foreach (Crossing c in Crossings)
            {
                if (c.Region != CurrentRegionID)
                    continue;

                double dx = c.KeepX - X;
                double dy = c.KeepY - Y;
                double dist = dx * dx + dy * dy;

                if (dist < best)
                {
                    best = dist;
                    found = c;
                }
            }

            // Roughly a keep's width. Beyond that it is not in a border keep
            // and should not be claiming to be a way across.
            return best < 8000.0 * 8000.0;
        }

        public override bool AddToWorld()
        {
            if (!base.AddToWorld())
                return false;

            if (Nearest(out Crossing c))
                GuildName = "Gateway to " + c.To;

            return true;
        }

        public override bool Interact(GamePlayer player)
        {
            if (!base.Interact(player))
                return false;

            if (!Nearest(out Crossing c))
            {
                player.Out.SendMessage(
                    "This gateway is not anchored to anywhere.",
                    eChatType.CT_System, eChatLoc.CL_PopupWindow);
                return false;
            }

            if (player.InCombat)
            {
                player.Out.SendMessage(
                    "You cannot step through while you are fighting.",
                    eChatType.CT_System, eChatLoc.CL_PopupWindow);
                return false;
            }

            player.Out.SendMessage(
                "The air folds, and " + c.To + " opens in front of you.",
                eChatType.CT_System, eChatLoc.CL_PopupWindow);

            player.MoveTo(FRONTIER, c.ToX, c.ToY, c.ToZ, c.ToHeading);

            // The group came to the frontier together or not at all. Anyone
            // hired walks through with their employer rather than being left
            // standing in the keep.
            foreach (GameMercenary hire in MercenaryManager.GetCompany(player))
            {
                if (hire != null && hire.IsAlive)
                    hire.MoveTo(FRONTIER, c.ToX + Util.Random(-200, 200),
                                c.ToY + Util.Random(-200, 200), c.ToZ, c.ToHeading);
            }

            return true;
        }
    }
}
