-- Champion Level abilities.
--
-- Champion Levels awarded nothing. The experience code was written and the
-- Arbiter hands out the levels, but the abilities those levels are meant to
-- grant were never in this database: one champion line, five specs and not a
-- single line entry. There was nothing to give.
--
-- Sixty-six lines, sixty-three specialisations and 442 entries over 196
-- spells -- Acolyte, Fighter, Mage, Guardian, Forester, Stalker, Disciple,
-- Elementalist, Magician and both Rogue trees, tiers one to four.
--
-- SpellLineID and SpecializationID are renumbered above our existing maxima:
-- the dump's champion IDs start at 247 and 201, both of which are already
-- taken here by unrelated lines. Nothing references those numbers -- the
-- lines are joined by KeyName -- so renumbering is free.
--
-- Part 2 of 4: the specialisations they hang from.

INSERT INTO `specialization` (`Specialization_ID`,`KeyName`,`Name`,`Icon`,`Description`,`SpecializationID`,`Implementation`,`LastTimeRowUpdated`) VALUES
(UUID(),'Champion Acolyte 1','Champion Acolyte Abilities 1',0,'Subclassing Specialization Acolyte 1',218,'DOL.GS.LiveCLAcolyteSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Acolyte 2','Champion Acolyte Abilities 2',0,'Subclassing Specialization Acolyte 2',219,'DOL.GS.LiveCLAcolyteSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Acolyte 3','Champion Acolyte Abilities 3',0,'Subclassing Specialization Acolyte 3',220,'DOL.GS.LiveCLAcolyteSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Acolyte 4','Champion Acolyte Abilities 4',0,'Subclassing Specialization Acolyte 4',221,'DOL.GS.LiveCLAcolyteSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Albion Rogue 1','Champion Albion Rogue Abilities 1',0,'Subclassing Specialization Albion Rogue 1',222,'DOL.GS.LiveCLAlbionRogueSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Albion Rogue 2','Champion Albion Rogue Abilities 2',0,'Subclassing Specialization Albion Rogue 2',223,'DOL.GS.LiveCLAlbionRogueSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Albion Rogue 3','Champion Albion Rogue Abilities 3',0,'Subclassing Specialization Albion Rogue 3',224,'DOL.GS.LiveCLAlbionRogueSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Albion Rogue 4','Champion Albion Rogue Abilities 4',0,'Subclassing Specialization Albion Rogue 4',225,'DOL.GS.LiveCLAlbionRogueSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Disciple 1','Champion Disciple Abilities 1',0,'Subclassing Specialization Disciple 1',226,'DOL.GS.LiveCLDiscipleSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Disciple 2','Champion Disciple Abilities 2',0,'Subclassing Specialization Disciple 2',227,'DOL.GS.LiveCLDiscipleSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Disciple 3','Champion Disciple Abilities 3',0,'Subclassing Specialization Disciple 3',228,'DOL.GS.LiveCLDiscipleSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Disciple 4','Champion Disciple Abilities 4',0,'Subclassing Specialization Disciple 4',229,'DOL.GS.LiveCLDiscipleSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Elementalist 1','Champion Elementalist Abilities 1',0,'Subclassing Specialization Elementalist 1',230,'DOL.GS.LiveCLElementalistSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Elementalist 2','Champion Elementalist Abilities 2',0,'Subclassing Specialization Elementalist 2',231,'DOL.GS.LiveCLElementalistSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Elementalist 3','Champion Elementalist Abilities 3',0,'Subclassing Specialization Elementalist 3',232,'DOL.GS.LiveCLElementalistSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Elementalist 4','Champion Elementalist Abilities 4',0,'Subclassing Specialization Elementalist 4',233,'DOL.GS.LiveCLElementalistSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Fighter 1','Champion Fighter Abilities 1',0,'Subclassing Specialization Fighter 1',234,'DOL.GS.LiveCLFighterSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Fighter 2','Champion Fighter Abilities 2',0,'Subclassing Specialization Fighter 2',235,'DOL.GS.LiveCLFighterSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Fighter 3','Champion Fighter Abilities 3',0,'Subclassing Specialization Fighter 3',236,'DOL.GS.LiveCLFighterSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Fighter 4','Champion Fighter Abilities 4',0,'Subclassing Specialization Fighter 4',237,'DOL.GS.LiveCLFighterSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Mage 1','Champion Mage Abilities 1',0,'Subclassing Specialization Mage 1',238,'DOL.GS.LiveCLMageSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Mage 2','Champion Mage Abilities 2',0,'Subclassing Specialization Mage 2',239,'DOL.GS.LiveCLMageSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Mage 3','Champion Mage Abilities 3',0,'Subclassing Specialization Mage 3',240,'DOL.GS.LiveCLMageSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Mage 4','Champion Mage Abilities 4',0,'Subclassing Specialization Mage 4',241,'DOL.GS.LiveCLMageSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Forester 1','Champion Forester Abilities 1',0,'Subclassing Specialization Forester 1',242,'DOL.GS.LiveCLForesterSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Forester 2','Champion Forester Abilities 2',0,'Subclassing Specialization Forester 2',243,'DOL.GS.LiveCLForesterSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Forester 3','Champion Forester Abilities 3',0,'Subclassing Specialization Forester 3',244,'DOL.GS.LiveCLForesterSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Forester 4','Champion Forester Abilities 4',0,'Subclassing Specialization Forester 4',245,'DOL.GS.LiveCLForesterSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Guardian 1','Champion Guardian Abilities 1',0,'Subclassing Specialization Guardian 1',246,'DOL.GS.LiveCLGuardianSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Guardian 2','Champion Guardian Abilities 2',0,'Subclassing Specialization Guardian 2',247,'DOL.GS.LiveCLGuardianSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Guardian 3','Champion Guardian Abilities 3',0,'Subclassing Specialization Guardian 3',248,'DOL.GS.LiveCLGuardianSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Guardian 4','Champion Guardian Abilities 4',0,'Subclassing Specialization Guardian 4',249,'DOL.GS.LiveCLGuardianSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Magician 1','Champion Magician Abilities 1',0,'Subclassing Specialization Magician 1',250,'DOL.GS.LiveCLMagicianSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Magician 2','Champion Magician Abilities 2',0,'Subclassing Specialization Magician 2',251,'DOL.GS.LiveCLMagicianSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Magician 3','Champion Magician Abilities 3',0,'Subclassing Specialization Magician 3',252,'DOL.GS.LiveCLMagicianSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Magician 4','Champion Magician Abilities 4',0,'Subclassing Specialization Magician 4',253,'DOL.GS.LiveCLMagicianSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Magician 5','Champion Magician Abilities 5',0,'Subclassing Specialization Magician 5',254,'DOL.GS.LiveCLMagicianSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Stalker 1','Champion Stalker Abilities 1',0,'Subclassing Specialization Stalker 1',255,'DOL.GS.LiveCLStalkerSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Stalker 2','Champion Stalker Abilities 2',0,'Subclassing Specialization Stalker 2',256,'DOL.GS.LiveCLStalkerSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Stalker 3','Champion Stalker Abilities 3',0,'Subclassing Specialization Stalker 3',257,'DOL.GS.LiveCLStalkerSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Stalker 4','Champion Stalker Abilities 4',0,'Subclassing Specialization Stalker 4',258,'DOL.GS.LiveCLStalkerSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Naturalist 1','Champion Naturalist Abilities 1',0,'Subclassing Specialization Naturalist 1',259,'DOL.GS.LiveCLNaturalistSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Naturalist 2','Champion Naturalist Abilities 2',0,'Subclassing Specialization Naturalist 2',260,'DOL.GS.LiveCLNaturalistSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Naturalist 3','Champion Naturalist Abilities 3',0,'Subclassing Specialization Naturalist 3',261,'DOL.GS.LiveCLNaturalistSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Naturalist 4','Champion Naturalist Abilities 4',0,'Subclassing Specialization Naturalist 4',262,'DOL.GS.LiveCLNaturalistSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Midgard Rogue 1','Champion Midgard Rogue Abilities 1',0,'Subclassing Specialization Midgard Rogue 1',263,'DOL.GS.LiveCLMidgardRogueSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Midgard Rogue 2','Champion Midgard Rogue Abilities 2',0,'Subclassing Specialization Midgard Rogue 2',264,'DOL.GS.LiveCLMidgardRogueSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Midgard Rogue 3','Champion Midgard Rogue Abilities 3',0,'Subclassing Specialization Midgard Rogue 3',265,'DOL.GS.LiveCLMidgardRogueSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Midgard Rogue 4','Champion Midgard Rogue Abilities 4',0,'Subclassing Specialization Midgard Rogue 4',266,'DOL.GS.LiveCLMidgardRogueSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Mystic 1','Champion Mystic Abilities 1',0,'Subclassing Specialization Mystic 1',267,'DOL.GS.LiveCLMysticSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Mystic 2','Champion Mystic Abilities 2',0,'Subclassing Specialization Mystic 2',268,'DOL.GS.LiveCLMysticSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Mystic 3','Champion Mystic Abilities 3',0,'Subclassing Specialization Mystic 3',269,'DOL.GS.LiveCLMysticSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Mystic 4','Champion Mystic Abilities 4',0,'Subclassing Specialization Mystic 4',270,'DOL.GS.LiveCLMysticSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Mystic 5','Champion Mystic Abilities 5',0,'Subclassing Specialization Mystic 5',271,'DOL.GS.LiveCLMysticSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Seer 1','Champion Seer Abilities 1',0,'Subclassing Specialization Seer 1',272,'DOL.GS.LiveCLSeerSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Seer 2','Champion Seer Abilities 2',0,'Subclassing Specialization Seer 2',273,'DOL.GS.LiveCLSeerSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Seer 3','Champion Seer Abilities 3',0,'Subclassing Specialization Seer 3',274,'DOL.GS.LiveCLSeerSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Seer 4','Champion Seer Abilities 4',0,'Subclassing Specialization Seer 4',275,'DOL.GS.LiveCLSeerSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Seer 5','Champion Seer Abilities 5',0,'Subclassing Specialization Seer 5',276,'DOL.GS.LiveCLSeerSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Viking 1','Champion Viking Abilities 1',0,'Subclassing Specialization Viking 1',277,'DOL.GS.LiveCLVikingSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Viking 2','Champion Viking Abilities 2',0,'Subclassing Specialization Viking 2',278,'DOL.GS.LiveCLVikingSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Viking 3','Champion Viking Abilities 3',0,'Subclassing Specialization Viking 3',279,'DOL.GS.LiveCLVikingSpec','2000-01-01 00:00:00'),
(UUID(),'Champion Viking 4','Champion Viking Abilities 4',0,'Subclassing Specialization Viking 4',280,'DOL.GS.LiveCLVikingSpec','2000-01-01 00:00:00');
