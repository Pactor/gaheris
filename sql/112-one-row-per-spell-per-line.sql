-- Casting one spell fired a different one, because a line listed a spell twice.
--
-- Reported from play: casting Vindictive Graze cast Odin's Lesser Aura.
--
-- The client does not send a spell id when you cast. It sends a position in
-- the list the server gave it. So if the two lists disagree by even one entry,
-- every spell after the disagreement casts its neighbour.
--
-- Odin's Will listed Odin's Minor Aura twice at level 8. Count the line in
-- server order and Vindictive Graze is the thirteenth entry; count it once,
-- as the client does, and the thirteenth is Odin's Lesser Aura. One surplus
-- row, one seat of drift, and every spell past level 8 casting the one before
-- it.
--
-- Six spells were doubled in that line alone -- Odin's Minor Aura, Odin's
-- Aura, Vindictive Nip, Valkyrie's Command, Odin's Full Aura and Valkyrie's
-- Dominance -- so the drift grew as she levelled.
--
-- It is not confined to her. 45 groups across the database carry 260 surplus
-- rows, most of them in Dragon Magic (216) and Combat Style Effects (20).
-- Every one of those lines has the same fault waiting, so all of them are
-- cleared here rather than only hers. A spell listed twice at the same level
-- in the same line cannot mean anything; there is no reading of this table
-- where the second row is wanted.
--
-- Vindictive Bite is a separate slip: listed at 47 and again at 49. The
-- Vindictive progression is Graze 17, Laceration 27, Nip 37, Bite 47, and the
-- 49 belongs to Valkyrie's Dominance, which is already there. The 49 row goes.

-- One row per spell per level per line, keeping the earliest by id.
DELETE x FROM linexspell x
JOIN (
  SELECT MIN(LineXSpell_ID) AS keep_id, LineName, SpellID, Level
  FROM linexspell
  GROUP BY LineName, SpellID, Level
  HAVING COUNT(*) > 1
) dupe
  ON  dupe.LineName = x.LineName
  AND dupe.SpellID  = x.SpellID
  AND dupe.Level    = x.Level
WHERE x.LineXSpell_ID <> dupe.keep_id;

-- Vindictive Bite belongs at 47 only.
DELETE FROM linexspell
 WHERE LineName = 'Odin''s Will' AND SpellID = 12531 AND Level = 49;
