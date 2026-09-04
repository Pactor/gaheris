using System;
using DOL.GS.Effects;
using DOL.GS.PacketHandler;
using DOL.GS.ServerProperties;
using DOL.GS.Spells;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// The Bainshee's point blank aura, which could not be stopped.
    ///
    /// Seven spells in Phantasmal Wail pulse damage around her -- Shrill Aura
    /// at 1 up to Sonorous Aura at 46. The core registers two ways of ending
    /// one, and neither worked.
    ///
    /// The first is GamePlayerEvent.Moving, which this server never raises.
    /// That is the Heretic's fault repeated, and it is dealt with the same
    /// way: her feet are sampled a few times a second rather than awaited.
    ///
    /// The second is subtler and would have bitten even with a working event.
    /// BainsheePulseDmgSpellHandler overrides CancelPulsingSpell, and the
    /// override cannot succeed:
    ///
    ///     PulsingSpellEffect effect = null; // concentrationEffects[i] as PulsingSpellEffect;
    ///
    ///     if (effect == null)
    ///         continue;
    ///
    /// The cast that finds the effect is commented out, so the variable is
    /// always null, the loop always continues, and the method always returns
    /// false. Nothing could cancel an aura at all -- including the Dying
    /// handler registered beside the Moving one, which does fire, calls
    /// straight into this, and is told there was nothing to cancel.
    ///
    /// It walks the wrong list as well. Pulsing effects moved to
    /// ECSPulseEffect and effectListComponent.GetPulseEffects(); the override
    /// still searches concentration effects for the legacy PulsingSpellEffect,
    /// which is why the line had to be commented out in the first place.
    ///
    /// So the fix is in two halves. Restoring CancelPulsingSpell is what makes
    /// dying stop the aura, because that path was only ever broken here. The
    /// sampled timer is what makes moving stop it, because that path has no
    /// event to hang on.
    /// </summary>
    [SpellHandler(eSpellType.BainsheePulseDmg)]
    public class BainsheeAura : BainsheePulseDmgSpellHandler
    {
        [ServerProperty("catacombs", "bainshee_log",
            "Log when a Bainshee's aura starts and what stops it.", false)]
        public static bool LOG;

        /// <summary>How far counts as having moved rather than having wobbled.</summary>
        private const int A_STEP = 32;

        private const int BEAT = 400;

        private ECSGameTimer _feet;
        private Point3D _stood;

        public BainsheeAura(GameLiving caster, Spell spell, SpellLine line)
            : base(caster, spell, line) { }

        /// <summary>
        /// What the core's override was trying to do, against the list the
        /// effects actually live in. This is the base SpellHandler's own
        /// implementation -- it is repeated rather than called because the
        /// broken override sits between us and it.
        /// </summary>
        public override bool CancelPulsingSpell(GameLiving living, eSpellType spellType)
        {
            if (living == null)
                return false;

            foreach (ECSPulseEffect effect in living.effectListComponent.GetPulseEffects())
            {
                if (effect.SpellHandler?.Spell?.SpellType == spellType)
                {
                    effect.End();
                    return true;
                }
            }

            return false;
        }

        /// <summary>
        /// The pulse, without the crash.
        ///
        /// The core's version asks for a line of sight check on anything cone
        /// shaped or point blank:
        ///
        ///     if (!Caster.castingComponent.StartEndOfCastLosCheck(target, this))
        ///         DealDamage(target);
        ///
        /// and that method ignores the handler it is handed, reading the
        /// casting component's own current one instead:
        ///
        ///     public bool StartEndOfCastLosCheck(GameLiving target, SpellHandler spellHandler)
        ///     {
        ///         if (SpellHandler.LosChecker == null || ...
        ///
        /// During a pulse there is no cast in progress, so that property is
        /// null and the check throws. It surfaces as "Critical error
        /// encountered in EffectService" and drops whoever was channelling
        /// back to the character screen -- a rough way to discover that your
        /// point blank aura is point blank.
        ///
        /// So the check is only asked for when there is a cast to hang it on,
        /// which during a pulse there never is. The cost is that a pulse does
        /// not test line of sight, which is what every other branch of this
        /// handler already does, and a great deal better than disconnecting.
        /// </summary>
        public override void OnDirectEffect(GameLiving target)
        {
            if (target == null)
                return;

            bool wantsLos = Spell.Target is eSpellTarget.CONE ||
                            (Spell.Target is eSpellTarget.ENEMY && Spell.IsPBAoE);

            if (wantsLos &&
                Caster?.castingComponent?.SpellHandler != null &&
                Caster.castingComponent.StartEndOfCastLosCheck(target, this))
                return;

            Hit(target);
        }

        public override void OnEndOfCastLosCheck(GameLiving target, LosCheckResponse response)
        {
            if (response is LosCheckResponse.True)
                Hit(target);
        }

        /// <summary>The core's DealDamage, which is private to it.</summary>
        private void Hit(GameLiving target)
        {
            if (!target.IsAlive || target.ObjectState != GameObject.eObjectState.Active)
                return;

            AttackData ad = CalculateDamageToTarget(target);
            DamageTarget(ad, true);
            SendDamageMessages(ad);
            target.StartInterruptTimer(target.SpellInterruptDuration, ad.AttackType, Caster);
        }

        public override void FinishSpellCast(GameLiving target)
        {
            base.FinishSpellCast(target);

            if (Spell.Pulse == 0 || Caster == null)
                return;

            Watch();
        }

        private void Watch()
        {
            if (_feet != null)
                return;

            _stood = new Point3D(Caster.X, Caster.Y, Caster.Z);
            _feet = new ECSGameTimer(Caster, Step, BEAT);
            _feet.Start(BEAT);

            Say("started");
        }

        private void Unwatch()
        {
            if (_feet == null)
                return;

            _feet.Stop();
            _feet = null;
        }

        /// <summary>
        /// A few times a second: is she still alive, is the aura still
        /// running, and has she moved.
        ///
        /// Both movement tests are here on purpose. IsMoving catches her
        /// walking at the instant it is read; the distance catches her having
        /// walked between two readings and stopped.
        /// </summary>
        private int Step(ECSGameTimer timer)
        {
            if (Caster == null)
            {
                Unwatch();
                return 0;
            }

            if (!Caster.IsAlive)
            {
                Stop("she died");
                return 0;
            }

            // Ended by something else -- its duration, another cast, the
            // player cancelling it. Nothing to say, and nothing left to watch.
            if (!Running())
            {
                Unwatch();
                return 0;
            }

            bool moving = Caster.IsMoving;
            bool shifted = _stood != null && _stood.GetDistanceTo(Caster) > A_STEP;

            if (moving || shifted)
            {
                Stop("she moved");
                return 0;
            }

            return BEAT;
        }

        private bool Running()
        {
            foreach (ECSPulseEffect effect in Caster.effectListComponent.GetPulseEffects())
            {
                if (effect.SpellHandler?.Spell?.SpellType == Spell.SpellType)
                    return true;
            }

            return false;
        }

        private void Stop(string why)
        {
            Unwatch();

            if (!CancelPulsingSpell(Caster, Spell.SpellType))
                return;

            Say("stopped -- " + why);
            MessageToCaster("You stop your " + Spell.Name + ".", eChatType.CT_SpellExpires);
        }

        private void Say(string what)
        {
            if (LOG)
                Console.WriteLine("Bainshee: " + Spell.Name + " -- " + what +
                                  " (" + (Caster?.Name ?? "?") + ")");
        }
    }
}
