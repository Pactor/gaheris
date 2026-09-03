using System;
using DOL.GS.PacketHandler;
using DOL.GS.Quests;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// A taskmaster who gives you a task and takes you there.
    ///
    /// Two departures from the core, both forced by what is actually possible
    /// here rather than by preference.
    ///
    /// The first is that it works at all. The core's TaskMaster refuses every
    /// player outright --
    ///
    ///     //we need to disable them for players for now
    ///     if (player.Client.Account.PrivLevel == 1)
    ///
    /// -- and that check sits above everything else in Interact, so a subclass
    /// cannot call through it. This is a copy with the gate removed rather
    /// than an override, and stands on GameNPC for the same reason.
    ///
    /// The second is that the taskmaster does the travelling. A task dungeon
    /// entrance is a hole in the landscape: the server holds only a zonepoint
    /// and the cave mouth is client terrain. It is in no database -- every
    /// coordinate-bearing table in the reference dump was searched within 700
    /// units of all fifteen known dungeon locations and there is nothing at
    /// any of them -- and a marker cannot be built either, because the models
    /// that look like a cave are static item models and do not render on an
    /// NPC. So rather than send people to hunt for a hole that may no longer
    /// be drawn, the taskmaster opens the way itself.
    ///
    /// That also makes it possible to drop a task you do not want, which
    /// matters more when the entrance is a person rather than a place you can
    /// walk away from.
    ///
    /// Leaving the dungeon still ends the task, and so does dying, since
    /// releasing takes you out of the instance. That is how it worked on live
    /// and it is left alone.
    /// </summary>
    public class GaherisTaskMaster : GameNPC
    {
        public override bool Interact(GamePlayer player)
        {
            if (!base.Interact(player))
                return false;

            if (Task(player) != null)
            {
                SayTo(player,
                    "You already have a task underway. I can remind you what the [task] is, " +
                    "[send] you to it, or [abandon] it and find you another.");
                return true;
            }

            SayTo(player,
                "I'm sure you're already aware that the guards protecting our towns often pay " +
                "bounties to young adventurers willing to help them deal with threats in the " +
                "area. We've decided to expand upon this idea and begin what we call the " +
                "Taskmaster program. Volunteers such as myself have been authorized to reward " +
                "those willing to confront the dangers lurking within our dungeons. If you would " +
                "like to assist I can give you such an [assignment] right now, and you will be " +
                "rewarded as soon as you complete it.");

            return true;
        }

        public override bool WhisperReceive(GameLiving source, string str)
        {
            if (!base.WhisperReceive(source, str))
                return false;

            if (source is not GamePlayer player)
                return false;

            switch (str.ToLower())
            {
                case "assignment":
                    if (Task(player) != null)
                        break;

                    SayTo(player,
                        "Based on your prowess and preference in engaging the enemy, I have " +
                        "assignments located in the [labyrinthine dungeons] for close quarter " +
                        "melee and tasks awaiting in [long corridors] for those who prefer " +
                        "ranged attacks. Select which you would prefer, or I can go into more " +
                        "detail about the Taskmaster [program].");
                    break;

                case "program":
                    SayTo(player,
                        "The taskmaster program is open to adventurers of any experience. " +
                        "You'll find us in many of our towns, ready to offer you the chance to " +
                        "aid the realm by confronting the monsters below. I will open the way " +
                        "myself -- the old entrances have long since fallen in.");
                    break;

                case "long corridors":
                case "labyrinthine dungeons":
                    GiveTask(player);
                    break;

                case "send":
                case "enter":
                    Send(player);
                    break;

                case "task":
                case "remind":
                {
                    TaskDungeonMission have = Task(player);

                    if (have == null)
                        SayTo(player, "You have no task. Ask me for an [assignment].");
                    else
                        player.Out.SendMessage(have.Description, eChatType.CT_System,
                                               eChatLoc.CL_PopupWindow);
                    break;
                }

                case "abandon":
                    Abandon(player);
                    break;
            }

            return true;
        }

        /// <summary>
        /// What this task's boss is called. The name is drawn fresh per task,
        /// so it comes off the mission rather than off the template.
        /// </summary>
        private static string Named(TaskDungeonMission mission)
        {
            return mission is GaherisTaskDungeonMission ours ? ours.BossTitle : mission.BossName;
        }

        /// <summary>The task in force for this player, their group's first.</summary>
        private static TaskDungeonMission Task(GamePlayer player)
        {
            if (player.Group?.Mission is TaskDungeonMission shared)
                return shared;

            return player.Mission as TaskDungeonMission;
        }

        private void GiveTask(GamePlayer player)
        {
            if (Task(player) != null)
                return;

            // Ours, not the core's. The core's mission cannot count kills --
            // it indexes an array sized by mob count using the world object id
            // of whatever died, so every kill throws -- and since the mission
            // is built here, the type is ours to choose.
            TaskDungeonMission mission;

            if (player.Group != null)
                mission = new GaherisTaskDungeonMission(player.Group,
                                                        TaskDungeonMission.eDungeonType.Ranged);
            else
            {
                mission = new GaherisTaskDungeonMission(player,
                                                        TaskDungeonMission.eDungeonType.Melee);
                player.Mission = mission;
            }

            // An empty dungeon cannot be finished and blocks the player from
            // taking another, so stand the task down rather than hand it over.
            if (mission.TaskRegion == null)
            {
                player.Mission = null;

                if (player.Group != null)
                    player.Group.Mission = null;

                SayTo(player, "The way below is collapsed. Come back another time.");
                return;
            }

            // Hold the dungeon open a couple of minutes past the last player
            // leaving. An instance is torn down the moment it empties --
            // DestroyWhenEmpty -- and everything still standing inside goes
            // with it, which is what was killing the hired company on the way
            // out: the roster read seven going in and nought coming back. The
            // companions are moved on the region change itself, so a short
            // delay is all it takes for them to survive the trip.
            //
            // The task is a separate matter and still ends when you leave,
            // which is how it worked on live.
            mission.TaskRegion.BeginDelayCloseCountdown(2);

            string msg = "Very well " + player.Name +
                         ", it's good to see adventurers willing to help out the realm in such times.";

            switch (mission.TDMissionType)
            {
                case TaskDungeonMission.eTDMissionType.Clear:
                    msg += " Clear " + mission.TaskRegion.Description + " of creatures.";
                    break;
                case TaskDungeonMission.eTDMissionType.Boss:
                    msg += " " + Named(mission) + " has taken over " +
                           mission.TaskRegion.Description + " and needs to be disposed of.";
                    break;
                case TaskDungeonMission.eTDMissionType.Specific:
                    msg += " Please remove " + mission.Total + " " + mission.TargetName +
                           " from " + mission.TaskRegion.Description + ".";
                    break;
            }

            SayTo(player, msg + " I will open the way now.");

            // Also as a popup, because the chat line scrolls past before it can
            // be read -- the send that follows fills the window immediately.
            // [task] repeats it for anyone who missed it anyway.
            player.Out.SendMessage(mission.Description, eChatType.CT_System,
                                   eChatLoc.CL_PopupWindow);

            Send(player);
        }

        /// <summary>
        /// Put the player -- and anyone they hired -- inside their dungeon.
        ///
        /// The destination is the instance's own entrance, the row loaded out
        /// of instancexelement when the region was built, which is what the
        /// core's jump point handler uses too.
        /// </summary>
        private void Send(GamePlayer player)
        {
            TaskDungeonMission task = Task(player);

            if (task == null)
            {
                SayTo(player, "You have no task to return to. Ask me for an [assignment].");
                return;
            }

            GameLocation inside = task.TaskRegion?.InstanceEntranceLocation;

            if (inside == null)
            {
                SayTo(player, "The way below has closed. Let me [abandon] this and find you another.");
                return;
            }

            if (player.InCombat)
            {
                SayTo(player, "Not while you are fighting.");
                return;
            }

            player.Out.SendMessage("The ground opens, and you climb down into the dark.",
                                   eChatType.CT_System, eChatLoc.CL_SystemWindow);
            player.MoveTo(inside.RegionID, inside.X, inside.Y, inside.Z, inside.Heading);

            foreach (GameMercenary hire in MercenaryManager.GetCompany(player))
            {
                if (hire != null && hire.IsAlive)
                    hire.MoveTo(inside.RegionID,
                                inside.X + Util.Random(-120, 120),
                                inside.Y + Util.Random(-120, 120),
                                inside.Z, inside.Heading);
            }
        }

        /// <summary>
        /// Drop the task. ExpireMission is the core's own way out and clears
        /// the owner properly, whether the task belongs to the player or to
        /// the group.
        /// </summary>
        private void Abandon(GamePlayer player)
        {
            TaskDungeonMission task = Task(player);

            if (task == null)
            {
                SayTo(player, "You have nothing to abandon.");
                return;
            }

            task.ExpireMission();
            SayTo(player, "Consider it forgotten. Ask me for an [assignment] when you want another.");
        }
    }
}
