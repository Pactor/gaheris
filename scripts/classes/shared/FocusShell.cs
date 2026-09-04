using System;
using DOL.GS.PacketHandler;
using DOL.GS.ServerProperties;
using DOL.GS.Spells;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// Focus Shell: Nature's Cocoon, Hand of God and Spirit Shell.
    ///
    /// One spell each for the Druid at 47, the Cleric at 46 and the Healer at
    /// 41 -- the primary healer of every realm -- absorbing 90, 85 and 70
    /// percent of the damage their target takes while the caster stands still
    /// and pays for it.
    ///
    /// **None of it happened.** The core handler puts the whole spell in
    /// `OnEffectStart(GameSpellEffect)`, and nothing calls that handler's
    /// `CreateSpellEffect`, so the callback is never reached: no absorption
    /// installed, no power drain started, nothing watching for it to end. What
    /// a player got was `FocusECSEffect`, which prints "Lashing energy ripples
    /// around you" and does nothing else. The spell has been flavour text.
    ///
    /// Rebuilt here on top of `GaherisPlayer` and `DamageGate`, which is what
    /// lets an effect shrink a blow at all.
    ///
    /// Three things the core intended have to be done here rather than left to
    /// it, and it is worth saying why:
    ///
    ///   the absorption   was on the dead AttackedByEnemy event
    ///   the power drain  was on a timer the dead callback never started
    ///   the cancelling   cannot come from the core's own focus machinery.
    ///                    `CancelFocusSpells` only ends effects of type Pulse,
    ///                    and these spells carry Pulse 0, so nothing in core
    ///                    can end this one. It ends itself.
    ///
    /// The tick is the spell's own: `Spell.Frequency` is the database column
    /// times a hundred, so the 5 these rows carry means every 500ms, and
    /// `PulsePower` of 10 is 20 power a second. That is a heavy sustain, which
    /// is what a 90 percent absorb should cost.
    /// </summary>
    [SpellHandler(eSpellType.FocusShell)]
    public class FocusShellThatAbsorbs : FocusShellHandler
    {
        /// <summary>
        /// Core refuses to absorb damage from anything whose realm is None,
        /// which is every monster in the game:
        ///
        ///     if (attackArgs.AttackData.Attacker.Realm != eRealm.None)
        ///
        /// Left as core has it, the spell would still do nothing here, because
        /// nothing on a co-operative server has a realm. Turned on by default
        /// because a spell that does nothing is not a working spell -- but it
        /// is a large change either way, so it is a switch rather than a
        /// decision baked into the code.
        /// </summary>
        [ServerProperty("gaheris", "focus_shell_absorbs_monsters",
            "Whether Focus Shell absorbs damage from monsters. Core only ever " +
            "absorbed damage from things with a realm, which on a co-operative " +
            "server means it absorbs nothing at all. Off restores core's " +
            "behaviour.", true)]
        public static bool ABSORBS_MONSTERS;

        [ServerProperty("gaheris", "focus_shell_log",
            "Narrate every Focus Shell: what it absorbs, what it drains and " +
            "why it ends. For diagnosis rather than for leaving on.", false)]
        public static bool LOG;

        public FocusShellThatAbsorbs(GameLiving caster, Spell spell, SpellLine line)
            : base(caster, spell, line) { }

        public override ECSGameSpellEffect CreateECSEffect(in ECSGameEffectInitParams initParams)
        {
            return ECSGameEffectFactory.Create(initParams, static (in i) => new FocusShellEffect(i));
        }
    }

    public class FocusShellEffect : ECSGameSpellEffect, ISoftensDamage
    {
        private GameLiving _caster;
        private ECSGameTimer _drain;
        private MovementWatch _casterWatch;
        private MovementWatch _targetWatch;
        private bool _ending;

        public FocusShellEffect(in ECSGameEffectInitParams initParams)
            : base(initParams) { }

        public override void OnStartEffect()
        {
            base.OnStartEffect();

            _caster = SpellHandler?.Caster;

            if (Owner == null || _caster == null)
                return;

            DamageGate.Register(Owner, this);

            // The caster is holding a focus. Moving or swinging ends it.
            // Casting is deliberately not watched: the caster's spell handler
            // stays set for as long as the focus is held, so watching for a
            // cast would end the spell the instant it began.
            _casterWatch = new MovementWatch(_caster, why => Finish("the caster " + why),
                                             () => !_ending, onMove: true, onAttack: true);
            _casterWatch.Start();

            // And the protected one must stay out of the fight, which is what
            // core's two handlers on the target were for.
            if (Owner != _caster)
            {
                _targetWatch = new MovementWatch(Owner, why => Finish("the target " + why),
                                                 () => !_ending, onMove: false,
                                                 onAttack: true, onCast: true);
                _targetWatch.Start();
            }

            int tick = Math.Max(100, SpellHandler.Spell.Frequency);
            _drain = new ECSGameTimer(_caster, Drain, tick);
            _drain.Start(tick);

            Say("held on " + Owner.Name + ", absorbing " + SpellHandler.Spell.Value + "%");
        }

        public override void OnStopEffect()
        {
            base.OnStopEffect();

            _ending = true;
            DamageGate.Unregister(Owner, this);

            _casterWatch?.Stop();
            _targetWatch?.Stop();
            _drain?.Stop();

            _casterWatch = null;
            _targetWatch = null;
            _drain = null;
        }

        /// <summary>
        /// The blow, made smaller. Percentages come from the spell: 90 for the
        /// Druid, 85 for the Cleric, 70 for the Healer.
        /// </summary>
        public void Soften(AttackData ad)
        {
            if (ad == null || SpellHandler?.Spell == null || _ending)
                return;

            if (ad.Attacker != null && ad.Attacker.Realm is eRealm.None &&
                !FocusShellThatAbsorbs.ABSORBS_MONSTERS)
                return;

            double share = SpellHandler.Spell.Value * 0.01;

            if (share <= 0)
                return;

            int wasDamage = ad.Damage;
            int wasCritical = ad.CriticalDamage;

            ad.Damage -= (int) (ad.Damage * share);
            ad.CriticalDamage -= (int) (ad.CriticalDamage * share);

            int taken = wasDamage - ad.Damage + (wasCritical - ad.CriticalDamage);

            if (taken > 0)
                Say("absorbed " + taken + " for " + Owner.Name);
        }

        /// <summary>
        /// The sustain. Out of power, or the target out of reach, and it ends.
        /// </summary>
        private int Drain(ECSGameTimer timer)
        {
            if (_ending || _caster == null || Owner == null || SpellHandler?.Spell == null)
                return 0;

            if (!_caster.IsAlive || !Owner.IsAlive)
            {
                Finish("someone died");
                return 0;
            }

            if (!_caster.IsWithinRadius(Owner, SpellHandler.Spell.Range))
            {
                Finish("the target went out of range");
                return 0;
            }

            if (_caster.Mana < SpellHandler.Spell.PulsePower)
            {
                Finish("the caster ran out of power");
                return 0;
            }

            _caster.Mana -= SpellHandler.Spell.PulsePower;

            // Holding a focus keeps the caster in combat, so that he is not
            // regenerating the power he is spending. Core stamped the PvP
            // tick; on this server the fight is always PvE.
            _caster.LastAttackTickPvE = GameLoop.GameLoopTime;

            return Math.Max(100, SpellHandler.Spell.Frequency);
        }

        private void Finish(string why)
        {
            if (_ending)
                return;

            _ending = true;
            Say("ended -- " + why);

            if (_caster is GamePlayer caster)
                caster.Out.SendMessage("You lose your concentration.", eChatType.CT_SpellExpires, eChatLoc.CL_SystemWindow);

            End();
        }

        private void Say(string what)
        {
            if (FocusShellThatAbsorbs.LOG)
                Console.WriteLine("FocusShell: " + (SpellHandler?.Spell?.Name ?? "?") + " -- " + what);
        }
    }
}
