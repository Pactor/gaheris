-- Every broken Brain reference in the mob table.
--
-- Four of these were shouting on every boot:
--
--   GameNPC error in LoadFromDatabase: can not instantiate brain of type
--   DOL.AI.Brain.MidGjalpinulvaBrain for npc DOL.GS.MidGjalpinulva, name
--   Gjalpinulva.
--
-- GameNPC.LoadFromDatabase builds a brain with Assembly.CreateInstance, which
-- needs a public parameterless constructor. The three realm dragons and Tabor
-- have none -- their brains take arguments:
--
--   public MidGjalpinulvaBrain(Point3D spawnPoint)
--   public TaborBrain(int thinkInterval)
--
-- because they were never meant to be built from the database. Each of those
-- NPC classes calls SetOwnBrain itself in AddToWorld with the right arguments,
-- so the Brain column is not just wrong, it is a second attempt at a job
-- already done properly in code. Clearing it silences the error and changes
-- nothing else; the dragons keep the brains they always built themselves.
--
-- Auditing the other 264 distinct Brain values turned up two more classes of
-- fault, both of them silent. CreateInstance returns null for a type it cannot
-- find, and null is not an error, so these have never appeared in a log.
--
-- Nine rows named a class that exists under a different namespace: five carry
-- a doubled prefix, DOL.GS.Scripts.DOL.AI.Brain.something, one has no
-- namespace at all, and ParthananFarmController is in DOL.GS rather than
-- DOL.AI.Brain. Those NPCs have been quietly running on the default brain
-- instead of the one they were given. Fixed rather than cleared -- the classes
-- are there and the intent is plain.
--
-- 363 rows named a class that exists nowhere: NightSpawnBrain on 259 mobs and
-- DaySpawnBrain on 100, plus four singles. NightSpawn and DaySpawn extend
-- TimeDependentSpawnNpc and never call SetOwnBrain, so they have always run on
-- the default brain and will carry on doing exactly that. Clearing these
-- changes no behaviour; it stops the data claiming something untrue.

-- 1. Brains that cannot be constructed from the database. The NPC does it.
UPDATE mob SET Brain = NULL WHERE Brain IN (
    'DOL.AI.Brain.AlbGolestandtBrain',
    'DOL.AI.Brain.HibCuuldurachBrain',
    'DOL.AI.Brain.MidGjalpinulvaBrain',
    'DOL.AI.Brain.TaborBrain');

-- 2. Right class, wrong namespace.
UPDATE mob SET Brain = 'DOL.GS.ParthananFarmController'
 WHERE Brain = 'DOL.AI.Brain.ParthananFarmController';

UPDATE mob SET Brain = 'DOL.AI.Brain.GudlaugrBrain'
 WHERE Brain = 'DOL.GS.Scripts.DOL.AI.Brain.GudlaugrBrain';

UPDATE mob SET Brain = 'DOL.AI.Brain.HamarBrain'
 WHERE Brain = 'DOL.GS.Scripts.DOL.AI.Brain.HamarBrain';

UPDATE mob SET Brain = 'DOL.AI.Brain.JarlOrmarrBrain'
 WHERE Brain = 'DOL.GS.Scripts.DOL.AI.Brain.JarlOrmarrBrain';

UPDATE mob SET Brain = 'DOL.AI.Brain.ThaneDyggveBrain'
 WHERE Brain = 'DOL.GS.Scripts.DOL.AI.Brain.ThaneDyggveBrain';

UPDATE mob SET Brain = 'DOL.AI.Brain.UaimhLairmasterBrain'
 WHERE Brain = 'DOL.GS.Scripts.DOL.AI.Brain.UaimhLairmasterBrain';

UPDATE mob SET Brain = 'DOL.AI.Brain.GiantSporiteClusterBrain'
 WHERE Brain = 'GiantSporiteClusterBrain';

-- 3. Classes that do not exist in this server at all.
UPDATE mob SET Brain = NULL WHERE Brain IN (
    'DOL.AI.Brain.AggressiveBrain',
    'DOL.AI.Brain.DaySpawnBrain',
    'DOL.AI.Brain.JariBrain',
    'DOL.AI.Brain.MortyBrain',
    'DOL.AI.Brain.NightSpawnBrain',
    'DOL.AI.Brain.WaterSpiderGleekBrain');
