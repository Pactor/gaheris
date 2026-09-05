using System;
using DOL.GS.PacketHandler;
using DOL.GS.ServerProperties;
using DOL.GS.Spells;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// Focus Shell: Nature's Cocoon, Hand of God and Spirit Shell.
    ///
    /// One spell each for the Druid, the Cleric and the Shaman, absorbing 90,
    /// 85 and 70 percent of the damage their target takes while the caster
    /// stands still and pays for it.
    ///
    /// The levels are *spec* levels, not character levels: 47 in Druid
    /// Nurture, 46 in Cleric Enhancement, 41 in Shaman Augmentation. Each
    /// lives in a line whose ClassIDHint names one class, so Augmentation
    /// being shared with the Healer and the Seer does not give either of them
    /// Spirit Shell.
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
    public class FocusShellThatAbsorbs : SpellHandler
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

        /// <summary>
        /// Core's own version of this check can never pass, and that is why the
        /// spell has never been castable.
        ///
        /// `FocusShellHandler.CheckBeginCast` reads the target straight out of
        /// its parameter and refuses anything that is not a GamePlayer:
        ///
        ///     if (selectedTarget is GamePlayer) { FSTarget = ...; }
        ///     else return false;          // silent
        ///
        /// But in the ECS cast flow that parameter is null. The real target is
        /// resolved *inside* `SpellHandler.CheckBeginCast`, from
        /// `playerCaster.TargetObject`, which happens only after core's handler
        /// has already returned false. Twelve presses were logged and the
        /// parameter was null every single time, with a target selected and
        /// without.
        ///
        /// So the check is skipped rather than delegated to -- this class
        /// derives from SpellHandler, not FocusShellHandler -- and the same
        /// rules are applied here against a target resolved the way the rest of
        /// the server resolves one. And it says why when it refuses, instead of
        /// leaving a button that does nothing.
        /// </summary>
        public override bool CheckBeginCast(GameLiving selectedTarget)
        {
            GameLiving who = selectedTarget
                          ?? Caster?.TargetObject as GameLiving
                          ?? Caster;

            if (who is GameNPC)
            {
                MessageToCaster("This spell may not be cast on pets!", eChatType.CT_SpellResisted);
                return false;
            }

            if (who is not GamePlayer)
            {
                MessageToCaster("This spell only works on members of your realm!", eChatType.CT_SpellResisted);
                return false;
            }

            if (!GameServer.ServerRules.IsSameRealm(Caster, who, true))
            {
                MessageToCaster("This spell only works on members of your realm!", eChatType.CT_SpellResisted);
                return false;
            }

            // A beneficial spell with nothing selected lands on the caster,
            // which is how it behaves in the client. Said plainly here because
            // SpellHandler re-reads TargetObject and would otherwise refuse.
            if (Caster?.TargetObject == null && Caster is GamePlayer self)
                self.TargetObject = self;

            Target = who;

            bool allowed;
            string trouble = null;

            try
            {
                allowed = base.CheckBeginCast(who);
            }
            catch (System.Exception e)
            {
                allowed = false;
                trouble = e.GetType().Name + ": " + e.Message;
            }

            if (LOG)
            {
                Console.WriteLine("FocusShell: CheckBeginCast by " + (Caster?.Name ?? "?") +
                                  "  on " + (who?.Name ?? "null") +
                                  "  handlerTarget=" + (Target?.Name ?? "null") +
                                  " -> " + allowed +
                                  (trouble == null ? "" : "  THREW " + trouble));
            }

            return allowed;
        }

        public override void FinishSpellCast(GameLiving target)
        {
            if (LOG)
                Console.WriteLine("FocusShell: FinishSpellCast on " + (target?.Name ?? "none"));

            base.FinishSpellCast(target);
        }

        public override void ApplyEffectOnTarget(GameLiving target)
        {
            if (LOG)
                Console.WriteLine("FocusShell: ApplyEffectOnTarget on " + (target?.Name ?? "none"));

            base.ApplyEffectOnTarget(target);
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
        /// Druid, 85 for the Cleric, 70 for the Shaman.
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
