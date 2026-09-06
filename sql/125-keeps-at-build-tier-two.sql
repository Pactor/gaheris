-- New Frontiers keeps one build tier lower, to test the white attachments.
--
-- NOT a settled change. This is an experiment with a single variable, written
-- as a migration so it can be applied and reverted cleanly. If the attachments
-- still render white at height 2, revert to 121 and the answer is elsewhere.
--
-- What it is testing. Migration 121 raised these keeps from Level 4 to Level
-- 10, which moved them from build tier 1 to build tier 3 and fixed the white
-- keeps. Three tiers are reachable:
--
--     Level 8-10 -> height 3        Level 5-7 -> height 2
--     Level 2-4  -> height 1
--
-- At tier 1 the whole keep was untextured. At tier 3 the stonework is right
-- and what remains white are the overhanging structures along the battlements
-- -- the hoardings a keep gains as it is built up. The client appears to have
-- art for the keep body and not for the tier-3 additions.
--
-- Tier 2 is the only untested point between them.
--
-- What it costs if kept. Keep guards take their level from the keep:
--
--     guard.Level = GetBaseLevel(guard) + (keep.Level * multiplier)
--
-- so at keep_guard_level_multiplier 1.6 the keep guards drop from 66 to 61,
-- and tower guards from 60 to 57 at multiplier 1.0. Keeps are also slightly
-- less tough. Neither matters much on a co-operative server, but it is the
-- trade being made and it should not be discovered later.
--
-- Region 163 only, as 121 was. Battleground keeps keep their bracket levels.

UPDATE keep
   SET Level = 7
 WHERE Region = 163;
