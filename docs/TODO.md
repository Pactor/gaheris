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
