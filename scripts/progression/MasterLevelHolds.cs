using System;
using DOL.GS.Effects;
using DOL.GS.PacketHandler;
using DOL.GS.ServerProperties;
using DOL.GS.Spells;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// Master Level effects that were supposed to end and never did.
    ///
    /// Six ML abilities cancel themselves when the holder moves, attacks or
    /// casts, and all six register that on events this server does not raise.
    /// The failure is silent and it runs the wrong way: the ability does not
    /// break, so it is *stronger* than it should be, and nothing in the log
    /// says why.
    ///
    /// Every class in the game reaches all six -- ML lines are shared, so this
    /// is not a Bainshee or a Heretic problem, it is everybody's.
    ///
    ///   Spymaster 7   Lookout                should end when either party moves
    ///   Spymaster 10  Blanket of Camouflage  should break on moving, attacking or casting
    ///   Convoker 6    Battlewarder           should end when the caster moves, casts or attacks
    ///   Stormlord 6   Focusing Winds         should end when the caster moves
    ///
    /// All four are done here.
    ///
    /// Two more ride the same dead events and are NOT holds at all, which an
    /// earlier note in this project got wrong. Forceful Zephyr and Phaseshift
    /// do not cancel when their owner is attacked -- they *absorb the blow*:
    ///
    ///     ad.Damage -= damageAbsorbed;              // Zephyr, 100%
    ///     ad.Damage = 0; ad.CriticalDamage = 0;     // Phaseshift
    ///
    /// So the failure there is lost immunity rather than an ability that never
    /// ends, and it cannot be repaired the way these four can: both edit the
    /// AttackData before the blow lands, and the only live hook arrives after
    /// the damage is already dealt. Phaseshift is additionally written to
    /// answer only `ad.Attacker is GamePlayer`, so on a co-operative server it
    /// would do nothing even working. Both are recorded in
    /// docs/master-levels.md rather than approximated with a heal.
    /// </summary>
    internal static class MasterLevelHolds
    {
        [ServerProperty("progression", "ml_holds_log",
            "Log when a Master Level effect is broken by moving, attacking or casting.", false)]
        public static bool LOG;

        public static void Say(string what)
        {
            if (LOG)
                Console.WriteLine("ML: " + what);
        }
    }

    /// <summary>
    /// Stormlord 6. Locks a storm in place for as long as the caster stands
    /// still -- "Now the vortex of this storm is locked!" -- and the moving
    /// half never worked, so the lock was permanent for the spell's duration.
    /// </summary>
    [SpellHandler(eSpellType.FocusingWinds)]
    public class FocusingWindsHeld : FocusingWindsSpellHandler
    {
        private MovementWatch _watch;

        public FocusingWindsHeld(GameLiving caster, Spell spell, SpellLine line)
            : base(caster, spell, line) { }

        public override void OnEffectStart(GameSpellEffect effect)
        {
            base.OnEffectStart(effect);

            if (effect?.Owner is not GameStorm || Caster == null)
                return;

            // The effect is captured here rather than read from a field. The
            // core keeps one, and a handler instance is shared, so a second
            // cast would have the first one cancelling the wrong storm.
            GameSpellEffect held = effect;

            _watch?.Stop();
            _watch = new MovementWatch(
                Caster,
                why =>
                {
                    MasterLevelHolds.Say(Spell.Name + " released -- " + why);
                    MessageToCaster("You are moving. Your concentration fades",
                        eChatType.CT_SpellExpires);
                    OnEffectExpires(held, true);
                });

            _watch.Start();
        }

        public override int OnEffectExpires(GameSpellEffect effect, bool noMessages)
        {
            _watch?.Stop();
            _watch = null;
            return base.OnEffectExpires(effect, noMessages);
        }
    }

    /// <summary>
    /// Spymaster 10. Stealths the caster's whole group, and is supposed to
    /// drop off anyone who moves, attacks or casts. None of those three
    /// registered, so the only thing that ever removed it was dying -- which
    /// does fire -- leaving a group that could walk into a keep invisible.
    ///
    /// There is a second fault underneath. The core stores the effect in one
    /// field on the handler:
    ///
    ///     private GameSpellEffect m_effect;
    ///
    /// and a handler serves every member of the group in turn, so each new
    /// target overwrites the last. Whichever member broke stealth would cancel
    /// the effect belonging to whoever was hit last instead of their own. Each
    /// watch below closes over its own effect, so that cannot happen.
    /// </summary>
    [SpellHandler(eSpellType.BlanketOfCamouflage)]
    public class GroupstealthHeld : GroupstealthHandler
    {
        public GroupstealthHeld(GameLiving caster, Spell spell, SpellLine line)
            : base(caster, spell, line) { }

        public override void OnEffectStart(GameSpellEffect effect)
        {
            base.OnEffectStart(effect);

            // The caster keeps their own stealth by their own means; the core
            // only registers the breaking handlers for the rest of the group.
            if (effect?.Owner is not GamePlayer hidden || effect.Owner == Caster)
                return;

            GameSpellEffect theirs = effect;

            MovementWatch watch = new(
                hidden,
                why =>
                {
                    MasterLevelHolds.Say(hidden.Name + " loses " + Spell.Name + " -- " + why);
                    MessageToLiving(hidden, "You are " + why + ". Your camouflage fades!",
                        eChatType.CT_SpellResisted);
                    OnEffectExpires(theirs, true);
                },
                () => hidden.IsStealthed,
                onMove: true, onAttack: true, onCast: true);

            watch.Start();
        }
    }

    /// <summary>
    /// Spymaster 7. The Spymaster hides beside a seated companion and borrows
    /// a hundred points of stealth from them; if either of the two moves, the
    /// arrangement is over. Neither half of that worked, so the stealth held
    /// while both of them walked around.
    ///
    /// Two watches rather than one, because the core registered two: the
    /// sitter and the Spymaster are each able to end it.
    /// </summary>
    [SpellHandler(eSpellType.Loockout)]
    public class LookoutThatEnds : LoockoutSpellHandler
    {
        private MovementWatch _sitter;
        private MovementWatch _scout;

        public LookoutThatEnds(GameLiving caster, Spell spell, SpellLine line)
            : base(caster, spell, line) { }

        public override void OnEffectStart(GameSpellEffect effect)
        {
            base.OnEffectStart(effect);

            if (effect?.Owner is not GamePlayer sat || Caster is not GamePlayer scout)
                return;

            GameSpellEffect held = effect;

            void Ended(GameLiving who, string why)
            {
                MasterLevelHolds.Say(who.Name + " ends " + Spell.Name + " -- " + why);
                MessageToLiving(who, "You are moving. Your concentration fades!",
                    eChatType.CT_SpellResisted);

                // The companion's static effect is a separate object and has to
                // be taken down by hand, exactly as the core's own handler did.
                FindStaticEffectOnTarget(scout, typeof(LoockoutOwner))?.Cancel(false);
                OnEffectExpires(held, true);
            }

            _sitter?.Stop();
            _scout?.Stop();

            _sitter = new MovementWatch(sat, why => Ended(sat, why));
            _scout = new MovementWatch(scout, why => Ended(scout, why));
            _sitter.Start();
            _scout.Start();
        }

        public override int OnEffectExpires(GameSpellEffect effect, bool noMessages)
        {
            _sitter?.Stop();
            _scout?.Stop();
            _sitter = null;
            _scout = null;
            return base.OnEffectExpires(effect, noMessages);
        }
    }

    /// <summary>
    /// Convoker 6. Plants a warder at the ground target that fights for the
    /// caster while he stands still and does nothing else. Moving, casting or
    /// swinging is supposed to dismiss it; none of the three did, so the
    /// warder stayed for its full duration whatever its owner got up to.
    /// </summary>
    [SpellHandler(eSpellType.Battlewarder)]
    public class BattlewarderThatEnds : BattlewarderSpellHandler
    {
        private MovementWatch _watch;

        public BattlewarderThatEnds(GameLiving caster, Spell spell, SpellLine line)
            : base(caster, spell, line) { }

        public override void OnEffectStart(GameSpellEffect effect)
        {
            base.OnEffectStart(effect);

            if (effect?.Owner is not GamePlayer owner)
                return;

            GameSpellEffect held = effect;

            _watch?.Stop();
            _watch = new MovementWatch(
                owner,
                why =>
                {
                    MasterLevelHolds.Say(owner.Name + " dismisses " + Spell.Name + " -- " + why);
                    MessageToLiving(owner, "You are " + why + ". Your warder fades!",
                        eChatType.CT_SpellExpires);
                    OnEffectExpires(held, true);
                },
                null,
                onMove: true, onAttack: true, onCast: true);

            _watch.Start();
        }

        public override int OnEffectExpires(GameSpellEffect effect, bool noMessages)
        {
            _watch?.Stop();
            _watch = null;
            return base.OnEffectExpires(effect, noMessages);
        }
    }
}
