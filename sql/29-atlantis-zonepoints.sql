-- Trials of Atlantis zone points.
--
-- The static portals in Atlantis did nothing when you walked into them. Not
-- broken scripts, no data at all: the zonepoint table held 169 rows and not
-- one of them touched an Atlantis region in either direction.
--
-- A portal is not an object the server owns. The client knows where the
-- portal is and sends its Id on contact; RegionChangeRequestHandler looks
-- that Id up in zonepoint and moves the player to the target it finds. With
-- no row, the lookup misses and the handler returns without a word to a
-- normal player -- which is why every portal in Atlantis looked equally dead.
--
-- These 100 rows come from the same DOL dump the 41,727 Atlantis mobs came
-- from (dol-db/ZonePoint.json, 1737 rows). Every ToA row, in both directions,
-- deduplicated on (Id, Realm). None of them collide with a row we already
-- have, so nothing existing changes.
--
-- Realms are kept as they came: 34 Albion, 31 Midgard, 35 Hibernia. Atlantis
-- exists three times over -- region 30 is Albion's, 73 Midgard's arrival hub
-- as we have it, 130 Hibernia's -- and the Id/Realm pair is what picks which
-- one a given player reaches.

INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 116, 1, 0, 0, 0, 0, 73, 274175, 534600, 8727, 180, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 117, 1, 0, 0, 0, 0, 73, 274175, 534600, 8727, 180, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 118, 1, 70, 578757, 533118, 7214, 73, 274175, 534600, 8727, 180, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 119, 1, 30, 274179, 534341, 8646, 70, 578494, 533304, 7295, 643, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 120, 1, 36, 22460, 45673, 8518, 73, 343922, 472891, 4205, 92, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 121, 1, 36, 29173, 24137, 16978, 73, 333470, 465791, 8783, 250, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 122, 1, 30, 344249, 472538, 4100, 79, 22666, 45432, 8500, 2114, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 123, 1, 30, 333212, 466125, 8822, 79, 29016, 23961, 16917, 350, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 124, 1, 30, 315382, 422206, 8605, 73, 313072, 435211, 8487, 15, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 125, 1, 30, 313061, 435140, 8485, 73, 315389, 422131, 8599, 2059, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 126, 1, 30, 387321, 530080, 4425, 78, 31363, 39344, 16086, 2116, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 127, 1, 78, 31287, 39417, 15853, 73, 387204, 530163, 4411, 228, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 128, 1, 30, 344324, 651174, 5295, 80, 29308, 26252, 17300, 400, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 129, 1, 37, 29468, 26150, 17312, 73, 344404, 651070, 5319, 2209, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 130, 1, 30, 234397, 401998, 9100, 83, 33021, 29980, 15975, 180, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 131, 1, 30, 234397, 401240, 9100, 83, 32362, 29972, 15975, 180, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 132, 1, 40, 32979, 29932, 15975, 73, 234452, 401954, 9100, 2456, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 133, 1, 40, 32301, 29942, 15975, 73, 234467, 401349, 9100, 90, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 134, 1, 30, 256406, 425596, 9344, 88, 32898, 28195, 16900, 4091, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 135, 1, 45, 32899, 27976, 16900, 73, 256300, 425600, 9344, 1048, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 136, 1, 0, 0, 0, 0, 73, 255788, 425626, 11109, 90, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 137, 1, 30, 572803, 554167, 10356, 89, 33099, 42988, 16445, 968, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 138, 1, 46, 33133, 43027, 16445, 73, 572737, 554159, 10332, 1037, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 139, 1, 89, 48703, 16893, 15668, 73, 572737, 554159, 10332, 1037, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 140, 1, 30, 464493, 665610, 14888, 90, 41979, 38173, 10341, 2257, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 141, 1, 90, 41846, 38307, 10341, 73, 464393, 665717, 14889, 170, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 142, 1, 0, 0, 0, 0, 91, 31892, 34784, 15763, 0, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 143, 1, 0, 0, 0, 0, 90, 51377, 39790, 11231, 290, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 256, 1, 201, 29362, 33080, 7890, 92, 58461, 28753, 11277, 1028, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 258, 1, 0, 0, 0, 0, 93, 32452, 31090, 17036, 1979, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 260, 1, 93, 23003, 30981, 16934, 228, 34405, 24015, 16832, 22, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 268, 1, 0, 0, 0, 0, 93, 23013, 30909, 16934, 2128, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 269, 1, 228, 34387, 23872, 16829, 93, 23013, 30909, 16934, 2128, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 445, 1, 92, 49825, 30491, 11741, 446, 35587, 36623, 15822, 764, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 116, 2, 0, 0, 0, 0, 30, 274175, 534600, 8727, 180, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 117, 2, 71, 565776, 570396, 7168, 30, 274175, 534600, 8727, 180, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 118, 2, 0, 0, 0, 0, 30, 274175, 534600, 8727, 180, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 119, 2, 73, 274228, 534289, 8637, 71, 565601, 570056, 7255, 1716, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 120, 2, 73, 343922, 472891, 4205, 30, 343922, 472891, 4205, 92, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 121, 2, 0, 0, 0, 0, 30, 333470, 465791, 8783, 250, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 122, 2, 73, 344196, 472447, 3969, 36, 22666, 45432, 8500, 2114, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 123, 2, 73, 333531, 465814, 8778, 36, 29016, 23961, 16917, 350, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 124, 2, 73, 315377, 422257, 8605, 30, 313072, 435211, 8487, 15, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 125, 2, 73, 313083, 435130, 8490, 30, 315389, 422131, 8599, 2059, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 126, 2, 73, 387414, 530171, 4518, 35, 31363, 39344, 16086, 2116, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 127, 2, 78, 31300, 39405, 15809, 30, 387204, 530163, 4411, 228, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 128, 2, 73, 344183, 651066, 5360, 37, 29308, 26252, 17300, 400, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 129, 2, 0, 0, 0, 0, 30, 344404, 651070, 5319, 2209, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 131, 2, 73, 234427, 401379, 9100, 40, 32362, 29972, 15975, 180, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 132, 2, 83, 33037, 29939, 15975, 30, 234452, 401954, 9100, 2456, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 133, 2, 0, 0, 0, 0, 30, 234467, 401349, 9100, 90, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 134, 2, 73, 256461, 425601, 9344, 45, 32898, 28195, 16900, 4091, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 135, 2, 88, 32891, 27866, 16900, 30, 256300, 425600, 9344, 1048, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 136, 2, 0, 0, 0, 0, 30, 255788, 425626, 11109, 90, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 137, 2, 73, 572779, 554156, 10356, 46, 33099, 42988, 16445, 968, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 138, 2, 89, 33179, 43030, 16445, 30, 572737, 554159, 10332, 1037, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 139, 2, 0, 0, 0, 0, 30, 572737, 554159, 10332, 1037, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 140, 2, 73, 464455, 665519, 14888, 47, 41979, 38173, 10341, 2257, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 141, 2, 90, 41838, 38297, 10341, 30, 464393, 665717, 14889, 170, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 142, 2, 47, 53102, 38926, 11920, 91, 31892, 34784, 15763, 0, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 143, 2, 91, 31906, 34971, 15722, 47, 51377, 39790, 11231, 290, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 256, 2, 0, 0, 0, 0, 92, 58461, 28753, 11277, 1028, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 258, 2, 0, 0, 0, 0, 93, 32452, 31090, 17036, 1979, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 268, 2, 0, 0, 0, 0, 93, 26344, 27854, 17597, 3072, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 269, 2, 0, 0, 0, 0, 93, 23013, 30909, 16934, 2128, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 116, 3, 72, 551784, 577456, 6686, 130, 274175, 534600, 8727, 180, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 117, 3, 0, 0, 0, 0, 130, 274175, 534600, 8727, 180, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 118, 3, 0, 0, 0, 0, 130, 274175, 534600, 8727, 180, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 119, 3, 30, 274176, 534359, 8637, 72, 551807, 577161, 6767, 2061, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 120, 3, 0, 0, 0, 0, 130, 343922, 472891, 4205, 92, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 121, 3, 0, 0, 0, 0, 130, 333470, 465791, 8783, 250, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 122, 3, 130, 344246, 472445, 4073, 136, 22666, 45432, 8500, 2114, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 124, 3, 130, 315378, 422220, 8606, 130, 313072, 435211, 8487, 15, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 125, 3, 130, 313073, 435147, 8494, 130, 315389, 422131, 8599, 2059, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 126, 3, 130, 387406, 530204, 4733, 135, 31363, 39344, 16086, 2116, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 127, 3, 135, 31386, 39446, 16085, 130, 387204, 530163, 4411, 228, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 128, 3, 130, 344143, 651141, 5386, 137, 29308, 26252, 17300, 400, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 129, 3, 0, 0, 0, 0, 130, 344404, 651070, 5319, 2209, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 130, 3, 130, 234385, 402008, 9100, 140, 33021, 29980, 15975, 180, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 131, 3, 130, 234390, 401350, 9100, 140, 32362, 29972, 15975, 180, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 132, 3, 0, 0, 0, 0, 130, 234452, 401954, 9100, 2456, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 133, 3, 140, 32349, 29920, 15975, 130, 234467, 401349, 9100, 90, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 134, 3, 130, 256566, 425615, 9344, 145, 32898, 28195, 16900, 4091, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 135, 3, 145, 32907, 27876, 16900, 130, 256300, 425600, 9344, 1048, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 136, 3, 0, 0, 0, 0, 130, 255788, 425626, 11109, 90, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 137, 3, 130, 572873, 554158, 10356, 146, 33099, 42988, 16445, 968, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 138, 3, 146, 33186, 43001, 16445, 130, 572737, 554159, 10332, 1037, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 139, 3, 146, 48737, 16902, 15688, 130, 572737, 554159, 10332, 1037, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 140, 3, 130, 464438, 665513, 14889, 147, 41979, 38173, 10341, 2257, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 141, 3, 147, 41816, 38317, 10341, 130, 464393, 665717, 14889, 170, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 142, 3, 147, 53012, 38863, 11968, 91, 31892, 34784, 15763, 0, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 143, 3, 0, 0, 0, 0, 147, 51377, 39790, 11231, 290, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 256, 3, 201, 29340, 33112, 7880, 92, 58461, 28753, 11277, 1028, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 258, 3, 197, 19325, 24207, 15470, 93, 32452, 31090, 17036, 1979, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 260, 3, 93, 23040, 30982, 16938, 228, 34405, 24015, 16832, 22, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 261, 3, 93, 32437, 31321, 17060, 197, 19506, 24014, 15477, 3163, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 268, 3, 228, 32808, 23670, 17628, 93, 23013, 30909, 16934, 2128, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 269, 3, 228, 34378, 23873, 16833, 93, 23013, 30909, 16934, 2128, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 445, 3, 92, 49634, 30670, 11820, 446, 35587, 36623, 15822, 764, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
INSERT INTO zonepoint (ZonePoint_ID, Id, Realm, SourceRegion, SourceX, SourceY, SourceZ, TargetRegion, TargetX, TargetY, TargetZ, TargetHeading, ClassType, LastTimeRowUpdated) VALUES (UUID(), 449, 3, 92, 31306, 39910, 15729, 447, 35698, 31254, 15822, 990, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `ZonePoint_ID` = `ZonePoint_ID`;
