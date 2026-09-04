# Where this stands

A working note rather than documentation: what is proven, what is built but
unproven, and what is known to be wrong. Written to be picked up cold.

`README.md` says what the server *is*. This says how far along it is.

---

## Proven in play

Walked through and seen working, not merely written.

| | |
|---|---|
| Character creation, all classes | Six reopened classes, six races, level 5 start, no base classes |
| Hired companions | Real classes, gear, tactics, formations, travel, recovery |
| New Frontiers | Region 163 populated, keeps garrisoned, all crossings retargeted |
| Border keep doors | Both directions, all six |
| Task dungeons | Given, entered, fought in, exited. Never cleared to zero |
| The dungeon exit | Confirmed twice; logged client zonepoints `570` and `571` |
| Mercenaries through a dungeon | Follow in, follow out, survive the instance closing |
| `/task` | Shows the mission; the core's version reads a different system entirely |

---

## Built but not yet proven

Written and compiled, not yet watched end to end.

**That the relocation works at all.** It has never run. Not once, across
every test so far. Three separate guards each looked correct and each
silently disabled it:

1. `m_owner is not GamePlayer` -- a task taken while grouped belongs to the
   Group, and anyone with hired companions is always grouped, so the watcher
   never started.
2. Straight-line distance from the trail, then a thousand-unit "met" radius --
   both reach through solid rock in a corridor dungeon, so creatures sealed
   behind walls were counted as reachable and never moved.
3. `IsVisibleToPlayers` -- reads like line of sight, is a distance flag with a
   radius of thousands of units. Everything counted as visible, so nothing was
   ever eligible.

All three are fixed and none of the fixes has been watched working. The
telemetry now prints `moved N`, which is the number that settles it: if it
stays at nought while `trail` climbs past five, something is still blocking it.

**A clear task reaching zero.** The closest run ended 20 alive of 37 with 34
required -- but that was with the relocation dead, so it says nothing about
whether the design works. This is the real test and it has not happened yet.

**The persistent trail.** The first run in a region logs
`DungeonTrail: learning region N for the first time` -- seen, for region 428.
A repeat visit should log `remembered from N known points` and start
populated. Nobody has yet done the second run.

**Whether the boss is reachable.** He is placed at the far end relative to the
entrance marker, and that marker is known not to be where players arrive, so
he is likely among the stranded. On a boss mission with the relocation dead he
was simply absent -- "he is not in here" -- which is consistent. Untested since
the fix.

**Mauler and Vampiir power from combat.** Both should now climb while
fighting. Neither has been watched on a power bar.

**Warlock chambers.** Not started. The design is understood -- see below.

---

## Known wrong, not yet fixed

**Warlock chambers do not load.** Upstream's own comment says why:

    // Likely to be broken. It used to override 'CastSpell', but it no longer
    // exists in 'SpellHanlder'. Can't be tested since Warlocks aren't functional.

A chamber is loaded *during* its own cast: the spell has a long cast time and
the Warlock clicks a primary and a secondary spell during the animation, which
are swallowed rather than cast. That swallowing was done by an override that
no longer exists, so the chamber always arms empty.

Two of the three pieces are written and committed --
`GaherisChamberLoader.cs` holds the bookkeeping and
`GaherisChamberSpellHandler.cs` replaces the core handler (which works because
`CreateSpellHandler` walks scripts before core and returns the first match).
The third is not: the interception itself, which belongs in a script copy of
`UseSkillHandler` in the `v168` namespace. Also `GetEffectSlot` knows only five
chamber names and three of ours are not among them, so those would arm with
slot 0 and the client would not draw the icon.

**Taskmasters do not hand you on.** Each should serve one level band and name
the next taskmaster when you outgrow it. Ours serves anybody, because the core
picks the dungeon from the player's level rather than the taskmaster's band.
Deferred deliberately -- see `TODO.md`.

**Three missing abilities, one of them unbuildable.** `Mark of Prey` and
`Ichor of the Deep` turned out to be present and correctly assigned. `Call of
a Thousand Storms` exists as a row with `Implementation: NULL` and **nothing
in the core implements it**; it belongs to Thane and Valkyrie at 40. Left
disabled on purpose rather than handed out as a button that does nothing.

**`Summon Bone Spellbinder` exists in no data we hold.** Restoring it would
mean inventing a spell.

**Out-of-bounds keep guards.** Some `keepposition` rows place guards outside
their keep. Pre-existing, affects battlegrounds too, untouched.

**New Frontiers keep guards have no patrol paths.** They stand where they
spawn.

---

## Things that will bite you

Recorded because each cost real time.

**A packet handler is registered only if its namespace ends with the client
version** -- the literal `v168`. A handler in `DOL.GS.Scripts` is skipped
silently however correct it is. This is why a frontier door handler once
"didn't work" for weeks with no explanation.

**MySQL compares case-insensitively by default.** `WHERE Name <> LOWER(Name)`
answers nothing however many capitalised rows exist. An audit built on that
query concluded there were no named creatures in the task dungeons; there are
29. The core makes the same test in C#, where it is case sensitive.

**Scripts win over core, but the order differs by system.** Spell handlers,
character classes and server rules take the *first* match walking scripts
first, so a script wins. Commands take the first registration, so a script
wins there too. Packet handlers *overwrite*, so the last wins -- and scripts
are loaded after core, so a script wins again. The trap is the namespace rule
above, not the ordering.

**`BeginDelayCloseCountdown` does the opposite of what it sounds like.** Its
timer sets `DestroyWhenEmpty = true` when it fires, so using it to hold an
instance open re-arms the very thing you were preventing.

**Instance regions are numbered per run.** Never persist one. Anything keyed
to a dungeon should key on `Skin`.

**The task dungeon maps are 65,536 units square** and we have no geometry for
any of them. The entrance coordinate in `instancexelement` is not where
players arrive -- measured ten thousand units out. Any layout reasoned from
that coordinate will fail; the trail is the only sound basis.

---

## New Frontiers: what to look at

Region 163 holds **105 keeps** and **8,359 creatures**, all crossings are
retargeted, and the border keep doors work in both directions. What has not
been examined closely is the garrison.

**Do the main keeps have guards?** This cannot be answered from the database
and I got it wrong trying. Counting mob rows near each keep says twenty-seven
have none -- including Caer Benowyc, Bledmeer Faste and Dun Scathaig, the ones
that matter -- but that is the wrong measure. New Frontiers keeps raise their
garrison at runtime from `keepposition` through their components, and all
twenty-seven have components, thirty-nine to forty-one apiece. What the count
actually found was ambient wildlife: the keeps that appeared defended were
merely near imported creatures like `boreal cockatrice`.

So it needs eyes. Ride to Caer Benowyc and Bledmeer Faste and see whether
anything is standing on them. If they are bare, the thing to check is whether
`keepposition` covers their component skins -- there are 2,044 components and
only 279 positions, and positions key on skin rather than on keep, so thin
coverage would show up as empty keeps rather than as an error.

**The rest of the frontier list.**

| | |
|---|---|
| Return stones | Six, now on model 2256. They were invisible until today -- worth confirming they are there |
| Guard patrols | None. Guards stand where they spawn |
| Keep levels | All 105 sit at level 4 |
| Relics | Six exist. The relic keeps are in the old frontier zones, which is the intended design |

---

## The expansion classes: what to test

`expansion-class-audit.md` has the per-class data. What is worth checking by
feel, class by class:

| Class | The thing that makes it itself |
|---|---|
| **Vampiir** | Power climbs while fighting AND while being hit. Refuses all stat buffs by design -- that is correct, not a bug |
| **Mauler** (x3) | Same, and until today it had no power source at all. Fist Wraps and Power Strikes should stay usable |
| **Warlock** | Chambers. Known broken, see above. Everything else -- six chambers, Powerless, Range, Uninterruptable -- is present and reachable |
| **Bainshee** | Shifts to spectral form and casts cones from it. `Alarming Screech` moved to Spectral Force at 26 today |
| **Heretic** | Ramping damage focus, and it keeps Shields and Slam at 42 |
| **Valkyrie** | Spear and sword, mending. Only three trainers in the world -- worth checking that is enough |
| **Bonedancer** | Sub-pets should assist the commander |
| **Animist** | Turrets. `Purifying Rain` now casts in 3s |
| **Valewalker** | Scythe, two-handed, trading health for magic |

Two known-thin spots: **Valkyrie and Bainshee have three trainers each** where
every other class has nine to twenty-five, and the **Maulers share 25 trainers
across all three realms**.

---

## How to test the dungeon work

Take a task, walk in, and read the log:

```bash
docker compose logs -f gameserver | grep -E "Dungeon:|DungeonTrail:|InstanceExit:"
```

    Dungeon: <player> at X,Y,Z | trail 19 | alive 20 | nearest <name> flat 204 height 0 true 204

`flat` small with `height` large means the population is off the floor.
`alive` standing still while `trail` grows means creatures are not being
rescued. `trail` growing and `alive` falling to zero is the target.

---

## Diagnostics currently loaded

All are meant to come out once they have answered.

| | |
|---|---|
| `GaherisUnclaimedPackets.cs` | 176 generated handlers, one per unclaimed code |
| `GaherisUnknownPacketLog.cs` | What arrived, and what the player was doing |
| `GaherisAttackRequestProbe.cs` | The combat-mode opcode. Answered: the client sends nothing; the key had moved to X |
| `GaherisPacketAudit.cs` | Names the handler owning an opcode, and lists unclaimed ones |
| Buff logging | Behind `gaheris_log_buffs`, currently **on** |
| `Dungeon:` telemetry | Always on while a task dungeon is occupied |
