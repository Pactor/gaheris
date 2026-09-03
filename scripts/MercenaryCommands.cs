using System.Collections.Generic;
using DOL.Database;
using DOL.GS.Commands;
using DOL.GS.PacketHandler;
using DOL.GS.Scripts;

namespace DOL.GS.Commands
{
    /// <summary>
    /// Changes how the group plays, in the field.
    ///
    /// The tactic is the sort of thing you want to switch between one pull and
    /// the next -- area damage on a room full of guards, then pet-tanking on
    /// the lord -- so it has no business being locked behind a walk back to a
    /// recruiter in the city.
    /// </summary>
    [CmdAttribute("&tactic",
        ePrivLevel.Player,
        "How your hired group plays. Takes effect on the next thing they do.",
        "/tactic          - what they are doing now",
        "/tactic balanced - tanks hold the line, healers mend whoever is worst off",
        "/tactic pbaoe    - they stack on you and the casters go in",
        "/tactic focus    - your pet holds everything; nobody taunts, the pet gets healed first",
        "/tactic camp     - hold this ground while you pull to it; turn it off to follow you again",
        "/tactic cc       - turn crowd control on or off")]
    public class TacticCommandHandler : AbstractCommandHandler, ICommandHandler
    {
        public void OnCommand(GameClient client, string[] args)
        {
            GamePlayer player = client.Player;

            if (player == null)
                return;

            if (args.Length < 2)
            {
                Show(player);
                return;
            }

            switch (args[1].ToLower())
            {
                case "balanced":
                    Set(player, Tactic.Balanced,
                        "The line holds, and they mend whoever needs it most.");
                    return;

                case "pbaoe":
                    Set(player, Tactic.PBAoE,
                        "They will stay on top of you and burn everything around you.");
                    return;

                case "camp":
                {
                    // Not a tactic, and listed here anyway.
                    //
                    // A camp can be a point-blank camp, a pet camp or a
                    // single-pull camp -- it says nothing about how the fight
                    // is fought, only that you are staying and the ground is
                    // worth investing in, so it is its own switch rather than a
                    // fourth Tactic. But /tactic is where a player looks for
                    // it, and making them whisper a hire instead was a rule
                    // that existed only because of how this was built.
                    bool camped = !MercenaryManager.IsCamped(player);
                    MercenaryManager.SetCamped(player, camped);

                    player.Out.SendMessage(camped
                        ? "Making camp here. They hold this ground while you pull to it, " +
                          "the fonts go down, and the turret classes plant their fields."
                        : "Breaking camp. They follow you again.",
                        eChatType.CT_System, eChatLoc.CL_SystemWindow);
                    return;
                }

                case "cc":
                case "mez":
                {
                    // Sometimes you want every one of them awake and in a heap.
                    bool on = !MercenaryManager.GetCrowdControl(player);
                    MercenaryManager.SetCrowdControl(player, on);
                    player.Out.SendMessage(on
                        ? "Your group will mesmerise loose adds."
                        : "No mez. Everything comes at once.",
                        eChatType.CT_Important, eChatLoc.CL_SystemWindow);
                    return;
                }

                case "focus":
                    Set(player, Tactic.Focus,
                        "Your pet holds them. Nobody touches a taunt, and the pet gets the " +
                        "healing first -- keep your shield up and let it work.");
                    return;

                default:
                    Show(player);
                    return;
            }
        }

        private void Set(GamePlayer player, Tactic tactic, string acknowledgement)
        {
            MercenaryManager.SetTactic(player, tactic);

            player.Out.SendMessage(acknowledgement, eChatType.CT_Important, eChatLoc.CL_SystemWindow);
            player.Out.SendMessage("(/tactic is now " + tactic + ")",
                eChatType.CT_System, eChatLoc.CL_SystemWindow);
        }

        private void Show(GamePlayer player)
        {
            player.Out.SendMessage(
                "Your group is playing " + MercenaryManager.GetTactic(player) + ".",
                eChatType.CT_System, eChatLoc.CL_SystemWindow);
            player.Out.SendMessage(
                "Crowd control is " + (MercenaryManager.GetCrowdControl(player) ? "on" : "off") + ".",
                eChatType.CT_System, eChatLoc.CL_SystemWindow);
            player.Out.SendMessage(
                "/tactic balanced | pbaoe | focus | cc",
                eChatType.CT_System, eChatLoc.CL_SystemWindow);
        }
    }

    /// <summary>
    /// Accounts for every piece of gear the group is holding.
    ///
    /// This exists because that gear is the player's own, earned the hard way,
    /// and "trust me, it is in there somewhere" is not good enough. It reads
    /// the database directly rather than the hires standing in front of you,
    /// so it also finds anything parked under a class that is not currently
    /// hired -- or under one the roster no longer has at all.
    /// </summary>
    [CmdAttribute("&mercgear",
        ePrivLevel.Player,
        "Accounts for every piece of gear your hired group is holding.",
        "/mercgear")]
    public class MercGearCommandHandler : AbstractCommandHandler, ICommandHandler
    {
        public void OnCommand(GameClient client, string[] args)
        {
            GamePlayer player = client.Player;

            if (player == null)
                return;

            var stored = DOLDB<DbInventoryItem>.SelectObjects(
                DB.Column("OwnerID").IsLike(player.InternalID + "-merc-%"));

            if (stored == null || stored.Count == 0)
            {
                DisplayMessage(client, "Your group is holding nothing of yours.");
                return;
            }

            SortedDictionary<string, List<string>> byHolder = new();

            foreach (DbInventoryItem item in stored)
            {
                string holder = item.OwnerID.Substring(item.OwnerID.IndexOf("-merc-") + 6);

                if (!byHolder.TryGetValue(holder, out List<string> carried))
                {
                    carried = new List<string>();
                    byHolder[holder] = carried;
                }

                carried.Add("    " + MercenaryGear.SlotName((eInventorySlot) item.SlotPosition) +
                            ": " + item.Name);
            }

            DisplayMessage(client, "Your group is holding " + stored.Count + " of your items.");

            foreach (var pair in byHolder)
            {
                bool hired = MercenaryManager.Roster.ContainsKey(pair.Key);

                DisplayMessage(client, "  " + pair.Key + (hired ? string.Empty : " (no longer a class)") +
                                       " -- " + pair.Value.Count);

                foreach (string line in pair.Value)
                    DisplayMessage(client, line);
            }

            DisplayMessage(client, "Any recruiter will hand all of it back: say [recover].");
        }
    }

    /// <summary>
    /// Reports what every hire is doing and why.
    ///
    /// Written because "they are not coming back" had been diagnosed wrong
    /// three times running, each costing a restart and a test. The brain now
    /// records the branch it took, so the reason can be read instead.
    /// </summary>
    [CmdAttribute("&mercwatch",
        ePrivLevel.Player,
        "Shows what each of your hired group is doing, and why.",
        "/mercwatch")]
    public class MercWatchCommandHandler : AbstractCommandHandler, ICommandHandler
    {
        private static readonly DOL.Logging.Logger log =
            DOL.Logging.LoggerManager.Create(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        /// <summary>
        /// The target AND whether it is still worth attacking -- alive, dead,
        /// and how far off. Without that there is no telling whether a hire is
        /// mid-fight or stuck swinging at a corpse, which is the difference
        /// between two completely different bugs.
        /// </summary>
        private static string TargetState(GameMercenary merc)
        {
            if (merc.TargetObject is not GameLiving target)
                return "none";

            return target.Name +
                   (target.IsAlive ? " (alive " + target.HealthPercent + "%" : " (DEAD") +
                   ", " + merc.GetDistanceTo(target) + "u)";
        }

        public void OnCommand(GameClient client, string[] args)
        {
            GamePlayer player = client.Player;

            if (player == null)
                return;

            List<GameMercenary> company = MercenaryManager.GetCompany(player);

            if (company.Count == 0)
            {
                DisplayMessage(client, "You have nobody with you.");
                log.Info("MERCWATCH ===== " + player.Name + " | no company");
                return;
            }

            string header = "You are " +
                (player.InCombat ? "in combat" : "out of combat") +
                (player.IsCasting ? ", casting" : string.Empty) +
                ". Target: " + (player.TargetObject?.Name ?? "none");

            log.Info("MERCWATCH ===== " + player.Name + " | " + header);

            foreach (GameMercenary merc in company)
            {
                string line = string.Format(
                    "{0} (lvl {1}) {2}u -- {3}",
                    merc.Name, merc.Level, merc.GetDistanceTo(player), merc.LastAction);

                // The chat window is unreadable at that size, and the point
                // of this is that somebody else reads it. Log only.

                string detail = "    " +
                    (merc.IsAlive ? "alive" : "DEAD") +
                    (merc.IsCasting ? ", casting" : string.Empty) +
                    (merc.attackComponent.AttackState ? ", swinging" : string.Empty) +
                    (merc.InCombat ? ", in combat" : string.Empty) +
                    ", target " + TargetState(merc) +
                    ", knows " + merc.Kit.Known.Count + " spells / " + merc.Kit.Styles.Count + " styles" +
                    ", maintains " + merc.Kit.Maintained.Count;

                // Also to the server log, so the snapshot can be read straight
                // off the host instead of being copied out of a chat window.
                log.Info("MERCWATCH " + line + " | " + detail.Trim());
            }

            DisplayMessage(client, "Snapshot written for " + company.Count + ".");
        }
    }
}
