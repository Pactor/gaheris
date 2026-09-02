-- Clear the stale OF teleporter brain off the converted mage-circle NPCs.
--
-- 16-portals.sql repointed nine OFTeleporter mobs at GaherisTeleporter but
-- left their Brain column set to MainTeleporterBrain. That brain opens with
--
--     OFTeleporter teleporter = Body as OFTeleporter;
--     foreach (GameSpellEffect activeEffect in teleporter.EffectList)
--
-- which is a null dereference the moment the body is anything else. The
-- brain only ticks when a player is near, so the warden rendered and then
-- vanished a second later as the ECS pulled the throwing entity out of the
-- world to keep the service alive:
--
--   Critical error encountered in NpcService: NullReferenceException
--      at MainTeleporterBrain.Think() OFTeleporters.cs:line 781
--   Calling RemoveFromWorld with (GaherisTeleporter name=Master Visur ...)
--
-- GaherisTeleporter wants no brain at all, same as the other 94 wardens.
UPDATE mob
   SET Brain = NULL
 WHERE ClassType = 'DOL.GS.Scripts.GaherisTeleporter'
   AND Brain IS NOT NULL;
