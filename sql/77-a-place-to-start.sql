-- Somewhere to start, for every race and class.
--
-- Restoring the six disabled races let people create them and then dropped
-- them at the door: a Shar Stalker came out with region 0, because
-- startuplocation had no row matching race 18, and entering the world with no
-- region disconnects the client. The log says it plainly --
--
--     startup location not found: char name=Mampy; region=0; realm=3;
--     class=54 (Stalker); race=18 (Shar)
--
-- and the character is created and then unplayable.
--
-- The table has 183 rows and not one wildcard, so any race or class it does
-- not name explicitly falls through to nothing. The matcher already supports
-- wildcards:
--
--     .Where(sl => sl.ClassID == 0 || sl.ClassID == ch.Class)
--     .Where(sl => sl.RaceID  == 0 || sl.RaceID  == ch.Race)
--
-- and orders by descending specificity, so an exact row still wins wherever
-- one exists. These three are only the floor beneath them: one per realm, at
-- the town every one of that realm's starting rows already sits in or beside
-- -- Cotswold, Mularn and Mag Mell, whose coordinates were verified against
-- the town hastener and Gate Warden earlier today.
--
-- This covers Half Ogre, Frostalf, Shar and the three Minotaurs, and anything
-- else added later that nobody remembers to give a starting point.

INSERT INTO startuplocation
    (StartupLoc_ID, XPos, YPos, ZPos, Heading, Region, MinVersion,
     RealmID, RaceID, ClassID, ClientRegionID, LastTimeRowUpdated)
VALUES
    (9001, 560564, 511528, 2280, 2064, 1,   0, 1, 0, 0, 0, '2000-01-01 00:00:00'),
    (9002, 803612, 726671, 4743, 2587, 100, 0, 2, 0, 0, 0, '2000-01-01 00:00:00'),
    (9003, 347811, 490351, 5210, 1000, 200, 0, 3, 0, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `StartupLoc_ID` = `StartupLoc_ID`;

-- And put Mampy somewhere, since he was created into region 0 and cannot log
-- in at all as he stands.

UPDATE dolcharacters
   SET Region = 200, Xpos = 347811, Ypos = 490351, Zpos = 5210,
       BindRegion = 200, BindXpos = 347811, BindYpos = 490351, BindZpos = 5210
 WHERE Name = 'Mampy' AND Region = 0;
