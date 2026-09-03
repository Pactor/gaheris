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
        public GaherisTaskDungeonMission(object owner,
                                         eDungeonType dungeonType = eDungeonType.Ranged)
            : base(owner, dungeonType)
        {
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
                if (killed.Target.Name == BossName)
                    FinishMission();

                return;
            }

            // The one that just died is already dead by the time this runs, so
            // it is not in the count.
            if (Remaining() == 0)
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
                        return "Kill " + BossName + " in " + TaskRegion.Description + ".";

                    case eTDMissionType.Specific:
                    {
                        int left = Remaining();
                        return "Kill the " + TargetName + " in " + TaskRegion.Description +
                               ". " + left + (left == 1 ? " left." : " left.");
                    }

                    case eTDMissionType.Clear:
                    {
                        int left = Remaining();
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
