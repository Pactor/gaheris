# Champion Levels

Investigated 4 September 2026, after `Champion Abilities Hibernia` turned up
with zero spells and I assumed that meant Hibernia had no champion abilities.

**It does not mean that.** The line is supposed to be empty. What the
investigation did find was a different fault, two tables over.

---

## How it actually works

Three pieces, and only the middle one holds content.

**The realm specialisation** -- `Champion Level Albion`, `Champion Level
Hibernia`, `Champion Level Midgard` -- is implemented by
`DOL.GS.LiveChampionsSpecialization`. It is a *container*: it gathers the
player's archetype specs and assembles them into the champion window. It has a
`spellline` row of its own carrying no spells, and that is correct -- it is not
where spells live.

**The archetype trees** are where the content is. `Champion Magician 1` through
`5`, `Champion Forester 1` to `4`, and so on: 63 lines, each with two to five
spells, each with a `specialization` row whose `Implementation` names the class
that drives it -- `DOL.GS.LiveCLMagicianSpec` and friends.

**The grants** in `classxspecialization` are named differently again --
`CL Hibernia Magician`, `CL Midgard Viking` -- and share the same
`Implementation`. `LiveChampionsSpecialization` finds the trees through
`SkillBase.GetSpecializationByType`, by **type** rather than by name, which is
why three different naming conventions coexist without anything being wrong.

So an empty `Champion Abilities <Realm>` line is not a symptom. I recorded it
as a probable fault in an earlier note; it was not one.

## The rule the grants follow

Every class is granted its realm's champion specialisation plus **every
archetype tree in that realm except its own**.

| Realm | Archetypes | Trees per class |
|---|---|---|
| Albion | Acolyte, Disciple, Elementalist, Fighter, Mage, Rogue | 5 |
| Hibernia | Forester, Guardian, Magician, Naturalist, Stalker | 4 |
| Midgard | Mystic, Rogue, Seer, Viking | 3 |

It holds for every class in the table. A Bainshee is a Magician and gets the
other four; an Animist is a Forester and gets the other four; a Bonedancer is a
Mystic and gets the other three.

---

## What was wrong

**The Midgard and Hibernia Maulers had each other's champion trees.**

| | Champion spec | Trees |
|---|---|---|
| 60 MaulerAlb | Albion | 5 Albion, no Fighter -- correct |
| 61 MaulerMid | **Hibernia** | 4 Hibernia, no Guardian |
| 62 MaulerHib | **Midgard** | 3 Midgard, no Viking |

Not two mistakes but one swap: 61 held exactly the set a *Hibernian* Mauler
should have, and 62 exactly the set a *Midgard* one should have. That is why it
survived -- read on its own, each row looks entirely plausible, and it is only
the class id beside it that is wrong.

A Midgard Mauler reaching champion level was offered Hibernia's trees, and a
Hibernian Mauler was offered Midgard's. Since the tree is built from these
rows, they would have trained the wrong realm's abilities outright.

Corrected in migration 106. Everything else about those two classes was right:
the career markers, the weapon lines, the Master Level lines.

---

## What to test

1. Take a **Midgard Mauler** to champion level and open the champion window.
   Mystic, Rogue and Seer, and no Hibernia trees.
2. The same for a **Hibernian Mauler**: Forester, Magician, Naturalist,
   Stalker.
3. Any class at all -- train a champion ability and confirm it is granted and
   usable. **Nobody has ever done this here.** The realm swap was found by
   reading the tables, and the fact that the wiring looks right is not the same
   as having seen a champion ability fire.

`cl_xp_per_level` (category `progression`) controls the rate;
`scripts/progression/ChampionLevels.cs` is what grants the experience at all,
since the core carries the field and never fills it.
