-- Every road to the frontier now leads to the new one.
--
-- Twenty-eight zonepoints still landed players in the OLD frontier zones,
-- and one of them is the main gate: walking north out of Camelot Hills put
-- you in region 1's Forest Sauvage, not New Frontiers. So did every
-- battleground exit -- Caledon, Murdaigean, Thidranki, Abermenai -- and the
-- dungeon exits from Dodens Gruva, Marfach Cavern and the Hall of the
-- Corrupt. Six crossings led to region 163 and twenty-eight led to the
-- leftover, which is why every attempt to reach New Frontiers on foot ended
-- up somewhere that looked almost right and wasn't.
--
-- Each is retargeted to the verified New Frontiers entry point for the realm
-- whose frontier it used to lead to. Those coordinates are not invented:
-- they are the targets the game's own six working crossings already use, so
-- they are known to be standable ground.
--
--   was region 1   -> 653823, 617390  (Albion's gate into 163)
--   was region 100 -> 651951, 313721  (Midgard's)
--   was region 200 -> 396561, 618476  (Hibernia's)
--
-- The twelve old zones and their 14,424 creatures stay exactly where they
-- are. What changes is that no route delivers you into them by accident any
-- more -- they stop being the frontier and become ordinary back-country.

UPDATE zonepoint zp
JOIN zones zt
  ON zt.RegionID = zp.TargetRegion
 AND zp.TargetX BETWEEN zt.OffsetX*8192 AND (zt.OffsetX+zt.Width)*8192
 AND zp.TargetY BETWEEN zt.OffsetY*8192 AND (zt.OffsetY+zt.Height)*8192
SET zp.TargetX = CASE zp.TargetRegion
                     WHEN 1   THEN 653823
                     WHEN 100 THEN 651951
                     WHEN 200 THEN 396561 END,
    zp.TargetY = CASE zp.TargetRegion
                     WHEN 1   THEN 617390
                     WHEN 100 THEN 313721
                     WHEN 200 THEN 618476 END,
    zp.TargetZ = CASE zp.TargetRegion
                     WHEN 1   THEN 9560
                     WHEN 100 THEN 9432
                     WHEN 200 THEN 9825 END,
    zp.TargetHeading = CASE zp.TargetRegion
                     WHEN 1   THEN 2000
                     WHEN 100 THEN 1006
                     WHEN 200 THEN 1966 END,
    zp.TargetRegion = 163
WHERE zt.ZoneID IN (11,12,14,15,111,112,113,115,210,211,212,214);
