# The Warlock, and what this server does not do

Research note. The Warlock is the most mechanically unusual class in the game
and the least implemented in OpenDAoC, so this records what the class *is*
before any more of it is built.

Sources: the official class library page, the spell data in our own database
(which is complete), and the core's source, which is where the gaps are.

---

## How the class actually works

A Warlock does not cast spells one at a time. Spells are flagged **primary**
or **secondary**, and the class is built on pairing them.

**A primary** casts in roughly double the usual time. While it is casting, a
**secondary** may be added, and it lands at the same moment as the primary at
no extra cost. Two spells, one cast, one interrupt window.

Our data carries the flags: **71 primary**, **36 secondary**, 46 neither
(buffs, chambers and so on). The delve says so too, though inconsistently --
`Hexed Clutching Root` reads "A Primary chamber spell", `Infernal Sore` reads
"Cannot be cast until after a Primary spell has been cast", and `Molding Hex`
says nothing at all despite being primary.

### Casting alone, and casting paired

A primary may be cast on its own and behaves like any other spell -- "Primary
Spells function much like any other spells and can be cast at any time". The
secondary is something the primary OFFERS, not something it demands. What the
primary costs for that offer is its casting time, about double a normal spell.

A secondary may not be cast alone. Its own delve says so, and the primers are
the answer: they exist so a secondary can be cast WITHOUT a primary. That is
their real purpose, and the range, power and interruption differences are what
distinguishes one from another rather than what they are for.

So there are four things a Warlock can do, and only the last is refused:

| | |
|---|---|
| Primary alone | fine, casts like any spell |
| Primary, then a secondary during its cast | the secondary lands with it, free |
| Primer, then a secondary | how a secondary is cast without a primary |
| Secondary alone | refused |

### The primers

Three spells exist to carry a secondary on their own, and each changes it in a
different way. One per line, and they are the signature of the class.

| Line | Primer | Effect on the secondary |
|---|---|---|
| Cursing | **Range** | range extended from 1,750 to 3,000 |
| Hexing | **Uninterruptable** | cannot be interrupted, at a cost to effectiveness |
| Witchcraft | **Powerless** | costs no power |

Example delve, `Steady Cast`: *"Removes the chance of interruption while
casting a secondary spell."*

This is why the Warlock has no Quickcast and never did. Uninterruptable is his
answer to the same problem, bought with a real trade rather than a timer.

### The chambers

A chamber banks a primary and a secondary together for later. Six seconds to
fill, ten second reuse, then released instantly with one click.

| Line | Chamber | Level |
|---|---|---|
| Cursing | Chamber of Destruction | 7 |
| Cursing | Chamber of Decimation | 37 |
| Hexing | Chamber of Lesser Fate | 7 |
| Hexing | Chamber of Greater Fate | 37 |
| Witchcraft | Chamber of Restraint | 7 |
| Witchcraft | Chamber of Creation | 37 |

Only the level 37 chambers may hold bolt spells.

A chamber holds a **pair** or nothing. Every description of the mechanic is of
loading a primary and a secondary; none describes banking a single spell, and
one that held a single spell would be a free instant cast rather than a trade.
The core's orb packet does carry a branch for a primary with no secondary,
which shows only that the client can draw such a chamber -- not that the game
ever let one be made.

### The shape of the three lines

Read from our own data, because the summary pages do not break it down and the
class is easier to reason about once you can see which spells take part.

| Line | Primary | Secondary | Plain |
|---|---|---|---|
| **Cursing** | 11 direct damage, 9 bolts | -- | 8 armour factor, 2 absorption, 1 bladeturn |
| **Cursing Spec** | 10 bolts, 8 direct damage | 6 direct damage, 4 nearsight | 8 direct damage, 6 Range primers, 2 chambers |
| **Hexing** | 9 roots, 8 lifedrains | 6 damage-over-time, 6 snares | 6 Uninterruptable primers, 3 matter debuffs, 2 chambers |
| **Witchcraft** | 16 heals and heal bolts | 9 lifedrains, 3 spreadheals, 2 regen | 5 Powerless primers, 2 chambers |

Three things worth noticing.

**Cursing Spec carries eight plain damage spells** -- Twisting, Warping,
Winding and Wrenching Curse, lesser and greater. These are his ordinary combat
spells, cast alone like anybody else's, and they are exactly the ones
`ClassWarlock.CanChangeCastingSpeed` names as exceptions. A Warlock is not
obliged to weave everything.

**Witchcraft's primaries are heals.** The line pairs a heal with a lifedrain
or a spreadhead, which is what makes the Warlock a support caster as well as a
damage one.

**Only the greater chambers hold a bolt.** The three learned at thirty-seven
-- Decimation, Greater Fate, Creation -- may bank one; the three learned at
seven may not. Without that rule the first chamber a Warlock ever gets would
bank his heaviest spell and the later ones would be worth nothing.

---

## What was missing, and what is built

The data was always complete. The engine was not, and most of it now is.

### Built

**The pairing.** A primary opens a weave; the next secondary clicked is hung
on it and lands when the primary does. Applied directly rather than cast,
because "at the same time" is the point and a second cast would be neither
simultaneous nor free.

**The primers open a weave too.** They carry `IsPrimary = 0` -- they are not
damage or control -- so a flag test alone would have missed the three spells
the class is named for.

**Powerless.** Applying a spell directly skips its power cost, so the cost is
taken by hand for every primary except Powerless. That is exactly what the
primer buys, and it replaces this, which is commented out in the core:

```csharp
// Warlock.
/* GameSpellEffect effect = SpellHandler.FindEffectOnTarget(m_caster, "Powerless");
if (effect != null && !m_spell.IsPrimary)
    return 0;*/
```

**Range.** Enforced here because it cannot be enforced anywhere else --
applying directly skips the range check a cast would have made, so without it
a woven spell would reach across the zone. A Range primer replaces the
secondary's own reach with its own.

**Uninterruptable** needed nothing. Its penalty lives inside `StartSpell`,
which is what the pairing calls, so it applies of its own accord.

**The rule.** A secondary with no primary in flight is refused, as its own
delve always said it should be.

**Bolts only in the greater chambers**, per the class library.

**Doubled cast time on primaries**, which is what pays for the weave. It was
not in the data: our Warlock primaries cast at ordinary speed and in three of
five types slightly faster than average, so this was a real change rather than
a correction. Done in the data, because casting time is worked out per spell
handler with no single place a script can reach, and because a player judging
the class needs to SEE the cost -- a delve reading 2.5 seconds while the cast
takes five would be worse than not doing it.

### The hired Warlock

A hire now weaves as a player does. Until this it did not, and the failure ran
the wrong way: the player's pairing is caught in the skill packet, a hire sends
no packets, so it saw its secondaries for what they look like on paper --
quick casts with real damage -- and threw them one after another with no
primary at all. It played the class backwards, and rather better than the
player's version of it.

None of the weave is re-implemented for it. `WarlockPairing` already takes any
`GameLiving` and closes on `GameLivingEvent.CastFinished`, which a hire raises
exactly as a player does. What was missing was somebody to open one, so
`GameMercenary.CastAt` -- the single funnel every hire's cast passes through --
now opens the weave when it means to cast a secondary, and hangs the secondary
on it.

What it opens with, in order: a **Powerless** primer first, because a hire has
no judgement about its own power bar and will otherwise drain it; then
**Uninterruptable**, worth most in a fight; then **Range**; and failing all
three the strongest **primary** it knows, which is no waste since a primary
lands as well as the secondary does.

A secondary with nothing to hang it on is refused, which is the rule the player
is held to. That case should not arise -- every Warlock line carries a primary
at level 1 or 2 and its first secondary no earlier than 2 -- but it is refused
rather than quietly cast alone.

### Still missing

**The Range effectiveness cost.** `Perennial Range` should carry a spell three
thousand units at half strength; here it carries it at full. The core has one
formula for this and it reads `Value` as a reduction, while Range stores
effectiveness retained -- 100 means full, 50 means half. Feeding Range through
that formula would make `Enduring Range`, which should be the cheapest and
strongest, cast at nothing at all. Left alone rather than bodged.

**Nothing else.** The doubled cast time is applied -- see below.

---

## What to test

1. Cast a **primary** -- a root, a lifedrain, a direct damage curse. It should
   cast as normal.
2. During that cast, click a **secondary** -- a damage-over-time, a snare. It
   should say it is woven in rather than casting.
3. When the primary lands, the secondary should land with it.
4. Click a **secondary alone**. It should be refused.
5. Cast a **Powerless** primer, then a secondary: no power spent.
6. Cast a **Range** primer, then a secondary at something far away: it should
   reach where it otherwise would not.
7. Cast one of the eight plain Cursing Spec curses. It should behave like any
   ordinary spell, because it is one.
