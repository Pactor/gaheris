-- The Bainshee's point blank aura cannot be interrupted.
--
-- Phantasmal Wail is the point blank spec, and its seven pulsing auras are
-- the line's whole reason to exist: Shrill Aura at 1 through Sonorous Aura at
-- 46, damage every beat to everything within 250 units, 350 at the top two.
--
-- The class library is explicit that the line carries an uninterruptible
-- point blank pulse and uninterruptible roots. All seven of ours carry
-- Uninterruptible = 0, which makes an aura that anything can stop -- and a
-- Bainshee standing in the middle of a fight, which is where a point blank
-- spec has to stand, is being hit by definition.
--
-- That is the same fault the Heretic's Blazes had in migration 101: the right
-- spells, the right damage, and no flag saying what kind of spell they were.
--
-- Uninterruptible is not the same as unstoppable. Moving still ends it and so
-- does dying -- see GaherisBainsheeAura, which is what makes either of those
-- work at all. This is only about being hit while she holds it.

UPDATE spell SET Uninterruptible = 1
 WHERE Type = 'BainsheePulseDmg'
   AND Name IN ('Shrill Aura', 'Undulating Aura', 'Resonating Aura',
                'Oscillating Aura', 'Intonating Aura', 'Reverberating Aura',
                'Sonorous Aura');
