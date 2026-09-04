using System;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// Watches a living for the things that are supposed to break a held
    /// effect, and cannot be waited for.
    ///
    /// Moving, attacking and starting a cast are all supposed to end various
    /// effects in this server, and all three are announced through events
    /// nothing raises -- GamePlayerEvent.Moving, AttackFinished and
    /// CastStarting. Forty-three files in the core subscribe to one of them.
    /// See docs/dead-events.md.
    ///
    /// Everything they announced is still readable, just not as an event, so
    /// this samples instead of listening:
    ///
    ///   moving   IsMoving, plus distance from where the watch began, because
    ///            IsMoving alone misses a step taken between two readings
    ///   attacked LastAttackTick moving past where it started
    ///   casting  castingComponent.SpellHandler being non-null
    ///
    /// Whoever creates it says which of those to care about, and gets a
    /// callback naming the one that fired. The watch stops itself first, so a
    /// callback is delivered exactly once.
    /// </summary>
    public sealed class MovementWatch
    {
        /// <summary>Far enough to be a step rather than a wobble.</summary>
        private const int A_STEP = 32;

        private const int BEAT = 400;

        private readonly GameLiving _who;
        private readonly Action<string> _broke;
        private readonly Func<bool> _stillWanted;
        private readonly bool _onMove;
        private readonly bool _onAttack;
        private readonly bool _onCast;

        private ECSGameTimer _timer;
        private Point3D _stood;
        private long _lastAttack;

        /// <param name="who">The living to watch.</param>
        /// <param name="broke">Called once, with the reason, when something breaks it.</param>
        /// <param name="stillWanted">
        /// Optional. Return false when the effect has ended some other way, so
        /// the watch can stop without saying anything.
        /// </param>
        public MovementWatch(GameLiving who, Action<string> broke,
                             Func<bool> stillWanted = null,
                             bool onMove = true, bool onAttack = false, bool onCast = false)
        {
            _who = who;
            _broke = broke;
            _stillWanted = stillWanted;
            _onMove = onMove;
            _onAttack = onAttack;
            _onCast = onCast;
        }

        public void Start()
        {
            if (_timer != null || _who == null)
                return;

            _stood = new Point3D(_who.X, _who.Y, _who.Z);
            _lastAttack = Math.Max(_who.LastAttackTickPvE, _who.LastAttackTickPvP);
            _timer = new ECSGameTimer(_who, Beat, BEAT);
            _timer.Start(BEAT);
        }

        public void Stop()
        {
            if (_timer == null)
                return;

            _timer.Stop();
            _timer = null;
        }

        private int Beat(ECSGameTimer timer)
        {
            if (_who == null || !_who.IsAlive)
            {
                Stop();
                return 0;
            }

            if (_stillWanted != null && !_stillWanted())
            {
                Stop();
                return 0;
            }

            string why = Broken();

            if (why == null)
                return BEAT;

            Stop();

            try
            {
                _broke?.Invoke(why);
            }
            catch (Exception)
            {
                // A cancel that throws is not worth taking a service down for.
            }

            return 0;
        }

        private string Broken()
        {
            if (_onMove && (_who.IsMoving ||
                            (_stood != null && _stood.GetDistanceTo(_who) > A_STEP)))
                return "moving";

            if (_onAttack && Math.Max(_who.LastAttackTickPvE, _who.LastAttackTickPvP) > _lastAttack)
                return "attacking";

            if (_onCast && _who.castingComponent?.SpellHandler != null)
                return "casting";

            return null;
        }
    }
}
