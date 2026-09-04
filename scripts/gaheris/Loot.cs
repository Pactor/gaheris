using System;
using System.Collections.Generic;
using DOL.Database;
using DOL.Events;
using DOL.GS.PacketHandler;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// Makes a kill by a hired companion count as a kill by their employer.
    ///
    /// Every loot generator in core answers the same question the same way:
    ///
    ///     if (killer is GameNPC npc && npc.Brain is IControlledBrain brain)
    ///         player = brain.GetPlayerOwner();
    ///
    /// which is to say: a kill by a NPC counts for somebody only if that NPC is
    /// a pet. Hired companions are deliberately not pets -- being pets is what
    /// had mobs walking through the group to reach the player -- so the moment
    /// they landed a killing blow, the generators found no player and dropped
    /// nothing at all. Not reduced loot: none.
    ///
    /// And the group does most of the killing, so most kills dropped nothing.
    ///
    /// Rather than reach back into the generators, this substitutes the
    /// employer for the hire before core ever sees the killer.
    /// </summary>
    public static class GaherisLoot
    {
        /// <summary>
        /// How often a mob drops a randomised item, as a percentage.
        ///
        /// Core's own value is 14 and it is a plain static field rather than a
        /// server property, so this is the only place it can be set. Gearing a
        /// group of seven from scratch needs considerably more than gearing
        /// one character.
        /// </summary>
        public const ushort ROG_CHANCE = 35;

        [ScriptLoadedEvent]
        public static void OnScriptLoaded(DOLEvent e, object sender, EventArgs args)
        {
            ROGMobGenerator.BASE_ROG_CHANCE = ROG_CHANCE;
        }

        /// <summary>Whoever should be credited for this kill.</summary>
        public static GameObject Credit(GameObject killer)
        {
            if (killer is GameMercenary hire && hire.Employer != null)
                return hire.Employer;

            return killer;
        }
    }

    /// <summary>Template loot, credited to the employer.</summary>
    public class GaherisLootTemplate : LootGeneratorTemplate
    {
        public override LootList GenerateLoot(GameNPC mob, GameObject killer)
        {
            return base.GenerateLoot(mob, GaherisLoot.Credit(killer));
        }
    }

    /// <summary>
    /// Randomised gear, rolled for the whole group.
    ///
    /// Core's version is not usable here, and not because of the rates. It
    /// picks which class to roll for like this:
    ///
    ///     foreach (GamePlayer player in group.GetMembersInTheGroup())
    ///         validClasses.Add((eCharacterClass) player.CharacterClass.ID);
    ///
    /// GetMembersInTheGroup returns GameLiving. With hired companions in the
    /// group that cast throws, the exception is swallowed by the try/catch
    /// around it, and the result is NO gear at all -- not less. Putting them in
    /// the group, which is what makes them a group, silently turned off gear
    /// drops entirely.
    ///
    /// Rewritten rather than patched, which also lets it do the right thing:
    /// it rolls for a random class among the player AND their hires, so a group
    /// of seven actually gets gear it can wear instead of seven copies of the
    /// employer's.
    /// </summary>
    public class GaherisLootRog : LootGeneratorBase
    {
        public override LootList GenerateLoot(GameNPC mob, GameObject killer)
        {
            LootList loot = base.GenerateLoot(mob, killer);

            try
            {
                if (GaherisLoot.Credit(killer) is not GamePlayer player)
                    return loot;

                int con = player.GetConLevel(mob);

                if (con <= -3)
                    return loot; // Grey. Nothing worth having.

                int chance = GaherisLoot.ROG_CHANCE + (con < 0 ? con + 1 : con) * 3;

                if (mob.Level > 27)
                    chance -= 3;

                if (mob.Level > 40)
                    chance -= 3;

                int drops = 0;
                int cap = 1 + MercenaryManager.GetCompany(player).Count / 3;

                for (int roll = 0; roll < cap; roll++)
                {
                    if (!Util.Chance(chance))
                        continue;

                    GeneratedUniqueItem item = AtlasROGManager.GenerateMonsterLootROG(
                        player.Realm, ClassToRollFor(player), (byte) (mob.Level + 1),
                        player.CurrentZone?.IsOF ?? false);

                    if (item == null)
                        continue;

                    item.GenerateItemQuality(con);
                    item.MaxCount = 1;
                    loot.AddFixed(item, 1);
                    drops++;
                }
            }
            catch (Exception)
            {
                // Never let a loot roll cost the player their kill.
            }

            return loot;
        }

        /// <summary>The player's class, or one of the classes they hired.</summary>
        private static eCharacterClass ClassToRollFor(GamePlayer player)
        {
            List<eCharacterClass> classes = new() { (eCharacterClass) player.CharacterClass.ID };

            foreach (GameMercenary hire in MercenaryManager.GetCompany(player))
            {
                if (hire.CanWearGear && hire.Profile != null &&
                    hire.Profile.ClassId is not eCharacterClass.Unknown)
                    classes.Add(hire.Profile.ClassId);
            }

            return classes[Util.Random(classes.Count - 1)];
        }
    }

    /// <summary>
    /// Money, credited to the employer, and the one place Pickpocket exists.
    ///
    /// Pickpocket is Spymaster ML1 and reads, in full, "20% Bonus to PvE Coin".
    /// It is granted to every class -- any of them may walk the Spymaster path
    /// -- and it had no code anywhere in the server. Its sibling Greatness is
    /// implemented, in MaxConcentrationCalculator, so the omission is an
    /// oversight rather than a decision.
    ///
    /// On a co-operative server every coin is PvE coin, which makes this one of
    /// the few Master Level passives that is worth more here than on live.
    ///
    /// Core builds the money as a fresh DbItemTemplate on each kill (model 488,
    /// "bag of coins"), so its price can be raised in place. GetLoot returns the
    /// same object that stays in the list, and this generator adds no random
    /// drops for the call to disturb.
    /// </summary>
    public class GaherisLootMoney : LootGeneratorMoney
    {
        /// <summary>Per the ability's own description.</summary>
        private const int PICKPOCKET_BONUS = 20;

        private const int BAG_OF_COINS = 488;

        public override LootList GenerateLoot(GameNPC mob, GameObject killer)
        {
            GameObject credited = GaherisLoot.Credit(killer);
            LootList loot = base.GenerateLoot(mob, credited);

            if (credited is not GamePlayer player || !player.HasAbility("Pickpocket"))
                return loot;

            foreach (DbItemTemplate item in loot.GetLoot())
            {
                if (item != null && item.Model == BAG_OF_COINS && item.Price > 0)
                    item.Price += item.Price * PICKPOCKET_BONUS / 100;
            }

            return loot;
        }
    }
}
