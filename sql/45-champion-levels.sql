-- ===========================================================================
--  45-champion-levels.sql
--
--  Champion Levels, which have never worked here.
--
--  Three separate things were missing and any one of them alone was enough.
--
--  1. Nobody could become a Champion. GameKingThroneNpc is what sets
--     Champion = true -- you whisper "Champions" to it at level 50 -- and no
--     such NPC existed anywhere in the database. The three throne rooms,
--     regions 360, 394 and 395, held zero mobs between them.
--
--  2. There was nothing to train. The core implements fifteen champion
--     mini-line specialisations, one per base archetype per realm, and this
--     database held a single champion row: "Champion Level Albion". No mini
--     lines, no Midgard or Hibernia wrapper, and nothing joined to any class.
--
--  3. No champion experience from killing anything. That one is code, not
--     data -- GamePlayer.cs has "// GainChampionExperience(expTotal);"
--     commented out in the experience path -- and is handled in
--     GaherisChampionLevels.cs alongside this.
--
--  The sub-classing rule is the live one: a character may train any archetype
--  of its own realm except the archetype it came from. The official tables
--  say so by omission -- Cleric and Friar are barred from Acolyte, Nightshade
--  from Stalker -- and every class's archetype is its declared BaseName, so
--  the whole matrix follows from that rather than from a table typed out by
--  hand.
--
--  Nothing here is discovered by name. LiveChampionsSpecialization finds its
--  mini lines with "sp is LiveChampionsLineSpec", so what matters is the
--  Implementation column naming the right core class and a classxspecialization
--  row putting it in the career. The KeyNames below are ours.
--
--  Read at boot: needs a restart. Safe to re-run.
-- ===========================================================================

SET NAMES utf8mb4;
SET SESSION sql_mode='';

DELETE FROM `classxspecialization` WHERE `SpecKeyName` LIKE 'CL %';
DELETE FROM `specialization`       WHERE `KeyName`     LIKE 'CL %';
DELETE FROM `classxspecialization` WHERE `SpecKeyName` IN ('Champion Level Midgard','Champion Level Hibernia');
DELETE FROM `specialization`       WHERE `KeyName`     IN ('Champion Level Midgard','Champion Level Hibernia');


-- The realm wrappers. Albion already had one (SpecializationID 152).
INSERT INTO `specialization` (`Specialization_ID`, `KeyName`, `Name`, `Icon`, `Description`, `SpecializationID`, `Implementation`, `LastTimeRowUpdated`) VALUES
  (UUID(), 'Champion Level Midgard', 'Champion Abilities', 0, 'Champion Level Abilities and Skills.', 201, 'DOL.GS.LiveChampionsSpecialization', '2000-01-01 00:00:00');
INSERT INTO `specialization` (`Specialization_ID`, `KeyName`, `Name`, `Icon`, `Description`, `SpecializationID`, `Implementation`, `LastTimeRowUpdated`) VALUES
  (UUID(), 'Champion Level Hibernia', 'Champion Abilities', 0, 'Champion Level Abilities and Skills.', 202, 'DOL.GS.LiveChampionsSpecialization', '2000-01-01 00:00:00');

-- The fifteen mini lines, one per archetype per realm.
INSERT INTO `specialization` (`Specialization_ID`, `KeyName`, `Name`, `Icon`, `Description`, `SpecializationID`, `Implementation`, `LastTimeRowUpdated`) VALUES
  (UUID(), 'CL Albion Acolyte', 'Acolyte', 0, 'Champion training in the way of the Acolyte.', 203, 'DOL.GS.LiveCLAcolyteSpec', '2000-01-01 00:00:00');
INSERT INTO `specialization` (`Specialization_ID`, `KeyName`, `Name`, `Icon`, `Description`, `SpecializationID`, `Implementation`, `LastTimeRowUpdated`) VALUES
  (UUID(), 'CL Albion Disciple', 'Disciple', 0, 'Champion training in the way of the Disciple.', 204, 'DOL.GS.LiveCLDiscipleSpec', '2000-01-01 00:00:00');
INSERT INTO `specialization` (`Specialization_ID`, `KeyName`, `Name`, `Icon`, `Description`, `SpecializationID`, `Implementation`, `LastTimeRowUpdated`) VALUES
  (UUID(), 'CL Albion Elementalist', 'Elementalist', 0, 'Champion training in the way of the Elementalist.', 205, 'DOL.GS.LiveCLElementalistSpec', '2000-01-01 00:00:00');
INSERT INTO `specialization` (`Specialization_ID`, `KeyName`, `Name`, `Icon`, `Description`, `SpecializationID`, `Implementation`, `LastTimeRowUpdated`) VALUES
  (UUID(), 'CL Albion Fighter', 'Fighter', 0, 'Champion training in the way of the Fighter.', 206, 'DOL.GS.LiveCLFighterSpec', '2000-01-01 00:00:00');
INSERT INTO `specialization` (`Specialization_ID`, `KeyName`, `Name`, `Icon`, `Description`, `SpecializationID`, `Implementation`, `LastTimeRowUpdated`) VALUES
  (UUID(), 'CL Albion Mage', 'Mage', 0, 'Champion training in the way of the Mage.', 207, 'DOL.GS.LiveCLMageSpec', '2000-01-01 00:00:00');
INSERT INTO `specialization` (`Specialization_ID`, `KeyName`, `Name`, `Icon`, `Description`, `SpecializationID`, `Implementation`, `LastTimeRowUpdated`) VALUES
  (UUID(), 'CL Albion Rogue', 'Rogue', 0, 'Champion training in the way of the Rogue.', 208, 'DOL.GS.LiveCLAlbionRogueSpec', '2000-01-01 00:00:00');
INSERT INTO `specialization` (`Specialization_ID`, `KeyName`, `Name`, `Icon`, `Description`, `SpecializationID`, `Implementation`, `LastTimeRowUpdated`) VALUES
  (UUID(), 'CL Hibernia Forester', 'Forester', 0, 'Champion training in the way of the Forester.', 209, 'DOL.GS.LiveCLForesterSpec', '2000-01-01 00:00:00');
INSERT INTO `specialization` (`Specialization_ID`, `KeyName`, `Name`, `Icon`, `Description`, `SpecializationID`, `Implementation`, `LastTimeRowUpdated`) VALUES
  (UUID(), 'CL Hibernia Guardian', 'Guardian', 0, 'Champion training in the way of the Guardian.', 210, 'DOL.GS.LiveCLGuardianSpec', '2000-01-01 00:00:00');
INSERT INTO `specialization` (`Specialization_ID`, `KeyName`, `Name`, `Icon`, `Description`, `SpecializationID`, `Implementation`, `LastTimeRowUpdated`) VALUES
  (UUID(), 'CL Hibernia Magician', 'Magician', 0, 'Champion training in the way of the Magician.', 211, 'DOL.GS.LiveCLMagicianSpec', '2000-01-01 00:00:00');
INSERT INTO `specialization` (`Specialization_ID`, `KeyName`, `Name`, `Icon`, `Description`, `SpecializationID`, `Implementation`, `LastTimeRowUpdated`) VALUES
  (UUID(), 'CL Hibernia Naturalist', 'Naturalist', 0, 'Champion training in the way of the Naturalist.', 212, 'DOL.GS.LiveCLNaturalistSpec', '2000-01-01 00:00:00');
INSERT INTO `specialization` (`Specialization_ID`, `KeyName`, `Name`, `Icon`, `Description`, `SpecializationID`, `Implementation`, `LastTimeRowUpdated`) VALUES
  (UUID(), 'CL Hibernia Stalker', 'Stalker', 0, 'Champion training in the way of the Stalker.', 213, 'DOL.GS.LiveCLStalkerSpec', '2000-01-01 00:00:00');
INSERT INTO `specialization` (`Specialization_ID`, `KeyName`, `Name`, `Icon`, `Description`, `SpecializationID`, `Implementation`, `LastTimeRowUpdated`) VALUES
  (UUID(), 'CL Midgard Mystic', 'Mystic', 0, 'Champion training in the way of the Mystic.', 214, 'DOL.GS.LiveCLMysticSpec', '2000-01-01 00:00:00');
INSERT INTO `specialization` (`Specialization_ID`, `KeyName`, `Name`, `Icon`, `Description`, `SpecializationID`, `Implementation`, `LastTimeRowUpdated`) VALUES
  (UUID(), 'CL Midgard Rogue', 'Rogue', 0, 'Champion training in the way of the Rogue.', 215, 'DOL.GS.LiveCLMidgardRogueSpec', '2000-01-01 00:00:00');
INSERT INTO `specialization` (`Specialization_ID`, `KeyName`, `Name`, `Icon`, `Description`, `SpecializationID`, `Implementation`, `LastTimeRowUpdated`) VALUES
  (UUID(), 'CL Midgard Seer', 'Seer', 0, 'Champion training in the way of the Seer.', 216, 'DOL.GS.LiveCLSeerSpec', '2000-01-01 00:00:00');
INSERT INTO `specialization` (`Specialization_ID`, `KeyName`, `Name`, `Icon`, `Description`, `SpecializationID`, `Implementation`, `LastTimeRowUpdated`) VALUES
  (UUID(), 'CL Midgard Viking', 'Viking', 0, 'Champion training in the way of the Viking.', 217, 'DOL.GS.LiveCLVikingSpec', '2000-01-01 00:00:00');

-- Every class: the career, its realm wrapper, and every archetype of
-- its realm except its own.
DELETE FROM `classxspecialization` WHERE `SpecKeyName` = 'ChampionCareer';
INSERT INTO `classxspecialization` (`ClassID`, `SpecKeyName`, `LevelAcquired`, `LastTimeRowUpdated`) VALUES
  (1, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (1, 'Champion Level Albion', 50, '2000-01-01 00:00:00'),
  (1, 'CL Albion Acolyte', 50, '2000-01-01 00:00:00'),
  (1, 'CL Albion Disciple', 50, '2000-01-01 00:00:00'),
  (1, 'CL Albion Elementalist', 50, '2000-01-01 00:00:00'),
  (1, 'CL Albion Mage', 50, '2000-01-01 00:00:00'),
  (1, 'CL Albion Rogue', 50, '2000-01-01 00:00:00'),
  (2, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (2, 'Champion Level Albion', 50, '2000-01-01 00:00:00'),
  (2, 'CL Albion Acolyte', 50, '2000-01-01 00:00:00'),
  (2, 'CL Albion Disciple', 50, '2000-01-01 00:00:00'),
  (2, 'CL Albion Elementalist', 50, '2000-01-01 00:00:00'),
  (2, 'CL Albion Mage', 50, '2000-01-01 00:00:00'),
  (2, 'CL Albion Rogue', 50, '2000-01-01 00:00:00'),
  (3, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (3, 'Champion Level Albion', 50, '2000-01-01 00:00:00'),
  (3, 'CL Albion Acolyte', 50, '2000-01-01 00:00:00'),
  (3, 'CL Albion Disciple', 50, '2000-01-01 00:00:00'),
  (3, 'CL Albion Elementalist', 50, '2000-01-01 00:00:00'),
  (3, 'CL Albion Fighter', 50, '2000-01-01 00:00:00'),
  (3, 'CL Albion Mage', 50, '2000-01-01 00:00:00'),
  (4, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (4, 'Champion Level Albion', 50, '2000-01-01 00:00:00'),
  (4, 'CL Albion Acolyte', 50, '2000-01-01 00:00:00'),
  (4, 'CL Albion Disciple', 50, '2000-01-01 00:00:00'),
  (4, 'CL Albion Elementalist', 50, '2000-01-01 00:00:00'),
  (4, 'CL Albion Fighter', 50, '2000-01-01 00:00:00'),
  (4, 'CL Albion Mage', 50, '2000-01-01 00:00:00'),
  (5, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (5, 'Champion Level Albion', 50, '2000-01-01 00:00:00'),
  (5, 'CL Albion Acolyte', 50, '2000-01-01 00:00:00'),
  (5, 'CL Albion Disciple', 50, '2000-01-01 00:00:00'),
  (5, 'CL Albion Fighter', 50, '2000-01-01 00:00:00'),
  (5, 'CL Albion Mage', 50, '2000-01-01 00:00:00'),
  (5, 'CL Albion Rogue', 50, '2000-01-01 00:00:00'),
  (6, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (6, 'Champion Level Albion', 50, '2000-01-01 00:00:00'),
  (6, 'CL Albion Disciple', 50, '2000-01-01 00:00:00'),
  (6, 'CL Albion Elementalist', 50, '2000-01-01 00:00:00'),
  (6, 'CL Albion Fighter', 50, '2000-01-01 00:00:00'),
  (6, 'CL Albion Mage', 50, '2000-01-01 00:00:00'),
  (6, 'CL Albion Rogue', 50, '2000-01-01 00:00:00'),
  (7, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (7, 'Champion Level Albion', 50, '2000-01-01 00:00:00'),
  (7, 'CL Albion Acolyte', 50, '2000-01-01 00:00:00'),
  (7, 'CL Albion Disciple', 50, '2000-01-01 00:00:00'),
  (7, 'CL Albion Fighter', 50, '2000-01-01 00:00:00'),
  (7, 'CL Albion Mage', 50, '2000-01-01 00:00:00'),
  (7, 'CL Albion Rogue', 50, '2000-01-01 00:00:00'),
  (8, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (8, 'Champion Level Albion', 50, '2000-01-01 00:00:00'),
  (8, 'CL Albion Acolyte', 50, '2000-01-01 00:00:00'),
  (8, 'CL Albion Disciple', 50, '2000-01-01 00:00:00'),
  (8, 'CL Albion Elementalist', 50, '2000-01-01 00:00:00'),
  (8, 'CL Albion Fighter', 50, '2000-01-01 00:00:00'),
  (8, 'CL Albion Rogue', 50, '2000-01-01 00:00:00'),
  (9, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (9, 'Champion Level Albion', 50, '2000-01-01 00:00:00'),
  (9, 'CL Albion Acolyte', 50, '2000-01-01 00:00:00'),
  (9, 'CL Albion Disciple', 50, '2000-01-01 00:00:00'),
  (9, 'CL Albion Elementalist', 50, '2000-01-01 00:00:00'),
  (9, 'CL Albion Fighter', 50, '2000-01-01 00:00:00'),
  (9, 'CL Albion Mage', 50, '2000-01-01 00:00:00'),
  (10, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (10, 'Champion Level Albion', 50, '2000-01-01 00:00:00'),
  (10, 'CL Albion Disciple', 50, '2000-01-01 00:00:00'),
  (10, 'CL Albion Elementalist', 50, '2000-01-01 00:00:00'),
  (10, 'CL Albion Fighter', 50, '2000-01-01 00:00:00'),
  (10, 'CL Albion Mage', 50, '2000-01-01 00:00:00'),
  (10, 'CL Albion Rogue', 50, '2000-01-01 00:00:00'),
  (11, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (11, 'Champion Level Albion', 50, '2000-01-01 00:00:00'),
  (11, 'CL Albion Acolyte', 50, '2000-01-01 00:00:00'),
  (11, 'CL Albion Disciple', 50, '2000-01-01 00:00:00'),
  (11, 'CL Albion Elementalist', 50, '2000-01-01 00:00:00'),
  (11, 'CL Albion Mage', 50, '2000-01-01 00:00:00'),
  (11, 'CL Albion Rogue', 50, '2000-01-01 00:00:00'),
  (12, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (12, 'Champion Level Albion', 50, '2000-01-01 00:00:00'),
  (12, 'CL Albion Acolyte', 50, '2000-01-01 00:00:00'),
  (12, 'CL Albion Elementalist', 50, '2000-01-01 00:00:00'),
  (12, 'CL Albion Fighter', 50, '2000-01-01 00:00:00'),
  (12, 'CL Albion Mage', 50, '2000-01-01 00:00:00'),
  (12, 'CL Albion Rogue', 50, '2000-01-01 00:00:00'),
  (13, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (13, 'Champion Level Albion', 50, '2000-01-01 00:00:00'),
  (13, 'CL Albion Acolyte', 50, '2000-01-01 00:00:00'),
  (13, 'CL Albion Disciple', 50, '2000-01-01 00:00:00'),
  (13, 'CL Albion Elementalist', 50, '2000-01-01 00:00:00'),
  (13, 'CL Albion Fighter', 50, '2000-01-01 00:00:00'),
  (13, 'CL Albion Rogue', 50, '2000-01-01 00:00:00'),
  (19, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (19, 'Champion Level Albion', 50, '2000-01-01 00:00:00'),
  (19, 'CL Albion Acolyte', 50, '2000-01-01 00:00:00'),
  (19, 'CL Albion Disciple', 50, '2000-01-01 00:00:00'),
  (19, 'CL Albion Elementalist', 50, '2000-01-01 00:00:00'),
  (19, 'CL Albion Mage', 50, '2000-01-01 00:00:00'),
  (19, 'CL Albion Rogue', 50, '2000-01-01 00:00:00'),
  (21, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (21, 'Champion Level Midgard', 50, '2000-01-01 00:00:00'),
  (21, 'CL Midgard Mystic', 50, '2000-01-01 00:00:00'),
  (21, 'CL Midgard Rogue', 50, '2000-01-01 00:00:00'),
  (21, 'CL Midgard Seer', 50, '2000-01-01 00:00:00'),
  (22, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (22, 'Champion Level Midgard', 50, '2000-01-01 00:00:00'),
  (22, 'CL Midgard Mystic', 50, '2000-01-01 00:00:00'),
  (22, 'CL Midgard Rogue', 50, '2000-01-01 00:00:00'),
  (22, 'CL Midgard Seer', 50, '2000-01-01 00:00:00'),
  (23, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (23, 'Champion Level Midgard', 50, '2000-01-01 00:00:00'),
  (23, 'CL Midgard Mystic', 50, '2000-01-01 00:00:00'),
  (23, 'CL Midgard Seer', 50, '2000-01-01 00:00:00'),
  (23, 'CL Midgard Viking', 50, '2000-01-01 00:00:00'),
  (24, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (24, 'Champion Level Midgard', 50, '2000-01-01 00:00:00'),
  (24, 'CL Midgard Mystic', 50, '2000-01-01 00:00:00'),
  (24, 'CL Midgard Rogue', 50, '2000-01-01 00:00:00'),
  (24, 'CL Midgard Seer', 50, '2000-01-01 00:00:00'),
  (25, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (25, 'Champion Level Midgard', 50, '2000-01-01 00:00:00'),
  (25, 'CL Midgard Mystic', 50, '2000-01-01 00:00:00'),
  (25, 'CL Midgard Seer', 50, '2000-01-01 00:00:00'),
  (25, 'CL Midgard Viking', 50, '2000-01-01 00:00:00'),
  (26, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (26, 'Champion Level Midgard', 50, '2000-01-01 00:00:00'),
  (26, 'CL Midgard Mystic', 50, '2000-01-01 00:00:00'),
  (26, 'CL Midgard Rogue', 50, '2000-01-01 00:00:00'),
  (26, 'CL Midgard Viking', 50, '2000-01-01 00:00:00'),
  (27, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (27, 'Champion Level Midgard', 50, '2000-01-01 00:00:00'),
  (27, 'CL Midgard Rogue', 50, '2000-01-01 00:00:00'),
  (27, 'CL Midgard Seer', 50, '2000-01-01 00:00:00'),
  (27, 'CL Midgard Viking', 50, '2000-01-01 00:00:00'),
  (28, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (28, 'Champion Level Midgard', 50, '2000-01-01 00:00:00'),
  (28, 'CL Midgard Mystic', 50, '2000-01-01 00:00:00'),
  (28, 'CL Midgard Rogue', 50, '2000-01-01 00:00:00'),
  (28, 'CL Midgard Viking', 50, '2000-01-01 00:00:00'),
  (29, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (29, 'Champion Level Midgard', 50, '2000-01-01 00:00:00'),
  (29, 'CL Midgard Rogue', 50, '2000-01-01 00:00:00'),
  (29, 'CL Midgard Seer', 50, '2000-01-01 00:00:00'),
  (29, 'CL Midgard Viking', 50, '2000-01-01 00:00:00'),
  (30, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (30, 'Champion Level Midgard', 50, '2000-01-01 00:00:00'),
  (30, 'CL Midgard Rogue', 50, '2000-01-01 00:00:00'),
  (30, 'CL Midgard Seer', 50, '2000-01-01 00:00:00'),
  (30, 'CL Midgard Viking', 50, '2000-01-01 00:00:00'),
  (31, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (31, 'Champion Level Midgard', 50, '2000-01-01 00:00:00'),
  (31, 'CL Midgard Mystic', 50, '2000-01-01 00:00:00'),
  (31, 'CL Midgard Rogue', 50, '2000-01-01 00:00:00'),
  (31, 'CL Midgard Seer', 50, '2000-01-01 00:00:00'),
  (32, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (32, 'Champion Level Midgard', 50, '2000-01-01 00:00:00'),
  (32, 'CL Midgard Mystic', 50, '2000-01-01 00:00:00'),
  (32, 'CL Midgard Rogue', 50, '2000-01-01 00:00:00'),
  (32, 'CL Midgard Seer', 50, '2000-01-01 00:00:00'),
  (33, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (33, 'Champion Level Albion', 50, '2000-01-01 00:00:00'),
  (33, 'CL Albion Disciple', 50, '2000-01-01 00:00:00'),
  (33, 'CL Albion Elementalist', 50, '2000-01-01 00:00:00'),
  (33, 'CL Albion Fighter', 50, '2000-01-01 00:00:00'),
  (33, 'CL Albion Mage', 50, '2000-01-01 00:00:00'),
  (33, 'CL Albion Rogue', 50, '2000-01-01 00:00:00'),
  (34, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (34, 'Champion Level Midgard', 50, '2000-01-01 00:00:00'),
  (34, 'CL Midgard Mystic', 50, '2000-01-01 00:00:00'),
  (34, 'CL Midgard Rogue', 50, '2000-01-01 00:00:00'),
  (34, 'CL Midgard Seer', 50, '2000-01-01 00:00:00'),
  (39, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (39, 'Champion Level Hibernia', 50, '2000-01-01 00:00:00'),
  (39, 'CL Hibernia Forester', 50, '2000-01-01 00:00:00'),
  (39, 'CL Hibernia Guardian', 50, '2000-01-01 00:00:00'),
  (39, 'CL Hibernia Naturalist', 50, '2000-01-01 00:00:00'),
  (39, 'CL Hibernia Stalker', 50, '2000-01-01 00:00:00'),
  (40, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (40, 'Champion Level Hibernia', 50, '2000-01-01 00:00:00'),
  (40, 'CL Hibernia Forester', 50, '2000-01-01 00:00:00'),
  (40, 'CL Hibernia Guardian', 50, '2000-01-01 00:00:00'),
  (40, 'CL Hibernia Naturalist', 50, '2000-01-01 00:00:00'),
  (40, 'CL Hibernia Stalker', 50, '2000-01-01 00:00:00'),
  (41, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (41, 'Champion Level Hibernia', 50, '2000-01-01 00:00:00'),
  (41, 'CL Hibernia Forester', 50, '2000-01-01 00:00:00'),
  (41, 'CL Hibernia Guardian', 50, '2000-01-01 00:00:00'),
  (41, 'CL Hibernia Naturalist', 50, '2000-01-01 00:00:00'),
  (41, 'CL Hibernia Stalker', 50, '2000-01-01 00:00:00'),
  (42, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (42, 'Champion Level Hibernia', 50, '2000-01-01 00:00:00'),
  (42, 'CL Hibernia Forester', 50, '2000-01-01 00:00:00'),
  (42, 'CL Hibernia Guardian', 50, '2000-01-01 00:00:00'),
  (42, 'CL Hibernia Naturalist', 50, '2000-01-01 00:00:00'),
  (42, 'CL Hibernia Stalker', 50, '2000-01-01 00:00:00'),
  (43, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (43, 'Champion Level Hibernia', 50, '2000-01-01 00:00:00'),
  (43, 'CL Hibernia Forester', 50, '2000-01-01 00:00:00'),
  (43, 'CL Hibernia Magician', 50, '2000-01-01 00:00:00'),
  (43, 'CL Hibernia Naturalist', 50, '2000-01-01 00:00:00'),
  (43, 'CL Hibernia Stalker', 50, '2000-01-01 00:00:00'),
  (44, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (44, 'Champion Level Hibernia', 50, '2000-01-01 00:00:00'),
  (44, 'CL Hibernia Forester', 50, '2000-01-01 00:00:00'),
  (44, 'CL Hibernia Magician', 50, '2000-01-01 00:00:00'),
  (44, 'CL Hibernia Naturalist', 50, '2000-01-01 00:00:00'),
  (44, 'CL Hibernia Stalker', 50, '2000-01-01 00:00:00'),
  (45, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (45, 'Champion Level Hibernia', 50, '2000-01-01 00:00:00'),
  (45, 'CL Hibernia Forester', 50, '2000-01-01 00:00:00'),
  (45, 'CL Hibernia Magician', 50, '2000-01-01 00:00:00'),
  (45, 'CL Hibernia Naturalist', 50, '2000-01-01 00:00:00'),
  (45, 'CL Hibernia Stalker', 50, '2000-01-01 00:00:00'),
  (46, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (46, 'Champion Level Hibernia', 50, '2000-01-01 00:00:00'),
  (46, 'CL Hibernia Forester', 50, '2000-01-01 00:00:00'),
  (46, 'CL Hibernia Guardian', 50, '2000-01-01 00:00:00'),
  (46, 'CL Hibernia Magician', 50, '2000-01-01 00:00:00'),
  (46, 'CL Hibernia Stalker', 50, '2000-01-01 00:00:00'),
  (47, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (47, 'Champion Level Hibernia', 50, '2000-01-01 00:00:00'),
  (47, 'CL Hibernia Forester', 50, '2000-01-01 00:00:00'),
  (47, 'CL Hibernia Guardian', 50, '2000-01-01 00:00:00'),
  (47, 'CL Hibernia Magician', 50, '2000-01-01 00:00:00'),
  (47, 'CL Hibernia Stalker', 50, '2000-01-01 00:00:00'),
  (48, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (48, 'Champion Level Hibernia', 50, '2000-01-01 00:00:00'),
  (48, 'CL Hibernia Forester', 50, '2000-01-01 00:00:00'),
  (48, 'CL Hibernia Guardian', 50, '2000-01-01 00:00:00'),
  (48, 'CL Hibernia Magician', 50, '2000-01-01 00:00:00'),
  (48, 'CL Hibernia Stalker', 50, '2000-01-01 00:00:00'),
  (49, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (49, 'Champion Level Hibernia', 50, '2000-01-01 00:00:00'),
  (49, 'CL Hibernia Forester', 50, '2000-01-01 00:00:00'),
  (49, 'CL Hibernia Guardian', 50, '2000-01-01 00:00:00'),
  (49, 'CL Hibernia Magician', 50, '2000-01-01 00:00:00'),
  (49, 'CL Hibernia Naturalist', 50, '2000-01-01 00:00:00'),
  (50, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (50, 'Champion Level Hibernia', 50, '2000-01-01 00:00:00'),
  (50, 'CL Hibernia Forester', 50, '2000-01-01 00:00:00'),
  (50, 'CL Hibernia Guardian', 50, '2000-01-01 00:00:00'),
  (50, 'CL Hibernia Magician', 50, '2000-01-01 00:00:00'),
  (50, 'CL Hibernia Naturalist', 50, '2000-01-01 00:00:00'),
  (55, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (55, 'Champion Level Hibernia', 50, '2000-01-01 00:00:00'),
  (55, 'CL Hibernia Guardian', 50, '2000-01-01 00:00:00'),
  (55, 'CL Hibernia Magician', 50, '2000-01-01 00:00:00'),
  (55, 'CL Hibernia Naturalist', 50, '2000-01-01 00:00:00'),
  (55, 'CL Hibernia Stalker', 50, '2000-01-01 00:00:00'),
  (56, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (56, 'Champion Level Hibernia', 50, '2000-01-01 00:00:00'),
  (56, 'CL Hibernia Guardian', 50, '2000-01-01 00:00:00'),
  (56, 'CL Hibernia Magician', 50, '2000-01-01 00:00:00'),
  (56, 'CL Hibernia Naturalist', 50, '2000-01-01 00:00:00'),
  (56, 'CL Hibernia Stalker', 50, '2000-01-01 00:00:00'),
  (58, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (58, 'Champion Level Hibernia', 50, '2000-01-01 00:00:00'),
  (58, 'CL Hibernia Forester', 50, '2000-01-01 00:00:00'),
  (58, 'CL Hibernia Guardian', 50, '2000-01-01 00:00:00'),
  (58, 'CL Hibernia Magician', 50, '2000-01-01 00:00:00'),
  (58, 'CL Hibernia Naturalist', 50, '2000-01-01 00:00:00'),
  (59, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (59, 'Champion Level Midgard', 50, '2000-01-01 00:00:00'),
  (59, 'CL Midgard Rogue', 50, '2000-01-01 00:00:00'),
  (59, 'CL Midgard Seer', 50, '2000-01-01 00:00:00'),
  (59, 'CL Midgard Viking', 50, '2000-01-01 00:00:00'),
  (60, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (60, 'Champion Level Albion', 50, '2000-01-01 00:00:00'),
  (60, 'CL Albion Acolyte', 50, '2000-01-01 00:00:00'),
  (60, 'CL Albion Disciple', 50, '2000-01-01 00:00:00'),
  (60, 'CL Albion Elementalist', 50, '2000-01-01 00:00:00'),
  (60, 'CL Albion Mage', 50, '2000-01-01 00:00:00'),
  (60, 'CL Albion Rogue', 50, '2000-01-01 00:00:00'),
  (61, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (61, 'Champion Level Hibernia', 50, '2000-01-01 00:00:00'),
  (61, 'CL Hibernia Forester', 50, '2000-01-01 00:00:00'),
  (61, 'CL Hibernia Magician', 50, '2000-01-01 00:00:00'),
  (61, 'CL Hibernia Naturalist', 50, '2000-01-01 00:00:00'),
  (61, 'CL Hibernia Stalker', 50, '2000-01-01 00:00:00'),
  (62, 'ChampionCareer', -3, '2000-01-01 00:00:00'),
  (62, 'Champion Level Midgard', 50, '2000-01-01 00:00:00'),
  (62, 'CL Midgard Mystic', 50, '2000-01-01 00:00:00'),
  (62, 'CL Midgard Rogue', 50, '2000-01-01 00:00:00'),
  (62, 'CL Midgard Seer', 50, '2000-01-01 00:00:00');

-- The Kings, in their throne rooms.
--
-- Placed on the arrival point of each throne room, which is where the travel
-- catalogue already puts a player who asks to go there, and so the one spot in
-- an otherwise empty region they are certain to be standing.
DELETE FROM `mob` WHERE `ClassType` = 'DOL.GS.GameKingThroneNpc';
INSERT INTO `mob` (`Mob_ID`, `ClassType`, `Name`, `Guild`, `X`, `Y`, `Z`, `Heading`, `Region`,
                  `Model`, `Size`, `Level`, `Realm`, `Flags`, `PackageID`, `LastTimeRowUpdated`, `OwnerID`, `NPCTemplateID`) VALUES
  (UUID(), 'DOL.GS.GameKingThroneNpc', 'King Eirik', 'King', 32331, 30410, 15563, 3, 360,
   40, 55, 75, 2, 16, 'gaheris-champion', '2000-01-01 00:00:00', '', 0);
INSERT INTO `mob` (`Mob_ID`, `ClassType`, `Name`, `Guild`, `X`, `Y`, `Z`, `Heading`, `Region`,
                  `Model`, `Size`, `Level`, `Realm`, `Flags`, `PackageID`, `LastTimeRowUpdated`, `OwnerID`, `NPCTemplateID`) VALUES
  (UUID(), 'DOL.GS.GameKingThroneNpc', 'King Constantine', 'King', 32328, 31795, 15901, 17, 394,
   40, 55, 75, 1, 16, 'gaheris-champion', '2000-01-01 00:00:00', '', 0);
INSERT INTO `mob` (`Mob_ID`, `ClassType`, `Name`, `Guild`, `X`, `Y`, `Z`, `Heading`, `Region`,
                  `Model`, `Size`, `Level`, `Realm`, `Flags`, `PackageID`, `LastTimeRowUpdated`, `OwnerID`, `NPCTemplateID`) VALUES
  (UUID(), 'DOL.GS.GameKingThroneNpc', 'King Lamfhota', 'King', 32329, 31779, 15715, 12, 395,
   40, 55, 75, 3, 16, 'gaheris-champion', '2000-01-01 00:00:00', '', 0);
