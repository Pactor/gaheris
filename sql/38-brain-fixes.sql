-- Broken Brain references in the mob table.
--
-- This file is smaller than the audit that produced it, because most of what
-- that audit flagged turned out not to be broken. Both corrections are worth
-- recording, since the same mistakes are easy to make again.
--
-- FIRST: nested namespaces compound. Five rows read
-- DOL.GS.Scripts.DOL.AI.Brain.GudlaugrBrain and friends, which looks like a
-- doubled prefix and is not. Gudlaugr.cs opens "namespace DOL.GS.Scripts" at
-- line 11 and then "namespace DOL.AI.Brain" INSIDE it at line 94, so the type's
-- real full name is exactly what the database said. Reading only the nearest
-- namespace declaration gets this wrong. Those rows are correct and are left
-- alone.
--
-- SECOND: GameNPC.SaveIntoDatabase writes the runtime brain back:
--
--     if (Brain.GetType().FullName != typeof(StandardMobBrain).FullName)
--         mob.Brain = Brain.GetType().FullName;
--
-- so a Brain column cannot simply be cleared if the NPC installs a brain of
-- its own -- autosave puts the name straight back. That is why the three realm
-- dragons and Tabor are not touched here. Their brains take constructor
-- arguments:
--
--     public MidGjalpinulvaBrain(Point3D spawnPoint)
--     public TaborBrain(int thinkInterval)
--
-- so Assembly.CreateInstance, which needs a public parameterless constructor,
-- throws on every boot and logs "can not instantiate brain of type". Each of
-- those NPCs then calls SetOwnBrain itself in AddToWorld with the right
-- arguments, autosave writes the name back, and the cycle repeats. The error
-- is noise, the dragons work, and no change to this table can end it -- it
-- would take a code change to stop loading a brain the NPC is going to replace.

-- 1. ParthananFarmController. The column read
--    DOL.AI.Brain.ParthananFarmController -- the brain's name with "Brain"
--    missing off the end. The truncated name does resolve, to
--    DOL.GS.ParthananFarmController, which is the NPC and not a brain, so
--    "correcting" the namespace turns a silent miss into a thrown
--    InvalidCastException every boot. Clearing is right: the NPC installs the
--    real brain in its own constructor,
--
--      public ParthananFarmController() : base(new ParthananFarmControllerBrain())
--
--    and autosave then records that name correctly on its own.
UPDATE mob SET Brain = NULL
 WHERE Brain IN ('DOL.AI.Brain.ParthananFarmController',
                 'DOL.GS.ParthananFarmController');

-- 2. Missing namespace. GiantSporiteClusterBrain sits in a top level
--    "namespace DOL.AI.Brain" -- not nested, unlike the five above -- and the
--    row named it with no namespace at all, so it silently fell back to the
--    default brain.
UPDATE mob SET Brain = 'DOL.AI.Brain.GiantSporiteClusterBrain'
 WHERE Brain = 'GiantSporiteClusterBrain';

-- 3. Classes that exist nowhere in this server. CreateInstance returns null
--    for a type it cannot find, and null is not an error, so none of these has
--    ever appeared in a log: NightSpawnBrain on 259 mobs, DaySpawnBrain on
--    100, and four singles. NightSpawn and DaySpawn extend
--    TimeDependentSpawnNpc and never call SetOwnBrain, so they have always run
--    on StandardMobBrain and will carry on doing so -- and because that is the
--    one brain SaveIntoDatabase declines to write, the cleared column stays
--    cleared. This changes no behaviour; it stops the data claiming otherwise.
UPDATE mob SET Brain = NULL WHERE Brain IN (
    'DOL.AI.Brain.AggressiveBrain',
    'DOL.AI.Brain.DaySpawnBrain',
    'DOL.AI.Brain.JariBrain',
    'DOL.AI.Brain.MortyBrain',
    'DOL.AI.Brain.NightSpawnBrain',
    'DOL.AI.Brain.WaterSpiderGleekBrain');
