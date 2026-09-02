-- The Atlantis portals were scenery.
--
-- Every "siam-he portal priest" and "taur portalmaster" in the three Haven
-- regions -- 58 NPCs -- carried ClassType DOL.GS.GameNPC, so right-clicking
-- one did nothing whatsoever. Same for the three loose Channelers. They look
-- exactly like the working portals next to them, which is why every one the
-- player tried appeared broken.
--
-- Point them at GaherisTeleporter and they answer with the same catalogue
-- every other warden offers, which is the whole reason the catalogue is a
-- table rather than a list of peers: a destination costs one row, and making
-- somewhere a departure point costs one ClassType.
--
-- Names and models are left alone; a portal priest still looks like a portal
-- priest.
UPDATE mob
   SET ClassType = 'DOL.GS.Scripts.GaherisTeleporter',
       Brain = NULL
 WHERE Region IN (30,45,46,47,70,71,72,73,88,89,90,93,130,145,146,147)
   AND ClassType = 'DOL.GS.GameNPC'
   AND (Name LIKE '%portal%' OR Name LIKE '%channeler%' OR Name LIKE '%djinn%'
        OR Name LIKE '%haven%' OR Name LIKE '%gate%');
