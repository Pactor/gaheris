-- Travel into New Frontiers.
--
-- The switch to New Frontiers moved 105 keeps into region 163 and left the
-- travel catalogue with nothing there at all -- 127 destinations, not one of
-- them in the frontier. The teleporters could reach every city, dungeon and
-- battleground on the server and none of the keeps.
--
-- Twenty-one destinations, the main keeps: seven per realm. The other 84 in
-- region 163 are their towers and do not belong in a menu.
--
-- Generated from the keep table rather than typed out, so the coordinates
-- cannot drift from where the keeps actually stand. Landing point is the keep
-- itself; that ground is guaranteed to exist because the keep is on it.
--
-- Realm 0 means anyone may use it. Gaheris is co-operative -- Albion, Midgard
-- and Hibernia play together -- so a Hibernian wanting Bledmeer Faste is
-- ordinary, not an intrusion.

DELETE FROM teleport WHERE Type = 'gaheris' AND RegionID = 163;

INSERT INTO teleport (Teleport_ID, Type, TeleportID, Realm, RegionID, X, Y, Z, Heading)
SELECT CONCAT('gaheris-nf-', k.KeepID), 'gaheris', k.Name, 0, 163,
       k.X, k.Y, k.Z, k.Heading
FROM keep k
WHERE k.Region = 163
  AND k.KeepID IN (50,51,52,53,54,55,56,
                   75,76,77,78,79,80,81,
                   100,101,102,103,104,105,106);
