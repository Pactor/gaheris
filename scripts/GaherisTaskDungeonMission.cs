using System;
using System.Collections.Generic;
using DOL.AI.Brain;
using DOL.Events;
using DOL.GS.Quests;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// A task dungeon mission that counts what you kill.
    ///
    /// The core's does not, and cannot. It tracks which creatures are dead in
    /// an array sized by how many there are:
    ///
    ///     m_mobIsAlive = new bool[m_total];            // fourteen, say
    ///
    /// and then indexes that array by the world object id of whatever died:
    ///
    ///     if (m_mobIsAlive[eargs.Target.ObjectID - 1])
    ///
    /// An object id is the region's own numbering -- hundreds or thousands --
    /// so every kill reaches past the end of the array and throws. Worse,
    /// GamePlayer.Notify calls Mission.Notify with no try/catch around it, so
    /// that exception escapes into the kill handler itself on every single kill
    /// inside a task dungeon. Nothing counted, and the damage did not stop
    /// there.
    ///
    /// This replaces the counting rather than patching it. Neither m_current
    /// nor m_total can be reached from a subclass -- both are private with
    /// getters only -- so instead of bookkeeping we simply look: after each
    /// kill, ask the instance what is still standing. That cannot drift out of
    /// step with the dungeon the way a tally can, and it needs no array at all.
    ///
    /// Description is overridden for the same reason, since the core's reports
    /// progress from the counter this never touches.
    /// </summary>
    public class GaherisTaskDungeonMission : TaskDungeonMission
    {
        private static readonly string[] FIRST_NAMES =
        {
            "Aggrash", "Balgar", "Corvus", "Drenn", "Ergoth", "Fangred",
            "Grimwold", "Hagreth", "Ilvarn", "Jorund", "Kaggath", "Lorgan",
            "Malreth", "Nurgal", "Orvath", "Pyrran", "Rhugard", "Skarn",
            "Torvald", "Ulgrim", "Vorgath", "Wregan", "Xanthos", "Zorath",
        };

        private static readonly string[] TITLES =
        {
            "the Ravener", "the Gorged", "the Unhallowed", "the Deep Warden",
            "the Blighted", "the Hollow", "the Toothed", "the Sunless",
            "the Cairnbreaker", "the Slow Death", "the Marrowlord", "the Rotcrown",
        };

        /// <summary>The boss himself, remembered rather than looked up by name.</summary>
        private GameNPC m_boss;

        /// <summary>What he is called this time.</summary>
        private string m_bossTitle;

        public GaherisTaskDungeonMission(object owner,
                                         eDungeonType dungeonType = eDungeonType.Ranged)
            : base(owner, dungeonType)
        {
            SealTheDungeon();
            NameTheBoss();
            WatchTheTrail();
        }

        /// <summary>
        /// Stop the dungeon refilling behind you.
        ///
        /// A task dungeon is cleared once. Its creatures are built by
        /// Instance.LoadFromDatabase as plain GameNPCs, which leaves
        /// m_respawnInterval at nought -- and nought is not "never", it is
        /// "work one out":
        ///
        ///     if (m_respawnInterval > 0 || m_respawnInterval < 0)
        ///         return m_respawnInterval;
        ///     int minutes = Util.Random(NPC_MIN_RESPAWN_INTERVAL, ...);
        ///
        /// So every creature came back a few minutes after it died and the
        /// count stuck: kill eleven more and eleven are still left, because
        /// the ones killed first are standing up again behind you. Anything
        /// at or below nought turns the respawn off outright.
        /// </summary>
        // ------------------------------------------------------------------
        // Where the dungeon actually is
        // ------------------------------------------------------------------

        /// <summary>
        /// Ground a player has stood on inside this instance.
        ///
        /// The creatures in these dungeons are placed around the entrance
        /// recorded in instancexelement, because that coordinate is the only
        /// one anybody has. Walking one shows that it is not where a player
        /// ends up: standing in a task dungeon, the nearest entrance in the
        /// whole table was ten thousand units away. Every creature is laid out
        /// within four thousand of it, so most of the dungeon is populated in
        /// places nobody can reach, and a clear task strands on the last
        /// twenty-odd that were never standing anywhere real.
        ///
        /// No amount of refining that guess fixes it, because the coordinate
        /// it is built on does not describe the playable space. What does
        /// describe the playable space is a player walking through it: every
        /// position anybody occupies inside the instance is, by definition,
        /// ground that can be stood on and reached.
        ///
        /// So the dungeon is laid out from the trail rather than from the
        /// door. Creatures nobody can get to are moved, quietly and out of
        /// sight, onto ground somebody has already covered. The dungeon fills
        /// in behind the player as it is explored, and a clear can always be
        /// finished because everything left is somewhere a player has been.
        /// </summary>
        private readonly List<Point3D> _trail = new();

        /// <summary>Far enough apart to be worth remembering separately.</summary>
        private const int TRAIL_SPACING = 400;

        /// <summary>Never move something onto a player's lap.</summary>
        private const int NOT_ON_TOP_OF = 900;

        /// <summary>
        /// Close enough to count as having been met.
        ///
        /// Straight-line distance from the trail was the wrong test and failed
        /// for the same reason every earlier attempt did: it measures geometry
        /// on a map whose geometry we do not have. In a dungeon of corridors a
        /// creature sealed behind rock is fifteen hundred units from the path
        /// and completely unreachable, so it never qualified as stranded and
        /// was never moved. Walking the whole western arm changed nothing --
        /// the count sat at twenty-four the entire way.
        ///
        /// Whether a player has ever come near it is not a guess about the
        /// map. It is a fact about what happened.
        ///
        /// Five hundred rather than a thousand, because a thousand still
        /// reaches through a wall in a corridor dungeon and counted creatures
        /// as met that were never reachable. Five hundred is about the range
        /// at which something would have noticed you and come.
        /// </summary>
        private const int MET = 500;

        /// <summary>Wait until there is a real trail before moving anything.</summary>
        private const int TRAIL_BEFORE_MOVING = 5;

        /// <summary>How many to rescue per tick.</summary>
        private const int PER_TICK = 6;

        /// <summary>Everything a player has been near, and so had the chance to fight.</summary>
        private readonly HashSet<GameNPC> _met = new();

        private ECSGameTimer _tidy;

        private void WatchTheTrail()
        {
            if (TaskRegion == null)
                return;

            // Start with whatever this dungeon has already been taught. A
            // region walked once before does not need teaching again, and the
            // creatures can be laid out on known ground from the moment the
            // instance is built rather than after somebody has explored it.
            _trail.AddRange(DungeonTrail.Load(TaskRegion.Skin));

            if (_trail.Count > 0)
                Console.WriteLine("Dungeon: region " + TaskRegion.Skin + " remembered from " +
                                  _trail.Count + " known points.");

            // A task taken while grouped belongs to the GROUP, not to the
            // player -- the taskmaster builds it that way, and anyone playing
            // with hired companions is always grouped. Requiring a GamePlayer
            // owner here meant the trail never ran for the only case that
            // actually occurs, and the dungeon stayed as unreachable as it was
            // before any of this was written.
            GamePlayer owner = m_owner as GamePlayer ?? (m_owner as Group)?.Leader;

            if (owner == null)
                return;

            _tidy = new ECSGameTimer(owner, Tidy, 5000);
            _tidy.Start(5000);
        }

        private int Tidy(ECSGameTimer timer)
        {
            try
            {
                if (TaskRegion == null)
                    return 0;

                List<GamePlayer> inside = new();

                foreach (GameObject obj in TaskRegion.Objects)
                {
                    if (obj is GamePlayer p && p.IsAlive &&
                        p.ObjectState == GameObject.eObjectState.Active)
                        inside.Add(p);
                }

                if (inside.Count == 0)
                    return 5000;

                Remember(inside);
                NoteWhoWasMet(inside);
                Report(inside);
                MoveTheStranded(inside);
            }
            catch (Exception)
            {
                // A dungeon that will not tidy itself is still playable.
            }

            return 5000;
        }

        /// <summary>
        /// Say where the nearest living creature is, and by how much.
        ///
        /// "Right in front of me and out of range" is a measurable claim and
        /// worth measuring rather than guessing at twice more. If the flat
        /// distance is small and the height difference is large, everything is
        /// floating above or sunk below the floor and the layout is a height
        /// problem. If both are large, they are simply somewhere else.
        /// </summary>
        private void Report(List<GamePlayer> inside)
        {
            GamePlayer p = inside[0];
            GameNPC nearest = null;
            int best = int.MaxValue;

            foreach (GameObject obj in TaskRegion.Objects)
            {
                if (obj is not GameNPC npc || !npc.IsAlive)
                    continue;

                if (npc is GameMercenary || npc.Brain is IControlledBrain)
                    continue;

                int dx = npc.X - p.X;
                int dy = npc.Y - p.Y;
                int flat = (int) Math.Sqrt((double) dx * dx + (double) dy * dy);

                if (flat < best)
                {
                    best = flat;
                    nearest = npc;
                }
            }

            Console.WriteLine("Dungeon: " + p.Name + " at " + p.X + "," + p.Y + "," + p.Z +
                              " | trail " + _trail.Count +
                              " | alive " + Remaining() +
                              (nearest == null ? " | nothing alive"
                                  : " | nearest " + nearest.Name + " flat " + best +
                                    " height " + (nearest.Z - p.Z) +
                                    " true " + nearest.GetDistanceTo(p)));
        }

        /// <summary>Anything near a player has been met, whether or not it was fought.</summary>
        private void NoteWhoWasMet(List<GamePlayer> inside)
        {
            foreach (GameObject obj in TaskRegion.Objects)
            {
                if (obj is not GameNPC npc || npc is GameMercenary ||
                    npc.Brain is IControlledBrain)
                    continue;

                foreach (GamePlayer p in inside)
                {
                    if (npc.GetDistanceTo(p) <= MET)
                    {
                        _met.Add(npc);
                        break;
                    }
                }
            }
        }

        /// <summary>Add where everybody is standing to the trail.</summary>
        private void Remember(List<GamePlayer> inside)
        {
            foreach (GamePlayer p in inside)
            {
                bool known = false;

                foreach (Point3D seen in _trail)
                {
                    if (seen.GetDistanceTo(p) < TRAIL_SPACING)
                    {
                        known = true;
                        break;
                    }
                }

                if (known)
                    continue;

                _trail.Add(new Point3D(p.X, p.Y, p.Z));
                DungeonTrail.Teach(TaskRegion.Skin, p.X, p.Y, p.Z);
            }
        }

        /// <summary>
        /// Bring stranded creatures onto ground somebody has walked, out of
        /// sight and not on top of anybody.
        ///
        /// A handful per tick rather than one. At one every five seconds a
        /// dungeon with twenty stranded creatures takes two minutes to become
        /// playable, which reads as an empty dungeon for the whole of the
        /// first fight. They are still only moved while nobody can see them,
        /// which is what stops it looking like conjuring.
        /// </summary>
        private void MoveTheStranded(List<GamePlayer> inside)
        {
            if (_trail.Count < TRAIL_BEFORE_MOVING)
                return;

            int moved = 0;

            foreach (GameObject obj in TaskRegion.Objects)
            {
                if (obj is not GameNPC npc || !npc.IsAlive)
                    continue;

                if (npc is GameMercenary || npc.Brain is IControlledBrain)
                    continue;

                if (npc.InCombat || npc.IsVisibleToPlayers)
                    continue;

                // Met means the player had their chance at it. Anything else
                // is somewhere they cannot get to, however near it looks.
                if (_met.Contains(npc))
                    continue;

                Point3D spot = _trail[Util.Random(_trail.Count - 1)];
                bool crowded = false;

                foreach (GamePlayer p in inside)
                {
                    if (spot.GetDistanceTo(p) < NOT_ON_TOP_OF)
                    {
                        crowded = true;
                        break;
                    }
                }

                if (crowded)
                    continue;

                npc.MoveTo(TaskRegion.ID,
                           spot.X + Util.Random(-200, 200),
                           spot.Y + Util.Random(-200, 200),
                           spot.Z, (ushort) Util.Random(4095));

                if (++moved >= PER_TICK)
                    return;
            }
        }

        private void SealTheDungeon()
        {
            if (TaskRegion == null)
                return;

            foreach (GameObject obj in TaskRegion.Objects)
            {
                if (obj is GameNPC npc && npc is not GameMercenary &&
                    npc.Brain is not IControlledBrain)
                    npc.RespawnInterval = -1;
            }
        }

        /// <summary>
        /// Give the dungeon's boss a fresh name for this task.
        ///
        /// The template carries a name so that the core will recognise it as a
        /// boss at all -- it decides that by looking for a capital letter --
        /// but a template is fixed, and the same dungeon would then hand out
        /// the same boss every time. On live the named creature differed from
        /// task to task, so it is renamed here, once, as the mission is built.
        ///
        /// Because the name now moves, the kill is matched on the creature
        /// itself rather than on what it is called.
        /// </summary>
        private void NameTheBoss()
        {
            if (TaskRegion == null)
                return;

            bool wanted = TDMissionType == eTDMissionType.Boss;

            foreach (GameObject obj in TaskRegion.Objects)
            {
                if (obj is not GameNPC npc || npc is GameMercenary ||
                    npc.Brain is IControlledBrain)
                    continue;

                // The core's own test for a named creature, and it has to be
                // done this way round: MySQL compares case-insensitively by
                // default, so asking the database which templates are
                // capitalised answers nought however many there are. There are
                // twenty-nine real ones in these dungeons -- Rat Matriarch,
                // Batty Bill, Archivist Borath -- and they were always being
                // treated as bosses.
                if (npc.Name == npc.Name.ToLower())
                    continue;

                if (wanted && npc.Name == BossName && m_boss == null)
                {
                    m_boss = npc;
                    m_bossTitle = FIRST_NAMES[Util.Random(FIRST_NAMES.Length - 1)] + " " +
                                  TITLES[Util.Random(TITLES.Length - 1)];
                    npc.GuildName = npc.Name;
                    npc.Name = m_bossTitle;
                    continue;
                }

                // Everything else loses its name. A clear or a count has no
                // named creature in it -- one standing there reads as a task
                // you were never given, which is exactly how it read.
                npc.Name = string.IsNullOrEmpty(npc.GuildName)
                    ? npc.Name.ToLower()
                    : npc.GuildName.ToLower();
                npc.GuildName = string.Empty;
            }
        }

        /// <summary>What the player should be told to go and kill.</summary>
        public string BossTitle => m_bossTitle ?? BossName;

        /// <summary>
        /// What is left to kill, as the player should be told it: the margin
        /// is taken off, so the count reaches nought exactly when the mission
        /// completes rather than stopping short of it.
        /// </summary>
        private int Reported()
        {
            return (int) Math.Max(0L, Remaining() - Total / 10);
        }

        /// <summary>
        /// What this mission still needs dead.
        ///
        /// Hired companions and anything summoned are skipped -- a Clear
        /// mission would otherwise never finish while the player still had a
        /// group standing next to them.
        /// </summary>
        private int Remaining()
        {
            if (TaskRegion == null)
                return 0;

            bool named = TDMissionType == eTDMissionType.Specific;
            int alive = 0;

            foreach (GameObject obj in TaskRegion.Objects)
            {
                if (obj is not GameNPC npc || !npc.IsAlive)
                    continue;

                if (npc is GameMercenary || npc.Brain is IControlledBrain)
                    continue;

                if (named && npc.Name != TargetName)
                    continue;

                alive++;
            }

            return alive;
        }

        public override void Notify(DOLEvent e, object sender, EventArgs args)
        {
            // Deliberately never calls base: that is the throw.
            if (e != GameLivingEvent.EnemyKilled)
                return;

            if (args is not EnemyKilledEventArgs killed || killed.Target == null)
                return;

            if (TaskRegion == null || killed.Target.CurrentRegion != TaskRegion)
                return;

            if (TDMissionType == eTDMissionType.Boss)
            {
                // By the creature, not by the name: the name was changed for
                // this task. Falling back to the name covers a boss that was
                // never found at construction.
                if (m_boss != null ? killed.Target == m_boss
                                   : killed.Target.Name == BossName)
                    FinishMission();

                return;
            }

            // The one that just died is already dead by the time this runs, so
            // it is not in the count.
            //
            // A margin rather than the very last kill. These dungeons are
            // populated without any geometry to place against -- we have the
            // entrance and the way it faces and nothing else -- so a few
            // creatures always end up standing inside rock. Demanding every
            // one of them means a clear task that cannot be finished. A tenth
            // is enough to absorb that and still small enough that the
            // dungeon has to be worked through; on a task of under ten it is
            // zero, and those are the named-target tasks where the count is
            // small enough to check by walking.
            if (Remaining() <= Total / 10)
                FinishMission();
            else
                UpdateMission();
        }

        public override string Description
        {
            get
            {
                if (TaskRegion == null)
                    return base.Description;

                switch (TDMissionType)
                {
                    case eTDMissionType.Boss:
                        return "Kill " + BossTitle + " in " + TaskRegion.Description + ".";

                    case eTDMissionType.Specific:
                    {
                        int left = Reported();
                        return "Kill the " + TargetName + " in " + TaskRegion.Description +
                               ". " + left + (left == 1 ? " left." : " left.");
                    }

                    case eTDMissionType.Clear:
                    {
                        int left = Reported();
                        return "Clear " + TaskRegion.Description + ". " + left +
                               (left == 1 ? " creature left." : " creatures left.");
                    }

                    default:
                        return base.Description;
                }
            }
        }
    }
}
