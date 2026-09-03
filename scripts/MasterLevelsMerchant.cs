using System;
using DOL.Database;
using DOL.GS.PacketHandler;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// Demyphon, of the Order of Mysteries -- the Master Level credit merchant.
    ///
    /// Written against OpenDAoC rather than ported. DOLSharp's version derives
    /// from GameBountyMerchant too, but builds its stock through a
    /// MerchantCatalog and a DOL.GS.Profession namespace, neither of which
    /// exists here. Forcing that across would have meant dragging in a whole
    /// merchant subsystem to serve two NPCs.
    ///
    /// It does not need to. Both Demyphons already carry the merchant list
    /// "Master Level Credits", eleven items strong, and OpenDAoC's own
    /// GameMerchant reads that from the database on load. So the stock works
    /// without any of it; what was actually missing was a class by this name
    /// for the mob row to resolve to.
    ///
    /// Bounty points are the currency, which is what GameBountyMerchant is.
    ///
    /// Selling the tokens was only ever half the transaction. You buy a credit
    /// and hand it straight back, and he grants the Master Level it stands for
    /// -- and nothing here did the second half, so a token was bounty points
    /// turned into a piece of inventory that did nothing at all.
    /// </summary>
    public class MasterLevelsMerchant : GameBountyMerchant
    {
        private const string CREDIT = "master_level_credit_bptoken_";
        private const string RESPEC = "master_level_respec_bptoken";

        public override bool Interact(GamePlayer player)
        {
            if (!base.Interact(player))
                return false;

            TurnTo(player, 5000);

            SayTo(player, eChatLoc.CL_ChatWindow,
                "I trade in the credits of the Master Levels. What I have is " +
                "bought with bounty points, and bounty points alone. Buy a " +
                "credit and hand it back to me, and the Master Level it stands " +
                "for is yours.");

            return true;
        }

        public override bool ReceiveItem(GameLiving source, DbInventoryItem item)
        {
            if (source is not GamePlayer player || item?.Id_nb == null)
                return base.ReceiveItem(source, item);

            if (item.Id_nb.StartsWith(CREDIT, StringComparison.OrdinalIgnoreCase))
                return Redeem(player, item);

            if (item.Id_nb.Equals(RESPEC, StringComparison.OrdinalIgnoreCase))
                return Respec(player, item);

            return base.ReceiveItem(source, item);
        }

        /// <summary>
        /// The Star of Destiny: put the choice of discipline back.
        ///
        /// This used to be handed straight back with an apology, because there
        /// was nothing for it to undo -- no Master Level path was attached to
        /// any class, so nobody had a discipline to change. Migration 39 gave
        /// every class all eight, so the token has work to do again. It resets
        /// the choice rather than making it; the Arbiter is who you name a new
        /// path to.
        /// </summary>
        private bool Respec(GamePlayer player, DbInventoryItem item)
        {
            if (!player.MLGranted)
            {
                SayTo(player, eChatLoc.CL_PopupWindow,
                      "Keep it. You have no discipline to turn from yet.");
                return false;
            }

            if (!player.Inventory.RemoveItem(item))
                return false;

            player.MLLine = 0;
            player.SaveIntoDatabase();
            player.RefreshSpecDependantSkills(true);
            player.Out.SendUpdatePlayer();

            SayTo(player, eChatLoc.CL_PopupWindow,
                  "The star is spent and your training with it. Go back to the " +
                  "Arbiter and name the discipline you would rather have.");

            player.Out.SendMessage(
                "Your Master Level discipline has been set aside. Speak to the " +
                "Arbiter to choose again.",
                eChatType.CT_Important, eChatLoc.CL_SystemWindow);

            return true;
        }

        /// <summary>Hand back a credit, receive the Master Level it names.</summary>
        private bool Redeem(GamePlayer player, DbInventoryItem item)
        {
            if (!int.TryParse(item.Id_nb.Substring(CREDIT.Length), out int level) ||
                level < 1 || level > GamePlayer.ML_MAX_LEVEL)
            {
                SayTo(player, eChatLoc.CL_PopupWindow,
                      "This is not a credit I recognise.");
                return false;
            }

            if (!player.MLGranted)
            {
                SayTo(player, eChatLoc.CL_PopupWindow,
                      "You have not begun the trials. Speak to the Arbiter " +
                      "first; I cannot give you a Master Level you have no " +
                      "claim to.");
                return false;
            }

            if (player.MLLevel >= level)
            {
                SayTo(player, eChatLoc.CL_PopupWindow,
                      "You are already Master Level " + player.MLLevel +
                      ". Keep this for a rank you have yet to reach.");
                return false;
            }

            if (!player.Inventory.RemoveItem(item))
                return false;

            // A credit buys the standing, not the rank.
            //
            // This used to set MLLevel outright and zero MLExperience, which
            // got both halves wrong: it skipped the Arbiter, who is the one who
            // actually teaches a Master Level, and it threw away every kill the
            // player had banked towards the next one. Somebody who bought their
            // way to Master Level 5 arrived with an empty bar, no new spells,
            // and an Arbiter who refused to advance them without saying why.
            //
            // What a credit does is fill the bar. One rank's worth per token,
            // added to whatever is already there, and then you go and be taught
            // -- which is why buying five means speaking to him five times.
            long worth = player.GetMLExperienceForLevel(player.MLLevel + 1);
            player.MLExperience += worth;
            player.SaveIntoDatabase();

            SayTo(player, eChatLoc.CL_PopupWindow,
                  "The credit is yours. Take it to the Arbiter and he will " +
                  "raise you; he does the teaching, I only keep the books.");

            player.Out.SendMessage(
                "You have earned credit towards Master Level " + (player.MLLevel + 1) +
                ". Speak to the Arbiter to be raised.",
                eChatType.CT_Important, eChatLoc.CL_SystemWindow);

            player.Out.SendMasterLevelWindow((byte) player.MLLevel);
            return true;
        }
    }
}
