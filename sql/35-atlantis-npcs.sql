-- The Atlantis NPCs that were standing there doing nothing.

-- 1. The Arbiter.
--
-- On live you spoke to him once and you were on the Master Level path. Here
-- DOL.GS.Arbiter inherits Researcher, which has no Interact of its own, and
-- Arbiter's own Interact prints two lines of flavour text and returns. In the
-- whole of OpenDAoC exactly one thing sets MLGranted and it is the GM command
-- /player startml -- the trials were never implemented. So every scholar past
-- him sits waiting on a flag nobody ever sets, which is why they will not
-- speak to you.
--
-- GaherisArbiter subclasses the core Arbiter, keeps his welcome text, and
-- enrols the player and every group member within 2000 units. A raid entrance
-- that admits one person at a time is not much use on a co-operative server.
UPDATE mob
   SET ClassType = 'DOL.GS.Scripts.GaherisArbiter'
 WHERE Name = 'Arbiter'
   AND ClassType = 'DOL.GS.Arbiter';

-- 2. Aphaestia in region 72.
--
-- Her counterparts in 70 and 71 are ArtifactCreditMerchants stocked from the
-- artifact_credits list, 62 items. This one was left a bare GameBountyMerchant
-- with a NULL ItemsListTemplateID, so she offered an empty window.
UPDATE mob
   SET ClassType = 'DOL.GS.ArtifactCreditMerchant',
       ItemsListTemplateID = 'artifact_credits'
 WHERE Name = 'Aphaestia'
   AND (ItemsListTemplateID IS NULL OR ItemsListTemplateID = '');

-- 3. Zosyne and Mnosus.
--
-- Both had a NULL ItemsListTemplateID in every region they appear, and the
-- pair in region 70 were not merchants at all -- plain DOL.GS.GameNPC. There
-- was no scroll list anywhere in the database for them to sell from, which is
-- the whole of why they had no scrolls.
--
-- They sell for bounty points, the same currency Demyphon takes for Master
-- Level credits and Aphaestia for artifact credits.
--
-- Be aware of what is behind them. We hold 57 artifacts and complete 3-of-3
-- scroll sets for four of them: Egg of Youth, Great Hunt, Oglidarsh's Scrolls
-- and Ring of Fire. The other scroll rows in itemtemplate are quest scrolls,
-- not artifact scrolls. So this stocks them with everything real that exists
-- and no further; the missing 53 sets are absent data, not a wiring problem,
-- and buying credit from Aphaestia remains the route to the rest.
DELETE FROM merchantitem WHERE ItemListID = 'artifact_scrolls';

INSERT INTO merchantitem (MerchantItem_ID, ItemListID, ItemTemplateID, PageNumber, SlotPosition, LastTimeRowUpdated) VALUES
 (UUID(), 'artifact_scrolls', 'Egg_of_Youth,_Scroll_1_of_3',  0, 0, '2000-01-01 00:00:00'),
 (UUID(), 'artifact_scrolls', 'Egg_of_Youth,_Scroll_2_of_3',  0, 1, '2000-01-01 00:00:00'),
 (UUID(), 'artifact_scrolls', 'Egg_of_Youth,_Scroll_3_of_3',  0, 2, '2000-01-01 00:00:00'),
 (UUID(), 'artifact_scrolls', 'Great_Hunt,_scroll_1_of_3',    0, 4, '2000-01-01 00:00:00'),
 (UUID(), 'artifact_scrolls', 'Great_Hunt,_scroll_2_of_3',    0, 5, '2000-01-01 00:00:00'),
 (UUID(), 'artifact_scrolls', 'Great_Hunt,_scroll_3_of_3',    0, 6, '2000-01-01 00:00:00'),
 (UUID(), 'artifact_scrolls', 'Oglidarshs_Scrolls,_1_of_3',   0, 8, '2000-01-01 00:00:00'),
 (UUID(), 'artifact_scrolls', 'Oglidarshs_Scrolls,_2_of_3',   0, 9, '2000-01-01 00:00:00'),
 (UUID(), 'artifact_scrolls', 'Oglidarshs_Scrolls,_3_of_3',   0, 10, '2000-01-01 00:00:00'),
 (UUID(), 'artifact_scrolls', 'Ring_of_Fire,_Scroll_1_of_3',  0, 12, '2000-01-01 00:00:00'),
 (UUID(), 'artifact_scrolls', 'Ring_of_Fire,_Scroll_2_of_3',  0, 13, '2000-01-01 00:00:00'),
 (UUID(), 'artifact_scrolls', 'Ring_of_Fire,_Scroll_3_of_3',  0, 14, '2000-01-01 00:00:00');

UPDATE mob
   SET ClassType = 'DOL.GS.GameBountyMerchant',
       ItemsListTemplateID = 'artifact_scrolls'
 WHERE Name IN ('Zosyne', 'Mnosus');

-- 4. Demyphon in region 72, the same omission as Aphaestia. His counterparts
-- in 70 and 71 are MasterLevelsMerchants selling the eleven Master Level
-- credit and respec tokens for bounty points; this one was a bare
-- GameAtlanteanGlassMerchant with nothing to sell.
UPDATE mob
   SET ClassType = 'DOL.GS.Scripts.MasterLevelsMerchant',
       ItemsListTemplateID = 'Master Level Credits'
 WHERE Name = 'Demyphon'
   AND (ItemsListTemplateID IS NULL OR ItemsListTemplateID = '');
