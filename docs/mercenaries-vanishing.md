# Hires that vanish without dying

Reported as "2 mercs died during a pull, still waiting for them to return".
They had not died. They were deleted, and nothing was ever going to bring them
back.

---

## How a hire is lost

Every ECS service answers a component that throws in the same way. From
`GameServiceUtils.HandleServiceException`:

```csharp
if (entity != null)
    ServiceObjectStore.Remove(entity);
...
case not null:
    action = () => entityOwner.RemoveFromWorld();
```

So one exception out of a brain, a casting component or an effect and the body
that owns it leaves the world. For a hire that is not a death:

- `Die()` never runs, so it is never removed from the company and never handed
  to `ScheduleReturn`
- `RemoveFromWorld` has already called `_leash?.Stop()`, so its own timer is
  gone too
- the roster still lists it as a live member of a company it is no longer in

Nothing ticks for it again. It comes back on the next login, when
`MercenaryMuster.Muster` rebuilds the whole roster, and not before -- which
from the player's side is indistinguishable from a death that never healed up.

It also takes the rest of that tick with it: the exception unwinds out of the
service loop, so every entity after it in that pass is skipped.

**A relog is the immediate recovery.** `RestoreRoster` disbands whatever is
left and fields the saved roster again, gear and all.

---

## What was actually throwing

Counted over one 20-hour boot, 7 September 2026:

| Removed | Count | Fault |
|---|---|---|
| Necromancer | 6 | `PetSpellHandler.CheckBeginCast` NRE |
| necroservant | 6 | same |
| Warlock | 5 | `WarlockPairing.Begin` `ArgumentNullException (key)` |
| Valkyrie | 2 | `CastingComponent.StartEndOfCastLosCheck` NRE |
| Master Visur | 3 | `MainTeleporterBrain.Think` NRE -- core, not ours |
| Minsty, Bainy | 1 each | players kicked to char screen |

Thirteen hires deleted in a day, from three separate faults.

### 1. The Warlock: a dictionary keyed on a null

`WarlockPairing` held the weave in flight in a
`Dictionary<string, Pairing>` keyed on `player.InternalID`.

`InternalID` is the database row id and is only ever assigned by
`GameObject.LoadFromDatabase`. A hire is built with `new` and never persisted,
so **its InternalID is null** -- visible in the log as `DB_ID=` with nothing
after it. `_open[null] = ...` throws `ArgumentNullException`, out of `Begin`,
out of `CastAt`, out of `MercenaryBrain.Think`, into `NpcService`.

Every hired Warlock died on its first primary cast.

Fixed by keeping the pairing in `TempProperties` on the caster instead: on
every `GameLiving`, null-safe, locked internally, and it dies with the object,
so there is no key and nothing to leak.

### 2 and 3. Core casting a hire's spells behind our back

Both remaining faults come from the same place: `MercenaryBrain.Think` calls
`base.Think()` while a hire is still swinging, `StandardMobBrain` reaches
`AttackMostWanted`, and that calls `CheckSpells` -- which picks a spell at
random out of `Body.Spells` and casts it with
`Body.CastSpell(spell, m_mobSpellLine)`.

That path is not `CastAt` and honours none of its guards:

- **A `PetSpell` reaches `PetSpellHandler.CheckBeginCast`**, which reports a
  missing pet with
  `LanguageMgr.GetTranslation((Caster as GamePlayer).Client, ...)`. A hire is
  not a `GamePlayer`, so it is a null dereference. `CastAt` has refused
  `PetSpell` for exactly this reason since the Necromancer work; core simply
  went around it.
- **`checkLos` is left at its default of `true`**, and the end-of-cast check
  reads `castingComponent.SpellHandler` with no null test. `CastAt` passes
  `false`. This is the one that took the Valkyrie.

Fixed by overriding `CheckSpells` in `MercenaryBrain` to return false.
`RoleThink` already owns every spell a hire casts -- kit, cooldowns, targeting
and all -- so nothing is lost. Melee is untouched: false is the answer that
sends `AttackMostWanted` to `StartAttack`.

---

## The two guards added underneath

Because the next core bug will be a different one.

**`MercenaryBrain.Think` catches.** A bad tick is logged and the next one is
taken. Nothing a brain does is worth deleting a hire the player paid for, and
nothing it does is worth skipping every other NPC in that pass.

**`GameMercenary.WatchForSilentLoss`.** Anything that leaves the world while
still alive and still on the company books is treated as a fall: removed from
the company and handed to `ScheduleReturn`, so it walks back on its own.

The check waits three seconds first, because `MoveTo` is a remove followed by
an add -- a teleport to the employer, a zone line, a trip to the frontier -- and
a hire that is back in the world by then went nowhere. Deliberate removal is
excluded outright by a `_retiring` flag set in `Retire()`.

This covers the causes we have not found yet, including any in
`CastingService`, `AttackService` or `EffectService`, which the brain's own
catch cannot see.

---

## Still open

- `MainTeleporterBrain.Think` NRE, 3 hits on Master Visur. Core, unrelated to
  hires, but it does remove the teleporter from the world until a reboot.
- `Group.RemoveMember` still threw once through `GamePlayer.CleanupOnDisconnect`
  -- the `First()`-on-empty crash the `Detach` handler exists to prevent. One
  occurrence, cause not yet found.
- Inventory rows failing to save for `-merc-` owner ids ("0 rows affected"),
  seen on a Spiritmaster robe and a Skald axe. Not fatal, not investigated.
