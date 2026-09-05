-- Realm abilities for the eight classes that had none.
--
-- Heretic, Valkyrie, Bainshee, Vampiir, Warlock and all three Maulers had
-- zero rows in classxrealmability_atlas, so realm rank bought them nothing --
-- no augmented stats, no resistances, nothing to spend a realm skill point
-- on. Our table covered 39 classes; there are 47.
--
-- The rows come from the public dump's ClassXRealmAbility, translated. The two
-- tables key abilities differently -- ours by AtlasOF_AugStr, the dump by the
-- display name "Augmented Strength" -- so each was matched through our own
-- ability table, which carries both.
--
-- 182 of the dump's 216 rows for these classes had an equivalent here. The
-- other 34 are abilities this server's OF-style set does not include at all
-- (Mastery of Focus, Dual Threat, and the class RR5s like Gift of Perizor and
-- Valhalla's Blessing), so they are left out rather than invented.

INSERT INTO classxrealmability_atlas
    (CharClass, AbilityKey, ClassXRealmAbility_ID, ClassXRealmAbility_Atlas_ID,
     LastTimeRowUpdated)
VALUES
(39,'AtlasOF_AugAcuity','Bainshee1-0-1
','Bainshee1-0-1
','2000-01-01 00:00:00'),
(39,'AtlasOF_AugCon','Bainshee1-0-2
','Bainshee1-0-2
','2000-01-01 00:00:00'),
(39,'AtlasOF_AugDex','Bainshee1-0-3
','Bainshee1-0-3
','2000-01-01 00:00:00'),
(39,'AtlasOF_AugQui','Bainshee1-0-4
','Bainshee1-0-4
','2000-01-01 00:00:00'),
(39,'AtlasOF_AugStr','Bainshee1-0-5
','Bainshee1-0-5
','2000-01-01 00:00:00'),
(39,'AtlasOF_EtherealBond','Bainshee1-0-6
','Bainshee1-0-6
','2000-01-01 00:00:00'),
(39,'AtlasOF_Lifter','Bainshee1-0-7
','Bainshee1-0-7
','2000-01-01 00:00:00'),
(39,'AtlasOF_LongWind','Bainshee1-0-8
','Bainshee1-0-8
','2000-01-01 00:00:00'),
(39,'AtlasOF_MasteryOfMagery','Bainshee1-1-1
','Bainshee1-1-1
','2000-01-01 00:00:00'),
(39,'AtlasOF_Serenity','Bainshee1-1-3
','Bainshee1-1-3
','2000-01-01 00:00:00'),
(39,'AtlasOF_Toughness','Bainshee1-1-4
','Bainshee1-1-4
','2000-01-01 00:00:00'),
(39,'AtlasOF_VeilRecovery','Bainshee1-1-5
','Bainshee1-1-5
','2000-01-01 00:00:00'),
(39,'AtlasOF_WildPower','Bainshee1-1-6
','Bainshee1-1-6
','2000-01-01 00:00:00'),
(39,'AtlasOF_Concentration','Bainshee1-1-9
','Bainshee1-1-9
','2000-01-01 00:00:00'),
(39,'AtlasOF_FirstAid','Bainshee1-2-1
','Bainshee1-2-1
','2000-01-01 00:00:00'),
(39,'AtlasOF_MasteryOfConcentration','Bainshee1-2-2
','Bainshee1-2-2
','2000-01-01 00:00:00'),
(39,'AtlasOF_MCL','Bainshee1-2-3
','Bainshee1-2-3
','2000-01-01 00:00:00'),
(39,'AtlasOF_PurgeReduced','Bainshee1-2-4
','Bainshee1-2-4
','2000-01-01 00:00:00'),
(39,'AtlasOF_RagingPower','Bainshee1-2-5
','Bainshee1-2-5
','2000-01-01 00:00:00'),
(39,'AtlasOF_SecondWind','Bainshee1-2-6
','Bainshee1-2-6
','2000-01-01 00:00:00'),
(39,'AtlasOF_EmptyMind','Bainshee1-2-8
','Bainshee1-2-8
','2000-01-01 00:00:00'),
(39,'AtlasOF_VolcanicPillar','Bainshee1-2-9
','Bainshee1-2-9
','2000-01-01 00:00:00'),
(33,'AtlasOF_AugAcuity','Heretic1-0-1
','Heretic1-0-1
','2000-01-01 00:00:00'),
(33,'AtlasOF_AugCon','Heretic1-0-2
','Heretic1-0-2
','2000-01-01 00:00:00'),
(33,'AtlasOF_AugDex','Heretic1-0-3
','Heretic1-0-3
','2000-01-01 00:00:00'),
(33,'AtlasOF_AugQui','Heretic1-0-4
','Heretic1-0-4
','2000-01-01 00:00:00'),
(33,'AtlasOF_AugStr','Heretic1-0-5
','Heretic1-0-5
','2000-01-01 00:00:00'),
(33,'AtlasOF_AvoidanceOfMagic','Heretic1-0-6
','Heretic1-0-6
','2000-01-01 00:00:00'),
(33,'AtlasOF_EtherealBond','Heretic1-0-7
','Heretic1-0-7
','2000-01-01 00:00:00'),
(33,'AtlasOF_Lifter','Heretic1-0-8
','Heretic1-0-8
','2000-01-01 00:00:00'),
(33,'AtlasOF_LongWind','Heretic1-0-9
','Heretic1-0-9
','2000-01-01 00:00:00'),
(33,'AtlasOF_MasteryOfBlocking','Heretic1-1-1
','Heretic1-1-1
','2000-01-01 00:00:00'),
(33,'AtlasOF_MasteryOfHealing','Heretic1-1-3
','Heretic1-1-3
','2000-01-01 00:00:00'),
(33,'AtlasOF_MasteryOfMagery','Heretic1-1-4
','Heretic1-1-4
','2000-01-01 00:00:00'),
(33,'AtlasOF_MasteryOfPain','Heretic1-1-5
','Heretic1-1-5
','2000-01-01 00:00:00'),
(33,'AtlasOF_Serenity','Heretic1-1-7
','Heretic1-1-7
','2000-01-01 00:00:00'),
(33,'AtlasOF_Toughness','Heretic1-1-8
','Heretic1-1-8
','2000-01-01 00:00:00'),
(33,'AtlasOF_VeilRecovery','Heretic1-1-9
','Heretic1-1-9
','2000-01-01 00:00:00'),
(33,'AtlasOF_WildHealing','Heretic1-2-1
','Heretic1-2-1
','2000-01-01 00:00:00'),
(33,'AtlasOF_WildPower','Heretic1-2-2
','Heretic1-2-2
','2000-01-01 00:00:00'),
(33,'AtlasOF_FirstAid','Heretic1-2-5
','Heretic1-2-5
','2000-01-01 00:00:00'),
(33,'AtlasOF_MasteryOfConcentration','Heretic1-2-6
','Heretic1-2-6
','2000-01-01 00:00:00'),
(33,'AtlasOF_MCL','Heretic1-2-7
','Heretic1-2-7
','2000-01-01 00:00:00'),
(33,'AtlasOF_PerfectRecovery','Heretic1-2-8
','Heretic1-2-8
','2000-01-01 00:00:00'),
(33,'AtlasOF_PurgeReduced','Heretic1-2-9
','Heretic1-2-9
','2000-01-01 00:00:00'),
(33,'AtlasOF_RagingPower','Heretic1-3-1
','Heretic1-3-1
','2000-01-01 00:00:00'),
(33,'AtlasOF_SecondWind','Heretic1-3-2
','Heretic1-3-2
','2000-01-01 00:00:00'),
(33,'AtlasOF_EmptyMind','Heretic1-3-3
','Heretic1-3-3
','2000-01-01 00:00:00'),
(60,'AtlasOF_AugAcuity','Mauler601-0-1
','Mauler601-0-1
','2000-01-01 00:00:00'),
(60,'AtlasOF_AugCon','Mauler601-0-2
','Mauler601-0-2
','2000-01-01 00:00:00'),
(60,'AtlasOF_AugDex','Mauler601-0-3
','Mauler601-0-3
','2000-01-01 00:00:00'),
(60,'AtlasOF_AugQui','Mauler601-0-4
','Mauler601-0-4
','2000-01-01 00:00:00'),
(60,'AtlasOF_AugStr','Mauler601-0-5
','Mauler601-0-5
','2000-01-01 00:00:00'),
(60,'AtlasOF_AvoidanceOfMagic','Mauler601-0-6
','Mauler601-0-6
','2000-01-01 00:00:00'),
(60,'AtlasOF_DeterminationHybrid','Mauler601-0-7
','Mauler601-0-7
','2000-01-01 00:00:00'),
(60,'AtlasOF_EtherealBond','Mauler601-0-8
','Mauler601-0-8
','2000-01-01 00:00:00'),
(60,'AtlasOF_Lifter','Mauler601-0-9
','Mauler601-0-9
','2000-01-01 00:00:00'),
(60,'AtlasOF_LongWind','Mauler601-1-1
','Mauler601-1-1
','2000-01-01 00:00:00'),
(60,'AtlasOF_MasteryOfMagery','Mauler601-1-4
','Mauler601-1-4
','2000-01-01 00:00:00'),
(60,'AtlasOF_MasteryOfPain','Mauler601-1-5
','Mauler601-1-5
','2000-01-01 00:00:00'),
(60,'AtlasOF_Serenity','Mauler601-1-7
','Mauler601-1-7
','2000-01-01 00:00:00'),
(60,'AtlasOF_Toughness','Mauler601-1-8
','Mauler601-1-8
','2000-01-01 00:00:00'),
(60,'AtlasOF_VeilRecovery','Mauler601-1-9
','Mauler601-1-9
','2000-01-01 00:00:00'),
(60,'AtlasOF_WildPower','Mauler601-2-1
','Mauler601-2-1
','2000-01-01 00:00:00'),
(60,'AtlasOF_FirstAid','Mauler601-2-3
','Mauler601-2-3
','2000-01-01 00:00:00'),
(60,'AtlasOF_IgnorePainTank','Mauler601-2-4
','Mauler601-2-4
','2000-01-01 00:00:00'),
(60,'AtlasOF_ReflexAttack','Mauler601-2-5
','Mauler601-2-5
','2000-01-01 00:00:00'),
(60,'AtlasOF_EmptyMind','Mauler601-2-6
','Mauler601-2-6
','2000-01-01 00:00:00'),
(60,'AtlasOF_PurgeReduced','Mauler601-2-7
','Mauler601-2-7
','2000-01-01 00:00:00'),
(60,'AtlasOF_ThornweedField','Mauler601-2-8
','Mauler601-2-8
','2000-01-01 00:00:00'),
(60,'AtlasOF_SecondWind','Mauler601-2-9
','Mauler601-2-9
','2000-01-01 00:00:00'),
(61,'AtlasOF_AugAcuity','Mauler611-0-1
','Mauler611-0-1
','2000-01-01 00:00:00'),
(61,'AtlasOF_AugCon','Mauler611-0-2
','Mauler611-0-2
','2000-01-01 00:00:00'),
(61,'AtlasOF_AugDex','Mauler611-0-3
','Mauler611-0-3
','2000-01-01 00:00:00'),
(61,'AtlasOF_AugQui','Mauler611-0-4
','Mauler611-0-4
','2000-01-01 00:00:00'),
(61,'AtlasOF_AugStr','Mauler611-0-5
','Mauler611-0-5
','2000-01-01 00:00:00'),
(61,'AtlasOF_AvoidanceOfMagic','Mauler611-0-6
','Mauler611-0-6
','2000-01-01 00:00:00'),
(61,'AtlasOF_DeterminationHybrid','Mauler611-0-7
','Mauler611-0-7
','2000-01-01 00:00:00'),
(61,'AtlasOF_EtherealBond','Mauler611-0-8
','Mauler611-0-8
','2000-01-01 00:00:00'),
(61,'AtlasOF_Lifter','Mauler611-0-9
','Mauler611-0-9
','2000-01-01 00:00:00'),
(61,'AtlasOF_LongWind','Mauler611-1-1
','Mauler611-1-1
','2000-01-01 00:00:00'),
(61,'AtlasOF_MasteryOfMagery','Mauler611-1-4
','Mauler611-1-4
','2000-01-01 00:00:00'),
(61,'AtlasOF_MasteryOfPain','Mauler611-1-5
','Mauler611-1-5
','2000-01-01 00:00:00'),
(61,'AtlasOF_Serenity','Mauler611-1-7
','Mauler611-1-7
','2000-01-01 00:00:00'),
(61,'AtlasOF_Toughness','Mauler611-1-8
','Mauler611-1-8
','2000-01-01 00:00:00'),
(61,'AtlasOF_VeilRecovery','Mauler611-1-9
','Mauler611-1-9
','2000-01-01 00:00:00'),
(61,'AtlasOF_WildPower','Mauler611-2-1
','Mauler611-2-1
','2000-01-01 00:00:00'),
(61,'AtlasOF_FirstAid','Mauler611-2-3
','Mauler611-2-3
','2000-01-01 00:00:00'),
(61,'AtlasOF_IgnorePainTank','Mauler611-2-4
','Mauler611-2-4
','2000-01-01 00:00:00'),
(61,'AtlasOF_ReflexAttack','Mauler611-2-5
','Mauler611-2-5
','2000-01-01 00:00:00'),
(61,'AtlasOF_EmptyMind','Mauler611-2-6
','Mauler611-2-6
','2000-01-01 00:00:00'),
(61,'AtlasOF_PurgeReduced','Mauler611-2-7
','Mauler611-2-7
','2000-01-01 00:00:00'),
(61,'AtlasOF_ThornweedField','Mauler611-2-8
','Mauler611-2-8
','2000-01-01 00:00:00'),
(61,'AtlasOF_SecondWind','Mauler611-2-9
','Mauler611-2-9
','2000-01-01 00:00:00'),
(62,'AtlasOF_AugAcuity','Mauler621-0-1
','Mauler621-0-1
','2000-01-01 00:00:00'),
(62,'AtlasOF_AugCon','Mauler621-0-2
','Mauler621-0-2
','2000-01-01 00:00:00'),
(62,'AtlasOF_AugDex','Mauler621-0-3
','Mauler621-0-3
','2000-01-01 00:00:00'),
(62,'AtlasOF_AugQui','Mauler621-0-4
','Mauler621-0-4
','2000-01-01 00:00:00'),
(62,'AtlasOF_AugStr','Mauler621-0-5
','Mauler621-0-5
','2000-01-01 00:00:00'),
(62,'AtlasOF_AvoidanceOfMagic','Mauler621-0-6
','Mauler621-0-6
','2000-01-01 00:00:00'),
(62,'AtlasOF_DeterminationHybrid','Mauler621-0-7
','Mauler621-0-7
','2000-01-01 00:00:00'),
(62,'AtlasOF_EtherealBond','Mauler621-0-8
','Mauler621-0-8
','2000-01-01 00:00:00'),
(62,'AtlasOF_Lifter','Mauler621-0-9
','Mauler621-0-9
','2000-01-01 00:00:00'),
(62,'AtlasOF_LongWind','Mauler621-1-1
','Mauler621-1-1
','2000-01-01 00:00:00'),
(62,'AtlasOF_MasteryOfMagery','Mauler621-1-4
','Mauler621-1-4
','2000-01-01 00:00:00'),
(62,'AtlasOF_MasteryOfPain','Mauler621-1-5
','Mauler621-1-5
','2000-01-01 00:00:00'),
(62,'AtlasOF_Serenity','Mauler621-1-7
','Mauler621-1-7
','2000-01-01 00:00:00'),
(62,'AtlasOF_Toughness','Mauler621-1-8
','Mauler621-1-8
','2000-01-01 00:00:00'),
(62,'AtlasOF_VeilRecovery','Mauler621-1-9
','Mauler621-1-9
','2000-01-01 00:00:00'),
(62,'AtlasOF_WildPower','Mauler621-2-1
','Mauler621-2-1
','2000-01-01 00:00:00'),
(62,'AtlasOF_FirstAid','Mauler621-2-3
','Mauler621-2-3
','2000-01-01 00:00:00'),
(62,'AtlasOF_IgnorePainTank','Mauler621-2-4
','Mauler621-2-4
','2000-01-01 00:00:00'),
(62,'AtlasOF_ReflexAttack','Mauler621-2-5
','Mauler621-2-5
','2000-01-01 00:00:00'),
(62,'AtlasOF_EmptyMind','Mauler621-2-6
','Mauler621-2-6
','2000-01-01 00:00:00'),
(62,'AtlasOF_PurgeReduced','Mauler621-2-7
','Mauler621-2-7
','2000-01-01 00:00:00'),
(62,'AtlasOF_ThornweedField','Mauler621-2-8
','Mauler621-2-8
','2000-01-01 00:00:00'),
(62,'AtlasOF_SecondWind','Mauler621-2-9
','Mauler621-2-9
','2000-01-01 00:00:00'),
(34,'AtlasOF_AugAcuity','Valkyrie1-0-1
','Valkyrie1-0-1
','2000-01-01 00:00:00'),
(34,'AtlasOF_AugCon','Valkyrie1-0-2
','Valkyrie1-0-2
','2000-01-01 00:00:00'),
(34,'AtlasOF_AugDex','Valkyrie1-0-3
','Valkyrie1-0-3
','2000-01-01 00:00:00'),
(34,'AtlasOF_AugQui','Valkyrie1-0-4
','Valkyrie1-0-4
','2000-01-01 00:00:00'),
(34,'AtlasOF_AugStr','Valkyrie1-0-5
','Valkyrie1-0-5
','2000-01-01 00:00:00'),
(34,'AtlasOF_AvoidanceOfMagic','Valkyrie1-0-6
','Valkyrie1-0-6
','2000-01-01 00:00:00'),
(34,'AtlasOF_DeterminationHybrid','Valkyrie1-0-7
','Valkyrie1-0-7
','2000-01-01 00:00:00'),
(34,'AtlasOF_EtherealBond','Valkyrie1-0-8
','Valkyrie1-0-8
','2000-01-01 00:00:00'),
(34,'AtlasOF_Lifter','Valkyrie1-0-9
','Valkyrie1-0-9
','2000-01-01 00:00:00'),
(34,'AtlasOF_LongWind','Valkyrie1-1-1
','Valkyrie1-1-1
','2000-01-01 00:00:00'),
(34,'AtlasOF_MasteryOfBlocking','Valkyrie1-1-2
','Valkyrie1-1-2
','2000-01-01 00:00:00'),
(34,'AtlasOF_MasteryOfHealing','Valkyrie1-1-4
','Valkyrie1-1-4
','2000-01-01 00:00:00'),
(34,'AtlasOF_MasteryOfMagery','Valkyrie1-1-5
','Valkyrie1-1-5
','2000-01-01 00:00:00'),
(34,'AtlasOF_MasteryOfPain','Valkyrie1-1-6
','Valkyrie1-1-6
','2000-01-01 00:00:00'),
(34,'AtlasOF_MasteryOfParrying','Valkyrie1-1-7
','Valkyrie1-1-7
','2000-01-01 00:00:00'),
(34,'AtlasOF_Serenity','Valkyrie1-1-8
','Valkyrie1-1-8
','2000-01-01 00:00:00'),
(34,'AtlasOF_Toughness','Valkyrie1-1-9
','Valkyrie1-1-9
','2000-01-01 00:00:00'),
(34,'AtlasOF_VeilRecovery','Valkyrie1-2-1
','Valkyrie1-2-1
','2000-01-01 00:00:00'),
(34,'AtlasOF_WildHealing','Valkyrie1-2-2
','Valkyrie1-2-2
','2000-01-01 00:00:00'),
(34,'AtlasOF_WildPower','Valkyrie1-2-3
','Valkyrie1-2-3
','2000-01-01 00:00:00'),
(34,'AtlasOF_FirstAid','Valkyrie1-2-6
','Valkyrie1-2-6
','2000-01-01 00:00:00'),
(34,'AtlasOF_Ichor','Valkyrie1-2-7
','Valkyrie1-2-7
','2000-01-01 00:00:00'),
(34,'AtlasOF_IgnorePainTank','Valkyrie1-2-8
','Valkyrie1-2-8
','2000-01-01 00:00:00'),
(34,'AtlasOF_MasteryOfConcentration','Valkyrie1-2-9
','Valkyrie1-2-9
','2000-01-01 00:00:00'),
(34,'AtlasOF_MCL','Valkyrie1-3-1
','Valkyrie1-3-1
','2000-01-01 00:00:00'),
(34,'AtlasOF_PurgeReduced','Valkyrie1-3-2
','Valkyrie1-3-2
','2000-01-01 00:00:00'),
(34,'AtlasOF_RagingPower','Valkyrie1-3-3
','Valkyrie1-3-3
','2000-01-01 00:00:00'),
(34,'AtlasOF_SecondWind','Valkyrie1-3-4
','Valkyrie1-3-4
','2000-01-01 00:00:00'),
(34,'AtlasOF_EmptyMind','Valkyrie1-3-5
','Valkyrie1-3-5
','2000-01-01 00:00:00'),
(58,'AtlasOF_AugCon','Vampiir1-0-1
','Vampiir1-0-1
','2000-01-01 00:00:00'),
(58,'AtlasOF_AugDex','Vampiir1-0-2
','Vampiir1-0-2
','2000-01-01 00:00:00'),
(58,'AtlasOF_AugQui','Vampiir1-0-3
','Vampiir1-0-3
','2000-01-01 00:00:00'),
(58,'AtlasOF_AugStr','Vampiir1-0-4
','Vampiir1-0-4
','2000-01-01 00:00:00'),
(58,'AtlasOF_AvoidanceOfMagic','Vampiir1-0-5
','Vampiir1-0-5
','2000-01-01 00:00:00'),
(58,'AtlasOF_Lifter','Vampiir1-0-6
','Vampiir1-0-6
','2000-01-01 00:00:00'),
(58,'AtlasOF_LongWind','Vampiir1-0-7
','Vampiir1-0-7
','2000-01-01 00:00:00'),
(58,'AtlasOF_MasteryOfPain','Vampiir1-0-8
','Vampiir1-0-8
','2000-01-01 00:00:00'),
(58,'AtlasOF_Toughness','Vampiir1-0-9
','Vampiir1-0-9
','2000-01-01 00:00:00'),
(58,'AtlasOF_VeilRecovery','Vampiir1-1-1
','Vampiir1-1-1
','2000-01-01 00:00:00'),
(58,'AtlasOF_FirstAid','Vampiir1-1-3
','Vampiir1-1-3
','2000-01-01 00:00:00'),
(58,'AtlasOF_IgnorePainTank','Vampiir1-1-4
','Vampiir1-1-4
','2000-01-01 00:00:00'),
(58,'AtlasOF_PurgeReduced','Vampiir1-1-5
','Vampiir1-1-5
','2000-01-01 00:00:00'),
(58,'AtlasOF_SecondWind','Vampiir1-1-6
','Vampiir1-1-6
','2000-01-01 00:00:00'),
(58,'AtlasOF_EmptyMind','Vampiir1-1-8
','Vampiir1-1-8
','2000-01-01 00:00:00'),
(58,'AtlasOF_ReflexAttack','Vampiir1-2-1
','Vampiir1-2-1
','2000-01-01 00:00:00'),
(59,'AtlasOF_AugAcuity','Warlock1-0-1
','Warlock1-0-1
','2000-01-01 00:00:00'),
(59,'AtlasOF_AugCon','Warlock1-0-2
','Warlock1-0-2
','2000-01-01 00:00:00'),
(59,'AtlasOF_AugDex','Warlock1-0-3
','Warlock1-0-3
','2000-01-01 00:00:00'),
(59,'AtlasOF_AugQui','Warlock1-0-4
','Warlock1-0-4
','2000-01-01 00:00:00'),
(59,'AtlasOF_AugStr','Warlock1-0-5
','Warlock1-0-5
','2000-01-01 00:00:00'),
(59,'AtlasOF_EtherealBond','Warlock1-0-6
','Warlock1-0-6
','2000-01-01 00:00:00'),
(59,'AtlasOF_Lifter','Warlock1-0-7
','Warlock1-0-7
','2000-01-01 00:00:00'),
(59,'AtlasOF_LongWind','Warlock1-0-8
','Warlock1-0-8
','2000-01-01 00:00:00'),
(59,'AtlasOF_MasteryOfMagery','Warlock1-1-1
','Warlock1-1-1
','2000-01-01 00:00:00'),
(59,'AtlasOF_Serenity','Warlock1-1-3
','Warlock1-1-3
','2000-01-01 00:00:00'),
(59,'AtlasOF_Toughness','Warlock1-1-4
','Warlock1-1-4
','2000-01-01 00:00:00'),
(59,'AtlasOF_VeilRecovery','Warlock1-1-5
','Warlock1-1-5
','2000-01-01 00:00:00'),
(59,'AtlasOF_WildPower','Warlock1-1-6
','Warlock1-1-6
','2000-01-01 00:00:00'),
(59,'AtlasOF_FirstAid','Warlock1-2-1
','Warlock1-2-1
','2000-01-01 00:00:00'),
(59,'AtlasOF_MCL','Warlock1-2-2
','Warlock1-2-2
','2000-01-01 00:00:00'),
(59,'AtlasOF_PurgeReduced','Warlock1-2-3
','Warlock1-2-3
','2000-01-01 00:00:00'),
(59,'AtlasOF_RagingPower','Warlock1-2-4
','Warlock1-2-4
','2000-01-01 00:00:00'),
(59,'AtlasOF_SecondWind','Warlock1-2-5
','Warlock1-2-5
','2000-01-01 00:00:00'),
(59,'AtlasOF_EmptyMind','Warlock1-2-6
','Warlock1-2-6
','2000-01-01 00:00:00'),
(59,'AtlasOF_VolcanicPillar','Warlock1-2-7','Warlock1-2-7','2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `CharClass` = `CharClass`;
