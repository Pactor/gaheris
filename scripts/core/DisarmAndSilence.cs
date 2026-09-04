using DOL.GS.PacketHandler;
using DOL.GS.Spells;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// Disarm and Silence, neither of which did anything.
    ///
    /// Both set a timestamp on the target -- DisarmedTime, SilencedTime -- and
    /// both set it only from OnEffectStart(GameSpellEffect). That is the
    /// legacy effect callback, and duration spells stopped creating a legacy
    /// effect when the ECS rewrite landed, so it is never reached. The same
    /// fault as the Bainshee's Fear and Befriend.
    ///
    /// Everything downstream works. IsDisarmed and IsSilenced are computed
    /// from those timestamps on GameLiving, and the casting component already
    /// refuses to cast for anyone silenced. Nothing was ever setting them.
    ///
    /// Found on the Mauler, who has six of them in Power Strikes -- Perizor
    /// Disarming Strike, Bash and Blow at 30, 40 and 50, and Demand Respect,
    /// Reverence and Awe at 25, 35 and 45. Three more Disarm spells belong to
    /// item effects and were equally dead.
    ///
    /// Neither needs an expiry half. Both timestamps are read as "later than
    /// now", so they lapse on their own; the core's OnEffectExpires only sent
    /// messages.
    /// </summary>
    [SpellHandler(eSpellType.Disarm)]
    public class WorkingDisarm : DisarmSpellHandler
    {
        public WorkingDisarm(GameLiving caster, Spell spell, SpellLine line)
            : base(caster, spell, line) { }

        public override void ApplyEffectOnTarget(GameLiving target)
        {
            base.ApplyEffectOnTarget(target);

            if (target == null || !target.IsAlive)
                return;

            target.DisarmedTime = target.CurrentRegion.Time + CalculateEffectDuration(target);
            target.attackComponent?.StopAttack();

            if (!string.IsNullOrEmpty(Spell.Message1))
                MessageToLiving(target, Spell.Message1, eChatType.CT_Spell);

            if (!string.IsNullOrEmpty(Spell.Message2))
                Message.SystemToArea(target, Util.MakeSentence(Spell.Message2, target.GetName(0, false)),
                    eChatType.CT_Spell, target);

            target.StartInterruptTimer(target.SpellInterruptDuration,
                AttackData.eAttackType.Spell, Caster);
        }
    }

    /// <summary>
    /// Silence, which additionally only ever considered players.
    ///
    /// The core's version is guarded by `if (effect.Owner is GamePlayer)`, so
    /// even reached it would have done nothing to a monster. That reads as an
    /// assumption from a realm-versus-realm server rather than a rule: the
    /// state it sets lives on GameLiving, and CastingComponent tests
    /// `!Owner.IsSilenced` for anything that casts, monsters included.
    ///
    /// On a co-operative server a silence that cannot silence a monster is no
    /// spell at all, so it is applied to any living thing here. That is a
    /// deliberate departure from the core and is the one judgement in this
    /// file; everything else restores what was already written.
    /// </summary>
    [SpellHandler(eSpellType.Silence)]
    public class WorkingSilence : SilenceSpellHandler
    {
        public WorkingSilence(GameLiving caster, Spell spell, SpellLine line)
            : base(caster, spell, line) { }

        public override void ApplyEffectOnTarget(GameLiving target)
        {
            base.ApplyEffectOnTarget(target);

            if (target == null || !target.IsAlive)
                return;

            target.SilencedTime = target.CurrentRegion.Time + CalculateEffectDuration(target);
            target.StopCurrentSpellcast();
            target.StartInterruptTimer(target.SpellInterruptDuration,
                AttackData.eAttackType.Spell, Caster);
        }
    }
}
