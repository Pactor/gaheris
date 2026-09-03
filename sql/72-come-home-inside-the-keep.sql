-- Come home inside the border keep, not into the old frontier.
--
-- Migration 64 pushed three of the ways home out to about 3,000 units to keep
-- them clear of the airlock trigger. Two of them landed inside leftover
-- frontier zones -- Druim Cain's in Mount Collory, Vindsaul's in Yggdra Forest
-- -- and the stray net now throws anyone standing there straight back to New
-- Frontiers. So coming home bounced you back where you came from.
--
-- The airlock is gone; the gates are doors now, so nothing needs clearance
-- from anything. All three land at their border keep instead, which is where
-- someone coming back from the frontier wants to be, and which sits inside
-- the 5,000 unit hole the stray net leaves around every border keep.
--
-- Checked: Connacht, Valley of Bri Leith and West Svealand respectively, all
-- outside the twelve leftover zones.

UPDATE zonepoint SET TargetX = 334435, TargetY = 419941, TargetZ = 5184
 WHERE SourceRegion = 163 AND Id = 178;   -- Druim Ligen

UPDATE zonepoint SET TargetX = 421156, TargetY = 486429, TargetZ = 1976
 WHERE SourceRegion = 163 AND Id = 179;   -- Druim Cain

UPDATE zonepoint SET TargetX = 704110, TargetY = 738883, TargetZ = 5704
 WHERE SourceRegion = 163 AND Id = 180;   -- Vindsaul Faste
