using System.Collections.Generic;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// Lets an effect shrink a blow before it lands.
    ///
    /// Several spells are written to reduce damage by editing the AttackData
    /// on its way past -- Focus Shell absorbs 70 to 90 percent of it, Phaseshift
    /// zeroes it, a Zephyr absorbs all of it. Every one of them hung that on
    /// `GameLivingEvent.AttackedByEnemy`, and nothing has raised that event
    /// since the ECS rewrite, so none of them ever absorbed anything.
    ///
    /// They could not be repaired from a script either. `GameObject.TakeDamage`
    /// raises its event with copied integers, so a handler can watch a blow but
    /// not shrink one, and the method that replaced the event --
    /// `GameLiving.OnAttackedByEnemy` -- is virtual but was on a class no
    /// script could stand in for.
    ///
    /// That is what `GaherisPlayer` is for. It overrides `OnAttackedByEnemy`
    /// and calls this on the way through, which is the right moment: both
    /// attack paths call that method immediately before applying the damage,
    /// and `WeaponAction` says so in a comment -- "should be before damage".
    ///
    /// Effects register themselves while they run and take themselves off when
    /// they end, so nothing here has to know which spells exist. Two softeners
    /// on the same living each shrink what the one before it left.
    /// </summary>
    public interface ISoftensDamage
    {
        /// <summary>Reduce the blow, or leave it alone. Called before it lands.</summary>
        void Soften(AttackData ad);
    }

    public static class DamageGate
    {
        private static readonly Dictionary<GameLiving, List<ISoftensDamage>> _held = new();
        private static readonly object _lock = new();

        public static void Register(GameLiving who, ISoftensDamage softener)
        {
            if (who == null || softener == null)
                return;

            lock (_lock)
            {
                if (!_held.TryGetValue(who, out List<ISoftensDamage> on))
                    _held[who] = on = new List<ISoftensDamage>(1);

                if (!on.Contains(softener))
                    on.Add(softener);
            }
        }

        public static void Unregister(GameLiving who, ISoftensDamage softener)
        {
            if (who == null || softener == null)
                return;

            lock (_lock)
            {
                if (!_held.TryGetValue(who, out List<ISoftensDamage> on))
                    return;

                on.Remove(softener);

                if (on.Count == 0)
                    _held.Remove(who);
            }
        }

        /// <summary>
        /// Every softener standing on this living gets a look at the blow.
        /// Copied out under the lock so a softener that ends itself while
        /// running cannot upset the walk.
        /// </summary>
        public static void Soften(GameLiving who, AttackData ad)
        {
            if (who == null || ad == null)
                return;

            ISoftensDamage[] softeners;

            lock (_lock)
            {
                if (!_held.TryGetValue(who, out List<ISoftensDamage> on) || on.Count == 0)
                    return;

                softeners = on.ToArray();
            }

            foreach (ISoftensDamage softener in softeners)
                softener.Soften(ad);
        }
    }
}
