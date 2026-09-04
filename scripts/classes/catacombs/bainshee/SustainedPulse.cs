using System;
using System.Collections.Generic;
using DOL.AI.Brain;
using DOL.GS.Effects;
using DOL.GS.PacketHandler;
using DOL.GS.Spells;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// A sustained pulse that ends when the caster moves or dies.
    ///
    /// The auras in Phantasmal Wail are not the only thing she holds open.
    /// Her fear and her nearsight pulse too -- the class library calls the
    /// wail "sustained" and says the shriek lasts "until she finally stops to
    /// breathe" -- and neither of those is a BainsheePulseDmg, so the fix for
    /// the auras never saw them. Vanquishing Screech kept going through a walk
    /// across the zone.
    ///
    /// Movement is sampled rather than awaited, for the usual reason:
    /// GamePlayerEvent.Moving is never raised by this server. See
    /// docs/dead-events.md.
    /// </summary>
    public sealed class SustainedPulse
    {
        /// <summary>How far counts as having moved rather than having wobbled.</summary>
        private const int A_STEP = 32;

        private const int BEAT = 400;

        private readonly GameLiving _caster;
        private readonly Func<bool> _running;
        private readonly Action<string> _ended;

        private ECSGameTimer _feet;
        private Point3D _stood;

        public SustainedPulse(GameLiving caster, Func<bool> running, Action<string> ended)
        {
            _caster = caster;
            _running = running;
            _ended = ended;
        }

        public void Start()
        {
            if (_feet != null || _caster == null)
                return;

            _stood = new Point3D(_caster.X, _caster.Y, _caster.Z);
            _feet = new ECSGameTimer(_caster, Step, BEAT);
            _feet.Start(BEAT);
        }

        public void Stop()
        {
            if (_feet == null)
                return;

            _feet.Stop();
            _feet = null;
        }

        private int Step(ECSGameTimer timer)
        {
            if (_caster == null)
            {
                Stop();
                return 0;
            }

            if (!_caster.IsAlive)
            {
                Stop();
                _ended("the caster died");
                return 0;
            }

            // Ended by something else -- duration, another cast, cancelled by
            // hand. Nothing to say and nothing left to watch.
            if (!_running())
            {
                Stop();
                return 0;
            }

            // Both tests on purpose: IsMoving catches walking at the instant it
            // is read, the distance catches a step taken between two readings.
            if (_caster.IsMoving ||
                (_stood != null && _stood.GetDistanceTo(_caster) > A_STEP))
            {
                Stop();
                _ended("the caster moved");
                return 0;
            }

            return BEAT;
        }
    }

    /// <summary>
    /// Shared by the two handlers below, which differ only in what they
    /// inherit from. Both leave every non-pulsing spell of their type exactly
    /// as the core handles it -- and outside her lines there are none:
    /// all six pulsing Fears and all five pulsing Nearsights in the database
    /// belong to the Bainshee.
    /// </summary>
    internal static class Sustained
    {
        public static bool StillRunning(GameLiving caster, eSpellType type)
        {
            if (caster == null)
                return false;

            foreach (ECSPulseEffect effect in caster.effectListComponent.GetPulseEffects())
            {
                if (effect.SpellHandler?.Spell?.SpellType == type)
                    return true;
            }

            return false;
        }

        public static void Say(Spell spell, string why)
        {
            if (BainsheeAura.LOG)
                Console.WriteLine("Bainshee: " + spell.Name + " -- stopped -- " + why);
        }
    }

    /// <summary>
    /// Fear, which frightened nobody.
    ///
    /// The core attaches a FearBrain -- the thing that actually makes a
    /// creature turn and run -- from OnEffectStart(GameSpellEffect). That is
    /// the legacy effect callback, and the only place in the server that calls
    /// it is GameSpellEffect itself. Duration spells no longer make one:
    /// SpellHandler.OnDurationEffectApply builds an ECSGameSpellEffect
    /// instead, so OnEffectStart is never reached.
    ///
    /// The result is a fear spell that lands, shows its effect, holds its
    /// duration, and leaves the creature standing there hitting you. Nothing
    /// in the log, because from the server's point of view it worked.
    ///
    /// So the brain is attached here, where the effect is actually applied,
    /// and taken away again when the fear has run its course. The level test
    /// is the core's -- Spell.Value is the highest level this fear can touch,
    /// not a strength -- and it is repeated because the base class returns
    /// before applying anything when a creature is too big to frighten.
    /// </summary>
    [SpellHandler(eSpellType.Fear)]
    public class SustainedFear : FearSpellHandler
    {
        private SustainedPulse _watch;

        /// <summary>Who is currently running, and what to give them back.</summary>
        private static readonly Dictionary<GameNPC, Fright> _afraid = new();
        private static readonly object _lock = new();

        private sealed class Fright
        {
            public FearBrain Brain;
            public ECSGameTimer Until;
        }

        public SustainedFear(GameLiving caster, Spell spell, SpellLine line)
            : base(caster, spell, line) { }

        public override void ApplyEffectOnTarget(GameLiving target)
        {
            base.ApplyEffectOnTarget(target);

            if (target is not GameNPC npc || !npc.IsAlive)
                return;

            // The core's own rule: Value is the highest level it may frighten.
            if (npc.Level > Spell.Value)
                return;

            Frighten(npc, CalculateEffectDuration(target));
        }

        private void Frighten(GameNPC npc, int duration)
        {
            if (duration < 1)
                duration = Spell.Duration > 0 ? Spell.Duration * 1000 : 15000;

            lock (_lock)
            {
                if (_afraid.TryGetValue(npc, out Fright running))
                {
                    // Already fleeing: a later pulse only buys more time.
                    running.Until?.Stop();
                    running.Until = new ECSGameTimer(npc, _ => Calm(npc), duration);
                    running.Until.Start(duration);
                    return;
                }

                FearBrain brain = new();
                npc.AddBrain(brain);

                Fright fright = new() { Brain = brain };
                fright.Until = new ECSGameTimer(npc, _ => Calm(npc), duration);
                fright.Until.Start(duration);
                _afraid[npc] = fright;
            }

            npc.StopAttack();
            npc.StopFollowing();

            if (BainsheeAura.LOG)
                Console.WriteLine("Bainshee: " + Spell.Name + " -- " + npc.Name +
                                  " flees for " + duration + "ms");
        }

        /// <summary>Give the creature its own mind back.</summary>
        private static int Calm(GameNPC npc)
        {
            lock (_lock)
            {
                if (!_afraid.TryGetValue(npc, out Fright fright))
                    return 0;

                _afraid.Remove(npc);
                fright.Until?.Stop();
                npc.RemoveBrain(fright.Brain);
            }

            if (npc.Brain == null)
                npc.AddBrain(new StandardMobBrain());

            if (BainsheeAura.LOG)
                Console.WriteLine("Bainshee: " + npc.Name + " recovers its nerve");

            return 0;
        }

        public override void FinishSpellCast(GameLiving target)
        {
            base.FinishSpellCast(target);

            if (Spell.Pulse == 0 || Caster == null)
                return;

            _watch ??= new SustainedPulse(
                Caster,
                () => Sustained.StillRunning(Caster, Spell.SpellType),
                why =>
                {
                    if (!CancelPulsingSpell(Caster, Spell.SpellType))
                        return;

                    Sustained.Say(Spell, why);
                    MessageToCaster("You stop your " + Spell.Name + ".",
                        eChatType.CT_SpellExpires);
                });

            _watch.Start();
        }
    }

    [SpellHandler(eSpellType.Nearsight)]
    public class SustainedNearsight : NearsightSpellHandler
    {
        private SustainedPulse _watch;

        public SustainedNearsight(GameLiving caster, Spell spell, SpellLine line)
            : base(caster, spell, line) { }

        public override void FinishSpellCast(GameLiving target)
        {
            base.FinishSpellCast(target);

            if (Spell.Pulse == 0 || Caster == null)
                return;

            _watch ??= new SustainedPulse(
                Caster,
                () => Sustained.StillRunning(Caster, Spell.SpellType),
                why =>
                {
                    if (!CancelPulsingSpell(Caster, Spell.SpellType))
                        return;

                    Sustained.Say(Spell, why);
                    MessageToCaster("You stop your " + Spell.Name + ".",
                        eChatType.CT_SpellExpires);
                });

            _watch.Start();
        }
    }
}
