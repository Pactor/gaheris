-- The three realm abilities every expansion class was never given.
--
-- Regeneration, Tireless and Mastery of Water are held by all thirty-nine
-- classes that shipped with the base game and by none of the eight added
-- afterwards:
--
--   Heretic, Valkyrie, Bainshee, Vampiir, Warlock, and the three Maulers
--
-- That is not a per-class decision. It is the shape of a table that was
-- populated for the original classes and never extended when the expansion
-- ones were added, and it is why the Vampiir looked as though he had a
-- deliberately restricted realm ability list -- twenty against thirty to
-- thirty-four for the rest of Hibernia -- when the gap was shared by seven
-- other classes.
--
-- Found while auditing the Vampiir, by asking which abilities eight or more of
-- his peers had that he did not, and then asking who else lacked them.
--
-- Two things that look like the same gap and are not, so nobody adds them:
--
--   Augmented Acuity is correctly absent from the Vampiir. He has no normal
--   power pool and acuity does not affect him.
--
--   Purge is not absent from any of them. They carry AtlasOF_PurgeReduced,
--   one of the three Purge keys.
--
-- Twenty-four rows, three for each of eight classes. The guard makes it safe
-- to run twice, and safe if any of them is later granted by another route.

INSERT INTO classxrealmability_atlas
  (CharClass, AbilityKey, LastTimeRowUpdated, ClassXRealmAbility_ID, ClassXRealmAbility_Atlas_ID)
SELECT p.cls, p.ab, '2000-01-01 00:00:00', p.id, p.id
FROM (
  SELECT 33 AS cls, 'AtlasOF_Tireless' AS ab, 'Heretic-exp-tireless' AS id
  UNION ALL
  SELECT 33 AS cls, 'AtlasOF_Regeneration' AS ab, 'Heretic-exp-regen' AS id
  UNION ALL
  SELECT 33 AS cls, 'AtlasOF_MasteryOfWater' AS ab, 'Heretic-exp-water' AS id
  UNION ALL
  SELECT 34 AS cls, 'AtlasOF_Tireless' AS ab, 'Valkyrie-exp-tireless' AS id
  UNION ALL
  SELECT 34 AS cls, 'AtlasOF_Regeneration' AS ab, 'Valkyrie-exp-regen' AS id
  UNION ALL
  SELECT 34 AS cls, 'AtlasOF_MasteryOfWater' AS ab, 'Valkyrie-exp-water' AS id
  UNION ALL
  SELECT 39 AS cls, 'AtlasOF_Tireless' AS ab, 'Bainshee-exp-tireless' AS id
  UNION ALL
  SELECT 39 AS cls, 'AtlasOF_Regeneration' AS ab, 'Bainshee-exp-regen' AS id
  UNION ALL
  SELECT 39 AS cls, 'AtlasOF_MasteryOfWater' AS ab, 'Bainshee-exp-water' AS id
  UNION ALL
  SELECT 58 AS cls, 'AtlasOF_Tireless' AS ab, 'Vampiir-exp-tireless' AS id
  UNION ALL
  SELECT 58 AS cls, 'AtlasOF_Regeneration' AS ab, 'Vampiir-exp-regen' AS id
  UNION ALL
  SELECT 58 AS cls, 'AtlasOF_MasteryOfWater' AS ab, 'Vampiir-exp-water' AS id
  UNION ALL
  SELECT 59 AS cls, 'AtlasOF_Tireless' AS ab, 'Warlock-exp-tireless' AS id
  UNION ALL
  SELECT 59 AS cls, 'AtlasOF_Regeneration' AS ab, 'Warlock-exp-regen' AS id
  UNION ALL
  SELECT 59 AS cls, 'AtlasOF_MasteryOfWater' AS ab, 'Warlock-exp-water' AS id
  UNION ALL
  SELECT 60 AS cls, 'AtlasOF_Tireless' AS ab, 'MaulerAlb-exp-tireless' AS id
  UNION ALL
  SELECT 60 AS cls, 'AtlasOF_Regeneration' AS ab, 'MaulerAlb-exp-regen' AS id
  UNION ALL
  SELECT 60 AS cls, 'AtlasOF_MasteryOfWater' AS ab, 'MaulerAlb-exp-water' AS id
  UNION ALL
  SELECT 61 AS cls, 'AtlasOF_Tireless' AS ab, 'MaulerMid-exp-tireless' AS id
  UNION ALL
  SELECT 61 AS cls, 'AtlasOF_Regeneration' AS ab, 'MaulerMid-exp-regen' AS id
  UNION ALL
  SELECT 61 AS cls, 'AtlasOF_MasteryOfWater' AS ab, 'MaulerMid-exp-water' AS id
  UNION ALL
  SELECT 62 AS cls, 'AtlasOF_Tireless' AS ab, 'MaulerHib-exp-tireless' AS id
  UNION ALL
  SELECT 62 AS cls, 'AtlasOF_Regeneration' AS ab, 'MaulerHib-exp-regen' AS id
  UNION ALL
  SELECT 62 AS cls, 'AtlasOF_MasteryOfWater' AS ab, 'MaulerHib-exp-water' AS id
) p
WHERE NOT EXISTS (
  SELECT 1 FROM classxrealmability_atlas x
   WHERE x.CharClass = p.cls AND x.AbilityKey = p.ab
);
