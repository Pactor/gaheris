-- Keep guards can be built again.
--
-- There were no guards at any keep that raises its garrison from keepposition
-- -- all 105 New Frontiers keeps and every battleground keep. No lord, nothing
-- in the courtyard, nothing on the stairs. Doors and banners were fine.
--
-- 62-keepposition-monster-garrison.sql renamed every guard ClassType in
-- keepposition from DOL.GS.Keeps.Guard* to DOL.GS.Scripts.MonsterGuard*, so
-- that keeps held by nobody would raise an evil garrison rather than realm
-- soldiers. The intent was right. The mechanism cannot work, and it fails
-- without saying anything.
--
-- GameKeepComponent.FillPositions builds each guard like this:
--
--     Assembly asm = Assembly.GetExecutingAssembly();
--     IKeepItem obj = (IKeepItem)asm.CreateInstance(position.ClassType, true);
--     if (obj != null)
--         obj.LoadFromPosition(position, this);
--
-- GetExecutingAssembly there is the GameServer assembly, because that is where
-- GameKeepComponent lives. Our Monster classes are in the scripts assembly,
-- which core keeps separately in ScriptMgr.m_compiledScripts. So CreateInstance
-- returns null, the null check skips the guard, and nothing is created.
--
-- It returns null rather than throwing, so the catch below it never fires and
-- there is no error in the log. 152 of the 262 rows in keepposition pointed at
-- classes core could not reach; the 110 that still worked are doors, banners,
-- portal stones, hasteners, mission masters and patrol definitions, which kept
-- their core names because none of them is a guard. That is exactly the
-- symptom: doors and no defenders.
--
-- Every ClassType is put back. A realm garrison that exists beats an evil one
-- that does not.
--
-- Why 62 looked like it worked: its other half is real. The Old Frontiers
-- guards are `mob` rows, and mob rows are instantiated through a path that
-- does know about scripts, which is why those became dread legionnaires
-- correctly. Only keepposition goes through GetExecutingAssembly. The mob-row
-- half is untouched here.
--
-- What is given up, and it is worth being plain: keeps raised from
-- keepposition go back to ordinary realm guards, so a keep held by nobody will
-- not show an evil garrison. Doing that properly means either putting the
-- Monster classes where core can see them or overriding FillPositions, and
-- neither belongs in a migration. Recorded in docs/new-frontiers-keep-guards.md.
--
-- Re-running changes nothing: after the first pass no row matches.

UPDATE keepposition SET ClassType = 'DOL.GS.Keeps.GuardFighter'
 WHERE ClassType = 'DOL.GS.Scripts.MonsterGuardFighter';
UPDATE keepposition SET ClassType = 'DOL.GS.Keeps.GuardArcher'
 WHERE ClassType = 'DOL.GS.Scripts.MonsterGuardArcher';
UPDATE keepposition SET ClassType = 'DOL.GS.Keeps.GuardStaticArcher'
 WHERE ClassType = 'DOL.GS.Scripts.MonsterGuardStaticArcher';
UPDATE keepposition SET ClassType = 'DOL.GS.Keeps.GuardCaster'
 WHERE ClassType = 'DOL.GS.Scripts.MonsterGuardCaster';
UPDATE keepposition SET ClassType = 'DOL.GS.Keeps.GuardStaticCaster'
 WHERE ClassType = 'DOL.GS.Scripts.MonsterGuardStaticCaster';
UPDATE keepposition SET ClassType = 'DOL.GS.Keeps.GuardHealer'
 WHERE ClassType = 'DOL.GS.Scripts.MonsterGuardHealer';
UPDATE keepposition SET ClassType = 'DOL.GS.Keeps.GuardStealther'
 WHERE ClassType = 'DOL.GS.Scripts.MonsterGuardStealther';
UPDATE keepposition SET ClassType = 'DOL.GS.Keeps.GuardLord'
 WHERE ClassType = 'DOL.GS.Scripts.MonsterGuardLord';

-- Hurbury was set to Level 1 by hand while testing, and /keep level saves.
UPDATE keep SET Level = 10 WHERE Region = 163;
