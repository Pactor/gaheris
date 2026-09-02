-- ===========================================================================
--  20-molvik-garrison.sql
--
--  Molvik pitched for the band it is registered in.
--
--  Its garrison ran 34-41 with the bulk at 41, in a 40-44 battleground -- so
--  most of the zone was grey to anyone at the top of the band it was meant
--  for. Three levels puts the ceiling on the band's ceiling: 37-44, with
--  Renegade Chieftain Molvik above it at 51, which is what a battleground
--  boss should be.
--
--  The floor stays a little under the band, and that is deliberate. What the
--  band controls is who may ENTER; a level 40 walking in and finding things a
--  few levels below them is a zone with a shallow end, not a broken one.
--
--  ---------------------------------------------------------------------------
--  Also fixed here, and worth reading before you run it
--  ---------------------------------------------------------------------------
--  Molvik Faste was defended by THIRTEEN LEVEL 1 GUARDS. Nine GuardFighters
--  and four GuardHealers, all named "new mob" -- placeholder rows that were
--  never levelled. A level 1 guard on a level 40 keep is not a defence, it is
--  a free kill and a broken-looking one.
--
--  They are levelled to the keep. This is a separate statement from the
--  garrison bump so it can be undone on its own if you would rather they
--  stayed as they were.
--
--  Read at boot: needs a restart. NOT safe to re-run -- the garrison bump is
--  relative, so running it twice adds six levels rather than three.
-- ===========================================================================

SET NAMES utf8mb4;
SET SESSION sql_mode='';

-- ---------------------------------------------------------------------------
-- 1. The garrison, three levels up
-- ---------------------------------------------------------------------------
-- Excludes the Gate Warden, which is level 70 and not part of the fight, and
-- the level 1 placeholders, which are dealt with separately below.

UPDATE `mob`
   SET `Level` = `Level` + 3
 WHERE `Region` = 241
   AND `Level` BETWEEN 20 AND 69
   AND `ClassType` <> 'DOL.GS.Scripts.GaherisTeleporter';

-- ---------------------------------------------------------------------------
-- 2. The keep itself
-- ---------------------------------------------------------------------------
-- Molvik Faste was BaseLevel 39, one under the band it now sits in.

UPDATE `keep` SET `BaseLevel` = 42 WHERE `KeepID` = 132 AND `Region` = 241;

-- ---------------------------------------------------------------------------
-- 3. The thirteen level 1 guards
-- ---------------------------------------------------------------------------

UPDATE `mob`
   SET `Level` = 42
 WHERE `Region` = 241
   AND `Level` < 20
   AND `ClassType` LIKE 'DOL.GS.Keeps.Guard%';

-- ---------------------------------------------------------------------------
-- Check
-- ---------------------------------------------------------------------------
SELECT MIN(`Level`) AS lo, MAX(`Level`) AS hi, COUNT(*) AS mobs
  FROM `mob`
 WHERE `Region` = 241 AND `ClassType` <> 'DOL.GS.Scripts.GaherisTeleporter';

SELECT `Level`, COUNT(*) FROM `mob`
 WHERE `Region` = 241 AND `ClassType` <> 'DOL.GS.Scripts.GaherisTeleporter'
 GROUP BY `Level` ORDER BY `Level`;

SELECT `KeepID`, `Name`, `BaseLevel` FROM `keep` WHERE `Region` = 241;
