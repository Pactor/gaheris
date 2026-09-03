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

            // 255, not 0. MLLine is an index into the disciplines and every
            // value from 0 upwards names a real one, so there is no number
            // that means "not chosen" -- setting it to 0 quietly moved the
            // player onto Banelord and left the Arbiter hiding the list,
            // because he only offers it to somebody who has not chosen. A
            // value past the end of the list is unchosen: PathOf finds nothing
            // at it, so the Arbiter offers the disciplines again, and
            // RefreshSpecDependantSkills matches nothing at it either, so the
            // old path's spells come away with the star.
            player.MLLine = GaherisArbiter.NO_PATH;
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

            // The credit has to be for the very next rank, which is how DOLSharp
            // does it and how the ranks stay a ladder rather than a menu:
            //
            //     if (item.Id_nb.EndsWith(string.Format("token_{0}", player.MLLevel+1)))
            //
            // Buy the credit for six when you are five, hand it over, and you
            // are six. Buying five credits means five of these conversations,
            // in order.
            if (level != player.MLLevel + 1)
            {
                SayTo(player, eChatLoc.CL_PopupWindow,
                      "You need to give me the credit for Master Level " +
                      (player.MLLevel + 1) + " to continue learning your path.");
                return false;
            }

            if (!player.Inventory.RemoveItem(item))
                return false;

            // Handing the credit over IS the training. This is the merchant's
            // job in DOLSharp and it is two lines there:
            //
            //     player.MLLevel++;
            //     player.RefreshSpecDependantSkills(true);
            //
            // Earlier attempts put the teaching on the Arbiter and had this
            // grant experience instead, which is not how it worked and left the
            // player holding a rank with no spells behind it. The refresh is
            // the part that matters: MLLevel decides which spells the Master
            // Level specialisation hands over, so changing the rank without
            // recomputing the spec leaves you at whatever you had before.
            player.MLLevel++;
            player.MLExperience = 0;
            player.SaveIntoDatabase();
            player.RefreshSpecDependantSkills(true);

            SayTo(player, eChatLoc.CL_PopupWindow,
                  "You have been granted knowledge of the Master Level " +
                  player.MLLevel + "!");

            player.Out.SendMessage(
                "You have been granted knowledge of the Master Level " +
                player.MLLevel + "!",
                eChatType.CT_Important, eChatLoc.CL_SystemWindow);

            // Refresh the client and bring the company along.
            GaherisArbiter.Announce(player);
            return true;
        }
    }
}
