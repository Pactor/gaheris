using System;
using System.Collections;
using System.Collections.Generic;
using DOL.Database;
using DOL.Events;
using DOL.GS.Effects;
using DOL.GS.PacketHandler;
using DOL.GS.RealmAbilities;
using DOL.GS.ServerProperties;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// Four realm abilities that were granted and did nothing.
    ///
    /// Each of them hangs its whole purpose on a blow landing, and each
    /// listens for that on an event this server does not raise --
    /// GameLivingEvent.AttackFinished for the two that pay out, and
    /// AttackedByEnemy for the two that should break. Nothing warns; the
    /// ability appears on the bar, fires, and quietly does half of what it
    /// says.
    ///
    ///   Scout   Shield Trip       root should break when the target is hit
    ///   Hunter  Entwining Snakes  snare should break when the target is hit
    ///   Warden  Fury of Nature    damage dealt should heal the group
    ///   Vampiir Mark of Prey      the damage add should return power
    ///
    /// The first two failing makes them stronger than they should be. The
    /// second two lose the entire point of the ability -- Mark of Prey is the
    /// Vampiir's own RR5 and has never once returned power.
    ///
    /// The replacement is GameObjectEvent.TakeDamage, which is raised, fires
    /// once per blow that lands, and names both ends of it. One handler
    /// therefore serves all four: it asks the victim whether they are rooted
    /// by one of the first two, and the striker whether they carry one of the
    /// second two. See docs/dead-events.md.
    /// </summary>
    public static class BlowsThatNeverLanded
    {
        [ServerProperty("realmabilities", "ra_blows_log",
            "Log when a realm ability fires off a landed blow.", false)]
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

        /// <summary>
        /// Only a weapon swing counts. This is both the correct filter -- all
        /// four abilities are about being hit or hitting in melee -- and the
        /// thing that stops Mark of Prey feeding itself: the damage it adds is
        /// Heat, so it cannot come back through here as another melee blow.
        /// </summary>
        private static bool Melee(eDamageType type)
        {
            return type is eDamageType.Crush or eDamageType.Slash or eDamageType.Thrust;
        }

        private static void Blow(DOLEvent e, object sender, EventArgs args)
        {
            try
            {
                if (args is not TakeDamageEventArgs blow)
                    return;

                int damage = blow.DamageAmount + blow.CriticalAmount;

                if (damage <= 0 || !Melee(blow.DamageType))
                    return;

                if (sender is GameLiving hurt)
                    BreakTheRoots(hurt);

                if (blow.DamageSource is GameLiving striker && sender is GameLiving victim)
                {
                    PayTheVampiir(striker, victim);
                    HealTheGrove(striker, damage);
                }
            }
            catch (Exception)
            {
                // A realm ability payout is not worth taking the damage path
                // down with it.
            }
        }

        /// <summary>
        /// Shield Trip and Entwining Snakes both root or snare, and both are
        /// supposed to let go the moment their victim is struck. Neither ever
        /// did. Stop() is public on both, and removes the speed penalty.
        /// </summary>
        private static void BreakTheRoots(GameLiving hurt)
        {
            ShieldTripRootEffect trip = hurt.EffectList.GetOfType<ShieldTripRootEffect>();

            if (trip != null)
            {
                trip.Stop();
                Say(hurt.Name + " is struck; Shield Trip releases");
            }

            EntwiningSnakesEffect snakes = hurt.EffectList.GetOfType<EntwiningSnakesEffect>();

            if (snakes != null)
            {
                snakes.Stop();
                Say(hurt.Name + " is struck; Entwining Snakes releases");
            }
        }

        /// <summary>
        /// Mark of Prey: a damage add on the Vampiir's group, every point of
        /// which goes back to the Vampiir as power. The core's formula, kept
        /// exactly -- a damage per second figure capped by the wielder's level,
        /// turned into a hit by the weapon's swing interval.
        ///
        /// The interval is read from the wielder's weapon rather than from the
        /// blow, because TakeDamage does not carry the AttackData the original
        /// handler was given. It is the same number: the swing that produced
        /// this blow is the swing that is being timed.
        /// </summary>
        private static void PayTheVampiir(GameLiving striker, GameLiving victim)
        {
            VampiirMark mark = striker.EffectList.GetOfType<VampiirMark>();

            if (mark?.Vampiir == null || !victim.IsAlive ||
                victim.ObjectState is not GameObject.eObjectState.Active)
                return;

            int interval = striker.AttackSpeed(striker.ActiveWeapon);

            if (interval <= 0)
                return;

            double dpsCap = (1.2 + 0.3 * striker.Level) * 0.7;
            double dps = Math.Min(MarkOfPreyAbility.VALUE, dpsCap);
            double bonus = dps * interval * 0.001;
            double resisted = bonus * victim.GetResist(eDamageType.Heat) * -0.01;

            AttackData ad = new()
            {
                Attacker = striker,
                Target = victim,
                Damage = (int) (bonus + resisted),
                Modifier = (int) resisted,
                DamageType = eDamageType.Heat,
                AttackType = AttackData.eAttackType.Spell,
                AttackResult = eAttackResult.HitUnstyled,
            };

            if (ad.Damage <= 0)
                return;

            victim.OnAttackedByEnemy(ad);
            mark.Vampiir.ChangeMana(striker, eManaChangeType.Spell, ad.Damage);

            (striker as GamePlayer)?.Out.SendMessage(
                "You hit " + victim.Name + " for " + ad.Damage + " extra damage!",
                eChatType.CT_Spell, eChatLoc.CL_SystemWindow);

            striker.DealDamage(ad);
            Say(striker.Name + " marks " + victim.Name + " for " + ad.Damage +
                ", returned to " + mark.Vampiir.Name);
        }

        /// <summary>
        /// Fury of Nature: the Warden's damage comes back to the group as a
        /// spread heal. Spread across whoever is hurt and nearby, never more
        /// than the damage dealt, and never onto the Warden.
        ///
        /// **The style damage doubling is NOT restored here.** The core's
        /// version doubles AttackData.StyleDamage before the blow is applied,
        /// and TakeDamage arrives after, carrying a total with no style
        /// component to double. Doing it from here would mean guessing which
        /// part of the number came from the style. The healing half is the
        /// half the delve leads with, and it is the half that was doing
        /// nothing at all.
        /// </summary>
        private static void HealTheGrove(GameLiving striker, int damage)
        {
            if (striker.EffectList.GetOfType<FuryOfNatureEffect>() == null)
                return;

            if (striker is not GamePlayer warden || warden.Group == null)
                return;

            List<GamePlayer> hurt = new();

            foreach (GamePlayer mate in warden.Group.GetPlayersInTheGroup())
            {
                if (mate == warden || !mate.IsAlive)
                    continue;

                if (mate.Health < mate.MaxHealth && mate.IsWithinRadius(warden, 2000))
                    hurt.Add(mate);
            }

            if (hurt.Count == 0)
                return;

            int each = Math.Max(1, damage / hurt.Count);

            foreach (GamePlayer mate in hurt)
            {
                int missing = mate.MaxHealth - mate.Health;
                int heal = Math.Min(each, missing);

                if (heal <= 0)
                    continue;

                mate.ChangeHealth(warden, eHealthChangeType.Spell, heal);
                warden.Out.SendMessage("You heal " + mate.Name + " for " + heal + "!",
                    eChatType.CT_Spell, eChatLoc.CL_SystemWindow);
                mate.Out.SendMessage(warden.Name + " heals you for " + heal + "!",
                    eChatType.CT_Spell, eChatLoc.CL_SystemWindow);
            }

            Say(warden.Name + " returns " + damage + " to " + hurt.Count + " groupmate(s)");
        }

        public static void Say(string what)
        {
            if (LOG)
                Console.WriteLine("RA: " + what);
        }
    }

    /// <summary>
    /// Mark of Prey, with the Vampiir remembered.
    ///
    /// The core's effect keeps its caster in a private field and hands it to
    /// nothing, so from outside there is no way to know who to give the power
    /// back to. This subclass records both ends where they can be read.
    /// </summary>
    public class VampiirMark : MarkofPreyEffect
    {
        public GamePlayer Vampiir;
        public GamePlayer Bearer;

        public void Begin(GamePlayer vampiir, GamePlayer bearer)
        {
            Vampiir = vampiir;
            Bearer = bearer;
            Start(vampiir, bearer);
        }
    }

    /// <summary>
    /// The same ability, starting an effect that knows who cast it.
    ///
    /// Reached through the ability table's Implementation column, which
    /// migration 109 repoints at this class. Everything else about it -- the
    /// range, the duration, the group targeting, the reuse timer -- is the
    /// core's, inherited.
    /// </summary>
    public class MarkOfPreyThatPays : MarkOfPreyAbility
    {
        private const int RANGE = 1000;

        public MarkOfPreyThatPays(DbAbility dba, int level) : base(dba, level) { }

        public override void Execute(GameLiving living)
        {
            if (CheckPreconditions(living, DEAD | SITTING | MEZZED | STUNNED))
                return;

            if (living is not GamePlayer vampiir)
                return;

            ArrayList targets = new();

            if (vampiir.Group == null)
                targets.Add(vampiir);
            else
            {
                foreach (GamePlayer mate in vampiir.Group.GetPlayersInTheGroup())
                {
                    if (vampiir.IsWithinRadius(mate, RANGE) && mate.IsAlive)
                        targets.Add(mate);
                }
            }

            foreach (GamePlayer target in targets)
            {
                target.EffectList.GetOfType<MarkofPreyEffect>()?.Cancel(false);
                new VampiirMark().Begin(vampiir, target);
            }

            BlowsThatNeverLanded.Say(vampiir.Name + " marks " + targets.Count + " for prey");
            DisableSkill(living);
        }
    }
}
