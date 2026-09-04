# The Mauler

**Labyrinth of the Minotaur, 2006** -- not Catacombs, and not Darkness Rising
as this repo said until 3 September. Unlockable from any realm, so there are
three of them: `MaulerAlb` 60, `MaulerMid` 61, `MaulerHib` 62, identical in
content.

Fist wraps or a staff, hand to hand, and a power bar fed by fighting.

Audited 4 September 2026. Not yet played.

---

## What he has

Identical across all three realms: 123 spells over three lines.

| Line | Holds |
|---|---|
| **Power Strikes** | 46 -- direct damage, damage add, disarm, **silence**, endurance drain, power drain, fumble debuff |
| **Aura Manipulation** | 39 -- absorption and constitution buffs, evade, heal over time, regen, 3 pulsing bladeturns, 3 pulsing nearsight reductions |
| **Magnetism** | 38 -- casting speed debuff, resist debuff, snares |

All 88 spell types have handlers. No blank types beyond the two Sojourner ones
every class shares.

---

## The mechanic, and the hole in it

A Mauler keys mana to Strength and is meant to earn his power by fighting,
exactly as a Vampiir does.

**The server grants him none.** Not from combat, and not from anywhere else --
`RegenBuff`, `PowerHealSpellHandler` and the Perfecter power heal all name the
three Mauler classes explicitly and decline. Declining is correct; the earning
half was simply never written. So the bar fills once, drains, and never
recovers, which makes Fist Wraps and Power Strikes something you use at the
start of an evening and not again.

`scripts/classes/shared/CombatPower.cs` grants it, on the Vampiir's curve --
the same file, because it is the same mechanic and splitting it would mean
lying about one of the two expansions.

The Mauler gets the **whole** share where a Vampiir gets a top-up, because the
core already pays the Vampiir for landing blows and pays the Mauler nothing.

**Never seen working.** Until 4 September the file was hung on two events this
server never raises, so it had done nothing at all since it was written. See
`dead-events.md`.

---

## Midgard and Hibernia had each other's champion trees

`61 MaulerMid` was granted `Champion Level Hibernia` and four Hibernia
archetype trees; `62 MaulerHib` was granted `Champion Level Midgard` and three
Midgard ones. Each held precisely the set the other should have, which is why
it survived being looked at -- on its own each row is entirely plausible, and
only the class id beside it is wrong.

A Mauler reaching champion level would have trained the wrong realm's
abilities. Corrected in migration 106; everything else about the two classes
was right. See `champion-levels.md`.

## What is worth checking against live

**Pulsing bladeturns and nearsight reductions** in Aura Manipulation -- three
of each. Whether those should end when he moves is unknown and unchanged. They
read like self-buffs rather than channels, in which case they should not.

**`Silence` in Power Strikes** is unusual for a melee class and worth a look
against the class library.

**Whether the power curve is right for him.** `combat_power_rate` exists to
tune it. The Vampiir's formula scales inversely with level because damage grows
with level and the share taken from it should not; whether the Mauler should
use the same curve is a genuine open question, and 1.0 is a starting position
rather than a researched answer.

---

## What to test

1. **Fight something and watch the power bar.** It should climb from landing
   blows and from taking them. Before this it never moved.
2. Spend it on **Fist Wraps** or a **Power Strike**, then refill by fighting.
   That loop is the whole class and has never once run on this server.
3. Whether the fill rate **feels** right at `combat_power_rate = 1.0`. This is
   the setting most likely to need changing after play.
4. **Silence**, and the pulsing bladeturns in Aura Manipulation.
5. That all **three realms** behave the same -- they share the content, so a
   difference means a data fault.
