-- The Warlock has no Quickcast, and is the one class that provably should.
--
-- Twelve list casters carry CharacterQuickcastUserCareer, which is what grants
-- the QuickCast ability. The Warlock is not among them, here or in the
-- reference dump, so this is a gap in the source data rather than something
-- lost along the way.
--
-- The core settles it. ClassWarlock is the ONLY class in the entire server
-- whose code mentions Quickcast at all, and it exists purely to say which of
-- his spells it may not be used on:
--
--     public override bool CanChangeCastingSpeed(SpellLine line, Spell spell)
--     {
--         if (spell.SpellType == eSpellType.Chamber)
--             return false;
--         if ((line.KeyName == "Cursing" || ... "Witchcraft") && ...)
--             return false;
--         return true;
--     }
--
-- Chambers are excluded, and so is most of his own casting, with a careful
-- list of exceptions -- the armour factor buff, bladeturn, absorption, the
-- matter debuff, the uninterruptable and range and powerless spells, and the
-- eight named curses. That override is meaningless on a class that cannot
-- quickcast in the first place. It was written for one that can.
--
-- The Necromancer is also absent from the list and is deliberately left that
-- way: nothing in the core speaks to it either way, its spells are cast
-- through the pet, and a guess would be a guess.

INSERT INTO classxspecialization (ClassID, SpecKeyName, LevelAcquired, LastTimeRowUpdated)
SELECT 59, 'CharacterQuickcastUserCareer', -100, '2000-01-01 00:00:00'
 WHERE NOT EXISTS (SELECT 1 FROM classxspecialization
                    WHERE ClassID = 59 AND SpecKeyName = 'CharacterQuickcastUserCareer');
