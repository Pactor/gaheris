-- The lord climbs with the keep.
--
-- On live, a keep lord moves as the keep is upgraded -- three rooms, one per
-- build tier, with the guards filling the floors between him and the door. Our
-- lord never moved: the new-skin keep has a lord position at height 1 and
-- nothing above, so a Level 10 keep fell back to the height-1 row and left him
-- one floor below where he belongs.
--
-- This adds the missing top rung. It does not invent it.
--
-- The three lord rooms were measured in game at Caer Hurbury and converted
-- back through core's own placement maths -- LoadXY inverted for the
-- component's rotation, against keep (599604,650643) heading 110 and its
-- skin-30 component at grid (-6,9) rotation 1:
--
--     ground   XOff  582   YOff -1134   ZOff 240
--     middle   XOff  335   YOff  -948   ZOff 577
--     top      XOff  586   YOff  -864   ZOff 848
--
-- The middle one is the check that makes the other two usable. The row already
-- in the database for that rotation is XOff 347, YOff -922, ZOff 577 -- twelve
-- units apart in X, twenty-six in Y, and exactly zero in Z. The inversion is
-- right and the measurement is sound.
--
-- Mapping onto core's tiers, only one rung is actually missing:
--
--     level 1       height 0    ground
--     levels 2-4    height 1    middle   row exists, and 4 is the unclaimed default
--     levels 5-7    height 2    middle   no row needed, falls back to height 1
--     levels 8-10   height 3    top      MISSING
--
-- So one row per rotation, at height 3, lifted from that rotation's own
-- height-1 row by the delta solved at Hurbury: X +251, Y +84, Z +271. Rotation
-- 1 is exact, being the rotation that was measured. The other three take the
-- same lift, which is the honest position: the four rotations are the same
-- building turned, their existing lord offsets already sit within seventy
-- units of one another, and a lord placed by this on a rotation-0 keep should
-- be checked in game rather than assumed.
--
-- HOff, TemplateID and TemplateType are carried across unchanged, so the lord
-- faces as he did and is the same guard by every identifier core uses.
--
-- What this does not do: the guards. Sixty-nine new-skin guard slots still have
-- a single rung, so the floors between the door and the lord stay empty and a
-- keep upgrading from 4 to 10 still gains no defenders. Those have no
-- measurement behind them and placing them would be invention; see
-- docs/new-frontiers-keep-guards.md.
--
-- Guarded so re-running adds nothing.

INSERT INTO keepposition
    (KeepPosition_ID, ComponentSkin, ComponentRotation, TemplateID, Height,
     XOff, YOff, ZOff, HOff, ClassType, TemplateType, KeepType, LastTimeRowUpdated)
SELECT UUID(), src.ComponentSkin, src.ComponentRotation, src.TemplateID, 3,
       src.XOff + 251, src.YOff + 84, src.ZOff + 271, src.HOff,
       src.ClassType, src.TemplateType, src.KeepType, '2000-01-01 00:00:00'
  FROM (SELECT * FROM keepposition
         WHERE ClassType LIKE '%GuardLord%' AND ComponentSkin = 30 AND Height = 1) src
 WHERE NOT EXISTS (
    SELECT 1 FROM (SELECT ComponentSkin, ComponentRotation FROM keepposition
                    WHERE ClassType LIKE '%GuardLord%' AND ComponentSkin = 30
                      AND Height = 3) have
     WHERE have.ComponentSkin = src.ComponentSkin
       AND have.ComponentRotation = src.ComponentRotation
 );
