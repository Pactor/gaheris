-- ===========================================================================
--  gaheris-clear-stale-roster.sql
--
--  Clears hire lists belonging to characters that are still a base class.
--
--  Those were hired before the recruiter learned to refuse anyone who has not
--  promoted, so they are groups that could not be hired today. Leaving them
--  means the character logs in and the group is rebuilt around a level 1 who
--  should not have one.
--
--  Gear is NOT touched -- it stays under its owner id and any recruiter will
--  hand it back with [recover].
--
--  Safe to re-run.
-- ===========================================================================

SET NAMES utf8mb4;

SELECT 'before' AS stage, c.Name, c.Level, c.Class, p.Value
FROM dolcharacters c
JOIN dolcharactersxcustomparam p ON p.DOLCharactersObjectId = c.DOLCharacters_ID
WHERE p.KeyName = 'GaherisMercRoster';

-- The base classes: Fighter, Elementalist, Acolyte, AlbionRogue, Mage,
-- Disciple, Viking, Mystic, Seer, MidgardRogue, Guardian, Naturalist,
-- Magician, Stalker, Forester.
DELETE p FROM dolcharactersxcustomparam p
JOIN dolcharacters c ON c.DOLCharacters_ID = p.DOLCharactersObjectId
WHERE p.KeyName = 'GaherisMercRoster'
  AND c.Class IN (14,15,16,17,18,20,35,36,37,38,51,52,53,54,57);

SELECT 'after' AS stage, COUNT(*) AS rosters_left
FROM dolcharactersxcustomparam WHERE KeyName = 'GaherisMercRoster';
