using System;
using DOL.AI.Brain;
using DOL.GS.Keeps;
using DOL.GS.Movement;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// Gaheris keep garrison for Old Frontiers.
    ///
    /// The frontier keeps are held by the forces of evil rather than by any
    /// realm, so a keep whose Realm is None gets a monster garrison instead of
    /// renamed realm soldiers. Guards inherit realm from their keep, or -- as
    /// here, where guards are mob rows rather than component-attached -- from
    /// their zone, and every Old Frontiers zone is Realm 0. So HeldByEvil is
    /// exactly "does an evil force hold this ground". Realm-owned keeps fall
    /// through to base behaviour and are untouched.
    ///
    /// Models come from mobs that already exist in this database, so they are
    /// known-good client models rather than guesses.
    ///
    /// Patrolling: the stock Patrol class is component-based and unusable in
    /// Old Frontiers, which has no keep components. Instead any guard given a
    /// PathID walks it, using the same three-method pattern as RoundsBrain --
    /// load the path on start, drop a breadcrumb when pulled, resume when the
    /// fight ends -- layered on KeepGuardBrain so guard aggro rules and lord
    /// assistance are preserved.
    /// </summary>
    public static class Garrison
    {
        // 921 ancient zombie, 920 defiled skeleton, 110 gore dappled zombie
        public static readonly ushort[] Fighters = { 921, 920, 110 };
        // 938 ater skeleton, 25 corybantic skeleton
        public static readonly ushort[] Archers = { 938, 25 };
        // 441 raven wraith, 440 black wraith
        public static readonly ushort[] Casters = { 441, 440 };
        // 923 grasping ghoul
        public static readonly ushort[] Stealthers = { 923 };
        // 605 cruach demon, 399 fiery fiend
        public static readonly ushort[] Lords = { 605, 399 };

        public const short PatrolSpeed = 250;

        /// <summary>
        /// Puts any hired companion in range onto a guard's aggro list, so the
        /// garrison fights the group in front of it rather than the player
        /// behind them.
        /// </summary>
        public static void NoticeCompanions(KeepGuardBrain brain)
        {
            if (brain?.Body == null || brain.AggroLevel <= 0)
                return;

            foreach (GameNPC npc in brain.Body.GetNPCsInRadius((ushort) brain.AggroRange))
            {
                if (npc is not GameMercenary companion || !companion.IsAlive)
                    continue;

                if (!GameServer.ServerRules.IsAllowedToAttack(brain.Body, companion, true))
                    continue;

                brain.AddToAggroList(companion, 1);
            }
        }

        public static bool HeldByEvil(GameKeepGuard guard)
        {
            return guard != null && guard.Realm == eRealm.None;
        }

        public static ushort Pick(ushort[] models)
        {
            return models[Util.Random(0, models.Length - 1)];
        }

        /// <summary>
        /// The keep a guard belongs to. Component-attached guards report it
        /// directly; Old Frontiers guards are mob rows with no Component, so
        /// they are matched to the nearest keep. The closest two frontier keeps
        /// are 21,686 units apart against a guard ring of about 2,056, so this
        /// radius cannot pick the wrong one.
        /// </summary>
        /// <summary>
        /// Gives a guard the level its keep says it should have.
        ///
        /// Core cannot do this for us. GameKeepGuard.SetLevel is
        ///
        ///     if (Component != null) Component.Keep.SetGuardLevel(this);
        ///
        /// and our guards are mob rows, so Component is always null and the
        /// level is simply never set -- leaving the whole garrison at whatever
        /// the database row said, which is level 1. A level 1 guard is grey to
        /// a level 50 player, does nothing, and is barely willing to fight.
        /// This is the same null that has already broken world init, the lord
        /// seal payout and the lord's call for help.
        ///
        /// The formula is core's own, with the keep found by proximity.
        /// </summary>
        public static void ScaleToKeep(GameKeepGuard guard)
        {
            if (guard == null || guard.Component != null)
                return; // Core will handle it.

            AbstractGameKeep keep = KeepOf(guard);
            int baseLevel = keep != null ? keep.BaseLevel : 50;
            int keepLevel = keep != null ? keep.Level : 1;

            int level = guard is GuardLord
                ? baseLevel + ((baseLevel / 10) + 1) * 2
                : baseLevel + 1;

            level += (int) (keepLevel * ServerProperties.Properties.KEEP_GUARD_LEVEL_MULTIPLIER);
            guard.Level = (byte) Math.Clamp(level, 1, 79);
            guard.Health = guard.MaxHealth;
            guard.StartHealthRegeneration();
        }

        public static AbstractGameKeep KeepOf(GameKeepGuard guard)
        {
            if (guard == null)
                return null;

            if (guard.Component != null && guard.Component.Keep != null)
                return guard.Component.Keep;

            return GameServer.KeepManager.GetClosestKeepToSpot(
                guard.CurrentRegionID, guard.X, guard.Y, guard.Z, 8000);
        }
    }

    /// <summary>
    /// Keep guard brain that walks a PathID while keeping KeepGuardBrain aggro.
    /// </summary>
    /// <summary>
    /// A keep guard that can see a hired companion.
    ///
    /// KeepGuardBrain.CheckNpcAggro is blunt about who counts:
    ///
    ///     // Non-pet NPCs are ignored.
    ///     if (npc is GameKeepGuard || npc.Brain is not IControlledBrain)
    ///         continue;
    ///
    /// That rule exists because, in the game core was written for, the only
    /// friendly NPCs at a keep are somebody's pets. Here a player arrives with
    /// six hired classes, and without this the entire garrison looks straight
    /// through them and walks to the one player in the room -- which is both
    /// absurd to watch and impossible to survive.
    ///
    /// Every guard on this server runs one of these, so the rule is ours.
    /// </summary>
    public class MonsterKeepGuardBrain : KeepGuardBrain
    {
        protected override void CheckNpcAggro()
        {
            base.CheckNpcAggro();
            Garrison.NoticeCompanions(this);
        }
    }

    public class PatrollingKeepGuardBrain : MonsterKeepGuardBrain
    {
        private PathPoint _resume;
        private bool _fighting;

        public override bool Start()
        {
            if (!base.Start())
                return false;

            if (!string.IsNullOrEmpty(Body.PathID))
            {
                PathPoint head = MovementMgr.LoadPath(Body.PathID);

                if (head != null)
                {
                    // Join the circuit at the nearest waypoint rather than at
                    // step 1, so a keep full of patrollers spreads around the
                    // ring instead of forming one queue.
                    Body.CurrentPathPoint = NearestWaypoint(head);
                    Body.MoveOnPath(Garrison.PatrolSpeed);
                }
            }

            return true;
        }

        private PathPoint NearestWaypoint(PathPoint head)
        {
            PathPoint best = head;
            long bestDistance = long.MaxValue;
            PathPoint point = head;

            // Bounded: a Loop path is circular, and Next is null on the others.
            for (int i = 0; i < 64 && point != null; i++)
            {
                long dx = point.X - Body.X;
                long dy = point.Y - Body.Y;
                long distance = dx * dx + dy * dy;

                if (distance < bestDistance)
                {
                    bestDistance = distance;
                    best = point;
                }

                point = point.Next;

                if (point == head)
                    break;
            }

            return best;
        }

        public override void AddToAggroList(GameLiving living, long aggroAmount, bool ignoreConfusion)
        {
            // Remember where the round was interrupted -- once, on the pull.
            //
            // Aggro is added on every single hit, so doing this per call spliced
            // a fresh waypoint into the path with each blow landed and left the
            // guard trying to walk a path made of hundreds of copies of itself.
            if (!_fighting)
            {
                _fighting = true;
                _resume = Body.CurrentPathPoint;
                Body.StopMovingOnPath(); // Stand and fight. The round can wait.
            }

            base.AddToAggroList(living, aggroAmount, ignoreConfusion);
        }

        protected override GameLiving CalculateNextAttackTarget()
        {
            GameLiving target = base.CalculateNextAttackTarget();

            if (target != null)
                return target;

            // Only pick the round back up when the fight is genuinely over.
            //
            // This used to resume on any tick without a target, which happens
            // constantly mid-fight -- between one target dying and the next
            // being chosen, or while the current one is briefly out of reach.
            // The guard would take a step down its path, re-aggro, step again:
            // the bouncing.
            if (!_fighting || HasAggro || Body.InCombat)
                return null;

            _fighting = false;

            if (_resume != null)
            {
                Body.CurrentPathPoint = _resume;
                _resume = null;
                Body.MoveOnPath(Garrison.PatrolSpeed);
            }

            return null;
        }
    }

    public class MonsterGuardFighter : GuardFighter
    {

        public override bool AddToWorld()
        {
            if (!base.AddToWorld())
                return false;

            Garrison.ScaleToKeep(this);
            return true;
        }
        protected override KeepGuardBrain GetBrain()
        {
            return string.IsNullOrEmpty(PathID) ? new MonsterKeepGuardBrain() : new PatrollingKeepGuardBrain();
        }

        protected override void SetModel()
        {
            if (Garrison.HeldByEvil(this)) Model = Garrison.Pick(Garrison.Fighters);
            else base.SetModel();
        }

        protected override void SetName()
        {
            if (Garrison.HeldByEvil(this)) Name = string.IsNullOrEmpty(PathID) ? "dread legionnaire" : "dread outrider";
            else base.SetName();
        }
    }

    public class MonsterGuardArcher : GuardArcher
    {

        public override bool AddToWorld()
        {
            if (!base.AddToWorld())
                return false;

            Garrison.ScaleToKeep(this);
            return true;
        }
        protected override KeepGuardBrain GetBrain()
        {
            return string.IsNullOrEmpty(PathID) ? new MonsterKeepGuardBrain() : new PatrollingKeepGuardBrain();
        }

        protected override void SetModel()
        {
            if (Garrison.HeldByEvil(this)) Model = Garrison.Pick(Garrison.Archers);
            else base.SetModel();
        }

        protected override void SetName()
        {
            if (Garrison.HeldByEvil(this)) Name = string.IsNullOrEmpty(PathID) ? "dread marksman" : "dread scout";
            else base.SetName();
        }
    }

    public class MonsterGuardStaticArcher : GuardStaticArcher
    {

        public override bool AddToWorld()
        {
            if (!base.AddToWorld())
                return false;

            Garrison.ScaleToKeep(this);
            return true;
        }
        protected override void SetModel()
        {
            if (Garrison.HeldByEvil(this)) Model = Garrison.Pick(Garrison.Archers);
            else base.SetModel();
        }

        protected override void SetName()
        {
            if (Garrison.HeldByEvil(this)) Name = "dread sentinel";
            else base.SetName();
        }
    }

    public class MonsterGuardCaster : GuardCaster
    {

        public override bool AddToWorld()
        {
            if (!base.AddToWorld())
                return false;

            Garrison.ScaleToKeep(this);
            return true;
        }
        protected override void SetModel()
        {
            if (Garrison.HeldByEvil(this)) Model = Garrison.Pick(Garrison.Casters);
            else base.SetModel();
        }

        protected override void SetName()
        {
            if (Garrison.HeldByEvil(this)) Name = "dread conjurer";
            else base.SetName();
        }
    }

    public class MonsterGuardStaticCaster : GuardStaticCaster
    {

        public override bool AddToWorld()
        {
            if (!base.AddToWorld())
                return false;

            Garrison.ScaleToKeep(this);
            return true;
        }
        protected override void SetModel()
        {
            if (Garrison.HeldByEvil(this)) Model = Garrison.Pick(Garrison.Casters);
            else base.SetModel();
        }

        protected override void SetName()
        {
            if (Garrison.HeldByEvil(this)) Name = "dread warder";
            else base.SetName();
        }
    }

    public class MonsterGuardHealer : GuardHealer
    {

        public override bool AddToWorld()
        {
            if (!base.AddToWorld())
                return false;

            Garrison.ScaleToKeep(this);
            return true;
        }
        protected override void SetModel()
        {
            if (Garrison.HeldByEvil(this)) Model = Garrison.Pick(Garrison.Casters);
            else base.SetModel();
        }

        protected override void SetName()
        {
            if (Garrison.HeldByEvil(this)) Name = "dread acolyte";
            else base.SetName();
        }
    }

    public class MonsterGuardStealther : GuardStealther
    {

        public override bool AddToWorld()
        {
            if (!base.AddToWorld())
                return false;

            Garrison.ScaleToKeep(this);
            return true;
        }
        protected override void SetModel()
        {
            if (Garrison.HeldByEvil(this)) Model = Garrison.Pick(Garrison.Stealthers);
            else base.SetModel();
        }

        protected override void SetName()
        {
            if (Garrison.HeldByEvil(this)) Name = "dread stalker";
            else base.SetName();
        }
    }

    public class MonsterGuardCommander : GuardCommander
    {

        public override bool AddToWorld()
        {
            if (!base.AddToWorld())
                return false;

            Garrison.ScaleToKeep(this);
            return true;
        }
        protected override void SetModel()
        {
            if (Garrison.HeldByEvil(this)) Model = Garrison.Pick(Garrison.Lords);
            else base.SetModel();
        }

        protected override void SetName()
        {
            if (Garrison.HeldByEvil(this)) Name = "dread captain";
            else base.SetName();
        }
    }

    /// <summary>
    /// Lord brain that can actually call its garrison.
    ///
    /// Stock LordBrain already implements the Gaheris mechanic -- on a PvE
    /// server, attacking the lord makes every guard in the keep rush to him --
    /// but it walks lord.Component.Keep.Guards, and Old Frontiers lords are mob
    /// rows with no Component. So the call never happens. This gathers the
    /// garrison by radius instead.
    /// </summary>
    public class MonsterLordBrain : LordBrain
    {
        private const ushort CALL_RADIUS = 4000;
        private const long CALL_COOLDOWN = 60000;

        private long _nextCall;

        protected override void CheckNpcAggro()
        {
            base.CheckNpcAggro();
            Garrison.NoticeCompanions(this);
        }

        protected override void BringFriends(GameLiving trigger)
        {
            GuardLord lord = Body as GuardLord;

            if (lord == null)
            {
                base.BringFriends(trigger);
                return;
            }

            long now = GameLoop.GameLoopTime;

            if (_nextCall > now)
                return;

            _nextCall = now + CALL_COOLDOWN;

            int responding = 0;

            foreach (GameNPC npc in lord.GetNPCsInRadius(CALL_RADIUS))
            {
                if (npc is not GameKeepGuard guard || guard == lord)
                    continue;

                if (!guard.IsAlive || guard.Realm != eRealm.None || !guard.IsAvailableToJoinFight)
                    continue;

                if (guard.AssistLord(lord))
                {
                    responding++;

                    if (trigger != null)
                        guard.StartAttack(trigger);
                }
            }

            string message = responding == 0
                ? $"{lord.Name} bellows for assistance but no guards respond!"
                : $"{lord.Name} bellows for assistance and {responding} guards respond!";

            foreach (GamePlayer player in lord.GetPlayersInRadius(WorldMgr.VISIBILITY_DISTANCE))
                ChatUtil.SendErrorMessage(player, message);
        }
    }

    public class MonsterGuardLord : GuardLord
    {

        public override bool AddToWorld()
        {
            if (!base.AddToWorld())
                return false;

            Garrison.ScaleToKeep(this);
            return true;
        }
        protected override KeepGuardBrain GetBrain()
        {
            return new MonsterLordBrain();
        }

        protected override void SetModel()
        {
            if (Garrison.HeldByEvil(this)) Model = Garrison.Pick(Garrison.Lords);
            else base.SetModel();
        }

        protected override void SetName()
        {
            if (Garrison.HeldByEvil(this)) Name = "dread lord";
            else base.SetName();
        }

        /// <summary>
        /// With the lord down the ground is clear, and the frontier hears about
        /// it. The garrison respawns on its own timers -- the dark forces
        /// return, as they do.
        /// </summary>
        public override void Die(GameObject killer)
        {
            AbstractGameKeep keep = Garrison.KeepOf(this);
            string where = keep != null ? keep.Name : "A frontier keep";

            base.Die(killer);

            if (!Garrison.HeldByEvil(this) && Realm != eRealm.None)
                return;

            string message = $"{where} has fallen! The evil that held it is vanquished.";

            foreach (eRealm realm in new[] { eRealm.Albion, eRealm.Midgard, eRealm.Hibernia })
                NewsMgr.CreateNews(message, realm, eNewsType.RvRGlobal, true);
        }
    }
}
