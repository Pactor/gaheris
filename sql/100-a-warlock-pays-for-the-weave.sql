-- A Warlock's primary spells cast slowly. That is what pays for the weave.
--
-- "Warlock Primary spells take about twice as long to cast as regular spells
-- in the game -- however, anytime the Warlock casts a primary spell, they can
-- (at no cost) add in a secondary spell that will land at the same time as
-- the primary."
--
-- The second half of that is built. The first half was not, and was not in
-- the data either. Comparing our own numbers against every other class shows
-- Warlock primaries casting at ordinary speed, and in three of five spell
-- types slightly FASTER than the average: bolts at 2.5 against 2.48, roots at
-- 2.0 against 2.45, lifedrains at 2.5 against 2.74. Nothing had been
-- pre-doubled, so this is a real change and not a correction.
--
-- Done in the data rather than at runtime for two reasons. The casting time
-- is calculated per spell handler and there is no single place a script can
-- reach to alter it. And a player judging this class needs to SEE what the
-- weave costs -- a delve that says 2.5 seconds while the cast takes 5 would
-- be worse than not doing it at all.
--
-- Absolute values rather than a multiply, so running this twice cannot double
-- anything twice. 71 spells, each written as its own doubled figure.
--
-- Only primaries. The 46 plain spells a Warlock casts like anybody else are
-- untouched, and so are the primers -- they carry their own cast times, three
-- to five seconds, and those already are the price of what they do.
--
-- To undo: halve these values. The originals are the second number in each
-- comment.

UPDATE spell SET CastTime = 5.2 WHERE SpellID = 12001;  -- Minor Annulling Curse, was 2.6
UPDATE spell SET CastTime = 5.2 WHERE SpellID = 12002;  -- Annulling Curse, was 2.6
UPDATE spell SET CastTime = 5.2 WHERE SpellID = 12003;  -- Minor Consuming Curse, was 2.6
UPDATE spell SET CastTime = 5.2 WHERE SpellID = 12004;  -- Consuming Curse, was 2.6
UPDATE spell SET CastTime = 5.2 WHERE SpellID = 12005;  -- Major Consuming Curse, was 2.6
UPDATE spell SET CastTime = 5.2 WHERE SpellID = 12006;  -- Minor Dismantling Curse, was 2.6
UPDATE spell SET CastTime = 5.2 WHERE SpellID = 12007;  -- Dismantling Curse, was 2.6
UPDATE spell SET CastTime = 5.2 WHERE SpellID = 12008;  -- Major Dismantling Curse, was 2.6
UPDATE spell SET CastTime = 5.2 WHERE SpellID = 12009;  -- Minor Crushing Curse, was 2.6
UPDATE spell SET CastTime = 5.2 WHERE SpellID = 12010;  -- Minor Crushing Curse, was 2.6
UPDATE spell SET CastTime = 5.2 WHERE SpellID = 12011;  -- Major Crushing Curse, was 2.6
UPDATE spell SET CastTime = 5 WHERE SpellID = 12015;  -- Cursed Blast, was 2.5
UPDATE spell SET CastTime = 5 WHERE SpellID = 12016;  -- Cursed Burst, was 2.5
UPDATE spell SET CastTime = 5 WHERE SpellID = 12017;  -- Cursed Explosion, was 2.5
UPDATE spell SET CastTime = 5 WHERE SpellID = 12018;  -- Cursed Mortar, was 2.5
UPDATE spell SET CastTime = 5 WHERE SpellID = 12019;  -- Cursed Bomb, was 2.5
UPDATE spell SET CastTime = 5 WHERE SpellID = 12020;  -- Cursed Ruination, was 2.5
UPDATE spell SET CastTime = 5 WHERE SpellID = 12021;  -- Cursed Destruction, was 2.5
UPDATE spell SET CastTime = 5 WHERE SpellID = 12022;  -- Cursed Devastation, was 2.5
UPDATE spell SET CastTime = 5 WHERE SpellID = 12023;  -- Cursed Annihilation, was 2.5
UPDATE spell SET CastTime = 8 WHERE SpellID = 12052;  -- Curse of Hurt, was 4
UPDATE spell SET CastTime = 8 WHERE SpellID = 12053;  -- Curse of Pain, was 4
UPDATE spell SET CastTime = 8 WHERE SpellID = 12054;  -- Curse of Detriment, was 4
UPDATE spell SET CastTime = 8 WHERE SpellID = 12056;  -- Curse of Ruin, was 4
UPDATE spell SET CastTime = 8 WHERE SpellID = 12057;  -- Curse of Peril, was 4
UPDATE spell SET CastTime = 8 WHERE SpellID = 12058;  -- Curse of Devastation, was 4
UPDATE spell SET CastTime = 8 WHERE SpellID = 12059;  -- Curse of Disaster, was 4
UPDATE spell SET CastTime = 5.6 WHERE SpellID = 12060;  -- Curse of Death, was 2.8
UPDATE spell SET CastTime = 5 WHERE SpellID = 12065;  -- Lesser Bolt of Ruin, was 2.5
UPDATE spell SET CastTime = 5 WHERE SpellID = 12066;  -- Greater Bolt of Ruin, was 2.5
UPDATE spell SET CastTime = 5 WHERE SpellID = 12067;  -- Lesser Bolt of Havoc, was 2.5
UPDATE spell SET CastTime = 5 WHERE SpellID = 12068;  -- Greater Bolt of Havoc, was 2.5
UPDATE spell SET CastTime = 5 WHERE SpellID = 12069;  -- Lesser Bolt of Destruction, was 2.5
UPDATE spell SET CastTime = 5 WHERE SpellID = 12070;  -- Bolt of Destruction, was 2.5
UPDATE spell SET CastTime = 5 WHERE SpellID = 12071;  -- Greater Bolt of Destruction, was 2.5
UPDATE spell SET CastTime = 5 WHERE SpellID = 12072;  -- Lesser Bolt of Death, was 2.5
UPDATE spell SET CastTime = 5 WHERE SpellID = 12073;  -- Bolt of Death, was 2.5
UPDATE spell SET CastTime = 5 WHERE SpellID = 12074;  -- Greater Bolt of Death, was 2.5
UPDATE spell SET CastTime = 6.4 WHERE SpellID = 12075;  -- Spell of Minor Mending, was 3.2
UPDATE spell SET CastTime = 6.2 WHERE SpellID = 12076;  -- Spell of Mending, was 3.1
UPDATE spell SET CastTime = 6 WHERE SpellID = 12077;  -- Spell of Greater Mending, was 3
UPDATE spell SET CastTime = 6 WHERE SpellID = 12078;  -- Spell of Minor Renewal, was 3
UPDATE spell SET CastTime = 5.8 WHERE SpellID = 12079;  -- Spell of Renewal, was 2.9
UPDATE spell SET CastTime = 5.6 WHERE SpellID = 12080;  -- Spell of Greater Renewal, was 2.8
UPDATE spell SET CastTime = 5.4 WHERE SpellID = 12081;  -- Spell of Minor Healing, was 2.7
UPDATE spell SET CastTime = 5.2 WHERE SpellID = 12082;  -- Spell of Healing, was 2.6
UPDATE spell SET CastTime = 5 WHERE SpellID = 12083;  -- Spell of Greater Healing, was 2.5
UPDATE spell SET CastTime = 4 WHERE SpellID = 12084;  -- Hexed Clutching Root, was 2
UPDATE spell SET CastTime = 4 WHERE SpellID = 12085;  -- Hexed Grasping Root, was 2
UPDATE spell SET CastTime = 4 WHERE SpellID = 12086;  -- Hexed Bonding Root, was 2
UPDATE spell SET CastTime = 4 WHERE SpellID = 12087;  -- Hexed Webbing Root, was 2
UPDATE spell SET CastTime = 4 WHERE SpellID = 12088;  -- Hexed Clutching Root, was 2
UPDATE spell SET CastTime = 4 WHERE SpellID = 12089;  -- Hexed Holding Root, was 2
UPDATE spell SET CastTime = 4 WHERE SpellID = 12090;  -- Hexed Tangling Root, was 2
UPDATE spell SET CastTime = 4 WHERE SpellID = 12091;  -- Hexed Tenacious Root, was 2
UPDATE spell SET CastTime = 4 WHERE SpellID = 12092;  -- Hexed Detaining Root, was 2
UPDATE spell SET CastTime = 5 WHERE SpellID = 12184;  -- Molding Hex, was 2.5
UPDATE spell SET CastTime = 5 WHERE SpellID = 12185;  -- Rotting Hex, was 2.5
UPDATE spell SET CastTime = 5 WHERE SpellID = 12186;  -- Dissolving Hex, was 2.5
UPDATE spell SET CastTime = 5 WHERE SpellID = 12187;  -- Decaying Hex, was 2.5
UPDATE spell SET CastTime = 5 WHERE SpellID = 12188;  -- Decomposing Hex, was 2.5
UPDATE spell SET CastTime = 5 WHERE SpellID = 12189;  -- Polluting Hex, was 2.5
UPDATE spell SET CastTime = 5 WHERE SpellID = 12190;  -- Corrupting Hex, was 2.5
UPDATE spell SET CastTime = 5 WHERE SpellID = 12191;  -- Putrifying Hex, was 2.5
UPDATE spell SET CastTime = 4 WHERE SpellID = 12192;  -- Lesser Bolt of Mending, was 2
UPDATE spell SET CastTime = 4 WHERE SpellID = 12193;  -- Bolt of Mending, was 2
UPDATE spell SET CastTime = 4 WHERE SpellID = 12194;  -- Lesser Bolt of Renewal, was 2
UPDATE spell SET CastTime = 4 WHERE SpellID = 12195;  -- Bolt of Renewal, was 2
UPDATE spell SET CastTime = 4 WHERE SpellID = 12196;  -- Lesser Bolt of Healing, was 2
UPDATE spell SET CastTime = 4 WHERE SpellID = 12197;  -- Bolt of Healing, was 2
UPDATE spell SET CastTime = 4 WHERE SpellID = 12198;  -- Greater Bolt of Healing, was 2
