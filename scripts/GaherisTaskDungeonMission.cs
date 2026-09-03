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

        /// <summary>Beyond this from every trail point, a creature is unreachable.</summary>
        private const int STRANDED = 2500;

        private ECSGameTimer _tidy;

        private void WatchTheTrail()
        {
            if (TaskRegion == null || m_owner is not GamePlayer owner)
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
                MoveTheStranded(inside);
            }
            catch (Exception)
            {
                // A dungeon that will not tidy itself is still playable.
            }

            return 5000;
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

                if (!known)
                    _trail.Add(new Point3D(p.X, p.Y, p.Z));
            }
        }

        /// <summary>
        /// Bring one stranded creature at a time onto ground somebody has
        /// walked, out of sight and not on top of anybody. One at a time
        /// because a dungeon that rearranges itself wholesale in front of you
        /// is worse than one with a few creatures missing.
        /// </summary>
        private void MoveTheStranded(List<GamePlayer> inside)
        {
            if (_trail.Count < 3)
                return;

            foreach (GameObject obj in TaskRegion.Objects)
            {
                if (obj is not GameNPC npc || !npc.IsAlive)
                    continue;

                if (npc is GameMercenary || npc.Brain is IControlledBrain)
                    continue;

                if (npc.InCombat || npc.IsVisibleToPlayers)
                    continue;

                int nearest = int.MaxValue;

                foreach (Point3D seen in _trail)
                    nearest = Math.Min(nearest, seen.GetDistanceTo(npc));

                if (nearest <= STRANDED)
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
            if (TaskRegion == null || string.IsNullOrEmpty(BossName))
                return;

            foreach (GameObject obj in TaskRegion.Objects)
            {
                if (obj is not GameNPC npc || npc.Name != BossName)
                    continue;

                if (TDMissionType == eTDMissionType.Boss)
                {
                    m_boss = npc;
                    m_bossTitle = FIRST_NAMES[Util.Random(FIRST_NAMES.Length - 1)] + " " +
                                  TITLES[Util.Random(TITLES.Length - 1)];
                    npc.Name = m_bossTitle;
                    npc.GuildName = BossName;
                }
                else
                {
                    // No named creature on a clear or a count -- there was
                    // never one on live, and a name standing in the dungeon
                    // reads as a task you have not been given. He goes back to
                    // being an ordinary big one of whatever he was made from,
                    // which the template keeps in its guild line for exactly
                    // this. He still counts towards the clear.
                    if (!string.IsNullOrEmpty(npc.GuildName))
                    {
                        npc.Name = npc.GuildName;
                        npc.GuildName = string.Empty;
                    }
                }

                break;
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
