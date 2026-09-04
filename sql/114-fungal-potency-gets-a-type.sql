-- The Animist's Fungal Potency had no spell type and no target.
--
-- Creeping Path, level 29, spell 150000. It came in through our own spell
-- sweep (migration 90) with `Type` and `Target` both empty, so it had no
-- handler and nothing to aim at. It has never done anything.
--
-- It is genuine content, not one of ours. Patch 1.88 gave the Animist "a new
-- ability in their Creeping baseline at level 29 called Fungal Potency... only
-- usable in PVE zones, has a 2 second cast time, is non-interruptible and
-- castable while on the move... a 350 radius pet cast ability that reduces
-- resists against high level monsters."
--
-- Every value the row does carry matches that note exactly -- cast time 2,
-- MoveCast 1, Uninterruptible 1, range 2000, radius 350, value 15, level 29.
-- Only the two columns that were blank in the reference were blank here, which
-- is why the sweep imported it faithfully and still left it inert.
--
-- Target becomes Pet: it is cast on the pet at 2000 range and spreads 350 from
-- there.
--
-- Type becomes BodyResistDebuff, and that needs explaining. A script cannot
-- add a value to the core's eSpellType, so the behaviour has to hang off a
-- type that already exists, and BodyResistDebuff is at least honest about what
-- the spell does. scripts/classes/shrouded-isles/FungalPotency.cs takes over
-- that type and enters its own path only for a spell aimed at a PET with a
-- radius -- a shape no resist debuff in this database uses, checked against
-- all nine of them, none of which targets a pet at all. Every ordinary resist
-- debuff still runs the core's handler untouched.
--
-- The obvious alternative was resist pierce, and it would have been wrong.
-- eProperty.ResistPierce is applied, but only against the victim's ItemBonus,
-- and a monster has no items. On the only targets this spell is permitted it
-- would have done nothing at all while looking perfectly correct here.

UPDATE spell
   SET Type = 'BodyResistDebuff',
       Target = 'Pet'
 WHERE SpellID = 150000
   AND Name = 'Fungal Potency';
