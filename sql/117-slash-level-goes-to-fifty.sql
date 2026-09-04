-- /level now carries a character to 50 rather than 20.
--
-- The command itself already reads this and needs no change: it takes
-- SLASH_LEVEL_TARGET, refuses anything outside 1 to 50, hands over exactly the
-- experience for that level and then sets the level so every OnLevelUp fires.
-- 50 is inside its own bounds, so this is the whole of it.
--
-- Why: classes are being checked at the level their spells actually exist.
-- Focus Shell is 41 on a Healer, 46 on a Cleric, 47 on a Druid; the Master
-- Level and champion work needs 50. Levelling each test character by hand is
-- time spent proving nothing.
--
-- The other two guards are deliberately left alone. slash_level_requirement
-- still asks for a level 50 somewhere on the account, so this is not a free
-- fifty for a brand new account, and allow_cata_slash_level is already true so
-- the Catacombs classes -- the ones most in need of testing -- can use it.

UPDATE serverproperty
   SET Value = '50'
 WHERE `Key` = 'slash_level_target';
