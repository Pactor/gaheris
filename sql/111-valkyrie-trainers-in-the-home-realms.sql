-- The Valkyrie had three trainers, and none of them at home.
--
-- Every other Midgard class has nine to twelve, spread across Midgard,
-- Jordheim and Aegir. She had three: one in Atlantis and two in New Frontiers,
-- both of which we placed ourselves as part of other work. A level five
-- Valkyrie had to cross a frontier to find her own trainer.
--
-- Why she was missed is on the record. Migration 75 -- "the trainers for the
-- six classes that were switched off" -- covered Heretic, Warlock, Vampiir and
-- the three Maulers, because those six could not be created at all and the
-- absence surfaced the moment they were reopened. The Valkyrie was never
-- switched off, so nobody went looking, and nobody noticed she had never been
-- given any either.
--
-- There is nothing to copy. Upstream OpenDAoC's mob data contains **zero**
-- Valkyrie trainers -- and zero Warlock ones, which is why migration 75 had to
-- source those from a public dump. That dump is no longer to hand. Eleven
-- Valkyrie trainer *npctemplates* exist in the reference data, so the class
-- was expected to have them; only the world placements were never made.
--
-- So these are placed rather than imported, and it is worth being plain about
-- that: the coordinates are ours, not live's. Each one stands beside a trainer
-- already in that hall -- a Skald, Savage or Thane at a known-good position,
-- offset a hundred units along X so they share the room without sharing the
-- spot. Region, Z and heading are taken from that neighbour, so nobody ends up
-- inside a wall or on the wrong floor.
--
-- Cloned from Sudya, an existing Valkyrie trainer, rather than written out.
-- Every column but name, position and package therefore already holds a value
-- known to work for this class -- model, size, equipment template, realm,
-- brain, flags -- instead of nine hand-typed rows with nine chances to get one
-- of them wrong.
--
-- Nine new trainers, bringing her to twelve, which is Warlock parity.

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
FROM (SELECT * FROM mob WHERE Name = 'Sudya'
        AND ClassType = 'DOL.GS.Trainer.ValkyrieTrainer' LIMIT 1) src
CROSS JOIN (
  -- beside Tjorri, the Savage trainer
  SELECT 'Sigrun'   AS NewName, 702398 AS NewX, 739916 AS NewY, 6536 AS NewZ, 3024 AS NewHeading, 100 AS NewRegion
  -- beside Ronja, the Savage trainer
  UNION ALL SELECT 'Gudny',    748191, 815206, 4408, 3515, 100
  -- beside Vanah, the Skald trainer
  UNION ALL SELECT 'Herja',    798730, 892404, 4744, 3117, 100
  -- beside Thonnir, the Warlock trainer
  UNION ALL SELECT 'Randgrid', 805173, 726866, 4688, 1056, 100
  -- Jordheim, beside Sven and Leif
  UNION ALL SELECT 'Skogul',    28605,  34944, 8021, 2928, 101
  UNION ALL SELECT 'Hlokk',     30500,  34921, 8005, 4090, 101
  -- Aegir, beside Regin, Otik and Gudrika
  UNION ALL SELECT 'Gondul',   287502, 303277, 4160, 1686, 151
  UNION ALL SELECT 'Geirahod', 289429, 354847, 3866, 3797, 151
  UNION ALL SELECT 'Thrud',    377532, 385792, 7840, 3197, 151
) p;
