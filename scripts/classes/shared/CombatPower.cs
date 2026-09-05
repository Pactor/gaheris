using System;
using DOL.Events;
using DOL.GS.Keeps;
using DOL.GS.PacketHandler;
using DOL.GS.PlayerClass;
using DOL.GS.ServerProperties;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// Power from fighting, for the two classes that live on it -- and only
    /// for the ones the core cannot reach.
    ///
    /// **The core already does this correctly, for players.** That took three
    /// passes to establish, and each pass had it wrong in a different way, so
    /// the conclusion is written out in full:
    ///
    ///   Vampiir  gains power by **dealing** damage. AttackComponent.MakeAttack:
    ///
    ///       perc = (ad.Damage + ad.CriticalDamage) / 100 * (55 - Level)
    ///       perc = clamp(perc, 1, 15)
    ///       Mana += ceil(perc * MaxMana / 100)
    ///
    ///   Mauler   gains power by **taking** it. GamePlayer.TakeDamage, through
    ///            Defensive Combat Power Regeneration, which every Mauler
    ///            carries from career level 1:
    ///
    ///       Mana += (damageAmount + criticalAmount) * 0.25
    ///
    /// The class libraries are plain about both. A Vampiir "gains power from a
    /// variety of attacks -- primarily melee strikes" and has no normal power
    /// pool to fill any other way. A Mauler "does not have a normal power
    /// pool, however. It will gain power from taking damage in combat" --
    /// power from damage *dealt* reaches him only through particular spells
    /// that say so, not as a passive.
    ///
    /// This file spent most of its life doing the opposite of both: paying a
    /// Vampiir for being hit, which is not his mechanic, and paying a Mauler
    /// for landing blows, which is not his either -- while core was quietly
    /// paying the Mauler a second time for the one that is.
    ///
    /// **What is left is hires, and nothing else.** Both core paths are gated
    /// on GamePlayer: MakeAttack tests `playerOwner.CharacterClass`, and
    /// TakeDamage is an override on GamePlayer that a GameNPC never runs. So a
    /// hired Vampiir was paid nothing for dealing and a hired Mauler nothing
    /// for taking, and the game refuses them every other way of filling a bar
    /// -- RegenBuff, PowerHealSpellHandler and the Perfecter power heal all
    /// name these classes and decline. Their bars filled once and never again.
    ///
    /// Each hire is paid on its own class's formula, the core's, so a hired
    /// one and a played one behave the same way.
    ///
    /// Power comes only from a blow that lands. A block, parry or evade is a
    /// blow that did not happen, and TakeDamage never fires for one.
    /// </summary>
    public static class CombatPower
    {
        [ServerProperty("classes", "combat_power_rate",
            "How fast a hired Vampiir or Mauler draws power from a fight, as a " +
            "multiplier on the core's own formulas. 1.0 grants a hire exactly " +
            "what the core grants the played class. Players are not affected " +
            "at all -- the core pays them directly.", 1.0)]
        public static double POWER_RATE;

        /// <summary>
        /// Whether power drawn from a fight is narrated.
        ///
        /// This file granted nothing at all from the day it was written until
        /// the dead events under it were found, and there was no way to tell
        /// from outside: the only evidence either way is a bar that moves.
        /// A line per landed blow is too much to leave on, and exactly what is
        /// wanted while confirming it works.
        /// </summary>
        [ServerProperty("classes", "combat_power_log",
            "Log each time a Vampiir or Mauler draws power from a blow.", false)]
        public static bool LOG;

        [ScriptLoadedEvent]
        public static void OnScriptLoaded(DOLEvent e, object sender, EventArgs args)
        {
            GameEventMgr.AddHandler(GameObjectEvent.TakeDamage, new DOLEventHandler(Blow));
        }

        [ScriptUnloadedEvent]
        public static void OnScriptUnloaded(DOLEvent e, object sender, EventArgs args)
        {
            GameEventMgr.RemoveHandler(GameObjectEvent.TakeDamage, new DOLEventHandler(Blow));
        }

        /// <summary>Classes that pay for their power with violence.</summary>
        /// <summary>
        /// Does this thing pay for its power with violence?
        ///
        /// A hire counts. It carries the same bar for the same reason, and the
        /// core refuses it every other way of filling one exactly as it
        /// refuses a player -- RegenBuff and the power heals test the class,
        /// not whether anybody is holding the reins. Without this a hired
        /// Vampiir or Mauler filled its bar once, drained it, and never
        /// recovered, which is the fault this whole file exists to answer.
        /// </summary>
        private static bool Feeds(GameLiving living)
        {
            if (living is GamePlayer player)
            {
                return player.CharacterClass is ClassVampiir
                    or ClassMaulerAlb or ClassMaulerMid or ClassMaulerHib;
            }

            return living is GameMercenary hire &&
                   hire.Profile?.ClassId is eCharacterClass.Vampiir
                       or eCharacterClass.MaulerAlb
                       or eCharacterClass.MaulerMid
                       or eCharacterClass.MaulerHib;
        }

        /// <summary>
        /// Who is paid for *dealing* a blow: the Vampiir, and only him. It is
        /// his whole mechanic, and it is not the Mauler's -- a Mauler earns
        /// power by being hit, and gets power from damage dealt only through
        /// the few spells that say "returned as power".
        /// </summary>
        private static bool FeedsOnDealing(GameLiving living)
        {
            if (living is GamePlayer player)
                return player.CharacterClass is ClassVampiir;

            return living is GameMercenary hire &&
                   hire.Profile?.ClassId is eCharacterClass.Vampiir;
        }

        /// <summary>
        /// Who is paid for *taking* a blow, which is not the same list.
        ///
        /// Power from being hit is the Mauler's mechanic and his alone -- it is
        /// what Defensive Combat Power Regeneration is, and only a Mauler
        /// carries it. **The Vampiir is not on this list**, and an earlier
        /// version of this file had him on it by mistake.
        ///
        /// The class library is plain: he "gains power from a variety of
        /// attacks -- primarily melee strikes", has no normal power pool, and
        /// fills it only by successfully attacking. Core already does exactly
        /// that in AttackComponent.MakeAttack. Paying him for standing there
        /// being hit was an invention, not a repair.
        /// </summary>
        private static bool FeedsOnBeingHit(GameLiving living)
        {
            if (living is GamePlayer player)
            {
                return player.CharacterClass
                    is ClassMaulerAlb or ClassMaulerMid or ClassMaulerHib;
            }

            return living is GameMercenary hire &&
                   hire.Profile?.ClassId is eCharacterClass.MaulerAlb
                       or eCharacterClass.MaulerMid
                       or eCharacterClass.MaulerHib;
        }

        /// <summary>Core pays a Vampiir for landing a blow, in MakeAttack.</summary>
        private static bool CorePays(GameLiving living)
        {
            return living is GamePlayer player && player.CharacterClass is ClassVampiir;
        }

        /// <summary>
        /// Core pays for *taking* a blow too, but only for someone carrying
        /// Defensive Combat Power Regeneration -- which is every Mauler and
        /// nobody else. Checked as an ability rather than a class so that a
        /// hired Mauler, whose GameNPC never runs GamePlayer.TakeDamage, is
        /// still paid here.
        /// </summary>
        private static bool CorePaysForBeingHit(GameLiving living)
        {
            return living is GamePlayer player &&
                   player.HasAbility(Abilities.DefensiveCombatPowerRegeneration);
        }

        /// <summary>
        /// One blow, read from the side that took it.
        ///
        /// This was two handlers, on AttackedByEnemy and AttackFinished, and
        /// neither of those events is ever raised by this server -- so for as
        /// long as it has been loaded this script has done nothing at all. The
        /// ECS rewrite moved being-attacked and finishing-an-attack out of the
        /// event system and into methods called directly, leaving twenty-seven
        /// and twenty-one files respectively subscribed to publishers that no
        /// longer exist.
        ///
        /// TakeDamage is still raised, from GameObject.TakeDamage, and it is
        /// the better hook anyway: it fires once per blow and names both ends
        /// of it. The victim is the sender, the striker is the source, so one
        /// handler pays whichever of them feeds on violence -- or both, when a
        /// Vampiir and a Mauler are hitting each other.
        /// </summary>
        private static void Blow(DOLEvent e, object sender, EventArgs args)
        {
            if (args is not TakeDamageEventArgs blow)
                return;

            int damage = blow.DamageAmount + blow.CriticalAmount;

            if (damage <= 0)
                return;

            // Taking a blow pays a Mauler, and nobody else. Core pays a played
            // one in GamePlayer.TakeDamage; a hire is a GameNPC and never runs
            // that override, so this is the only thing that pays it.
            if (sender is GameLiving hurt && FeedsOnBeingHit(hurt) && !CorePaysForBeingHit(hurt))
                Quarter(hurt, damage);

            // Landing one pays a Vampiir, and nobody else. Core pays a played
            // one in MakeAttack, which tests playerOwner.CharacterClass, so
            // again only a hire is left.
            if (blow.DamageSource is GameLiving struck && FeedsOnDealing(struck) && !CorePays(struck))
                Draw(struck, sender as GameObject, damage, POWER_RATE);
        }

        /// <summary>
        /// Grant a share of what the core's formula is worth for this blow.
        /// One whole share is exactly what the core pays for landing one.
        /// </summary>
        private static void Draw(GameLiving player, GameObject other, int damage, double share)
        {
            try
            {
                if (!Feeds(player) || !player.IsAlive)
                    return;

                // Nothing is drawn from a keep or a siege engine, the same
                // exclusion the core makes on the other side. Damage landing
                // is no longer worth testing for -- TakeDamage only fires on a
                // blow that got through, so a parry or a miss never reaches
                // here in the first place.
                if (other is GameKeepComponent or GameKeepDoor or GameSiegeWeapon)
                    return;

                int perc = Convert.ToInt32((double) damage / 100 * (55 - player.Level));
                perc = perc < 1 ? 1 : (perc > 15 ? 15 : perc);

                int gain = (int) Math.Ceiling(perc * player.MaxMana / 100.0 * share);

                if (gain > 0)
                {
                    int before = player.Mana;
                    player.Mana += gain;

                    if (LOG)
                        Console.WriteLine("Power: " + player.Name + " draws " + gain +
                                          " from " + damage + " damage " +
                                          (player == other ? "taken" : "dealt") +
                                          " -- " + before + " to " + player.Mana +
                                          " of " + player.MaxMana);
                }
            }
            catch (Exception)
            {
                // Never let a power tick interfere with a swing.
            }
        }

        /// <summary>
        /// A quarter of the damage, as power. This is the core's Mauler
        /// formula exactly -- `Mana += (damage + crit) * 0.25` -- rather than
        /// the Vampiir's curve, so a hired Mauler fills at the same rate as a
        /// played one.
        /// </summary>
        private static void Quarter(GameLiving hire, int damage)
        {
            try
            {
                if (!hire.IsAlive)
                    return;

                int gain = (int) (damage * 0.25 * POWER_RATE);

                if (gain <= 0)
                    return;

                int before = hire.Mana;
                hire.Mana += gain;

                if (LOG)
                {
                    Console.WriteLine("Power: " + hire.Name + " draws " + gain +
                                      " from " + damage + " damage taken -- " +
                                      before + " to " + hire.Mana +
                                      " of " + hire.MaxMana);
                }
            }
            catch (Exception)
            {
                // Never let a power tick interfere with a swing.
            }
        }
    }
}
