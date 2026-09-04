# Realm abilities

Swept 4 September 2026, hunting for more faults of the kind that had the
Midgard and Hibernia Maulers training each other's champion trees.

**No second swap was found.** What turned up instead is a set of omissions,
which are recorded here and deliberately not fixed, because two of the three
need a source I could not find.

---

## The rule

From the official realm abilities page: *every class is granted a free
class-specific RA at Realm Rank 5*, most on a ten or fifteen minute timer.

That makes a class with no class-specific ability a fault by definition, and
gives a way to check the table: 47 classes have realm ability rows, and each
should have exactly one ability nobody else has.

---

## Nine classes have no realm rank 5 ability

| Class | | Class | |
|---|---|---|---|
| 3 | Scout | 46 | Warden |
| 7 | Wizard | 50 | Ranger |
| 10 | Friar | 60 | MaulerAlb |
| 25 | Hunter | 61 | MaulerMid |
| | | 62 | MaulerHib |

Everyone else has one. Thirty-one classes carry an `AtlasOF_*` ability that no
other class has -- Bard's Ameliorating Melodies, Cleric's Bunker of Faith,
Reaver's Unquenchable Thirst, Savage's Ravager, and so on -- and the five
Catacombs classes carry plain-named ones instead: Heretic Fanaticism, Valkyrie
Valhalla's Blessing, Bainshee Sonic Barrier, Vampiir Mark of Prey, Warlock
Boiling Cauldron.

The three Maulers having none fits their history -- they arrived in 2006, two
expansions after most of this data.

## The Heretic has two, and the Friar has none

`33 Heretic` holds both **Fanaticism** and **Divine Intervention**.

Fanaticism is certainly his: the patch notes name it as the Heretic RR5, and
its own description in our database begins *"All Heretic groupmates..."*.

Divine Intervention is the odd one -- *"Gives the group a buff that provides a
pool of healing... Does not heal the user"* -- and the Friar, an obvious
candidate to own it, is one of the nine classes with nothing.

**Not moved.** It reads like the Friar's, and the shape is exactly the Mauler
swap's -- one class with two, another with none -- but I could not find a
source naming its owner, and the realm ability lists that are easy to reach
deliberately omit RR5s. Confirm before touching it.

## Two classes lack Avoidance of Magic

`AtlasOF_AvoidanceOfMagic` is held by 45 of 47 classes. The two without it are
**39 Bainshee** and **59 Warlock** -- both Catacombs casters, both classes that
have already turned out to be missing things elsewhere for the same reason:
they were added late and the data was not revisited.

Avoidance of Magic is an ordinary RA rather than a class-specific one, so there
is no reason for a caster to be excluded. **Not added**, on the same principle:
it looks like an omission and reads like one, but "45 of 47 have it" is an
argument from consistency rather than a source.

---

## What was checked and is clean

- **Champion grants**, every class against the realm its class file lives in,
  and the count against that realm's archetype total. Clean except the Mauler
  swap, which is fixed. See `champion-levels.md`.
- **Career specialisations** that name a realm -- `AlbClothCasterCareer`,
  `HibClothCasterCareer`, `MidClothCasterCareer`, `MidgardRogueCareer` and the
  three Mauler careers. Every grant matches its class's realm.
- **`spellline.ClassIDHint`**, all 22 hinted lines. Each names the class whose
  line it is -- Theurgist's Abrasion, Bonedancer's Bone Guardians, Valewalker's
  Arboreal Path, and so on. No line is hinted at the wrong class.
- **Mark of Prey on the Vampiir**, which looked misplaced because the core has
  it under `realmabilities/effects/rr5/` and the name suggests a Warden.
  Its description settles it: *"Grants all members of the Vampiir's group a 30
  second damage add... returned to the Vampiir as power."* It is his.

---

## A caveat on the earlier class audit

The cross-class sweep in `shrouded-isles.md` and the class documents joined
spell lines to classes through `spellline.Spec` alone, without applying
`ClassIDHint`. That makes the "spell types reachable" counts a **superset** --
a Bonedancer's figure includes lines hinted at the Runemaster and Spiritmaster,
which the game filters out at runtime.

It does not affect the conclusion drawn from it, which was that every reachable
type has a handler: a superset with no gaps means the real set has none either.
It does mean the counts should not be quoted as the size of a class's spell
list.
