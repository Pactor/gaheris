-- The Vampiir's bolt, and the abilities that make it a Vampiir.
--
-- Vampiir Bolt did nothing. The ability was present and the core's handler
-- registers itself against it, so the click was reaching code -- but that
-- handler casts by number:
--
--     public override int SpellID => 13200 + m_ability.Level;
--
-- and spells 13200 to 13207 do not exist here. Eight VampiirBolt spells,
-- Leeching through Devouring, imported.
--
-- With them, the four stat abilities the class is built around. Vampiir
-- Strength, Quickness, Dexterity and Constitution were missing from the
-- ability table entirely, each with a real handler waiting in the core --
-- DOL.GS.SkillHandler.VampiirStrength and its siblings. Only five abilities
-- were missing on this whole server and four of them were these.
--
-- Part 1: the bolts themselves.

INSERT INTO `spell` (`Spell_ID`,`SpellID`,`ClientEffect`,`Icon`,`Name`,`Description`,`Target`,`Range`,`Power`,`CastTime`,`Damage`,`DamageType`,`Type`,`Duration`,`Frequency`,`Pulse`,`PulsePower`,`Radius`,`RecastDelay`,`ResurrectHealth`,`ResurrectMana`,`Value`,`Concentration`,`LifeDrainReturn`,`AmnesiaChance`,`Message1`,`Message2`,`Message3`,`Message4`,`InstrumentRequirement`,`SpellGroup`,`EffectGroup`,`SubSpellID`,`MoveCast`,`Uninterruptible`,`IsPrimary`,`IsSecondary`,`AllowBolt`,`SharedTimerGroup`,`PackageID`,`IsFocus`,`TooltipId`,`LastTimeRowUpdated`) VALUES
(UUID(),13200,13200,13200,'Leeching Bolt','Damages the target. A portion of damage is returned as power to the caster. This is limited by the target''s level.','Enemy',1875,0,0,0,0,'VampiirBolt',0,0,0,0,0,30,0,0,5,0,0,0,'','','','',0,0,0,0,1,0,0,0,0,15,'Vampiir',0,5400,'2000-01-01 00:00:00'),
(UUID(),13201,13201,13201,'Gorging Bolt','Damages the target. A portion of damage is returned as power to the caster. This is limited by the target''s level.','Enemy',1875,0,0,0,0,'VampiirBolt',0,0,0,0,0,30,0,0,10,0,0,0,'','','','',0,0,0,0,1,0,0,0,0,15,'Vampiir',0,5401,'2000-01-01 00:00:00'),
(UUID(),13202,13202,13202,'Abating Bolt','Damages the target. A portion of damage is returned as power to the caster. This is limited by the target''s level.','Enemy',1875,0,0,0,0,'VampiirBolt',0,0,0,0,0,30,0,0,20,0,0,0,'','','','',0,0,0,0,1,0,0,0,0,15,'Vampiir',0,5402,'2000-01-01 00:00:00'),
(UUID(),13203,13203,13203,'Draining Bolt','Damages the target. A portion of damage is returned as power to the caster. This is limited by the target''s level.','Enemy',1875,0,0,0,0,'VampiirBolt',0,0,0,0,0,30,0,0,30,0,0,0,'','','','',0,0,0,0,1,0,0,0,0,15,'Vampiir',0,5403,'2000-01-01 00:00:00'),
(UUID(),13204,13204,13204,'Gnawing Bolt','Damages the target. A portion of damage is returned as power to the caster. This is limited by the target''s level.','Enemy',1875,0,0,0,0,'VampiirBolt',0,0,0,0,0,30,0,0,35,0,0,0,'','','','',0,0,0,0,1,0,0,0,0,15,'Vampiir',0,5404,'2000-01-01 00:00:00'),
(UUID(),13205,13205,13205,'Consuming Bolt','Damages the target. A portion of damage is returned as power to the caster. This is limited by the target''s level.','Enemy',1875,0,0,0,0,'VampiirBolt',0,0,0,0,0,30,0,0,40,0,0,0,'','','','',0,0,0,0,1,0,0,0,0,15,'Vampiir',0,5405,'2000-01-01 00:00:00'),
(UUID(),13206,13206,13206,'Ravishing Bolt','Damages the target. A portion of damage is returned as power to the caster. This is limited by the target''s level.','Enemy',1875,0,0,0,0,'VampiirBolt',0,0,0,0,0,30,0,0,45,0,0,0,'','','','',0,0,0,0,1,0,0,0,0,15,'Vampiir',0,5406,'2000-01-01 00:00:00'),
(UUID(),13207,13207,3294,'Devouring Bolt','Damages the target. A portion of damage is returned as power to the caster. This is limited by the target''s level.','Enemy',1875,0,0,0,0,'VampiirBolt',0,0,0,0,0,30,0,0,50,0,0,0,'','','','',0,0,0,0,1,0,0,0,0,15,'Vampiir',0,5407,'2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `Spell_ID` = `Spell_ID`;
