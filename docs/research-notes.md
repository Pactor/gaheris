# Research notes

Findings only. Nothing here has been applied to the server — this is a log of
what exists, where, and what it would take.

Written while the server was live; no restarts, no writes.

---

## 1. New Frontiers

**It is already in the database as a map, and completely empty.**

```
regions.RegionID 163  "New Frontiers"   IsFrontier = 0
  15 zones: Agramon, Irish Sea, Odin's Gate, Jamtland Mountains, Yggdra Forest,
            Uppland, Emain Macha, Breifine, Cruachan Gorge, Mount Collory,
            Snowdonia, Forest Sauvage, Pennine Mountains, Hadrian's Wall, ...

  mobs             0
  keeps            0
  keepcomponents   0
  teleport dests  15   <- these already exist and point into it
```

### How the server decides what the frontier is

`GameServer/keeps/KeepManager.cs`:

```csharp
public const int DEFAULT_FRONTIERS_REGION = 163; // New Frontiers
...
if (r.IsFrontier)
    m_frontierRegionsList.Add(r.ID);

// default to NF if no frontier regions found
if (m_frontierRegionsList.Count == 0)
    m_frontierRegionsList.Add(DEFAULT_FRONTIERS_REGION);
```

So the frontier is whatever `regions.IsFrontier = 1` says it is. Ours currently
says:

```
RegionID   1  Albion    IsFrontier = 1
RegionID 100  Midgard   IsFrontier = 1
RegionID 200  Hibernia  IsFrontier = 1
```

That is the **Old Frontiers**, and it is what the whole Gaheris conversion was
built on — 33 keeps across those three regions, regarrisoned with monsters.

### What activating New Frontiers would take

Four data imports and one flag. All four tables are **100% schema-compatible**
with what we have:

| source (Eve `~/dol-db`) | table | ours | theirs | overlap |
|---|---|---|---|---|
| `Keep.json` | `keep` | 20 | 20 | **20** |
| `KeepComponent.json` | `keepcomponent` | 10 | 10 | **10** |
| `KeepPosition.json` | `keepposition` | 13 | 13 | **13** |
| `KeepHookPoint.json` | `keephookpoint` | 9 | 9 | **9** |

Content available for region 163:

```
Keep.json          105 keeps   Caer Benowyc, Caer Berkstead, Caer Erasleigh,
                               Caer Boldiam, Caer Sursbrooke, Caer Hurbury,
                               Caer Renaris, Bledmeer Faste, Nottmoor Faste,
                               Hlidskialf Faste, Blendrake Faste, Glenlock
                               Faste, Fensalir Faste, Arvakr Faste + towers
KeepComponent.json 2121 rows   the physical structures
KeepPosition.json   261 rows   the defenders (see below)
KeepHookPoint.json  729 rows   siege / hookpoint slots
```

Then `UPDATE regions SET IsFrontier = 1 WHERE RegionID = 163` (and presumably 0
for 1/100/200, or the server treats both as frontier at once).

**The open question is not technical.** Our entire conversion — MonsterGarrison,
the garrison scaling, the seal payouts, the travel catalogue — is pointed at the
Old Frontiers keeps in regions 1/100/200. Moving to New Frontiers means either
redoing that work against 105 new keeps, or running both frontiers at once. That
is a decision, not a script.

---

## 2. Correct defenders per castle

**Source: `~/dol-db/KeepPosition.json` (Eve-of-Darkness).** We already have it
locally; it is what `gaheris-keeps.sql` and `keep-import.sql` were built from.

Eve's is materially richer than db-public's, and it is worth using the better one:

| | Eve `~/dol-db` | db-public |
|---|---|---|
| KeepPosition rows | **261** | 164 |
| distinct TemplateID | **224** | 119 |
| distinct ClassType | **14** | 13 |

Breakdown of Eve's 261:

```
GuardFighter        74      GameKeepDoor        67
GuardStaticArcher   25      GuardArcher         25
Patrol              16      GuardLord           13
```

db-public has only 33 GuardFighter and no GuardArcher at all, so Eve is the one
to import from.

`KeepPosition` is exactly the "which defender stands where, in which keep, at
which height" table — `KeepID`, `ComponentSkin`, `TemplateID`, `Height`,
`ClassType`, and the offsets. That is the data you were after.

**Caveat that bit us before:** our Gaheris guards are `mob` rows, not
`keepposition` rows, which is why `guard.Component` is always null here (see the
README). Importing `keepposition` for New Frontiers would create guards of the
*other* kind — the kind core expects. That is probably good, but it means two
different guard mechanisms would exist side by side, and `MonsterGarrison.cs`
only understands ours.

---

## 3. Volcanus

**Deep Volcanus is empty and db-public cannot fix it.**

```
our zones     46 / 89 / 146  "Deep Volcanus"    mobs: 0
db-public                                        mobs: NONE
capnbry zone 89 "Heart of Volcanus"              mobs: 56
```

capnbry is the **only** source that has it. 56 distinct mobs — apophian
aggressor / archon / crusher / enforcer (levels 61-65), Balance of the Four,
Ancient Transmuter, and the rest.

That is ~57 polite requests to harvest, which is nothing — the harvester in
`tools/harvest-atlantis.py` already does exactly this and just needs its zone
list narrowed to 89. The gap versus db-public is that capnbry gives name, level
and coordinates but **no model, no stats, no loot**, so imported mobs would need
models inferred by name before they were visible.

Worth noting the earlier correction: "5983 mobs indexed" on that site is the
**site-wide total**, not a per-zone count.

---

## 3b. Volcanus, in detail

Followed up properly. The short version: **the creatures can be imported, the
raid cannot be rebuilt, and nothing would be visible without inventing models.**

### What Deep Volcanus actually is

Master Level **7** -- not 10, as first assumed. From the ToA documentation:

> All of these trials, except the first one, happen inside Deep Volcanus, in
> Ashen Isle. Entry requirement to Volcanus is ML 3.

Trials: The Lava Bridge, Know your Opponents, Apophian's Challenge, Volurgon's
Challenge, Shaitan's Challenge, Hephaestian's Challenge, Crossing the Chamber,
Pillars.

Note the entrance is in **Ashen Isle**, which is zone 85 in region 73 -- and
that zone we DID populate. The way in is furnished; what is behind the door is
not.

### What capnbry actually lists

56 entries for zone 89, and a good half of them are not creatures at all. They
are the scaffolding a scripted raid is built from:

```
spell markers      Typhon spell effects 1/2, spell effects 1/2/3,
                   fire explosion, fire explosions, flame sphere
control entities   monster generator 1, monster generator 2,
                   T7E3-6 Inra Mediator Control
doors and walls    Typhon's Gate, Volurgon's Passage, mystical barrier
boss abilities     Katorii's Blood / Breath / Deathtouch / Foresight /
                   Gaze / Touch, Katorii's pet
```

The genuine creatures are four elemental factions and their bosses:

```
apophian      aggressor, archon, crusher, enforcer, controlled, feuding
hephaestian   archon, controlled, feuding, mastered
shaitan       archon, idol, zealot, controlled, feuding
volurgon      archon, chronomancer, psytinel, wretch, controlled,
              corrupt, feuding, mischievous, unruly
bosses        Typhon, Katorii, and a Mediator for each of the four
other         Battlewarder, Ancient Transmuter, Balance of the Four,
              Flame of Volcanus
```

Levels run 61-65 for the rank and file.

### Three blockers, in order of severity

1. **No models, and nothing to borrow.** Checked every one of the 56 names
   against our `mob` and `npctemplate` tables: **zero matches**. These
   creatures exist nowhere else in the world, and capnbry records name, level
   and coordinates but no model. Imported as-is they would be invisible.

2. **No encounter logic anywhere.** Grepped the whole of OpenDAoC-Core for
   typhon / katorii / volurgon / apophian / hephaestian / shaitan: the only hit
   is `AncientBoundDjinn.cs`, which is a teleporter. The generators, the gate,
   the mediator controls are inert rows without scripts to drive them.

3. **db-public has nothing** for regions 46 / 89 / 146, so the good source that
   solved the rest of Atlantis cannot help here.

### What is actually achievable

Import the ~30 real creatures with models chosen by hand from existing
elemental models, and Deep Volcanus becomes a populated level 61-65 fire
dungeon worth fighting through. That is worth having on a co-operative server.

What it would NOT be is Master Level 7. The trials are scripted content and
none of the scripting exists.

---

## 4. GitHub: is there an old DOL Gaheris project?

Searched. **No dedicated Gaheris server repository exists.** What is out there:

- [Dawn-of-Light/DOLSharp](https://github.com/Dawn-of-Light/DOLSharp) — the
  original emulator. Code only; the world data was always distributed separately
  and those downloads are gone.
- [Eve-of-Darkness/db-public](https://github.com/Eve-of-Darkness/db-public) —
  the database we imported Atlantis and the Master Levels from.
- [digitalbox94/DOLSharp-1127](https://github.com/digitalbox94/DOLSharp-1127) —
  a DOLSharp fork carried forward to **1.124-1.127**, which is our client
  version. Not yet examined; the most likely place to find 1.127-era fixes.
- [OpenDAoC/OpenDAoC-Core](https://github.com/OpenDAoC/OpenDAoC-Core) — ours.

**gaheris.net** turned up and is worth recording so nobody chases it twice. It
is dead (connection refused) but archived: captures from 2010 to 2015 or so,
titled "Gaheris: Home", with Forum / FAQ / Index / Links / About and the
footer "Site copyright 2010-2014 Robbie of Gaheris". It was a **player
community site for the live server** -- guides, a phpBB forum -- not a shard
and not a source of server data. Only the homepage was archived; the inner
pages have no captures at all.

Gaheris itself was a live Mythic/EA ruleset, never a community server, which is
why there is no repository for it. The ruleset is documented on the
[Camelot Herald wiki](https://camelotherald.fandom.com/wiki/Cooperative_Server_(Gaheris)_Information):
one realm, cross-realm grouping, no PvP except duels, and — the line this
project is built around — **realm points and realm abilities earned only from
NPCs**.

---

## Summary

| Want | Source | Status |
|---|---|---|
| New Frontiers map | already in DB (region 163, 15 zones) | present, empty, `IsFrontier=0` |
| NF keeps | Eve `Keep.json` | 105 keeps, schema 20/20 |
| **Correct defenders** | **Eve `KeepPosition.json`** | **261 rows, schema 13/13** |
| NF structures | Eve `KeepComponent.json` | 2121 rows, schema 10/10 |
| Volcanus mobs | capnbry zone 89 only | ~30 real creatures, no models, no encounter logic |
| Gaheris repo | — | does not exist |
