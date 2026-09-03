using System.Collections.Generic;
using DOL.GS.PacketHandler;
using DOL.GS.Quests;

namespace DOL.GS.Commands
{
    /// <summary>
    /// /task -- what the taskmaster sent you to do.
    ///
    /// The core's version does not answer this, and never did. It reads
    /// `player.GameTask`, the old kill-ten-rats system handed out by guards
    /// and merchants, which has nothing to do with `player.Mission`. So a
    /// player holding a perfectly live task dungeon mission is told
    ///
    ///     You have currently no pending task
    ///
    /// which is true of the thing it looked at and useless to the person
    /// reading it -- and the mission text goes past in the chat window far too
    /// fast to catch the name of the creature you were sent to kill.
    ///
    /// This replaces it rather than sitting alongside it. ScriptMgr.LoadCommands
    /// walks GameServerScripts, which is the compiled scripts followed by the
    /// core assembly, and suppresses any command whose name is already taken --
    /// so the first registration wins and a script gets there first.
    ///
    /// Both systems are reported, mission first, since the guard tasks still
    /// exist and /task is still where somebody would look for them.
    /// </summary>
    [CmdAttribute("&task", new string[] { "&mission" }, ePrivLevel.Player,
        "Show the task or mission you are on", "/task")]
    public class GaherisTaskCommandHandler : AbstractCommandHandler, ICommandHandler
    {
        public void OnCommand(GameClient client, string[] args)
        {
            if (IsSpammingCommand(client.Player, "task"))
                return;

            GamePlayer player = client.Player;

            if (player == null)
                return;

            if (args.Length > 1 && args[1].ToLower() == "abort")
            {
                if (player.GameTask != null && player.GameTask.TaskActive)
                    player.GameTask.ExpireTask();

                return;
            }

            List<string> lines = new();

            // A mission taken while grouped belongs to the group rather than
            // to any one member, so the group's comes first.
            AbstractMission mission = player.Group?.Mission ?? player.Mission;

            if (mission != null)
            {
                lines.Add("You are on " + mission.Name + ".");
                lines.Add(" ");
                lines.Add(mission.Description);

                if (mission is TaskDungeonMission dungeon && dungeon.TaskRegion != null)
                {
                    lines.Add(" ");
                    lines.Add("Dungeon: " + dungeon.TaskRegion.Description);
                    lines.Add(player.CurrentRegion == dungeon.TaskRegion
                        ? "You are inside it."
                        : "You have left it, so this is no longer in hand.");
                }
            }

            if (player.GameTask != null)
                player.GameTask.CheckTaskExpired();

            AbstractTask task = player.GameTask;

            if (task != null && task.TaskActive)
            {
                if (lines.Count > 0)
                    lines.Add(" ");

                lines.Add("You are also on " + task.Name + ".");
                lines.Add("What to do: " + task.Description);
                lines.Add("It expires at " + task.TimeOut.ToShortTimeString() + ".");
                lines.Add("You have done " + task.TasksDone + " tasks out of " +
                          AbstractTask.MaxTasksDone(player.Level) + " so far.");
            }
            else if (lines.Count == 0 && task != null &&
                     task.TasksDone >= AbstractTask.MaxTasksDone(player.Level))
            {
                player.Out.SendMessage("You can do no more tasks at your current level.",
                    eChatType.CT_System, eChatLoc.CL_SystemWindow);
                return;
            }

            if (lines.Count == 0)
            {
                player.Out.SendMessage(
                    "You have no task. A taskmaster can give you one.",
                    eChatType.CT_System, eChatLoc.CL_SystemWindow);
                return;
            }

            player.Out.SendCustomTextWindow("Task", lines);
        }
    }
}
