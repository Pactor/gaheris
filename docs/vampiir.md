# The Vampiir

Hibernia, Catacombs (December 2004). Class 58. A melee caster who draws power
from fighting and refuses to be buffed.

Audited 4 September 2026. Partly fixed, not yet played since.

---

## What he has

| Line | Holds |
|---|---|
| **Vampiiric Embrace** | 40 -- direct damage, fear, evade and weapon skill buffs, **stealth detection** |
| **Dementia** | 38 -- mesmerise, buff shear, and six *pulsing* effectiveness debuffs |
| **Shadow Mastery** | 46 -- endurance drain, haste, parry, speed, two pulsing snares |

All 88 spell types he reaches have handlers. Nothing missing.

---

## The mechanic, and what was wrong with it

A Vampiir has no power regeneration. He pays for his spells with violence, and
the bar refills only from combat. That is the class.

**The core implements half of it.** `AttackComponent.MakeAttack` grants power
when a Vampiir *lands* a blow, on this curve:

```
perc = (ad.Damage + ad.CriticalDamage) / 100 * (55 - Level)
perc = clamp(perc, 1, 15)
Mana += ceil(perc * MaxMana / 100)
```

and that is the only place in the entire server a Vampiir is granted power, the
power bolt aside. **Being hit grants nothing**, which is the half that pays you
for standing in the middle of a fight.

`scripts/classes/shared/CombatPower.cs` adds it, on the core's own curve.

### It did not work at all until this session

The script was written against `GameLivingEvent.AttackedByEnemy` and
`GameLivingEvent.AttackFinished`. **Neither is ever raised by this server** --
27 and 21 files subscribe to them respectively and nothing publishes either. So
from the day it was written until 4 September it did nothing whatsoever, and I
had told you it worked.

It now hangs off `GameObjectEvent.TakeDamage`, which is raised, fires once per
landed blow, and names both ends of it -- so one handler pays the striker and
the victim. See `dead-events.md`.

**This has never been seen working.** It needs testing before it is believed.

`combat_power_rate` scales it. 1.0 grants exactly what the core pays for one
landed blow.

---

## What is worth checking against live

**He refuses stat buffs**, and the core enforces this in several places by
naming the class. Whether the *right* things are refused has not been checked.

**Six pulsing effectiveness debuffs in Dementia** and two pulsing snares in
Shadow Mastery. No pulsing spell in this server stops when the caster moves
unless something was written to make it -- the event that announced movement is
dead. Whether these *should* stop on movement is unknown; the Bainshee's do,
but she is a different case. Not changed.

**`VampiirStealthDetection`** in Vampiiric Embrace -- a real class feature and
completely untested here.

---

## What to test

1. **Take a beating and watch the power bar.** This is the half that never
   worked. Hit something and watch it too -- the core pays for that already, so
   the bar should climb from both.
2. **Maulers as well**, since they share the file and are paid nothing at all
   by the core. See `mauler.md`.
3. **Stealth detection** against a stealthed hire or player.
4. A **Dementia pulsing debuff**, and whether walking stops it.
5. Whether **buffs are refused** as they should be.
