-- Break the border keep gates, and move the stones to the far side.
--
-- The gates are switch-operated and they open onto the old frontier, which is
-- not anywhere anyone should be going. Locking them kills the switches:
-- GameDoor has
--
--     public override bool CanBeOpenedViaInteraction => !Locked;
--
-- so a locked gate cannot be opened by interaction at all. Clicking one now
-- crosses you to New Frontiers instead, handled in FrontierGateDoors.cs.
--
-- These twelve ids are the core's own border keep door list, six pairs, one
-- pair per keep. Nothing else on the server is touched.

UPDATE door SET Locked = 1 WHERE InternalID IN
    (11020501, 11020502,      -- Castle Sauvage
     12000101, 12000102,      -- Snowdonia Fortress
     102093501, 102093502,    -- Vindsaul Faste
     111161301, 111161302,    -- Svasud Faste
     206016801, 206016802,    -- Druim Cain
     207156901, 207156902);   -- Druim Ligen

-- The six portal stones move to the arrival camps and become the way home.
--
-- They were scenery marking the passage on the realm side. The gate itself is
-- now the crossing, so the stone is more use on the far side: the border keep
-- doors only exist in the realm regions, so there is no door in the frontier
-- to click to come back. This is that door.

UPDATE mob SET ClassType = 'DOL.GS.Scripts.FrontierReturn', Region = 163, Flags = 16
 WHERE PackageID = 'gaheris-portal';

UPDATE mob SET X = 653995, Y = 615343, Z = 9411 WHERE Mob_ID = 'gaheris-portal-sauvage';
UPDATE mob SET X = 615354, Y = 677360, Z = 9372 WHERE Mob_ID = 'gaheris-portal-snowdon';
UPDATE mob SET X = 649670, Y = 313898, Z = 8797 WHERE Mob_ID = 'gaheris-portal-svasud';
UPDATE mob SET X = 714416, Y = 366163, Z = 9096 WHERE Mob_ID = 'gaheris-portal-vindsaul';
UPDATE mob SET X = 396089, Y = 616403, Z = 9232 WHERE Mob_ID = 'gaheris-portal-ligen';
UPDATE mob SET X = 433899, Y = 678939, Z = 9314 WHERE Mob_ID = 'gaheris-portal-cain';
