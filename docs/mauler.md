# The Mauler

**Labyrinth of the Minotaur, 2006** -- not Catacombs, and not Darkness Rising
as this repo said until 3 September. Unlockable from any realm, so there are
three: `MaulerAlb` 60, `MaulerMid` 61, `MaulerHib` 62.

Fist wraps or a staff, hand to hand, and a power bar fed by fighting.

Audited 5 September 2026 against the running server and against DOLSharp, where
the class last worked. Not yet played.

---

## What he has

**Identical across all three realms** -- same three spell lines, same five
specialisations, same 26 realm abilities, no ability one has that another
lacks. Any difference between the realms would itself have been a fault, and
there is none.

| Line | | Holds |
|---|---|---|
| **Power Strikes** | 46 | direct damage, damage add, **disarm**, **silence**, endurance drain, power drain, fumble debuff |
| **Aura Manipulation** | 39 | absorption and constitution buffs, evade, heal over time, regen, 3 pulsing bladeturns, 3 nearsight reductions |
| **Magnetism** | 38 | casting speed debuff, resist debuff, snares |

Weapon lines `Fist Wraps` and `Mauler Staff` carry 48 styles each, 1 to 50.

All three spell specs are correctly marked `LiveSpellHybridSpecialization`, and
all three classes declare `eClassType.Hybrid` -- so the fault that had the
Valkyrie casting her neighbour's spells is not present here. Checked precisely
because of her.

---

## What was wrong

### Disarm and Silence did nothing -- six spells

Both set a timestamp on the target, `DisarmedTime` and `SilencedTime`, and both
set it only from `OnEffectStart(GameSpellEffect)`. That callback is never
reached: duration spells stopped creating a legacy effect in the ECS rewrite.
The same fault as the Bainshee's Fear and Befriend.

Everything downstream was fine. `IsDisarmed` and `IsSilenced` are computed from
those timestamps, and the casting component already refuses to cast for anyone
silenced. Nothing was setting them.

- **Perizor Disarming Strike / Bash / Blow** -- 30, 40, 50
- **Demand Respect / Reverence / Awe** -- 25, 35, 45

Fixed in `scripts/core/DisarmAndSilence.cs`. It lives in `core/` rather than
here because three more Disarm spells belong to item effects and were equally
dead.

**One deliberate departure.** The core's Silence is guarded by
`if (effect.Owner is GamePlayer)`, so even when reached it would do nothing to
a monster -- an assumption from a realm-versus-realm server. The state lives on
`GameLiving` and the casting component tests it for anything that casts, so on
a co-operative server it is applied to any living thing. A silence that cannot
silence a monster is no spell at all here.

### Gift of Perizor never returned any power

His Realm Rank 5 shields a groupmate, swallowing a quarter of the damage they
take and handing it to the Mauler as power. The swallowing works. The handing
over never has -- not here, and not in DOLSharp before it:

```csharp
int difference = (int) (0.25 * damageDealt);
double manareturned = (difference / this.MaxHealth * TheMauler.MaxMana);
```

Both operands are `int`, so that is integer division. Unless one blow exceeds
the target's whole health pool it yields 0, and nought times MaxMana is nought.
The comment directly above says what was meant -- *"apply this % to mauler
maxmana"* -- and the arithmetic throws the percentage away.

It sits inside `GameLiving.TakeDamage` where a script cannot reach it, so the
correct sum is done in `scripts/realmabilities/BlowsThatNeverLanded.cs`
instead, off the same `TakeDamage` event. The core still adds its zero, which
costs nothing.

---

## The power supply, still unproven

A Mauler keys mana to Strength and is meant to earn power by fighting. **The
server grants him none.** `RegenBuff`, `PowerHealSpellHandler` and the
Perfecter power heal all name the three Mauler classes explicitly and decline
-- correctly, because he is supposed to earn it -- and the earning half was
never written.

`scripts/classes/shared/CombatPower.cs` grants it, on the Vampiir's curve. For
the Vampiir it is a top-up; **for the Mauler it is the entire supply**.

**Corrected 5 September: this was never his mechanic.** The class library says
it outright -- "The class does not have a normal power pool, however. It will
gain power from taking damage in combat." Power from damage *dealt* reaches a
Mauler only through the few spells that say "returned as power", not as a
passive.

Core already pays him for taking damage, a flat 25%, through Defensive Combat
Power Regeneration, which every Mauler carries from career level 1. So a played
Mauler was never short of anything -- he was being paid twice for the mechanic
he has and once more for one he does not.

This file now pays **hired** Maulers only, on that same 25%, because
`GamePlayer.TakeDamage` is an override a `GameNPC` never runs.

**This is the thing to test first.** If it does not work, a Mauler is
unplayable past his first bar.

---

## Champion, realm abilities, Master Levels

**Champion.** Correct after migration 106, which untangled a swap that had the
Midgard and Hibernia Maulers training each other's trees. Albion gets five
trees excluding Fighter, Midgard three excluding Viking, Hibernia four
excluding Guardian -- each realm's full set minus his own archetype.

**Realm abilities.** 26 each, identical across the three. Every one
instantiates and none is backed by a handler on a dead event. Their RR5, **Gift
of Perizor**, is shared by all three and is fixed above.

**Master Levels.** All eight lines, with the faults every class shares.

---

## What to test

One session should settle him.

1. **Fight something and watch the power bar.** It should climb from landing
   blows and from taking them. Turn on `combat_power_log` first -- without it
   there is no evidence but the bar itself.
2. Spend it on **Fist Wraps** or a **Power Strike**, then refill by fighting.
   That loop is the whole class and has never run on this server.
3. **Demand Respect** on a casting monster -- it should stop casting.
4. **Perizor Disarming Strike** -- the target should stop swinging.
5. **Gift of Perizor** on a groupmate, then let them be hit: they take a
   quarter less and you gain power. `ra_blows_log` narrates it.
6. Whether the fill rate **feels** right at `combat_power_rate = 1.0`. This is
   the setting most likely to want changing after play.

---

## Full audit, 5 September 2026

Run to the standard the Bainshee audit should have met -- not just skills, but
whether the class can be trained, created and equipped.

### Clean

| Checked | Result |
|---|---|
| Class ids and races | 60/61/62, each Minotaur race plus two of the realm -- Korazh/Briton/Inconnu, Deifrang/Kobold/Norseman, Graoch/Celt/Lurikeen |
| **Trainers at home** | Albion 4, Midgard 6, Hibernia 8. The fault that caught the Bainshee is not here |
| Champion lines | correct realm each -- migration 106's fix confirmed |
| Spell types | 21 across Aura Manipulation, Magnetism and Power Strikes. **All handled, none dead** |
| Hybrid marking | class is `eClassType.Hybrid`, all three spell specs are `LiveSpellHybridSpecialization` |
| RR5 | Gift of Perizor, all three, instantiates |
| Realm abilities | 26 each |
| Styles | Fist Wraps 48, Mauler Staff 48 |
| Armour and weapons | realm armour plus Fist Wraps, Mauler Staff and three realm weapons each |
| Master levels | all eight paths |

**On the realm ability count.** 26 against 32-33 for a Mercenary, Berserker or
Blademaster, which looks short until you read the difference. The Mauler trades
pure-melee abilities -- Mastery of Arms, Dodger, Duelist's Reflexes, Whirling
Dervish, Hail of Blows -- for caster ones: Aug Acuity, Mastery of Magery, Wild
Power, Serenity, Ethereal Bond, Mastery of Focus. That is a hybrid's set, and
it is coherent.

### One fault, and it was ours

**The Mauler was being paid twice for being hit.**

`CombatPower.cs` was written on the belief that nothing in the server pays a
Mauler anything, and said so in a comment. That is true of landing a blow. It is
**not** true of taking one. Every Mauler carries **Defensive Combat Power
Regeneration** from career level 1, and `GamePlayer.TakeDamage` pays it:

```csharp
if (HasAbility(Abilities.DefensiveCombatPowerRegeneration))
    Mana += (int)((damageAmount + criticalAmount) * 0.25);
```

So a Mauler in a fight drew a quarter of the damage he took as power from core,
and then a full share again from our script.

Fixed: the defensive grant now skips anyone carrying that ability. The test is
the **ability**, not the class, on purpose -- a hired Mauler is a `GameNPC`,
core's `GamePlayer.TakeDamage` never runs for it, and it still needs paying.

The offensive half is unchanged and was always right: core pays only a Vampiir
for landing a blow, so a Mauler and every hire still take the whole share there.

**Never observed either way.** The doubling was found by reading, not by
watching a power bar, and the fix has not been watched either.

### Not the Mauler's fault, but his to live with

He is handed the same dead Master Level abilities as everyone: **Unburdened
Warrior**, **Sabotage**, **Lookout** and **Siege Master** do nothing, and
**Enduring Poison** fires at a hundredth of its stated chance. All recorded in
`abilities.md`; none are class-specific.

