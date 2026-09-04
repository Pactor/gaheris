# The Bainshee

Research note, written like the Warlock's and the Heretic's: what the class
*is*, checked against the official class library, our own database, and the
core's source.

---

## What she is

A Hibernian cloth caster whose magic is sound, and **the only class in the game
restricted by sex** -- she may only be played by a female avatar, which the
client enforces at creation. Three areas of attack, one per spec: point blank,
ranged, and frontal cone.

| Line | | Ours holds |
|---|---|---|
| **Spectral Force** | baseline | 10 self armour factor, 10 direct damage, 8 root/snare, 2 absorption, 1 bladeturn |
| **Ethereal Shriek** | ranged AoE | 10 direct damage, 7 bolts, 7 dex/qui debuff, 5 nearsight, 4 snare, 3 range shields |
| **Phantasmal Wail** | point blank | 7 pulsing auras, 7 dex/qui debuff, 6 fear, 5 root, 4 befriend, 2 buff shear |
| **Spectral Guard** | frontal cone | **23 cone spells** -- 9 damage, 8 bolt, 6 root -- plus 4 taunts and 3 group ablatives |

**The content is right.** Line for line this matches the class library,
including the oddities: the befriend that turns monsters into realm guards, the
nearsight focus, the group ablative, the taunts on a cloth caster. 130 spells,
levels 1 to 50, nothing obviously missing.

### Wraith form

Implemented, in `ClassBainshee`, and **working** -- it is the one piece of her
built on events that are actually raised.

Casting anything without a positive effect turns her into a wraith: the model
swaps by race (Celt 1883, Lurikeen 1884, Elf 1885) and a thirty-second timer
starts, restarted by every further offensive cast. It ends on the timer or on
leaving the world.

One thing is commented out in the core: keeping the form while an offensive
pulsing spell is running. As written, a Bainshee holding a Phantasmal Wail aura
drops out of wraith form after thirty seconds while still channelling it.

---

## What is broken

Both faults are the dead-event problem. See [dead-events.md](dead-events.md).

### The pulsing aura cannot be stopped

`BainsheePulseDmgSpellHandler` -- the seven Phantasmal Wail auras -- registers
for `GamePlayerEvent.Moving` and `GamePlayerEvent.Dying`. `Moving` is never
raised by this server, so **walking does not stop the aura**. That alone is the
Heretic's bug again.

It is broken a second time underneath, and this one would bite even if the
event worked:

```csharp
PulsingSpellEffect effect = null; // concentrationEffects[i] as PulsingSpellEffect;

if (effect == null)
    continue;
```

The cast that finds the effect is commented out, so `effect` is always null,
the loop always continues, and `CancelPulsingSpell` **always returns false**.
Nothing can cancel the aura -- not moving, not the `Dying` handler that is
registered alongside it and does fire.

### The range shield does nothing, and would do the wrong thing

`RangeShield` -- Wraith's Shield, Barrier and Barricade, at 21, 31 and 41 --
registers for `GameLivingEvent.AttackedByEnemy`, which is never raised. The
ranged damage reduction never applies. It inherits from
`BladeturnSpellHandler`, so whatever bladeturn it grants still works; the part
the spell is named for does not.

It should not simply be rewired, because the arithmetic is wrong too:

```csharp
value = Spell.Value * .01;
attackArgs.AttackData.Damage *= (int) value;
```

`Damage` is multiplied by `value` **cast to int**. A Value of 50 gives 0.5,
truncating to 0; a Value of 150 gives 1.5, truncating to 1. So the spell either
erases the damage entirely or does nothing, with no setting that halves it.

And all three of ours carry **`Value = 0`**. Reviving this as it stands would
give her group total immunity to every ranged attack and every arrow for thirty
seconds. This needs data before it needs code.

---

## Checked and cleared

Two things that look like faults and are not:

**Her eligible races are empty in the core** -- `ClassBainshee.EligibleRaces`
has the whole list commented out, and both `CharacterCreateRequestHandler` and
`GameTrainer` refuse a class whose list does not contain the race. That would
make her uncreatable and unpromotable. Our own `GaherisRaces.cs` already
restores it.

**The `Spectral Force` line is labelled `Spec = 'Spectral Guard'`**, which reads
like a mislabel. It is not. `classxspecialization` grants her exactly three
specs -- Ethereal Shriek, Phantasmal Wail, Spectral Guard -- and no Spectral
Force, so the baseline has to hang off a spec she actually has. Changing it to
match its own name would make the baseline unreachable.

---

## To confirm before changing anything

The class library calls Phantasmal Wail's point blank pulse and its roots
**uninterruptible**. All seven of our auras carry `Uninterruptible = 0`. That
is the same shape of fault as the Heretic's Blazes, which were also
uninterruptible on live and unmarked here -- but the Heretic had a patch note
behind it and this does not yet. Worth checking the notes before touching the
data.

## What to test

1. Cast a **Phantasmal Wail aura** and walk. Expect it to keep pulsing --
   that is the bug, and it should be seen before it is fixed.
2. Cast one and **die**. Expect it to keep pulsing too, which shows the second
   fault is real and separate from the dead event.
3. Cast anything offensive and watch for **wraith form**, then wait thirty
   seconds while still channelling and watch it drop.
4. Cast into a **cone** from Spectral Guard and confirm it hits a fan of
   targets rather than one.
5. **Befriend** a monster and see whether it turns and fights for you.
