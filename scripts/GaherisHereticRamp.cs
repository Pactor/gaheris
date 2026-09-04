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

        public GaherisHereticRamp(GameLiving caster, Spell spell, SpellLine line)
            : base(caster, spell, line)
        {
        }

        /// <summary>Only a held channel grows. A one-shot damage-over-time does not.</summary>
        private bool Ramps => Spell.Pulse > 0 && RAMP_PER_PULSE > 0;

        public override void OnSpellPulse(PulsingSpellEffect effect)
        {
            if (Ramps)
                _pulses++;

            base.OnSpellPulse(effect);
        }

        /// <summary>
        /// The damage as it stands after however long the channel has been
        /// held. Applied here because every path to damage passes through it,
        /// so the growth cannot be missed by one of them.
        /// </summary>
        public override AttackData CalculateDamageToTarget(GameLiving target)
        {
            AttackData ad = base.CalculateDamageToTarget(target);

            if (!Ramps || _pulses <= 0)
                return ad;

            int grown = _pulses * RAMP_PER_PULSE;

            if (grown > RAMP_CAP)
                grown = RAMP_CAP;

            ad.Damage += ad.Damage * grown / 100;
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
    }
}
