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
the harvester used for Atlantis did exactly this and only needed its zone list
narrowed to 89. (That tooling is no longer in the repository -- see the README
-- but the approach is one request a second against `mobs.php?f=xml&m=<id>`.) The gap versus db-public is that capnbry gives name, level
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

## 3c. disorder.dk -- a good reference, not a source

`https://disorder.dk/daoc/bestiary/zone.php?load=NN` -- the **Uthgard 2.0**
bestiary, built from submitted kill logs. 67 zones indexed, and the zone list
is at `/daoc/bestiary/`.

What a zone page gives, per monster:

```
name    level from / level to    aggro    total killed    droprate    avg kill value
```

Example, Abermenai (`load=64`), 24 monsters:

```
crag bear        24-25  aggressive     chinook      29-30  aggressive
crag wolf        23-24  aggressive     squall       27-28  aggressive
crag lynx        25-26  aggressive     gust         22-23  neutral
crag badger      27-28  aggressive     rubble       25-26  neutral
crag crab        20-21  aggressive     shifter      26-27  neutral
Viking Huscarl   23-25  aggressive     Seism        31-32  aggressive
Viking Jarl      25-26  aggressive     Jarl Abermenai  32  aggressive
```

**It has no coordinates and no models.** It says what lives in a zone and how
dangerous it is; it cannot place anything.

That makes it excellent for cross-checking levels and aggro across the 67
zones it covers, and useless on its own for filling an empty one.

### The two empty battlegrounds

`Wilton` (region 240) and `Abermenai` (region 253) hold zero mobs. Checked
every source:

| source | Wilton | Abermenai |
|---|---|---|
| our database | 0 mobs | 0 mobs |
| db-public | nothing | nothing |
| capnbry | not indexed | **indexed as zone 253, but 0 mobs surveyed** |
| disorder.dk | not indexed | **24 monsters, no coordinates** |

So Abermenai has a creature list and nothing else, and Wilton has nothing at
all.

Reconstructing Abermenai would mean inventing **every position** -- no source
has one -- and roughly seven of the 24 models. Matching the rest by name only
half works: `crag bear` finds `umber bear` (96) and `crag wolf` finds
`white wolf` (459), but a naive substring match also pairs `gust` with
`evocatus Augusti` and `river rat` with `crater cicada`, so it needs a human
eye.

**Worth naming the line this crosses.** Everything imported so far has been
real data: db-public's rows, capnbry's radar coordinates, Eve's teleport
table. Abermenai would be the first zone we made up. That may well be fine --
it is your server -- but it should be a decision to *design* a battleground,
not a belief that we restored one.

---

## 3d. The model viewer -- and two models I got wrong

`https://daoc.ndlp.info/losojos-001-site1.btempurl.com/ModelViewer/`

A **model ID to name and picture** browser, 75 pages, filterable by category
(Biped male/female, Vampiir, Demons, Animals, Other, Not Categorised). Credits
Dawn of Light for the pictures and Eve of Darkness for the viewer itself, and
is hosted under the Los-Ojos DOLSharp fork's space.

**This is the reference we did not have when choosing models for Deep
Volcanus, and it immediately exposed two mistakes.**

The method used there was to match a creature's name against names already in
the world and take that model. It works when the match is representative and
fails badly when it lands on an outlier:

| chosen | because | what model actually is |
|---|---|---|
| `456` for Flame of Volcanus | one mob in the world is called "Flame" | **417 wyverns** |
| `456` for Typhon's Essence | same | **wyverns** |
| `666` for Battlewarder | "chrysiron statue" x18 sits on it | **1086 "storm effects"** -- invisible |

So the flames were wyverns and the Battlewarder could not be seen.

The lesson generalises: **take the model the MAJORITY of a family uses, never
a single name hit.** Corrected in `sql/23-volcanus-model-fixes.sql`:

```
125   Magma Elemental / magmatasm   an actual magma elemental
951   basalt golem                  a construct you can see
993   atevo statue (248 in world)   where 1203 palios statue has 9 uses
```

Still worth a second look, not yet changed: `Ancient Transmuter` sits on model
1191, which is overwhelmingly **taur** (elite taur defender, taur arieos --
several hundred). A centaur is not absurd for an Atlantis service NPC, but it
was not the intent.

---

## 3e. How keeps actually get their defenders

The question "which mobs defend which castle" has a structural answer, and it
is not a list.

**`KeepPosition` is keyed on `ComponentSkin` and `Height` -- not on KeepID.**

```json
{ "ClassType": "DOL.GS.Keeps.GameKeepDoor", "ComponentSkin": 24,
  "Height": 0, "XOff": 374, "YOff": -771, "ZOff": 0, "TemplateType": 1 }
```

A position says: *on a wall section of this skin, at this height, put this
guard at this offset*. A keep gets its garrison by being **built of components**
whose skins have positions defined. So the defenders of a castle are a
consequence of its architecture, not a roster attached to it.

Eve's data, per building block rather than per keep:

```
skin 30  62 positions     skin 24  33      skin 0   24
skin 10  20               skin 4   19      skin 31  15

GuardFighter 74   GameKeepDoor 67   GuardStaticArcher 25   GuardArcher 25
Patrol 16         GuardLord 13      GameKeepBanner 10      GuardHealer 9
FrontiersPortalStone 8   MissionMaster 5   FrontierHastener 3
GuardCaster 3     GuardStaticCaster 2      GuardStealther 1
```

### Why ours does not work that way

| | our live DB | Eve `~/dol-db` | upstream OpenDAoC-Database |
|---|---|---|---|
| keep | 79 | 151 | present |
| keepposition | 55 | **261** | ~55, mostly doors |
| keepcomponent | **0** | **2121** | ~0 |
| keephookpoint | **0** | **729** | ~0 |

**We have no components at all**, which is precisely why this project builds
garrisons out of `mob` rows and why `guard.Component` is always null -- the
trap that has bitten four times now. It is not a bug in our data; there is
simply no component layer to hang guards off.

Adopting Eve's would mean adopting the whole architecture: 2121 components,
729 hookpoints, 261 positions, and keeps that assemble themselves. That is a
different server design from the one running now, not an import.

---

## 3f. Other emulator projects worth knowing about

- **[TTom03/DOLServer-DAoC-NewFrontiers](https://github.com/TTom03/DOLServer-DAoC-NewFrontiers)**
  -- a real OpenDAoC fork, 13,190 commits, whose stated purpose is exactly the
  New Frontiers question: *"OpenDAoC was old frontiers. This repository will
  have New Frontiers implemented."* Also plans epic dungeons, CL5 dungeons, a
  revised Summoner's Hall and a modern quest system, and deliberately excludes
  artifacts. The README says nothing about bundled world data, so whether it
  carries NF keep data or only the code to run it is unresolved -- and it is
  the single most promising unexplored lead in this file.
- **[Eve-of-Darkness/eve-of-darkness](https://github.com/Eve-of-Darkness/eve-of-darkness)**
  -- a DAoC server in Elixir. Same people whose `db-public` and `dol-db` we
  have already mined.
- The **OpenDAoC organisation** has eleven repositories and none of them holds
  world data beyond `OpenDAoC-Database`, which we already have.

---

## 3g. The New Frontiers fork, examined

`TTom03/DOLServer-DAoC-NewFrontiers`, cloned to
`E:\AITestProjects\UO\DOLServer-DAoC-NewFrontiers`. 227 MB, 13,190 commits,
last touched 2026-03-01 with a merge from OpenDAoC upstream.

### It carries no world data

Twelve non-source files, all of them build artefacts and VS Code settings. No
SQL, no JSON, nothing for region 163. The keeps, components and positions are
not here.

### It carries the CODE that Old Frontiers does not need

Forty source files we do not have, and three of them matter:

```
GameServer/relics/TempleGuardsNF/     RelicCaster, RelicGuards, RelicHealer,
                                      RelicKeepGuards, RelicLord,
                                      RelicRoamingGuards
GameServer/relics/GameTempleRelicPad.cs
GameServer/keeps/Managers/RelicDefenseMgr.cs
```

`TempleGuardsNF` is a per-realm relic temple garrison -- a Relic Wizard at
model 61 for Albion, level 65, fifteen-minute respawn, and so on. That is
literally "a specific set of defenders for this castle", written out.

### The single most important line

`KeepManager.cs` differs, and the difference is not cosmetic. **OpenDAoC has
tower creation commented out; the fork has it enabled:**

```csharp
//  ours -- disabled
// if ((datakeep.KeepID >> 8) != 0 || ((datakeep.KeepID & 0xFF) > 150))
// {   keep = keepRegion.CreateGameKeepTower();   }
// else {
      keep = datakeep.SkinType == 99 ? CreateRelicGameKeep() : CreateGameKeep();
// }

//  theirs -- enabled
if ((datakeep.KeepID >> 8) != 0 || ((datakeep.KeepID & 0xFF) > 150))
{   keep = keepRegion.CreateGameKeepTower();   }
else
{   keep = datakeep.SkinType == 99 ? CreateRelicGameKeep() : CreateGameKeep();   }
```

Old Frontiers keeps have no towers, so OpenDAoC switched the branch off. New
Frontiers keeps do, and **which is which is encoded in the KeepID** -- a
non-zero high byte, or a low byte above 150, means tower. Our 79 keeps contain
no towers at all; Eve's 105 for region 163 do.

### So all three pieces are now located

| | where | state |
|---|---|---|
| the map | our own database, region 163 | 15 zones, present, empty |
| the data | Eve `~/dol-db` | 105 keeps, 2121 components, 261 positions, 729 hookpoints -- schema 100% compatible |
| the code | TTom03 fork | tower creation, relic temples, relic defence |

Nothing is missing any more. What remains is not research.

### The cost, stated plainly

Taking this means moving from **mob-row garrisons to component-built keeps**.
Everything this project does with keeps -- `MonsterGarrison.cs`, the guard
scaling, the seal payout, `ScaleToKeep`, the null-Component workarounds --
exists *because* there is no component layer. Give the server one and most of
that code is solving a problem it no longer has, while `MonsterGarrison`
continues to expect the old shape.

It is a second server design sitting alongside the first, not an import. Worth
doing deliberately, on a branch, with the Old Frontiers conversion left intact
until the new one actually works.

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
