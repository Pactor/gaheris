-- Travel to the frontier camps, not to the keeps.
--
-- Migration 48 offered the 21 New Frontiers keeps as destinations. That was
-- wrong twice over. The game will not port you to a keep your realm does not
-- hold, and under the Gaheris rules the keeps are held by the forces of evil
-- rather than by any realm -- so every one of those destinations is either
-- refused outright or drops you inside a hostile garrison.
--
-- What players actually travel to are the camps: the small settlements
-- scattered through the frontier with the merchants, hasteners, vault keepers
-- and trainers. Region 163 has twelve, and they arrived with the population
-- import -- 83 merchants and a trainer for nearly every class among them.
--
-- Six are full camps, twenty to twenty-eight NPCs each, two per realm side.
-- Six are the small arrival camps, and those sit exactly on the coordinates
-- the game's own crossings already target -- which is the confirmation that
-- these are the right places to land: the game lands you there itself.
--
-- Coordinates are each camp's hastener, which is the one NPC every camp has.

DELETE FROM teleport WHERE Type = 'gaheris' AND RegionID = 163;

INSERT INTO teleport (Teleport_ID, Type, TeleportID, Realm, RegionID, X, Y, Z, Heading)
VALUES
    -- Full camps: merchants, trainers, vaults, healers.
    ('gaheris-nf-camp-snow',  'gaheris', 'Snowdonia Camp',       0, 163, 566220, 671177, 8088, 0),
    ('gaheris-nf-camp-fsau',  'gaheris', 'Forest Sauvage Camp',  0, 163, 676886, 568062, 8088, 0),
    ('gaheris-nf-camp-yggd',  'gaheris', 'Yggdra Forest Camp',   0, 163, 699130, 417057, 8088, 0),
    ('gaheris-nf-camp-uppl',  'gaheris', 'Uppland Camp',         0, 163, 596625, 305894, 8088, 0),
    ('gaheris-nf-camp-coll',  'gaheris', 'Mount Collory Camp',   0, 163, 481616, 668402, 7840, 0),
    ('gaheris-nf-camp-crua',  'gaheris', 'Cruachan Gorge Camp',  0, 163, 373581, 573112, 8040, 0),

    -- Arrival camps, on the crossings themselves.
    ('gaheris-nf-gate-snow',  'gaheris', 'Snowdonia Entrance',      0, 163, 615354, 677360, 9372, 0),
    ('gaheris-nf-gate-fsau',  'gaheris', 'Forest Sauvage Entrance', 0, 163, 653995, 615343, 9411, 0),
    ('gaheris-nf-gate-uppl',  'gaheris', 'Uppland Entrance',        0, 163, 649670, 313898, 8797, 0),
    ('gaheris-nf-gate-yggd',  'gaheris', 'Yggdra Forest Entrance',  0, 163, 714416, 366163, 9096, 0),
    ('gaheris-nf-gate-coll',  'gaheris', 'Mount Collory Entrance',  0, 163, 433899, 678939, 9314, 0),
    ('gaheris-nf-gate-crua',  'gaheris', 'Cruachan Gorge Entrance', 0, 163, 396089, 616403, 9232, 0);

-- And hand the keeps to evil.
--
-- They imported carrying their live realm ownership -- 35 keeps each to
-- Albion, Midgard and Hibernia -- which is how a competitive server runs
-- them. Gaheris does not: MonsterGarrison holds that a keep whose Realm is
-- None is held by an evil force and raises a monster garrison rather than
-- renamed realm soldiers, and every Old Frontiers keep here was already set
-- that way. New Frontiers should match, or half the map belongs to players
-- who never took it.

UPDATE keep SET Realm = 0, OriginalRealm = 0 WHERE Region = 163;
