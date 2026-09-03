-- The portal stones become markers, and move into the passage.
--
-- Migration 63 placed them as FrontierPortal NPCs you clicked. The airlock
-- replaced that: you are sent the moment you step into the passage between a
-- border keep's two doors, before you can reach the second switch. So the
-- class is gone and these rows would have failed to instantiate.
--
-- They stay as scenery, because a Frontiers Portal Stone standing in the
-- passage tells you what the passage is. Moved from the keep's centre onto
-- the airlock midpoint so they mark the exact spot that sends you.
--
-- Flag 16 is PEACE and 4 is DONTSHOWNAME -- it is a stone, not a creature.

UPDATE mob SET ClassType = 'DOL.GS.GameNPC', Flags = 20 WHERE PackageID = 'gaheris-portal';

UPDATE mob SET X = 585237, Y = 477238, Z = 2600 WHERE Mob_ID = 'gaheris-portal-sauvage';
UPDATE mob SET X = 528529, Y = 358945, Z = 8320 WHERE Mob_ID = 'gaheris-portal-snowdon';
UPDATE mob SET X = 766188, Y = 669650, Z = 5736 WHERE Mob_ID = 'gaheris-portal-svasud';
UPDATE mob SET X = 704018, Y = 738932, Z = 5704 WHERE Mob_ID = 'gaheris-portal-vindsaul';
UPDATE mob SET X = 334165, Y = 420570, Z = 5336 WHERE Mob_ID = 'gaheris-portal-ligen';
UPDATE mob SET X = 421251, Y = 486389, Z = 1976 WHERE Mob_ID = 'gaheris-portal-cain';
