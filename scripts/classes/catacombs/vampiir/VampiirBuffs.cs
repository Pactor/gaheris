using System;
using System.Collections.Generic;
using DOL.GS.PacketHandler;
using DOL.GS.PropertyCalc;
using DOL.GS.Spells;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// The Vampiir's own buffs, none of which did anything.
    ///
    /// Six of his spell types put their whole behaviour in
    /// OnEffectStart(GameSpellEffect). That callback is only reached when
    /// something builds a legacy GameSpellEffect, and duration spells stopped
    /// building one in the ECS rewrite -- the same fault as the Bainshee's
    /// Fear and Befriend and the Mauler's Disarm and Silence.
    ///
    /// Three of the six are worth repairing and three are not:
    ///
    ///   VampiirMeleeResistance    self buff  -- fixed here
    ///   VampiirMagicResistance    self buff  -- fixed here
    ///   VampiirStealthDetection   self buff  -- fixed here
    ///   VampiirArmorDebuff        enemy      -- edits the target's *inventory*
    ///   VampiirEffectivenessDeBuff enemy     -- sets GamePlayer.Effectiveness
    ///   VampiirSkillBonusDeBuff   enemy      -- zeroes a GamePlayer's skills
    ///
    /// All three debuffs are guarded by `effect.Owner is GamePlayer` and work
    /// on things only a player has. On a co-operative server, where everything
    /// hostile is a monster, they would do nothing even reached -- so reviving
    /// them would be motion rather than progress. Recorded in docs/vampiir.md.
    ///
    /// The bonus is applied where the effect really lands and taken back on a
    /// timer, because the expiry callback is as unreachable as the start one.
    /// A recast refreshes the timer rather than stacking a second helping.
    /// </summary>
    internal static class VampiirGrant
    {
        private sealed class Given
        {
            public int Amount;
            public ECSGameTimer Until;
        }

        private static readonly Dictionary<string, Given> _given = new();
        private static readonly object _lock = new();

        private static string Key(GameLiving who, string what)
        {
            return who.InternalID + "|" + what;
        }

        /// <summary>
        /// Add <paramref name="amount"/> to each property, and put it back when
        /// the time is up. Casting again while it holds only extends it.
        /// </summary>
        public static void Give(GameLiving who, IPropertyIndexer bag, eProperty[] props,
                                int amount, int duration, string what)
        {
            if (who == null || bag == null || amount == 0 || duration <= 0)
                return;

            string key = Key(who, what);

            lock (_lock)
            {
                if (_given.TryGetValue(key, out Given standing))
                {
                    standing.Until?.Stop();
                    standing.Until = new ECSGameTimer(who, _ => TakeBack(who, bag, props, key), duration);
                    standing.Until.Start(duration);
                    return;
                }

                foreach (eProperty p in props)
                    bag[p] += amount;

                Given fresh = new() { Amount = amount };
                fresh.Until = new ECSGameTimer(who, _ => TakeBack(who, bag, props, key), duration);
                fresh.Until.Start(duration);
                _given[key] = fresh;
            }

            if (who is GamePlayer player)
            {
                player.Out.SendCharStatsUpdate();
                player.Out.SendCharResistsUpdate();
            }
        }

        private static int TakeBack(GameLiving who, IPropertyIndexer bag, eProperty[] props, string key)
        {
            lock (_lock)
            {
                if (!_given.TryGetValue(key, out Given standing))
                    return 0;

                _given.Remove(key);
                standing.Until?.Stop();

                foreach (eProperty p in props)
                    bag[p] -= standing.Amount;
            }

            if (who is GamePlayer player)
            {
                player.Out.SendCharStatsUpdate();
                player.Out.SendCharResistsUpdate();
            }

            return 0;
        }
    }

    /// <summary>Slash, crush and thrust, on himself.</summary>
    [SpellHandler(eSpellType.VampiirMeleeResistance)]
    public class VampiirMeleeResist : VampiirMeleeResistance
    {
        private static readonly eProperty[] MELEE =
        {
            eProperty.Resist_Slash, eProperty.Resist_Crush, eProperty.Resist_Thrust,
        };

        public VampiirMeleeResist(GameLiving caster, Spell spell, SpellLine line)
            : base(caster, spell, line) { }

        public override void ApplyEffectOnTarget(GameLiving target)
        {
            base.ApplyEffectOnTarget(target);

            if (target == null || !target.IsAlive)
                return;

            VampiirGrant.Give(target, target.BaseBuffBonusCategory, MELEE,
                (int) Spell.Value, CalculateEffectDuration(target), "vamp-melee");

            if (!string.IsNullOrEmpty(Spell.Message1))
                MessageToLiving(target, Spell.Message1, eChatType.CT_Spell);
        }
    }

    /// <summary>The six magic resists, on himself.</summary>
    [SpellHandler(eSpellType.VampiirMagicResistance)]
    public class VampiirMagicResist : VampiirMagicResistance
    {
        private static readonly eProperty[] MAGIC =
        {
            eProperty.Resist_Body, eProperty.Resist_Cold, eProperty.Resist_Energy,
            eProperty.Resist_Heat, eProperty.Resist_Matter, eProperty.Resist_Spirit,
        };

        public VampiirMagicResist(GameLiving caster, Spell spell, SpellLine line)
            : base(caster, spell, line) { }

        public override void ApplyEffectOnTarget(GameLiving target)
        {
            base.ApplyEffectOnTarget(target);

            if (target == null || !target.IsAlive)
                return;

            VampiirGrant.Give(target, target.AbilityBonus, MAGIC,
                (int) Spell.Value, CalculateEffectDuration(target), "vamp-magic");

            if (!string.IsNullOrEmpty(Spell.Message1))
                MessageToLiving(target, Spell.Message1, eChatType.CT_Spell);
        }
    }

    /// <summary>
    /// Seeing hidden things. The core adds the spell's value to the owner's
    /// stealth skill, which is how this server measures who can see a
    /// stealther, and it has never once been added.
    /// </summary>
    [SpellHandler(eSpellType.VampiirStealthDetection)]
    public class VampiirSeesHidden : VampiirStealthDetection
    {
        private static readonly eProperty[] SEEING = { eProperty.Skill_Stealth };

        public VampiirSeesHidden(GameLiving caster, Spell spell, SpellLine line)
            : base(caster, spell, line) { }

        public override void ApplyEffectOnTarget(GameLiving target)
        {
            base.ApplyEffectOnTarget(target);

            if (target == null || !target.IsAlive)
                return;

            VampiirGrant.Give(target, target.BaseBuffBonusCategory, SEEING,
                (int) Spell.Value, CalculateEffectDuration(target), "vamp-sight");
        }
    }
}
