-- A portal stone inside each border keep.
--
-- This is how getting to the frontier always worked: open the first door, run
-- in, and port. You never walked there. That matters here more than it did on
-- live, because the old frontier zones are part of the realm regions -- Castle
-- Sauvage physically stands in Forest Sauvage, region 1 -- so walking out of a
-- border keep gate is a stroll across Albion and there is no crossing to
-- intercept. New Frontiers is region 163, and the only way into another region
-- is to be sent.
--
-- Six stones, one per border keep, each opening onto the arrival camp on its
-- own side of the map. Model 2603 is the game's own Frontiers Portal Stone,
-- already used by fourteen world objects here, so it looks like what it is.
--
-- Realm 0: anyone may use any of them. Gaheris groups cross together.
--
-- Flag 16 is PEACE -- a portal is not something to be killed.

DELETE FROM mob WHERE PackageID = 'gaheris-portal';

INSERT INTO mob
    (Mob_ID, ClassType, Name, X, Y, Z, Heading, Region, Model, Size,
     Level, Realm, Flags, AggroLevel, AggroRange, RespawnInterval, PackageID,
     LastTimeRowUpdated)
VALUES
    ('gaheris-portal-sauvage',  'DOL.GS.Scripts.FrontierPortal', 'Frontier Portal Stone',
     584151, 477177, 2600, 0, 1,   2603, 100, 0, 0, 16, 0, 0, 0, 'gaheris-portal', '2000-01-01 00:00:00'),
    ('gaheris-portal-snowdon',  'DOL.GS.Scripts.FrontierPortal', 'Frontier Portal Stone',
     515959, 372539, 8208, 0, 1,   2603, 100, 0, 0, 16, 0, 0, 0, 'gaheris-portal', '2000-01-01 00:00:00'),
    ('gaheris-portal-svasud',   'DOL.GS.Scripts.FrontierPortal', 'Frontier Portal Stone',
     765518, 673661, 5736, 0, 100, 2603, 100, 0, 0, 16, 0, 0, 0, 'gaheris-portal', '2000-01-01 00:00:00'),
    ('gaheris-portal-vindsaul', 'DOL.GS.Scripts.FrontierPortal', 'Frontier Portal Stone',
     704110, 738883, 5704, 0, 100, 2603, 100, 0, 0, 16, 0, 0, 0, 'gaheris-portal', '2000-01-01 00:00:00'),
    ('gaheris-portal-ligen',    'DOL.GS.Scripts.FrontierPortal', 'Frontier Portal Stone',
     334435, 419941, 5336, 0, 200, 2603, 100, 0, 0, 16, 0, 0, 0, 'gaheris-portal', '2000-01-01 00:00:00'),
    ('gaheris-portal-cain',     'DOL.GS.Scripts.FrontierPortal', 'Frontier Portal Stone',
     421156, 486429, 1976, 0, 200, 2603, 100, 0, 0, 16, 0, 0, 0, 'gaheris-portal', '2000-01-01 00:00:00');
