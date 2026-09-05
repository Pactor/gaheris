# scripts/

Everything here compiles into **one assembly** at server boot, from
`~/gaheris/scripts`, recursively -- `ScriptMgr.ParseDirectory` walks
subdirectories, skipping only `obj`. The folders below are therefore an
organising device and a delete unit, not separate builds.

**One bad file stops every script in the server**, not just its own folder.
Compile before deploying:

```bash
cd ~/scriptcheck && ~/.dotnet/dotnet build -v q --nologo
```

## The folders

| Folder | What it is | Safe to delete? |
|---|---|---|
| `core/` | OpenDAoC bugs and gaps any server has. Nothing to do with this server or any expansion. | Only if you want the bugs |
| `classes/` | Class mechanics the core never implemented, by expansion | Yes, per class |
| `progression/` | Champion levels, master levels, realm rank 15 -- endgame the core ships incomplete | Yes |
| `toa/` | Trials of Atlantis: the artifact system, ported from DOLSharp | Yes |
| `gaheris/` | The co-operative server itself -- mercenaries, task dungeons, rules, travel | Yes, if you want stock rules |
| `diagnostics/` | Temporary packet and combat probes. **Delete before release.** | Yes, please |

**`progression/` and `toa/` do depend on `gaheris/`**, which the table above
once denied. Two files are load-bearing:

* `gaheris/Loot.cs` -- `GaherisLoot.Credit()` is called by
  `progression/MasterLevels.cs`, `progression/ChampionLevels.cs` and
  `toa/ArtifactExperience.cs`. A hired companion is deliberately not a pet, so
  a kill it lands credits nobody until the employer is substituted, and every
  system that awards experience resolves it through this one helper.
* `gaheris/Mercenaries.cs` -- `MercenaryManager.GetCompany()` is called by
  `progression/MasterLevels.cs` and `gaheris/TaskMaster.cs`.

Everything compiles into one assembly, so deleting either does not disable a
feature -- it stops every script in the server.

The full graph, mapped rather than assumed:

| From | Needs | For |
|---|---|---|
| `classes/shared` | `core` | `DamageGate`, `ISoftensDamage`, `MovementWatch` |
| `progression` | `core` | the same three |
| `classes/shared` | `gaheris` | `GameMercenary` |
| `classes/catacombs/warlock` | `gaheris` | `GameMercenary` |
| `progression` | `gaheris` | `GaherisLoot`, `MercenaryManager`, `GameMercenary` |
| `toa` | `gaheris` | `GaherisLoot`, `GameMercenary` |
| `toa` | `progression` | `GaherisArbiter` |
| `gaheris` | `classes/catacombs/warlock` | `WarlockPairing` |

`core/` reaches outward for nothing and is a real floor. So are `classes/`
other than `shared/`, and `realmabilities/`.

**The Warlock and the mercenaries need each other.** `Mercenaries.cs` calls
`WarlockPairing.Pairs()` so a hired Warlock weaves, and `WarlockPairing.cs`
takes a `GameMercenary`. Neither comes out alone.

## Two rules that are not obvious

**Do not change namespaces.** Everything stays in `DOL.GS.Scripts` (packet
handlers excepted, below). The `mob` table stores a fully qualified
`ClassType` string, so the namespace is part of the database: 161 rows name
`DOL.GS.Scripts.GaherisTeleporter`, 474 name
`DOL.GS.Scripts.MonsterGuardFighter`. Renaming a namespace silently breaks
every world object using it.

**Do not rename a class the database names.** Same reason. A class reachable
from `mob.ClassType`, `npctemplate.ClassType` or `lootgenerator` keeps its
name whatever the folder is called -- which is why `GaherisTeleporter`,
`GaherisTaskMaster`, `GaherisArbiter`, `GaherisLoot*` and
`LootGeneratorGaherisSeals` still carry a prefix that no longer describes
them. Renaming one means a migration over the rows that reference it. Classes
registered by *attribute* -- spell handlers, packet handlers, character
classes -- are free to rename, because nothing stores their names.

**Packet handlers are the one namespace exception.** They must sit in a
namespace ending in the client version literal, `DOL.GS.PacketHandler.Client.v168`
-- `ScriptMgr` tests `type.Namespace.EndsWith(version)` and silently skips any
handler that does not match.

## Server properties

Properties are named for what they configure, not for this server. Only the
four that really are this server's ruleset keep the `gaheris_` prefix:
`gaheris_atlantis`, `gaheris_log_buffs`, `gaheris_no_base_classes`,
`gaheris_starting_level`. Class and progression settings live under the
`catacombs`, `classes` and `progression` categories. See migration 104.

## SQL

`sql/` stays a single numbered sequence rather than mirroring these folders,
because migrations depend on the ones before them -- 90 imports spells that 101
then corrects. `install.sh` applies them with `sort -V`, by number. It used to
use a plain glob, which sorts as text and applied 100+ between 10 and 11.
