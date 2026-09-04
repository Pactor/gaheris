-- Server properties renamed to match what they actually configure.
--
-- Eight of the twelve gaheris_* properties were never about Gaheris. The
-- Heretic's ramp, the Bainshee's log, the power a Vampiir or Mauler draws from
-- a fight, the champion and master level curves, realm rank fifteen -- those
-- belong to a class or to a progression system, and any server running that
-- content wants them under a name that says so.
--
-- The four that stay are the ones that really are this server's ruleset:
-- gaheris_atlantis, gaheris_log_buffs, gaheris_no_base_classes and
-- gaheris_starting_level.
--
-- Renaming rather than re-creating, so the values already set are kept. The
-- Key column is the primary key, so an UPDATE moves the row intact -- a fresh
-- boot would otherwise create the new key at its default and strand the old
-- one holding the setting you actually chose.
--
-- Category moves with it, which is what groups them in /serverproperties.

UPDATE serverproperty SET `Key` = 'heretic_ramp_per_pulse', Category = 'catacombs'
 WHERE `Key` = 'gaheris_heretic_ramp_per_pulse';
UPDATE serverproperty SET `Key` = 'heretic_ramp_cap', Category = 'catacombs'
 WHERE `Key` = 'gaheris_heretic_ramp_cap';
UPDATE serverproperty SET `Key` = 'heretic_log', Category = 'catacombs'
 WHERE `Key` = 'gaheris_log_heretic';
UPDATE serverproperty SET `Key` = 'bainshee_log', Category = 'catacombs'
 WHERE `Key` = 'gaheris_log_bainshee';
UPDATE serverproperty SET `Key` = 'combat_power_rate', Category = 'classes'
 WHERE `Key` = 'gaheris_vampiir_power_rate';
UPDATE serverproperty SET `Key` = 'cl_xp_per_level', Category = 'progression'
 WHERE `Key` = 'gaheris_cl_xp_per_level';
UPDATE serverproperty SET `Key` = 'ml_xp_per_level', Category = 'progression'
 WHERE `Key` = 'gaheris_ml_xp_per_level';
UPDATE serverproperty SET `Key` = 'max_realm_level', Category = 'progression'
 WHERE `Key` = 'gaheris_max_realm_level';
