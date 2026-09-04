using System;
using System.Collections.Generic;
using DOL.AI.Brain;
using DOL.GS.PacketHandler;
using DOL.GS.Spells;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// Befriend, which befriended nobody.
    ///
    /// Four spells in Phantasmal Wail turn monsters into realm guards for a
    /// while -- the class library calls it out as one of the things only she
    /// can do. What makes it happen is a FriendBrain, and the core attaches it
    /// from OnEffectStart(GameSpellEffect).
    ///
    /// That is the legacy effect callback and nothing calls it any more. Only
    /// GameSpellEffect itself does, and duration spells stopped making one --
    /// SpellHandler.OnDurationEffectApply builds an ECSGameSpellEffect
    /// instead. So the spell lands, the resist checks run, the duration is
    /// counted down, and the monster carries on exactly as it was.
    ///
    /// Identical to the Fear fault next door in SustainedPulse.cs, and fixed
    /// the same way: attach the brain where the effect is really applied, and
    /// take it back when the time is up.
    ///
    /// Both of the core's guards are repeated here, because the base returns
    /// before applying anything in either case and this code runs after it:
    /// Spell.Value is the highest level that may be befriended, and anything
    /// already under someone's control is refused.
    /// </summary>
    [SpellHandler(eSpellType.BeFriend)]
    public class Befriended : BeFriendSpellHandler
    {
        private sealed class Friendship
        {
            public FriendBrain Brain;
            public ECSGameTimer Until;
        }

        private static readonly Dictionary<GameNPC, Friendship> _friends = new();
        private static readonly object _lock = new();

        public Befriended(GameLiving caster, Spell spell, SpellLine line)
            : base(caster, spell, line) { }

        public override void ApplyEffectOnTarget(GameLiving target)
        {
            base.ApplyEffectOnTarget(target);

            if (target is not GameNPC npc || !npc.IsAlive)
                return;

            if (npc.Level > Spell.Value || npc.Brain is IControlledBrain)
                return;

            Befriend(npc, CalculateEffectDuration(target));
        }

        private void Befriend(GameNPC npc, int duration)
        {
            if (duration < 1)
                duration = Spell.Duration > 0 ? Spell.Duration * 1000 : 15000;

            lock (_lock)
            {
                if (_friends.TryGetValue(npc, out Friendship standing))
                {
                    // Already friendly: a second casting only extends it.
                    standing.Until?.Stop();
                    standing.Until = new ECSGameTimer(npc, _ => Forget(npc), duration);
                    standing.Until.Start(duration);
                    return;
                }

                // Whatever it was angry about is dropped as it changes sides,
                // which is the core's intent -- it clears the old aggro list
                // so the creature does not round on everyone when it reverts.
                (npc.Brain as IOldAggressiveBrain)?.ClearAggroList();

                FriendBrain brain = new(this);
                npc.AddBrain(brain);

                Friendship made = new() { Brain = brain };
                made.Until = new ECSGameTimer(npc, _ => Forget(npc), duration);
                made.Until.Start(duration);
                _friends[npc] = made;
            }

            npc.StopAttack();

            if (BainsheeAura.LOG)
                Console.WriteLine("Bainshee: " + Spell.Name + " -- " + npc.Name +
                                  " takes your side for " + duration + "ms");
        }

        private static int Forget(GameNPC npc)
        {
            lock (_lock)
            {
                if (!_friends.TryGetValue(npc, out Friendship standing))
                    return 0;

                _friends.Remove(npc);
                standing.Until?.Stop();
                npc.RemoveBrain(standing.Brain);
            }

            if (npc.Brain == null)
                npc.AddBrain(new StandardMobBrain());

            (npc.Brain as IOldAggressiveBrain)?.ClearAggroList();

            if (BainsheeAura.LOG)
                Console.WriteLine("Bainshee: " + npc.Name + " remembers itself");

            return 0;
        }
    }
}
