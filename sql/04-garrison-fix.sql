-- ===========================================================================
--  gaheris-garrison-fix.sql
--
--  Three faults found while testing keep lords.
--
--  Needs the updated MonsterGarrison.cs, which sets guard levels itself --
--  core cannot, because GameKeepGuard.SetLevel is gated on a Component our
--  guards do not have.
--
--  Safe to re-run.
-- ===========================================================================

SET NAMES utf8mb4;
SET SESSION sql_mode='';

-- ---------------------------------------------------------------------------
-- 1. Guards that still belong to a realm
-- ---------------------------------------------------------------------------
-- Converting the keeps set the KEEP's realm to none, but left the realm on the
-- guard rows themselves. 172 guards and 8 of the 21 lords were still Albion,
-- Midgard or Hibernian -- including Chieftain Ailinne at Dun Ailinne.
--
-- This is not cosmetic. Under PvE rules an attack is refused when both sides
-- have a realm, so a Hibernian player simply could not attack a Hibernian
-- lord: the keep was unfinishable, with nothing on screen to say why.

UPDATE `mob` SET `Realm` = 0
WHERE `ClassType` LIKE 'DOL.GS.Scripts.Monster%';

-- ---------------------------------------------------------------------------
-- 2. Relic keeps have no lord at all
-- ---------------------------------------------------------------------------
-- 21 lords for 27 keeps. The six without one are exactly the six relic keeps,
-- which have never had a lord row in this database.
--
-- Placed at the keep's own coordinates: the one position the keep table
-- guarantees is valid for that keep. Name and model are overwritten at load
-- by MonsterGuardLord, so only the position and class here matter.

DELETE FROM `mob` WHERE `PackageID` = 'GaherisRelicLords';

INSERT INTO `mob`
 (`Mob_ID`,`Name`,`Guild`,`ClassType`,`X`,`Y`,`Z`,`Heading`,`Region`,`Model`,`Size`,`Level`,`Realm`,
  `Flags`,`AggroLevel`,`AggroRange`,`RespawnInterval`,`PackageID`,`NPCTemplateID`,
  `Speed`,`Strength`,`Constitution`,`Dexterity`,`Quickness`,`Intelligence`,`Piety`,`Empathy`,`Charisma`,
  `OwnerID`,`VisibleWeaponSlots`,`HouseNumber`)
SELECT
  CONCAT('gaheris_lord_', k.`KeepID`),
  'dread lord', '', 'DOL.GS.Scripts.MonsterGuardLord',
  k.`X`, k.`Y`, k.`Z`, k.`Heading`, k.`Region`, 605, 55, 70, 0,
  0, 99, 1000, 1800000, 'GaherisRelicLords', -1,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
FROM `keep` k
WHERE k.`KeepID` IN (57, 58, 82, 198, 110, 111);

-- ---------------------------------------------------------------------------
-- 3. Stray keep staff left standing at evil keeps
-- ---------------------------------------------------------------------------
-- Merchants, hasteners and corpse summoners belong to a keep somebody holds.
-- One was still trading at Dun Lamfhota.
--
-- The corpse summoners are worth removing on their own account: that class
-- dereferences Component.Keep.Level with no null guard, which is what took
-- down world init earlier in this build.

DELETE m FROM `mob` m
JOIN `keep` k ON k.`Region` = m.`Region`
             AND SQRT(POW(m.`X` - k.`X`, 2) + POW(m.`Y` - k.`Y`, 2)) < 4000
WHERE k.`Realm` = 0
  AND k.`KeepID` BETWEEN 50 AND 200
  AND m.`ClassType` IN ('DOL.GS.Keeps.GuardMerchant',
                        'DOL.GS.Keeps.FrontierHastener',
                        'DOL.GS.Keeps.GuardCorpseSummoner',
                        'DOL.GS.GameHastener');

-- ---------------------------------------------------------------------------
-- Check
-- ---------------------------------------------------------------------------
SELECT 'guards still holding a realm' AS check_name, COUNT(*) AS n
  FROM `mob` WHERE `ClassType` LIKE 'DOL.GS.Scripts.Monster%' AND `Realm` <> 0
UNION ALL
SELECT 'lords', COUNT(*) FROM `mob` WHERE `ClassType` = 'DOL.GS.Scripts.MonsterGuardLord'
UNION ALL
SELECT 'keep staff left at evil keeps', COUNT(*) FROM `mob`
  WHERE `Region` IN (1,100,200)
    AND `ClassType` IN ('DOL.GS.Keeps.GuardMerchant','DOL.GS.Keeps.GuardCorpseSummoner');

-- Teardown for the added lords only:
-- DELETE FROM `mob` WHERE `PackageID` = 'GaherisRelicLords';
