-- Sojourner 7 hands out the same ability twice, and one of the two is broken.
--
-- Two rows sit at level 7 of the Sojourner line, both called Resistance of
-- the Ancients:
--
--   7328  EssenceResist  Realm   30s   Value 15   -- works
--   7278  (blank type)   Group  1200s  Value 0    -- has no handler at all
--
-- A spell with no Type gets no handler, so 7278 does nothing whatsoever. It is
-- reachable by every class in the game, because the Master Level lines are
-- shared, which makes it the most widely broken single spell in the database.
--
-- Removing it from the line rather than deleting the spell: the row costs
-- nothing where it sits, and something else may reference it.

DELETE FROM linexspell WHERE LineName = 'Sojourner' AND SpellID = 7278;

-- Reveal Crystalseed (7204, Sojourner 3) has the same blank-type fault and is
-- NOT fixed here. It has no working twin, and no spell type in the core's enum
-- matches "reveal all enemy runes around your ground target" -- UnmakeCrystalseed
-- destroys them rather than showing them. It needs a handler and an enum entry,
-- which means a core change rather than a migration. See docs/master-levels.md.
