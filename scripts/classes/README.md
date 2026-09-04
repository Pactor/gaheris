# classes/

Class mechanics the core defines and never implements. Grouped by the
expansion that introduced the class, because the era is the best guide to how
something should behave -- see `docs/expansion-class-audit.md`.

| Folder | Classes | Expansion |
|---|---|---|
| `catacombs/heretic/` | Heretic | Catacombs, Dec 2004 |
| `catacombs/warlock/` | Warlock | Catacombs, Dec 2004 |
| `catacombs/bainshee/` | Bainshee | Catacombs, Dec 2004 |
| `shared/` | Vampiir **and** the three Maulers | Catacombs / Labyrinth 2006 |
| `shrouded-isles/` | Bonedancer, Animist, Valewalker | Shrouded Isles, 2002 -- not started |

**Why `shared/` exists.** The Vampiir and the Maulers draw power from combat
instead of regenerating it. It is one mechanic and one file, so it cannot sit
under a single expansion without lying about the other. Delete it and both
classes lose their power supply.

Each class folder stands alone except where its own README says otherwise.
The data these rely on lives in `sql/`, as ordinary numbered migrations.

## A recurring shape

Most faults in here were not missing data. The spells existed with the right
values and the wiring was dead -- handlers registered against events the ECS
rewrite stopped raising, damage methods nothing called, flags never set. See
`docs/dead-events.md` before assuming something is absent.
