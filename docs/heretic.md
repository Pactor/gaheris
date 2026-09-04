# The Heretic

Research note, written the way the Warlock's was: what the class *is*, checked
against the official class library, the 1.616 spell data, our own database and
the core's source.

---

## What he is

An Acolyte who renounces the Church of Albion at level five and serves Arawn
instead. Cloth armour, small shields, flexible weapons, and a spell list built
around one idea nobody else has.

| Line | What it is | Ours is called |
|---|---|---|
| Rejuvenation | baseline heals | `Rejuvenation` (shared) |
| **Arawn's Fire** | the channelled damage, snares, the resurrection | `Heretic Rejuvenation Spec` |
| Enhancement | baseline buffs | `Heretic Enhancement` |
| **Cthonic Accretion** | armour factor, absorption, damage add, piercing magic | `Heretic Enhancement Spec` |

The two spec lines exist and are reachable. They are simply named after the
baseline they hang off rather than after the line, which is why a first look
suggests they are missing.

---

## The channel

The defining mechanic. A focus spell that pulses, and **grows the longer it is
held** -- "start slowly but will eventually ramp up over the course of 10-20
seconds to match that of a pure damage dealing caster".

Twelve spells, all Pulse 1 at Frequency 15: the nine **Arawn's** spells from
Singe at level 1 to Inferno at 47, and three **Blazes**.

### What breaks it

From the 1.616 spell data, not from preference:

- **Cannot** be interrupted by ranged attacks -- archery, crossbows, spells
- **Can** be interrupted by melee attacks, and by sitting
- "Caster may not do anything else while spell is in effect"

So: moving, sitting, swinging, losing the target, the target dying, leaving
range, or a melee blow. A blow from range breaks the Arawn's spells and is
exactly what the Blazes are for.

### The two kinds

| | Arawn's | Blazes |
|---|---|---|
| Damage | higher | lower |
| Duration | 16s | **33s** |
| Ranged attacks | break it | do not |

`Glistening Blaze` (36), `Whirling Blaze` (42) and `Torrential Blaze` (48) are
the uninterruptible ones. We had them all along with the right damage --
90/104/120 a pulse, matching the 1.616 data exactly -- and no flag saying what
they were, and half the duration they should have had.

---

## The resurrection

Not a resurrection. Reanimate Corpse (level 41) raises the target **as a
monster**, and the chain is four spells:

| ID | | |
|---|---|---|
| 14076 | Reanimate Corpse | raises, then casts the next |
| 14078 | Summon Monster | changes model, grants 90% magic and physical absorption, sets full health, lasts 45 seconds |
| 14077 | Monster Dot | 64 damage to everything within 500 units, every pulse |
| 14079 | Monster Disease | disease to everything within 500 units, every pulse |

For forty-five seconds the raised player is a nearly immune monster that leaks
damage and disease onto everything around them. Then it ends, the model
reverts, and they are left on **a tenth of their health**.

It also cancels on dying, linkdeath, quitting, or changing region -- so it
cannot be carried out of the fight it was cast in.

---

## What was wrong

**The channel dealt no damage at all.** The pulse machinery calls
`StartSpell` and then `ApplyEffectOnTarget` over and over; `OnDirectEffect` --
the only thing in the handler that deals damage -- was never called by
anything. The aura re-applied itself every beat and nothing was hurt.

**It never ramped**, because nothing implemented the ramp. The core has a
`RampingDamageFocus` handler that does exactly this and **no spell in this
database is of that type** -- the reference dump types them
`HereticDoTLostOnPulse`, which is not in the core's enum at all and would have
no handler whatsoever. Our `HereticDamageOverTime` is the better of the two.

**Nothing ended it.** The core defines the interrupt handlers in
`HereticPiercingMagic.BeginEffect` -- moving, attacking, being attacked,
casting -- and never calls `BeginEffect`, so not one was hooked up. The channel
ran through the target's death, through losing it, and through walking away.

**The Blazes were not marked uninterruptible** and lasted 15 seconds instead
of 33, so the two lines were indistinguishable.

**The contagion was half broken.** 14079 was typed `Disease` rather than
`MonsterDisease`. A plain disease hits one target; `MonsterDisease` overrides
target selection to hit everything within its radius. The row already carried
Radius 500 and nothing read it. Its partner, 14077, was typed correctly -- so
the damage spread and the disease did not.

---

## Still missing

**Nothing known.** Unlike the Warlock, every piece of this class turned out to
be present in the data once it was looked for -- including the uninterruptible
spells I was on the point of inventing. The gaps were all wiring.

## What to test

1. Channel an **Arawn's** spell and watch the damage climb ten percent a
   pulse, roughly doubling as the sixteen seconds run out.
2. **Move**, **sit**, or **swing** -- it should end and say so.
3. Let something **melee** you -- it should end.
4. Channel a **Blaze** while something shoots you -- it should hold.
5. At 41, **Reanimate Corpse** on a dead group member: they should come up as
   a monster on full health, spreading damage and disease for forty-five
   seconds, and drop to a tenth of their health when it ends.
