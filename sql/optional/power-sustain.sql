-- Power sustain for solo testing.
-- Server properties need a restart to take effect; item bonuses too, since
-- ItemTemplate is cached at load.

SET SESSION sql_mode='';

-- Mana regen: 25x, and no longer halved below 50% power.
UPDATE `serverproperty` SET `Value`='25'    WHERE `Key`='mana_regen_amount_modifier';
UPDATE `serverproperty` SET `Value`='False' WHERE `Key`='mana_regen_amount_halved_below_50_percent';
UPDATE `serverproperty` SET `Value`='10'    WHERE `Key`='endurance_regen_amount_modifier';

-- Wellspring of the Deep now also sustains power rather than just enlarging
-- the pool: PowerRegenerationAmount (151) and ArcaneSyphon (254), which
-- returns power on every cast.
UPDATE `itemtemplate` SET
  `Bonus1Type`=196, `Bonus1`=100,
  `Bonus2Type`=156, `Bonus2`=50,
  `Bonus3Type`=9,   `Bonus3`=500,
  `Bonus4Type`=151, `Bonus4`=100,
  `Bonus5Type`=254, `Bonus5`=50,
  `Description`='A cold weight in the palm. The well it draws on has no bottom.

Doubles your power pool, and refills it as fast as you can spend it.'
WHERE `Id_nb`='gaheris_wellspring';

-- Teardown:
-- UPDATE `serverproperty` SET `Value`='1'    WHERE `Key`='mana_regen_amount_modifier';
-- UPDATE `serverproperty` SET `Value`='True' WHERE `Key`='mana_regen_amount_halved_below_50_percent';
-- UPDATE `serverproperty` SET `Value`='1'    WHERE `Key`='endurance_regen_amount_modifier';
