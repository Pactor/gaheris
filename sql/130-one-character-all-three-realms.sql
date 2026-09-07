-- ===========================================================================
--  130-one-character-all-three-realms.sql
--
--  Cross-realm items.
--
--  Gaheris is co-operative: one character walks all three realms, kills in all
--  three, and the drops come back with them. Refusing to let them use what
--  they picked up in Hibernia is a rule written for a server where they could
--  never have been there.
--
--  The property does two things, both in AbstractServerRules.CheckAbilityToUseItem.
--
--  It lifts the outright refusal:
--
--      if (!ServerProperties.Properties.ALLOW_CROSS_REALM_ITEMS)
--      {
--          if (item.Realm != 0 && item.Realm != (int) living.Realm)
--              return false;
--      }
--
--  and, past that, it switches the proficiency check from the item's realm to
--  the WEARER's, so the three realms' equivalents count as the same training:
--
--      case eObjectType.SlashingWeapon:
--          if (ALLOW_CROSS_REALM_ITEMS)
--              switch (living.Realm)
--              {
--                  case eRealm.Albion:   abilityCheck = Abilities.Weapon_Slashing; break;
--                  case eRealm.Hibernia: abilityCheck = Abilities.Weapon_Blades;   break;
--                  case eRealm.Midgard:  abilityCheck = Abilities.Weapon_Swords;   break;
--              }
--
--  So a Skald picks up an Albion slashing sword and it asks her for Swords,
--  which she has. Without this it asks for Weapon_Slashing, which no Midgard
--  class has ever had -- and it never got that far, because the realm gate
--  above refused it first. The same mapping covers crushing / blunt / hammers,
--  polearms / celtic spear / spears, thrust / piercing, and two-handed /
--  large weapons.
--
--  Bows are deliberately NOT equivalenced by that table, in core or here: a
--  longbow still asks for Weapon_Longbows. That is the live behaviour and it
--  stays.
--
--  Armour is unaffected in practice. It reads the wearer's own realm ability,
--  and a class is granted exactly one of AlbArmor, HibArmor or MidArmor -- so
--  the rung a character is trained to is the same either way. What changes is
--  that the armour is no longer refused for having come from somewhere else.
--
--  Hired companions have always ignored realm for ARMOUR, in MercenaryGear.WhyNot,
--  which takes the best of all three abilities. This is what makes their
--  weapons agree with that.
--
--  Head armour is the one exception core keeps, and it keeps it here too:
--
--      if (ALLOW_CROSS_REALM_ITEMS && item.Item_Type != (int) eEquipmentItems.HEAD)
--
--  Read at boot: needs a restart. Safe to re-run.
-- ===========================================================================

SET NAMES utf8mb4;
SET SESSION sql_mode='';

UPDATE `serverproperty` SET `Value` = 'True' WHERE `Key` = 'allow_cross_realm_items';

INSERT INTO `serverproperty` (`ServerProperty_ID`, `Category`, `Key`, `Description`, `DefaultValue`, `Value`)
SELECT UUID(), 'classes', 'allow_cross_realm_items',
       'Do we want to allow items to be equipped regardless of realm?', 'False', 'True'
WHERE NOT EXISTS (SELECT 1 FROM `serverproperty` WHERE `Key` = 'allow_cross_realm_items');

SELECT `Key`, `DefaultValue`, `Value` FROM `serverproperty`
WHERE `Key` = 'allow_cross_realm_items';
