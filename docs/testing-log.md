# Where to pick up testing

Last session ended 4 September 2026. The server has been restarted, so
everything below is live.

Logging is on for the classes under test: `bainshee_log`, `heretic_log`,
`ml_holds_log`. Turn them off when you are done -- they write a line per
pulse.

---

## Start here: the Bainshee

She is mid-test and two of her faults were only fixed after you logged off.

1. **Cast an aura and let something hit you.** This is the one that dropped you
   to the character screen. It was not the aura -- it was a line of sight check
   underneath it throwing on every pulse. Fixed. If you get dropped again,
   stop and say so, because the fix is wrong.
2. **Vanquishing Screech, then walk.** It used to keep going. It is a `Fear`
   rather than a `BainsheePulseDmg`, so the first fix never saw it. Her
   nearsights pulse too -- try **Expel Sight** and walk.
3. **Cast an aura and die.** Should stop, and say so.
4. **A Spectral Guard cone.** 23 of her spells are cones and not one has been
   fired yet.
5. **Befriend** a monster -- it should turn and fight for you.

**Known and deliberately not fixed:** `RangeShield` (Wraith's Shield, Barrier,
Barricade) does nothing. It is on a dead event, its arithmetic truncates to 0
or 1, and all three carry `Value = 0` -- reviving it as written would make your
group immune to ranged damage. It needs data first.

**Open question:** `Diminishing Wail` has `Range 0`, so it is point blank and
needs no target -- correct for Phantasmal Wail, but it is the *same spell row*
in Ethereal Shriek, which is the ranged spec. That looks wrong and I have no
source for what the ranged version should be.

---

## Then: the Valkyrie

Untested, and she has a crash waiting that nobody has hit yet.

Odin's Will has five **pulsing frontal cones**, which is the same shape that
disconnected you on the Bainshee. Fixed the same way, but never seen to work.
**Cast one first, before anything else**, and be ready to be dropped.

After that she is unexplored: mending, Odin's Will, and a resurrect in three
separate lines.

---

## Then: Master Levels, for any class

Six ML abilities never end, because their cancel conditions ride dead events.
Two are fixed and want testing:

- **Stormlord 6, Focusing Winds** -- locks a storm while you stand still.
  Cast it, then walk. It should release.
- **Spymaster 10, Blanket of Camouflage** -- group stealth. Have a group
  member move, swing, or cast. Each should drop out individually.
  This one had a second bug: the core kept one effect field for the whole
  group, so the wrong person's stealth would break.

Four are still broken and are **not** fixed: Forceful Zephyr, Phaseshift,
Lookout, Battlewarder. See `master-levels.md`.

---

## Champion levels

The Maulers of Midgard and Hibernia were training **each other's** champion
trees -- one swap in `classxspecialization`, corrected in migration 106. See
`champion-levels.md`.

- Take a **Midgard Mauler** to champion level: Mystic, Rogue, Seer.
- A **Hibernian Mauler**: Forester, Magician, Naturalist, Stalker.
- And on **any class**, train a champion ability and see it work. Nobody has
  ever done that here; the swap was found by reading tables, not by playing.

The empty `Champion Abilities Hibernia` line I flagged as suspicious last night
is **not** a fault -- that line is a container and is meant to be empty. The
content lives in the archetype trees.

## Five classes got their realm rank 5 ability back

Sourced from a published RR5 listing and granted in migration 107. All five
already existed with working handlers and had simply never been granted to
anyone. See `realm-abilities.md`.

- **Scout** Shield Trip, **Friar** Whirling Staff, **Hunter** Entwining Snakes,
  **Warden** Fury of Nature, **Ranger** Desperate Bowman, **Wizard** Wall of
  Flame.
- Take any of them to RR5 and check the ability appears and fires.
- Shield Trip, Entwining Snakes and Fury of Nature sit partly on dead events,
  so expect parts of them not to work. Report which parts.
- **Wall of Flame** should be the cleanest of the six: instant cast, a ward at
  your feet doing 400 fire damage every 3 seconds for 15, in a 150 radius.
  Nothing about it touches a dead event.

All 47 classes now have a class-specific ability, every one backed by a real
handler.

**Four granted realm abilities did nothing and are now fixed.** All four hung
on a blow landing and listened on a dead event; all four now read
`TakeDamage`. `ra_blows_log` is on, so each one narrates when it fires.

| Ability | Class | What to look for |
|---|---|---|
| **Mark of Prey** | **Vampiir** | hit something and watch your power climb -- every point of the damage add comes back |
| Fury of Nature | Warden | your damage heals the group. **Style doubling is not restored** -- only the healing |
| Shield Trip | Scout | root your target, then hit it -- it should let go |
| Entwining Snakes | Hunter | same: snare, then hit, and it should release |

Mark of Prey matters most: it is the Vampiir's own RR5, it was granted long
before today, and it had never once returned power. Test it alongside his
combat-power fix -- both feed the same bar, so if the bar behaves oddly, say
which ability was up.

**Still inert, not fixed:** the Mentalist's Severing the Tether. The class was
never written. On live it kills summoned pets and releases charmed ones, which
is an RvR counter of little use on a co-operative server -- worth a decision
before anyone writes it.

**Still open, deliberately:** Bainshee and Warlock lack Avoidance of Magic,
which 45 of 47 classes have. No source found saying they should have it, so it
was not added.

## Not started

- **Shrouded Isles classes** -- Bonedancer, Animist, Valewalker, Necromancer,
  Reaver, Savage. See `shrouded-isles.md` for what the audit found.
- **The Mauler** -- see `mauler.md`. Power now comes from combat, which it
  never did before, and that has never been seen working.
- **Mercenary versions** of Warlock, Heretic and Bainshee. The hired Warlock
  still bypasses the pairing mechanic.

## Still true from before

- The Heretic is confirmed working through ramp, movement, melee and target
  death. Untested: sitting, swinging, a Blaze holding under ranged fire, and
  Reanimate Corpse at 41.
- The Warlock's chambers and weave are confirmed in play.
- Task dungeon relocation has never been observed working.
