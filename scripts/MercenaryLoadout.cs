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

        /// <summary>
        /// Songs and chants -- pulsing group effects.
        ///
        /// These are deliberately NOT kept with the maintained buffs, because
        /// they are not maintained. Only one pulses at a time, so which one is
        /// playing IS the decision: travelling wants speed, a fight wants
        /// whichever sustain the group is short of. Filed with the buffs, speed
        /// was simply kept up out of combat and the mana song never played at
        /// all -- which is not what a Bard does.
        /// </summary>
        public Spell Speed;

        public Spell PowerSong;
        public Spell HealthSong;
        public Spell ChantHeal;
        public Spell ChantDamage;
        public Spell ChantGuard;
        public Spell ChantEndurance;

        /// <summary>Whether this class plays anything at all.</summary>
        public bool HasSongs =>
            Speed != null || PowerSong != null || HealthSong != null ||
            ChantHeal != null || ChantDamage != null || ChantGuard != null ||
            ChantEndurance != null;

        /// <summary>The class's own pet, the one the spell actually summons.</summary>
        public Spell PetSummon;

        /// <summary>
        /// Fire-and-forget turrets. An Animist plants these where it stands and
        /// they stay put -- they are not a pet, and they do not follow.
        /// </summary>
        public List<Spell> Turrets = new();

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
            return For(characterClass, level, Duty.None);
        }

        /// <summary>
        /// Duties come in only for Atlantis: a Master Level path is chosen by
        /// what the character does, not by what class it is, so the cache has
        /// to tell a healing Cleric from a smiting one.
        /// </summary>
        public static Loadout For(eCharacterClass characterClass, int level, Duty duties)
        {
            level = Math.Clamp(level, 1, 50);
            long key = ((long) characterClass * 100 + level) * 65536 + (long) duties;

            lock (_lock)
            {
                if (_cache.TryGetValue(key, out Loadout cached))
                    return cached;
            }

            Loadout loadout = Build(characterClass, level, duties);

            lock (_lock)
                _cache[key] = loadout;

            return loadout;
        }

        private static Loadout Build(eCharacterClass characterClass, int level, Duty duties)
        {
            Loadout loadout = new();
            List<string> specs = SpecsOf(characterClass);

            // Atlantis, if this server runs it.
            if (GaherisSettings.ATLANTIS)
            {
                string path = MasterPath(duties);

                if (path != null)
                    specs.Add(path);
            }

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

        /// <summary>
        /// The Master Level path this role would actually have walked.
        ///
        /// A character picks one path, so this picks one too, by what the hire
        /// is for rather than by class -- which is how players chose them.
        /// </summary>
        private static string MasterPath(Duty duties)
        {
            if (duties.HasFlag(Duty.Heal) || duties.HasFlag(Duty.Buffs))
                return "Perfecter";

            if (duties.HasFlag(Duty.Pet))
                return "Convoker";

            if (duties.HasFlag(Duty.CC) || duties.HasFlag(Duty.Debuff))
                return "Banelord";

            if (duties.HasFlag(Duty.Nuke) || duties.HasFlag(Duty.PBAoE) ||
                duties.HasFlag(Duty.DoT))
                return "Stormlord";

            if (duties.HasFlag(Duty.Archer))
                return "Spymaster";

            if (duties.HasFlag(Duty.Tank))
                return "Warlord";

            if (duties.HasFlag(Duty.Melee))
                return "Battlemaster";

            if (duties.HasFlag(Duty.Speed) || duties.HasFlag(Duty.Chants))
                return "Sojourner";

            return null;
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
                // Travel speed is never a buff to keep up, pulsing or not.
                if (spell.SpellType is eSpellType.SpeedEnhancement)
                {
                    Keep(ref loadout.Speed, spell, s => s.Value);
                    continue;
                }

                // Anything else that pulses is a song, and songs are switched
                // between rather than stacked.
                if (spell.Pulse > 0 && KeepSong(loadout, spell))
                    continue;

                switch (spell.SpellType)
                {
                    // ---- pets ----------------------------------------------
                    //
                    // Fire-and-forget first: a turret is planted and left, and
                    // the Animist keeps planting more. Treating it as "the pet"
                    // would give an Animist one wandering mushroom instead of a
                    // field of them.
                    case eSpellType.SummonAnimistFnF:
                    case eSpellType.SummonAnimistFnFCustom:
                    case eSpellType.SummonAnimistAmbusher:
                        KeepTurret(loadout, spell);
                        break;

                    case eSpellType.SummonDruidPet:
                    case eSpellType.SummonUnderhill:
                    case eSpellType.SummonSimulacrum:
                    case eSpellType.SummonNecroPet:
                    case eSpellType.SummonCommander:
                    case eSpellType.SummonMinion:
                    case eSpellType.SummonSpiritFighter:
                    case eSpellType.SummonHunterPet:
                    case eSpellType.SummonTheurgistPet:
                    case eSpellType.SummonAnimistPet:
                    case eSpellType.SummonElemental:
                    case eSpellType.SummonHealingElemental:
                        Keep(ref loadout.PetSummon, spell, s => s.Level);
                        break;

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
                        KeepBest(loadout.Maintained, spell);
                        break;
                }
            }
        }

        /// <summary>
        /// Files a pulsing spell under the job it does, strongest of each kind.
        /// False for anything that pulses but is not a song we would play.
        /// </summary>
        private static bool KeepSong(Loadout loadout, Spell spell)
        {
            switch (spell.SpellType)
            {
                case eSpellType.PowerRegenBuff:
                    Keep(ref loadout.PowerSong, spell, s => s.Value);
                    return true;

                case eSpellType.HealthRegenBuff:
                    Keep(ref loadout.HealthSong, spell, s => s.Value);
                    return true;

                case eSpellType.CombatHeal:
                    Keep(ref loadout.ChantHeal, spell, s => s.Value);
                    return true;

                case eSpellType.DamageAdd:
                    Keep(ref loadout.ChantDamage, spell, s => s.Value);
                    return true;

                case eSpellType.AblativeArmor:
                case eSpellType.Bladeturn:
                    Keep(ref loadout.ChantGuard, spell, s => s.Value);
                    return true;

                case eSpellType.EnduranceRegenBuff:
                    Keep(ref loadout.ChantEndurance, spell, s => s.Value);
                    return true;
            }

            return false;
        }

        /// <summary>Turrets, weakest first, one of each strength.</summary>
        private static void KeepTurret(Loadout loadout, Spell spell)
        {
            foreach (Spell kept in loadout.Turrets)
            {
                if (kept.SpellType == spell.SpellType && kept.Level == spell.Level)
                    return;
            }

            loadout.Turrets.Add(spell);
            loadout.Turrets.Sort((a, b) => a.Level.CompareTo(b.Level));
        }

        /// <summary>
        /// What a summon spell actually brings.
        ///
        /// The pet id lives in LifeDrainReturn -- the field is reused, which is
        /// not obvious -- and points at a real npctemplate row. Reading it is
        /// what makes a Druid's pet the bear the game summons rather than a
        /// model number picked to look about right. It was picked to look about
        /// right, and it was a vine.
        /// </summary>
        public static DbNpcTemplate PetTemplate(Spell summon)
        {
            if (summon == null || summon.LifeDrainReturn <= 0)
                return null;

            var rows = DOLDB<DbNpcTemplate>.SelectObjects(
                DB.Column("TemplateId").IsEqualTo(summon.LifeDrainReturn));

            if (rows == null || rows.Count == 0)
                return null;

            return rows[0];
        }

        /// <summary>
        /// First number out of a template field.
        ///
        /// Model and Size are STRINGS holding a semicolon-separated list of
        /// alternatives -- an underhill ally has thirty-odd models -- so they
        /// cannot simply be parsed as a number.
        /// </summary>
        public static ushort FirstOf(string field, ushort fallback)
        {
            if (string.IsNullOrWhiteSpace(field))
                return fallback;

            foreach (string part in field.Split(';', ','))
            {
                if (ushort.TryParse(part.Trim(), out ushort value) && value > 0)
                    return value;
            }

            return fallback;
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
