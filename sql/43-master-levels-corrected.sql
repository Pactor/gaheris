-- ===========================================================================
--  43-master-levels-corrected.sql
--
--  Migration 42 put the right abilities at the wrong ranks.
--
--  It worked from the handler names OpenDAoC implements, which told it what
--  was possible but not where anything belonged, so eight of its nine
--  guesses were misplaced or misnamed. The canonical lists settle it -- the
--  per-path pages at camelot.allakhazam.com/masterlevels, which give all ten
--  ranks for each path -- and this puts every one where it goes.
--
--      Battlemaster  1 Sapping Strike    was Essence Dampen at 1
--                    3 Power Leak        was Mana Drain
--                    5 Essence Flames    was Endurance Drain at 5, Flames at 7
--                    7 Essence Sear      was at 9
--                    8 Bodyguard         correct already
--                    9 Essence Dampen    was at 1
--
--      Spymaster     4 Sabotage          was at 3
--                    7 Lookout           was at 1
--
--      Sojourner     7 Resistance of the Ancients   correct already
--
--  The types were right throughout -- MLEndudrain really is the endurance
--  drain, BodyguardHandler really is Bodyguard -- so nothing here changes what
--  the abilities do, only which rank teaches them and what they are called.
--  Getting that wrong is the quiet kind of wrong: the path works, and every
--  ability arrives one or two ranks from where a player expects it.
--
--  Seven gaps remain and all seven are now identified by name, which is worth
--  more than the guesses were:
--
--      Battlemaster 10   Essence Shatter        removes a random buff
--      Spymaster     1   Pickpocket             passive bonus PvE coin
--      Spymaster     3   Enduring Poison        poison survives a resist
--      Sojourner     1   Unburdened Warrior     passive, +30% encumbrance
--      Sojourner     3   Reveal Crystalseed     reveals enemy runes
--      Perfecter     4   Greatness              +20% concentration pool
--      Warlord       1   Siege Master           -30% siege timers
--
--  None of them has a handler in OpenDAoC, and no amount of database work
--  changes that -- each needs code before a row is worth writing. Perfecter's
--  unclaimed CCResist and PowerOverTime turn out to be the sub-effects of
--  Determination Ward and Dissonating Ward rather than abilities of their own,
--  so they are not the missing rank 4 and were rightly left alone.
--
--  db-public does hold Reveal Crystalseed as spell 7204 with an empty Type
--  column, which is why migration 12 skipped it. It stays skipped: without a
--  handler it would be an ability that costs a rank and does nothing, which is
--  worse than an empty rank.
--
--  Read at boot: needs a restart. Safe to re-run.
-- ===========================================================================

SET NAMES utf8mb4;
SET SESSION sql_mode='';

-- ---------------------------------------------------------------------------
-- Names, to match the canonical lists
-- ---------------------------------------------------------------------------
UPDATE `spell` SET `Name` = 'Sapping Strike',
       `Description` = 'Reduces the target''s endurance by half.'
 WHERE `SpellID` = 7322;

UPDATE `spell` SET `Name` = 'Power Leak',
       `Description` = 'Draws the power out of the target.'
 WHERE `SpellID` = 7321;

UPDATE `spell` SET `Name` = 'Essence Flames',
       `Description` = 'Drains a third of the target''s power, and burns those around it.'
 WHERE `SpellID` = 7323;

UPDATE `spell` SET `Name` = 'Essence Sear',
       `Description` = 'Chains from Essence Flames, searing the essence of those nearby.'
 WHERE `SpellID` = 7325;

UPDATE `spell` SET `Name` = 'Bodyguard',
       `Description` = 'The one you guard cannot be struck in melee while you stand.'
 WHERE `SpellID` = 7324;

UPDATE `spell` SET `Name` = 'Essence Dampen',
       `Description` = 'Suppresses the strength and constitution granted to those nearby.'
 WHERE `SpellID` = 7320;

UPDATE `spell` SET `Name` = 'Sabotage',
       `Description` = 'Ruins an enemy ward where it stands.'
 WHERE `SpellID` = 7327;

UPDATE `spell` SET `Name` = 'Lookout',
       `Description` = 'Guards an ally and reveals what is hidden near them.'
 WHERE `SpellID` = 7326;

-- ---------------------------------------------------------------------------
-- Ranks, to match the canonical lists
-- ---------------------------------------------------------------------------
DELETE FROM `linexspell`
 WHERE `SpellID` IN (7320, 7321, 7322, 7323, 7324, 7325, 7326, 7327, 7328);

INSERT INTO `linexspell` (`LineXSpell_ID`, `LineName`, `SpellID`, `Level`, `PackageID`, `LastTimeRowUpdated`) VALUES
  (UUID(), 'Battlemaster', 7322,  1, 'gaheris-ml', '2000-01-01 00:00:00'),
  (UUID(), 'Battlemaster', 7321,  3, 'gaheris-ml', '2000-01-01 00:00:00'),
  (UUID(), 'Battlemaster', 7323,  5, 'gaheris-ml', '2000-01-01 00:00:00'),
  (UUID(), 'Battlemaster', 7325,  7, 'gaheris-ml', '2000-01-01 00:00:00'),
  (UUID(), 'Battlemaster', 7324,  8, 'gaheris-ml', '2000-01-01 00:00:00'),
  (UUID(), 'Battlemaster', 7320,  9, 'gaheris-ml', '2000-01-01 00:00:00'),
  (UUID(), 'Spymaster',    7327,  4, 'gaheris-ml', '2000-01-01 00:00:00'),
  (UUID(), 'Spymaster',    7326,  7, 'gaheris-ml', '2000-01-01 00:00:00'),
  (UUID(), 'Sojourner',    7328,  7, 'gaheris-ml', '2000-01-01 00:00:00');
