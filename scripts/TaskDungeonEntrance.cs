using System;
using DOL.GS.PacketHandler;
using DOL.GS.Quests;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// The way into a task dungeon, made visible.
    ///
    /// A task dungeon entrance is a hole in the landscape. The server has only
    /// a zonepoint at the spot, and the cave mouth itself is client terrain --
    /// nothing stands there in our world or in the reference database, which
    /// was checked: not one object or NPC within 900 units of any of the nine
    /// jump points, on either server.
    ///
    /// That is fine if the client still has the hole. If it does not -- and
    /// task dungeons were switched off on live years ago -- then there is
    /// nothing to walk into, the zonepoint can never fire, and the feature is
    /// unreachable however correct the data behind it is.
    ///
    /// So this stands at each jump point and does the same job by hand. It
    /// reads the mission the way the core's own handler does:
    ///
    ///     TaskDungeonMission task = (TaskDungeonMission) player.Mission;
    ///     loc = task.TaskRegion.InstanceEntranceLocation;
    ///
    /// which is the entrance row loaded out of instancexelement when the
    /// instance was built. Group missions come first, exactly as the core
    /// orders it, so a group enters its own dungeon together rather than each
    /// member opening a private one.
    /// </summary>
    public class TaskDungeonEntrance : GameNPC
    {
        public override bool AddToWorld()
        {
            if (!base.AddToWorld())
                return false;

            GuildName = "Task Dungeon";
            return true;
        }

        public override bool Interact(GamePlayer player)
        {
            if (!base.Interact(player))
                return false;

            GameLocation inside = Mouth(player);

            if (inside == null)
            {
                // The core's wording, kept, because it is the message players
                // would have seen walking into the hole.
                player.Out.SendMessage(
                    "You need to have a proper mission before entering this area!",
                    eChatType.CT_System, eChatLoc.CL_SystemWindow);
                return true;
            }

            player.Out.SendMessage("You climb down into the dark.",
                                   eChatType.CT_System, eChatLoc.CL_SystemWindow);
            player.MoveTo(inside.RegionID, inside.X, inside.Y, inside.Z, inside.Heading);

            // Hired companions go down with their employer.
            foreach (GameMercenary hire in MercenaryManager.GetCompany(player))
            {
                if (hire != null && hire.IsAlive)
                    hire.MoveTo(inside.RegionID,
                                inside.X + Util.Random(-120, 120),
                                inside.Y + Util.Random(-120, 120),
                                inside.Z, inside.Heading);
            }

            return true;
        }

        /// <summary>
        /// Where this player's dungeon actually is. The group's mission wins
        /// over a personal one, so a group goes to one dungeon.
        /// </summary>
        private static GameLocation Mouth(GamePlayer player)
        {
            if (player.Group?.Mission is TaskDungeonMission shared)
                return shared.TaskRegion?.InstanceEntranceLocation;

            if (player.Mission is TaskDungeonMission own)
                return own.TaskRegion?.InstanceEntranceLocation;

            return null;
        }
    }
}
