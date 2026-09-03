-- Put the eight Master Level paths into every class's career.
--
-- Everything for Master Level abilities was already here and one link was
-- missing. The eight specialisations exist and are correctly typed --
-- Banelord, Battlemaster, Convoker, Perfecter, Sojourner, Spymaster,
-- Stormlord and Warlord, each with Implementation
-- DOL.GS.LiveMasterLevelsSpecialization. The eight spell lines exist and hold
-- 64 spells between them: Banelord 10, Battlemaster 3, Convoker 10, Perfecter
-- 9, Sojourner 7, Spymaster 6, Stormlord 10, Warlord 9 -- exactly the 64 we
-- imported in migration 12.
--
-- And classxspecialization held not one row joining any of them to any class.
--
-- GamePlayer.RefreshSpecDependantSkills builds a career from that table and
-- walks it looking for entries implementing IMasterLevelsSpecialization:
--
--     foreach (KeyValuePair<Specialization, int> constraint in careers)
--         if (constraint.Key is IMasterLevelsSpecialization)
--             if (mlindex != MLLine) { remove it; mlindex++; continue; }
--
-- With no ML specialisation ever in the career the loop has nothing to keep,
-- MLLine indexes an empty set, and a player at Master Level 5 receives
-- precisely nothing. The Master Levels were real; the abilities behind them
-- were never attached to anybody.
--
-- All eight go to every class, which is how it worked: the paths are not class
-- restricted, some merely suit better. Choosing between them is the Arbiter's
-- job and is handled in GaherisMasterLevels.cs -- and note that MLLine is a
-- positional index into the ML entries in career order rather than a name, so
-- the choice is resolved by walking the career the same way the loop above
-- does. Guessing at the order would hand out the wrong path.
--
-- LevelAcquired is 50 because Atlantis is level 50 content.

DELETE FROM classxspecialization
 WHERE SpecKeyName IN ('Banelord','Battlemaster','Convoker','Perfecter',
                       'Sojourner','Spymaster','Stormlord','Warlord');

INSERT INTO classxspecialization (ClassID, SpecKeyName, LevelAcquired, LastTimeRowUpdated)
SELECT c.ClassID, s.SpecKeyName, 50, '2000-01-01 00:00:00'
  FROM (SELECT DISTINCT ClassID FROM classxspecialization WHERE ClassID > 0) c
 CROSS JOIN (SELECT 'Banelord' AS SpecKeyName
             UNION ALL SELECT 'Battlemaster'
             UNION ALL SELECT 'Convoker'
             UNION ALL SELECT 'Perfecter'
             UNION ALL SELECT 'Sojourner'
             UNION ALL SELECT 'Spymaster'
             UNION ALL SELECT 'Stormlord'
             UNION ALL SELECT 'Warlord') s;
