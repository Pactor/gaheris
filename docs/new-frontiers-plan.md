# Converting to New Frontiers

A plan, not a change. Nothing here is implemented.

## What this actually is

Not an import. A **swap**.

Old Frontiers and New Frontiers share one `KeepID` space, because a server runs
one set or the other and never holds both. Twenty-one IDs mean different things
in the two: **50-56, 75-81 and 100-106** are our old-frontier keeps in regions
1, 100 and 200, and New Frontiers keeps in Eve's dump. That is why importing her
keep data on its own word silently bolted 798 New Frontiers components onto
Albion, Midgard and Hibernia — caught and reverted; see the header of
`sql/33-battleground-keeps.sql`.

So converting means **giving up the old-frontier keeps that own those IDs**, not
adding anything alongside them.

## What is already in place

| | |
|---|---|
| `keephookpoint` | 729 rows, imported (migration 31) |
| `keepposition` | 279 rows, imported (migration 32) |
| NF keeps in the dump | 105, in `dol-db/Keep.json` |
| NF components in the dump | 966, in `dol-db/KeepComponent.json` |
| region 163 today | **0 mobs**, 0 keeps |
| travel to region 163 | removed in migration 24 (15 destinations) |

Hook points and positions are keyed on **component skin**, not `KeepID`, so they
already serve either frontier. They are the part that did not need a decision.

`KeepManager.DEFAULT_FRONTIERS_REGION` is already `163`, and
`m_frontierRegionsList` already contains it, so the core is expecting this
region to be the frontier whether or not anything is in it.

## The garrison problem, which is the real work

`keepposition.ClassType` names the **core RvR guard classes**:

```
DOL.GS.Keeps.GuardFighter        74
DOL.GS.Keeps.GuardArcher         25
DOL.GS.Keeps.GuardStaticArcher   25
DOL.GS.Keeps.GuardLord           14
DOL.GS.Keeps.GameKeepDoor        80
...
```

Not ours. Our Gaheris garrison is 872 hand-placed `mob` rows using
`DOL.GS.Scripts.MonsterGuard*` — Fighter, Archer, Commander, Lord, Healer,
Caster, StaticArcher, StaticCaster, Stealther — each of which calls
`Garrison.ScaleToKeep` in `AddToWorld`, which is our standing workaround for the
null `Component` trap.

**A New Frontiers keep raised from components would garrison itself with realm
guards, not Gaheris keep lords.** That is the thing to solve before anything
else is worth doing.

### This is already happening in the battlegrounds

Migration 33 gave the battleground keeps their components, and they now spawn
core guards from these positions. This boot:

```
DOL.GS.Keeps.GuardFighter name=Guardian
DOL.GS.Keeps.GuardFighter name=Huscarl
DOL.GS.Keeps.GuardArcher  name=Hunter
```

So the battlegrounds currently have two garrisons of different kinds: our
hand-placed monster guards, and core realm guards raised from architecture.
Worth deciding on its own merits, ahead of and separately from New Frontiers.

### Three ways to solve it

1. **Rewrite `keepposition.ClassType`** to the `MonsterGuard*` equivalents. One
   migration, affects every keep built from those skins — which is what we want
   for a PvE server, and which also fixes the battlegrounds. Cheapest and most
   consistent. The risk is that our classes derive from the core ones
   (`MonsterGuardFighter : GuardFighter`), so they must survive being
   constructed by `FillPositions` rather than loaded from a `mob` row — that is
   exactly the null-`Component` path, and it is the one thing to test first.
2. **Subclass per position type in code** and leave the data alone. More code,
   no migration, same outcome.
3. **Leave positions alone and hand-place the garrison**, as we did for the old
   frontiers. 105 keeps is far too many for that.

Recommend **1**, proven on one battleground keep before it is applied anywhere.

## Steps, in order

1. **Decide the garrison question above** and prove it on a single battleground
   keep. Nothing else starts until a keep raised from components garrisons
   itself with Gaheris monsters that scale correctly.
2. **Back up.** `mob`, `keep`, `keepcomponent`, `keepposition`, `teleport`,
   `zonepoint`. This is the one change in this project that cannot be undone by
   deleting rows, because it retires data we still want.
3. **Retire the old-frontier keeps** holding the contested IDs — 50-56, 75-81,
   100-106 — and their hand-placed garrison in regions 1, 100 and 200. Keep the
   rows in a dated backup table rather than deleting them, so the swap is
   reversible.
4. **Import the 105 NF keeps and 966 components** with the collision check from
   `sql/33`, which should now find no collisions at all.
5. **Populate region 163.** It has 0 mobs. Keeps alone are not a frontier —
   there is nothing between them to fight. Sources: the same DOL dump, or the NF
   server checkout at `/mnt/e/AITestProjects/UO/DOLServer-DAoC-NewFrontiers/`.
6. **Towers.** OpenDAoC does not create them; the NF fork does. Check
   `DefaultKeepManager` against the fork before assuming the 105 keeps include
   towers or that they will stand up without it.
7. **Restore travel.** Re-run the New Frontiers section of `sql/16-portals.sql`
   to put the 15 destinations back, and add region 163 to `FamilyOf` in
   `GaherisTravel.cs` — it currently falls through to "Midgard" on the numeric
   rule, which is wrong and only harmless because nothing points there.
8. **Wardens.** Region 163 needs its own, or every trip there is one-way. The
   rule from migration 25 applies: a warden at every arrival point.

## What to watch

- **`zones.Realm` is 0 for every row in this database.** Anything in the keep or
  frontier code that reads it will behave oddly. It already broke the travel
  menu once.
- **Keep ownership on a one-realm server.** New Frontiers assumes three realms
  taking keeps off each other. Decide what a captured keep means here before
  turning it on, or the answer will be decided by accident.
- **Boot cost.** 105 keeps and 966 components, each raising a garrison from
  positions. The battlegrounds' 1078 components cost roughly nothing, but they
  are mostly empty of positions; New Frontiers keeps are not.

## Rollback

Steps 4-8 are all additive and revert by deleting what they added. **Step 3 is
the point of no return** — keep the retired rows in a backup table, and treat
that table as the thing that makes this reversible.
