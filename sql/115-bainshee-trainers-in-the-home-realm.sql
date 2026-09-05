-- The Bainshee had no trainer anywhere in Hibernia.
--
-- Found by asking, of every one of the sixty-two classes, whether a trainer
-- that trains it is actually standing somewhere a player of that class would
-- be. Every Albion class passes. Every Midgard class passes. Every Hibernia
-- class has between five and nine trainers across Hibernia, the Shrouded Isles
-- and Tir na Nog -- except this one, which has zero.
--
-- Her three trainers were one in Atlantis and two on Agramon, and all three are
-- ours: they carry the gaheris-atlantis and gaheris-nf package ids, placed as
-- part of other work. Upstream OpenDAoC placed no Bainshee trainer at all.
--
-- This is the Valkyrie fault exactly, and it went unnoticed for the same
-- reason twice over. Migration 111 fixed her because someone tried to train
-- her. The Bainshee was audited far more thoroughly than that -- every spell
-- line, every realm ability, her champion and master level entries, her auras
-- and her fear and her befriend -- and not one of those checks asks whether a
-- level five Bainshee can spend a specialisation point. Skills were treated as
-- the whole of a class, and they are not.
--
-- Twelve Bainshee trainer npctemplates exist in the reference data, with real
-- names, so the class was always expected to have them; only the world
-- placements were never made. Nine of those names are unused, and are used
-- here, which is better than inventing any.
--
-- The coordinates are ours, not live's, and that should be plain. Each new
-- trainer stands beside a Vampiir trainer -- the other Hibernia class from the
-- same expansion, so the same halls are the right halls -- offset a hundred
-- units along X so they share the room without sharing the spot. Region, Z and
-- heading are taken from that neighbour, so nobody ends up inside a wall or on
-- the wrong floor.
--
-- Cloned from Morynne, an existing Bainshee trainer, rather than written out,
-- so every column but name, position and package already holds a value known to
-- work for this class: model, size, equipment template, realm, brain, flags.
--
-- Nine new trainers, bringing her to twelve, which is Vampiir parity.

-- This migration clones an existing trainer rather than typing fifty columns
-- out by hand, which means it needs that row to exist. It does not on a
-- server that has not installed 13-atlantis-mobs.sql, and a missing source made the
-- whole thing insert nothing at all while still reporting success -- which is
-- how it passed unnoticed until it was installed onto a fresh database on
-- 5 September 2026.
--
-- So it now stops instead. The subquery below returns two rows when the
-- source is missing, which is an error rather than a silent no-op.

SET @src := (SELECT COUNT(*) FROM mob
              WHERE Name = 'Morynne' AND ClassType = 'DOL.GS.Trainer.BainsheeTrainer');

SELECT IF(@src > 0, 1, (SELECT 1 UNION SELECT 2)) AS `13-atlantis-mobs.sql must be installed first`;

INSERT INTO mob
  (ClassType, TranslationId, Name, Suffix, Guild, ExamineArticle, MessageArticle,
   X, Y, Z, Speed, Heading, Region, Model, Size, Strength, Constitution, Dexterity,
   Quickness, Intelligence, Piety, Empathy, Charisma, Level, Realm,
   EquipmentTemplateID, ItemsListTemplateID, NPCTemplateID, Race, Flags, AggroLevel,
   AggroRange, MeleeDamageType, RespawnInterval, FactionID, BodyType, HouseNumber,
   Brain, PathID, OwnerID, RoamingRange, IsCloakHoodUp, Gender, PackageID,
   VisibleWeaponSlots, LastTimeRowUpdated, Mob_ID)
SELECT
   src.ClassType, src.TranslationId, p.NewName, src.Suffix, src.Guild,
   src.ExamineArticle, src.MessageArticle,
   p.NewX, p.NewY, p.NewZ, src.Speed, p.NewHeading, p.NewRegion,
   src.Model, src.Size, src.Strength, src.Constitution, src.Dexterity,
   src.Quickness, src.Intelligence, src.Piety, src.Empathy, src.Charisma,
   src.Level, src.Realm,
   src.EquipmentTemplateID, src.ItemsListTemplateID, 0, src.Race, src.Flags,
   src.AggroLevel, src.AggroRange, src.MeleeDamageType, src.RespawnInterval,
   src.FactionID, src.BodyType, src.HouseNumber,
   src.Brain, src.PathID, src.OwnerID, src.RoamingRange, src.IsCloakHoodUp,
   src.Gender, 'gaheris-trn',
   src.VisibleWeaponSlots, '2000-01-01 00:00:00', UUID()
FROM (SELECT * FROM mob WHERE Name = 'Morynne'
        AND ClassType = 'DOL.GS.Trainer.BainsheeTrainer' LIMIT 1) src
CROSS JOIN (
  -- Shrouded Isles, beside the three Vampiir trainers there
  SELECT 'Beland'   AS NewName, 424111 AS NewX, 444902 AS NewY, 5952 AS NewZ,  216 AS NewHeading, 181 AS NewRegion
  UNION ALL SELECT 'Bleollyn', 430905, 318074, 3479,  648, 181
  UNION ALL SELECT 'Daegda',   308701, 350510, 3507,  261, 181
  -- Hibernia, beside the five there
  UNION ALL SELECT 'Leena',    294734, 641412, 4848,  568, 200
  UNION ALL SELECT 'Lenvanu',  349026, 489274, 5284, 3350, 200
  UNION ALL SELECT 'Maedri',   341010, 591954, 5464, 3117, 200
  UNION ALL SELECT 'Rheoran',  419939, 487455, 2656, 1752, 200
  UNION ALL SELECT 'Siddyn',   352030, 552728, 5105, 2480, 200
  -- Tir na Nog
  UNION ALL SELECT 'Tellyn',    26834,  35155, 7493, 3936, 201
) p
WHERE NOT EXISTS (
  SELECT 1 FROM mob existing
   WHERE existing.Name = p.NewName
     AND existing.ClassType = 'DOL.GS.Trainer.BainsheeTrainer'
);
