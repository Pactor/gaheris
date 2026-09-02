-- A Gate Warden at every destination the catalogue can reach.
--
-- The wardens went in at the old mage-circle sites, which left three per
-- realm on the mainland, one per capital, and NOTHING in the Shrouded
-- Isles -- 20 SI destinations you could travel to and not one you could
-- travel back from. Albion had 20 destinations and 3 wardens.
--
-- The catalogue rows already are the towns, border keeps and SI hubs
-- (Castle Sauvage, Snowdonia, Svasud Faste, Vindsaul Faste, Druim Ligen,
-- Druim Cain, Cotswold, Mularn, Mag Mell, Gothwaite, Aegirhamn, Domnann...),
-- so every arrival point gets a warden and travel becomes symmetric.
--
-- Battlegrounds, Atlantis and the dungeons already have theirs and are not
-- touched here. Throne-room exits and personal housing are not destinations
-- anyone needs to leave from by portal.
--
-- Idempotent: skips any spot already within 2000 units of a warden.

CREATE TEMPORARY TABLE _warden_here AS
SELECT Region, X, Y FROM mob
 WHERE ClassType = 'DOL.GS.Scripts.GaherisTeleporter';

INSERT INTO mob (Mob_ID, ClassType, Name, Guild, X, Y, Z, Speed, Heading,
                 Region, Model, Size, Level, Realm, Flags, PackageID,
                 LastTimeRowUpdated, OwnerID, NPCTemplateID)
SELECT UUID(), 'DOL.GS.Scripts.GaherisTeleporter', 'Gate Warden', 'Gate Warden',
       t.X, t.Y, t.Z, 0, t.Heading, t.RegionID, 63, 50, 70, 0, 16,
       'gaheris-wardens', '2000-01-01 00:00:00', '', 0
  FROM (SELECT RegionID,
               MIN(X) X, MIN(Y) Y, MIN(Z) Z, MIN(Heading) Heading
          FROM teleport
         WHERE Type = 'gaheris'
           AND RegionID IN (1,10,27,50,51,100,101,150,151,180,181,200,201)
           AND TeleportID NOT IN ('AlbThroneExit','MidThroneExit',
                                  'HibThroneExit','personal')
         GROUP BY RegionID, ROUND(X/2000), ROUND(Y/2000)) t
 WHERE NOT EXISTS (SELECT 1 FROM _warden_here w
                    WHERE w.Region = t.RegionID
                      AND ABS(w.X - t.X) < 2000
                      AND ABS(w.Y - t.Y) < 2000);

DROP TEMPORARY TABLE _warden_here;
