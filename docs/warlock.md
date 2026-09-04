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

### The primers

Three primaries exist only to change what the secondary does. One per line,
and they are the signature of the class.

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

---

## What is missing

The data is complete. The engine is not.

**Powerless does nothing.** It is commented out in the core, in
`SpellHandler.PowerCost`:

```csharp
// Warlock.
/* GameSpellEffect effect = SpellHandler.FindEffectOnTarget(m_caster, "Powerless");
if (effect != null && !m_spell.IsPrimary)
    return 0;*/
```

**Range does nothing.** Nothing anywhere reads the Range primer to extend a
secondary's reach.

**The pairing itself does not exist.** Searching the whole codebase for
`IsPrimary` and `IsSecondary` finds two uses: a commented-out block, and one
effectiveness penalty for Uninterruptable. Nothing makes a secondary land with
a primary, and nothing gives primaries their doubled cast time.

**The rule is not enforced.** `Infernal Sore`'s own delve says it cannot be
cast until after a primary. It can be, freely.

**Chambers were entirely broken** until today, and are now the only part of
the mechanic that works -- because the pairing had to be implemented inside
them to make them work at all.

---

## What that means for the class as it stands

A Warlock here is a caster with a large spell list, no pairing, no primers
that do anything, and working chambers. Every individual spell casts and does
its damage, so nothing looks broken from the outside. What is absent is the
reason to play the class.

The parts already built for chambers are most of what a full implementation
needs: `ChamberLoader` already tracks an open primary and the secondary that
follows it, and both packet paths that carry a spell are already intercepted.
Extending that from "while a chamber is casting" to "while any primary is
casting" is the same shape of work.

---

## Order worth doing it in

1. **Pairing.** A primary opens a window; the next secondary is bound to it
   and lands with it. Everything else depends on this.
2. **Powerless and Range.** Once a secondary knows which primary it belongs
   to, both are small.
3. **The rule.** Refuse a secondary with no primary, as its own delve says.
4. **Doubled cast time on primaries**, which is the cost that makes the whole
   trade fair. Worth doing last, because until the pairing works it is a
   penalty with no benefit attached.
