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
-- Part 1 of 4: the lines.

INSERT INTO `spellline` (`KeyName`,`Name`,`Spec`,`IsBaseLine`,`SpellLineID`,`ClassIDHint`,`PackageID`,`LastTimeRowUpdated`) VALUES
('Champion Acolyte 1','Champion Acolyte 1','Champion Acolyte 1',0,248,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Acolyte 2','Champion Acolyte 2','Champion Acolyte 2',0,249,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Acolyte 3','Champion Acolyte 3','Champion Acolyte 3',0,250,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Acolyte 4','Champion Acolyte 4','Champion Acolyte 4',0,251,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Albion Rogue 1','Champion Albion Rogue 1','Champion Albion Rogue 1',0,252,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Albion Rogue 2','Champion Albion Rogue 2','Champion Albion Rogue 2',0,253,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Albion Rogue 3','Champion Albion Rogue 3','Champion Albion Rogue 3',0,254,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Albion Rogue 4','Champion Albion Rogue 4','Champion Albion Rogue 4',0,255,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Disciple 1','Champion Disciple 1','Champion Disciple 1',0,256,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Disciple 2','Champion Disciple 2','Champion Disciple 2',0,257,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Disciple 3','Champion Disciple 3','Champion Disciple 3',0,258,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Disciple 4','Champion Disciple 4','Champion Disciple 4',0,259,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Elementalist 1','Champion Elementalist 1','Champion Elementalist 1',0,260,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Elementalist 2','Champion Elementalist 2','Champion Elementalist 2',0,261,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Elementalist 3','Champion Elementalist 3','Champion Elementalist 3',0,262,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Elementalist 4','Champion Elementalist 4','Champion Elementalist 4',0,263,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Fighter 1','Champion Fighter 1','Champion Fighter 1',0,264,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Fighter 2','Champion Fighter 2','Champion Fighter 2',0,265,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Fighter 3','Champion Fighter 3','Champion Fighter 3',0,266,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Fighter 4','Champion Fighter 4','Champion Fighter 4',0,267,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Forester 1','Champion Forester 1','Champion Forester 1',0,268,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Forester 2','Champion Forester 2','Champion Forester 2',0,269,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Forester 3','Champion Forester 3','Champion Forester 3',0,270,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Forester 4','Champion Forester 4','Champion Forester 4',0,271,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Guardian 1','Champion Guardian 1','Champion Guardian 1',0,272,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Guardian 2','Champion Guardian 2','Champion Guardian 2',0,273,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Guardian 3','Champion Guardian 3','Champion Guardian 3',0,274,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Guardian 4','Champion Guardian 4','Champion Guardian 4',0,275,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Mage 1','Champion Mage 1','Champion Mage 1',0,276,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Mage 2','Champion Mage 2','Champion Mage 2',0,277,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Mage 3','Champion Mage 3','Champion Mage 3',0,278,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Mage 4','Champion Mage 4','Champion Mage 4',0,279,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Magician 1','Champion Magician 1','Champion Magician 1',0,280,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Magician 2','Champion Magician 2','Champion Magician 2',0,281,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Magician 3','Champion Magician 3','Champion Magician 3',0,282,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Magician 4','Champion Magician 4','Champion Magician 4',0,283,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Magician 5','Champion Magician 5','Champion Magician 5',0,284,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Midgard Rogue 1','Champion Midgard Rogue 1','Champion Midgard Rogue 1',0,285,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Midgard Rogue 2','Champion Midgard Rogue 2','Champion Midgard Rogue 2',0,286,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Midgard Rogue 3','Champion Midgard Rogue 3','Champion Midgard Rogue 3',0,287,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Midgard Rogue 4','Champion Midgard Rogue 4','Champion Midgard Rogue 4',0,288,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Mystic 1','Champion Mystic 1','Champion Mystic 1',0,289,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Mystic 2','Champion Mystic 2','Champion Mystic 2',0,290,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Mystic 3','Champion Mystic 3','Champion Mystic 3',0,291,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Mystic 4','Champion Mystic 4','Champion Mystic 4',0,292,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Mystic 5','Champion Mystic 5','Champion Mystic 5',0,293,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Naturalist 1','Champion Naturalist 1','Champion Naturalist 1',0,294,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Naturalist 2','Champion Naturalist 2','Champion Naturalist 2',0,295,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Naturalist 3','Champion Naturalist 3','Champion Naturalist 3',0,296,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Naturalist 4','Champion Naturalist 4','Champion Naturalist 4',0,297,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Seer 1','Champion Seer 1','Champion Seer 1',0,298,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Seer 2','Champion Seer 2','Champion Seer 2',0,299,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Seer 3','Champion Seer 3','Champion Seer 3',0,300,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Seer 4','Champion Seer 4','Champion Seer 4',0,301,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Seer 5','Champion Seer 5','Champion Seer 5',0,302,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Stalker 1','Champion Stalker 1','Champion Stalker 1',0,303,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Stalker 2','Champion Stalker 2','Champion Stalker 2',0,304,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Stalker 3','Champion Stalker 3','Champion Stalker 3',0,305,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Stalker 4','Champion Stalker 4','Champion Stalker 4',0,306,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Viking 1','Champion Viking 1','Champion Viking 1',0,307,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Viking 2','Champion Viking 2','Champion Viking 2',0,308,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Viking 3','Champion Viking 3','Champion Viking 3',0,309,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Viking 4','Champion Viking 4','Champion Viking 4',0,310,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Abilities Hibernia','Champion Abilities','Champion Level Hibernia',0,311,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Abilities Midgard','Champion Abilities','Champion Level Midgard',0,312,0,'gaheris-champ','2000-01-01 00:00:00'),
('Champion Abilities Albion','Champion Abilities','Champion Level Albion',0,313,0,'gaheris-champ','2000-01-01 00:00:00');
