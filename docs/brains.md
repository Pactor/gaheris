# Brains

Everything that decides what an NPC *does* lives in a brain. The body
(`GameNPC`) holds position, stats and inventory; the brain holds intent. If you
want a monster to behave differently, you are writing a brain.

Written 5 September 2026 against the code as it stands.

---

## The shape of it

```
ABrain                        the contract: a Body, a Think(), a tick interval
└── APlayerVicinityBrain      only runs while a player can see the body
    └── StandardMobBrain      aggro, spells, the state machine -- the real base
        ├── ControlledMobBrain     pets: has an owner, obeys commands
        │   └── (Necromancer, Animist, Theurgist, Bonedancer pets)
        ├── KeepGuardBrain         guards
        ├── FriendBrain            temporarily on your side
        ├── FearBrain              runs away
        └── MercenaryBrain         ours -- hired companions
BlankBrain                    does nothing at all, on purpose
```

Pick the lowest base that already does most of what you want. Almost always
that is `StandardMobBrain`. Use `BlankBrain` for something that must never act
-- a prop, a marker, a summoned merchant.

---

## The contract

`ABrain` is small. These are the members worth knowing:

| Member | What it is for |
|---|---|
| `Body` | the `GameNPC` this brain drives |
| `Think()` | **abstract.** Called every tick. This is the whole job |
| `ThinkInterval` | milliseconds between ticks. Default 2500 |
| `Start()` / `Stop()` | attach and detach; override to set things up |
| `Notify(e, sender, args)` | the event hook, mostly vestigial -- see below |
| `IsActive` | body alive, in the world, **and visible to a player** |
| `FSM` | the state machine, for brains that use one |

`StandardMobBrain` adds the parts you actually reach for:

| Member | What it is for |
|---|---|
| `AddToAggroList(living, amount)` | put someone on the list |
| `RemoveFromAggroList(living)` | take them off |
| `ClearAggroList()` | forget everyone |
| `IsInAggroList(living)` | ask |
| `GetOrderedAggroList()` | who it wants to kill, most-wanted first |
| `HasAggro` | is it fighting anything |
| `AggroLevel` / `AggroRange` | how eager, and how far -- both come from the `mob` row |
| `CanAggroTarget(target)` | **override this** to change who it will fight |
| `OnAttackedByEnemy(ad)` | **override this** to change how it reacts to being hit |
| `CheckSpells(type)` | cast something: `Offensive`, `Defensive`, `Heal` |
| `AttackMostWanted()` | go and hit the top of the list |
| `Disengage()` | stop fighting, stay where you are |
| `PullFriends(packageId, radius)` | bring the neighbours |

---

## Writing one

The smallest useful brain overrides one method and calls the base:

```csharp
public class TimidBrain : StandardMobBrain
{
    public override void Think()
    {
        if (Body.HealthPercent < 20 && HasAggro)
        {
            Disengage();
            return;
        }

        base.Think();
    }
}
```

Three rules that matter more than they look:

**Call the base unless you mean not to.** `StandardMobBrain.Think()` runs
proximity aggro, the state machine, ability checks and spell casting. Skipping
it gives you a mob that stands still.

**Keep `Think()` cheap.** It runs every 500 to 2500ms for every visible NPC in
the region. Database reads, world scans and allocation belong in `Start()` or
behind a counter, not in the tick.

**Guard everything.** `Body`, `Body.TargetObject` and the aggro list can all be
null or empty mid-tick. A brain that throws is a mob that stops thinking.

### Reacting to a hit

Override `OnAttackedByEnemy`. `LoyalFriendBrain` in
`scripts/classes/catacombs/bainshee/Befriended.cs` is the whole pattern:

```csharp
public override void OnAttackedByEnemy(AttackData ad)
{
    // A guard does not round on the one who called it.
    if (ad?.Attacker != null && ad.Attacker == _calledBy)
        return;

    base.OnAttackedByEnemy(ad);
}
```

### Casting

`CheckSpells(eCheckSpellType.Offensive)` walks the body's spell list, picks
something usable and casts it. `StandardMobBrain` already calls it from the
aggro state, so a mob with spells on its template will use them without you
writing anything.

---

## Attaching a brain

Three ways, and choosing the wrong one is the usual mistake.

### 1. From the database — permanent, for placed mobs

The `mob` table has a `Brain` column holding a **fully qualified class name**:

```
DOL.AI.Brain.KeepGuardBrain      286 mobs
DOL.AI.Brain.GuardBrain          380 mobs
DOL.AI.Brain.ChangelingBrain     166 mobs
```

Empty or `NULL` means `StandardMobBrain`, which is nearly 150,000 of our rows.
`GameNPC.LoadFromDatabase` resolves the name across every loaded assembly, so a
brain written in `scripts/` works here exactly like a core one.

### 2. `SetOwnBrain(brain)` — permanent, for mobs you create in code

Replaces the body's own brain. This is what a spawned NPC wants:

```csharp
merc.SetOwnBrain(new MercenaryBrain(player));
```

### 3. `AddBrain(brain)` / `RemoveBrain(brain)` — temporary, for effects

A body keeps a **stack**. `Brain` returns the top of it, falling back to the own
brain when the stack is empty. `AddBrain` pushes and stops whatever was
running; `RemoveBrain` pops and restarts what was underneath.

This is the right tool for a spell that changes behaviour for a while — Fear,
Befriend, Charm:

```csharp
npc.AddBrain(new FearBrain());          // on
...
npc.RemoveBrain(theBrainYouAdded);      // off, previous one resumes
```

**`AddBrain` throws if the brain is already active.** Never add one instance to
two bodies, and never re-add one you have not removed.

**Remove the exact instance you added.** Keep a reference. Our Befriend and Fear
effects hold theirs in a dictionary keyed by the NPC precisely for this.

---

## Things that will catch you out here

**Do not hook events for movement, attacking or casting.** `AttackedByEnemy`,
`AttackFinished`, `Moving` and `CastStarting` are all subscribed to by dozens of
core files and **raised by nothing**. `ABrain.Notify` still exists and is still
mostly pointless. Override the method — `OnAttackedByEnemy` — or sample state on
your tick. `scripts/core/MovementWatch.cs` exists to sample movement, attacks
and casting for exactly this reason. See `dead-events.md`.

**A brain only thinks when somebody is watching.** `IsActive` requires
`Body.IsVisibleToPlayers`, and `APlayerVicinityBrain.Start()` refuses outright
if no player can see the body. Anything you expect to happen in an empty zone
will not happen. That is a deliberate performance choice, not a fault.

**The `Brain` column is a class name in the database.** Renaming or moving a
brain class breaks every mob that names it, with only a line in the boot log to
say so:

> `GameNPC error in LoadFromDatabase: can not instantiate brain of type … `

The same trap as `mob.ClassType` and `serverproperty.player_class`. Grep the DB
before you rename.

**Hired companions are deliberately not pets.** `MercenaryBrain` derives from
`StandardMobBrain`, **not** `ControlledMobBrain`, and does not implement
`IControlledBrain`. That was a choice: being pets is what had monsters walking
through the group to reach the player. The cost is that every piece of core code
which asks "is this a pet?" answers no for a hire — which is why
`scripts/gaheris/Loot.cs` has to substitute the employer before the loot
generators ever see the killer. Expect to do the same anywhere else that checks
`Brain is IControlledBrain`.

**Our keep guards are ordinary mob rows.** They are placed as mobs with a guard
brain rather than through the keep system, so `guard.Component` is null and any
core path that dereferences it will throw. This has bitten three times. See
`KeepGuardData.md`.

**`ThinkInterval` is a property, not a field.** `StandardMobBrain` computes it
from `AggroLevel`, so overriding it means overriding the property:

```csharp
public override int ThinkInterval => 1000;
```

---

## The state machine

`StandardMobBrain` drives an FSM rather than a pile of if-statements. The states
live in `ai/brain/StandardMob/StandardMobState.cs`:

| State | Meaning |
|---|---|
| `WAKING_UP` | just spawned or just became visible |
| `IDLE` | nothing to do; watching for aggro |
| `AGGRO` | fighting — this is where `CheckSpells` and `AttackMostWanted` run |
| `ROAMING` | wandering within its roam radius |
| `RETURN_TO_SPAWN` | went too far, going home |
| `PATROLLING` | walking a path |

For most work you do not touch the FSM — override `Think`, `CanAggroTarget` or
`OnAttackedByEnemy` and let the states carry on. Reach for a custom state only
when you need behaviour the six do not describe.

---

## Worked examples in this repo

| File | Shows |
|---|---|
| `scripts/gaheris/Mercenaries.cs` | the big one: a full companion brain, formation keeping, a 1000ms tick |
| `scripts/classes/catacombs/bainshee/Befriended.cs` | pushing and popping a temporary brain, and overriding `OnAttackedByEnemy` |
| `scripts/classes/catacombs/bainshee/SustainedPulse.cs` | the same for Fear, including a level cap on who may be affected |
| `scripts/gaheris/MonsterGarrison.cs` | subclassing `KeepGuardBrain` and adding patrolling |
| `scripts/toa/Encounters.cs` | giving a copied mob its brain at spawn |

---

## A checklist for a new brain

1. Which base? `StandardMobBrain` unless you have a reason.
2. Permanent or temporary? `SetOwnBrain` / DB column, or `AddBrain`.
3. Override `Think`, and **call the base** at the end.
4. Need to change who it fights? `CanAggroTarget`.
5. Need to change how it reacts to a hit? `OnAttackedByEnemy`.
6. Anything that needs movement, attack or cast *events* — sample it with
   `MovementWatch` instead. The events are dead.
7. Compile-check before deploying: one bad script file kills every script.
   `~/scriptcheck`, then `~/.dotnet/dotnet build`.
8. If a mob row names your class, do not rename the class.
