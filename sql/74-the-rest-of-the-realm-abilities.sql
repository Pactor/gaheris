-- The rest of the realm abilities for those eight classes.
--
-- Migration 73 added the 182 that matched an AtlasOF_ key. The other 34 were
-- not missing at all -- I had only been looking at keys beginning AtlasOF_,
-- and these are held under their plain names: Sonic Barrier, Mastery of Focus,
-- Fanaticism, Dual Threat, Charge, and the class RR5s like Gift of Perizor and
-- Valhalla's Blessing.
--
-- Of the 104 distinct realm abilities the dump uses, this server has an
-- ability row for 103. The one it has never heard of is Trueshot.
--
-- With these in, all eight classes have their complete realm ability list.

INSERT INTO classxrealmability_atlas
    (CharClass, AbilityKey, ClassXRealmAbility_ID, ClassXRealmAbility_Atlas_ID,
     LastTimeRowUpdated)
VALUES
(39,'Sonic Barrier','Bainshee-RR5','Bainshee-RR5','2000-01-01 00:00:00'),
(39,'Mastery of Focus','Bainshee1-0-9','Bainshee1-0-9','2000-01-01 00:00:00'),
(39,'Physical Defense','Bainshee1-1-2','Bainshee1-1-2','2000-01-01 00:00:00'),
(39,'Adrenaline Rush','Bainshee1-1-7','Bainshee1-1-7','2000-01-01 00:00:00'),
(39,'Bedazzling Aura','Bainshee1-1-8','Bainshee1-1-8','2000-01-01 00:00:00'),
(39,'Strike Prediction','Bainshee1-2-7','Bainshee1-2-7','2000-01-01 00:00:00'),
(33,'Fanaticism','Heretic-RR5','Heretic-RR5','2000-01-01 00:00:00'),
(33,'Mastery of Focus','Heretic1-1-2','Heretic1-1-2','2000-01-01 00:00:00'),
(33,'Physical Defense','Heretic1-1-6','Heretic1-1-6','2000-01-01 00:00:00'),
(33,'Bedazzling Aura','Heretic1-2-3','Heretic1-2-3','2000-01-01 00:00:00'),
(33,'Divine Intervention','Heretic1-2-4','Heretic1-2-4','2000-01-01 00:00:00'),
(60,'Gift of Perizor','Mauler60-RR5','Mauler60-RR5','2000-01-01 00:00:00'),
(60,'Mastery of Focus','Mauler601-1-3','Mauler601-1-3','2000-01-01 00:00:00'),
(60,'Dual Threat','Mauler601-2-2','Mauler601-2-2','2000-01-01 00:00:00'),
(61,'Gift of Perizor','Mauler61-RR5','Mauler61-RR5','2000-01-01 00:00:00'),
(61,'Mastery of Focus','Mauler611-1-3','Mauler611-1-3','2000-01-01 00:00:00'),
(61,'Dual Threat','Mauler611-2-2','Mauler611-2-2','2000-01-01 00:00:00'),
(62,'Gift of Perizor','Mauler62-RR5','Mauler62-RR5','2000-01-01 00:00:00'),
(62,'Mastery of Focus','Mauler621-1-3','Mauler621-1-3','2000-01-01 00:00:00'),
(62,'Dual Threat','Mauler621-2-2','Mauler621-2-2','2000-01-01 00:00:00'),
(34,'Valhalla''s Blessing','Valkyrie-RR5','Valkyrie-RR5','2000-01-01 00:00:00'),
(34,'Mastery of Focus','Valkyrie1-1-3','Valkyrie1-1-3','2000-01-01 00:00:00'),
(34,'Charge','Valkyrie1-2-4','Valkyrie1-2-4','2000-01-01 00:00:00'),
(34,'Dual Threat','Valkyrie1-2-5','Valkyrie1-2-5','2000-01-01 00:00:00'),
(58,'Mark of Prey','Vampiir-RR5','Vampiir-RR5','2000-01-01 00:00:00'),
(58,'Charge','Vampiir1-1-2','Vampiir1-1-2','2000-01-01 00:00:00'),
(58,'Strike Prediction','Vampiir1-1-7','Vampiir1-1-7','2000-01-01 00:00:00'),
(58,'Wrath of Champions','Vampiir1-1-9','Vampiir1-1-9','2000-01-01 00:00:00'),
(59,'Boiling Cauldron','Warlock-RR5','Warlock-RR5','2000-01-01 00:00:00'),
(59,'Mastery of Focus','Warlock1-0-9','Warlock1-0-9','2000-01-01 00:00:00'),
(59,'Physical Defense','Warlock1-1-2','Warlock1-1-2','2000-01-01 00:00:00'),
(59,'Adrenaline Rush','Warlock1-1-7','Warlock1-1-7','2000-01-01 00:00:00'),
(59,'Bedazzling Aura','Warlock1-1-8','Warlock1-1-8','2000-01-01 00:00:00'),
(59,'Decimation Trap','Warlock1-1-9','Warlock1-1-9','2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `CharClass` = `CharClass`;
