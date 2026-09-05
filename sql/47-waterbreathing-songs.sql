-- The group waterbreathing songs, restored.
--
-- Patch 1.89 added a four step line of them to the Minstrel's Instruments,
-- the Bard's Music and the Skald's Battlesongs -- one shared set of spells
-- trained at spec 10, 20, 30 and 40 in all three. Different names, same job.
--
-- Value is the swim speed the buff grants as a percentage of running speed,
-- which is why the tiers matter: 70, 80, 90, then full speed at Leviathan.
-- Breathing and swimming are the one spell, not two.
--
-- Before this the only WaterBreathing spell on the server was Sojourner's
-- ML2 Unending Breath, so the three classes that are supposed to hand it out
-- for free could not.

INSERT INTO spell
    (Spell_ID, SpellID, ClientEffect, Icon, TooltipId, Name, Description,
     Target, `Range`, Power, CastTime, Type, Duration, Value, PackageID)
VALUES
    ('7510', 7510, 7510, 7510, 7510, 'Neriad''s Call',
     'Allows the group to breathe under water.',
     'Group', 1500, 10, 3, 'WaterBreathing', 1800, 70, 'gaheris-water'),
    ('7511', 7511, 7511, 7511, 7511, 'Neriad''s Breath',
     'Allows the group to breathe under water.',
     'Group', 1500, 15, 3, 'WaterBreathing', 1800, 80, 'gaheris-water'),
    ('7512', 7512, 7512, 7512, 7512, 'Neriad''s Blessing',
     'Allows the group to breathe under water.',
     'Group', 1500, 20, 3, 'WaterBreathing', 1800, 90, 'gaheris-water'),
    ('7513', 7513, 7513, 7513, 7513, 'Breath of Leviathan',
     'Allows the group to breathe under water.',
     'Group', 1500, 25, 3, 'WaterBreathing', 1800, 100, 'gaheris-water')
ON DUPLICATE KEY UPDATE `Spell_ID` = `Spell_ID`;

INSERT INTO linexspell (LineXSpell_ID, LineName, SpellID, Level, PackageID)
VALUES
    ('gaheris-water-bard-10',  'Bard Music Spec', 7510, 10, 'gaheris-water'),
    ('gaheris-water-bard-20',  'Bard Music Spec', 7511, 20, 'gaheris-water'),
    ('gaheris-water-bard-30',  'Bard Music Spec', 7512, 30, 'gaheris-water'),
    ('gaheris-water-bard-40',  'Bard Music Spec', 7513, 40, 'gaheris-water'),
    ('gaheris-water-mins-10',  'Instruments',     7510, 10, 'gaheris-water'),
    ('gaheris-water-mins-20',  'Instruments',     7511, 20, 'gaheris-water'),
    ('gaheris-water-mins-30',  'Instruments',     7512, 30, 'gaheris-water'),
    ('gaheris-water-mins-40',  'Instruments',     7513, 40, 'gaheris-water'),
    ('gaheris-water-skald-10', 'Battlesongs',     7510, 10, 'gaheris-water'),
    ('gaheris-water-skald-20', 'Battlesongs',     7511, 20, 'gaheris-water'),
    ('gaheris-water-skald-30', 'Battlesongs',     7512, 30, 'gaheris-water'),
    ('gaheris-water-skald-40', 'Battlesongs',     7513, 40, 'gaheris-water')
ON DUPLICATE KEY UPDATE `LineXSpell_ID` = `LineXSpell_ID`;
