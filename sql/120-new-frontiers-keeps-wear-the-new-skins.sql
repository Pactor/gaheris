-- New Frontiers keeps built from the new models rather than the old ones.
--
-- Every keep in this database stores its appearance twice. Tower 306 carries
-- exactly two components, skin 11 and skin 31 -- the old tower and the new
-- one. Caer Benowyc carries 21 old-skin parts and 18 new-skin parts. That is
-- not duplicated data, it is DOL's design: one building described in both
-- families, and the server picks which to load.
--
-- KeepManager picks with a single global property:
--
--     if (USE_NEW_KEEPS == 0)  SelectObjects(Skin < 20);   // old appearance
--     else if (== 1)           SelectObjects(Skin > 20);   // new appearance
--
-- It was 0, so region 163 -- New Frontiers -- was being assembled out of
-- old-frontier keep parts. Wrong models for a zone whose terrain and layout
-- expect the new ones, which is the likeliest reason some keeps rendered as
-- untextured white.
--
-- Safe everywhere it applies: every keep region holds a full new-skin set --
-- 402 components in 163, and 45 to 55 in each battleground region -- so
-- nothing loses its body by switching.
--
-- Two things this does NOT fix, recorded so they are not rediscovered:
--
--   Skin exactly 20 is loaded by neither branch. `< 20` excludes it and
--   `> 20` excludes it, so nine components in region 163 cannot load under any
--   setting. That is a core bug, not a data one.
--
--   Four keeps have no components at all and will be invisible whatever this
--   is set to: Dun Orseo (165), Braemar Middle Camp (239), Caer Caledon (250)
--   and Thidranki Faste (252). The other componentless rows are Portal Keeps,
--   which are destinations rather than buildings.
--
-- The switch is global. keep.SkinType exists with exactly the right values --
-- Any 0, Old 1, New 2 -- but KeepManager reads it only to recognise relic
-- keeps at 99, so old-style and new-style keeps cannot be mixed. One setting
-- suits this server, so that limitation costs nothing here.
--
-- Written with an insert fallback because the gameserver creates its property
-- rows at boot: an UPDATE alone does nothing on a database the server has
-- never run against.

UPDATE serverproperty
   SET Value = '1'
 WHERE `Key` = 'use_new_keeps';

INSERT INTO serverproperty (`Key`, Description, DefaultValue, Value, Category)
SELECT 'use_new_keeps',
       'Appearance Keeps Components to load. 0 for Old Appearance Keeps Components, 1 for New Appearance Keeps Components. 2 is no longer used but load 0 for compatibility.',
       '0', '1', 'keeps'
 WHERE NOT EXISTS (SELECT 1 FROM serverproperty WHERE `Key` = 'use_new_keeps');
