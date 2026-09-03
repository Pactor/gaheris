using System.Collections.Generic;
using DOL.GS.PacketHandler;
using DOL.GS.Quests;

namespace DOL.GS.Commands
{
    /// <summary>
    /// /mission -- what the taskmaster sent you to do.
    ///
    /// `/task` does not answer this, and never did. It reads `player.GameTask`,
    /// the old kill-ten-rats system handed out by guards and merchants, which
    /// has nothing to do with `player.Mission`. So a player holding a perfectly
    /// live task dungeon mission is told
    ///
    ///     You have currently no pending task
    ///
    /// which is true of the thing it looked at and useless to the person
    /// reading it. `&amp;task` cannot be overridden either -- unlike packet
    /// handlers, the first command registration wins and the core's is already
    /// there -- so this is a second command rather than a replacement.
    ///
    /// It also reports the group's mission, since a task taken while grouped
    /// belongs to the group rather than to any one member.
    /// </summary>
    [CmdAttribute("&mission", ePrivLevel.Player,
        "Show the mission you are on", "/mission")]
    public class MissionCommandHandler : AbstractCommandHandler, ICommandHandler
    {
        public void OnCommand(GameClient client, string[] args)
        {
            if (IsSpammingCommand(client.Player, "mission"))
                return;

            GamePlayer player = client.Player;

            if (player == null)
                return;

            AbstractMission mission = player.Group?.Mission ?? player.Mission;

            if (mission == null)
            {
                player.Out.SendMessage(
                    "You are not on a mission. A taskmaster can give you one.",
                    eChatType.CT_System, eChatLoc.CL_SystemWindow);
                return;
            }

            List<string> lines = new()
            {
                "You are on " + mission.Name + ".",
                " ",
                mission.Description,
            };

            if (mission is TaskDungeonMission dungeon && dungeon.TaskRegion != null)
            {
                lines.Add(" ");
                lines.Add("Dungeon: " + dungeon.TaskRegion.Description);
                lines.Add(player.CurrentRegion == dungeon.TaskRegion
                    ? "You are inside it."
                    : "You are not inside it. A taskmaster can [send] you back.");
            }

            player.Out.SendCustomTextWindow("Mission", lines);
        }
    }
}
