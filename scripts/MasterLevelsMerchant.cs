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
    /// </summary>
    public class MasterLevelsMerchant : GameBountyMerchant
    {
        public override bool Interact(GamePlayer player)
        {
            if (!base.Interact(player))
                return false;

            TurnTo(player, 5000);

            SayTo(player, eChatLoc.CL_ChatWindow,
                "I trade in the credits of the Master Levels. What I have is " +
                "bought with bounty points, and bounty points alone.");

            return true;
        }
    }
}
