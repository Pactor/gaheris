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
            "Shrouded Isles", "Atlantis", "Battlegrounds", "Dungeons", "Elsewhere",
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


        /// <summary>
        /// Which heading a destination belongs under.
        ///
        /// This used to read the realm off the zone, which sounds right and is
        /// useless: `zones.Realm` is ZERO for every region in this database --
        /// Albion, Midgard, Hibernia, the Shrouded Isles, all of it. So every
        /// realm resolved to "Elsewhere" and eighty-five of the hundred and
        /// forty-two destinations landed under one heading, in a single
        /// undifferentiated wall of names. There was no Albion heading, no
        /// Midgard, no Hibernia. The catalogue was complete and unusable.
        ///
        /// Region numbering is the reliable answer, because the game assigns
        /// it: Albion below 100, Midgard below 200, Hibernia below 300. The
        /// special cases come first, since a battleground sits inside
        /// Hibernia's numeric range and the Shrouded Isles sit across all
        /// three.
        /// </summary>
        private static string FamilyOf(ushort region, string name)
        {
            // Grouped by region number, deliberately.
            //
            // The obvious implementation reads zones.Realm -- except that
            // column is 0 for every row in this database, so every
            // destination came out under one heading. The region id is the
            // thing that is actually populated, so the region id is what we
            // group on. Every case below is a region that really appears in
            // the catalogue; verified against the regions table.
            switch (region)
            {
                case 10:                     // Camelot City
                case 101:                    // Jordheim
                case 201:                    // Tir na Nog
                case 360:                    // King Eirik's Throne Room
                case 394:                    // King Constantine's Throne Room
                case 395: return "Cities";   // King Lamfhotas' Throne Room

                case 50:                     // Avalon City
                case 51:                     // Avalon
                case 150:                    // Trollheim
                case 151:                    // Aegir
                case 180:                    // Fomor City
                case 181: return "Shrouded Isles";   // HyBrasil

                case 30: case 45: case 46: case 47:
                case 70: case 71: case 72:
                case 73:                     // Oceanus
                case 88:                     // The Great Pyramid
                case 89:
                case 90:                     // Aerus City
                case 93:                     // Shar Labyrinth
                case 130: case 145: case 146: case 147:
                    return "Atlantis";

                case 165:                    // Cathal Valley
                case 234: case 235: case 236: case 237: case 238: case 239:
                case 240:                    // Wilton
                case 241:                    // Molvik
                case 242:                    // Leirvik
                case 244:                    // Passage of Conflict
                case 250:                    // Caledonia
                case 251:                    // Murdaigean
                case 252:
                case 253:                    // Abermenai
                    return "Battlegrounds";

                case 23: case 24: case 60: case 61: case 65:
                case 125: case 126: case 127: case 128: case 129:
                case 160: case 161: case 190: case 191:
                case 220: case 221: case 222: case 223: case 224:
                case 243: case 246: case 248:
                    return "Dungeons";
            }

            if (region < 100) return "Albion";
            if (region < 200) return "Midgard";
            if (region < 300) return "Hibernia";

            return "Dungeons";
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
