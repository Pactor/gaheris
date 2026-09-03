# Gaheris — things to come back to

Not a bug list. These are decisions we have deliberately deferred, with enough
context to pick them up cold.

## Switch to New Frontiers

**Deferred by choice. Atlantis comes first.**

Old and New Frontiers share one `KeepID` space. A server holds one set or the
other and never both, so IDs 50-56, 75-81 and 100-106 name Castle Sauvage and
its Midgard and Hibernia counterparts on our database, and New Frontiers keeps
on Eve's. This is why importing her keep data on its own word silently bolted
798 New Frontiers components onto our mainland keeps — caught and reverted, see
`sql/33-battleground-keeps.sql`.

So this is not an import, it is a swap. What it takes:

- Region 163 is currently empty: 0 mobs, and migration 24 removed travel to it
  because every destination there was a one-way trip into nothing.
- The data exists and is complete: 105 keeps and 966 components in
  `dol-db/Keep.json` and `dol-db/KeepComponent.json`, plus the 729 hookpoints
  and 279 positions already imported in migrations 31 and 32, which are keyed
  on component skin rather than `KeepID` and so serve either frontier.
- Doing it means retiring the old-frontier keeps that own the contested IDs,
  repointing the travel catalogue at region 163, and putting the 15 New
  Frontiers destinations back.
- OpenDAoC has tower creation commented out; the NF fork has it enabled.

## Realm-point trade-in merchant

Three "Void Merchant" NPCs stand in Caledonia and region 252 pointing at
`DOL.GS.Scripts.RPTradeInMerchant`, a class that exists in neither OpenDAoC nor
DOLSharp, and all three have a NULL `ItemsListTemplateID` — so there is no
merchant list behind them either. Migration 27 left them as ordinary NPCs
rather than deleting them, pending a decision on building a real one.

## Mercenary inventory not persisting

Play sessions throw a steady stream of:

```
Error saving data object (0 rows affected) in table Inventory
  Name{Arcane Cloth Boots}, OwnerID{...-merc-wizard}
```

Hired companions' gear is failing to save. Not blocking anything, but real.

## The null keep Component

Every Gaheris guard on the mainland is a `mob` row, so `guard.Component` is
null and core code that touches it breaks — it has bitten four times, and
`ScaleToKeep` is our standing workaround. Eve's dump does **not** fix this: it
contains no keeps for regions 1, 100 or 200 at all. Migration 33 gave the
battlegrounds real components, so guards raised from position templates there
do have one; the mainland still does not.

## Task dungeons

Introduced in **1.73, Catacombs, 7 December 2004** as "Instanced Dungeon
Tasks": *"Taskmasters are stationed in towns across the world to provide you
dungeon task encounters."* Distinct from Adventure Wings, which are the glowing
doors inside real dungeons and are handled by `AdventureWingJumpPoint`.

Four things stand between us and working task dungeons. Three are solved on
paper; the fourth is not.

**1. The core disables them.** `TaskMaster.Interact` opens with

```csharp
//we need to disable them for players for now
if (player.Client.Account.PrivLevel == 1)
{
    SayTo(player, "I'm sorry, Task Dungeons are currently disabled!");
    return true;
}
```

so only a GM can take a task. That is code, not data. A script subclass
overrides it the same way `GaherisLevelCommand` overrides `/level` -- scripts
register first and win.

**2. No taskmasters exist.** The live roster is fifteen, five per realm by
level band, and all but two stand somewhere already in our travel catalogue,
so the coordinates are in hand:

| levels | Albion | Midgard | Hibernia |
|---|---|---|---|
| 1-10  | Traint, Cotswold | Bernard, Mularn | Sevinia, Mag Mell |
| 11-20 | Prairdred, Prydwen Keep | Cheri, Audliten | Nelarid, Howth |
| 21-30 | Lucir, Adribard's Retreat | Bisil, Gna Faste | Jeryd, Tir na mBeo |
| 31-40 | Mairlin, Caer Ulfwych | Domli, Haggerfell | Praest, Tir na Nog N gate |
| 41-50 | Trudan, Castle Sauvage | Trinnan, Svasud Faste | Vaellyn, Druim Ligen |

Haggerfell and the Tir na Nog north gate are not in the catalogue; Huginfell
and Connla are the nearest substitutes.

**3. No instance entrances.** `Instance.LoadFromDatabase` reads
`instancexelement` and we hold zero rows. db-public has **120** -- one
`entrance` per task dungeon region, keyed `TaskDungeon<region>.1`, which is the
key `TaskDungeonMission` builds. The OpenDAoC reference `instancexelement.sql`
is empty.

**4. No mobs, and no source for them.** All 120 task dungeon regions exist in
`regions` and every one holds **zero** mobs, and `instancexelement` carries only
entrances. `TaskDungeonMission` picks its boss and its target by reading
`instance.Objects` after loading, so with nothing inside there is no boss, no
target and a count of zero.

Nothing found has the populations: not db-public, not the OpenDAoC reference
database, not DOLSharp. The Dawn of Light forum thread that discussed it
(`dolserver.sourceforge.net`, topic 15142) returns HTTP 500 and is not in the
Wayback Machine.

So the choice is to generate them -- spawns by level band and dungeon type,
which is inventing content -- or keep hunting for a dump that has them. Worth
deciding before building 1 through 3, because on their own they produce a
taskmaster who hands out a task in an empty room.
