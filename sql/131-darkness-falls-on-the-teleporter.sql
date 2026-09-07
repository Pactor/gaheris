-- ===========================================================================
--  131-darkness-falls-on-the-teleporter.sql
--
--  The three Darkness Falls arrivals, as teleporter stops.
--
--  The catalogue already had "Darkness Falls", but it goes to the DOOR -- the
--  Albion surface entrance in region 1, outside. These three go INSIDE, to the
--  spot each realm's entrance drops you at, so the teleporter can put you in
--  the dungeon rather than in front of it.
--
--  Surveyed in game. The figures came off /loc, which reports ZONE-LOCAL
--  coordinates, and this table wants world ones. Darkness Falls is zone 249 at
--  OffsetX 1, OffsetY 1, so world = local + 8192 on both axes. Z is absolute
--  and is left alone.
--
--      Midgard    10606 10475  ->  18798 18667  22892
--      Albion     23044 19728  ->  31236 27920  22893
--      Hibernia   38132 32679  ->  46324 40871  21357
--
--  Two independent checks that this is right. The Midgard figure converts to
--  18798 18667, which is the stock Midgard DF entrance jump target EXACTLY --
--  the same two numbers, not near them. And all three heights match the stock
--  arrival heights for their realm: 22892, 22893 and 21357. Converting the
--  other way, or not at all, agrees with neither.
--
--  Headings were given in degrees (269, 92, and -359, which is 1 going the
--  other way round). The column wants DAoC units, which are 4096 to the
--  circle, so each is degrees * 4096 / 360.
--
--  Region 249 also has to be filed under Dungeons in Travel.cs. Without that
--  it falls through to the numeric test, and 249 is under 300, so all three
--  would have been listed under Hibernia.
--
--  Read at spawn: needs a restart. Safe to re-run.
-- ===========================================================================

SET NAMES utf8mb4;
SET SESSION sql_mode='';

DELETE FROM `teleport`
 WHERE `Type` = 'gaheris'
   AND `TeleportID` IN ('Darkness Falls Albion',
                        'Darkness Falls Midgard',
                        'Darkness Falls Hibernia');

INSERT INTO `teleport`
    (`Teleport_ID`, `Type`, `TeleportID`, `Realm`, `RegionID`, `X`, `Y`, `Z`, `Heading`)
VALUES
    (UUID(), 'gaheris', 'Darkness Falls Midgard',  0, 249, 18798, 18667, 22892, 3061),
    (UUID(), 'gaheris', 'Darkness Falls Albion',   0, 249, 31236, 27920, 22893, 1047),
    (UUID(), 'gaheris', 'Darkness Falls Hibernia', 0, 249, 46324, 40871, 21357,   11);

SELECT `TeleportID`, `RegionID`, `X`, `Y`, `Z`, `Heading`
  FROM `teleport`
 WHERE `Type` = 'gaheris' AND `TeleportID` LIKE 'Darkness Falls%'
 ORDER BY `TeleportID`;
