-- ===========================================================================
--  23-volcanus-model-fixes.sql
--
--  Four models in Deep Volcanus were wrong, and wrong in a particular way
--  worth recording: they were chosen by matching a creature's name against
--  names already in the world, and the match landed on an OUTLIER instead of
--  the model's real identity.
--
--      Flame of Volcanus   456   matched a single mob called "Flame"
--      Typhon's Essence    456   -- but model 456 is 417 WYVERNS
--      Battlewarder        666   matched "chrysiron statue" x18
--                                -- but model 666 is 1086 "storm effects",
--                                   which is to say it is INVISIBLE
--
--  So the flames were wyverns and the Battlewarder could not be seen at all.
--
--  The fix uses the model that the MAJORITY of a family uses rather than any
--  single name match:
--
--      125   Magma Elemental / magmatasm   -- an actual magma elemental
--      951   basalt golem                  -- a construct you can see
--      993   atevo statue (248 in world)   -- reliably a statue, where 1203
--                                             palios statue is used 9 times
--
--  Read at boot: needs a restart. Safe to re-run.
-- ===========================================================================

SET NAMES utf8mb4;
SET SESSION sql_mode='';

-- Fire that is fire, not a wyvern.
UPDATE `mob` SET `Model` = 125
 WHERE `PackageID` = 'gaheris-volcanus'
   AND `Name` IN ('Flame of Volcanus', 'Typhon''s Essence');

-- A warded construct you can actually see.
UPDATE `mob` SET `Model` = 951
 WHERE `PackageID` = 'gaheris-volcanus' AND `Name` = 'Battlewarder';

-- Statues that read as statues.
UPDATE `mob` SET `Model` = 993
 WHERE `PackageID` = 'gaheris-volcanus'
   AND `Name` IN ('shaitan idol', 'Balance of the Four');

-- ---------------------------------------------------------------------------
-- Check
-- ---------------------------------------------------------------------------
SELECT `Name`, `Model`, `Level`, COUNT(*) AS n FROM `mob`
 WHERE `PackageID` = 'gaheris-volcanus'
   AND `Name` IN ('Flame of Volcanus', 'Typhon''s Essence', 'Battlewarder',
                  'shaitan idol', 'Balance of the Four')
 GROUP BY `Name`, `Model`, `Level` ORDER BY `Name`;
