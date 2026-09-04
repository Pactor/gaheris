# Master Levels

Not a class document. The ML lines are shared -- **every class in the game
reaches all ten** -- so a fault here is the most widely felt kind there is.

Audited 4 September 2026 against the live database and the core source.

---

## Six abilities that never end

Each of these cancels itself when the holder moves, attacks or casts, and each
registers that on an event this server does not raise. The failure runs the
wrong way: the ability does not break, so it is **stronger** than it should be,
and nothing appears in the log.

| ML | Ability | Should end on | Status |
|---|---|---|---|
| Sojourner 8 | Forceful Zephyr | the passenger being attacked | **broken** |
| Sojourner 9 | Phaseshift | the caster being attacked | **broken** |
| Spymaster 7 | Lookout | either party moving | **broken** |
| Spymaster 10 | Blanket of Camouflage | moving, attacking, casting | fixed |
| Convoker 6 | Battlewarder | caster moving, casting, attacking | **broken** |
| Stormlord 6 | Focusing Winds | caster moving | fixed |

The two fixed ones are in `scripts/progression/MasterLevelHolds.cs`, sampling
through `core/MovementWatch.cs` rather than waiting on events. See
`dead-events.md` for why the events are gone.

### Blanket of Camouflage had a second fault

The core keeps the effect in one field on the handler:

```csharp
private GameSpellEffect m_effect;
```

and one handler serves every member of the group in turn, so each new target
overwrote the last. Whoever broke stealth would have cancelled the effect
belonging to whichever member was processed last, rather than their own. Each
watch now closes over its own effect.

Worth noting what this meant in practice: group stealth whose only working
cancel was **dying**. A group could walk into a keep invisible.

### The four still broken

They are left because their cancel is entangled with things I could not verify
without testing -- Zephyr carries a player, Phaseshift and Battlewarder alter
the caster's state, Lookout watches two people at once. Each needs the same
treatment: subclass the handler, capture the effect in a closure, and replace
the dead event with a `MovementWatch`. The pattern is in `MasterLevelHolds.cs`.

---

## Two spells with no type at all

A spell with a blank `Type` gets no handler, so it does nothing. Both of these
sit in the Sojourner line, which means every class in the game could train them
and get silence.

**`7278` Resistance of the Ancients, Sojourner 7** -- a duplicate. Level 7
carried two rows of the same name, one working (`7328`, `EssenceResist`,
Value 15) and this one blank. Removed from the line in migration 105.

**`7204` Reveal Crystalseed, Sojourner 3** -- *not fixed*. It has no working
twin, and no type in the core's `eSpellType` enum matches "reveal all enemy
runes around your ground target" -- `UnmakeCrystalseed` destroys them rather
than showing them. Fixing it means adding an enum value and a handler, which is
a core change rather than a migration.

---

## What is not wrong

Worth recording, because it saves the next look.

Every other spell type reachable through the ML lines has a handler. Across all
fourteen expansion classes audited, the *only* types with no handler were the
two blank ones above and one Animist spell. There is no missing ML content --
the apparatus and the spells are both present.

`GaherisArbiter` in `scripts/progression/MasterLevels.cs` is what makes the
levels earnable; the core ships the whole apparatus with no way to gain one.

## Settings

`ml_xp_per_level` (category `progression`) and `ml_holds_log`, which reports
when one of the fixed holds is broken and by what.
