# Taking a piece of this

This repo is an overlay on a stock OpenDAoC server: scripts dropped into the
custom-script directory, migrations applied to the database. Nothing here needs
you to build OpenDAoC and nothing here modifies it.

That makes it possible to take one piece rather than all of it -- the hired
companions without the co-operative ruleset, the class repairs without the task
dungeons. This page is the map.

```bash
./install.sh --list                  # what can be taken on its own
./install.sh --dry-run mercenaries   # name the migrations, apply nothing
./install.sh mercenaries             # that feature and what it depends on
./install.sh                         # all of it, the tested path
```

`sql/features.conf` is the machine-readable version and the one `install.sh`
reads. If the two ever disagree, believe the conf file.

---

## The features

Every one of them depends on **base**, which is the conversion itself plus the
world fixes that have no meaning on their own.

| Feature | What you get | Scripts | Migrations |
|---|---|---|---|
| **base** | the co-operative conversion, keep and garrison fixes, experience rates, starting points, the custom player class | `core/`, `gaheris/ServerRules.cs`, `gaheris/Settings.cs`, `gaheris/MonsterGarrison.cs`, `gaheris/StartingLevel.cs`, `gaheris/LevelCommand.cs` | 23 |
| **travel** | the travel catalogue, Gate Wardens, portals, zone points | `gaheris/Travel.cs`, `gaheris/FrontierReturn.cs`, `gaheris/InstanceExit.cs` | 11 |
| **frontiers** | New Frontiers: population, objects, crossings, border keeps | `gaheris/FrontierGateDoors.cs` | 12 |
| **battlegrounds** | the designed battlegrounds and Molvik | — | 5 |
| **mercenaries** | hired companions and the recruiters who sell them | `gaheris/Mercenaries.cs`, `MercenaryCommands.cs`, `MercenaryLoadout.cs`, `MercenaryTravel.cs`, `gaheris/Loot.cs` | 2 |
| **seals** | dreaded seals as a currency | `gaheris/Seals.cs` | 1 |
| **atlantis** | Trials of Atlantis: zones, artifacts, scrolls | `toa/` | 8 |
| **taskdungeons** | fifteen task dungeons, masters, doors, populations | `gaheris/TaskDungeon*.cs`, `TaskMaster.cs`, `MissionCommand.cs`, `DungeonTrail.cs` | 8 |
| **progression** | champion levels, master levels, the realm ability tables | `progression/` | 14 |
| **classes** | every class repair | `classes/` | 33 |

Those add up to 117, which is every migration in the repo -- nothing is
orphaned and nothing is counted twice.

---

## Two things that will catch you out

### The class data is one unit

You can take `classes/catacombs/bainshee/` and leave the Mauler. You **cannot**
take the Bainshee's migrations and leave the Mauler's, because migrations 46
and 89 through 92 are bulk imports -- spell lines, spells, line-to-spell
mappings and style procs -- carrying every expansion class at once. There is no
subset of them that is one class.

So `install.sh catacombs`, `install.sh maulers` and `install.sh bainshee` all
resolve to `classes` and say so. The scripts separate; the data does not.

### A feature is not always a folder

Some mechanics belong to more than one class, and sit where the mechanic sits
rather than where you would look for them. The Mauler is the worst case:

| Piece | Where |
|---|---|
| Combat power -- for hires | `classes/shared/CombatPower.cs` |
| Disarm and Silence | `core/DisarmAndSilence.cs` |
| Swapped champion realms | `sql/106-...` |

`scripts/classes/README.md` spells that one out. The general rule: `core/` holds
OpenDAoC bugs any server has, `classes/shared/` holds mechanics more than one
class owns, and neither is optional if you want the class to work.

---

## Order matters, and the installer enforces it

Migrations are applied in **numeric** order, never in the order they are listed
in `features.conf`. This is not fussiness. The bulk imports at 46 and 89-92
overwrite what came before them, so a correction numbered above them must run
after them -- and a plain shell glob sorts `100` between `10` and `11`, which
put every migration from 100 up *before* 11 through 99 and silently undid a
season of corrections on fresh installs. That bug is why `sort -V` and this
paragraph both exist.

Anything not named in `features.conf` is treated as part of `base`, so a
migration added later is applied by default rather than quietly skipped.

---

## What this does not do

It does not uninstall. Migrations add and correct rows; there is no down
script. Taking a feature into a live server is a one-way trip, so try it
somewhere you do not mind breaking, and read `--dry-run` first.

It also does not check whether you already have something. Every migration is
idempotent and safe to re-run, but "safe" means it will not corrupt anything --
not that it will notice your server already disagrees with it.

**The whole install is the tested path.** Feature installs are derived from the
migration headers and are correct as far as they have been read, but this
server has only ever been built by applying everything, in order.
