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

**The Wizard's is now granted too** -- migration 108. All six are fixed, and
every one of the 47 classes has a class-specific ability backed by a real
handler.

| Wizard | Wall of Flame | a ward at the caster's feet, 400 fire damage every 3 seconds for 15, radius 150 |
|---|---|---|

Nothing had to be written for it either. `WallOfFlameAbility`, the pulsing
`WallOfFlameBase` static, and the `ability` row (id 122) all existed; no class
had ever been granted it.

Migration 107 said this one "cannot be granted, only written". **That was
wrong**, and the reason is worth keeping: the published RR5 listing calls it
*Wall of Fire* and the game calls it **Wall of Flame**. Searching the source's
name instead of the code's found nothing, and I reported nothing there. The
lesson is the same one the Purge variants taught an hour earlier -- an absence
in a search is not an absence in the data.

One discrepancy deliberately left: the ability page gives a fifteen minute
reuse, and the core's `GetReUseDelay` returns 600, which is ten. Changing it
means subclassing the handler and repointing `Implementation` at the subclass
-- machinery for one number, on a single source, when most RR5s sit on "a ten
or fifteen minute timer".

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

## Verification, not inventory

Everything above this line was an existence check -- granted, has a row, has a
handler file. That is not the same as working, and the difference is where
every fault in this project has lived. Three checks that test function:

**1. Does the implementation instantiate?** `SkillBase` warns at boot when an
ability's `Implementation` will not resolve and silently substitutes an inert
default. 123 abilities are granted; 122 instantiate; one does not, below.

Read it from the boot log, not from the source tree -- `ResolveType` matches
**case-insensitively**, so a grep for the exact class name produces false
positives. `AtlasOF_MasteryOfConcentration` is granted to 20 classes and the
class is spelled `AtlasOF_MasteryofConcentration`; grepping said it was broken
and the log said it was fine. The log is right.

**2. Is the handler wired to an event that never fires?** Four granted
abilities were. All four are now fixed, in
`scripts/realmabilities/BlowsThatNeverLanded.cs`:

| Ability | Class | What it lost | Now |
|---|---|---|---|
| Shield Trip | Scout | root should break when the target is hit | breaks |
| Entwining Snakes | Hunter | snare should break when the target is hit | breaks |
| Fury of Nature | Warden | damage dealt should heal the group | heals (see below) |
| **Mark of Prey** | **Vampiir** | the damage add should return power | returns it |

Every one of them hangs its purpose on a blow landing, so all four are served
by a single handler on `GameObjectEvent.TakeDamage` -- raised, once per landed
blow, naming both ends. It asks the victim whether they are held by one of the
first two, and the striker whether they carry one of the second two.

It reacts only to Crush, Slash and Thrust. That is the right filter -- all four
are melee abilities -- and it is also what stops Mark of Prey feeding itself,
since the damage it adds is Heat and cannot return as another melee blow.

Two things worth knowing:

**Mark of Prey needed a database change.** The core's effect keeps its caster
in a private field and exposes it to nothing, so there was no way to know which
Vampiir to pay. Migration 109 points the ability at a subclass that records
both ends. The formula is the core's, unchanged; the swing interval is read
from the striker's weapon because `TakeDamage` does not carry the `AttackData`
the original handler was given -- the same number, since the swing that
produced the blow is the swing being timed.

**Fury of Nature is fixed by half, deliberately.** The healing is restored. The
style damage doubling is not: the core doubles `AttackData.StyleDamage` before
the blow is applied, and `TakeDamage` arrives afterwards carrying a total with
no style component in it. Restoring that would mean guessing which part of the
number came from the style. The healing is the half the delve leads with, and
the half that was doing nothing at all.

The core files still subscribe to the dead events -- those are core, untouched,
and now simply redundant. A repeat of this audit will still name these four;
that is the check being blunt, not the abilities being broken.

**3. Do the champion and Master Level trees hold anything unhandled?** No. Every
spell in the 63 champion archetype lines has a type, and all 15 types have
handlers. Every ML spell type has a handler. The only ML faults are the two
blank-type spells and the six holds, both recorded in `master-levels.md`.

## The Mentalist's RR5 was granted and inert. It is now written.

Found in the boot log after migration 108, which is worth noting on its own:
`SkillBase` warns when an ability's `Implementation` will not instantiate, and
falls back to a do-nothing `Ability`. Sixteen abilities trigger that warning.

Fifteen are legacy rows nobody is granted, so they cost nothing. The sixteenth
is **`AtlasOF_SeveringTheTether`, granted to the Mentalist (42)** as its
class-specific ability.

The class does not exist. The only occurrence of that name anywhere in the core
is the commented-out helper script that inserts the grant. So a Mentalist
reaching RR5 gets the ability on their bar and it does nothing at all, with one
warning at boot and silence thereafter.

Written in `scripts/realmabilities/SeveringTheTether.cs` and pointed at by
migration 110. Ground targeted, thousand unit radius: summoned pets are
unmade, charmed ones are let go. Thirty minutes reuse when it catches
something, three seconds when it catches nothing, so a misjudged cast costs
almost nothing.

Two choices worth recording, since neither came from a source:

**Charms are released by ending the charm effect** rather than by unpicking it.
`CharmECSGameEffect.OnStopEffect` already restores the creature's brain, clears
its aggro, and turns a sustained charm back on whoever held it. Calling it is
better than reimplementing it.

**Who it may touch is left to `GameServer.ServerRules.IsAllowedToAttack`** on
the pet's *owner*, rather than a rule written here. On a co-operative server
that means monster pets and never a groupmate's or a hired hand's.

Worth knowing before it is judged: on live this counters enemy pet classes in
RvR. Here the only pets it will ever meet are monsters', so it is a far
narrower ability than it was designed to be. It works; it will not often be
useful.

**Every granted ability now instantiates.** Fifteen abilities still fail at
boot and none of them are granted to anybody -- they are legacy rows. Checking
the boot log for these warnings is a cheap audit and was not part of the sweep
above; it is worth repeating after any ability change.

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
