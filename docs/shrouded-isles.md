# The Shrouded Isles classes

Shrouded Isles, November 2002 -- the first expansion, and a **different six**
from the Catacombs five: Necromancer and Reaver in Albion, Savage and
Bonedancer in Midgard, Valewalker and Animist in Hibernia, plus the Flexible,
Scythe and Hand-to-Hand weapon lines.

Swept 5 September 2026 against the running server, using the checks that found
every fault in the Catacombs classes.

---

## The result: they are mechanically sound

**One gap across all six**, and it is a single spell.

| Check | Result |
|---|---|
| Spell types **deliverable** (not merely present) | **45 of 45** |
| Class type vs how its spell specs are marked | all six consistent |
| Realm abilities instantiating | **186 of 186** |
| Realm abilities on dead events | **none** |
| Champion trees: right realm, right count | all six correct |
| Blank spell types | one, below |

That is a real result rather than an absence of effort. The same sweep found
Fear and Befriend dead on the Bainshee, Disarm and Silence dead on the Mauler,
and Odin's Will mismarked on the Valkyrie.

### Why they survived when the Catacombs classes did not

Nothing in these six parks its behaviour in `OnEffectStart(GameSpellEffect)`,
the legacy callback the ECS rewrite stopped reaching. Their spells are damage,
pets, buffs and debuffs -- the paths that were migrated. The classes that broke
were the ones doing something unusual enough to need a custom effect:
attaching a brain, cancelling a pulse, returning power from a blow.

### The hybrid marking, checked because of the Valkyrie

| Class | Declares | Its spell specs |
|---|---|---|
| Reaver | Hybrid | Soulrending marked hybrid |
| Savage | PureTank (from ClassViking) | Savagery marked hybrid |
| Necromancer | ListCaster (from ClassDisciple) | unmarked, correct for a list caster |
| Bonedancer | ListCaster | unmarked |
| Animist | ListCaster | unmarked |
| Valewalker | ListCaster (from ClassForester) | unmarked |

All six agree with themselves. The Valkyrie's fault -- a Hybrid class with an
unmarked line -- appears nowhere here.

---

## The one gap: the Animist's Fungal Potency

`Creeping Path`, level 29, spell **150000**. It has **no `Type` and no
`Target`**, so it has no handler and no way to choose a target: it does
nothing at all.

I first recorded this as probably invented, on the strength of its round spell
id and its "(Only usable in PVE)" wording. **That was wrong.** It is real, and
was added in **patch 1.88**:

> Animists receive a new ability in their Creeping baseline at level 29 called
> Fungal Potency. It is only usable in PVE zones, has a 2 second cast time, is
> non-interruptible and castable while on the move. The effect is a 350 radius
> pet cast ability that reduces resists against high level monsters.

Our import is faithful everywhere it has a value: `CastTime 2`, `MoveCast 1`,
`Uninterruptible 1`, `Range 2000`, `Radius 350`, `Value 15`, level 29 of the
Creeping baseline. Only the two columns that were blank in the reference are
blank here.

**Not fixed, and not by a Type guess.** Nothing in `eSpellType` matches it. The
resist types are all per damage type -- Body, Cold, Crush, Energy, Heat,
Matter, Slash, Spirit, Thrust -- and this reduces resists generally, in a
radius around the caster's pet, against monsters only. Giving it the nearest
wrong type would make it do something wrong, which is worse than doing nothing
visibly. It wants a handler written, as Severing the Tether did.

---

## What each class still needs from play

Nothing here is known broken, so what follows is behaviour rather than wiring.

**Necromancer** -- the shade and pet mechanic is the most structural thing in
the six and none of it is spell data, so this sweep says nothing about it. Most
worth an hour of play.

**Reaver** -- Soulrending's 22 spells pulse. Every pulsing line so far has had
something wrong with it, and his are the only ones in these six that were not
checked for stop-on-movement, because there is no source saying they should.

**Bonedancer** -- the largest, 345 spells, with pulsing bladeturns and snares.
His sub-pets are the thing to watch.

**Savage** -- self-buffs bought with health. The cost is data, not a handler,
so it needs feeling rather than auditing.

**Animist** -- turrets, and Fungal Potency doing nothing at 29.

**Valewalker** -- scythe and no armour, neither of which is spell data.
