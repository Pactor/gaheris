using System;
using DOL.Events;
using DOL.GS.Keeps;
using DOL.GS.PacketHandler;
using DOL.GS.PlayerClass;
using DOL.GS.ServerProperties;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// A Vampiir draws power from blows taken as well as blows landed, and a
    /// Mauler draws it at all.
    ///
    /// Only half of that is in the core. AttackComponent.MakeAttack grants
    /// power when a Vampiir hits something --
    ///
    ///     int perc = (ad.Damage + ad.CriticalDamage) / 100 * (55 - Level);
    ///     perc = clamp(perc, 1, 15);
    ///     Mana += ceil(perc * MaxMana / 100);
    ///
    /// -- and that is the only place in the whole server where a Vampiir is
    /// given power at all, the power bolt aside. Being hit grants nothing. The
    /// one piece of Vampiir code on the damage-taken path cancels the speed
    /// enhancement and then stops. So a Vampiir fills at half the rate it
    /// should, and the half that is missing is the one that pays you for
    /// standing in the middle of a fight, which is the whole shape of the
    /// class.
    ///
    /// This adds it, using the core's own formula rather than a new one --
    /// same curve, same one-to-fifteen-percent bounds, same inverse scaling on
    /// level, which is there because damage grows with level and the share
    /// taken from it should not.
    ///
    /// The Maulers are worse off still. They carry a power bar -- their class
    /// keys mana to Strength -- and the game refuses them every way of filling
    /// it: RegenBuff, PowerHealSpellHandler and the Perfecter power heal all
    /// name the three of them alongside the Vampiir and decline. That is
    /// correct, because a Mauler is supposed to earn its power by fighting.
    /// Nothing in the server grants it any. So the bar fills once, drains, and
    /// never recovers -- which makes Fist Wraps and Power Strikes something
    /// you use at the start of an evening and not again.
    ///
    /// They are given the same deal as the Vampiir here: power for landing a
    /// blow and for taking one, on the core's own curve.
    ///
    /// Power comes only from a blow that actually lands. A block, a parry or
    /// an evade is a blow that did not happen.
    /// </summary>
    public static class CombatPower
    {
        [ServerProperty("classes", "combat_power_rate",
            "How fast a Vampiir or Mauler draws power from a fight, as a multiplier on " +
            "the core's own formula. 1.0 grants exactly what the core grants " +
            "a Vampiir for landing a blow -- now also for taking one, and for " +
            "the Maulers, who are granted nothing at all by the core.", 1.0)]
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

        /// <summary>The core pays a Vampiir for landing a blow; nobody else.</summary>
        private static bool CorePays(GameLiving living)
        {
            return living is GamePlayer player && player.CharacterClass is ClassVampiir;
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

            // The half the core never had: power for being hit.
            if (sender is GameLiving hurt)
                Draw(hurt, hurt, damage, POWER_RATE);

            // And power for landing one. The core already pays a Vampiir for
            // this in MakeAttack, so it only tops that up when the rate has
            // been raised. A Mauler is paid nothing by anybody, and neither is
            // any hire, so both get the whole share.
            if (blow.DamageSource is GameLiving struck)
            {
                double share = CorePays(struck) ? POWER_RATE - 1.0 : POWER_RATE;

                if (share > 0)
                    Draw(struck, sender as GameObject, damage, share);
            }
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
    }
}
