-- The Wizard's Realm Rank 5 ability, which was never granted to anybody.
--
-- Wall of Flame: instant cast, drops a ward at the caster's feet that pulses
-- fire damage in a 150 radius for 15 seconds, 400 damage every 3 seconds.
--
-- Nothing had to be written. The handler exists
-- (realmabilities/handlers/rr5/WallOfFlameAbility.cs), the pulsing static
-- exists (realmabilities/Statics/WallOfFlameBase.cs), and the ability row
-- exists -- AbilityID 122, Implementation
-- DOL.GS.RealmAbilities.WallOfFlameAbility. The core's values match the
-- published ones exactly: 400 damage, 15 seconds, pulse every 3, radius 150.
--
-- The only thing missing was this row: no class was ever granted it, so the
-- whole implementation sat unreachable, exactly as the other five RR5s did in
-- migration 107.
--
-- Migration 107 recorded that this one "cannot be granted, only written". That
-- was wrong, and the reason is worth keeping: the RR5 listing calls it "Wall
-- of Fire" and the game calls it "Wall of Flame". Searching for the name in
-- the source rather than the name in the code found nothing, and I concluded
-- nothing was there.
--
-- One discrepancy left alone: the ability page gives a fifteen minute reuse
-- and the core's GetReUseDelay returns 600, which is ten. Changing it means
-- subclassing the handler in scripts and repointing Implementation at it --
-- machinery for one number, on a single source, when most RR5s are on "a ten
-- or fifteen minute timer". Left as the core has it.

INSERT INTO classxrealmability_atlas
  (CharClass, AbilityKey, ClassXRealmAbility_ID, ClassXRealmAbility_Atlas_ID)
VALUES
  (7, 'Wall of Flame', 'Wizard-RR5', 'Wizard-RR5');
