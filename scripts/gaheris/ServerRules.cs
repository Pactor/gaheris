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
    ///
    /// It has to be amended in BOTH directions, which the first version of
    /// this missed. Widening only "hire hits monster" left "monster hits hire"
    /// falling through to the same core rule, and a hire has no faction, so it
    /// was refused. The consequences were not obvious from the rule:
    ///
    ///   Nothing ever aggroed a hire. CanAggroTarget asks IsAllowedToAttack
    ///   first, so a monster scanning for something to fight discarded every
    ///   companion in the group and walked to the player.
    ///
    ///   A tank could not hold anything either. Provoke plants real aggro on
    ///   the monster, but ShouldBeRemoved drops any entry the same rule
    ///   refuses, so the threat was swept out of the list on the next tick.
    ///   The tank was shouting at something that could not hear it.
    ///
    /// So a group of six could not take a hit between them, and everything a
    /// monster wanted was standing behind them.
    /// </summary>
    [ServerRules(EGameServerType.GST_PvE)]
    public class GaherisServerRules : PvEServerRules
    {
        public override bool IsAllowedToAttack(GameLiving attacker, GameLiving defender, bool quiet)
        {
            if (base.IsAllowedToAttack(attacker, defender, quiet))
                return true;

            // Only ever widens the rule between a hire and a hostile NPC, in
            // whichever direction it is asked. Everything base refused for any
            // other reason stays refused.
            if (attacker is GameMercenary && defender is GameNPC monster)
                return IsHostileToHires(monster);

            if (defender is GameMercenary && attacker is GameNPC aggressor)
                return IsHostileToHires(aggressor);

            return false;
        }

        /// <summary>
        /// Whether an NPC is something a hired company is at war with.
        ///
        /// One test, asked from both sides, so a monster a hire may attack is
        /// exactly a monster that may attack the hire. Splitting these apart is
        /// what produced a company that could hit things and never be hit back.
        /// </summary>
        private static bool IsHostileToHires(GameNPC npc)
        {
            if (!npc.IsAlive)
                return false;

            // Never each other, never the player's own side. Anything that
            // belongs to a realm is somebody's, and a hire carries its
            // employer's realm, so this covers the whole group at once.
            if (npc is GameMercenary || npc.Realm != eRealm.None)
                return false;

            // Peaceful things stay peaceful -- trainers, merchants, the Gate
            // Wardens standing outside hostile keeps.
            if ((npc.Flags & GameNPC.eFlags.PEACE) != 0)
                return false;

            if (npc.Brain is IControlledBrain)
                return false; // Somebody's pet, so somebody's business.

            return true;
        }
    }
}
