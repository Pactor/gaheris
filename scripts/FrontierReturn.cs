using System;
using DOL.GS.PacketHandler;

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
