using System;
using DOL.Events;
using DOL.GS.Keeps;
using DOL.GS.PacketHandler;
using DOL.GS.PlayerClass;
using DOL.GS.ServerProperties;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// A Vampiir draws power from blows taken as well as blows landed.
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
    /// Power comes only from a blow that actually lands. A block, a parry or
    /// an evade is a blow that did not happen.
    /// </summary>
    public static class VampiirPower
    {
        [ServerProperty("gaheris", "gaheris_vampiir_power_rate",
            "How fast a Vampiir draws power from a fight, as a multiplier on " +
            "the core's own formula. 1.0 grants exactly what the core grants " +
            "for landing a blow, now also for taking one. Above 1.0 tops up " +
            "both sides by the difference.", 1.0)]
        public static double POWER_RATE;

        [ScriptLoadedEvent]
        public static void OnScriptLoaded(DOLEvent e, object sender, EventArgs args)
        {
            GameEventMgr.AddHandler(GameLivingEvent.AttackedByEnemy, new DOLEventHandler(Struck));
            GameEventMgr.AddHandler(GameLivingEvent.AttackFinished, new DOLEventHandler(Landed));
        }

        [ScriptUnloadedEvent]
        public static void OnScriptUnloaded(DOLEvent e, object sender, EventArgs args)
        {
            GameEventMgr.RemoveHandler(GameLivingEvent.AttackedByEnemy, new DOLEventHandler(Struck));
            GameEventMgr.RemoveHandler(GameLivingEvent.AttackFinished, new DOLEventHandler(Landed));
        }

        /// <summary>The half the core never had: power for being hit.</summary>
        private static void Struck(DOLEvent e, object sender, EventArgs args)
        {
            if (sender is not GamePlayer player || args is not AttackedByEnemyEventArgs hit)
                return;

            Draw(player, hit.AttackData, POWER_RATE);
        }

        /// <summary>
        /// The half the core does have, topped up only when the rate has been
        /// raised. At 1.0 this grants nothing, because the core has already
        /// paid for the blow by the time this runs.
        /// </summary>
        private static void Landed(DOLEvent e, object sender, EventArgs args)
        {
            if (POWER_RATE <= 1.0)
                return;

            if (sender is not GamePlayer player || args is not AttackFinishedEventArgs swing)
                return;

            Draw(player, swing.AttackData, POWER_RATE - 1.0);
        }

        /// <summary>
        /// Grant a share of what the core's formula is worth for this blow.
        /// One whole share is exactly what the core pays for landing one.
        /// </summary>
        private static void Draw(GamePlayer player, AttackData ad, double share)
        {
            try
            {
                if (ad == null || player.CharacterClass is not ClassVampiir || !player.IsAlive)
                    return;

                if (ad.AttackResult is not eAttackResult.HitStyle and not eAttackResult.HitUnstyled)
                    return;

                // Nothing is drawn from a keep or a siege engine, the same
                // exclusion the core makes on the other side.
                if (ad.Target is GameKeepComponent or GameKeepDoor or GameSiegeWeapon)
                    return;

                int perc = Convert.ToInt32((double) (ad.Damage + ad.CriticalDamage) / 100 *
                                           (55 - player.Level));
                perc = perc < 1 ? 1 : (perc > 15 ? 15 : perc);

                int gain = (int) Math.Ceiling(perc * player.MaxMana / 100.0 * share);

                if (gain > 0)
                    player.Mana += gain;
            }
            catch (Exception)
            {
                // Never let a power tick interfere with a swing.
            }
        }
    }
}
