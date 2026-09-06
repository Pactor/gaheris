-- A keep without a lord can never be taken.
--
-- Fifteen of the twenty-one New Frontiers keeps had no lord at all at Level 1,
-- which makes them permanently uncapturable: the lord is what a keep is taken
-- by, so a keep that cannot produce one cannot change hands, and nothing in
-- the game will ever fix it.
--
-- Guard positions carry a Height, and FillPositions walks down from the
-- component's height taking the first row it finds. Level 1 is height 0, and
-- the lord rows for the new keep sit like this:
--
--     skin 30 rotation 0    heights 0, 1     safe
--     skin 30 rotation 1    height 1 only    no lord at level 1
--     skin 30 rotation 2    height 1 only    no lord at level 1
--     skin 30 rotation 3    height 1 only    no lord at level 1
--
-- Region 163's keeps split across those rotations 6 / 9 / 3 / 3, so six were
-- safe and fifteen were not. The 84 towers are fine: skin 31 has its lord at
-- both heights.
--
-- Reached by ordinary play. Levels are not fixed -- AbstractGameKeep.Reset
-- drops a captured keep back to starting_keep_level, the upgrade timer moves
-- them, and `/keep level 1` sets one directly, which is how this was found.
--
-- The fix is one row per affected rotation, copying that rotation's existing
-- height-1 lord down to height 0. Same offsets, so the lord stands exactly
-- where he already stands and no new position is invented -- the only claim
-- being made is that a keep should have a lord at every level, which is not a
-- matter of taste.
--
-- This does not touch the wider gap. New-skin guards still have no positions
-- above height 1, so the upper floors stay empty and the lord does not climb
-- as the keep is upgraded. That is recorded in
-- docs/new-frontiers-keep-guards.md and is a separate job.
--
-- Written as INSERT ... SELECT with a NOT EXISTS guard, so re-running adds
-- nothing and a rotation that already has a height-0 lord is left alone.

INSERT INTO keepposition
    (KeepPosition_ID, ComponentSkin, ComponentRotation, TemplateID, Height,
     XOff, YOff, ZOff, HOff, ClassType, TemplateType, KeepType, LastTimeRowUpdated)
SELECT UUID(), src.ComponentSkin, src.ComponentRotation, src.TemplateID, 0,
       src.XOff, src.YOff, src.ZOff, src.HOff, src.ClassType, src.TemplateType,
       src.KeepType, '2000-01-01 00:00:00'
  FROM (SELECT * FROM keepposition
         WHERE ClassType LIKE '%GuardLord%' AND Height = 1) src
 WHERE NOT EXISTS (
    SELECT 1 FROM (SELECT ComponentSkin, ComponentRotation FROM keepposition
                    WHERE ClassType LIKE '%GuardLord%' AND Height = 0) have
     WHERE have.ComponentSkin = src.ComponentSkin
       AND have.ComponentRotation = src.ComponentRotation
 );
