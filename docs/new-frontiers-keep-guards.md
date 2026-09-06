# New Frontiers keep guards

A max-level keep should be fought through. Ours can be walked through: the
courtyard is empty, the stairs are empty, the path to the lord is empty, and
the lord is not in the room he should be in.

Opened 6 September 2026. The cause is found and recorded below; the fix is not
written yet.

---

## How it is supposed to work

Reported from live play, and it is the piece that made the rest make sense.

**The lord moves as the keep is upgraded.** He is not in a fixed room. There
are three positions, one per build tier, and the guards move with him -- at low
levels they stand outside and in the courtyard, and as the keep rises they fill
the stairs and the floors between the door and the lord.

Measured in game at Caer Hurbury, in Snowdonia (`/loc` gives zone coordinates;
Snowdonia is offset 68, 76, so world = local + 557056, 622592):

| keep level | lord, zone coords | heading | world coords |
|---|---|---|---|
| 1-3 | 43944, 26407, 8664 | 200 | 601000, 648999, 8664 |
| 4-7 | 44113, 26667, 9001 | 287 | 601169, 649259, 9001 |
| 8-10 | 43848, 26660, 9272 | 19 | 600904, 649252, 9272 |

He climbs: Z 8664, then 9001, then 9272. Three floors of the same building.
At 8-10 there is "plenty of guards to go through on the way up", and the lord
keeps clerics and damage dealers with him at every tier.

**Those three bands are core's build tiers exactly**, which is the confirmation
that this is a real mechanic and not a memory:

```
GetHeightFromLevel:  level 1 -> 0    2-4 -> 1    5-7 -> 2    8-10 -> 3
```

Height 0 and 1 are the ground room, height 2 the middle, height 3 the top. The
player-reported bands 1-3 / 4-7 / 8-10 line up on the same boundaries.

---

## What is actually wrong

**The new-skin keeps have no guard positions above height 1.**

`keepposition` rows carry a Height, and `FillPositions` walks down from the
component's height taking the first row it finds:

```csharp
for (int i = this.Height; i >= 0; i--)
    if (positionGroup[i] is DbKeepPosition position) { ...create...; break; }
```

So a height-3 keep looks for a height-3 row, then height 2, then 1. Counting
what exists:

| skin family | heights present |
|---|---|
| old skins (< 20) | 0, 1, 2, 3 |
| new skins (> 20) | 0, 1 only |

And the lord ladder shows it cleanly. The old tower, skin 11, has a lord at
every height:

```
skin 11   height 0, 1, 2, 3      one lord per build tier
skin 30   height 0, 1            new keep
skin 31   height 0, 1            new tower
```

New Frontiers runs on the new skins. So every keep in region 163, whatever its
level, falls back to the height-1 row: **the lord spawns one floor below where
a max-level keep should put him, and the floors above are unguarded because
those positions do not exist.**

That is the whole symptom. Not too few guards spread thinly -- the correct
mid-tier garrison, with the entire upper-tier garrison missing.

### Confirmed by measurement

Hurbury's lord was reported missing entirely. He is not. Computing his spawn
through core's own placement maths -- keep at (599604, 650643) heading 110, its
skin-30 component at grid (-6, 9) rotation 1, the lord's offset (347, -922)
with **ZOff 577** rotated onto it -- puts him at zone **44092, 26686, 9001**.

Against the position measured in game for a levels 4-7 keep, 44113, 26667,
9001: **21 units apart in X, 19 in Y, and exactly zero in Z.**

So the lord is standing on the middle floor of a Level 10 keep, which is why
he was not found: the search was on the top floor, where a max-level keep
should put him and where our data has nothing.

The match also cross-validates both sides. The positions remembered from live
play and the positions this database produces are describing the same building
to within twenty units, which is why the missing height 2 and 3 rows can be
treated as a genuine gap rather than a difference of opinion about what live
did.

An earlier note here said the lord falls back to the ground room. That was
wrong -- ZOff was read as 0 when it is 577 -- and the fallback is the middle
floor.

---

## Why this was not obvious

The keeps are at Level 10, so everything reads as "max level" and the guard
count looks like a tuning problem rather than a missing dataset. Three earlier
readings were wrong on the way here and are worth recording:

**The counts were miscounted twice.** First by ignoring the rotation filter --
`LoadPositions` also matches `ComponentRotation` against the component's
heading -- which inflated Benowyc from 41 to 108. Then by counting distinct
TemplateIDs rather than TemplateID per component, which is how core keys them.

**The data was assumed correct because it matches the reference.** It does:
every one of the public database's 261 rows is present. But the public Dawn of
Light database has the same gap -- it, too, has no height 2 or 3 rows for the
new skins -- so matching it proves the import was faithful, not that the data
is complete.

---

## Two rulesets, and where the line is

There are two garrison systems here and they must stay apart. They already do,
and the line is the frontier itself:

| | how guards are made | classes | ruleset |
|---|---|---|---|
| Old Frontiers, regions 1 / 100 / 200 | `mob` rows | `DOL.GS.Scripts.MonsterGuard*` | Gaheris, evil-held |
| New Frontiers, region 163 | `keepposition` | `DOL.GS.Keeps.Guard*` | normal RvR |

The Gaheris garrison is real and working: 474 fighters, 187 archers, 84
commanders and 31 lords across the old frontiers, all mob rows. Mob rows are
instantiated through a path that knows about the scripts assembly, which is why
they became dread legionnaires correctly.

**Renaming ClassType is not available as a mechanism for keep-position
guards**, and this is the thing to remember rather than rediscover.
`FillPositions` uses `Assembly.GetExecutingAssembly()`, which is the GameServer
assembly, so it can only build classes that live in core. A script class put
there returns null and the guard is silently skipped. That is what
`62-keepposition-monster-garrison.sql` did, and it emptied every New Frontiers
and battleground keep without logging anything; `sql/127` puts it back.

### The plan, in two stages

Stated 6 September 2026, and it is the order the rest of this work should
follow.

This server exists to play the Gaheris ruleset -- keeps held by the forces of
evil rather than by realms -- and that is what was built first. What was not
known at the time is how much of New Frontiers was broken underneath it. The
Gaheris layer was laid over a floor that was not sound.

**Stage one: make New Frontiers correct on the ordinary RvR ruleset.** Stock
behaviour, stock data, checkable against the public Dawn of Light database.
That is the baseline, and it is worth having for its own sake: it is the only
version of this that can be verified against an outside authority rather than
against opinion. Everything in this document above this line is stage one, and
it is not finished -- the missing height 2 and 3 positions are still missing.

**Stage two: a deliberate switch to the Gaheris ruleset**, applied on top of a
working baseline rather than edited into the data in place.

The constraint found today shapes stage two, so it is worth stating before
anyone starts: **the switch cannot be a ClassType rename.** `FillPositions`
uses `Assembly.GetExecutingAssembly()`, so keep-position guards can only ever
be classes that live in core. Naming a script class there returns null and the
guard is silently skipped, which is exactly what emptied the keeps. So the
switch has to be one of:

- the Monster classes moved somewhere core can instantiate them, or
- the guards post-processed after they spawn -- model, name and brain changed
  on a core guard rather than the class substituted.

The second is the smaller change and does not require touching core. Either
way it should be a toggle -- a server property, or a feature in
`sql/features.conf` -- so the two rulesets can be swapped without a migration
rewriting rows that then have to be reverted. That is the mistake worth not
repeating: `62-keepposition-monster-garrison.sql` changed the data rather than
adding a layer, and undoing it meant another migration.

One stale piece to be aware of: `Garrison.HeldByEvil` still answers true for
anything in region 163, written when New Frontiers was meant to be evil-held:

```csharp
return guard.CurrentRegionID == NEW_FRONTIERS;
```

Nothing consults it there any more, because that clause is only reached from
the Monster classes and New Frontiers no longer uses them. It is inert rather
than wrong, but it is misleading and should be revisited if the ruleset for
region 163 is ever settled the other way.

Battlegrounds also raise their garrisons from `keepposition`, so they went back
to realm guards with New Frontiers. That is the same decision, made once.

---

## What a fix has to supply

Guard positions at heights 2 and 3 for the new-skin components, at minimum
skin 30 (the keep) and skin 31 (the tower), including the lord's own position
at each tier.

The old skins have this data. They are the same keeps in different art, so the
old-skin ladder is the obvious model -- but the offsets cannot simply be
copied, because an old keep and a new keep are different buildings and a
position is an offset from the component. The three lord positions measured
above are real coordinates from a real keep and are the anchor to work from.

Nothing here is written yet.

---

## Unrelated, already fixed

Recorded so they are not re-investigated: six keeps had two lords and three
designs had healers standing inside one another, from four rows this repo
added that are not in the reference (`sql/123`). Thirteen doubled and corrupt
door rows, same cause (`sql/124`). Those were real and are gone, but neither
was the reason the keeps feel empty.
