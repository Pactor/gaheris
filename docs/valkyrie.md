# The Valkyrie

Midgard, Catacombs (December 2004). Class 34. Chain armour, spear and sword, a
hybrid who heals and fights. Odin's chooser of the slain.

Audited 4 September 2026 from the live database and the core source. **Not yet
played** -- everything below is what the data and the code say, not what has
been seen.

---

## What she has

| Line | | Holds |
|---|---|---|
| Mending | baseline | 28 -- heals, cures, resurrect |
| Valkyrie Mending Spec | spec | 32 -- heals, heal over time, regen, resurrect |
| **Odin's Will** | spec | 47 -- **5 pulsing frontal cones**, direct damage, ablatives, shears, an offensive proc, resurrect |
| Healer Mending Spec | shared | 46 |
| Shaman Mend Spec | shared | 37 |

Spear and sword are weapon specs and not visible here.

**Nothing is missing.** All 83 spell types she can reach have handlers, and she
has no blank-type spells beyond the two Sojourner ones every class has.

---

## The crash that had not happened yet

Odin's Will carries five **pulsing frontal cone** damage spells, and that is
precisely the shape that dropped a Bainshee to the character screen an hour
before this was written.

`FrontalAOEConeHandler` inherits `DirectDamageSpellHandler`, which asks the
casting component for a line of sight check on anything cone shaped. That
method ignores the handler it is passed and reads the component's own current
one:

```csharp
public bool StartEndOfCastLosCheck(GameLiving target, SpellHandler spellHandler)
{
    if (SpellHandler.LosChecker == null || ...
```

During a pulse nothing is being cast, so it is null and it throws. It surfaces
as a critical error in EffectService and takes the session with it.

Fixed in `scripts/classes/catacombs/valkyrie/ValkyrieCone.cs`, by the same
means as the Bainshee: only ask for the check when there is a cast to hang it
on. **This is untested** -- it is a crash found by looking for the shape rather
than by anyone hitting it, and it would have fired the first time anyone specced
Odin's Will.

Test a cone before anything else, and be ready to be dropped.

---

## What is worth checking against live

Three things the data raises that I have no source for, so nothing was changed:

**Three resurrects, in three lines.** Mending, Valkyrie Mending Spec and Odin's
Will each carry one. That may be the shared healer lines bleeding through rather
than something the class should have.

**`OffensiveProc` in Odin's Will.** Procs are one of the few things the ECS
rewrite actually rewired -- they are invoked directly from `GameLiving.cs:1435`
rather than through the dead `AttackFinished` event -- so this should work. The
core's `ValkyrieProc.cs` is a *different* handler (`ValkyrieOffensiveProc`) that
is still on the dead event, but no spell in the database uses that type, so it
costs nothing.

**Whether the pulsing cones should break on movement.** Her cones pulse, and
the Bainshee's pulsing spells all stop when she moves. Odin's Will may work the
same way or may not; the class library does not say and I found no patch note.
Left alone rather than guessed at.

---

## What to test

1. **A frontal cone from Odin's Will.** Crash check first, damage second, and
   whether it hits a fan rather than one target.
2. Whether the cone **keeps pulsing while you walk**. Report what it does; that
   settles the open question above.
3. **Heal and resurrect** from each line, to see whether the three resurrects
   are really three.
4. The **ablatives** and **shears** in Odin's Will.
5. Spear and sword styles, which this audit did not cover at all.
