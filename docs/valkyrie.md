# The Valkyrie

Midgard, Catacombs (December 2004). Class 34. Chain armour, spear and sword, a
hybrid who heals and fights. Odin's chooser of the slain.

Verified 5 September 2026 against the running server and then confirmed in
play. **Nothing in her is known to be broken.**

Two faults were found and fixed, neither of them in her spell content: a crash
waiting in her pulsing cones, and her damage line not being marked as the
hybrid line it is, which made her buff-strips cast their neighbours. Both are
confirmed working. The log stayed clean through testing.

---

## What she has

Three lines, not five. An earlier version of this note listed `Healer Mending
Spec` and `Shaman Mend Spec` as hers because they hang off the `Mending` spec
she is granted; they are hinted at classes 26 and 28, so the game filters them
out and she never sees them. 107 spells, not 190.

| Line | | Holds |
|---|---|---|
| Mending | baseline, 28 | heals, cure poison, cure disease, a resurrect |
| Valkyrie Mending Spec | spec, 32 | heals, heal over time, health regen, a resurrect |
| **Odin's Will** | spec, 47 | **5 pulsing frontal cones**, direct damage, 3 group ablatives, shears, an offensive proc, a resurrect |

Spear and sword are weapon specialisations and carry styles rather than spells;
this audit did not cover them.

### Three resurrects, and they are real

`Mending` 10 **Arrival from Valhalla**, `Valkyrie Mending Spec` 35 **Redeem
from Valhalla**, `Odin's Will` 43 **Call from Valhalla**. Distinct spells with
distinct names at rising levels, one per line -- not the shared healer lines
bleeding through, which was the earlier suspicion. That question is closed.

One caveat: `Redeem from Valhalla` carries spell id **121001**, far above the
range around it, which is the signature of something added to this database
rather than imported. The same signature as the Animist's Fungal Potency. It
works; whether it belongs is a separate question.

---

## The crash that was waiting, and is fixed

Odin's Will carries five **pulsing frontal cones**, the exact shape that
dropped a Bainshee to the character screen: a cone spell that ticks outside a
cast asks the casting component for a line of sight check, and that method
reads the component's *own* current handler rather than the one it is passed.
During a pulse there is none, so it throws and takes the session with it.

Fixed in `scripts/classes/catacombs/valkyrie/ValkyrieCone.cs` and **confirmed
in play** -- the cone was cast without incident. It was found by looking for
the shape after the Bainshee hit it, not by anyone being disconnected, so it is
a crash that never happened.

---

## Every spell type she can cast

Checked as deliverable, not merely present -- the test is whether the handler's
behaviour can be reached by the effect system that runs today, which is how
Fear and Befriend were found dead while looking perfectly wired.

| Type | Handler | |
|---|---|---|
| FrontalPulseConeDD | `ValkyrieCone` (ours) | fixed, confirmed |
| Heal, HealOverTime, HealthRegenBuff | core | property-changing, ECS path |
| CurePoison, CureDisease, Resurrect | core | ordinary |
| DirectDamage, SpeedDecrease | core | ordinary |
| MagicAblativeArmor | core | builds its own ECS effect |
| AcuityShear, DexterityQuicknessShear | core | ordinary |
| OffensiveProc | core | invoked directly from `GameLiving.OnAttackEnemy`, one of the few things the ECS rewrite actually rewired |

All thirteen clear. No blank types, nothing parked in a callback nothing calls.

---

## Champion, realm abilities, Master Levels

**Champion.** `Champion Level Midgard` plus Mystic, Rogue and Seer -- three of
Midgard's four archetype trees, correctly excluding **Viking**, which is her
own. Every spell in those trees has a handler.

**Realm abilities.** 33 granted. Every one instantiates and none is backed by a
handler sitting on a dead event, checked against the boot log and the handler
files. Her RR5, **Valhalla's Blessing**, is present and real. She also holds
`AtlasOF_Ichor`, shared only with the Shaman.

Unlike the Bainshee she is **not** missing Avoidance of Magic.

**Master Levels.** All eight lines, like every class, with the faults everyone
shares: `Reveal Crystalseed` has no spell type, and four of the six ML holds
still never end. See `master-levels.md`.

---

## What is left, and it is all feel rather than function

Nothing here is known broken, so what remains is whether it behaves properly in
a fight -- which needs targets, a group, and someone to heal.

1. **A frontal cone** against several targets: does it hit a fan?
2. Whether the cones **keep pulsing while she moves**. Deliberately left alone
   -- the Bainshee's pulses stop on movement, Odin's Will may or may not, and
   there is no source either way. Whatever it does settles it.
3. **The three resurrects**, particularly whether the level 10 one is right.
4. The **group ablative** chants, which also pulse.
5. The **offensive proc** in Odin's Will.
6. **Spear and sword styles**, entirely uncovered by this audit.
