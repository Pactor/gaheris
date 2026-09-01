-- Keep garrison respawn cycle.
--
-- "Guilds will be able to claim the keep and fly their banner, but dark forces
-- will return and reclaim the keeps." -- so a cleared keep repopulates.
--
-- RespawnInterval is in milliseconds. 20 minutes gives a cleared keep long
-- enough to feel cleared, without a long wait to run it again while testing.
--
-- The lord respawns slower than the garrison, so the keep refills before its
-- master returns.

SET SESSION sql_mode='';

UPDATE `mob` SET `RespawnInterval` = 1200000
WHERE `ClassType` LIKE 'DOL.GS.Scripts.Monster%'
  AND `ClassType` <> 'DOL.GS.Scripts.MonsterGuardLord'
  AND `Region` IN (1,100,200);

UPDATE `mob` SET `RespawnInterval` = 1800000
WHERE `ClassType` = 'DOL.GS.Scripts.MonsterGuardLord'
  AND `Region` IN (1,100,200);

-- Teardown (back to the server default of a random short interval):
-- UPDATE `mob` SET `RespawnInterval` = 0
--  WHERE `ClassType` LIKE 'DOL.GS.Scripts.Monster%' AND `Region` IN (1,100,200);
