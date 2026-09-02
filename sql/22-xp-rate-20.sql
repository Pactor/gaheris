-- ===========================================================================
--  22-xp-rate-20.sql
--
--  Experience doubled again: 10x to 20x, in the open world and in RvR zones
--  alike.
--
--  The reason is specific rather than general. Atlantis is level 50 content
--  and the Master Levels are gated on 50, so everything imported for it --
--  41,727 mobs, 64 ML spells across eight paths, thirteen destinations -- is
--  unreachable until somebody actually gets there. Twenty times gets a
--  character to the content it was built for in an evening rather than a
--  fortnight.
--
--  Both rates move together on purpose. GamePlayer.GainExperience picks ONE
--  of them:
--
--      if (CurrentRegion.IsRvR || CurrentZone.IsRvR)
--          baseXp *= RvR_XP_RATE;
--      else
--          baseXp *= XP_RATE;
--
--  so leaving rvr_zones_xp_rate behind would quietly halve the rate in
--  Darkness Falls, the frontiers and every battleground -- which is where the
--  keeps are, and the keeps are the content.
--
--  Read at boot: needs a restart. Safe to re-run (both values are absolute).
-- ===========================================================================

SET NAMES utf8mb4;
SET SESSION sql_mode='';

UPDATE `serverproperty` SET `Value` = '20' WHERE `Key` = 'xp_rate';
UPDATE `serverproperty` SET `Value` = '20' WHERE `Key` = 'rvr_zones_xp_rate';

-- ---------------------------------------------------------------------------
-- Check
-- ---------------------------------------------------------------------------
SELECT `Key`, `Value` FROM `serverproperty`
 WHERE `Key` IN ('xp_rate', 'rvr_zones_xp_rate', 'cl_xp_rate');
