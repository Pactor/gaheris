-- Four mobs were loading as plain GameNPC because their ClassType could not
-- be resolved. Region.cs takes the class name from the npctemplate when the
-- template replaces mob values, and falls back to a bare GameNPC on failure:
--
--   Error loading the following NPC ClassType(s), GameNPC used instead: ScoutArgyle
--   Error loading the following NPC ClassType(s), GameNPC used instead: QanrisDuros, 0
--   Error loading the following NPC ClassType(s), GameNPC used instead: DOL.GS.Scripts.RPTradeInMerchant

-- 1. Qan'ris Duros and Scout Argyle. Both classes exist in core --
--    scripts/namedmobs/.../QanrisDuros.cs and scripts/mobs/MidgardMobs/
--    ScoutArgyle.cs, both in namespace DOL.GS -- but the npctemplate rows
--    named them without the namespace, so CreateInstance never found them.
--    These two get their real behaviour back.
UPDATE npctemplate SET ClassType = 'DOL.GS.QanrisDuros'
 WHERE TemplateId = 60165072 AND ClassType = 'QanrisDuros';

UPDATE npctemplate SET ClassType = 'DOL.GS.ScoutArgyle'
 WHERE TemplateId = 60165671 AND ClassType = 'ScoutArgyle';

-- 2. One drakoran mage in Avalon carried the literal string '0' as its
--    ClassType. Junk from an old import.
UPDATE mob SET ClassType = 'DOL.GS.GameNPC'
 WHERE ClassType = '0';

-- 3. The three Void Merchants point at DOL.GS.Scripts.RPTradeInMerchant,
--    which exists in neither OpenDAoC nor DOLSharp, and all three have a
--    NULL ItemsListTemplateID -- there is no merchant list behind them, so
--    even with the class they would sell nothing. Left standing as ordinary
--    NPCs rather than deleted, pending a decision on building a real
--    realm-point trade-in merchant for the battlegrounds.
UPDATE mob SET ClassType = 'DOL.GS.GameNPC'
 WHERE ClassType = 'DOL.GS.Scripts.RPTradeInMerchant';
