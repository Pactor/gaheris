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
| Spymaster 7 | Lookout | either party moving | **fixed** |
| Spymaster 10 | Blanket of Camouflage | moving, attacking, casting | fixed |
| Convoker 6 | Battlewarder | caster moving, casting, attacking | **fixed** |
| Stormlord 6 | Focusing Winds | caster moving | fixed |

All four holds are now repaired.

## Two of the six were never holds at all

An earlier version of this note listed **Forceful Zephyr** and **Phaseshift**
as abilities that should end when their owner is attacked. **They are not.**
Both ride the same dead `AttackedByEnemy`, but what they do with it is absorb
the blow:

```csharp
ad.Damage -= damageAbsorbed;            // Zephyr, 100 percent
ad.Damage = 0; ad.CriticalDamage = 0;   // Phaseshift
```

So the loss is immunity, not an ability that overstays -- and unlike the four
holds it cannot be repaired the same way. Both edit the `AttackData` **before**
the blow lands, and the only live hook, `GameObjectEvent.TakeDamage`, arrives
after the damage is already dealt. Healing it back afterwards would look
similar and behave differently: the blow would still generate aggro, still
interrupt, and could still kill.

Phaseshift is doubly moot here. It answers only `ad.Attacker is GamePlayer`, so
on a co-operative server, where everything hostile is a monster, it would do
nothing even working.

Both are left alone deliberately. Repairing them properly means intercepting
damage before it is applied, which needs a core change rather than a script.

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

### Lookout watches two people

The Spymaster hides beside a seated companion and borrows a hundred points of
stealth; either of them moving ends it. That needed two watches rather than
one, because the core registered two -- and the companion's own static effect,
`LoockoutOwner`, has to be taken down by hand as the core's handler did.

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

---

## Three more, found only after a wrong assumption was corrected

Added 4 September. An earlier sweep in this repo excused **every** Master Level
handler on the grounds that `MasterlevelHandling` builds a legacy effect, so
its `OnEffectStart(GameSpellEffect)` is still reached. **That was wrong.**
`MasterlevelHandling` derives straight from `SpellHandler` and builds nothing;
only its font and mine subclasses do. Phaseshift exposed it, and re-running the
sweep without the excuse turned up three more.

| Spell | Line | Verdict |
|---|---|---|
| **Leadership** | Warlord | +25% effectiveness to the realm around you for 20s. Dead. **Fixed** |
| **Grapple** | Battlemaster | **cannot be cast here** -- refuses NPC targets with "This spell works only on realm enemys" |
| **Demoralization** | Banelord | -25% enemy effectiveness. Reached nothing, and `Effectiveness` has an empty setter on everything but a player, so it would do nothing to a monster even repaired |

Leadership is kept exactly as core has it: the bonus applies only to players.
That is not timidity, it is the only thing that can work -- `Effectiveness` is
declared on `GameLiving` with `set { }` and only `GamePlayer` overrides it with
real storage. On a server whose group is hired companions, that limits the buff
to players in range.

**Grapple joins Forceful Zephyr** as a spell whose problem was never the dead
callback: both demand a target that is attackable and not a `GameNPC`, which
means an enemy player, and there are none here. Neither is fixable without
changing who you may cast them on, which is a departure from live rather than a
repair.

