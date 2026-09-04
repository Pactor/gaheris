using System;
using DOL.Events;
using DOL.GS.Effects;
using DOL.GS.PacketHandler;
using DOL.GS.ServerProperties;
using DOL.GS.Spells;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// A Heretic's channelled fire grows the longer it is held.
    ///
    /// This is the class. "The channeled focus damage spells start slowly but
    /// will eventually ramp up over the course of 10-20 seconds to match that
    /// of a pure damage dealing caster." Hold the channel and the damage
    /// climbs; break it and you start again from nothing. Everything else the
    /// Heretic does -- the shield stuns, the flexible weapon line, the
    /// uninterruptible variants -- exists to protect that channel.
    ///
    /// None of it happened. The core has a RampingDamageFocus handler that
    /// does exactly this, reading its growth per pulse and its ceiling from
    /// two repurposed columns:
    ///
    ///     double growthPercent    = Spell.LifeDrainReturn * 0.01;
    ///     double growthCapPercent = Spell.AmnesiaChance   * 0.01;
    ///     damageIncrease = Math.Min(pulseCount * growthPercent, growthCapPercent);
    ///
    /// -- and not one spell in this database is of that type. The Arawn's Fire
    /// spells are all HereticDamageOverTime, whose handler is an ordinary
    /// damage-over-time with no notion of growing at all. So a Heretic
    /// channelled, and the numbers never moved.
    ///
    /// Fixed at the handler rather than by retyping the spells, which keeps
    /// the two spell types doing their own jobs. It is safe to do here because
    /// the type is not shared: all twelve HereticDamageOverTime spells are the
    /// Arawn's line, every one of them Pulse 1 at Frequency 15 over a fifteen
    /// or sixteen second duration. There is no spell of this type that ought
    /// not to ramp. The Pulse check below keeps that true even if one is ever
    /// added.
    ///
    /// The growth figures are not in any data we hold -- the only description
    /// is the sentence above -- so they are server properties rather than
    /// constants, and the defaults follow from the spells themselves: sixteen
    /// seconds at a pulse every 1.5 gives about ten pulses, so ten percent a
    /// pulse reaches double damage exactly as the channel runs out. That is
    /// what "starts slowly and ends matching a pure caster" describes for a
    /// hybrid who starts at about half one.
    /// </summary>
    [SpellHandler(eSpellType.HereticDamageOverTime)]
    public class GaherisHereticRamp : HereticDoTSpellHandler
    {
        [ServerProperty("gaheris", "gaheris_heretic_ramp_per_pulse",
            "How much a Heretic's channelled fire grows with each pulse, as a " +
            "percentage of its base damage. 0 disables the ramp.", 10)]
        public static int RAMP_PER_PULSE;

        [ServerProperty("gaheris", "gaheris_heretic_ramp_cap",
            "The most a Heretic's channelled fire can grow, as a percentage of " +
            "its base damage. 100 means it can reach double.", 100)]
        public static int RAMP_CAP;

        private int _pulses;
        private GameLiving _channelling;

        public GaherisHereticRamp(GameLiving caster, Spell spell, SpellLine line)
            : base(caster, spell, line)
        {

        }

        /// <summary>Only a held channel grows. A one-shot damage-over-time does not.</summary>
        private bool Ramps => Spell.Pulse > 0 && RAMP_PER_PULSE > 0;

        /// <summary>
        /// Each beat of the channel, and the beat has to deal the damage.
        ///
        /// This is why the spell pulsed and nothing ever landed. These spells
        /// carry Pulse 1, so the core drives them from the caster's side
        /// through OnSpellPulse -- but the Heretic handler only ever put its
        /// damage in OnEffectPulse, the target-side tick, and never overrode
        /// OnSpellPulse at all. So the aura beat away and nothing was ever
        /// asked to work out damage.
        ///
        /// The core's own RampingDamageFocus does exactly what is missing:
        ///
        ///     pulseCount += 1;
        ///     OnDirectEffect(Target);
        ///
        /// which is the shape followed here.
        /// </summary>
        public override void OnSpellPulse(PulsingSpellEffect effect)
        {
            base.OnSpellPulse(effect);

            GameLiving at = Caster?.TargetObject as GameLiving ?? _channelling;

            if (at == null || !at.IsAlive || Caster == null)
                return;

            // The channel holds only while the caster keeps his target and
            // stays in reach. Losing either is what resets the growth.
            if (Caster.TargetObject != at ||
                !Caster.IsWithinRadius(at, Spell.CalculateEffectiveRange(Caster)))
            {
                Console.WriteLine("Heretic: " + Spell.Name + " channel broken after " +
                                  _pulses + " pulses");
                _pulses = 0;
                return;
            }

            if (Ramps)
                _pulses++;

            OnDirectEffect(at);
        }

        /// <summary>
        /// The channel ticking. This is what actually carries the damage --
        /// OnEffectPulse leads to OnDirectEffect -- and it is also where the
        /// core gives up, cancelling silently if the caster has moved out of
        /// range, lost the target, or run out of power. Worth saying which.
        /// </summary>
        public override void OnEffectPulse(GameSpellEffect effect)
        {
            if (Caster != null && effect?.Owner != null)
            {
                bool inRange = Caster.IsWithinRadius(effect.Owner, Spell.CalculateEffectiveRange(Caster));
                bool onTarget = Caster.TargetObject == effect.Owner;
                bool hasPower = Caster.Mana >= Spell.PulsePower;

                if (!inRange || !onTarget || !hasPower)
                    Console.WriteLine("Heretic: " + Spell.Name + " channel breaking -- " +
                                      (inRange ? "" : "out of range ") +
                                      (onTarget ? "" : "target lost ") +
                                      (hasPower ? "" : "no power"));
            }

            base.OnEffectPulse(effect);
        }

        /// <summary>
        /// The damage as it stands after however long the channel has been
        /// held. Applied here because every path to damage passes through it,
        /// so the growth cannot be missed by one of them.
        /// </summary>
        public override AttackData CalculateDamageToTarget(GameLiving target)
        {
            AttackData ad = base.CalculateDamageToTarget(target);
            int baseDamage = ad.Damage;

            if (Ramps && _pulses > 0)
            {
                int grown = _pulses * RAMP_PER_PULSE;

                if (grown > RAMP_CAP)
                    grown = RAMP_CAP;

                ad.Damage += ad.Damage * grown / 100;
            }

            // Temporary, while the channel is being trusted. The visual worked
            // and nothing landed, and there are several places that could
            // swallow it -- the pulse cancels on range, on losing the target,
            // or on power -- so this says what the damage actually was.
            Console.WriteLine("Heretic: " + Spell.Name + " pulse " + _pulses +
                              " base " + baseDamage + " -> " + ad.Damage +
                              " on " + (target == null ? "?" : target.Name) +
                              " (" + ad.AttackResult + ")");

            return ad;
        }

        /// <summary>
        /// A broken channel starts again from nothing, which is the whole
        /// tension of the class: the Heretic is asking to be left alone for
        /// sixteen seconds and everyone else is trying to stop him.
        /// </summary>
        public override void OnEffectStart(GameSpellEffect effect)
        {
            _pulses = 0;
            base.OnEffectStart(effect);
        }

        public override void FinishSpellCast(GameLiving target)
        {
            _channelling = target;
            base.FinishSpellCast(target);
        }

        /// <summary>
        /// This is the beat of the channel, whatever its name suggests.
        ///
        /// Tracing the cast shows the pulse machinery calling StartSpell and
        /// then ApplyEffectOnTarget, over and over, for as long as the channel
        /// holds. OnEffectStart never fires, neither pulse hook fires, and
        /// OnDirectEffect -- the only thing in the whole handler that deals
        /// damage -- is never called at all. So the aura re-applied itself
        /// every beat and nothing was ever hurt.
        ///
        /// The damage is therefore dealt here, where the beat actually
        /// arrives, and the growth counted with it.
        /// </summary>
        public override void ApplyEffectOnTarget(GameLiving target)
        {
            base.ApplyEffectOnTarget(target);

            // Everything that should end a channel, and none of it did.
            //
            // The core knows the list -- HereticPiercingMagic.BeginEffect
            // registers handlers for moving, attacking, being attacked and
            // casting -- and nothing ever calls BeginEffect, so none of them
            // were ever hooked up. The result was a channel that carried on
            // through the target's death, through losing it, and through
            // walking away, because nothing was watching for any of that.
            // Watch for the step itself. Testing IsMoving at pulse time only
            // catches somebody who happens to be moving on the beat -- walk
            // between two pulses and stop, and it reads false both times,
            // which is why the channel carried on through a walk. The event
            // fires on the step.
            Watch();

            string over = Ended(target);

            if (over != null)
            {
                if (_pulses > 0)
                    Say("channel ended after " + _pulses + " pulses -- " + over);

                _pulses = 0;
                Unwatch();
                MessageToCaster("You lose your concentration.", eChatType.CT_SpellExpires);
                CancelPulsingSpell(Caster, Spell.SpellType);
                return;
            }

            OnDirectEffect(target);

            if (Ramps)
                _pulses++;
        }

        public override void OnDirectEffect(GameLiving target)
        {
            base.OnDirectEffect(target);
        }

        public override bool StartSpell(GameLiving target)
        {
            return base.StartSpell(target);
        }

        /// <summary>
        /// Why the channel is over, or null while it holds. A Heretic asks to
        /// be left alone with one target for sixteen seconds; this is the list
        /// of things that refuse him.
        /// </summary>
        private string Ended(GameLiving target)
        {
            if (Caster == null || !Caster.IsAlive)
                return "the caster is gone";

            // "Caster may not do anything else while spell is in effect."
            // Sitting and swinging both count, and both are listed as
            // interrupting a focus channel.
            if (Caster is GamePlayer resting && resting.IsSitting)
                return "the caster sat down";

            if (Caster.attackComponent != null && Caster.attackComponent.AttackState)
                return "the caster attacked";

            if (target == null || !target.IsAlive ||
                target.ObjectState != GameObject.eObjectState.Active)
                return "the target is dead";

            if (Caster.TargetObject != target)
                return "the target was lost";

            if (!Caster.IsWithinRadius(target, Spell.CalculateEffectiveRange(Caster)))
                return "out of range";

            return null;
        }

        private bool _watching;

        /// <summary>
        /// Notice the moment the caster takes a step, or is struck.
        ///
        /// The rules are the 1.616 spell data's, not a preference: a focus
        /// channel "cannot be interrupted by ranged attacks" -- archery,
        /// crossbows and spells -- and "can be interrupted by melee attacks
        /// and sitting". That distinction only applies to the three
        /// uninterruptible ones; everything else breaks on any of it.
        /// </summary>
        private void Watch()
        {
            if (_watching || Caster == null)
                return;

            _watching = true;
            GameEventMgr.AddHandler(Caster, GamePlayerEvent.Moving, new DOLEventHandler(Moved));
            GameEventMgr.AddHandler(Caster, GameLivingEvent.AttackedByEnemy, new DOLEventHandler(Struck));
        }

        private void Unwatch()
        {
            if (!_watching || Caster == null)
                return;

            _watching = false;
            GameEventMgr.RemoveHandler(Caster, GamePlayerEvent.Moving, new DOLEventHandler(Moved));
            GameEventMgr.RemoveHandler(Caster, GameLivingEvent.AttackedByEnemy, new DOLEventHandler(Struck));
        }

        /// <summary>
        /// Struck while channelling. A melee blow always breaks it. Anything
        /// at range -- an arrow, a bolt, a spell -- breaks the ordinary
        /// channels and is exactly what the three Blazes are for.
        /// </summary>
        private void Struck(DOLEvent e, object sender, EventArgs args)
        {
            if (args is not AttackedByEnemyEventArgs hit || hit.AttackData == null)
                return;

            bool melee = hit.AttackData.IsMeleeAttack;

            if (!melee && Spell.Uninterruptible)
                return;

            Break(melee ? "struck in melee" : "struck from range");
        }

        private void Break(string why)
        {
            if (_pulses > 0)
                Say("channel ended after " + _pulses + " pulses -- " + why);

            _pulses = 0;
            Unwatch();
            MessageToCaster("You lose your concentration.", eChatType.CT_SpellExpires);
            CancelPulsingSpell(Caster, Spell.SpellType);
        }

        private void Moved(DOLEvent e, object sender, EventArgs args)
        {
            Break("the caster moved");
        }

        private void Say(string what)
        {
            Console.WriteLine("Heretic: " + Spell.Name + " -- " + what);
        }

        public override int OnEffectExpires(GameSpellEffect effect, bool noMessages)
        {
            Console.WriteLine("Heretic: " + Spell.Name + " effect expired after " +
                              _pulses + " pulses");
            return base.OnEffectExpires(effect, noMessages);
        }
    }
}
