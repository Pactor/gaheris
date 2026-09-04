using System;
using DOL.AI.Brain;
using DOL.Database;
using DOL.GS.Keeps;
using DOL.GS.ServerProperties;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// Dreaded Seal loot for Old Frontiers.
    ///
    /// Replaces the stock LootGeneratorDreadedSeals, which cannot pay out keep
    /// lords here. It reads lord.Component.Keep.BaseLevel directly, and in Old
    /// Frontiers the lords are mob rows with no Component -- so it throws, the
    /// surrounding catch swallows it, and every keep lord drops nothing. The
    /// guaranteed 5 x keep level payout never fires.
    ///
    /// This version resolves the keep by proximity when Component is absent.
    /// The nearest two frontier keeps are 21,686 units apart and the guard ring
    /// reaches about 2,056, so an 8,000 radius is unambiguous.
    ///
    /// LootMgr searches ScriptMgr.Scripts before GameServer.dll when resolving
    /// a generator class, so registering this name in the lootgenerator table
    /// is all that is needed -- no core fork.
    ///
    /// Behaviour is otherwise identical to the original, including the tower
    /// and low-BaseLevel single-seal case and the Lord Agramon special case.
    /// </summary>
    public class LootGeneratorGaherisSeals : LootGeneratorBase
    {
        private static readonly Logging.Logger log =
            Logging.LoggerManager.Create(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        private const int KEEP_SEARCH_RADIUS = 8000;

        private static DbItemTemplate _glowing;
        private static DbItemTemplate _sanguine;

        // Looked up lazily: a static initialiser can run before the seal
        // templates are loaded, which would cache null forever.
        private static DbItemTemplate Glowing =>
            _glowing ??= GameServer.Database.FindObjectByKey<DbItemTemplate>("glowing_dreaded_seal");

        private static DbItemTemplate Sanguine =>
            _sanguine ??= GameServer.Database.FindObjectByKey<DbItemTemplate>("sanguine_dreaded_seal");

        public override LootList GenerateLoot(GameNPC mob, GameObject killer)
        {
            LootList loot = base.GenerateLoot(mob, killer);

            try
            {
                GamePlayer player = killer as GamePlayer;

                // A kill by somebody's pet counts for them -- and so does a
                // kill by a hired companion, which is not a pet at all and so
                // has to be resolved separately.
                // A kill by somebody's pet counts for them -- and a hired
                // companion is a controlled brain too, so this covers both.
                // A kill by somebody's pet counts for them -- and so does one
                // by a hired companion, which is not a pet and so is resolved
                // separately.
                if (killer is GameNPC killerNpc)
                {
                    if (killerNpc.Brain is MercenaryBrain hired)
                        player = hired.Employer;
                    else if (killerNpc.Brain is ControlledMobBrain controlled)
                        player = controlled.GetPlayerOwner();
                }

                if (player == null)
                    return loot;

                if (mob is GuardLord lord)
                {
                    AbstractGameKeep keep = KeepOf(lord);

                    if (keep == null || lord.IsTowerGuard || keep.BaseLevel < 50)
                        loot.AddFixed(Sanguine, 1);
                    else
                        loot.AddFixed(Sanguine, 5 * keep.Level);

                    return loot;
                }

                if (mob.Name.ToUpper() == "LORD AGRAMON")
                {
                    loot.AddFixed(Sanguine, 10);
                    return loot;
                }

                if (mob.Level >= Properties.LOOTGENERATOR_DREADEDSEALS_STARTING_LEVEL)
                {
                    int chance = (mob.Level - Properties.LOOTGENERATOR_DREADEDSEALS_STARTING_LEVEL)
                               * Properties.LOOTGENERATOR_DREADEDSEALS_DROP_CHANCE_PER_LEVEL
                               + Properties.LOOTGENERATOR_DREADEDSEALS_BASE_CHANCE;

                    // A capitalised name marks a named mob.
                    if (!mob.Name.ToLower().Equals(mob.Name))
                        chance = (int) Math.Round(chance * Properties.LOOTGENERATOR_DREADEDSEALS_NAMED_CHANCE);

                    if (Util.Random(9999) < chance)
                        loot.AddFixed(Glowing, 1);
                }
            }
            catch (Exception e)
            {
                log.Error("LootGeneratorGaherisSeals: " + e.Message, e);
            }

            return loot;
        }

        /// <summary>
        /// The keep this lord belongs to. Component-attached lords report it
        /// directly; mob-row lords are matched to the nearest keep.
        /// </summary>
        private static AbstractGameKeep KeepOf(GameKeepGuard guard)
        {
            if (guard.Component != null && guard.Component.Keep != null)
                return guard.Component.Keep;

            return GameServer.KeepManager.GetClosestKeepToSpot(
                guard.CurrentRegionID, guard.X, guard.Y, guard.Z, KEEP_SEARCH_RADIUS);
        }
    }
}
