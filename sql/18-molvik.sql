-- ===========================================================================
--  18-molvik.sql
--
--  Molvik as the 40-44 battleground.
--
--  Unlike Wilton, this needs no population: Molvik already holds 123 mobs, a
--  Renegade garrison -- Rangers, Hunters, Druids, Runemasters, Guardians --
--  around Molvik Faste, with Renegade Chieftain Molvik at 48 to finish it.
--  It was simply never registered as a battleground, so the level band was
--  never enforced and it never appeared as one.
--
--  That completes the ladder:
--
--      15-19  Abermenai      35-39  Wilton
--      20-24  Thidranki      40-44  Molvik      <- this
--      25-29  Murdaigean     45-49  Cathal Valley
--      30-34  Caledonia
--
--  Worth knowing: Molvik's population actually runs 34-41 with the bulk at 41,
--  so it plays like the FLOOR of a 40-44 band rather than the middle of it.
--  Its keep, Molvik Faste, is BaseLevel 39. If it wants to feel like a proper
--  40-44 zone the garrison needs lifting a few levels -- that is a content
--  decision, not a registration one, and this file deliberately does not make
--  it.
--
--  Read at boot: needs a restart. Safe to re-run.
-- ===========================================================================

SET NAMES utf8mb4;
SET SESSION sql_mode='';

DELETE FROM `battleground` WHERE `RegionID` = 241;

INSERT INTO `battleground`
  (`Battleground_ID`, `RegionID`, `MinLevel`, `MaxLevel`, `MaxRealmLevel`)
VALUES
  ('Molvik (Level 40-44)', 241, 40, 44, 35);

-- ---------------------------------------------------------------------------
-- Check
-- ---------------------------------------------------------------------------
SELECT `RegionID`, `MinLevel`, `MaxLevel`, `Battleground_ID`
  FROM `battleground` ORDER BY `MinLevel`;
