# The events that are never raised

Some features in this server are wired to events that nothing publishes. The
handlers are registered, the code is correct, and it never runs. This is not a
bug in any one file -- it is what the ECS rewrite left behind, and it explains a
recurring shape of problem: **the data is right, the handler is right, and
nothing happens.**

Audited by taking every event anything subscribes to and looking for a matching
`Notify`.

---

## Why

The rewrite moved combat out of the event system and into methods called
directly. `OnAttackedByEnemy(AttackData)` on `GameLiving` replaced the
`AttackedByEnemy` event; procs are now invoked at `GameLiving.cs:1435` as a
direct call. The event objects were left in place, and so was every handler
hung on them.

`OffensiveProcSpellHandler` shows the migration mid-stride: it keeps the old
`EventHandler(DOLEvent, object, EventArgs)` as a deliberately **empty** method
and carries a second `EventHandler(AttackData)` that is called directly. Procs
were rewired. Everything else was not.

Nothing in the server warns about this. A handler on a dead event is
indistinguishable from a handler that is simply never triggered.

---

## The dead list

| Event | Subscriber files | Notes |
|---|---|---|
| `AttackedByEnemy` (Living + Player) | **27** | never raised |
| `AttackFinished` (Living + Player) | **21** | only "raise" is `NecromancerPetBrain` forwarding an event it never receives |
| `Moving` (Living + Player) | 7 | never raised |
| `CastStarting` (Living + Player) | 4 | only raised by `NecromancerPetBrain`, for its own owner |
| `CastSucceeded` | 1 | never raised |
| `GainedExperience` | 1 | never raised; already worked around |
| `DatabaseEvent.CharacterSelected` | 1 | never raised |
| `GameNPCEvent.PathMoveEnds` | 1 | never raised |

### What is on the far side of them

**Realm abilities**, mostly RR5: Blade Barrier, Testudo, Badge of Valor, Mark of
Prey, Fury of Nature, Blooddrinking, Selective Blindness, Speed of Sound,
Entwining Snakes, Nature's Womb, Retribution of the Faithful, Shadow Shroud,
Shield of Immunity, Shield Trip, Sputin's Legacy, Ichor of the Deep, Negative
Maelstrom, Rez Damage Immunity.

**Trials of Atlantis artifacts**: Shades of Mist, Ereine, Crown of Zahur, Dream
Sphere, Traitor's Dagger, the Atlantis Tablet line, Style Damage Absorption.

**Master Levels**: Sojourner, Spymaster, Convoker, Stormlord.

**Classes**: Heretic (`HereticPiercingMagic` -- every interrupt it defines),
Warlock (`PrimerSpellHandler` -- primers never break on movement), Bainshee
(`RangeShield`, the pulsing damage spell), Valkyrie (`ValkyrieProc`).

**Other**: Triple Wield, Dirty Tricks, Focus Shell, Conversion, Damage
Reduction Power Return, quest interrupt-on-attack.

A caveat worth keeping: a dead event proves the handler cannot fire through
that path. It does not prove the feature is otherwise whole -- several of these
register in a `BeginEffect` or `AddHandlers` that is itself never called, so
they are broken twice over.

---

## What to use instead

The information still exists; it is read rather than awaited.

| Instead of | Read |
|---|---|
| `AttackedByEnemy` | `GameObjectEvent.TakeDamage` (live, fires on the victim and names the source), or sample `living.LastAttackedByEnemyTick` |
| melee vs ranged | `living.attackComponent.AttackerTracker.MeleeCount` -- a maintained count of who is currently swinging rather than shooting |
| `AttackFinished` | `GameObjectEvent.TakeDamage`, read from the source side |
| `Moving` | sample `living.IsMoving` plus distance from a stored point, a few times a second |

`TakeDamage` is the useful one: it is raised from `GameObject.TakeDamage`,
fires once per blow that lands, and names both ends of it -- so a single
handler can pay attention to the striker, the victim, or both.

---

## Fixed here

- **`GaherisHereticRamp`** -- the channel's melee and ranged interrupts moved
  onto `AttackerTracker.MeleeCount` and `LastAttackedByEnemyTick`, sampled on
  the same 400ms beat that already watched the caster's feet. Movement had
  already been moved off `Moving` for the same reason.
- **`GaherisVampiirPower`** -- was subscribed to `AttackedByEnemy` *and*
  `AttackFinished`, so the whole script had never done anything since it was
  written. Rewired onto `TakeDamage`, one handler covering both the blow taken
  and the blow landed.

## Not fixed, deliberately

**`PrimerSpellHandler`** breaks a Warlock's primer when he moves, and cannot,
because it listens for `Moving`. Whether a primer *should* break on movement is
DOL's own claim -- there is no patch note for it -- so it stays as it is until
there is a source. See [warlock.md](warlock.md).

Everything else in the dead list is untouched. Reviving these events wholesale
would switch on dozens of handlers at once that have never run on this server
and have never been tested; they are better taken one at a time, as the class
or ability they belong to comes up for testing.
