using System;
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
            NameTheBoss();
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
