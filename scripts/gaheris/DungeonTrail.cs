using System;
using System.Collections.Generic;
using DOL.Database;
using DOL.Database.Attributes;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// Ground somebody has actually stood on, in a dungeon we have no map of.
    ///
    /// Registered from the scripts directory -- the server reflects over every
    /// assembly at boot and creates the table itself, so this needs no
    /// migration.
    /// </summary>
    [DataTable(TableName = "gaheris_dungeon_trail")]
    public class DbDungeonTrail : DataObject
    {
        private ushort m_skin;
        private int m_x;
        private int m_y;
        private int m_z;

        /// <summary>The template region, not the instance -- instances are numbered per run.</summary>
        [DataElement(AllowDbNull = false, Index = true)]
        public ushort Skin
        {
            get => m_skin;
            set { Dirty = true; m_skin = value; }
        }

        [DataElement(AllowDbNull = false)]
        public int X
        {
            get => m_x;
            set { Dirty = true; m_x = value; }
        }

        [DataElement(AllowDbNull = false)]
        public int Y
        {
            get => m_y;
            set { Dirty = true; m_y = value; }
        }

        [DataElement(AllowDbNull = false)]
        public int Z
        {
            get => m_z;
            set { Dirty = true; m_z = value; }
        }
    }

    /// <summary>
    /// What players have taught the server about a dungeon.
    ///
    /// Each of the 120 task dungeon regions is a map we do not have and never
    /// will. The mission works around that by watching where a player walks
    /// and moving unreachable creatures onto that ground -- but the trail died
    /// with the instance, so every visit began by relearning the same dungeon
    /// from nothing. That is why the first minutes of a run are always sparse:
    /// the server is being taught the floor again by somebody who has already
    /// taught it.
    ///
    /// Kept here instead. The first person to walk a dungeon teaches it
    /// permanently, and every later instance of that region starts knowing
    /// where the floor is. Nothing about the map is inferred -- every point is
    /// somewhere a player stood, which is the only proof of walkable ground
    /// available to us.
    ///
    /// Keyed on the SKIN rather than the instance id, because the instance is
    /// numbered per run while the skin is the dungeon itself.
    /// </summary>
    public static class DungeonTrail
    {
        /// <summary>Enough to lay a dungeon out with; not so many that it is a survey.</summary>
        private const int MAX_PER_DUNGEON = 60;

        /// <summary>Points nearer than this to a known one teach nothing new.</summary>
        private const int SPACING = 400;

        private static readonly Dictionary<ushort, List<Point3D>> _cache = new();
        private static readonly object _lock = new();

        /// <summary>Everything players have shown us of this dungeon.</summary>
        public static List<Point3D> Load(ushort skin)
        {
            lock (_lock)
            {
                if (_cache.TryGetValue(skin, out List<Point3D> known))
                    return new List<Point3D>(known);
            }

            List<Point3D> points = new();

            try
            {
                var rows = DOLDB<DbDungeonTrail>.SelectObjects(
                    DB.Column("Skin").IsEqualTo(skin));

                if (rows != null)
                {
                    foreach (DbDungeonTrail row in rows)
                        points.Add(new Point3D(row.X, row.Y, row.Z));
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("DungeonTrail: could not read skin " + skin + ": " + ex.Message);
            }

            lock (_lock)
                _cache[skin] = new List<Point3D>(points);

            return points;
        }

        /// <summary>
        /// Record a spot, if it says something the dungeon has not already
        /// been taught. Silently does nothing once the dungeon is well enough
        /// known -- sixty points is a layout, and past that we would only be
        /// accumulating a survey nobody reads.
        /// </summary>
        public static void Teach(ushort skin, int x, int y, int z)
        {
            try
            {
                List<Point3D> known = Load(skin);

                if (known.Count >= MAX_PER_DUNGEON)
                    return;

                Point3D spot = new(x, y, z);

                foreach (Point3D seen in known)
                {
                    if (seen.GetDistanceTo(spot) < SPACING)
                        return;
                }

                DbDungeonTrail row = new() { Skin = skin, X = x, Y = y, Z = z };
                GameServer.Database.AddObject(row);

                lock (_lock)
                {
                    if (!_cache.TryGetValue(skin, out List<Point3D> cached))
                    {
                        cached = new List<Point3D>();
                        _cache[skin] = cached;
                    }

                    cached.Add(spot);

                    if (cached.Count == 1)
                        Console.WriteLine("DungeonTrail: learning region " + skin +
                                          " for the first time.");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("DungeonTrail: could not record skin " + skin + ": " + ex.Message);
            }
        }
    }
}
