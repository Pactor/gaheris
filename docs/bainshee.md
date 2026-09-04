# The Bainshee

Hibernia, Catacombs (December 2004). Class 39. A cloth caster whose magic is
sound, and the only class in the game restricted by sex -- female avatars only,
which the client enforces at creation.

Researched 4 September 2026, fixed and verified over 4-5 September. Everything
below that says "works" was either seen in play or checked against the running
server, not inferred from the data.

---

## What she has

| Line | | Holds |
|---|---|---|
| **Spectral Force** | baseline | 10 self armour factor, 10 direct damage, 8 root/snare, 2 absorption, 1 bladeturn |
| **Ethereal Shriek** | ranged AoE | 10 direct damage, 7 bolts, 7 dex/qui debuff, 5 nearsight, 4 snare, 3 range shields |
| **Phantasmal Wail** | point blank | 7 pulsing auras, 7 dex/qui debuff, 6 fear, 5 root, 4 befriend, 2 buff shear |
| **Spectral Guard** | frontal cone | **23 cone spells** -- 9 damage, 8 bolt, 6 root -- plus 4 taunts and 3 group ablatives |

130 spells, levels 1 to 50. Line for line this matches the class library,
including the oddities: the befriend that turns monsters into realm guards, the
nearsight focus, the group ablative, taunts on a cloth caster.

`Spectral Force` is the baseline and is labelled with the `Spectral Guard`
spec on purpose -- `classxspecialization` grants her only three specs, so the
baseline has to hang off one she actually has. Changing it to match its own
name would make the baseline unreachable.

### Wraith form

Works. Casting anything without a positive effect turns her into a wraith --
model by race, Celt 1883, Lurikeen 1884, Elf 1885 -- with a thirty second timer
restarted by every further offensive cast. It ends on the timer or on leaving
the world. It is the one piece of her built on events that are actually raised.

One thing is commented out in the core: keeping the form while an offensive
pulsing spell runs. As written she drops out of wraith form after thirty
seconds while still channelling.

---

## Every spell type she can cast, and whether it can work

The test is not "does a handler exist" -- one existed for every one of these
while three of them did nothing. It is whether the handler's behaviour can
actually be delivered by the effect system that runs today.

| Type | Handler | Verdict |
|---|---|---|
| BainsheePulseDmg | `BainsheeAura` (ours) | **fixed** -- see below |
| Fear | `SustainedFear` (ours) | **fixed** -- brain was never attached |
| BeFriend | `Befriended` (ours) | **fixed** -- brain was never attached |
| Nearsight | `SustainedNearsight` (ours) | works; stops on movement |
| ArmorFactorBuff | `ArmorFactorBuff` (ours) | works -- core's could not be constructed |
| Bladeturn | `BladeturnECSGameEffect` | works, ECS effect |
| MagicAblativeArmor | `AblativeArmorSpellHandler` | works -- builds its own ECS effect |
| DirectDamage, Bolt, SpeedDecrease, DexterityQuicknessDebuff, AcuityShear, ArmorAbsorptionBuff, Taunt | core | ordinary ECS paths, nothing legacy |
| **RangeShield** | `RangeShield` (core) | **still broken, deliberately** |

---

## What was wrong, and what fixed it

Four faults, and every one of them looked correct in both the data and the
handler. Nothing logged, nothing warned.

**The auras dealt damage but could not be stopped.** `CancelPulsingSpell` in
the core searches concentration effects for a legacy `PulsingSpellEffect` with
the line that finds one commented out, so it always returned false. Nothing
could cancel an aura -- not moving, not the `Dying` handler registered beside
it, which fires and was simply told there was nothing to cancel. Restored
against `ECSPulseEffect`, which is where pulses actually live.

**Movement never ended anything**, because `GamePlayerEvent.Moving` is never
raised. Her feet are sampled every 400ms instead.

**Her auras crashed whoever cast one.** `OnDirectEffect` asks the casting
component for a line of sight check on anything point blank, and that method
reads the component's *own* current spell handler rather than the one it is
given. During a pulse nothing is being cast, so it is null and it throws --
surfacing as a critical error in EffectService and dropping the caster to the
character screen. The check is now only asked for when there is a cast to hang
it on.

**Fear frightened nothing, and Befriend befriended nothing.** Both attach a
brain -- `FearBrain`, `FriendBrain` -- from `OnEffectStart(GameSpellEffect)`.
That is the legacy effect callback and the only thing that calls it is
`GameSpellEffect` itself, which duration spells no longer create:
`OnDurationEffectApply` builds an `ECSGameSpellEffect` instead. So both spells
landed, passed their resist checks, held their duration, and had no
consequence whatsoever. Both brains are now attached where the effect is really
applied and removed when the time is up.

**The Screech was not a `BainsheePulseDmg`.** Her fear and her nearsight pulse
too, so the first movement fix never saw them; both are covered now.

**Migration 103** marked the seven auras uninterruptible, which the class
library calls for and which a point blank spec needs, since standing in the
middle of a fight is the whole idea. Uninterruptible is not unstoppable --
moving and dying still end them.

### Still broken, on purpose

`RangeShield` -- Wraith's Shield, Barrier and Barricade at 21, 31 and 41. It
is on a dead event, its arithmetic multiplies damage by `(int)(Value * 0.01)`
which truncates to 0 or 1, and all three spells carry `Value = 0`. Reviving it
as written would make her group immune to every ranged attack. **It needs data
before it needs code.**

### Open question

`Diminishing Wail` has `Range 0`, making it point blank and needing no target
-- correct for Phantasmal Wail, but it is the *same spell row* in Ethereal
Shriek, which is the ranged spec. That looks wrong and there is no source for
what the ranged version should be.

---

## Champion, realm and Master Level

Checked as function rather than inventory.

**Champion.** She is granted `Champion Level Hibernia` and four of Hibernia's
five archetype trees -- Forester, Guardian, Naturalist, Stalker -- correctly
excluding Magician, which is her own archetype. Every spell in those trees has
a type and every type has a handler. See `champion-levels.md`.

**Realm abilities.** 28 granted. Every one instantiates, and none is backed by
a handler sitting on a dead event -- checked against the boot log and the
handler files, not assumed. Her RR5, **Sonic Barrier**, is present and backed
by a real class.

She lacks `AtlasOF_AvoidanceOfMagic`, which 45 of 47 classes have. Not added:
there is no source saying she should have it, and the one piece of evidence
that would have settled it -- her apparently missing Purge -- turned out to be
a variant she does have. See `realm-abilities.md`.

**Master Levels.** She reaches all eight lines, like every class. Two faults
are hers only in the sense that they are everybody's: `Reveal Crystalseed` has
no spell type and cannot work without a core change, and four of the six ML
holds still never end. Two are fixed. See `master-levels.md`.

---

## Status: concept done, further testing needed

Four faults found and fixed, three of them confirmed in play: the auras stop on
movement and on death and no longer disconnect the caster, fear makes monsters
flee, and befriend turns them to your side without them rounding on you.

Everything else is verified as *wired* -- every spell type she can cast reaches
a live path -- but has not been fired in anger, because the rest needs combat
and other targets to mean anything. Picked up when there is a group to test
with.

---

## She could not be trained

Found on 4 September, sweeping trainers across all sixty-two classes.

Every Albion class and every Midgard class has a trainer at home. Every
Hibernia class has between five and nine, across Hibernia, the Shrouded Isles
and Tir na Nog. **The Bainshee had none.** Her only three stood in Atlantis and
on Agramon, and all three are ours -- upstream OpenDAoC placed no Bainshee
trainer anywhere.

She was the only class in the game in that state.

This matters more than the count suggests, because of when it was found. The
audit above went through every spell line, every realm ability, her champion
and master level entries, her auras, her fear and her befriend, and it was
called complete. Not one of those checks asks whether a level five Bainshee can
spend a specialisation point. **Skills were treated as the whole of a class,
and they are not.**

Migration 115 places nine more, beside the Vampiir trainers -- the other
Hibernia class from the same expansion, so the same halls -- using nine of the
twelve real Bainshee trainer names that were already sitting unused in
`npctemplate`. Twelve total, which is Vampiir parity.

The coordinates are ours, not live's.

## What is left to test

Everything below is wired. What remains is whether it feels right.

1. **Fear**, on something at or below the level cap -- `Spell.Value` is a
   maximum level, not a strength. Vanquishing Screech reaches 27; the six run
   15, 27, 34, 44, 54, 65.
2. **Befriend**, and whether the monster fights for you and reverts cleanly.
3. **A Spectral Guard cone** -- 23 spells and none has been fired in anger.
4. Whether the **ramp and damage** of the auras feel right at her level.
5. The **taunts** and the **group ablative**, neither of which has been used.
6. **Training her at home** -- nine new trainers, none of them yet visited.

`bainshee_log` narrates the auras, the channels, the fear and the befriend.
