# The Shrouded Isles classes

Shrouded Isles, November 2002 -- the first expansion, and a **different six**
from the Catacombs five we have been fixing. Necromancer and Reaver in Albion,
Savage and Bonedancer in Midgard, Valewalker and Animist in Hibernia, plus the
Flexible, Scythe and Hand-to-Hand weapon lines.

Audited 4 September 2026 from the live database and the core source. **None of
these have been played or fixed.** This is the starting map, not a report.

---

## The headline

**Their content is present and their handlers exist.** Across all six, the only
spell type with no handler is one Animist spell, plus the two Sojourner ML
spells every class in the game shares. There is no missing content to import.

That matches what the Catacombs classes turned out to be: the data was always
there, and what was broken was wiring.

---

## Class by class

### Necromancer (12) -- Albion

| Line | | Spells |
|---|---|---|
| Deathsight / Death Servant / Painworking | baseline | 24 / 22 / 20 |
| Deathsight Spec / Death Servant Spec / Painworking Spec | spec | 34 / 32 / 37 |

169 spells, 71 types, all handled. **No pulsing spells at all**, so none of the
movement faults that plagued the Bainshee apply.

The class is a pet class that becomes a shade while the pet lives, which is
structural rather than spell data, and none of it was examined here. That is the
first thing to look at.

### Reaver (19) -- Albion

One spec line, **Soulrending**, 53 spells. 75 types, all handled.

**Worth attention:** Soulrending's spells *pulse* -- 9 direct damage, 7 melee
damage debuffs, 6 armour absorption debuffs, all with a non-zero Pulse. Nothing
in this server stops a pulsing spell when the caster moves unless it was written
to, because the event that announced movement is dead. Whether a Reaver's
lifetaps are meant to be sustained or are simply flagged oddly is the question
to settle first, and it wants a patch note rather than a guess.

### Savage (32) -- Midgard

One line, **Savagery**, 48 spells. 77 types, all handled. Nothing pulsing,
nothing blank.

The Savage's mechanic is self-buffs bought with health, which is a data
property rather than a handler, so a clean audit here means little. Test the
health cost.

### Bonedancer (30) -- Midgard

The largest of the six: three baselines and six spec lines, 345 spells, 98
types, all handled.

| | Lines |
|---|---|
| baseline | Bone Army 35, Suppression 39, Darkness 20 |
| spec | Bone Warriors 53, Bone Guardians 52, Spirit Dimming 42, Bone Mystics 39, Spirit Suppression 38, Runes of Darkness 34, Runes of Suppression 33 |

**Pulsing:** 3 bladeturns in Runes of Suppression, 6 snares in Bone Guardians.
Same question as the Reaver.

A note from an earlier session that still stands: each Bonedancer line fills
levels 15 through 48 in threes, so a level that looks wrong usually is not --
the rung belongs to a different line.

### Animist (55) -- Hibernia

Four baselines and four spec lines, 299 spells, 91 types.

**One spell has a blank `Type` and therefore no handler at all:**
`150000 Fungal Potency`, Creeping Path level 29 -- *"Target's spells have an
enhanced effectiveness... will reduce the chance of a resisted spell. (Only
usable in PVE)"*, Value 15, 60s, radius 350.

It is **not** fixed, deliberately. The spell ID is 150000, far above the ranges
around it, which is the signature of something added to this database rather
than imported from live data, and the "(Only usable in PVE)" note reads the same
way. `EffectivenessBuff` would probably make it work, but making an invented
spell work is not the same as matching live. **Decide whether it belongs before
giving it a type.**

### Valewalker (56) -- Hibernia

Two baselines and two spec lines, 134 spells, 82 types, all handled. Nothing
pulsing, nothing blank.

Scythe and the no-armour rule are the class, and neither is spell data.

---

## What every one of them shares

Two Sojourner ML spells with blank types, described in `master-levels.md` --
one now removed from its line, one still broken and needing a core change.

Six ML abilities that never end, four of them still broken. Every class reaches
all of them.

---

## Where to start

The Reaver and the Bonedancer, because both have pulsing spec lines and pulsing
is where every fault so far has been. Then the Necromancer's shade mechanic,
which is the most structural thing in the six and the least likely to be
correct given how the Bainshee's wraith form turned out.

Nothing here justifies a fix yet. The audit says the content is present; it does
not say the mechanics work, and no one has played any of them.
