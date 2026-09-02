-- ===========================================================================
--  21-stranded-guards.sql
--
--  Ninety-one keep guards stuck at level 1, and why.
--
--  A guard's level is set by GameKeepGuard.SetLevel, which is gated on the
--  guard having a Component. On this server the guards are `mob` rows, so the
--  Component is always null -- the trap this project has hit three times now.
--  MonsterGarrison.ScaleToKeep exists precisely to fill that hole, and it is
--  called from AddToWorld on the DOL.GS.Scripts.Monster* guard classes.
--
--  Guards still carrying the CORE class names get neither. Core will not
--  level them because the Component is null, and our code never sees them
--  because it only hooks our own subclasses. So they sit at level 1 forever,
--  which is how Molvik Faste came to be defended by thirteen level 1 guards.
--
--  This is not a level patch. Setting a number in the database would leave
--  them just as stranded the next time a keep changed. Instead every one is
--  remapped to the subclass we already have for it -- there is a Monster*
--  version of every core guard class -- so from now on they are levelled by
--  the same code as every other guard here, take the right model, and get
--  MonsterKeepGuardBrain with the CheckNpcAggro fix that lets them notice
--  hired companions.
--
--  Only `mob` rows are touched. Guards that live in `keepposition` have a
--  real Component and core handles them correctly; nothing here goes near
--  them.
--
--  Read at boot: needs a restart. Safe to re-run.
-- ===========================================================================

SET NAMES utf8mb4;
SET SESSION sql_mode='';

-- ---------------------------------------------------------------------------
-- Before
-- ---------------------------------------------------------------------------
SELECT 'BEFORE' AS phase, `ClassType`, `Level`, COUNT(*) AS n
  FROM `mob` WHERE `ClassType` LIKE 'DOL.GS.Keeps.Guard%'
 GROUP BY `ClassType`, `Level` ORDER BY n DESC;

-- ---------------------------------------------------------------------------
-- The remap
-- ---------------------------------------------------------------------------

UPDATE `mob` SET `ClassType` = 'DOL.GS.Scripts.MonsterGuardFighter'
 WHERE `ClassType` = 'DOL.GS.Keeps.GuardFighter';

UPDATE `mob` SET `ClassType` = 'DOL.GS.Scripts.MonsterGuardArcher'
 WHERE `ClassType` = 'DOL.GS.Keeps.GuardArcher';

UPDATE `mob` SET `ClassType` = 'DOL.GS.Scripts.MonsterGuardStaticArcher'
 WHERE `ClassType` = 'DOL.GS.Keeps.GuardStaticArcher';

UPDATE `mob` SET `ClassType` = 'DOL.GS.Scripts.MonsterGuardCaster'
 WHERE `ClassType` = 'DOL.GS.Keeps.GuardCaster';

UPDATE `mob` SET `ClassType` = 'DOL.GS.Scripts.MonsterGuardStaticCaster'
 WHERE `ClassType` = 'DOL.GS.Keeps.GuardStaticCaster';

UPDATE `mob` SET `ClassType` = 'DOL.GS.Scripts.MonsterGuardHealer'
 WHERE `ClassType` = 'DOL.GS.Keeps.GuardHealer';

UPDATE `mob` SET `ClassType` = 'DOL.GS.Scripts.MonsterGuardStealther'
 WHERE `ClassType` = 'DOL.GS.Keeps.GuardStealther';

UPDATE `mob` SET `ClassType` = 'DOL.GS.Scripts.MonsterGuardCommander'
 WHERE `ClassType` = 'DOL.GS.Keeps.GuardCommander';

UPDATE `mob` SET `ClassType` = 'DOL.GS.Scripts.MonsterGuardLord'
 WHERE `ClassType` = 'DOL.GS.Keeps.GuardLord';

-- FrontierHastener is deliberately left alone. It is a service NPC, not a
-- guard -- there is no Monster* version of it and it has nothing to defend.
-- Its level does not matter to anything, but it is listed below so it is not
-- mistaken for something this missed.

-- ---------------------------------------------------------------------------
-- After
-- ---------------------------------------------------------------------------
SELECT 'AFTER' AS phase, `ClassType`, COUNT(*) AS n
  FROM `mob` WHERE `ClassType` LIKE 'DOL.GS.Keeps.%'
    OR `ClassType` LIKE 'DOL.GS.Scripts.MonsterGuard%'
 GROUP BY `ClassType` ORDER BY n DESC;

SELECT 'left at level 1' AS note, `ClassType`, COUNT(*) AS n
  FROM `mob` WHERE `Level` < 20 AND `ClassType` LIKE 'DOL.GS.Keeps.%'
 GROUP BY `ClassType`;
