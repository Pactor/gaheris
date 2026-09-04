# Power drawn from combat

`CombatPower.cs` -- the Vampiir (Catacombs) and all three Maulers (Labyrinth
of the Minotaur, 2006) pay for their power with violence rather than
regenerating it. One mechanic, one file, two expansions, which is why it is
not filed under either.

The core pays a Vampiir for landing a blow and nothing for taking one, and
pays the Maulers nothing at all while refusing them every other way of filling
the bar -- `RegenBuff`, `PowerHealSpellHandler` and the Perfecter power heal
all name the three of them and decline.

This grants both halves, on the core's own curve. `combat_power_rate` scales
it; 1.0 is exactly what the core pays a Vampiir for one landed blow.

It hangs off `GameObjectEvent.TakeDamage`, which fires once per landed blow
and names both ends of it, so a single handler pays the striker and the
victim. It used to use `AttackedByEnemy` and `AttackFinished`, neither of
which this server raises -- so it did nothing at all from the day it was
written until that was found. See `docs/dead-events.md`.
