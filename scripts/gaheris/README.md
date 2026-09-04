# gaheris/

The co-operative server itself. Everything here is a deliberate departure from
stock DAoC, and none of it is a bug fix -- delete the folder and you have an
ordinary OpenDAoC server with the class and expansion work still in place.

| | |
|---|---|
| `Mercenaries.cs` `MercenaryLoadout.cs` `MercenaryCommands.cs` `MercenaryTravel.cs` | Hireable group members: brains, gear, tactics, formations, travel |
| `TaskDungeonMission.cs` `TaskDungeonReturn.cs` `TaskMaster.cs` `MissionCommand.cs` `DungeonTrail.cs` `InstanceExit.cs` | Task dungeons -- generated instances, populated along a trail, with a named boss and a way out |
| `MonsterGarrison.cs` `Seals.cs` `FrontierGateDoors.cs` `FrontierReturn.cs` | Old Frontiers held by monsters rather than by the other realms, since nobody is on the other side |
| `ServerRules.cs` `Settings.cs` `StartingLevel.cs` `LevelCommand.cs` `Loot.cs` `Travel.cs` | The ruleset: one realm co-operative, starting level, loot and travel |

## Names that cannot change

`GaherisTeleporter`, `GaherisTaskMaster`, `GaherisLootMoney`, `GaherisLootRog`,
`GaherisLootTemplate` and `LootGeneratorGaherisSeals` are stored as strings in
the database -- `mob.ClassType` and `lootgenerator` -- so renaming any of them
breaks live world objects. 161 mob rows name the teleporter alone. The
namespace `DOL.GS.Scripts` is part of those strings too.

## What depends on this

`classes/catacombs/warlock/WarlockPairing.cs` checks for a `GameMercenary`
whose profile is a Warlock, so a hired one plays the class properly. It is the
only reference into this folder from outside, and it is one `is` expression.
