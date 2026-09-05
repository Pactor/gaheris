-- Give the piercing classes something they can actually swing.
--
-- A new Vampiir could not enter combat, and the reason was in its hands. The
-- only weapon in its starter kit is training_dirk, which is
--
--     Item_Type 11, Object_Type 21, Hand 2
--
-- Hand 2 means left hand only -- an off-hand weapon for a dual wielder. The
-- creation code puts it in the right hand because the right hand is free, and
-- a left-hand-only weapon held in the right hand is not something that can be
-- drawn. The class had the piercing proficiency, the weapon, and no way to
-- use it.
--
-- Our data matches the reference exactly here, so this is not a corrupted
-- row: the starter kit was simply written for the classes that dual wield.
-- That row covers Stalker, Nightshade, Ranger and Vampiir, and only the first
-- three have an off hand to put a dirk in. All four were starting with an
-- empty main hand; the other three could at least train dual wield out of it.
--
-- So: a plain dagger -- right hand, Hand 0, piercing, level 2, Hibernia -- for
-- Nightshade, Ranger and Vampiir. The Nightshade and Ranger keep the dirk as
-- the off-hand weapon it was meant to be. The Vampiir does not, because it has
-- no off hand.

INSERT INTO starterequipment (StarterEquipmentID, Class, TemplateID, LastTimeRowUpdated)
VALUES (9101, '49;50;58;', 'dagger', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `StarterEquipmentID` = `StarterEquipmentID`;

UPDATE starterequipment SET Class = '54;49;50;'
 WHERE TemplateID = 'training_dirk' AND Class = '54;49;50;58;';
