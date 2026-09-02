-- Region 163 (New Frontiers) has 0 mobs and 0 keeps in this database: we have
-- never activated it. The travel catalogue was offering 15 destinations there,
-- every one of which drops the player into an empty world -- no keeps, no
-- guards, nothing to do but teleport out again.
--
-- Remove them until New Frontiers is actually populated.
DELETE FROM teleport WHERE Type = 'gaheris' AND RegionID = 163;
