# The chamber, ours against DOLSharp's

DOLSharp is where these classes last worked, so its `ChamberSpellHandler` is
the closest thing to a specification we have. OpenDAoC kept the file but lost
the method that did the work, and says so in its own comment:

> `// Likely to be broken. It used to override 'CastSpell', but it no longer`
> `// exists in 'SpellHanlder'. Can't be tested since Warlocks aren't functional.`

Diffed 5 September 2026. DOLSharp 360 lines, OpenDAoC 336, ours ~280 across
`WarlockChamber.cs` and `ChamberLoader.cs`.

---

## Most of DOLSharp's discharge checks are now redundant

Its `CastSpell()` makes sixteen checks before firing. Fourteen of them are done
today by `SpellHandler.CheckBeginCast`, which our handler calls first and
refuses on: alive, sitting, moving, mezzed, stunned, target in view, target in
front, same realm, allowed to attack, within radius, and the rest. Re-adding
them would be writing a second copy of the casting pipeline.

Two were not covered.

---

## 1. Range was never checked against what the chamber fires

**Fixed.**

Every chamber spell in the database carries **`Range = 0`**. The ordinary range
check therefore measures the chamber, and the chamber has no range -- while the
spell banked inside reaches 1500 to 2250. A discharge could land a bolt at any
distance.

DOLSharp measured the **primary's** range explicitly:

```csharp
if (!caster.IsWithinRadius(m_spellTarget,
        ((SpellHandler) spellhandler).CalculateSpellRange()))
{ MessageToCaster("That target is too far away!"); return false; }
```

Ours now does the same before firing.

## 2. The chamber costs 5 endurance

**Not applied.** DOLSharp charges it on arming:

```csharp
m_caster.Mana -= PowerCost(target);
m_caster.Endurance -= 5;
```

We charge the power and not the endurance. It is a real difference and a small
one; whether live charged it is unverified, and five endurance on a caster is
close to free either way. Left for a decision rather than added quietly.

---

## Where we deliberately disagree with DOLSharp

**A chamber with only one spell.** DOLSharp arms whatever it has --

```csharp
if (SecondarySpell == null && PrimarySpell == null)
    MessageToCaster("No spells were loaded into " + m_spell.Name + ".");
else
    // arm it
```

-- so a primary alone gives a working chamber, and the discharge fires the
secondary only `if (chamber.SecondarySpell != null)`.

**We require both.** That came from the class library, which describes the
mechanic only ever as banking a pair, and from a player's recollection that
live refuses a single. A chamber holding one spell is a free instant cast
rather than a trade, which is the wrong shape for the ability.

DOLSharp is an emulator, not live. Where the two disagree it is evidence, not
authority. Recorded here so the disagreement is deliberate rather than
forgotten.

**Quickcast.** DOLSharp's chamber cancels a Quickcast effect on finishing, so
it assumed a Warlock could have Quickcast. We removed Quickcast from the class
in migration 98, because no official source gives it to him and his
Uninterruptable primer is the answer to the same problem. Same reasoning: older
code, not a source.

---

## What DOLSharp confirms about the rest of the class

The pieces we rebuilt are visible in it working, which is worth knowing:

- `CastSpell()` performed the discharge, cast the primary, then the secondary
  if present, cancelled the effect and redrew the orb -- the same sequence ours
  performs from `FinishSpellCast`.
- It redrew the orbs through `SendWarlockChamberEffect` on both arming and
  expiry, which is what our `ChamberRedraw` does after zoning.
- Chamber data matches the class library: `CastTime 6`, `RecastDelay 10`,
  `Power 0`.
