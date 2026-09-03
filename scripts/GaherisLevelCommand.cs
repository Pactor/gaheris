using System.Linq;
using DOL.Database;
using DOL.GS.PacketHandler;

namespace DOL.GS.Commands
{
    /// <summary>
    /// /level, which the core cannot grant.
    ///
    /// OpenDAoC's version reads GamePlayer.CanUseSlashLevel to decide whether
    /// the account has earned it. That property returns m_canUseSlashLevel,
    /// which is declared
    ///
    ///     protected bool m_canUseSlashLevel = false;
    ///
    /// and is never assigned anywhere in the entire codebase. So the check can
    /// only ever fail, and every player is told "You don't have a level 50 on
    /// your account!" no matter how many they have. Turning the command on with
    /// slash_level_target was necessary and not sufficient; the eligibility it
    /// gates on was never computed.
    ///
    /// Script commands are registered before the core ones and the first
    /// registration of a name wins -- ScriptMgr says so in the log when it
    /// suppresses the loser -- so this simply replaces it, keeping every other
    /// rule the original had: the trainer, the Catacombs classes, the target
    /// level, and the refusal once you are past it.
    ///
    /// The eligibility is what it always should have been: does this account
    /// hold a character at the required level.
    /// </summary>
    [CmdAttribute("&level",
        ePrivLevel.Player,
        "Levels you to the server's starting level if your account has earned it",
        "/level")]
    public class GaherisLevelCommandHandler : AbstractCommandHandler, ICommandHandler
    {
        public void OnCommand(GameClient client, string[] args)
        {
            GamePlayer player = client?.Player;

            if (player == null)
                return;

            int target = ServerProperties.Properties.SLASH_LEVEL_TARGET;

            if (target <= 1)
            {
                DisplayMessage(client, "/level is disabled on this server.");
                return;
            }

            if (target is < 1 or > 50)
                target = 20;

            if (player.TargetObject is not GameTrainer)
            {
                player.Out.SendMessage("You need to be at your trainer to use this command.",
                                       eChatType.CT_System, eChatLoc.CL_SystemWindow);
                return;
            }

            if (!ServerProperties.Properties.ALLOW_CATA_SLASH_LEVEL)
            {
                switch ((eCharacterClass) player.CharacterClass.ID)
                {
                    case eCharacterClass.Heretic:
                    case eCharacterClass.Valkyrie:
                    case eCharacterClass.Warlock:
                    case eCharacterClass.Vampiir:
                    case eCharacterClass.Bainshee:
                    case eCharacterClass.MaulerAlb:
                    case eCharacterClass.MaulerHib:
                    case eCharacterClass.MaulerMid:
                        player.Out.SendMessage("Your class cannot use the /level command.",
                                               eChatType.CT_System, eChatLoc.CL_SystemWindow);
                        return;
                }
            }

            int required = ServerProperties.Properties.SLASH_LEVEL_REQUIREMENT;

            if (!HasEarnedIt(player, required))
            {
                player.Out.SendMessage(
                    "You do not have a level " + required + " character on this account.",
                    eChatType.CT_System, eChatLoc.CL_SystemWindow);
                return;
            }

            // target, not target - 1.
            //
            // GetExperienceNeededForLevel already steps back a level itself:
            //
            //     return GetExperienceAmountForLevel(level - 1);
            //
            // so the core's GetExperienceNeededForLevel(target - 1) subtracts
            // one twice and hands over the experience for level 19 while its
            // own message promises 20. Asking for the target gives the target.
            long enough = player.GetExperienceNeededForLevel(target);

            if (player.Experience >= enough)
            {
                player.Out.SendMessage("/level only carries you to " + target + ".",
                                       eChatType.CT_System, eChatLoc.CL_SystemWindow);
                return;
            }

            long owed = enough - player.Experience;

            if (owed < 0)
                owed = 0;

            player.GainExperience(eXPSource.Other, owed);
            player.UsedLevelCommand = true;
            player.SaveIntoDatabase();

            player.Out.SendMessage(
                "You have been granted the experience to reach level " + target +
                ". Right click your trainer to take the levels.",
                eChatType.CT_System, eChatLoc.CL_SystemWindow);
        }

        /// <summary>
        /// Has this account taken a character far enough to have earned it.
        ///
        /// Any realm counts. On a co-operative server the three realms are one
        /// group of friends, and telling somebody their Albion fifty does not
        /// count towards a Midgard alt would be a rule invented for a conflict
        /// this server does not have.
        /// </summary>
        private static bool HasEarnedIt(GamePlayer player, int required)
        {
            if (required <= 0)
                return true;

            if (player.Level >= required)
                return true;

            string account = player.Client?.Account?.Name;

            if (string.IsNullOrEmpty(account))
                return false;

            var characters = DOLDB<DbCoreCharacter>.SelectObjects(
                DB.Column("AccountName").IsEqualTo(account));

            return characters != null && characters.Any(c => c != null && c.Level >= required);
        }
    }
}
