-- Let the evil garrison reach keeps that raise guards from components.
--
-- The Gaheris garrison is applied by ClassType. The Old Frontiers guards are
-- mob rows typed DOL.GS.Scripts.MonsterGuardFighter and friends, which is why
-- they came up as dread legionnaires. Keeps that raise their garrison from
-- keepposition instead -- all 105 New Frontiers keeps and every battleground
-- keep -- named the core classes, so they raised ordinary realm soldiers no
-- matter who held the ground. Setting those keeps to Realm None was not
-- enough on its own; nothing was reading it.
--
-- Safe on keeps that DO have a realm. Every Monster class overrides only
-- SetModel and SetName, and only when HeldByEvil -- that is, when the guard's
-- realm is None. A realm-owned keep falls through to base behaviour exactly
-- as before. What every keep gains is MonsterKeepGuardBrain, which puts hired
-- companions on a guard's aggro list, so garrisons fight the group in front
-- of them rather than the player standing behind it.
--
-- Doors, banners, portal stones, mission masters, hasteners and the Patrol
-- definition are left alone: none of them is a guard.

UPDATE keepposition SET ClassType = 'DOL.GS.Scripts.MonsterGuardFighter'
 WHERE ClassType = 'DOL.GS.Keeps.GuardFighter';
UPDATE keepposition SET ClassType = 'DOL.GS.Scripts.MonsterGuardArcher'
 WHERE ClassType = 'DOL.GS.Keeps.GuardArcher';
UPDATE keepposition SET ClassType = 'DOL.GS.Scripts.MonsterGuardStaticArcher'
 WHERE ClassType = 'DOL.GS.Keeps.GuardStaticArcher';
UPDATE keepposition SET ClassType = 'DOL.GS.Scripts.MonsterGuardCaster'
 WHERE ClassType = 'DOL.GS.Keeps.GuardCaster';
UPDATE keepposition SET ClassType = 'DOL.GS.Scripts.MonsterGuardStaticCaster'
 WHERE ClassType = 'DOL.GS.Keeps.GuardStaticCaster';
UPDATE keepposition SET ClassType = 'DOL.GS.Scripts.MonsterGuardHealer'
 WHERE ClassType = 'DOL.GS.Keeps.GuardHealer';
UPDATE keepposition SET ClassType = 'DOL.GS.Scripts.MonsterGuardStealther'
 WHERE ClassType = 'DOL.GS.Keeps.GuardStealther';
UPDATE keepposition SET ClassType = 'DOL.GS.Scripts.MonsterGuardLord'
 WHERE ClassType = 'DOL.GS.Keeps.GuardLord';
