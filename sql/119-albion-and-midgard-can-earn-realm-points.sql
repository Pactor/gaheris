-- Realm points in Albion's and Midgard's frontier zones.
--
-- Found while checking, of every installable feature, whether a player can
-- actually reach what it installs. Two of them -- realm abilities and the
-- Realm Rank 5 abilities -- installed perfectly and were unreachable for two
-- realms out of three.
--
-- Realm points come from NpcKillRewardProcessor, scaled by the *zone's*
-- Realmpoints value. Four zones in the whole database had a non-zero one:
--
--     Breifine, Cruachan Gorge, Emain Macha, Mount Collory
--
-- all in region 200, which is Hibernia's old frontier. Albion's Forest
-- Sauvage, Snowdonia, Pennine Mountains and Hadrian's Wall were zero. So were
-- Midgard's Uppland, Yggdra Forest, Jamtland Mountains and Odin's Gate.
--
-- So an Albion or Midgard character could not earn a realm point anywhere,
-- could never spend a realm skill point, and could never reach the Realm Rank
-- 5 that five classes were given their RR5 abilities back for. The highest
-- realm level on this server is 10 -- Realm Rank 2 -- and nobody is above
-- Realm Rank 1.
--
-- This is stock OpenDAoC data, not something the conversion introduced. No
-- other migration here touches Realmpoints.
--
-- The values are Hibernia's, not invented: 20 realm points and 25 bounty
-- points, the same pair its four frontier zones already carry. Each realm has
-- exactly four such zones and they are the high zone ids in each homeland
-- region -- 11 to 15 in Albion, 111 to 115 in Midgard, 210 to 214 in
-- Hibernia -- so the eight below are the exact counterparts of the four that
-- already worked.
--
-- Old frontiers only, matching Hibernia. Region 163 is New Frontiers and every
-- zone in it is zero for all three realms; that stays as it is.
--
-- An UPDATE, so re-running changes nothing.

UPDATE zones
   SET Realmpoints = 20,
       Bountypoints = 25
 WHERE (RegionID = 1   AND Name IN ('Forest Sauvage', 'Snowdonia',
                                    'Pennine Mountains', 'Hadrian''s Wall'))
    OR (RegionID = 100 AND Name IN ('Uppland', 'Yggdra Forest',
                                    'Jamtland Mountains', 'Odin''s Gate'));
