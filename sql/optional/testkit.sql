-- ===========================================================================
--  gaheris-testkit.sql
--
--  A testing kit, kept deliberately separate from gaheris-setup.sql so it can
--  be dropped without touching the real conversion.
--
--    * faster seal drops and softer keep doors, so a test loop takes minutes
--      rather than an evening
--    * a merchant in Tir na Nog stocking a level 50 Enchanter kit
--    * two custom items: one that doubles the power pool, one that makes the
--      pet and PBAoE hit hard
--
--  Item shapes (Object_Type, Item_Type, Model, AF/DPS) are copied from real
--  level 50 Hibernia items already in this database, so the client renders
--  them correctly. Only names and bonuses are ours.
--
--  Enchanter note: the pet scales off MANA spec and PBAoE off LIGHT spec, so
--  the strength item grants skill in both rather than raw stats. Live caps may
--  clamp some of these values -- they are set generously on purpose.
--
--  Safe to re-run. To remove: see the teardown block at the bottom.
-- ===========================================================================

SET NAMES utf8mb4;

-- itemtemplate.AllowedClasses is NOT NULL with no default, and an empty string
-- (all classes) is what we want for every item here. Relaxing sql_mode lets
-- MariaDB supply that implicit default rather than threading the column
-- through every tuple below.
SET SESSION sql_mode='';

-- ---------------------------------------------------------------------------
-- 1. Testing rates
-- ---------------------------------------------------------------------------
-- Seal drop chance is in hundredths of a percent. Stock gives a level 50 mob
-- 0.25 + 25*0.25 = 6.5%. This makes it 5 + 25*1 = 30%.
UPDATE `serverproperty` SET `Value`='500' WHERE `Key`='lootgenerator_dreadedseals_base_chance';
UPDATE `serverproperty` SET `Value`='100' WHERE `Key`='lootgenerator_dreadedseals_drop_chance_per_level';

-- Keep doors keep their real health. Instead the Heart of Agramon effect is
-- applied globally: door toughness is a straight percentage multiplier --
--
--     GetAdjustedDamage: (damage - damage * 5 * level / 100) * toughness / 100
--
-- so 100 -> 2000 is exactly the twenty-fold door damage the Heart grants on
-- live, and it applies to melee, spells and pet swings alike. doors_allowpetattack
-- is already True, so the pet contributes.
--
-- This is server-wide rather than gated on the equipped item. A true
-- item-gated, group-wide buff needs a hook inside GameKeepDoor.TakeDamage,
-- which is core code -- see the note in the plan.
UPDATE `serverproperty` SET `Value`='200'  WHERE `Key`='keep_doors_base_health';
UPDATE `serverproperty` SET `Value`='2000' WHERE `Key`='set_keep_door_toughness';
UPDATE `serverproperty` SET `Value`='2000' WHERE `Key`='set_tower_door_toughness';
UPDATE `serverproperty` SET `Value`='True' WHERE `Key`='doors_allowpetattack';

-- ---------------------------------------------------------------------------
-- 2. The two custom items
-- ---------------------------------------------------------------------------
-- Bonus types used: 2 Dex, 3 Con, 5 Int, 9 MaxMana, 10 MaxHealth, 65 Skill_Light,
-- 67 Skill_Mana, 156 Acuity, 191 CastingSpeed, 196 PowerPool, 198 SpellDamage.

-- Doubles the power pool. PowerPool is a percentage bonus, so 100 = +100%.
REPLACE INTO `itemtemplate`
 (`Id_nb`,`Name`,`Level`,`Item_Type`,`Object_Type`,`Model`,`Realm`,`Quality`,`Bonus`,`Weight`,
  `MaxCondition`,`Condition`,`MaxDurability`,`Durability`,`IsPickable`,`IsDropable`,`IsTradable`,
  `MaxCount`,`PackSize`,`Price`,`Description`,
  `Bonus1Type`,`Bonus1`,`Bonus2Type`,`Bonus2`,`Bonus3Type`,`Bonus3`,`Bonus4Type`,`Bonus4`)
 VALUES
 ('gaheris_wellspring','Wellspring of the Deep',50,29,41,101,0,100,35,5,
  50000,50000,50000,50000,1,1,1,1,1,0,
  'A cold weight in the palm. The well it draws on has no bottom.\n\nDoubles your power pool.',
  196,100, 156,50, 9,500, 191,10);

-- Pet and PBAoE. For an Enchanter the pet comes from Mana spec and the PBAoE
-- from Light spec, so skill in both does far more than raw stats would.
REPLACE INTO `itemtemplate`
 (`Id_nb`,`Name`,`Level`,`Item_Type`,`Object_Type`,`Model`,`Realm`,`Quality`,`Bonus`,`Weight`,
  `MaxCondition`,`Condition`,`MaxDurability`,`Durability`,`IsPickable`,`IsDropable`,`IsTradable`,
  `MaxCount`,`PackSize`,`Price`,`Description`,
  `Bonus1Type`,`Bonus1`,`Bonus2Type`,`Bonus2`,`Bonus3Type`,`Bonus3`,`Bonus4Type`,`Bonus4`,
  `Bonus5Type`,`Bonus5`)
 VALUES
 ('gaheris_sigil_servant','Sigil of the Bound Servant',50,35,41,101,0,100,35,5,
  50000,50000,50000,50000,1,1,1,1,1,0,
  'Something answers to it, and answers hard.\n\nGreatly strengthens the pet and your point-blank magic.',
  67,25, 65,25, 198,25, 5,60, 156,60);

-- ---------------------------------------------------------------------------
-- 3. Enchanter kit -- cloth armour, jewellery, staff
-- ---------------------------------------------------------------------------
-- Shapes cloned from real level 50 Hibernia items: cloth is Object_Type 32
-- with the models below, jewellery is Object_Type 41, staff is Object_Type 8
-- at 165 DPS.

REPLACE INTO `itemtemplate`
 (`Id_nb`,`Name`,`Level`,`Item_Type`,`Object_Type`,`Model`,`Realm`,`Quality`,`Bonus`,`Weight`,
  `DPS_AF`,`SPD_ABS`,`Hand`,`Type_Damage`,
  `MaxCondition`,`Condition`,`MaxDurability`,`Durability`,`IsPickable`,`IsDropable`,`IsTradable`,
  `MaxCount`,`PackSize`,`Price`,`Description`,
  `Bonus1Type`,`Bonus1`,`Bonus2Type`,`Bonus2`,`Bonus3Type`,`Bonus3`,`Bonus4Type`,`Bonus4`)
 VALUES
 ('gaheris_kit_head','Dread-Woven Circlet',50,21,32,826,3,100,35,10, 50,0,0,0,
  50000,50000,50000,50000,1,1,1,1,1,0,'Testing kit.',5,25,156,25,3,25,10,60),
 ('gaheris_kit_hands','Dread-Woven Gloves',50,22,32,381,3,100,35,10, 51,0,0,0,
  50000,50000,50000,50000,1,1,1,1,1,0,'Testing kit.',5,25,2,25,3,25,191,5),
 ('gaheris_kit_feet','Dread-Woven Boots',50,23,32,382,3,100,35,10, 50,0,0,0,
  50000,50000,50000,50000,1,1,1,1,1,0,'Testing kit.',5,25,4,25,3,25,10,60),
 ('gaheris_kit_torso','Dread-Woven Robe',50,25,32,378,3,100,35,10, 50,0,0,0,
  50000,50000,50000,50000,1,1,1,1,1,0,'Testing kit.',5,25,3,25,156,25,10,60),
 ('gaheris_kit_legs','Dread-Woven Leggings',50,27,32,379,3,100,35,10, 50,0,0,0,
  50000,50000,50000,50000,1,1,1,1,1,0,'Testing kit.',5,25,3,25,2,25,10,60),
 ('gaheris_kit_arms','Dread-Woven Sleeves',50,28,32,380,3,100,35,10, 50,0,0,0,
  50000,50000,50000,50000,1,1,1,1,1,0,'Testing kit.',5,25,2,25,156,25,10,60),
 ('gaheris_kit_neck','Dread-Woven Torc',50,24,41,101,0,100,35,5, 0,0,0,0,
  50000,50000,50000,50000,1,1,1,1,1,0,'Testing kit.',156,40,198,10,9,200,10,60),
 ('gaheris_kit_cloak','Dread-Woven Mantle',50,26,41,57,0,100,35,5, 0,0,0,0,
  50000,50000,50000,50000,1,1,1,1,1,0,'Testing kit.',5,30,198,10,191,5,10,60),
 ('gaheris_kit_bracer','Dread-Woven Bracer',50,33,41,101,0,100,35,5, 0,0,0,0,
  50000,50000,50000,50000,1,1,1,1,1,0,'Testing kit.',156,40,9,200,153,5,10,60),
 ('gaheris_kit_ring','Dread-Woven Band',50,35,41,101,0,100,35,5, 0,0,0,0,
  50000,50000,50000,50000,1,1,1,1,1,0,'Testing kit.',5,30,198,10,196,25,10,60),
 ('gaheris_kit_staff','Dread-Woven Staff',50,12,8,1173,3,100,35,45, 165,40,1,1,
  50000,50000,50000,50000,1,1,1,1,1,0,'Testing kit.',156,40,198,15,65,10,67,10);

-- ---------------------------------------------------------------------------
-- 3b. Heart of Agramon
-- ---------------------------------------------------------------------------
-- On live Gaheris the Heart is a jewel with a charge that multiplies the
-- group's damage to keep doors twenty fold, so groups break gates without
-- rams. A true damage multiplier needs a hook inside GameKeepDoor.TakeDamage,
-- which is core code -- so this is the data-only equivalent: a heavy direct
-- damage charge aimed at the door. With keep_doors_base_health at 20 a gate
-- holds about 1,000 hit points, so a charge or two opens it.
--
-- Shaped after spell 61003 (Odin's Hatred), an existing 3,000 damage nuke.

REPLACE INTO `spell`
 (`SpellID`,`Spell_ID`,`Name`,`Description`,`Type`,`Target`,`Damage`,`DamageType`,
  `Range`,`Radius`,`CastTime`,`RecastDelay`,`Power`,`ClientEffect`,`Icon`,
  `Message1`,`Message2`,`Uninterruptible`,`MoveCast`)
 VALUES
 (999001,'gaheris_heart_of_agramon','Heart of Agramon',
  'Strikes a keep door with the weight of the island itself.',
  'DirectDamage','Enemy',4000,12,
  1500,0,0,8,0,2958,2958,
  'The Heart pulses, and the gate shudders!','{0} strikes the gate!',1,1);

REPLACE INTO `itemtemplate`
 (`Id_nb`,`Name`,`Level`,`Item_Type`,`Object_Type`,`Model`,`Realm`,`Quality`,`Bonus`,`Weight`,
  `MaxCondition`,`Condition`,`MaxDurability`,`Durability`,`IsPickable`,`IsDropable`,`IsTradable`,
  `MaxCount`,`PackSize`,`Price`,`Description`,
  `SpellID`,`Charges`,`MaxCharges`,`CanUseEvery`,
  `Bonus1Type`,`Bonus1`,`Bonus2Type`,`Bonus2`)
 VALUES
 ('gaheris_heart_agramon','Heart of Agramon',50,29,41,101,0,100,35,5,
  50000,50000,50000,50000,1,1,1,1,1,0,
  'It beats, slowly, against the palm.\n\nUse: strikes a keep door for heavy damage.',
  999001,50,50,8,
  156,20, 10,100);

-- ---------------------------------------------------------------------------
-- 4. The merchant
-- ---------------------------------------------------------------------------
-- Placed beside Relena, the Hibernian seal collector in Tir na Nog, so both
-- ends of a test loop are in one spot.

DELETE FROM `merchantitem` WHERE `ItemListID`='gaheris_testkit';
INSERT INTO `merchantitem` (`ItemListID`,`PageNumber`,`SlotPosition`,`ItemTemplateID`,`MerchantItem_ID`) VALUES
 ('gaheris_testkit',0,0,'gaheris_kit_head','gtk_00'),
 ('gaheris_testkit',0,1,'gaheris_kit_torso','gtk_01'),
 ('gaheris_testkit',0,2,'gaheris_kit_arms','gtk_02'),
 ('gaheris_testkit',0,3,'gaheris_kit_hands','gtk_03'),
 ('gaheris_testkit',0,4,'gaheris_kit_legs','gtk_04'),
 ('gaheris_testkit',0,5,'gaheris_kit_feet','gtk_05'),
 ('gaheris_testkit',0,6,'gaheris_kit_staff','gtk_06'),
 ('gaheris_testkit',0,8,'gaheris_kit_neck','gtk_08'),
 ('gaheris_testkit',0,9,'gaheris_kit_cloak','gtk_09'),
 ('gaheris_testkit',0,10,'gaheris_kit_bracer','gtk_10'),
 ('gaheris_testkit',0,11,'gaheris_kit_ring','gtk_11'),
 ('gaheris_testkit',0,16,'gaheris_wellspring','gtk_16'),
 ('gaheris_testkit',0,17,'gaheris_sigil_servant','gtk_17'),
 ('gaheris_testkit',0,18,'gaheris_heart_agramon','gtk_18'),
 ('gaheris_testkit',0,24,'Strong_Potion_of_Power','gtk_24'),
 ('gaheris_testkit',0,25,'Strong_Potion_of_Endurance','gtk_25'),
 ('gaheris_testkit',0,26,'Strong_Potion_of_Healing','gtk_26'),
 ('gaheris_testkit',0,27,'Strong_Potion_of_Invigoration','gtk_27');

DELETE FROM `mob` WHERE `Mob_ID`='gaheris_quartermaster';
INSERT INTO `mob`
 (`Mob_ID`,`Name`,`Guild`,`ClassType`,`X`,`Y`,`Z`,`Heading`,`Region`,`Model`,`Size`,`Level`,`Realm`,
  `ItemsListTemplateID`,`Flags`,`AggroLevel`,`AggroRange`,`RespawnInterval`,`PackageID`,
  `Speed`,`Strength`,`Constitution`,`Dexterity`,`Quickness`,`Intelligence`,`Piety`,`Empathy`,`Charisma`,
  `OwnerID`,`VisibleWeaponSlots`,`HouseNumber`)
 VALUES
 ('gaheris_quartermaster','Dread Quartermaster','Testing Supplies','DOL.GS.GameMerchant',
  32290,33075,7998,2150,201,388,50,50,3,
  'gaheris_testkit',16,0,0,0,'GaherisTestKit',
  0,0,0,0,0,0,0,0,0, 0,0,0);

-- ---------------------------------------------------------------------------
-- Teardown -- run these to remove the kit and restore real rates
-- ---------------------------------------------------------------------------
-- DELETE FROM `mob` WHERE `Mob_ID`='gaheris_quartermaster';
-- DELETE FROM `merchantitem` WHERE `ItemListID`='gaheris_testkit';
-- DELETE FROM `itemtemplate` WHERE `Id_nb` LIKE 'gaheris\_%';
-- UPDATE `serverproperty` SET `Value`='25'  WHERE `Key`='lootgenerator_dreadedseals_base_chance';
-- UPDATE `serverproperty` SET `Value`='25'  WHERE `Key`='lootgenerator_dreadedseals_drop_chance_per_level';
-- UPDATE `serverproperty` SET `Value`='200'  WHERE `Key`='keep_doors_base_health';
-- UPDATE `serverproperty` SET `Value`='100'  WHERE `Key`='set_keep_door_toughness';
-- UPDATE `serverproperty` SET `Value`='100'  WHERE `Key`='set_tower_door_toughness';
