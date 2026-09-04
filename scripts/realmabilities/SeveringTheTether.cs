using System;
using DOL.AI.Brain;
using DOL.Database;
using DOL.GS.PacketHandler;
using DOL.GS.RealmAbilities;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// Severing the Tether -- the Mentalist's Realm Rank 5 ability, which was
    /// granted to him and never written.
    ///
    /// The ability row named `DOL.GS.RealmAbilities.AtlasOF_SeveringTheTether`
    /// and no such class exists anywhere in the server. The only other mention
    /// of that name is the commented-out helper script that inserts the grant.
    /// SkillBase warned once at boot, substituted an inert default, and a
    /// Mentalist reaching RR5 got a button that did nothing at all.
    ///
    /// What it does, from the published description: a ground targeted effect
    /// with a thousand unit radius that unmakes summoned pets and breaks the
    /// hold on charmed ones. Thirty minute reuse when it catches something,
    /// three seconds when it catches nothing -- so a miss costs almost nothing
    /// and a hit costs the fight.
    ///
    /// Releasing a charm is deliberately done by ending the charm effect
    /// rather than by hand. CharmECSGameEffect.OnStopEffect already returns the
    /// creature's own brain, clears its aggro, and -- for a sustained charm --
    /// sets it on whoever was holding it. Reimplementing that would be worse
    /// than calling it.
    ///
    /// Who it may touch is decided by the server rules rather than by this
    /// ability. Anything whose owner the caster is allowed to attack is fair
    /// game, which on a co-operative server means monster pets and never a
    /// groupmate's or a hired hand's.
    /// </summary>
    public class SeveringTheTether : RR5RealmAbility
    {
        public SeveringTheTether(DbAbility dba, int level) : base(dba, level) { }

        /// <summary>A thousand units around the ground target.</summary>
        private const ushort RADIUS = 1000;

        /// <summary>How far away that ground target may be set.</summary>
        private const int REACH = 1500;

        /// <summary>Three seconds when it finds nothing, so a misjudged cast is cheap.</summary>
        private const int NOTHING_FOUND = 3000;

        public override void Execute(GameLiving living)
        {
            if (CheckPreconditions(living, DEAD | SITTING | MEZZED | STUNNED))
                return;

            if (living is not GamePlayer caster)
                return;

            if (!caster.GroundTarget.IsValid)
            {
                caster.Out.SendMessage("You must set a ground target to use this ability!",
                    eChatType.CT_System, eChatLoc.CL_SystemWindow);
                return;
            }

            if (!caster.IsWithinRadius(caster.GroundTarget, REACH))
            {
                caster.Out.SendMessage("Your ground target is too far away to use this ability!",
                    eChatType.CT_System, eChatLoc.CL_SystemWindow);
                return;
            }

            int unmade = 0;
            int freed = 0;

            foreach (GameNPC npc in WorldMgr.GetNPCsCloseToSpot(
                         caster.CurrentRegionID, caster.GroundTarget, RADIUS))
            {
                if (npc?.Brain is not IControlledBrain leash)
                    continue;

                GameLiving keeper = leash.Owner;

                if (keeper == null || keeper == caster)
                    continue;

                if (!GameServer.ServerRules.IsAllowedToAttack(caster, keeper, true))
                    continue;

                if (Sever(npc, keeper))
                    freed++;
                else if (Unmake(npc, leash, keeper))
                    unmade++;
            }

            int caught = unmade + freed;

            if (caught == 0)
            {
                caster.Out.SendMessage("You find no tethers to sever.",
                    eChatType.CT_SpellResisted, eChatLoc.CL_SystemWindow);
                living.DisableSkill(this, NOTHING_FOUND);
                return;
            }

            SendCasterSpellEffectAndCastMessage(caster, 7059, true);
            caster.Out.SendMessage(
                "You sever " + caught + (caught == 1 ? " tether" : " tethers") + "!",
                eChatType.CT_Spell, eChatLoc.CL_SystemWindow);

            BlowsThatNeverLanded.Say(caster.Name + " severs " + freed + " charm(s) and unmakes " +
                                     unmade + " summoned pet(s)");

            DisableSkill(living);
        }

        /// <summary>
        /// A charmed creature is let go by ending the charm, which hands it
        /// back its own brain and turns it on whoever held it.
        /// </summary>
        private static bool Sever(GameNPC npc, GameLiving keeper)
        {
            ECSGameEffect charm = EffectListService.GetEffectOnTarget(npc, eEffect.Charm, eSpellType.Charm);

            if (charm == null)
                return false;

            return charm.End();
        }

        /// <summary>
        /// A summoned one has nowhere to go back to, so it is unmade: taken
        /// off its owner first, so nothing is left holding a brain that no
        /// longer has a body in the world.
        /// </summary>
        private static bool Unmake(GameNPC npc, IControlledBrain leash, GameLiving keeper)
        {
            try
            {
                keeper.RemoveControlledBrain(leash);
                npc.StopAttack();
                npc.StopCurrentSpellcast();
                npc.RemoveFromWorld();
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }

        public override int GetReUseDelay(int level)
        {
            // Thirty minutes, and only when it caught something. A cast that
            // found nothing is re-disabled for three seconds in Execute.
            return 1800;
        }
    }
}
