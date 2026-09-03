-- Open every New Frontiers crossing to every realm.
--
-- The six ways into region 163 were realm-locked the way they are on a
-- competitive server: Vale of Mularn admitted only Midgard, West Svealand
-- refused Albion, and Druim Ligen was Hibernia only. An Albion character
-- standing at Druim Ligen is simply turned away -- no message, nothing
-- happens, and you walk on into the old frontier zones instead and conclude
-- the switch never took.
--
-- Gaheris is co-operative. All three realms group together and travel
-- together, so a realm gate on the entrance to the frontier is not a rule
-- here, it is a wall across the middle of the group.
--
-- Fills in the missing (Id, Realm) rows, copying each crossing's own source
-- and target from a row that already exists for it, so nothing moves.

INSERT INTO zonepoint
    (ZonePoint_ID, Id, TargetX, TargetY, TargetZ, TargetRegion, TargetHeading,
     SourceX, SourceY, SourceZ, SourceRegion, Realm, ClassType, LastTimeRowUpdated)
SELECT UUID(), z.Id, z.TargetX, z.TargetY, z.TargetZ, z.TargetRegion,
       z.TargetHeading, z.SourceX, z.SourceY, z.SourceZ, z.SourceRegion,
       r.Realm, z.ClassType, '2000-01-01 00:00:00'
FROM (SELECT 1 AS Realm UNION ALL SELECT 2 UNION ALL SELECT 3) r
CROSS JOIN (
    SELECT Id, TargetX, TargetY, TargetZ, TargetRegion, TargetHeading,
           SourceX, SourceY, SourceZ, SourceRegion, ClassType
    FROM zonepoint
    WHERE TargetRegion = 163 AND SourceRegion IN (1, 100, 200)
    GROUP BY Id
) z
WHERE NOT EXISTS (
    SELECT 1 FROM zonepoint e
    WHERE e.Id = z.Id AND e.SourceRegion = z.SourceRegion AND e.Realm = r.Realm
);
