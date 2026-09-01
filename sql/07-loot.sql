-- ===========================================================================
--  gaheris-loot.sql
--
--  Seals and gear.
--
--  Needs GaherisLoot.cs in the scripts directory.
--  Read at boot: needs a restart. Safe to re-run.
-- ===========================================================================

SET NAMES utf8mb4;
SET SESSION sql_mode='';

-- ---------------------------------------------------------------------------
-- 1. Kills by the group count
-- ---------------------------------------------------------------------------
-- Every core loot generator credits an NPC's kill to a player only when that
-- NPC is a pet. Hired companions are deliberately not pets, so a kill they
-- finished produced NO loot at all -- not less, none -- and they do most of the
-- killing. These subclasses hand the employer to core in the hire's place.

UPDATE `lootgenerator` SET `LootGeneratorClass` = 'DOL.GS.Scripts.GaherisLootTemplate'
 WHERE `LootGeneratorClass` = 'DOL.GS.LootGeneratorTemplate';

UPDATE `lootgenerator` SET `LootGeneratorClass` = 'DOL.GS.Scripts.GaherisLootRog'
 WHERE `LootGeneratorClass` = 'DOL.GS.ROGMobGenerator';

UPDATE `lootgenerator` SET `LootGeneratorClass` = 'DOL.GS.Scripts.GaherisLootMoney'
 WHERE `LootGeneratorClass` = 'DOL.GS.LootGeneratorMoney';

-- ---------------------------------------------------------------------------
-- 2. Seals drop everywhere, not only in the frontier
-- ---------------------------------------------------------------------------
-- The seal generator was registered against regions 1, 100, 200, 245 and 249 --
-- the three frontiers and Darkness Falls. Nothing killed while levelling could
-- ever drop one, whatever the rates said.
--
-- LootMgr.RegisterLootGenerator treats a RegionID of 0 as global, so one row
-- replaces the five. The mob level floor still applies, so this does not put
-- seals on starter rats.

DELETE FROM `lootgenerator` WHERE `LootGeneratorClass` = 'DOL.GS.Scripts.LootGeneratorGaherisSeals';

INSERT INTO `lootgenerator` (`LootGenerator_ID`, `LootGeneratorClass`, `ExclusivePriority`,
                             `MobName`, `MobGuild`, `MobFaction`, `RegionID`)
VALUES (UUID(), 'DOL.GS.Scripts.LootGeneratorGaherisSeals', 0, NULL, NULL, NULL, 0);

-- ---------------------------------------------------------------------------
-- 3. Enough seals to gear a group, not a character
-- ---------------------------------------------------------------------------
-- Chance is out of 10000: base, plus per-level above the floor. Dropping the
-- floor to 15 means a level 21 character killing level 20+ mobs is earning
-- them, rather than waiting until 25.

UPDATE `serverproperty` SET `Value` = '1500' WHERE `Key` = 'lootgenerator_dreadedseals_base_chance';
UPDATE `serverproperty` SET `Value` = '150'  WHERE `Key` = 'lootgenerator_dreadedseals_drop_chance_per_level';
UPDATE `serverproperty` SET `Value` = '15'   WHERE `Key` = 'lootgenerator_dreadedseals_starting_level';

-- ---------------------------------------------------------------------------
-- Check
-- ---------------------------------------------------------------------------
SELECT `LootGeneratorClass`, `RegionID` FROM `lootgenerator` ORDER BY `LootGeneratorClass`;

SELECT `Key`, `Value` FROM `serverproperty`
 WHERE `Key` LIKE 'lootgenerator_dreadedseals%';
