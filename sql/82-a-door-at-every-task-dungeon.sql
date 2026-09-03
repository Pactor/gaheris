-- A door at every task dungeon, all fifteen.
--
-- The cave mouths are not in any database. Every coordinate-bearing table in
-- the reference dump was searched within 700 units of all fifteen Camelot
-- Herald locations -- WorldObject, Mob, Door, ZonePoint, the lot -- and the
-- only things near them are the zonepoints we already hold and ordinary
-- wildlife. The hole in the ground is client terrain and was never server
-- data, which is why no dump has it and why looking harder was never going to
-- turn one up.
--
-- It does not matter, because our entrance does not use the zonepoint. It
-- reads the player's mission and moves them, the same way the core's jump
-- point handler does, so it works wherever it is put.
--
-- One at each of the fifteen locations the Herald gives: every realm, every
-- level band. Six are corroborated by our own zonepoints agreeing to within
-- 200 units -- Albion 11-20, Midgard 1-10, 11-20 and 41-50, Hibernia 1-10 and
-- 41-50 -- and the other nine are the Herald's alone, for bands we hold no
-- zonepoint coordinates for at all.
--
-- Z is the ground height of the nearest creature to each spot, so they sit on
-- the terrain rather than in it.

DELETE FROM mob WHERE PackageID = 'gaheris-tdoor';

INSERT INTO mob
    (Mob_ID, ClassType, Name, X, Y, Z, Heading, Region, Model, Size, Level,
     Realm, Flags, AggroLevel, AggroRange, RespawnInterval, PackageID, LastTimeRowUpdated)
VALUES
    -- Albion 1-10
    ('gaheris-td-alb-1-10','DOL.GS.Scripts.TaskDungeonEntrance','Dungeon Entrance',562564,514528,2737,0,1,3543,100,0,0,16,0,0,0,'gaheris-tdoor','2000-01-01 00:00:00'),
    -- Albion 11-20
    ('gaheris-td-alb-11-20','DOL.GS.Scripts.TaskDungeonEntrance','Dungeon Entrance',574864,539228,2353,0,1,3543,100,0,0,16,0,0,0,'gaheris-tdoor','2000-01-01 00:00:00'),
    -- Albion 21-30
    ('gaheris-td-alb-21-30','DOL.GS.Scripts.TaskDungeonEntrance','Dungeon Entrance',529628,612732,2499,0,1,3543,100,0,0,16,0,0,0,'gaheris-tdoor','2000-01-01 00:00:00'),
    -- Albion 31-40
    ('gaheris-td-alb-31-40','DOL.GS.Scripts.TaskDungeonEntrance','Dungeon Entrance',468692,631300,1735,0,1,3543,100,0,0,16,0,0,0,'gaheris-tdoor','2000-01-01 00:00:00'),
    -- Albion 41-50
    ('gaheris-td-alb-41-50','DOL.GS.Scripts.TaskDungeonEntrance','Dungeon Entrance',591764,574928,2064,0,1,3543,100,0,0,16,0,0,0,'gaheris-tdoor','2000-01-01 00:00:00'),
    -- Midgard 1-10
    ('gaheris-td-mid-1-10','DOL.GS.Scripts.TaskDungeonEntrance','Dungeon Entrance',799664,729144,5049,0,100,3543,100,0,0,16,0,0,0,'gaheris-tdoor','2000-01-01 00:00:00'),
    -- Midgard 11-20
    ('gaheris-td-mid-11-20','DOL.GS.Scripts.TaskDungeonEntrance','Dungeon Entrance',726496,774980,4635,0,100,3543,100,0,0,16,0,0,0,'gaheris-tdoor','2000-01-01 00:00:00'),
    -- Midgard 21-30
    ('gaheris-td-mid-21-30','DOL.GS.Scripts.TaskDungeonEntrance','Dungeon Entrance',762596,849516,4680,0,100,3543,100,0,0,16,0,0,0,'gaheris-tdoor','2000-01-01 00:00:00'),
    -- Midgard 31-40
    ('gaheris-td-mid-31-40','DOL.GS.Scripts.TaskDungeonEntrance','Dungeon Entrance',809164,697144,5111,0,100,3543,100,0,0,16,0,0,0,'gaheris-tdoor','2000-01-01 00:00:00'),
    -- Midgard 41-50
    ('gaheris-td-mid-41-50','DOL.GS.Scripts.TaskDungeonEntrance','Dungeon Entrance',759064,676144,5176,0,100,3543,100,0,0,16,0,0,0,'gaheris-tdoor','2000-01-01 00:00:00'),
    -- Hibernia 1-10
    ('gaheris-td-hib-1-10','DOL.GS.Scripts.TaskDungeonEntrance','Dungeon Entrance',349788,485228,5250,0,200,3543,100,0,0,16,0,0,0,'gaheris-tdoor','2000-01-01 00:00:00'),
    -- Hibernia 11-20
    ('gaheris-td-hib-11-20','DOL.GS.Scripts.TaskDungeonEntrance','Dungeon Entrance',329888,536528,5611,0,200,3543,100,0,0,16,0,0,0,'gaheris-tdoor','2000-01-01 00:00:00'),
    -- Hibernia 21-30
    ('gaheris-td-hib-21-30','DOL.GS.Scripts.TaskDungeonEntrance','Dungeon Entrance',334588,587864,8361,0,200,3543,100,0,0,16,0,0,0,'gaheris-tdoor','2000-01-01 00:00:00'),
    -- Hibernia 31-40
    ('gaheris-td-hib-31-40','DOL.GS.Scripts.TaskDungeonEntrance','Dungeon Entrance',311720,459692,6271,0,200,3543,100,0,0,16,0,0,0,'gaheris-tdoor','2000-01-01 00:00:00'),
    -- Hibernia 41-50
    ('gaheris-td-hib-41-50','DOL.GS.Scripts.TaskDungeonEntrance','Dungeon Entrance',346420,422892,5943,0,200,3543,100,0,0,16,0,0,0,'gaheris-tdoor','2000-01-01 00:00:00');
