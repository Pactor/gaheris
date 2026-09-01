-- ===========================================================================
--  gaheris-mercenaries.sql
--
--  The mercenary company: a recruiter to hire from, and the seal collectors
--  repointed so a turn-in credits the company's realm points too.
--
--  Needs Mercenaries.cs in the scripts directory.
--  Safe to re-run.
-- ===========================================================================

SET NAMES utf8mb4;
SET SESSION sql_mode='';

-- ---------------------------------------------------------------------------
-- The recruiter
-- ---------------------------------------------------------------------------
-- Beside the Dread Quartermaster and Relena in Tir na Nog, so hiring, gearing
-- and seal turn-in are all one stop.

DELETE FROM `mob` WHERE `Mob_ID`='gaheris_recruiter';
INSERT INTO `mob`
 (`Mob_ID`,`Name`,`Guild`,`ClassType`,`X`,`Y`,`Z`,`Heading`,`Region`,`Model`,`Size`,`Level`,`Realm`,
  `Flags`,`AggroLevel`,`AggroRange`,`RespawnInterval`,`PackageID`,
  `Speed`,`Strength`,`Constitution`,`Dexterity`,`Quickness`,`Intelligence`,`Piety`,`Empathy`,`Charisma`,
  `OwnerID`,`VisibleWeaponSlots`,`HouseNumber`)
 VALUES
 ('gaheris_recruiter','Mercenary Recruiter','Free Companies','DOL.GS.Scripts.MercenaryRecruiter',
  32330,33110,7998,2150,201,334,52,50,3,
  16,0,0,0,'GaherisMercs',
  0,0,0,0,0,0,0,0,0, 0,0,0);

-- ---------------------------------------------------------------------------
-- Seal collectors credit the company
-- ---------------------------------------------------------------------------
-- GaherisSealCollector extends the stock DreadedSealCollector: it measures the
-- realm points the turn-in awarded and grants the same amount to the company,
-- which is what raises their tier.

UPDATE `mob` SET `ClassType`='DOL.GS.Scripts.GaherisSealCollector'
WHERE `ClassType`='DOL.GS.DreadedSealCollector';

-- Teardown:
-- DELETE FROM `mob` WHERE `Mob_ID`='gaheris_recruiter';
-- UPDATE `mob` SET `ClassType`='DOL.GS.DreadedSealCollector'
--  WHERE `ClassType`='DOL.GS.Scripts.GaherisSealCollector';
