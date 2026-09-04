-- Point the server at GaherisPlayer instead of GamePlayer.
--
-- This is the change that lets an effect shrink a blow before it lands, which
-- three spells need and none could have. See scripts/core/DamageGate.cs for
-- why nothing short of this was enough: TakeDamage raises its event with
-- copied integers, so a script could watch a blow but never make one smaller.
--
-- The property already exists and already has this exact shape -- core reads
-- `player_class`, looks through its own assembly first and then through the
-- script assemblies, and falls back to plain GamePlayer with an error in the
-- log if the named class will not load. So the failure mode is the server this
-- repo had yesterday, not a server that will not run.
--
-- GaherisPlayer is deliberately thin: one override, of a method core calls
-- immediately before applying damage. Anything a script can already do should
-- stay in a script, because every line in that class is paid for by every
-- player on the server.
--
-- The error, if it ever happens, reads:
--   Could not instantiate player class 'DOL.GS.Scripts.GaherisPlayer', using 'GamePlayer' instead!
-- and appears at the moment somebody logs in rather than at boot.

UPDATE serverproperty
   SET Value = 'DOL.GS.Scripts.GaherisPlayer'
 WHERE `Key` = 'player_class';

INSERT INTO serverproperty (`Key`, Description, DefaultValue, Value, Category)
SELECT 'player_class',
       'What class should the server use for players',
       'DOL.GS.GamePlayer',
       'DOL.GS.Scripts.GaherisPlayer',
       'system'
 WHERE NOT EXISTS (SELECT 1 FROM serverproperty WHERE `Key` = 'player_class');
