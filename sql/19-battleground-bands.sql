-- ===========================================================================
--  19-battleground-bands.sql
--
--  Leirvik takes 45-49; Cathal Valley becomes the level 50 zone.
--
--  This is how live had it. Cathal Valley was never a levelling battleground
--  -- it was the endgame zone, level 50 only, and Leirvik was the last rung of
--  the ladder below it. Having Cathal Valley registered at 45-49 meant the
--  ladder ended one rung early and the endgame zone was doing a job it was
--  never built for.
--
--  Both zones already suit their new bands without any content change:
--
--      Leirvik         105 mobs, 39-52, savage koalinth at 45-48,
--                      wretched hagbui berserker at 46, four keeps
--      Cathal Valley   550 mobs, four keeps, and a garrison of level 255
--                      Master Guardians, Masters of Runes, Bowman Commanders
--                      and Master Eldritches -- which is a level 50 problem,
--                      not a level 45 one
--
--  Cathal Valley's realm rank cap is lifted to 99, which is to say removed.
--  The rungs below it are capped so a geared-up character cannot farm the low
--  bands; there is nothing above 50 to protect it from.
--
--  Read at boot: needs a restart. Safe to re-run.
-- ===========================================================================

SET NAMES utf8mb4;
SET SESSION sql_mode='';

DELETE FROM `battleground` WHERE `RegionID` IN (165, 242);

INSERT INTO `battleground`
  (`Battleground_ID`, `RegionID`, `MinLevel`, `MaxLevel`, `MaxRealmLevel`)
VALUES
  ('Leirvik (Level 45-49)',       242, 45, 49, 45),
  ('Cathal Valley (Level 50)',    165, 50, 50, 99);

-- ---------------------------------------------------------------------------
-- Check
-- ---------------------------------------------------------------------------
SELECT `RegionID`, `MinLevel`, `MaxLevel`, `MaxRealmLevel`, `Battleground_ID`
  FROM `battleground` ORDER BY `MinLevel`;
