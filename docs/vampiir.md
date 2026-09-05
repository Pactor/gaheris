# The Vampiir

Hibernia, Catacombs (December 2004). Class 58. A melee caster who draws power
from fighting and refuses to be buffed.

Audited 4 September 2026, played briefly on the 5th. Nothing went wrong, and
nothing was proved either.

**Status: good enough to move on, with two fixes still unconfirmed.** He
behaved correctly in play and the log stayed clean, but the log carried no
evidence about the two things that were actually repaired -- Mark of Prey never
fired during the session, and the combat-power grant had no narration of its
own at the time. Both remain plausible rather than demonstrated.

`combat_power_log` now exists, off by default, so the next person to look can
settle it in one property rather than another code change.

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

## Six more of his spell types did nothing

Found on 5 September by sweeping every spell type in the game rather than only
the ones a class was being tested on. All six put their whole behaviour in
`OnEffectStart(GameSpellEffect)`, the callback duration spells stopped reaching
in the ECS rewrite -- the Bainshee's Fear and Befriend, and the Mauler's Disarm
and Silence, all failed the same way.

**Three are fixed**, in `scripts/classes/catacombs/vampiir/VampiirBuffs.cs`.
All three are buffs he puts on himself, so they matter every time he fights:

| Type | What was never applied |
|---|---|
| VampiirMeleeResistance | slash, crush and thrust resistance |
| VampiirMagicResistance | all six magic resistances |
| VampiirStealthDetection | the stealth skill that lets him see hidden things |

The bonus is applied where the effect really lands and taken back on a timer,
because the expiry callback is as unreachable as the start one. Recasting
refreshes rather than stacking.

**Three are not fixed, deliberately.** `VampiirArmorDebuff`,
`VampiirEffectivenessDeBuff` and `VampiirSkillBonusDeBuff` are all guarded by
`effect.Owner is GamePlayer` and work on things only a player has -- inventory
items, `Effectiveness`, trained skill levels. On a co-operative server, where
everything hostile is a monster, they would do nothing even if reached.
Reviving them would be motion rather than progress. The six pulsing
effectiveness debuffs in Dementia are of this kind.

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

---

## Full audit, 5 September 2026

Run to the same standard as the Mauler: not only skills, but whether the class
can be trained, created and equipped.

**Clean.** Trainers at home -- nine across the Shrouded Isles, Hibernia and Tir
na Nog. Champion line is Hibernia's. Twenty spell types across Vampiiric
Embrace, Dementia and Shadow Mastery, every one with a handler. Styles present
(Blades 110, Blunt 77, Piercing 101). Hibernia armour with Blades, Blunt and
Piercing. Races Celt, Lurikeen and Shar. `ClassType` is `ListCaster` and all
three of his specs have a NULL implementation, which is the consistent pairing
-- the mismatch that made the Valkyrie cast the wrong spell is not here.

### The realm ability gap is not his

He has 20 realm abilities, fewest in Hibernia against 26 for a Mauler and 30 to
34 for everyone else. Checked properly, that splits three ways.

**Correctly absent: Augmented Acuity.** A Vampiir has no acuity-driven power
pool -- he has no normal power pool at all -- and acuity is documented as not
affecting him in any way. Leaving it off is right.

**Not absent: Purge.** He carries `AtlasOF_PurgeReduced`, one of the three Purge
keys. Covered.

**Genuinely missing: Regeneration, Tireless and Mastery of Water** -- and *not*
because he is a Vampiir. The classes lacking all three are exactly:

    Heretic, Valkyrie, Bainshee, Vampiir, Warlock, and the three Maulers

which is precisely the eight classes added after the base game. All 39 older
classes have them. This is a population gap in `classxrealmability_atlas` that
was never filled in for the expansion classes, not a per-class decision, and it
applies to eight classes rather than one.

**Fixed**, migration 118. Twenty-four rows, three for each of the eight, with a
guard so it is safe to run twice. The Vampiir goes from 20 to 23 and stays the
lowest in Hibernia, which is now fully explained rather than merely low:
Augmented Acuity is correctly absent, and Purge is present under another key.

### One thing that needs your judgement

Our `CombatPower.cs` pays a Vampiir power **for being hit**. Live does not.

The official class library says he "gains power from a variety of attacks --
primarily melee strikes", and the class is described as having no normal power
pool, gaining power only from successfully attacking an opponent. Core already
implements exactly that, in `AttackComponent.MakeAttack`.

So the defensive half of that script is an **invention** for the Vampiir, not a
repair. It was written on the belief that being hit ought to pay him too, and
that belief is not supported by anything found since.

**Removed.** The defensive grant now applies only to something that both feeds
on being hit *and* is not already paid by core, and the Vampiir is neither. He
is paid for landing blows, by core, exactly as live describes.

What is left of that half is one narrow case: a **hired** Mauler. Power from
being hit is the Mauler's mechanic, core pays it through Defensive Combat Power
Regeneration in `GamePlayer.TakeDamage`, and a hire is a `GameNPC`, so that
override never runs for it.

So the same script had the two classes exactly backwards. It invented a
mechanic for the Vampiir and double-paid the Mauler for a real one.
