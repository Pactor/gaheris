using DOL.GS.PacketHandler;
using DOL.GS.Spells;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// Arawn's Precision, Accuracy, Clarity, Acuity and Cunning -- the
    /// Heretic's five spell piercing buffs, none of which did anything.
    ///
    /// They are the whole of the HereticPiercingMagic spell type: five self
    /// buffs in the Enhancement line, twenty minutes each, values 1, 3, 5, 7
    /// and 10. Nothing else in the database is of that type, so fixing the
    /// handler cannot disturb anything else.
    ///
    /// The core handler is not a buff at all. It inherits SpellHandler and puts
    /// its whole body in OnEffectStart(GameSpellEffect) -- the callback the ECS
    /// rewrite stopped reaching -- where it registers the caster as a *focus*
    /// target and says "You concentrated on the spell!". That is machinery for
    /// the Heretic's channels, which these are not: Pulse is 0 and the target
    /// is self. So a Heretic cast one of these, saw a buff icon, and carried no
    /// bonus of any kind.
    ///
    /// It is not enough to re-type them as ResiPierceBuff either, and that is
    /// worth writing down because it is the obvious move. Stat buffs do not
    /// read the handler's Property1 any more -- StatBuffECSEffect asks
    /// EffectHelper.GetPropertiesFromEffect(EffectType) instead -- and
    /// EffectHelper does not mention eProperty.ResistPierce anywhere at all.
    /// The property has to be written directly.
    ///
    /// That the mapping is right is confirmed by the arithmetic rather than
    /// assumed. ResistPierceCalculator caps the property at max(1, level / 5),
    /// which is exactly 10 at level 50, and Arawn's Cunning -- the level 50
    /// one -- carries exactly 10. The line was built against that cap.
    ///
    /// **What it will and will not do here.** Resist pierce reduces only the
    /// resistance a target gets *from items*:
    ///
    ///     primaryResistModifier -= Math.Max(0, Math.Min(ad.Target.ItemBonus[property], resistPierce));
    ///
    /// Ordinary monsters carry no item bonuses, so against them this subtracts
    /// nothing, and it is honest to say so rather than claim a damage increase
    /// that will not appear. What it does do is what the class says it does,
    /// it shows on the character sheet where it never did, and it behaves
    /// correctly against anything that does wear gear. The same reasoning kept
    /// the Vampiir's three debuffs unrevived; the difference is that this one
    /// is a self buff on a player, through a property the game really reads,
    /// and it costs almost nothing to make right.
    /// </summary>
    [SpellHandler(eSpellType.HereticPiercingMagic)]
    public class ArawnsPiercing : SpellHandler
    {
        public ArawnsPiercing(GameLiving caster, Spell spell, SpellLine line)
            : base(caster, spell, line) { }

        public override ECSGameSpellEffect CreateECSEffect(in ECSGameEffectInitParams initParams)
        {
            return ECSGameEffectFactory.Create(initParams, static (in i) => new ArawnsPiercingEffect(i));
        }
    }

    /// <summary>
    /// Adds and takes back the bonus where the effect really starts and stops,
    /// which is the whole of the repair. Written into BaseBuffBonusCategory
    /// because that is the one channel ResistPierceCalculator reads, alongside
    /// item bonuses and debuffs.
    /// </summary>
    public class ArawnsPiercingEffect : ECSGameSpellEffect
    {
        public ArawnsPiercingEffect(in ECSGameEffectInitParams initParams)
            : base(initParams) { }

        public override void OnStartEffect()
        {
            base.OnStartEffect();
            Adjust(true);
        }

        public override void OnStopEffect()
        {
            base.OnStopEffect();
            Adjust(false);
        }

        private void Adjust(bool granting)
        {
            if (Owner == null || SpellHandler?.Spell == null)
                return;

            int amount = (int) (SpellHandler.Spell.Value * Effectiveness);

            if (amount <= 0)
                return;

            if (granting)
                Owner.BaseBuffBonusCategory[eProperty.ResistPierce] += amount;
            else
                Owner.BaseBuffBonusCategory[eProperty.ResistPierce] -= amount;

            if (Owner is GamePlayer player)
                player.Out.SendCharStatsUpdate();
        }
    }
}
