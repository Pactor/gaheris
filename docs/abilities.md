# Abilities

Swept 4 September 2026, after the spell sweep. Spells were only ever half the
question: a class is also the abilities it is handed, and nobody had checked
those.

Two questions, asked of every ability in the game.

---

## Does the ability build at all?

Fifteen fail to instantiate at boot:

    Assassinate, Ethereal Bond, First Aid, Ignore Pain, Lifter, Long Wind,
    Reflex Attack, Remedy, Second Wind, Serenity, Shadow Strike,
    Speed of Sound, Toughness, Volcanic Pillar, Wild Minion

**All fifteen are harmless**, and it is worth being precise about why, because
the warning is alarming and means less than it looks.

Each names an `Implementation` like `DOL.GS.RealmAbilities.LifterAbility` --
New Frontiers classes that OpenDAoC retired. Their replacements live under
`AtlasOF_` and the retired files are still on disk renamed `X...Ability.cs`.
`SkillBase` cannot resolve the old name, warns, and falls back to a plain
`Ability`.

Fourteen of them are **granted to nobody** -- not through `specxability`, not
through `classxrealmability_atlas`. Dead rows.

The fifteenth, **Remedy**, is granted: `AssassinCareer` at spec level 50, so
every Infiltrator, Nightshade and Shadowblade has it. **It works anyway.** An
activated ability does not need its `Implementation` to resolve, because the
behaviour hangs off `[SkillHandlerAttribute(Abilities.Remedy)]` and is found by
key name at `CastingComponent.cs:481`. The fallback `Ability` carries that
perfectly well, and `RemedyEffect` is still consulted live in
`GameLiving.cs:810`.

This is the same shape as the `MasteryofConcentration` false alarm. A failed
`Implementation` is a real fault only for a **passive** ability, where the
class *is* the behaviour.

---

## Does anything act on the ability?

Ninety-two abilities are granted to a class through `specxability`. For
eighteen, the key name appeared nowhere in the server except the declaration of
its own constant.

Read one at a time, they fall into four groups.

### Already implemented, just not through the ability (3)

| Ability | Where it really lives |
|---|---|
| **Greatness** | `MaxConcentrationCalculator` -- `GetSpellLine("Perfecter") != null && MLLevel >= 4`, +20% concentration |
| **Prevent Flight** | the realm ability `AtlasOF_PreventFlight`, consulted in `WeaponAction.cs:149` |
| **Tireless** | the realm ability `AtlasOF_Tireless`, through `AtlasOF_RAEndRegenEnhancer` |

The class-ability rows for the last two are legacy duplicates; on live both are
realm abilities and nothing else. Leaving them inert is correct. Implementing
them would hand every character a second helping of something they already have
by another route -- and Tireless's own description says it does not stack with
any other form of endurance regeneration.

Greatness is the useful one to notice: it proves the Master Level passives are
*meant* to be implemented in code keyed off the ML line, not off the ability. So
the ones below are oversights rather than decisions.

### Implemented and wrong (1)

**Enduring Poison** -- Spymaster ML3, "15% Chance poison won't be removed from
weapon on a resist". `GameLiving.cs:825`:

```csharp
if (Util.Chance((double)(15 * 0.0001))) return;
```

`Util.Chance(double)` compares against `NextDouble()`, so it takes a
probability in 0..1, not a percentage. `15 * 0.0001` is **0.0015, or 0.15%** --
one hundred times smaller than the 15% promised. It should be `0.15`.

Same shape as the Gift of Perizor bug: arithmetic that looks deliberate and is
off by a clean factor.

**This is in core, and this repo does not patch core**, so it is recorded here
rather than fixed. It is also minor: assassin poison charges run out slightly
sooner than they should.

### Fixed here (1)

**Pickpocket** -- Spymaster ML1, "20% Bonus to PvE Coin". Every class may walk
the Spymaster path, and on a co-operative server every coin is PvE coin, which
makes this worth more here than on live. It had no code anywhere.

`scripts/gaheris/Loot.cs` now applies it in `GaherisLootMoney`, which was
already the server's money generator. Core builds the coin as a fresh
`DbItemTemplate` per kill, so its price is raised in place. A hire's kill is
credited to the employer first, as with all the other loot, so the player's own
Pickpocket applies to the whole company's kills.

**Never tested.** Needs a character with Spymaster ML1 and a coin count.

### Genuinely dead (13)

| Ability | Granted to | What live says it does |
|---|---|---|
| **Snapshot** | Armsman, Crossbows 25 | draw and fire a crossbow shot while running, for 60 seconds |
| **Call of a thousand storms** | Thane 40 and 51, **Valkyrie 40** | 2 min self buff, 3 min recast, "increases the amount of attackers based off the level of monster being battled" |
| **Tracker's Alacrity** | Ranger 35 | *description is just its own name* |
| **Bloodrage** | Shadowblade 45 | +25% stealth speed for a minute after a killing blow on a realm enemy |
| **Turn Weapon** | Shadowblade 10 | *description is just its own name* |
| **Caltrops** | all three assassins, 35 | *description is just its own name* |
| **Danger Sense** | Stealth 8, ten classes | warns you and your party when scout mobs spot you |
| **Climbing** | Stealth 25, ten classes | use keep climb points |
| **Unburdened Warrior** | Sojourner ML1, every class | 25% bonus to encumbrance |
| **Siege Master** | Warlord ML1, every class | reduces all siege times by 30% |
| **Siege Resist** | pure tanks, 5 | *description is a copy of Siege Master's, so what it should do is unknown* |
| ~~**Sabotage**~~ | Spymaster ML4 | destroys a targeted ward or siege engine. **Never broken** -- its handler has a live `OnDirectEffect` |
| ~~**Lookout**~~ | Spymaster ML7 | exposes stealthers near a sitting watcher. **Was dead and is now fixed** -- see below |

Nothing was invented for any of these. Several cannot be written at all yet:

- **Three have no specification.** Tracker's Alacrity, Turn Weapon and Caltrops
  have descriptions that repeat their own names. Nothing in this server, in the
  old DOL server, or in any patch note to hand says what they do.
- **Call of a thousand storms appears nowhere** -- not in OpenDAoC, not in
  DOLSharp, not as a spell. Its description is also hard to read as a benefit.
  It is the only one of the thirteen that lands on a class this repo has already
  worked on, so it is flagged rather than buried: **the Valkyrie audit missed
  it**, and the Thane has never been looked at.
- **Unburdened Warrior needs a core change.** `MaxCarryingCapacity` is a
  non-virtual property on `GamePlayer` that consults exactly one ability,
  `AtlasOF_LifterAbility`. There is no property channel for a script to add to.

The rest are judgement calls that belong to the server owner, not to me:

- **Bloodrage** triggers on a killing blow against a realm enemy. There are no
  realm enemies here.
- **Climbing, Siege Master, Siege Resist, Sabotage** are siege and keep
  mechanics.
- **Danger Sense** needs a concept of a scout mob that this server does not have.
- **Snapshot** and **Danger Sense** are the two that would matter most in
  ordinary play, for the Armsman and for stealthers respectively.

---

## A loose end

The Spymaster line carries two Lookout rows: type `Loockout` in the `Spymaster`
line and type `Lookout` in `ML7 Spymaster`. Both spellings exist in the spell
type enum; **only `Loockout` has a handler**, in core and in
`scripts/progression/MasterLevelHolds.cs`. The reachable one is the handled one,
so the duplicate is clutter rather than a fault -- but it is the same
duplicate-line shape that made the Valkyrie cast the wrong spell, so it is
written down.

Note that "handled" was doing too much work in an earlier version of this line.
The core `Loockout` handler existed but put its whole body in the callback
nothing reaches, so the ability was dead in every sense until 5 September.

---

## What to test

1. **Pickpocket.** Spymaster ML1, then count coin against a character without it.
2. **Remedy** on an assassin at 50 -- believed to work, never seen to.

---

## Deliberately left alone

Checked again on 5 September, with their live behaviour confirmed, and **not**
implemented. Both need a change to core, and this repo does not patch core.

**Unburdened Warrior** (Sojourner ML1) -- live grants a bonus to encumbrance.
`MaxCarryingCapacity` is a non-virtual property on `GamePlayer` that consults
exactly one ability, `AtlasOF_LifterAbility`, and `GetAbility<T>` matches with
`GetType().Equals(typeof(T))` -- an exact type test, so even a subclass of
Lifter would not be found. There is no property channel and no override point.

**Siege Master** (Warlord ML1) -- reduces siege load, aim and fire times by 30%.
`GameSiegeWeapon.GetActionDelay` is non-virtual, and siege weapons are built by
core, so a script cannot reach it. It is siege-only in any case, which is worth
very little on a co-operative server.

**Sabotage was never broken.** Its handler has a live `OnDirectEffect`. The bare
ability row beside it is the visible entry, not the behaviour.

The four that *were* dead -- Lookout, Blanket of Camouflage, Battlewarder and
Focusing Winds -- are fixed, in `scripts/progression/MasterLevelHolds.cs`.
