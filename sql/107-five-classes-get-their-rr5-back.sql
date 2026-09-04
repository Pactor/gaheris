-- Five classes were never granted their Realm Rank 5 ability.
--
-- Every class is given a free class-specific ability at Realm Rank 5. Nine
-- classes in this database had none: Scout, Wizard, Friar, Hunter, Warden,
-- Ranger and the three Maulers.
--
-- For five of them the ability already exists in the `ability` table, with a
-- working Implementation pointing at a real handler class in the core. Nobody
-- was ever granted it, so it sat there unreachable. Names confirmed against a
-- published RR5 listing rather than guessed:
--
--   Scout   Shield Trip       throws the shield, rooting the target
--   Friar   Whirling Staff    PBAE that stops melee in a 350 radius
--   Hunter  Entwining Snakes  insta-cast PBAE 50% snare  (listed as "Entwining Stakes")
--   Warden  Fury of Nature    double style damage, returned to the group as healing
--   Ranger  Desperate Bowman  bow style, 300 damage and a 5 second stun
--
-- The row ids follow the convention the other explicitly-added RR5s use --
-- Heretic-RR5, Valkyrie-RR5, Bainshee-RR5 -- rather than the ClassN-x-y grid,
-- which is generated and would collide.
--
-- Ranger takes "Desperate Bowman". There are two rows, "Bowman" and "Bowmen",
-- identical in every field but the name and both pointing at
-- DesperateBowmanAbility. The singular one matches the handler and the
-- published name.
--
-- NOT fixed here, and why:
--
--   Wizard    "Wall of Fire" has no row in `ability` and no handler anywhere
--             in the core. It cannot be granted, only written.
--   Maulers   the RR5 listing does not cover them. They arrived in 2006, two
--             expansions after this data, and inventing one is not a fix.
--
-- Worth knowing before testing: Shield Trip, Entwining Snakes and Fury of
-- Nature all register handlers on GameLivingEvent.AttackedByEnemy or
-- AttackFinished, neither of which this server raises. They will be granted
-- and castable but parts of them will not fire. See docs/dead-events.md.

INSERT INTO classxrealmability_atlas
  (CharClass, AbilityKey, ClassXRealmAbility_ID, ClassXRealmAbility_Atlas_ID)
VALUES
  ( 3, 'Shield Trip',      'Scout-RR5',  'Scout-RR5'),
  (10, 'Whirling Staff',   'Friar-RR5',  'Friar-RR5'),
  (25, 'Entwining Snakes', 'Hunter-RR5', 'Hunter-RR5'),
  (46, 'Fury of Nature',   'Warden-RR5', 'Warden-RR5'),
  (50, 'Desperate Bowman', 'Ranger-RR5', 'Ranger-RR5');
