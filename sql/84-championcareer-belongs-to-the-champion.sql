-- ChampionCareer belongs to the Champion, not to everyone.
--
-- Every class on this server carried ChampionCareer, all forty-seven of them.
-- That career grants HibArmor, Weaponry: Large Weapons and Shield at spec
-- level one, so every class was handed a Hibernia Champion's kit -- which is
-- why a Vampiir came up holding Large Weapons and a Shield and could not
-- equip the piercing weapon it is the only class to use.
--
-- In the reference database ChampionCareer belongs to exactly one class:
-- 45, the Hibernia Champion. Ours had it on all of them, almost certainly
-- from confusing this career with the champion LEVEL system, which is a
-- different thing entirely and lives in the "Champion Level <realm>" specs.
--
-- The master level paths are left alone deliberately. Banelord, Battlemaster,
-- Convoker, Perfecter, Sojourner, Spymaster, Stormlord and Warlord are on all
-- 62 here against three to twenty-two in the reference, and that is ours on
-- purpose: every class can walk every path on Gaheris.

DELETE FROM classxspecialization
 WHERE SpecKeyName = 'ChampionCareer' AND ClassID <> 45;
