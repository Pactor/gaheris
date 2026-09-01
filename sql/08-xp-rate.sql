-- ===========================================================================
--  gaheris-rates.sql
--
--  Experience rate.
--
--  Gaheris is co-operative PvE built around keeps, and the keeps are the
--  content. Grinding 5 to 50 solo before any of it opens up is a toll, not a
--  game. This raises the rate so a character reaches the frontier in an
--  evening rather than a fortnight.
--
--  The rate is applied in GamePlayer.GainExperience, AFTER the per-kill cap in
--  NpcKillRewardProcessor, so the multiplier is not clipped by XP_Cap_Percent
--  and that property is left alone.
--
--  Read at boot: needs a restart. Safe to re-run.
-- ===========================================================================

SET NAMES utf8mb4;
SET SESSION sql_mode='';

UPDATE `serverproperty` SET `Value` = '10' WHERE `Key` = 'xp_rate';

INSERT INTO `serverproperty` (`ServerProperty_ID`, `Category`, `Key`, `Description`, `DefaultValue`, `Value`)
SELECT UUID(), 'rates', 'xp_rate',
       'The Experience Points Rate Modifier', '1.0', '10'
WHERE NOT EXISTS (SELECT 1 FROM `serverproperty` WHERE `Key` = 'xp_rate');

SELECT `Key`, `DefaultValue`, `Value` FROM `serverproperty`
WHERE `Key` IN ('xp_rate','starting_level','XP_Cap_Percent');
