-- The fifteen taskmasters.
--
-- Five per realm, one per level band, each standing outside the town the
-- Camelot Herald wiki records them in. Their own band is flavour: the core
-- picks the dungeon from the PLAYER's level in GetRegionFromLevel, so any
-- taskmaster will give any player the right dungeon. They are placed by band
-- because that is where people will look for them.
--
-- Every coordinate is verified rather than trusted. The wiki gives zone-local
-- positions in thousands; converting them with world = Offset * 8192 + local
-- put Cotswold 67 units from the town hastener, Mularn 154 from its Gate
-- Warden, Haggerfel 117 from Stor Gothi Annark and the Tir na Nog gate 43
-- from an ambient pixie -- so the conversion is right. Where we already had a
-- verified landmark in the travel catalogue, that was used in preference.
--
-- One correction the wiki forced: it places Castle Sauvage in Camelot Hills,
-- and it is not -- it stands in Forest Sauvage, and converting against Camelot
-- Hills would have put Trudan 55,000 units into empty ground. Our own
-- catalogue coordinate is used instead.
--
-- Model 63 is what Gate Wardens use in all three realms, so it is known to
-- exist client-side everywhere these stand. Flag 16 is PEACE.

DELETE FROM mob WHERE PackageID = 'gaheris-task';

INSERT INTO mob
    (Mob_ID, ClassType, Name, X, Y, Z, Heading, Region, Model, Size, Level,
     Realm, Flags, AggroLevel, AggroRange, RespawnInterval, PackageID, LastTimeRowUpdated)
VALUES
    -- Albion
    ('gaheris-tm-traint',    'DOL.GS.Scripts.GaherisTaskMaster', 'Taskmaster Traint',
     560564, 511528, 2280, 1000, 1, 63, 50, 50, 1, 16, 0, 0, 0, 'gaheris-task', '2000-01-01 00:00:00'),
    ('gaheris-tm-prairdred', 'DOL.GS.Scripts.GaherisTaskMaster', 'Taskmaster Prairdred',
     574199, 528948, 2863, 1000, 1, 63, 50, 50, 1, 16, 0, 0, 0, 'gaheris-task', '2000-01-01 00:00:00'),
    ('gaheris-tm-mairlin',   'DOL.GS.Scripts.GaherisTaskMaster', 'Taskmaster Mairlin',
     521253, 616481, 1785, 1000, 1, 63, 50, 50, 1, 16, 0, 0, 0, 'gaheris-task', '2000-01-01 00:00:00'),
    ('gaheris-tm-lucir',     'DOL.GS.Scripts.GaherisTaskMaster', 'Taskmaster Lucir',
     472348, 629103, 1724, 1000, 1, 63, 50, 50, 1, 16, 0, 0, 0, 'gaheris-task', '2000-01-01 00:00:00'),
    ('gaheris-tm-trudan',    'DOL.GS.Scripts.GaherisTaskMaster', 'Taskmaster Trudan',
     584151, 477177, 2600, 1000, 1, 63, 50, 50, 1, 16, 0, 0, 0, 'gaheris-task', '2000-01-01 00:00:00'),

    -- Midgard
    ('gaheris-tm-bernard',   'DOL.GS.Scripts.GaherisTaskMaster', 'Taskmaster Bernard',
     803612, 726671, 4743, 1000, 100, 63, 50, 50, 2, 16, 0, 0, 0, 'gaheris-task', '2000-01-01 00:00:00'),
    ('gaheris-tm-cheri',     'DOL.GS.Scripts.GaherisTaskMaster', 'Taskmaster Cheri',
     729152, 760225, 4573, 1000, 100, 63, 50, 50, 2, 16, 0, 0, 0, 'gaheris-task', '2000-01-01 00:00:00'),
    ('gaheris-tm-bisil',     'DOL.GS.Scripts.GaherisTaskMaster', 'Taskmaster Bisil',
     770196, 836716, 4624, 1000, 100, 63, 50, 50, 2, 16, 0, 0, 0, 'gaheris-task', '2000-01-01 00:00:00'),
    ('gaheris-tm-domli',     'DOL.GS.Scripts.GaherisTaskMaster', 'Taskmaster Domli',
     804564, 701744, 4960, 1000, 100, 63, 50, 50, 2, 16, 0, 0, 0, 'gaheris-task', '2000-01-01 00:00:00'),
    ('gaheris-tm-trinnan',   'DOL.GS.Scripts.GaherisTaskMaster', 'Taskmaster Trinnan',
     765518, 673661, 5736, 1000, 100, 63, 50, 50, 2, 16, 0, 0, 0, 'gaheris-task', '2000-01-01 00:00:00'),

    -- Hibernia
    ('gaheris-tm-sevinia',   'DOL.GS.Scripts.GaherisTaskMaster', 'Taskmaster Sevinia',
     347811, 490351, 5210, 1000, 200, 63, 50, 50, 3, 16, 0, 0, 0, 'gaheris-task', '2000-01-01 00:00:00'),
    ('gaheris-tm-jeryd',     'DOL.GS.Scripts.GaherisTaskMaster', 'Taskmaster Jeryd',
     345698, 528897, 5448, 1000, 200, 63, 50, 50, 3, 16, 0, 0, 0, 'gaheris-task', '2000-01-01 00:00:00'),
    ('gaheris-tm-nelarid',   'DOL.GS.Scripts.GaherisTaskMaster', 'Taskmaster Nelarid',
     343184, 592636, 5456, 1000, 200, 63, 50, 50, 3, 16, 0, 0, 0, 'gaheris-task', '2000-01-01 00:00:00'),
    ('gaheris-tm-praest',    'DOL.GS.Scripts.GaherisTaskMaster', 'Taskmaster Praest',
     313120, 469292, 5206, 1000, 200, 63, 50, 50, 3, 16, 0, 0, 0, 'gaheris-task', '2000-01-01 00:00:00'),
    ('gaheris-tm-vaellyn',   'DOL.GS.Scripts.GaherisTaskMaster', 'Taskmaster Vaellyn',
     334435, 419941, 5184, 1000, 200, 63, 50, 50, 3, 16, 0, 0, 0, 'gaheris-task', '2000-01-01 00:00:00');
