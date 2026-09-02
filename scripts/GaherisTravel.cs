using System;
using System.Collections.Generic;
using DOL.Database;
using DOL.GS.PacketHandler;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// Gaheris travel.
    ///
    /// One realm, one teleporter, the whole world on it. On Gaheris there is
    /// nobody to hide the map from, so there is no reason to make you walk to a
    /// particular keep to reach a particular place.
    ///
    /// This used to be a peer network: every warden was both a stop and a
    /// destination, so the list of places you could go was exactly the list of
    /// places somebody had already put a warden. That meant thirty wardens
    /// standing at keeps to make thirty keeps reachable, a menu that was mostly
    /// keep names, and no way at all to offer somewhere that had no warden --
    /// Atlantis included.
    ///
    /// Now the destinations are a catalogue in the teleport table, and a warden
    /// is only somewhere to stand. Adding a destination is one row; it does not
    /// need anybody posted there.
    /// </summary>
    public class GaherisTeleporter : GameNPC
    {
        /// <summary>The Type column that marks a row as ours.</summary>
        public const string CATALOGUE = "gaheris";

        private static readonly List<Stop> _stops = new();
        private static readonly Dictionary<int, string> _families = new();
        private static readonly object _lock = new();
        private static bool _loaded;

        /// <summary>Somewhere you can be sent.</summary>
        public class Stop
        {
            public string Name;
            public ushort Region;
            public int X;
            public int Y;
            public int Z;
            public ushort Heading;
            public string Family;
        }

        /// <summary>Menu order. Where you are most likely to want to go, first.</summary>
        private static readonly string[] Order =
        {
            "Cities", "Albion", "Midgard", "Hibernia",
            "Shrouded Isles", "Atlantis", "Dungeons", "Elsewhere",
        };

        public override bool AddToWorld()
        {
            if (!base.AddToWorld())
                return false;

            Level = 70;
            Flags |= eFlags.PEACE;
            Load();
            return true;
        }

        public override bool Interact(GamePlayer player)
        {
            if (!base.Interact(player))
                return false;

            TurnTo(player, 5000);
            SayTo(player, eChatLoc.CL_PopupWindow, Menu());
            return true;
        }

        public override bool WhisperReceive(GameLiving source, string text)
        {
            if (!base.WhisperReceive(source, text))
                return false;

            if (source is not GamePlayer player)
                return false;

            Stop stop = Find(text);

            if (stop == null)
            {
                SayTo(player, eChatLoc.CL_SystemWindow, "I know nowhere by that name.");
                return true;
            }

            Send(player, stop);
            return true;
        }

        // -------------------------------------------------------------------
        // The catalogue
        // -------------------------------------------------------------------

        /// <summary>
        /// Reads the destinations once, the first time a warden spawns.
        ///
        /// Regions are grouped by the realm their zones belong to rather than
        /// by a list kept here, so a server that adds a zone gets it filed in
        /// the right place without anybody editing this.
        /// </summary>
        private static void Load()
        {
            lock (_lock)
            {
                if (_loaded)
                    return;

                _loaded = true;

                foreach (DbZone zone in DOLDB<DbZone>.SelectAllObjects())
                {
                    if (zone != null && !_families.ContainsKey(zone.RegionID))
                        _families[zone.RegionID] = RealmName(zone.Realm);
                }

                var rows = DOLDB<DbTeleport>.SelectObjects(
                    DB.Column("Type").IsEqualTo(CATALOGUE));

                if (rows == null)
                    return;

                foreach (DbTeleport row in rows)
                {
                    if (row == null || string.IsNullOrWhiteSpace(row.TeleportID))
                        continue;

                    _stops.Add(new Stop
                    {
                        Name = row.TeleportID.Trim(),
                        Region = (ushort) row.RegionID,
                        X = row.X,
                        Y = row.Y,
                        Z = row.Z,
                        Heading = (ushort) row.Heading,
                        Family = FamilyOf((ushort) row.RegionID, row.TeleportID),
                    });
                }

                _stops.Sort((a, b) =>
                {
                    int byFamily = Rank(a.Family).CompareTo(Rank(b.Family));

                    return byFamily != 0
                        ? byFamily
                        : string.Compare(a.Name, b.Name, StringComparison.OrdinalIgnoreCase);
                });
            }
        }

        private static string RealmName(int realm)
        {
            switch (realm)
            {
                case 1:  return "Albion";
                case 2:  return "Midgard";
                case 3:  return "Hibernia";
                default: return "Elsewhere";
            }
        }

        private static string FamilyOf(ushort region, string name)
        {
            switch (region)
            {
                case 10:                     // Camelot
                case 101:                    // Jordheim
                case 201: return "Cities";   // Tir na Nog

                case 30:
                case 73:
                case 130: return "Atlantis";

                case 51:
                case 151:
                case 181: return "Shrouded Isles";
            }

            // A dungeon has no zone realm of its own worth showing under a
            // realm heading, and there are a lot of them.
            if (_families.TryGetValue(region, out string family) && family != "Elsewhere")
                return family;

            return region > 200 ? "Dungeons" : "Elsewhere";
        }

        private static int Rank(string family)
        {
            for (int i = 0; i < Order.Length; i++)
            {
                if (Order[i] == family)
                    return i;
            }

            return Order.Length;
        }

        private string Menu()
        {
            string text = "Anywhere you like. Your company comes with you.\n\n";

            foreach (string family in Order)
            {
                bool wroteHeading = false;

                lock (_lock)
                {
                    foreach (Stop stop in _stops)
                    {
                        if (stop.Family != family)
                            continue;

                        // No point offering to send somebody where they are.
                        if (stop.Region == CurrentRegionID && IsWithinRadius2D(stop, 2000))
                            continue;

                        if (!wroteHeading)
                        {
                            text += family + "\n";
                            wroteHeading = true;
                        }

                        text += "  [" + stop.Name + "]\n";
                    }
                }

                if (wroteHeading)
                    text += "\n";
            }

            return text;
        }

        private bool IsWithinRadius2D(Stop stop, int radius)
        {
            long dx = stop.X - X;
            long dy = stop.Y - Y;
            return dx * dx + dy * dy <= (long) radius * radius;
        }

        private static Stop Find(string name)
        {
            string wanted = name.ToLower().Trim();

            lock (_lock)
            {
                foreach (Stop stop in _stops)
                {
                    if (stop.Name.ToLower() == wanted)
                        return stop;
                }
            }

            return null;
        }

        // -------------------------------------------------------------------
        // Going
        // -------------------------------------------------------------------

        private void Send(GamePlayer player, Stop stop)
        {
            if (!player.IsWithinRadius(this, WorldMgr.INTERACT_DISTANCE))
                return;

            if (player.InCombat)
            {
                SayTo(player, eChatLoc.CL_SystemWindow, "Not while you are fighting.");
                return;
            }

            foreach (GamePlayer nearby in GetPlayersInRadius(WorldMgr.VISIBILITY_DISTANCE))
                nearby.Out.SendSpellCastAnimation(this, 4468, 20);

            // Everything the player brought has to be moved by hand. Their
            // brains stop the moment the player is no longer in sight of them,
            // so anything left behind stays behind for good.
            List<GameNPC> retinue = new();

            foreach (GameMercenary merc in MercenaryManager.GetCompany(player))
                retinue.Add(merc);

            if (player.ControlledBrain?.Body != null)
                retinue.Add(player.ControlledBrain.Body);

            player.MoveTo(stop.Region, stop.X + 80, stop.Y + 80, stop.Z, stop.Heading);

            int spread = 100;

            foreach (GameNPC follower in retinue)
            {
                spread += 50;
                follower.MoveTo(stop.Region, stop.X + spread, stop.Y + spread,
                    stop.Z, stop.Heading);
            }
        }
    }
}
