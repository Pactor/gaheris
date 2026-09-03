-- Move the way home clear of the airlock.
--
-- Three of the zonepoints that bring people back from New Frontiers landed
-- almost on top of the border keep passage they came out of: 799 units at
-- Druim Cain, 809 at Druim Ligen, 997 at Vindsaul Faste. The airlock sends
-- anyone who steps into it straight back to the frontier, so arriving home
-- that close to it means walking a few steps in the wrong direction and being
-- fired back where you came from.
--
-- Each is pushed further out along the line it already lay on, to roughly
-- 3,000 units. Checked: all three still land inside a real zone -- Mount
-- Collory, Connacht and Yggdra Forest respectively -- rather than off the
-- edge of one.
--
-- The other returns were already clear: Svasud Faste's is 3,407 out and
-- Castle Sauvage's 9,089.

UPDATE zonepoint SET TargetX = 421281, TargetY = 483193
 WHERE SourceRegion = 163 AND TargetX = 421257 AND TargetY = 485590;

UPDATE zonepoint SET TargetX = 332041, TargetY = 418130
 WHERE SourceRegion = 163 AND TargetX = 333634 AND TargetY = 419960;

UPDATE zonepoint SET TargetX = 703922, TargetY = 735941
 WHERE SourceRegion = 163 AND TargetX = 703994 AND TargetY = 737935;
