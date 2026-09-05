# classes/

Class mechanics the core defines and never implements. Grouped by the
expansion that introduced the class, because the era is the best guide to how
something should behave -- see `docs/expansion-class-audit.md`.

| Folder | Classes | Expansion |
|---|---|---|
| `catacombs/heretic/` | Heretic | Catacombs, Dec 2004 |
| `catacombs/valkyrie/` | Valkyrie | Catacombs, Dec 2004 |
| `catacombs/warlock/` | Warlock | Catacombs, Dec 2004 |
| `catacombs/vampiir/` | Vampiir | Catacombs, Dec 2004 |
| `catacombs/bainshee/` | Bainshee | Catacombs, Dec 2004 |
| `shrouded-isles/` | Animist | Shrouded Isles, 2002 |
| `shared/` | mechanics more than one class owns | -- |

Those five **are** the whole of Catacombs. The Maulers are not among them --
they arrived with Labyrinth of the Minotaur in 2006, which is why there is no
mauler folder here.

The other Shrouded Isles classes -- Bonedancer, Valewalker, and the Reaver,
Savage and Necromancer alongside them -- have folders only if something needed
fixing. They were swept and nothing was found, so there is nothing to keep.
An empty folder would suggest work that does not exist.

## Where a Mauler actually lives

Nowhere in one place, and that is worth saying plainly, because somebody who
wants to take just the Mauler will look for a folder and not find one. Each of
his three repairs is shared with something else, so each sits where the
mechanic sits:

| Piece | File |
|---|---|
| Combat power -- his **entire** power supply | `shared/CombatPower.cs` |
| Disarm and Silence | `../core/DisarmAndSilence.cs` |
| The swapped champion realms | `../../sql/106-the-maulers-champion-realms-are-swapped.sql` |

Take those three and you have the Mauler work. Take only some and he is still
broken: without combat power he is unplayable past his first bar.

## Why `shared/` exists

Some mechanics belong to more than one class and cannot sit under a single
expansion without lying about the other:

- **`CombatPower.cs`** -- the Vampiir and the three Maulers draw power from
  fighting instead of regenerating it. One mechanic, one file, two expansions.
  Delete it and all four lose their power supply.
- **`FocusShell.cs`** -- Nature's Cocoon, Hand of God and Spirit Shell, one each
  for the Druid, Cleric and Shaman. Three classes, three realms, one spell.

## What these depend on

Two things in `../core/` are not class code, but classes here need them:

- **`MovementWatch.cs`** -- samples movement, attacks and casting, because the
  events that used to announce them are dead.
- **`DamageGate.cs`** with **`GaherisPlayer.cs`** -- lets an effect shrink a
  blow before it lands. Focus Shell needs it, and no script can do it without
  the player class, which is named in `serverproperty.player_class`.

The data these rely on lives in `sql/`, as ordinary numbered migrations.

## A recurring shape

Most faults in here were not missing data. The spells existed with the right
values and the wiring was dead -- handlers registered against events the ECS
rewrite stopped raising, damage methods nothing called, callbacks nothing
reaches any more. See `docs/dead-events.md` before assuming something is absent.
