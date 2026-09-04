-- Say which Warlock spells are primary.
--
-- Every one of the thirty-six secondaries carries it in its delve --
-- "Cannot be cast until after a Primary spell has been cast" -- and only nine
-- of the seventy-one primaries do. So the game tells a Warlock what a
-- secondary needs and never tells him which spells provide it. Playing the
-- class means guessing, and the whole mechanic is invisible until somebody
-- happens to click the right two spells in the right order.
--
-- The nine that already say it are left exactly as they are, including their
-- wording -- several read "A Primary chamber spell", which is the delve's own
-- phrasing and not worth normalising away.
--
-- Only the Warlock's own lines are touched. IsPrimary appears on spells
-- belonging to other classes for unrelated reasons, and rewriting their delve
-- would be a change nobody asked for.

UPDATE spell SET Description = CONCAT(Description, ' A Primary spell.')
 WHERE IsPrimary = 1
   AND Description NOT LIKE '%rimary%'
   AND Description NOT LIKE '%econdary%'
   AND SpellID IN (SELECT SpellID FROM linexspell
                    WHERE LineName IN ('Cursing', 'Cursing Spec', 'Hexing', 'Witchcraft'));
