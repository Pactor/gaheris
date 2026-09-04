# Realm abilities

Swept 4 September 2026, hunting for more faults of the kind that had the
Midgard and Hibernia Maulers training each other's champion trees, then chased
each finding to a source.

**No second swap exists.** What turned up was one real omission, now fixed, and
one question that is still open.

---

## The rule

From the official realm abilities page: *every class is granted a free
class-specific ability at Realm Rank 5*, most on a ten or fifteen minute timer.

47 classes have realm ability rows, so each should have one such ability.

## Six classes had no realm rank 5 ability. Five now do.

Names taken from a published RR5 listing rather than guessed. All five already
existed in the `ability` table with a working `Implementation` pointing at a
real handler class -- nobody had ever been granted them, so they sat
unreachable.

| Class | Ability | |
|---|---|---|
| Scout | Shield Trip | throws the shield, rooting the target |
| Friar | Whirling Staff | PBAE that stops melee in a 350 radius |
| Hunter | Entwining Snakes | insta-cast PBAE 50% snare (listed as "Entwining Stakes") |
| Warden | Fury of Nature | double style damage, returned to the group as healing |
| Ranger | Desperate Bowman | bow style, 300 damage and a 5 second stun |

Granted in migration 107, with ids following the `<Class>-RR5` convention the
other explicitly-added ones use.

**The Wizard's is not fixed.** "Wall of Fire" has no row in `ability` and no
handler anywhere in the core. It cannot be granted, only written.

**Before testing these:** Shield Trip, Entwining Snakes and Fury of Nature all
register handlers on `AttackedByEnemy` or `AttackFinished`, neither of which
this server raises. They will be granted and castable, but parts of them will
not fire. See `dead-events.md`.

---

## Two leads that died on inspection

Both are worth recording, because both looked like the Mauler swap and neither
was.

**Mark of Prey on the Vampiir.** The core files it under `rr5/` and the name
reads like a Warden ability. Its own description settles it: *"Grants all
members of the Vampiir's group a 30 second damage add... returned to the
Vampiir as power."* It is his.

**Divine Intervention on the Heretic.** He holds two -- Fanaticism, which the
patch notes confirm is his, and Divine Intervention, a group healing pool. The
Friar looked like the obvious owner and had nothing, which is exactly the
one-class-with-two, one-with-none shape.

It is wrong. **The Friar's RR5 is Whirling Staff**, and Divine Intervention does
not appear in the RR5 listing at all -- it is not a realm rank 5 ability. Why
the Heretic alone has it is unexplained, but it is not a misplaced RR5 and
moving it to the Friar would have been a mistake dressed up as a fix.

**And the Maulers were never missing one.** All three share `Gift of Perizor`,
keyed `Mauler60-RR5` through `Mauler62-RR5`. My first count called them missing
because it defined "class-specific" as held by two classes or fewer, and theirs
is held by three. Nine was never the number; six was.

---

## Still open: Avoidance of Magic

`AtlasOF_AvoidanceOfMagic` is held by 45 of 47 classes. The two without it are
**39 Bainshee** and **59 Warlock** -- both Catacombs casters. The Vampiir, also
Catacombs, has it.

**Not added.** The published ability page describes what it does and links a
class list that is not reachable, so there is no source saying those two should
have it. 45 of 47 is an argument from consistency.

It is worth saying why that caution earned its keep here. The two classes also
appeared to be missing **Purge**, which would have been damning -- no caster
plays without it. They are not: there are three Purge keys in this database,
and both hold `AtlasOF_PurgeReduced`. `AtlasOF_Purge` covers 32 classes and
`AtlasOF_PurgeReduced` the other 15, together exactly 47. The gap was in my
query, not the data.

The other five they both lack -- Mastery of Water, Regeneration, Tireless,
Mastery of Pain, Mastery of the Arcane -- are held by 39, 39, 39, 29 and 25
classes respectively, so none is universal and none is evidence of anything.

That leaves Avoidance of Magic alone, on consistency alone. Confirm before
adding it.

---

## What was checked and is clean

- **Champion grants**, every class against the realm its class file lives in,
  and the tree count against that realm's archetype total. Clean except the
  Mauler swap. See `champion-levels.md`.
- **Career specialisations** naming a realm -- every grant matches its class.
- **`spellline.ClassIDHint`**, all 22 hinted lines, each naming its own class.

---

## A caveat on the earlier class audit

The cross-class sweep in `shrouded-isles.md` and the class documents joined
spell lines to classes through `spellline.Spec` alone, without applying
`ClassIDHint`. That makes the "spell types reachable" counts a **superset** --
a Bonedancer's figure includes lines hinted at the Runemaster and Spiritmaster,
which the game filters out at runtime.

It does not affect the conclusion drawn from it -- a superset with no missing
handlers means the real set has none either -- but the counts should not be
quoted as the size of a class's spell list.
