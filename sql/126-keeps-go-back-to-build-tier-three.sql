-- Back to build tier three. The experiment in 125 is answered.
--
-- 125 dropped New Frontiers keeps from Level 10 to Level 7 to see whether the
-- white overhanging structures at tier 3 were geometry the client could not
-- texture. They were not. At tier 2 the entire keep went white again, exactly
-- as it had been at tier 1.
--
-- So all three reachable tiers are now known:
--
--     height 1  (Level 2-4)    every keep completely untextured
--     height 2  (Level 5-7)    every keep completely untextured
--     height 3  (Level 8-10)   keep body correct, hoardings untextured
--
-- Tier 3 is the only one that renders a keep at all, so it stands. The
-- remaining white pieces are the overhanging structures along the battlements,
-- and they are not a build-tier problem -- lowering the tier does not remove
-- them, it removes the keep.
--
-- Level 10 rather than 8 or 9 because it is the maximum the server allows,
-- max_keep_level is already 10, and AbstractGameKeep documents Level as 0-10.
-- All three give height 3, so the choice is about keep and guard strength
-- rather than appearance. Guards go back up with it: keep guards 61 to 66,
-- tower guards 57 to 60.
--
-- 125 is kept in the repository rather than deleted. It is the record of how
-- this was established, and re-running it is how the test would be repeated.

UPDATE keep
   SET Level = 10
 WHERE Region = 163;
