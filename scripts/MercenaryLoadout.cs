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

        /// <summary>
        /// Master Level fonts: Font of Power, Sphere of Rejuvenation and the
        /// two wards. Planted on the ground where the fight is and left to
        /// feed whoever stands in them, so they are dropped once per fight
        /// rather than kept up like a buff.
        /// </summary>
        public List<Spell> MlFonts = new();

        /// <summary>
        /// Master Level summons -- Battlewarder, Brittle Guard, Crystal Titan.
        /// Kept apart from PetSummon because a hire may have both a class pet
        /// and one of these, and the class pet is the one it fights with.
        /// </summary>
        public List<Spell> MlPets = new();

        /// <summary>
        /// Master Level buffs worth keeping on the group: Warguard, Leadership,
        /// Energizing Aura, Guided Strike, Chaotic Power.
        /// </summary>
        public List<Spell> MlBuffs = new();

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
            return For(characterClass, level, Duty.None, 0);
        }

        public static Loadout For(eCharacterClass characterClass, int level, Duty duties)
        {
            return For(characterClass, level, duties, 0);
        }

        /// <summary>
        /// Duties come in only for Atlantis: a Master Level path is chosen by
        /// what the character does, not by what class it is, so the cache has
        /// to tell a healing Cleric from a smiting one.
        /// </summary>
        public static Loadout For(eCharacterClass characterClass, int level, Duty duties,
                                  int masterLevel)
        {
            level = Math.Clamp(level, 1, 50);
            masterLevel = Math.Clamp(masterLevel, 0, 10);
            long key = (((long) characterClass * 100 + level) * 65536 + (long) duties) * 11
                       + masterLevel;

            lock (_lock)
            {
                if (_cache.TryGetValue(key, out Loadout cached))
                    return cached;
            }

            Loadout loadout = Build(characterClass, level, duties, masterLevel);

            lock (_lock)
                _cache[key] = loadout;

            return loadout;
        }

        private static Loadout Build(eCharacterClass characterClass, int level, Duty duties,
                                     int masterLevel)
        {
            Loadout loadout = new();
            List<string> specs = SpecsOf(characterClass);

            // Atlantis, if this server runs it.
            if (GaherisSettings.ATLANTIS)
            {
                string path = MasterPath(characterClass, duties);

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

            // Master Level paths are deliberately NOT counted here.
            //
            // The even split divides a character's points across the lines it
            // specialises in, and a Master Level path is not one of those --
            // it is separate progression, earned by raiding rather than bought
            // with spec points. Counting it turned Atlantis into a straight
            // downgrade: a Druid went from three casting specs to four, so
            // every Nurture, Regrowth and Nature spell it knew dropped from
            // spec 20 to spec 15 in exchange for spells it would have got
            // anyway. Turning a feature on should not make the class worse.
            int castingSpecs = Math.Max(1, lines
                .Where(l => !IsMasterPath(l.Spec))
                .Select(l => l.Spec).Distinct().Count());

            int specLevel = Math.Clamp((int) (level * EVEN_SPEC_SHARE / castingSpecs), 1, level);

            foreach (DbSpellLine line in lines)
            {
                // A base line comes with the class; a spec line only as far
                // as the points reach; a Master Level path by its own rule.
                //
                // ML spells are numbered 1 to 10 -- those are Master Levels,
                // not character levels -- so measuring them against a spec
                // level is meaningless. Atlantis is level 50 content, so that
                // is the gate.
                // A hire walks the Master Levels its employer has walked and
                // no further. Handing a level 50 hire all ten the moment it was
                // recruited made Atlantis something you were given rather than
                // something you earned -- and made your own Master Levels the
                // only ones in the group that meant anything.
                int reach = IsMasterPath(line.Spec)
                    ? (level >= 50 ? masterLevel : 0)
                    : (line.IsBaseLine ? level : specLevel);

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
        /// The Master Level path this class actually had.
        ///
        /// Every class was offered exactly two paths and picked one; this takes
        /// the first, which is the one the class is usually built around. The
        /// table is the real one rather than a guess from what the hire does --
        /// a Druid is Convoker/Perfecter, which no amount of reasoning from
        /// "it heals" would have produced.
        ///
        /// Classes that postdate Trials of Atlantis are not in it, and fall
        /// through to the duty rule below.
        /// </summary>
        private static string MasterPath(eCharacterClass characterClass, Duty duties)
        {
            string first, second;

            if (!PathPair(characterClass, out first, out second))
                return MasterPathByDuty(duties);

            // Two real options, so pick the one this hire will actually use.
            return Suits(second, duties) > Suits(first, duties) ? second : first;
        }

        /// <summary>
        /// The two Master Level paths a class may walk.
        ///
        /// This is the live table, from the official class options list, and it
        /// is a pair rather than a free choice: every class has exactly two of
        /// the eight open to it. The earlier version of this method named one
        /// path per class and, as it happens, never named one outside the
        /// class's real pair -- but it also never chose between them, so a
        /// Cleric and a Warden both went Battlemaster or Warlord whether they
        /// were hired to heal or to hold a line.
        ///
        /// Players on this server are not held to the pair -- migration 39
        /// opens all eight to every class deliberately. Hires are, because a
        /// hire has no opinion to express and the authentic pair is the better
        /// default.
        /// </summary>
        private static bool PathPair(eCharacterClass characterClass,
                                     out string first, out string second)
        {
            switch (characterClass)
            {
                // ---- Albion --------------------------------------------
                case eCharacterClass.Armsman:      first = "Warlord";      second = "Battlemaster"; return true;
                case eCharacterClass.Cabalist:     first = "Convoker";     second = "Stormlord";    return true;
                case eCharacterClass.Cleric:       first = "Warlord";      second = "Perfecter";    return true;
                case eCharacterClass.Friar:        first = "Battlemaster"; second = "Perfecter";    return true;
                case eCharacterClass.Heretic:      first = "Banelord";     second = "Perfecter";    return true;
                case eCharacterClass.Infiltrator:  first = "Spymaster";    second = "Battlemaster"; return true;
                case eCharacterClass.Mercenary:    first = "Battlemaster"; second = "Banelord";     return true;
                case eCharacterClass.Minstrel:     first = "Warlord";      second = "Sojourner";    return true;
                case eCharacterClass.Necromancer:  first = "Convoker";     second = "Warlord";      return true;
                case eCharacterClass.Paladin:      first = "Warlord";      second = "Battlemaster"; return true;
                case eCharacterClass.Reaver:       first = "Battlemaster"; second = "Banelord";     return true;
                case eCharacterClass.Scout:        first = "Battlemaster"; second = "Sojourner";    return true;
                case eCharacterClass.Sorcerer:     first = "Convoker";     second = "Stormlord";    return true;
                case eCharacterClass.Theurgist:    first = "Convoker";     second = "Stormlord";    return true;
                case eCharacterClass.Wizard:       first = "Convoker";     second = "Stormlord";    return true;

                // ---- Midgard -------------------------------------------
                case eCharacterClass.Berserker:    first = "Battlemaster"; second = "Banelord";     return true;
                case eCharacterClass.Bonedancer:   first = "Convoker";     second = "Banelord";     return true;
                case eCharacterClass.Healer:       first = "Sojourner";    second = "Perfecter";    return true;
                case eCharacterClass.Hunter:       first = "Sojourner";    second = "Battlemaster"; return true;
                case eCharacterClass.Runemaster:   first = "Convoker";     second = "Stormlord";    return true;
                case eCharacterClass.Savage:       first = "Warlord";      second = "Battlemaster"; return true;
                case eCharacterClass.Shadowblade:  first = "Spymaster";    second = "Battlemaster"; return true;
                case eCharacterClass.Shaman:       first = "Convoker";     second = "Perfecter";    return true;
                case eCharacterClass.Skald:        first = "Warlord";      second = "Sojourner";    return true;
                case eCharacterClass.Spiritmaster: first = "Convoker";     second = "Stormlord";    return true;
                case eCharacterClass.Thane:        first = "Battlemaster"; second = "Stormlord";    return true;
                case eCharacterClass.Valkyrie:     first = "Stormlord";    second = "Warlord";      return true;
                case eCharacterClass.Warlock:      first = "Banelord";     second = "Convoker";     return true;
                case eCharacterClass.Warrior:      first = "Warlord";      second = "Battlemaster"; return true;

                // ---- Hibernia ------------------------------------------
                case eCharacterClass.Animist:      first = "Convoker";     second = "Stormlord";    return true;
                case eCharacterClass.Bainshee:     first = "Convoker";     second = "Stormlord";    return true;
                case eCharacterClass.Bard:         first = "Sojourner";    second = "Perfecter";    return true;
                case eCharacterClass.Blademaster:  first = "Battlemaster"; second = "Banelord";     return true;
                case eCharacterClass.Champion:     first = "Battlemaster"; second = "Banelord";     return true;
                case eCharacterClass.Druid:        first = "Convoker";     second = "Perfecter";    return true;
                case eCharacterClass.Eldritch:     first = "Convoker";     second = "Stormlord";    return true;
                case eCharacterClass.Enchanter:    first = "Convoker";     second = "Stormlord";    return true;
                case eCharacterClass.Hero:         first = "Battlemaster"; second = "Warlord";      return true;
                case eCharacterClass.Mentalist:    first = "Stormlord";    second = "Warlord";      return true;
                case eCharacterClass.Nightshade:   first = "Spymaster";    second = "Stormlord";    return true;
                case eCharacterClass.Ranger:       first = "Battlemaster"; second = "Sojourner";    return true;
                case eCharacterClass.Valewalker:   first = "Battlemaster"; second = "Stormlord";    return true;
                case eCharacterClass.Vampiir:      first = "Banelord";     second = "Warlord";      return true;
                case eCharacterClass.Warden:       first = "Battlemaster"; second = "Perfecter";    return true;
            }

            first = null;
            second = null;
            return false;
        }

        /// <summary>
        /// How well a path serves what this hire was brought along to do.
        ///
        /// Only ever used to choose between the two a class actually has, so
        /// the numbers are a ranking and not a measurement.
        /// </summary>
        private static int Suits(string path, Duty duties)
        {
            switch (path)
            {
                case "Perfecter":
                    if (duties.HasFlag(Duty.Heal)) return 100;
                    if (duties.HasFlag(Duty.Buffs) || duties.HasFlag(Duty.Chants)) return 60;
                    return 10;

                case "Convoker":
                    if (duties.HasFlag(Duty.Pet)) return 100;
                    if (duties.HasFlag(Duty.Heal)) return 20;
                    return 40;

                case "Stormlord":
                    if (duties.HasFlag(Duty.PBAoE)) return 100;
                    if (duties.HasFlag(Duty.Nuke) || duties.HasFlag(Duty.DoT)) return 85;
                    return 15;

                case "Banelord":
                    if (duties.HasFlag(Duty.Debuff) || duties.HasFlag(Duty.CC)) return 90;
                    if (duties.HasFlag(Duty.Melee)) return 55;
                    return 25;

                case "Spymaster":
                    if (duties.HasFlag(Duty.Archer)) return 90;
                    return 45;

                case "Sojourner":
                    if (duties.HasFlag(Duty.Speed)) return 90;
                    if (duties.HasFlag(Duty.Archer)) return 70;
                    if (duties.HasFlag(Duty.Heal)) return 30;
                    return 35;

                case "Warlord":
                    if (duties.HasFlag(Duty.Tank)) return 95;
                    if (duties.HasFlag(Duty.Buffs) || duties.HasFlag(Duty.Bubble)) return 55;
                    return 30;

                case "Battlemaster":
                    if (duties.HasFlag(Duty.Tank)) return 70;
                    if (duties.HasFlag(Duty.Melee)) return 80;
                    return 35;
            }

            return 0;
        }

        /// <summary>
        /// For anything the table does not name -- Heretic, Mauler, Valkyrie,
        /// Warlock, Vampiir, Bainshee all arrived after Atlantis did.
        /// </summary>
        private static string MasterPathByDuty(Duty duties)
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

        /// <summary>The eight Master Level paths, by spec name.</summary>
        private static readonly HashSet<string> MasterPaths = new()
        {
            "Banelord", "Battlemaster", "Convoker", "Perfecter",
            "Sojourner", "Spymaster", "Stormlord", "Warlord",
        };

        private static bool IsMasterPath(string spec)
        {
            return spec != null && MasterPaths.Contains(spec);
        }

        /// <summary>
        /// Whether this class is trained to use a given kind of weapon.
        ///
        /// The game already knows: every weapon type maps to the
        /// specialisation that wields it, and a class either has that
        /// specialisation or it does not. A Blademaster has Blades, Blunt,
        /// Piercing and Celtic Dual, and nothing that fires an arrow.
        /// </summary>
        public static bool CanWield(eCharacterClass characterClass, eObjectType type)
        {
            string spec = SkillBase.ObjectTypeToSpec(type);

            // No mapping at all: not something proficiency governs.
            if (string.IsNullOrEmpty(spec))
                return true;

            foreach (string mine in SpecsOf(characterClass))
            {
                if (string.Equals(mine, spec, StringComparison.OrdinalIgnoreCase))
                    return true;
            }

            return false;
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
                    // ---- Atlantis ------------------------------------------
                    //
                    // These have to be named individually because nothing about
                    // their spell type marks them as Master Level work, and
                    // without a slot to sit in they stayed in Known and were
                    // never cast. A hire could hold all ten levels of Perfecter
                    // and never once drop a Font of Power.
                    case eSpellType.FOP:            // Font of Power
                    case eSpellType.FOH:            // Sphere of Rejuvenation
                    case eSpellType.FOR:            // Determination Ward
                    case eSpellType.FOD:            // Dissonating Ward
                        loadout.MlFonts.Add(spell);
                        break;

                    case eSpellType.Battlewarder:
                    case eSpellType.BrittleGuard:
                    case eSpellType.SummonTitan:
                        loadout.MlPets.Add(spell);
                        break;

                    case eSpellType.MLABSBuff:              // Warguard
                    case eSpellType.EffectivenessBuff:      // Leadership
                    case eSpellType.FatigueConsumptionBuff: // Energizing Aura
                        loadout.MlBuffs.Add(spell);
                        break;

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
        /// <summary>
        /// One of the alternatives, chosen at random.
        ///
        /// A summon's Model field is a semicolon-separated list because the
        /// creature is not meant to look the same every time -- an Enchanter's
        /// underhill ally has thirty-two models and can be any of them. Taking
        /// the first, which is what FirstOf does, gave every Enchanter in the
        /// company an identical twin.
        /// </summary>
        public static ushort AnyOf(string field, ushort fallback)
        {
            if (string.IsNullOrWhiteSpace(field))
                return fallback;

            List<ushort> choices = new();

            foreach (string part in field.Split(';', ','))
            {
                if (ushort.TryParse(part.Trim(), out ushort value) && value > 0)
                    choices.Add(value);
            }

            if (choices.Count == 0)
                return fallback;

            return choices[Util.Random(choices.Count - 1)];
        }

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
