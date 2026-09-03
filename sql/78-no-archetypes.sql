-- Be the class you chose.
--
-- The core ships a startup script, StartAsBaseClass, that hooks
-- DatabaseEvent.CharacterCreated and rewrites the class after the character
-- has already been validated and accepted:
--
--     var chClass = ScriptMgr.FindCharacterBaseClass(ch.Class);
--     if (chClass != null && chClass.ID != ch.Class)
--         ch.Class = chClass.ID;
--
-- It is on by default. That is why the log showed the client sending class 58,
-- Vampiir, and the database holding 54, Stalker, with no warning anywhere in
-- between: nothing was rejected, the class was simply changed afterwards.
--
-- Live retired archetypes years ago. Off.

UPDATE serverproperty SET Value = 'False' WHERE `Key` = 'start_as_base_class';
