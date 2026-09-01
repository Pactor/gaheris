-- ===========================================================================
--  gaheris-gear-migrate.sql
--
--  Moves gear left with the old invented archetypes onto the real classes
--  that replaced them, so nothing a player handed over is stranded under a
--  name the roster no longer has.
--
--  This is only a convenience. The safety net is in the code: [recover] and
--  /mercgear sweep by owner-id PREFIX, so gear under ANY bucket -- including
--  ones nobody remembers -- is still found and can still be handed back.
--
--  Safe to re-run.
-- ===========================================================================

SET NAMES utf8mb4;
SET SESSION sql_mode='';

-- Before
SELECT 'before' AS stage, OwnerID, COUNT(*) AS pieces
FROM `inventory` WHERE `OwnerID` LIKE '%-merc-%' GROUP BY OwnerID;

-- Reaver and Warden survived the rename as real classes, so they are left
-- alone. These eight did not.
UPDATE `inventory` SET `OwnerID` = REPLACE(`OwnerID`, '-merc-guardian',   '-merc-hero')         WHERE `OwnerID` LIKE '%-merc-guardian';
UPDATE `inventory` SET `OwnerID` = REPLACE(`OwnerID`, '-merc-stalker',    '-merc-ranger')       WHERE `OwnerID` LIKE '%-merc-stalker';
UPDATE `inventory` SET `OwnerID` = REPLACE(`OwnerID`, '-merc-mender',     '-merc-druid')        WHERE `OwnerID` LIKE '%-merc-mender';
UPDATE `inventory` SET `OwnerID` = REPLACE(`OwnerID`, '-merc-adept',      '-merc-eldritch')     WHERE `OwnerID` LIKE '%-merc-adept';
UPDATE `inventory` SET `OwnerID` = REPLACE(`OwnerID`, '-merc-runecaster', '-merc-runemaster')   WHERE `OwnerID` LIKE '%-merc-runecaster';
UPDATE `inventory` SET `OwnerID` = REPLACE(`OwnerID`, '-merc-summoner',   '-merc-spiritmaster') WHERE `OwnerID` LIKE '%-merc-summoner';
UPDATE `inventory` SET `OwnerID` = REPLACE(`OwnerID`, '-merc-beguiler',   '-merc-sorcerer')     WHERE `OwnerID` LIKE '%-merc-beguiler';
UPDATE `inventory` SET `OwnerID` = REPLACE(`OwnerID`, '-merc-blighter',   '-merc-cabalist')     WHERE `OwnerID` LIKE '%-merc-blighter';

-- The old hire list named archetypes too. Clear it rather than translate it:
-- the classes are all different now, and re-hiring is one click. The GEAR is
-- what had to survive, and it just did.
DELETE FROM `dolcharactersxcustomparam` WHERE `KeyName` = 'GaherisMercRoster';

-- After
SELECT 'after' AS stage, OwnerID, COUNT(*) AS pieces
FROM `inventory` WHERE `OwnerID` LIKE '%-merc-%' GROUP BY OwnerID;

-- Nothing is ever deleted by this file. If a mapping above is wrong, the gear
-- is still in the database under some -merc- bucket, and [recover] finds it.
