-- Three corrections from the live patch notes.
--
-- Checked one at a time against our own data rather than applied wholesale,
-- and two of the six differences originally listed did not survive that:
--
-- Spectral Force is not a missing Bainshee specialisation. It is a BASELINE
-- line whose spec is Spectral Guard, which she has, so its thirty spells were
-- always reachable. The audit misread the structure.
--
-- Summon Bone Spellbinder cannot be corrected here. It exists in no data we
-- hold -- not this database, not the reference dump -- so restoring it would
-- mean inventing a spell rather than fixing one, and that is a different kind
-- of change. Left alone deliberately.
--
-- The pet scare cast times are also left alone. Live reduced them from 5.0 to
-- 3.5 seconds; ours already cast in 2, so applying the patch would make them
-- slower rather than faster.

-- 1.129: Alarming Screech moved from Ethereal Shriek to Spectral Force at 26.
--
-- Ours had it on Phantasmal Wail at 18, so it is wrong on both counts and in
-- both directions -- the wrong line and eight levels early.
UPDATE linexspell SET LineName = 'Spectral Force', Level = 26
 WHERE SpellID = (SELECT SpellID FROM spell WHERE Name = 'Alarming Screech' LIMIT 1);

-- 1.129: Summon Bone Deadeye moved to level 21.
--
-- The patch names the Bone Legion line and we have no line by that name --
-- ours is Bone Warriors, under the Bone Army spec -- so the line is left as
-- it is and only the level is corrected. Ours had it at 45, which is a long
-- way from 21 whichever line it sits on.
UPDATE linexspell SET Level = 21
 WHERE SpellID = (SELECT SpellID FROM spell WHERE Name = 'Summon Bone Deadeye' LIMIT 1);

-- 1.129: Purifying Rain cast time reduced from 5.0 to 3.0 seconds.
UPDATE spell SET CastTime = 3 WHERE Name = 'Purifying Rain';
