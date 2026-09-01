-- ===========================================================================
--  gaheris-start-level.sql
--
--  New characters start at level 5.
--
--  Level 5 is where the game lets you promote out of your base class, and the
--  recruiters will not hire to anyone still holding an archetype -- you cannot
--  field a group of Wardens while you are a Naturalist. Starting there means a
--  new character picks a class and has a group the same minute, rather than
--  soloing four levels first to reach the point the content begins.
--
--  Applies at character creation only, so anyone already rolled keeps the
--  level they have.
--
--  Read by the server at boot: needs a restart to take effect.
--  Safe to re-run.
-- ===========================================================================

SET NAMES utf8mb4;
SET SESSION sql_mode='';

UPDATE `serverproperty` SET `Value` = '5' WHERE `Key` = 'starting_level';

-- If the server has not written the row yet, create it.
INSERT INTO `serverproperty` (`ServerProperty_ID`, `Category`, `Key`, `Description`, `DefaultValue`, `Value`)
SELECT UUID(), 'startup', 'starting_level',
       'Starting Level - Edit this to set which levels experience a new player start the game with',
       '1', '5'
WHERE NOT EXISTS (SELECT 1 FROM `serverproperty` WHERE `Key` = 'starting_level');

SELECT `Key`, `DefaultValue`, `Value` FROM `serverproperty` WHERE `Key` = 'starting_level';
