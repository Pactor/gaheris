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
-- Part 2: the abilities.

INSERT INTO `ability` (`AbilityID`,`KeyName`,`Name`,`InternalID`,`Description`,`IconID`,`Implementation`,`LastTimeRowUpdated`) VALUES
(24,'Vampiir Strength','Vampiir Strength',152,'Vampiirs get an increase to their stats every three levels starting at level six.',0,'DOL.GS.SkillHandler.VampiirStrength','2000-01-01 00:00:00'),
(25,'Vampiir Quickness','Vampiir Quickness',153,'Vampiirs get an increase to their stats every three levels starting at level six.',0,'DOL.GS.SkillHandler.VampiirQuickness','2000-01-01 00:00:00'),
(26,'Vampiir Dexterity','Vampiir Dexterity',154,'Vampiirs get an increase to their stats every three levels starting at level six.',0,'DOL.GS.SkillHandler.VampiirDexterity','2000-01-01 00:00:00'),
(27,'Vampiir Constitution','Vampiir Constitution',155,'Vampiirs get an increase to their stats every three levels starting at level six.',0,'DOL.GS.SkillHandler.VampiirConstitution','2000-01-01 00:00:00'),
(28,'Warlock-RR5','Boiling Cauldron',156,'Summons a large cauldron that boils in place for 5 seconds before spilling and doing damage to all those nearby.',3085,'','2000-01-01 00:00:00');
