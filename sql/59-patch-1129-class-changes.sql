-- Patch 1.129 class changes, as far as our data supports them.
--
-- The stun changes are repoints, not edits. Every style stun on this server
-- points at one of a shared ladder of StyleStun spells -- 20401 through
-- 20408, two seconds to ten -- and Two Moons, Anaconda and Kelgor's Wrath all
-- point at the SAME nine second spell, 20407. Editing 20407 to seven seconds
-- would have quietly moved all three and every other style using it. So each
-- style is pointed at the rung it should be on instead.
--
--   Two Moons       9s -> 7s   (Armsman and Paladin, style 114)
--   Sun and Moon    7s -> 9s   (Armsman and Paladin, style 115)
--   Anaconda        9s -> 6s   (Reaver, style 367)
--   Kelgor's Wrath  9s -> 7s   (Savage, style 383)
--
-- Two Moons and Sun and Moon are a straight exchange, which is exactly what
-- the patch describes.

UPDATE stylexspell SET SpellID = 20405 WHERE StyleID = 114 AND SpellID = 20407;
UPDATE stylexspell SET SpellID = 20407 WHERE StyleID = 115 AND SpellID = 20405;
UPDATE stylexspell SET SpellID = 20408 WHERE StyleID = 367 AND SpellID = 20407;
UPDATE stylexspell SET SpellID = 20405 WHERE StyleID = 383 AND SpellID = 20407;

-- Savage evade buffs, 5-25% down to 3-20%.
--
-- Six rungs, and the patch gives the endpoints rather than each value, so the
-- middle four are spaced evenly between them: 3, 6, 10, 13, 17, 20 against
-- the old 5, 9, 13, 17, 21, 25. Endpoints are exact; the interior is
-- interpolated and is the only guessed thing in this file.

UPDATE spell SET Value =  3 WHERE SpellID = 10507;  -- Swiftness of Kelgor
UPDATE spell SET Value =  6 WHERE SpellID = 10508;  -- Alacrity of Kelgor
UPDATE spell SET Value = 10 WHERE SpellID = 10509;  -- Speed of Kelgor
UPDATE spell SET Value = 13 WHERE SpellID = 10510;  -- Fleetness of Kelgor
UPDATE spell SET Value = 17 WHERE SpellID = 10511;  -- Quickness of Kelgor
UPDATE spell SET Value = 20 WHERE SpellID = 10512;  -- Evasion of Kelgor

-- Deliberately NOT applied, and why:
--
--   Cleric/Druid/Shaman heal range 1500 -> 1875. Our heals are already at
--   2000; only seven heal spells on the whole server sit at 1500 and none of
--   them are in those lines. Applying it would be a downgrade.
--
--   Odin's Emendation power cost 25 -> 99. Already 99 here.
--
--   Realm ability reuse timers, Determination costs, Anger of the Gods and
--   the rest. Those live in realm ability handler code in the core, not in
--   any table, and the core is not ours to compile.
