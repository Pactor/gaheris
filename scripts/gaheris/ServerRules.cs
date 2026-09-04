using DOL.AI.Brain;
using DOL.GS.ServerRules;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// The PvE rules, with one addition: a hired companion may fight.
    ///
    /// Core refuses NPC versus NPC outright unless the attacker is somebody's
    /// pet:
    ///
    ///     // Pets can attack everything.
    ///     if (npcAttacker is GameSummonedPet || npcAttacker.Brain is ControlledMobBrain)
    ///         return true;
    ///
    ///     // Mobs can attack mobs only if they both have a faction...
    ///     if (npcDefender.Faction == null || npcAttacker.Faction == null)
    ///         return false;
    ///
    /// That rule is why a hired group would heal and buff perfectly well and
    /// never swing at anything: healing targets an ally, so it was never
    /// checked, while every offensive act was quietly illegal. The player did
    /// all the killing while six people watched.
    ///
    /// The obvious workarounds are both wrong. Making them pets again brings
    /// back the owner-aggro tag that has mobs walking through the group to
    /// reach the player. Deriving from GameSummonedPet satisfies the type check
    /// but its Level setter is gated on having a controlled owner, so they
    /// could never be levelled at all.
    ///
    /// So the rule itself is amended, in the one place meant for it. ScriptMgr
    /// looks in the scripts before the core assembly when choosing rules, so
    /// this replaces the stock PvE set with no fork of the server.
    /// </summary>
    [ServerRules(EGameServerType.GST_PvE)]
    public class GaherisServerRules : PvEServerRules
    {
        public override bool IsAllowedToAttack(GameLiving attacker, GameLiving defender, bool quiet)
        {
            if (base.IsAllowedToAttack(attacker, defender, quiet))
                return true;

            // Only ever widens the rule for a hire attacking a hostile NPC.
            // Everything base refused for any other reason stays refused.
            if (attacker is not GameMercenary hire || defender is not GameNPC target)
                return false;

            if (!hire.IsAlive || !target.IsAlive)
                return false;

            // Never each other, never the player's own side. Anything that
            // belongs to a realm is somebody's, and a hire carries its
            // employer's realm, so this covers the whole group at once.
            if (target is GameMercenary || target.Realm != eRealm.None)
                return false;

            // Peaceful things stay peaceful -- trainers, merchants, the Gate
            // Wardens standing outside hostile keeps.
            if ((target.Flags & GameNPC.eFlags.PEACE) != 0)
                return false;

            if (target.Brain is IControlledBrain)
                return false; // Somebody's pet, so somebody's business.

            return true;
        }
    }
}
