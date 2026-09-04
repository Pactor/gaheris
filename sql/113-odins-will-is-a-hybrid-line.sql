-- Odin's Will was the only hybrid melee-caster line in the game not marked as
-- one, and casting from it fired the wrong spell.
--
-- Reported twice from play: casting either of her cone buff-strips -- Vindictive
-- Graze and Valkyrie's Authority -- cast an Odin's Aura instead. Both share
-- their level with another spell (Graze with Odin's Lesser Aura at 17,
-- Authority with Odin's Horn at 19), which is the shape of an index landing
-- one seat away.
--
-- The Valkyrie is a hybrid. ClassValkyrie declares eClassType.Hybrid, exactly
-- as the Thane does. Her healing line, Mending, is marked
-- LiveSpellHybridSpecialization. So is every comparable line in the game:
-- Stormcalling, Battlesongs, Soulrending, Savagery, Chants, Enhancement,
-- Smite, Valor, Nurture, Pacification, Subterranean, Rejuvenation.
--
-- Odin's Will alone had no Implementation, and the default Specialization
-- returns HybridSpellList = false. UpdateUsableListSpells skips hybrid specs
-- and collects the rest, so her damage line was being built and sent as a pure
-- caster's spell list -- a list of every spell she owns -- while the client
-- renders a hybrid class's spells the hybrid way. Two different pictures of
-- the same line, and a cast is only an index into one of them.
--
-- The NULL is not unusual on its own: Mana, Light, Void, Cursing, Suppression
-- and the rest of the list-caster lines all carry it correctly. Odin's Will is
-- the one that does not belong in that company.
--
-- This changes how her spells are presented and granted -- hybrid lines hand
-- out spells by spec level rather than listing every one -- which is what a
-- hybrid is supposed to do and what her own Mending line already did.

UPDATE specialization
   SET Implementation = 'DOL.GS.LiveSpellHybridSpecialization'
 WHERE KeyName = 'Odin''s Will';
