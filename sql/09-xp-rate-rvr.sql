-- ===========================================================================
--  gaheris-rvr-xp.sql
--
--  Bring the RvR-zone experience rate in line with the open world.
--
--  GamePlayer.GainExperience picks ONE of the two rates:
--
--      if (CurrentRegion.IsRvR || CurrentZone.IsRvR)
--          baseXp *= RvR_XP_RATE;      -- was 1.0
--      else
--          baseXp *= XP_RATE;          -- 10
--
--  Instead of, not on top of. So raising xp_rate alone left every RvR zone --
--  Darkness Falls included -- paying a tenth of what the open world pays. On a
--  co-operative PvE server where the frontier and its dungeons are the whole
--  point, that is exactly backwards.
--
--  Matched rather than boosted: the dungeon camp bonus already pays extra on
--  top, which is what should make Darkness Falls worth the trip.
--
--  Read at boot: needs a restart. Safe to re-run.
-- ===========================================================================

SET NAMES utf8mb4;
SET SESSION sql_mode='';

UPDATE `serverproperty` SET `Value` = '10' WHERE `Key` = 'rvr_zones_xp_rate';

INSERT INTO `serverproperty` (`ServerProperty_ID`, `Category`, `Key`, `Description`, `DefaultValue`, `Value`)
SELECT UUID(), 'rates', 'rvr_zones_xp_rate', 'The RvR zones Experience Points Rate Modifier', '1.0', '10'
WHERE NOT EXISTS (SELECT 1 FROM `serverproperty` WHERE `Key` = 'rvr_zones_xp_rate');

SELECT `Key`, `DefaultValue`, `Value` FROM `serverproperty`
WHERE `Key` IN ('xp_rate','rvr_zones_xp_rate','starting_level');
