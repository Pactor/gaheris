using System;
using DOL.GS.Quests;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// A taskmaster who will actually give you a task.
    ///
    /// The core's TaskMaster refuses everyone:
    ///
    ///     //we need to disable them for players for now
    ///     if (player.Client.Account.PrivLevel == 1)
    ///     {
    ///         SayTo(player, "I'm sorry, Task Dungeons are currently disabled!");
    ///         return true;
    ///     }
    ///
    /// Only a GM has ever been able to take one. That check sits at the top of
    /// Interact, before anything else happens, so a subclass cannot call
    /// through it -- base.Interact would hit the refusal. This is therefore a
    /// copy of the core taskmaster with the gate removed, rather than an
    /// override of it, and it stands on GameNPC directly for the same reason.
    ///
    /// Everything else is the core's, deliberately: the same conversation, the
    /// same two dungeon shapes, the same mission construction. The one change
    /// is that a player can now be given the assignment.
    ///
    /// Long corridors are the ranged dungeons, labyrinths the melee ones --
    /// and note the core's own quirk, kept here: a group always gets the
    /// ranged shape and a solo player always the melee one, whichever they
    /// asked for. The choice reads as flavour rather than as a setting.
    /// </summary>
    public class GaherisTaskMaster : GameNPC
    {
        public override bool Interact(GamePlayer player)
        {
            if (!base.Interact(player))
                return false;

            if (player.Mission == null)
            {
                SayTo(player,
                    "I'm sure you're already aware that the guards protecting our towns often " +
                    "pay bounties to young adventurers willing to help them deal with threats in " +
                    "the area. We've decided to expand upon this idea and begin what we call the " +
                    "Taskmaster program. Volunteers such as myself have been authorized to reward " +
                    "those willing to confront the dangers lurking within our dungeons. If you " +
                    "would like to assist I can give you such an [assignment] right now, and you " +
                    "will be rewarded as soon as you complete it.");
            }
            else
                SayTo(player, "You already have a task that requires completion.");

            return true;
        }

        public override bool WhisperReceive(GameLiving source, string str)
        {
            if (!base.WhisperReceive(source, str))
                return false;

            if (source is not GamePlayer player || player.Mission != null)
                return false;

            switch (str.ToLower())
            {
                case "assignment":
                    SayTo(player,
                        "Based on your prowess and preference in engaging the enemy, I have " +
                        "assignments located in the [labyrinthine dungeons] for close quarter " +
                        "melee and tasks awaiting in [long corridors] for those who prefer ranged " +
                        "attacks. Select which you would prefer and I shall assign a task for you " +
                        "to complete, or if you wish I can go into more detail about the " +
                        "Taskmaster [program].");
                    break;

                case "program":
                    SayTo(player,
                        "Unlike the tasks which you can receive from guards by using /whisper task " +
                        "when speaking to one, the taskmaster program is available to adventurers " +
                        "across a wide range of experience. You'll find taskmasters in many of our " +
                        "towns, ready to offer you the chance to aid the realm by confronting some " +
                        "of the monsters which inhabit a nearby dungeon.");
                    break;

                case "long corridors":
                case "labyrinthine dungeons":
                    GiveTask(player);
                    break;
            }

            return true;
        }

        private void GiveTask(GamePlayer player)
        {
            // Not if the player already has one, and not if the group does --
            // a task belongs to the whole group, so one is one.
            if (player.Mission != null)
                return;

            if (player.Group != null && player.Group.Mission != null)
                return;

            TaskDungeonMission mission;

            if (player.Group != null)
                mission = new TaskDungeonMission(player.Group, TaskDungeonMission.eDungeonType.Ranged);
            else
            {
                mission = new TaskDungeonMission(player, TaskDungeonMission.eDungeonType.Melee);
                player.Mission = mission;
            }

            // An empty dungeon is worse than no task at all: it cannot be
            // finished and it blocks the player from taking another. If the
            // instance came up with nothing to kill, say so and stand down.
            if (mission.TaskRegion == null)
            {
                player.Mission = null;

                if (player.Group != null)
                    player.Group.Mission = null;

                SayTo(player, "The way below is collapsed. Come back another time.");
                return;
            }

            string msg = "Very well " + player.Name +
                         ", it's good to see adventurers willing to help out the realm in such times.";

            switch (mission.TDMissionType)
            {
                case TaskDungeonMission.eTDMissionType.Clear:
                    msg += " Clear " + mission.TaskRegion.Description + " of creatures. Good luck!";
                    break;
                case TaskDungeonMission.eTDMissionType.Boss:
                    msg += " " + mission.BossName + " has taken over " +
                           mission.TaskRegion.Description + " and needs to be disposed of. Good luck!";
                    break;
                case TaskDungeonMission.eTDMissionType.Specific:
                    msg += " Please remove " + mission.Total + " " + mission.TargetName +
                           " from " + mission.TaskRegion.Description + "! The entrance is nearby.";
                    break;
            }

            SayTo(player, msg);
        }
    }
}
