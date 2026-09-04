using DOL.GS.Spells;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// The Valkyrie's frontal cones, which would have disconnected her.
    ///
    /// Odin's Will carries five pulsing cone damage spells, and that is exactly
    /// the shape that drops a Bainshee to the character screen: a cone or point
    /// blank spell that ticks outside a cast.
    ///
    /// DirectDamageSpellHandler, which FrontalAOEConeHandler inherits, asks the
    /// casting component for a line of sight check on anything cone shaped, and
    /// that method reads the component's own current spell handler rather than
    /// the one it is given:
    ///
    ///     public bool StartEndOfCastLosCheck(GameLiving target, SpellHandler spellHandler)
    ///     {
    ///         if (SpellHandler.LosChecker == null || ...
    ///
    /// During a pulse nothing is being cast, so that is null and it throws --
    /// "Critical error encountered in EffectService", taking the player's
    /// session with it.
    ///
    /// Found by looking for the same shape elsewhere after the Bainshee hit it,
    /// rather than by anyone running into it, so this is untested: it is a
    /// crash that has not happened yet. The five spells are Odin's Will's cone
    /// line, which means it would have happened the first time anyone specced
    /// it.
    ///
    /// The check is only asked for when there is a cast to hang it on. A pulse
    /// therefore does not test line of sight, which is what the non-cone branch
    /// of this handler already does.
    /// </summary>
    [SpellHandler(eSpellType.FrontalPulseConeDD)]
    public class ValkyrieCone : FrontalAOEConeHandler
    {
        public ValkyrieCone(GameLiving caster, Spell spell, SpellLine line)
            : base(caster, spell, line) { }

        public override void OnDirectEffect(GameLiving target)
        {
            if (target == null)
                return;

            if (Spell.Target is eSpellTarget.CONE &&
                Caster?.castingComponent?.SpellHandler != null &&
                Caster.castingComponent.StartEndOfCastLosCheck(target, this))
                return;

            DealDamage(target);
        }
    }
}
