-- Move the taskmasters off the Gate Wardens, and mark the dungeon mouths.
--
-- Nine of the fifteen taskmasters stand at distance ZERO from a Gate Warden,
-- because they were placed on the travel catalogue's coordinate for the town
-- and that is exactly where the Warden stands. Two NPCs in the same spot means
-- one of them cannot be clicked. Shifted 180 units north-east, which is a step
-- away rather than a relocation.
--
-- And a marker at each of the nine task dungeon jump points.
--
-- A task dungeon entrance is a hole in the landscape: the server holds only a
-- zonepoint and the cave mouth itself is client terrain. Nothing stands at any
-- of them in our world OR in the reference database -- checked, not one object
-- or NPC within 900 units of any of the nine, on either server -- so there has
-- never been anything to see. Worth knowing: the source coordinates on a
-- zonepoint are informational. The client sends a jump point ID when the
-- player enters ITS cave, and the server matches on Id and Realm, so the hole
-- can be somewhere other than the coordinate we record.
--
-- These are therefore two things at once: something to see, so the spot can be
-- found and the recorded coordinate checked against the real terrain; and
-- something to click, so the dungeon is reachable even if this client no
-- longer draws the hole at all.

UPDATE mob SET X = X + 180, Y = Y + 180
 WHERE ClassType = 'DOL.GS.Scripts.GaherisTaskMaster'
   AND Name IN ('Taskmaster Bernard','Taskmaster Prairdred','Taskmaster Cheri',
                'Taskmaster Sevinia','Taskmaster Jeryd','Taskmaster Trinnan',
                'Taskmaster Lucir','Taskmaster Mairlin','Taskmaster Nelarid');

DELETE FROM mob WHERE PackageID = 'gaheris-tdoor';

INSERT INTO mob
    (Mob_ID, ClassType, Name, X, Y, Z, Heading, Region, Model, Size, Level,
     Realm, Flags, AggroLevel, AggroRange, RespawnInterval, PackageID, LastTimeRowUpdated)
VALUES
    ('gaheris-td-loughderg', 'DOL.GS.Scripts.TaskDungeonEntrance', 'Dungeon Entrance',
     349777, 485325, 5250, 0, 200, 3543, 100, 0, 0, 16, 0, 0, 0, 'gaheris-tdoor', '2000-01-01 00:00:00'),
    ('gaheris-td-connacht',  'DOL.GS.Scripts.TaskDungeonEntrance', 'Dungeon Entrance',
     346582, 422963, 5943, 0, 200, 3543, 100, 0, 0, 16, 0, 0, 0, 'gaheris-tdoor', '2000-01-01 00:00:00'),
    ('gaheris-td-camhills1', 'DOL.GS.Scripts.TaskDungeonEntrance', 'Dungeon Entrance',
     562653, 517106, 2957, 0, 1,   3543, 100, 0, 0, 16, 0, 0, 0, 'gaheris-tdoor', '2000-01-01 00:00:00'),
    ('gaheris-td-camhills2', 'DOL.GS.Scripts.TaskDungeonEntrance', 'Dungeon Entrance',
     574943, 539231, 2353, 0, 1,   3543, 100, 0, 0, 16, 0, 0, 0, 'gaheris-tdoor', '2000-01-01 00:00:00'),
    ('gaheris-td-camhills3', 'DOL.GS.Scripts.TaskDungeonEntrance', 'Dungeon Entrance',
     591843, 492422, 2200, 0, 1,   3543, 100, 0, 0, 16, 0, 0, 0, 'gaheris-tdoor', '2000-01-01 00:00:00'),
    ('gaheris-td-mularn1',   'DOL.GS.Scripts.TaskDungeonEntrance', 'Dungeon Entrance',
     799695, 729114, 5049, 0, 100, 3543, 100, 0, 0, 16, 0, 0, 0, 'gaheris-tdoor', '2000-01-01 00:00:00'),
    ('gaheris-td-mularn2',   'DOL.GS.Scripts.TaskDungeonEntrance', 'Dungeon Entrance',
     759086, 676174, 5176, 0, 100, 3543, 100, 0, 0, 16, 0, 0, 0, 'gaheris-tdoor', '2000-01-01 00:00:00'),
    ('gaheris-td-svealand1', 'DOL.GS.Scripts.TaskDungeonEntrance', 'Dungeon Entrance',
     726593, 775056, 4635, 0, 100, 3543, 100, 0, 0, 16, 0, 0, 0, 'gaheris-tdoor', '2000-01-01 00:00:00'),
    ('gaheris-td-svealand2', 'DOL.GS.Scripts.TaskDungeonEntrance', 'Dungeon Entrance',
     726644, 775040, 4635, 0, 100, 3543, 100, 0, 0, 16, 0, 0, 0, 'gaheris-tdoor', '2000-01-01 00:00:00');
