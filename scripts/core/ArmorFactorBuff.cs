using DOL.GS.Spells;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// A working handler for the plain ArmorFactorBuff.
    ///
    /// There is one in the core and it cannot be built:
    ///
    ///     [SpellHandler(eSpellType.ArmorFactorBuff)]
    ///     public abstract class ArmorFactorBuff(...) : SingleStatBuff(...)
    ///
    /// It is abstract. It exists to be the shared parent of the base, spec and
    /// Paladin variants -- which is a good reason for it to be abstract and no
    /// reason at all for it to carry the attribute claiming the generic spell
    /// type. An abstract class cannot be instantiated, so the constructor
    /// lookup fails and the server says so at every attempt:
    ///
    ///     Couldn't find a SpellHandler constructor for ArmorFactorBuff
    ///     Couldn't find spell handler for spell type ArmorFactorBuff
    ///
    /// Sixty-two spells use that type here and none of them has ever done
    /// anything: the Bard's Shield of Ivy line, the pet armour buff, and the
    /// armour factor procs on items. A hired Bard casting Shield of Ivy is
    /// throwing it away, and worse, will keep re-casting it forever because
    /// the effect never lands -- the same shape as the buff loop chased
    /// earlier today.
    ///
    /// Deriving from the core's abstract class keeps its two decisions --
    /// the property is ArmorFactor and it takes a specialisation bonus -- and
    /// adds only the ability to exist. The bonus category is SingleStatBuff's
    /// own default, BaseBuff, which is what the parent would have used.
    /// </summary>
    [SpellHandler(eSpellType.ArmorFactorBuff)]
    public class PlainArmorFactorBuff(GameLiving caster, Spell spell, SpellLine line)
        : ArmorFactorBuff(caster, spell, line)
    {
    }
}
