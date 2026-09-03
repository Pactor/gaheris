-- The frontier return stones were invisible.
--
-- Six Frontier Portal Stones stand in New Frontiers on model 2603, which is a
-- static-item model. Item models and mob models are separate spaces: 2603
-- draws a portal stone when it is placed as world scenery and draws nothing at
-- all on a GameNPC. The stones were there, they had names, they could be
-- clicked if you knew where to stand, and nobody could see them.
--
-- This is the third time that distinction has cost us. The task dungeon
-- entrance markers were built on 3543, a rock pile, and were equally invisible
-- for the same reason.
--
-- 2256 is what the Obelisk of Nurizane uses -- seventy-three mobs in this
-- database stand on it -- so it is a standing stone already proven to render
-- on an NPC rather than a model picked because the number looked right.

UPDATE mob SET Model = 2256 WHERE Name = 'Frontier Portal Stone' AND Model = 2603;
