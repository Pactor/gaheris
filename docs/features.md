# Taking a piece of this

This repo is an overlay on a stock OpenDAoC server: scripts dropped into the
custom-script directory, migrations applied to the database. Nothing here needs
you to build OpenDAoC and nothing here modifies it.

So you can take one piece rather than all of it -- the hired companions without
the co-operative ruleset, one class repair on its own to see what it does. This
page is the map.

```bash
./install.sh --list                  # every feature, and what it needs
./install.sh --dry-run bainshee      # name the migrations, apply nothing
./install.sh bainshee                # that feature and its dependencies
./install.sh mercenaries travel      # several at once
./install.sh                         # all of it, the tested path

./install.sh --diff                  # what differs from the last backup
./install.sh --restore               # put the last backup back
```

A **backup is taken automatically** before anything is applied, because there
are no down migrations. `--no-backup` skips it if you insist.

`sql/features.conf` is the machine-readable version and the one `install.sh`
reads. If this page and that file ever disagree, believe the file.

---

## Before anything else: boot once

**Start the server before installing.** Seven migrations only *update* server
properties -- the experience rates, the loot rates, `/level`, and others -- and
those rows do not exist until the gameserver has created them from its own
`[ServerProperty]` attributes. A stock database has four of them; a booted one
has around four hundred and seventy.

Install onto a database the server has never run against and every one of those
updates matches nothing, silently. `install.sh` now checks and warns, but the
order in the README is the right one: `docker compose up -d`, wait for
`Server is now listening`, then install.

---

## The catalogue

Twenty-three features. The counts add to the 117 migrations in the repo --
nothing orphaned, nothing counted twice.

### Foundation

| Feature | Migrations | Needs | What you get |
|---|---|---|---|
| `base` | 23 | — | the co-operative conversion, keep and garrison fixes, experience and loot rates, starting points, the custom player class |
| `travel` | 11 | base | travel catalogue, Gate Wardens, portals, zone points |

### Content

| Feature | Migrations | Needs | What you get |
|---|---|---|---|
| `frontiers` | 12 | travel | New Frontiers: population, objects, crossings, border keeps, the way home |
| `battlegrounds` | 5 | base | the designed battlegrounds and Molvik |
| `mercenaries` | 2 | base | hired companions and the recruiters who sell them |
| `seals` | 1 | base | dreaded seals as a currency |
| `atlantis` | 6 | travel | Trials of Atlantis zones, population, Hall of the Corrupt |
| `artifacts` | 2 | atlantis | artifact scrolls and the wiring that turns them into artifacts |
| `taskdungeons` | 8 | base | fifteen task dungeons, masters, doors, populations |

### Progression

| Feature | Migrations | Needs | What you get |
|---|---|---|---|
| `champion` | 6 | base | champion trees, their spell lines, who may train them |
| `masterlevels` | 5 | base | the eight Master Level paths, their spells and gaps |
| `realmabilities` | 2 | base | realm ability tables for the classes that had none |

### Classes

`classdata` is the floor. Everything below it sits on top and **each one
installs on its own**, which is the point -- you can put one class repair on a
server and see what it does.

| Feature | Migrations | What you get |
|---|---|---|
| `classdata` | 14 | spell lines, spells, line-to-spell mappings, combat styles, style procs, and reopening the classes that were switched off |
| `warlock` | 4 | Quickcast, primary spells, and paying for the weave |
| `heretic` | 2 | the three uninterruptible Blazes, and catching resurrection |
| `bainshee` | 2 | the uninterruptible wail, and trainers in Hibernia |
| `valkyrie` | 1 | nine trainers in the home realms |
| `maulers` | 1 | the swapped Midgard and Hibernia champion trees |
| `vampiir` | 1 | Mark of Prey remembering who cast it |
| `animist` | 1 | Fungal Potency getting a type and a target |
| `rr5` | 3 | five classes given their RR5 back, the Wizard's Wall of Flame, the Mentalist's Severing the Tether |
| `classfixes` | 5 | duplicate spell line rows, a hybrid line never marked as one, water breathing songs, one Resistance of the Ancients, three realm abilities every expansion class lacked |
| `classes` | — | all of the above together |

---

## Three things that will catch you out

### No set of migrations is one expansion

You can install `bainshee` on its own. You **cannot** install "catacombs"
without the Maulers, because migrations 46 and 89 through 92 are bulk imports
-- spell lines, spells, mappings, styles and procs -- carrying every expansion
class at once. `install.sh catacombs` says so and gives you `classes`.

The individual *fixes* separate cleanly. The *data underneath them* does not.

### A feature is not always a folder

Some mechanics belong to more than one class and sit where the mechanic sits.
The Mauler is the worst case:

| Piece | Where |
|---|---|
| Combat power, for hires | `scripts/classes/shared/CombatPower.cs` |
| Disarm and Silence | `scripts/core/DisarmAndSilence.cs` |
| Swapped champion realms | `sql/106-...` |

`scripts/classes/README.md` spells that one out. The rule: `core/` holds
OpenDAoC bugs any server has, `classes/shared/` holds mechanics more than one
class owns, and neither is optional if you want the class to work.

### Order matters, and the installer enforces it

Migrations are applied in **numeric** order, never in the order `features.conf`
lists them. The bulk imports at 46 and 89-92 overwrite what came before them,
so a correction numbered above them must run after them -- and a plain shell
glob sorts `100` between `10` and `11`, which once put every migration from 100
up *before* 11 through 99 and silently undid a season of corrections on fresh
installs. That bug is why `sort -V` and this paragraph both exist.

Anything not named in `features.conf` falls through to `base`, so a migration
added later is applied by default rather than quietly skipped.

---

## Backing out

There are no down migrations. Undo is restore-from-backup:

```bash
./install.sh --diff        # which tables differ from the last backup
./install.sh --restore     # put it back (asks you to type the database name)
```

Backups land in `backups/` as `<database>-<timestamp>.sql.gz`, with a
`.fingerprint` beside them -- a checksum per table, so `--diff` catches a
migration that only *updated* rows, which a row count would miss. `backups/` is
gitignored.

`--restore` replaces the whole database. Everything since that backup goes,
characters included. Stop the gameserver first.

---

## What has actually been tested

`install.sh mercenaries` was installed onto a database built from the stock
OpenDAoC seed, on 5 September 2026. All 25 migrations applied cleanly, the
recruiters appeared, and nothing from the task dungeons or the class work came
with it.

**Everything else is derived from the migration headers.** The full install
remains the only path this server itself has ever been built by.
