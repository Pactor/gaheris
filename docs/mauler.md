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

It has never been seen working. It hung on two dead events from the day it was
written until 4 September, and the Vampiir session that followed produced no
evidence either way. `combat_power_log` exists, off by default, to settle it.

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
