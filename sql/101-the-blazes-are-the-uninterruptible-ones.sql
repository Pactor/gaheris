-- The three Blazes are the Heretic's uninterruptible focus spells.
--
-- Arawn's Fire holds two kinds of channelled damage: the Arawn's line, which
-- anything can break, and lower-damage versions that hold through ranged
-- attacks. We have both -- the second kind is Glistening, Whirling and
-- Torrential Blaze -- but nothing marked them as such, so a Heretic had two
-- lines of identical spells and no reason to prefer either.
--
-- From the 1.616 spell data, which matches our damage values exactly:
--
--   36  Glistening Blaze   90/pulse   33s   1500
--   42  Whirling Blaze    104/pulse   33s   1500
--   48  Torrential Blaze  120/pulse   33s   1500
--
-- Ours carry the right damage and the wrong duration -- fifteen seconds
-- against thirty-three -- and no uninterruptible flag at all. Both corrected.
--
-- The longer duration is the point of them as much as the flag is: they are
-- the spells for a fight you expect to be shot at during, so they need to
-- outlast the shooting.

UPDATE spell SET Uninterruptible = 1, Duration = 33
 WHERE Name IN ('Glistening Blaze', 'Whirling Blaze', 'Torrential Blaze')
   AND Type = 'HereticDamageOverTime';
