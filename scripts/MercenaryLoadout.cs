using System;
using System.Collections.Generic;
using System.Linq;
using DOL.Database;
using DOL.GS.Styles;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// What a class actually knows at a given level.
    ///
    /// Everything here is the game's own data. A hired Warden draws from
    /// Nurture and Regrowth, a Bard from Music, a Blademaster from Blades and
    /// Celtic Dual -- the same lines the character creation screen would hand a
    /// player, resolved the same way:
    ///
    ///     class -> classxspecialization -> spellline.Spec -> SkillBase.GetSpellList
    ///     class -> classxspecialization -> SkillBase.GetStyleList
    ///
    /// Nothing is invented, approximated or rescaled. That matters for more
    /// than tidiness: a hand-built spell wearing a borrowed icon delves as
    /// whatever spell owns that icon, so an approximated buff on a level 12
    /// hire reads to the player as a level 50 buff. Using the real spell makes
    /// the icon, the delve, the value and the level right by construction --
    /// and progression comes free, because a class learns a spell exactly when
    /// the game says it does.
    /// </summary>
    public class Loadout
    {
        public List<Spell> Known = new();
        public List<Style> Styles = new();

        /// <summary>
        /// The class's own abilities -- armour and weapon proficiencies among
        /// them, which is what decides that an Eldritch cannot wear plate.
        /// </summary>
        public List<Ability> Abilities = new();

        /// <summary>Group buffs worth keeping up, best of each kind.</summary>
        public List<Spell> Maintained = new();

        public Spell Heal;
        public Spell GroupHeal;
        public Spell Rez;
        public Spell Nuke;

        /// <summary>Centred on the caster. They have to be in the pile.</summary>
        public Spell Pbaoe;

        /// <summary>Thrown at the mob and bursts there. Cast from range.</summary>
        public Spell AreaNuke;
        public Spell Dot;
        public Spell Debuff;
        public Spell Mez;
        public Spell Taunt;

        public bool Has(Spell spell) => spell != null;
    }

    public static class MercenaryLoadout
    {
        private static readonly Dictionary<long, Loadout> _cache = new();
        private static readonly object _lock = new();

        /// <summary>
        /// Even spec, as asked for: the points are spread across the lines a
        /// class actually casts from, rather than poured into one.
        ///
        /// A player does not get a spec level equal to their character level in
        /// every line at once -- that is the whole point of specialising -- so
        /// this hands each castable line a share and lets the rest follow.
        /// </summary>
        private const double EVEN_SPEC_SHARE = 1.2;

        public static Loadout For(eCharacterClass characterClass, int level)
        {
            level = Math.Clamp(level, 1, 50);
            long key = (long) characterClass * 100 + level;

            lock (_lock)
            {
                if (_cache.TryGetValue(key, out Loadout cached))
                    return cached;
            }

            Loadout loadout = Build(characterClass, level);

            lock (_lock)
                _cache[key] = loadout;

            return loadout;
        }

        private static Loadout Build(eCharacterClass characterClass, int level)
        {
            Loadout loadout = new();
            List<string> specs = SpecsOf(characterClass);

            if (specs.Count == 0)
                return loadout;

            // Which of those specs actually carry spells, so the even split is
            // across the lines that matter rather than across weapon skills.
            List<DbSpellLine> lines = new();

            foreach (string spec in specs)
            {
                var found = DOLDB<DbSpellLine>.SelectObjects(DB.Column("Spec").IsEqualTo(spec));

                if (found != null)
                    lines.AddRange(found);
            }

            int castingSpecs = Math.Max(1, lines.Select(l => l.Spec).Distinct().Count());
            int specLevel = Math.Clamp((int) (level * EVEN_SPEC_SHARE / castingSpecs), 1, level);

            foreach (DbSpellLine line in lines)
            {
                // A base line comes with the class; a spec line only as far as
                // the points reach.
                int reach = line.IsBaseLine ? level : specLevel;

                foreach (Spell spell in SkillBase.GetSpellList(line.KeyName))
                {
                    if (spell != null && spell.Level <= reach)
                        loadout.Known.Add(spell);
                }
            }

            foreach (string spec in specs)
            {
                List<Ability> abilities = SkillBase.GetSpecAbilityList(spec, (int) characterClass);

                if (abilities != null)
                {
                    foreach (Ability ability in abilities)
                    {
                        if (ability != null && ability.SpecLevelRequirement <= level)
                            loadout.Abilities.Add(ability);
                    }
                }

                List<Style> styles = SkillBase.GetStyleList(spec, (int) characterClass);

                if (styles == null)
                    continue;

                foreach (Style style in styles)
                {
                    if (style != null && style.Level <= specLevel)
                        loadout.Styles.Add(style);
                }
            }

            Categorise(loadout);
            return loadout;
        }

        private static List<string> SpecsOf(eCharacterClass characterClass)
        {
            List<string> specs = new();
            var rows = DOLDB<DbClassXSpecialization>.SelectObjects(
                DB.Column("ClassID").IsEqualTo((int) characterClass));

            if (rows == null)
                return specs;

            foreach (DbClassXSpecialization row in rows)
            {
                if (!string.IsNullOrEmpty(row.SpecKeyName))
                    specs.Add(row.SpecKeyName);
            }

            return specs;
        }

        /// <summary>
        /// Sorts what they know into the jobs a group needs doing, keeping the
        /// strongest of each.
        ///
        /// Concentration buffs are included, and that matters: in this game
        /// EVERY base and spec buff is one. Bark Skin, Strength of the Oak,
        /// Strength of the Tree -- all concentration. Skipping them, as this
        /// once did on the theory that they cost the caster a slot, threw away
        /// the entire reason for bringing a Druid or a Warden.
        ///
        /// The cost is not real here anyway: MaxConcentrationCalculator returns
        /// a flat million for anything that is not a player.
        ///
        /// Base and spec versions of the same buff are both kept on purpose --
        /// they occupy different categories and stack, which is what "base and
        /// spec buffs" means.
        /// </summary>
        private static void Categorise(Loadout loadout)
        {
            foreach (Spell spell in loadout.Known)
            {
                switch (spell.SpellType)
                {
                    case eSpellType.Heal:
                    case eSpellType.SpreadHeal:
                        if (spell.Target is eSpellTarget.GROUP)
                            Keep(ref loadout.GroupHeal, spell, s => s.Value);
                        else if (spell.Target is eSpellTarget.REALM or eSpellTarget.SELF)
                            Keep(ref loadout.Heal, spell, s => s.Value);
                        break;

                    case eSpellType.Resurrect:
                        Keep(ref loadout.Rez, spell, s => s.ResurrectHealth);
                        break;

                    case eSpellType.DirectDamage:
                    case eSpellType.DirectDamageWithDebuff:
                    case eSpellType.Bolt:
                    case eSpellType.Lifedrain:
                        // Radius alone does not make a spell point-blank. A
                        // RANGE of zero does: it bursts on the caster, so the
                        // caster has to be standing in it. Anything with both a
                        // radius and a range is thrown at the target and burst
                        // there, and closing to melee to cast it -- which is
                        // what treating them alike meant -- is simply wrong.
                        if (spell.Radius > 0 && spell.Range <= 0)
                            Keep(ref loadout.Pbaoe, spell, s => s.Damage);
                        else if (spell.Radius > 0)
                            Keep(ref loadout.AreaNuke, spell, s => s.Damage);
                        else
                            Keep(ref loadout.Nuke, spell, s => s.Damage);
                        break;

                    case eSpellType.DamageOverTime:
                        Keep(ref loadout.Dot, spell, s => s.Damage);
                        break;

                    case eSpellType.StrengthDebuff:
                    case eSpellType.StrengthConstitutionDebuff:
                    case eSpellType.DexterityQuicknessDebuff:
                    case eSpellType.ArmorFactorDebuff:
                        Keep(ref loadout.Debuff, spell, s => s.Value);
                        break;

                    case eSpellType.Mesmerize:
                        Keep(ref loadout.Mez, spell, s => s.Duration);
                        break;

                    case eSpellType.Taunt:
                        Keep(ref loadout.Taunt, spell, s => s.Value);
                        break;

                    // Anything worth putting up and leaving up.
                    case eSpellType.StrengthConstitutionBuff:
                    case eSpellType.DexterityQuicknessBuff:
                    case eSpellType.AcuityBuff:
                    case eSpellType.StrengthBuff:
                    case eSpellType.ConstitutionBuff:
                    case eSpellType.DexterityBuff:
                    case eSpellType.QuicknessBuff:
                    case eSpellType.BaseArmorFactorBuff:
                    case eSpellType.SpecArmorFactorBuff:
                    case eSpellType.PaladinArmorFactorBuff:
                    case eSpellType.ArmorAbsorptionBuff:
                    case eSpellType.DamageShield:
                    case eSpellType.DamageAdd:
                    case eSpellType.AblativeArmor:
                    case eSpellType.BodySpiritEnergyBuff:
                    case eSpellType.HeatColdMatterBuff:
                    case eSpellType.AllMagicResistsBuff:
                    case eSpellType.HealthRegenBuff:
                    case eSpellType.EnduranceRegenBuff:
                    case eSpellType.PowerRegenBuff:
                    case eSpellType.CombatSpeedBuff:
                    case eSpellType.MeleeDamageBuff:
                    case eSpellType.SpeedEnhancement:
                        KeepBest(loadout.Maintained, spell);
                        break;
                }
            }
        }

        private static void Keep(ref Spell slot, Spell candidate, Func<Spell, double> weigh)
        {
            if (slot == null || weigh(candidate) > weigh(slot))
                slot = candidate;
        }

        /// <summary>One of each kind, the strongest they know.</summary>
        private static void KeepBest(List<Spell> kept, Spell candidate)
        {
            for (int i = 0; i < kept.Count; i++)
            {
                if (kept[i].SpellType != candidate.SpellType)
                    continue;

                if (candidate.Value > kept[i].Value || candidate.Level > kept[i].Level)
                    kept[i] = candidate;

                return;
            }

            kept.Add(candidate);
        }
    }
}
