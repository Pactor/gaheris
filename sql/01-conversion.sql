-- ===========================================================================
--  gaheris-setup.sql
--
--  Rebuilds the Gaheris conversion on top of a fresh OpenDAoC-Database import.
--  Safe to re-run: every statement is idempotent.
--
--  NOT covered here, because it does not live in the database:
--    * GAME_TYPE=PvE          -> docker-compose.yml (gameserver environment)
--    * MonsterGarrison.cs     -> ~/opendaoc/scripts/, mounted at
--                                /app/scripts/custom and compiled at boot
--    * account PrivLevel      -> set per account by hand
--
--  Order matters: keeps must be converted before the hastener removal, which
--  keys off keep realm.
--
--  Target: OpenDAoC on Old Frontiers (regions 1, 100, 200).
-- ===========================================================================

SET NAMES utf8mb4;

-- ---------------------------------------------------------------------------
-- 1. Server properties
-- ---------------------------------------------------------------------------
-- Both code paths for all-realms character creation: modern packet libs ask
-- the rules class, but the inherited 1.75 SendLoginGranted reads this property
-- directly, and a 1.127 client hits both.
UPDATE `serverproperty` SET `Value`='True' WHERE `Key`='allow_all_realms';
-- Darkness Falls is open to every realm at all times on Gaheris.
UPDATE `serverproperty` SET `Value`='True' WHERE `Key`='allow_all_realms_df';
-- Relic keeps sit at level 10, so the cap has to allow it.
UPDATE `serverproperty` SET `Value`='10'   WHERE `Key`='max_keep_level';

-- ---------------------------------------------------------------------------
-- 2. The frontier falls to the forces of evil
-- ---------------------------------------------------------------------------
-- Targeted by explicit KeepID: matching on names is fragile, and the
-- equivalent upstream script has three faults doing exactly that.
--
-- Both Realm and OriginalRealm are zeroed. RelicGateMgr tests
-- `keep.Realm != keep.OriginalRealm` and would otherwise read every keep as
-- captured.
--
-- Portal keeps (20,21,22,23,24,25) keep their realms. They are travel
-- infrastructure, not raid targets.
UPDATE `keep` SET `Realm`=0, `OriginalRealm`=0 WHERE `KeepID` IN (
  50,51,52,53,54,55,56,          -- Albion frontier
  75,76,77,78,79,80,81,          -- Midgard frontier
  100,101,102,103,104,105,106,   -- Hibernia frontier
  57,58,82,198,110,111);         -- relic keeps

-- Difficulty tiers. On Gaheris a keep is worth 5 dreaded seals per level, so
-- these are the live 15 / 25 / 40 seal keeps.
UPDATE `keep` SET `Level`=3  WHERE `KeepID` IN (56, 81, 106);
UPDATE `keep` SET `Level`=5  WHERE `KeepID` IN (51,52,54,55, 76,77,78,80, 101,102,104,105);
UPDATE `keep` SET `Level`=8  WHERE `KeepID` IN (50,53, 75,79, 100,103);
UPDATE `keep` SET `Level`=10 WHERE `KeepID` IN (57,58,82,198,110,111);

-- ---------------------------------------------------------------------------
-- 3. Monster garrison
-- ---------------------------------------------------------------------------
-- In Old Frontiers the guards are mob rows, and Region.LoadFromDatabase falls
-- back to ScriptMgr.Scripts when a ClassType is not in GameServer.dll -- so
-- script classes resolve here. (Keep positions are the opposite: FillPositions
-- uses Assembly.GetExecutingAssembly() and silently yields nothing.)
--
-- Each Monster* class only changes appearance when Realm is None, falling
-- through to base behaviour otherwise, so realm-owned keeps are unaffected.
UPDATE `mob` SET `ClassType`='DOL.GS.Scripts.MonsterGuardFighter'
  WHERE `ClassType`='DOL.GS.Keeps.GuardFighter'      AND `Region` IN (1,100,200);
UPDATE `mob` SET `ClassType`='DOL.GS.Scripts.MonsterGuardArcher'
  WHERE `ClassType`='DOL.GS.Keeps.GuardArcher'       AND `Region` IN (1,100,200);
UPDATE `mob` SET `ClassType`='DOL.GS.Scripts.MonsterGuardStaticArcher'
  WHERE `ClassType`='DOL.GS.Keeps.GuardStaticArcher' AND `Region` IN (1,100,200);
UPDATE `mob` SET `ClassType`='DOL.GS.Scripts.MonsterGuardCommander'
  WHERE `ClassType`='DOL.GS.Keeps.GuardCommander'    AND `Region` IN (1,100,200);
UPDATE `mob` SET `ClassType`='DOL.GS.Scripts.MonsterGuardLord'
  WHERE `ClassType`='DOL.GS.Keeps.GuardLord'         AND `Region` IN (1,100,200);

-- 25 guards ignore mob.ClassType entirely: their template supplies a
-- non-default ClassType and has ReplaceMobValues set, which wins.
UPDATE `npctemplate` SET `ClassType`='DOL.GS.Scripts.MonsterGuardFighter'
  WHERE `TemplateId` IN (60158055, 60162291);

-- Deliberately left as core classes:
--   GuardCorpseSummoner -- AddToWorld dereferences Component.Keep.Level with
--                          no null guard, and mob-loaded guards have no
--                          Component. It works today; subclassing it means
--                          handling that null first.
--   GuardMerchant       -- a vendor, not a garrison.

-- ---------------------------------------------------------------------------
-- 4. Remove hasteners from evil-held keeps
-- ---------------------------------------------------------------------------
-- A keep held by the forces of evil should not offer players a speed buff.
-- Hasteners at the portal keeps survive, since those keeps kept their realms
-- and are how people travel. Depends on step 2 having run.
DELETE FROM `mob` WHERE `Mob_ID` IN (
  SELECT `Mob_ID` FROM (
    SELECT h.`Mob_ID` FROM `mob` h
    WHERE h.`ClassType`='DOL.GS.Keeps.FrontierHastener'
      AND h.`Region` IN (1,100,200)
      AND (SELECT k.`Realm` FROM `keep` k
           WHERE k.`Region`=h.`Region`
           ORDER BY (POW(k.`X`-h.`X`,2)+POW(k.`Y`-h.`Y`,2)) ASC LIMIT 1) = 0
  ) t);

-- ---------------------------------------------------------------------------
-- 5. Keep patrols
-- ---------------------------------------------------------------------------
-- The stock Patrol class takes a GameKeepComponent and is unusable here, since
-- Old Frontiers has no keep components. Instead each route is a normal mob
-- path, walked by PatrollingKeepGuardBrain (in MonsterGarrison.cs) for any
-- guard carrying a PathID.
--
-- Two things shape these routes:
--
--   * Waypoints are guards' own standing positions. A synthesised circle risks
--     points inside walls or off cliffs; ground a guard already occupies is
--     valid by definition.
--
--   * Guards are clustered by ELEVATION first. A keep garrison spans roughly
--     900 units of height -- courtyard, wall walk, tower tops -- so a single
--     ground-level circuit would march the wall guards through the air. Each
--     elevation band gets its own circuit, giving 2-3 routes per keep.
--
-- Guards join the circuit at their nearest waypoint rather than at step 1
-- (see PatrollingKeepGuardBrain.NearestWaypoint), so a fully-patrolling keep
-- spreads around its rings instead of forming one queue.
--
-- 109 guards are left standing: their elevation band held too few peers to
-- make a sensible circuit, mostly lone tower sentries.
--
-- Regenerate with mkpatrols.py if guard positions ever change.
DELETE FROM pathpoints WHERE PathID LIKE 'Gaheris\_Patrol\_%';
DELETE FROM path       WHERE PathID LIKE 'Gaheris\_Patrol\_%';
UPDATE mob SET PathID=NULL WHERE PathID LIKE 'Gaheris\_Patrol\_%';
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_50_100', 3, NOW(), 'Gaheris_Patrol_50_100');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_50_103', 3, NOW(), 'Gaheris_Patrol_50_103');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_50_106', 3, NOW(), 'Gaheris_Patrol_50_106');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_51_100', 3, NOW(), 'Gaheris_Patrol_51_100');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_51_103', 3, NOW(), 'Gaheris_Patrol_51_103');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_51_106', 3, NOW(), 'Gaheris_Patrol_51_106');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_52_100', 3, NOW(), 'Gaheris_Patrol_52_100');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_52_103', 3, NOW(), 'Gaheris_Patrol_52_103');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_52_106', 3, NOW(), 'Gaheris_Patrol_52_106');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_53_100', 3, NOW(), 'Gaheris_Patrol_53_100');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_53_103', 3, NOW(), 'Gaheris_Patrol_53_103');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_53_106', 3, NOW(), 'Gaheris_Patrol_53_106');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_54_100', 3, NOW(), 'Gaheris_Patrol_54_100');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_54_103', 3, NOW(), 'Gaheris_Patrol_54_103');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_54_106', 3, NOW(), 'Gaheris_Patrol_54_106');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_55_100', 3, NOW(), 'Gaheris_Patrol_55_100');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_55_103', 3, NOW(), 'Gaheris_Patrol_55_103');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_55_106', 3, NOW(), 'Gaheris_Patrol_55_106');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_56_100', 3, NOW(), 'Gaheris_Patrol_56_100');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_56_103', 3, NOW(), 'Gaheris_Patrol_56_103');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_56_106', 3, NOW(), 'Gaheris_Patrol_56_106');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_57_100', 3, NOW(), 'Gaheris_Patrol_57_100');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_57_103', 3, NOW(), 'Gaheris_Patrol_57_103');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_58_100', 3, NOW(), 'Gaheris_Patrol_58_100');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_75_100', 3, NOW(), 'Gaheris_Patrol_75_100');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_75_102', 3, NOW(), 'Gaheris_Patrol_75_102');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_75_106', 3, NOW(), 'Gaheris_Patrol_75_106');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_76_100', 3, NOW(), 'Gaheris_Patrol_76_100');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_76_102', 3, NOW(), 'Gaheris_Patrol_76_102');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_76_106', 3, NOW(), 'Gaheris_Patrol_76_106');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_77_100', 3, NOW(), 'Gaheris_Patrol_77_100');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_77_102', 3, NOW(), 'Gaheris_Patrol_77_102');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_77_106', 3, NOW(), 'Gaheris_Patrol_77_106');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_78_100', 3, NOW(), 'Gaheris_Patrol_78_100');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_78_102', 3, NOW(), 'Gaheris_Patrol_78_102');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_78_106', 3, NOW(), 'Gaheris_Patrol_78_106');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_79_100', 3, NOW(), 'Gaheris_Patrol_79_100');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_79_102', 3, NOW(), 'Gaheris_Patrol_79_102');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_79_106', 3, NOW(), 'Gaheris_Patrol_79_106');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_80_100', 3, NOW(), 'Gaheris_Patrol_80_100');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_80_102', 3, NOW(), 'Gaheris_Patrol_80_102');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_80_106', 3, NOW(), 'Gaheris_Patrol_80_106');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_81_100', 3, NOW(), 'Gaheris_Patrol_81_100');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_81_102', 3, NOW(), 'Gaheris_Patrol_81_102');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_81_106', 3, NOW(), 'Gaheris_Patrol_81_106');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_82_100', 3, NOW(), 'Gaheris_Patrol_82_100');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_100_100', 3, NOW(), 'Gaheris_Patrol_100_100');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_100_102', 3, NOW(), 'Gaheris_Patrol_100_102');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_100_108', 3, NOW(), 'Gaheris_Patrol_100_108');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_101_100', 3, NOW(), 'Gaheris_Patrol_101_100');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_101_103', 3, NOW(), 'Gaheris_Patrol_101_103');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_101_108', 3, NOW(), 'Gaheris_Patrol_101_108');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_102_100', 3, NOW(), 'Gaheris_Patrol_102_100');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_102_102', 3, NOW(), 'Gaheris_Patrol_102_102');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_102_108', 3, NOW(), 'Gaheris_Patrol_102_108');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_103_100', 3, NOW(), 'Gaheris_Patrol_103_100');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_103_103', 3, NOW(), 'Gaheris_Patrol_103_103');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_103_108', 3, NOW(), 'Gaheris_Patrol_103_108');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_104_100', 3, NOW(), 'Gaheris_Patrol_104_100');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_104_102', 3, NOW(), 'Gaheris_Patrol_104_102');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_104_108', 3, NOW(), 'Gaheris_Patrol_104_108');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_105_100', 3, NOW(), 'Gaheris_Patrol_105_100');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_105_102', 3, NOW(), 'Gaheris_Patrol_105_102');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_105_108', 3, NOW(), 'Gaheris_Patrol_105_108');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_106_100', 3, NOW(), 'Gaheris_Patrol_106_100');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_106_102', 3, NOW(), 'Gaheris_Patrol_106_102');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_106_108', 3, NOW(), 'Gaheris_Patrol_106_108');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_110_100', 3, NOW(), 'Gaheris_Patrol_110_100');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_111_92', 3, NOW(), 'Gaheris_Patrol_111_92');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_111_95', 3, NOW(), 'Gaheris_Patrol_111_95');
INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) VALUES ('Gaheris_Patrol_198_99', 3, NOW(), 'Gaheris_Patrol_198_99');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_50_100', 1, 653448, 346043, 6280, 250, 0, '', NOW(), 'Gaheris_Patrol_50_100_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_50_100', 2, 653452, 346517, 6280, 250, 0, '', NOW(), 'Gaheris_Patrol_50_100_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_50_100', 3, 653196, 346278, 6280, 250, 0, '', NOW(), 'Gaheris_Patrol_50_100_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_50_100', 4, 652934, 346513, 6276, 250, 0, '', NOW(), 'Gaheris_Patrol_50_100_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_50_100', 5, 651917, 346778, 6237, 250, 0, '', NOW(), 'Gaheris_Patrol_50_100_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_50_100', 6, 651973, 346712, 6257, 250, 0, '', NOW(), 'Gaheris_Patrol_50_100_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_50_100', 7, 651797, 346689, 6255, 250, 0, '', NOW(), 'Gaheris_Patrol_50_100_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_50_100', 8, 651905, 346620, 6280, 250, 0, '', NOW(), 'Gaheris_Patrol_50_100_8');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_50_100', 9, 652927, 346043, 6280, 250, 0, '', NOW(), 'Gaheris_Patrol_50_100_9');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_50_100', 10, 651892, 346253, 6280, 250, 0, '', NOW(), 'Gaheris_Patrol_50_100_10');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_50_100', 11, 651767, 346204, 6280, 250, 0, '', NOW(), 'Gaheris_Patrol_50_100_11');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_50_100', 12, 651893, 346132, 6280, 250, 0, '', NOW(), 'Gaheris_Patrol_50_100_12');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_50_103', 1, 652105, 345873, 6666, 250, 0, '', NOW(), 'Gaheris_Patrol_50_103_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_50_103', 2, 652074, 345328, 6682, 250, 0, '', NOW(), 'Gaheris_Patrol_50_103_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_50_103', 3, 652841, 345378, 6666, 250, 0, '', NOW(), 'Gaheris_Patrol_50_103_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_50_103', 4, 653889, 345924, 6666, 250, 0, '', NOW(), 'Gaheris_Patrol_50_103_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_50_103', 5, 653908, 346699, 6682, 250, 0, '', NOW(), 'Gaheris_Patrol_50_103_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_50_103', 6, 653064, 346667, 6666, 250, 0, '', NOW(), 'Gaheris_Patrol_50_103_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_50_103', 7, 652041, 346629, 6666, 250, 0, '', NOW(), 'Gaheris_Patrol_50_103_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_50_106', 1, 653843, 345110, 7130, 250, 0, '', NOW(), 'Gaheris_Patrol_50_106_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_50_106', 2, 653834, 345414, 7130, 250, 0, '', NOW(), 'Gaheris_Patrol_50_106_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_50_106', 3, 654111, 345106, 7130, 250, 0, '', NOW(), 'Gaheris_Patrol_50_106_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_50_106', 4, 654122, 345423, 7130, 250, 0, '', NOW(), 'Gaheris_Patrol_50_106_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_51_100', 1, 583999, 390590, 5848, 250, 0, '', NOW(), 'Gaheris_Patrol_51_100_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_51_100', 2, 584241, 390463, 5848, 250, 0, '', NOW(), 'Gaheris_Patrol_51_100_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_51_100', 3, 584056, 390220, 5848, 250, 0, '', NOW(), 'Gaheris_Patrol_51_100_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_51_100', 4, 584001, 389037, 5844, 250, 0, '', NOW(), 'Gaheris_Patrol_51_100_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_51_100', 5, 584079, 388967, 5846, 250, 0, '', NOW(), 'Gaheris_Patrol_51_100_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_51_100', 6, 584118, 389054, 5848, 250, 0, '', NOW(), 'Gaheris_Patrol_51_100_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_51_100', 7, 584541, 390339, 5848, 250, 0, '', NOW(), 'Gaheris_Patrol_51_100_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_51_100', 8, 584522, 389125, 5848, 250, 0, '', NOW(), 'Gaheris_Patrol_51_100_8');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_51_100', 9, 584582, 389023, 5848, 250, 0, '', NOW(), 'Gaheris_Patrol_51_100_9');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_51_100', 10, 584630, 389148, 5848, 250, 0, '', NOW(), 'Gaheris_Patrol_51_100_10');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_51_100', 11, 584479, 390693, 5848, 250, 0, '', NOW(), 'Gaheris_Patrol_51_100_11');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_51_103', 1, 583915, 390274, 6234, 250, 0, '', NOW(), 'Gaheris_Patrol_51_103_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_51_103', 2, 584120, 389261, 6234, 250, 0, '', NOW(), 'Gaheris_Patrol_51_103_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_51_103', 3, 584851, 389460, 6234, 250, 0, '', NOW(), 'Gaheris_Patrol_51_103_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_51_103', 4, 585382, 389514, 6250, 250, 0, '', NOW(), 'Gaheris_Patrol_51_103_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_51_103', 5, 585218, 390268, 6234, 250, 0, '', NOW(), 'Gaheris_Patrol_51_103_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_51_103', 6, 584491, 391199, 6234, 250, 0, '', NOW(), 'Gaheris_Patrol_51_103_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_51_103', 7, 583728, 391094, 6250, 250, 0, '', NOW(), 'Gaheris_Patrol_51_103_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_51_106', 1, 585330, 391305, 6698, 250, 0, '', NOW(), 'Gaheris_Patrol_51_106_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_51_106', 2, 585283, 391582, 6698, 250, 0, '', NOW(), 'Gaheris_Patrol_51_106_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_51_106', 3, 585030, 391252, 6698, 250, 0, '', NOW(), 'Gaheris_Patrol_51_106_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_51_106', 4, 584984, 391519, 6698, 250, 0, '', NOW(), 'Gaheris_Patrol_51_106_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_52_100', 1, 620276, 370590, 6136, 250, 0, '', NOW(), 'Gaheris_Patrol_52_100_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_52_100', 2, 620709, 370584, 6136, 250, 0, '', NOW(), 'Gaheris_Patrol_52_100_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_52_100', 3, 620466, 370395, 6136, 250, 0, '', NOW(), 'Gaheris_Patrol_52_100_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_52_100', 4, 620264, 370159, 6136, 250, 0, '', NOW(), 'Gaheris_Patrol_52_100_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_52_100', 5, 620716, 370133, 6136, 250, 0, '', NOW(), 'Gaheris_Patrol_52_100_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_52_100', 6, 620014, 369135, 6132, 250, 0, '', NOW(), 'Gaheris_Patrol_52_100_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_52_100', 7, 620109, 369230, 6150, 250, 0, '', NOW(), 'Gaheris_Patrol_52_100_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_52_100', 8, 620109, 369056, 6136, 250, 0, '', NOW(), 'Gaheris_Patrol_52_100_8');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_52_100', 9, 620196, 369143, 6165, 250, 0, '', NOW(), 'Gaheris_Patrol_52_100_9');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_52_100', 10, 620515, 369128, 6141, 250, 0, '', NOW(), 'Gaheris_Patrol_52_100_10');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_52_100', 11, 620578, 369030, 6136, 250, 0, '', NOW(), 'Gaheris_Patrol_52_100_11');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_52_100', 12, 620646, 369125, 6136, 250, 0, '', NOW(), 'Gaheris_Patrol_52_100_12');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_52_103', 1, 620139, 370309, 6522, 250, 0, '', NOW(), 'Gaheris_Patrol_52_103_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_52_103', 2, 620156, 369306, 6522, 250, 0, '', NOW(), 'Gaheris_Patrol_52_103_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_52_103', 3, 620912, 369356, 6522, 250, 0, '', NOW(), 'Gaheris_Patrol_52_103_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_52_103', 4, 621455, 369324, 6538, 250, 0, '', NOW(), 'Gaheris_Patrol_52_103_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_52_103', 5, 621406, 370086, 6522, 250, 0, '', NOW(), 'Gaheris_Patrol_52_103_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_52_103', 6, 620860, 371136, 6522, 250, 0, '', NOW(), 'Gaheris_Patrol_52_103_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_52_103', 7, 620087, 371150, 6538, 250, 0, '', NOW(), 'Gaheris_Patrol_52_103_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_52_106', 1, 621689, 371109, 6986, 250, 0, '', NOW(), 'Gaheris_Patrol_52_106_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_52_106', 2, 621684, 371367, 6986, 250, 0, '', NOW(), 'Gaheris_Patrol_52_106_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_52_106', 3, 621360, 371104, 6986, 250, 0, '', NOW(), 'Gaheris_Patrol_52_106_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_52_106', 4, 621361, 371374, 6986, 250, 0, '', NOW(), 'Gaheris_Patrol_52_106_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_53_100', 1, 623842, 406365, 6520, 250, 0, '', NOW(), 'Gaheris_Patrol_53_100_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_53_100', 2, 624265, 406416, 6520, 250, 0, '', NOW(), 'Gaheris_Patrol_53_100_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_53_100', 3, 624030, 406599, 6520, 250, 0, '', NOW(), 'Gaheris_Patrol_53_100_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_53_100', 4, 624277, 406818, 6520, 250, 0, '', NOW(), 'Gaheris_Patrol_53_100_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_53_100', 5, 624524, 407948, 6523, 250, 0, '', NOW(), 'Gaheris_Patrol_53_100_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_53_100', 6, 624446, 407870, 6528, 250, 0, '', NOW(), 'Gaheris_Patrol_53_100_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_53_100', 7, 624394, 407954, 6528, 250, 0, '', NOW(), 'Gaheris_Patrol_53_100_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_53_100', 8, 624442, 408053, 6518, 250, 0, '', NOW(), 'Gaheris_Patrol_53_100_8');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_53_100', 9, 623809, 406838, 6520, 250, 0, '', NOW(), 'Gaheris_Patrol_53_100_9');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_53_100', 10, 624015, 408008, 6522, 250, 0, '', NOW(), 'Gaheris_Patrol_53_100_10');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_53_100', 11, 623975, 408082, 6523, 250, 0, '', NOW(), 'Gaheris_Patrol_53_100_11');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_53_100', 12, 623903, 408023, 6520, 250, 0, '', NOW(), 'Gaheris_Patrol_53_100_12');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_53_103', 1, 623687, 405959, 6906, 250, 0, '', NOW(), 'Gaheris_Patrol_53_103_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_53_103', 2, 624468, 405926, 6922, 250, 0, '', NOW(), 'Gaheris_Patrol_53_103_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_53_103', 3, 624416, 406778, 6906, 250, 0, '', NOW(), 'Gaheris_Patrol_53_103_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_53_103', 4, 624389, 407805, 6906, 250, 0, '', NOW(), 'Gaheris_Patrol_53_103_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_53_103', 5, 623634, 407724, 6906, 250, 0, '', NOW(), 'Gaheris_Patrol_53_103_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_53_103', 6, 623097, 407764, 6922, 250, 0, '', NOW(), 'Gaheris_Patrol_53_103_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_53_103', 7, 623134, 406999, 6906, 250, 0, '', NOW(), 'Gaheris_Patrol_53_103_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_53_106', 1, 622864, 405982, 7370, 250, 0, '', NOW(), 'Gaheris_Patrol_53_106_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_53_106', 2, 622856, 405707, 7370, 250, 0, '', NOW(), 'Gaheris_Patrol_53_106_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_53_106', 3, 623168, 405994, 7370, 250, 0, '', NOW(), 'Gaheris_Patrol_53_106_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_53_106', 4, 623164, 405691, 7370, 250, 0, '', NOW(), 'Gaheris_Patrol_53_106_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_54_100', 1, 582519, 365525, 5848, 250, 0, '', NOW(), 'Gaheris_Patrol_54_100_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_54_100', 2, 582974, 365619, 5848, 250, 0, '', NOW(), 'Gaheris_Patrol_54_100_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_54_100', 3, 582723, 365730, 5848, 250, 0, '', NOW(), 'Gaheris_Patrol_54_100_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_54_100', 4, 582896, 365997, 5848, 250, 0, '', NOW(), 'Gaheris_Patrol_54_100_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_54_100', 5, 582972, 367131, 5848, 250, 0, '', NOW(), 'Gaheris_Patrol_54_100_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_54_100', 6, 582915, 367033, 5848, 250, 0, '', NOW(), 'Gaheris_Patrol_54_100_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_54_100', 7, 582869, 367240, 5848, 250, 0, '', NOW(), 'Gaheris_Patrol_54_100_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_54_100', 8, 582812, 367114, 5848, 250, 0, '', NOW(), 'Gaheris_Patrol_54_100_8');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_54_100', 9, 582437, 365918, 5848, 250, 0, '', NOW(), 'Gaheris_Patrol_54_100_9');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_54_100', 10, 582465, 367067, 5848, 250, 0, '', NOW(), 'Gaheris_Patrol_54_100_10');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_54_100', 11, 582389, 367161, 5817, 250, 0, '', NOW(), 'Gaheris_Patrol_54_100_11');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_54_100', 12, 582331, 367043, 5848, 250, 0, '', NOW(), 'Gaheris_Patrol_54_100_12');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_54_103', 1, 582480, 365027, 6234, 250, 0, '', NOW(), 'Gaheris_Patrol_54_103_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_54_103', 2, 583248, 365126, 6250, 250, 0, '', NOW(), 'Gaheris_Patrol_54_103_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_54_103', 3, 583065, 365952, 6234, 250, 0, '', NOW(), 'Gaheris_Patrol_54_103_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_54_103', 4, 582855, 366948, 6234, 250, 0, '', NOW(), 'Gaheris_Patrol_54_103_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_54_103', 5, 582124, 366764, 6234, 250, 0, '', NOW(), 'Gaheris_Patrol_54_103_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_54_103', 6, 581578, 366701, 6250, 250, 0, '', NOW(), 'Gaheris_Patrol_54_103_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_54_103', 7, 581756, 365954, 6234, 250, 0, '', NOW(), 'Gaheris_Patrol_54_103_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_54_106', 1, 581656, 364926, 6698, 250, 0, '', NOW(), 'Gaheris_Patrol_54_106_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_54_106', 2, 581949, 364967, 6698, 250, 0, '', NOW(), 'Gaheris_Patrol_54_106_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_54_106', 3, 581709, 364634, 6698, 250, 0, '', NOW(), 'Gaheris_Patrol_54_106_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_54_106', 4, 581997, 364712, 6698, 250, 0, '', NOW(), 'Gaheris_Patrol_54_106_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_55_100', 1, 546534, 336849, 4960, 250, 0, '', NOW(), 'Gaheris_Patrol_55_100_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_55_100', 2, 546847, 336531, 4960, 250, 0, '', NOW(), 'Gaheris_Patrol_55_100_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_55_100', 3, 546897, 336849, 4960, 250, 0, '', NOW(), 'Gaheris_Patrol_55_100_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_55_100', 4, 547253, 336911, 4960, 250, 0, '', NOW(), 'Gaheris_Patrol_55_100_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_55_100', 5, 548153, 337448, 4960, 250, 0, '', NOW(), 'Gaheris_Patrol_55_100_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_55_100', 6, 548062, 337439, 4960, 250, 0, '', NOW(), 'Gaheris_Patrol_55_100_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_55_100', 7, 548189, 337583, 4960, 250, 0, '', NOW(), 'Gaheris_Patrol_55_100_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_55_100', 8, 548038, 337543, 4960, 250, 0, '', NOW(), 'Gaheris_Patrol_55_100_8');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_55_100', 9, 546949, 337235, 4960, 250, 0, '', NOW(), 'Gaheris_Patrol_55_100_9');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_55_100', 10, 547855, 337858, 4960, 250, 0, '', NOW(), 'Gaheris_Patrol_55_100_10');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_55_100', 11, 547854, 337951, 4960, 250, 0, '', NOW(), 'Gaheris_Patrol_55_100_11');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_55_100', 12, 547766, 337943, 4960, 250, 0, '', NOW(), 'Gaheris_Patrol_55_100_12');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_55_103', 1, 546145, 336640, 5346, 250, 0, '', NOW(), 'Gaheris_Patrol_55_103_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_55_103', 2, 546679, 336079, 5362, 250, 0, '', NOW(), 'Gaheris_Patrol_55_103_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_55_103', 3, 547254, 336699, 5346, 250, 0, '', NOW(), 'Gaheris_Patrol_55_103_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_55_103', 4, 547949, 337447, 5346, 250, 0, '', NOW(), 'Gaheris_Patrol_55_103_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_55_103', 5, 547376, 337943, 5346, 250, 0, '', NOW(), 'Gaheris_Patrol_55_103_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_55_103', 6, 547011, 338353, 5362, 250, 0, '', NOW(), 'Gaheris_Patrol_55_103_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_55_103', 7, 546495, 337778, 5346, 250, 0, '', NOW(), 'Gaheris_Patrol_55_103_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_55_106', 1, 545628, 336844, 5810, 250, 0, '', NOW(), 'Gaheris_Patrol_55_106_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_55_106', 2, 545605, 337272, 5810, 250, 0, '', NOW(), 'Gaheris_Patrol_55_106_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_55_106', 3, 545413, 337075, 5810, 250, 0, '', NOW(), 'Gaheris_Patrol_55_106_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_55_106', 4, 545829, 337052, 5810, 250, 0, '', NOW(), 'Gaheris_Patrol_55_106_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_56_100', 1, 580461, 429851, 4640, 250, 0, '', NOW(), 'Gaheris_Patrol_56_100_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_56_100', 2, 580052, 429863, 4640, 250, 0, '', NOW(), 'Gaheris_Patrol_56_100_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_56_100', 3, 580265, 429971, 4640, 250, 0, '', NOW(), 'Gaheris_Patrol_56_100_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_56_100', 4, 580453, 430103, 4640, 250, 0, '', NOW(), 'Gaheris_Patrol_56_100_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_56_100', 5, 580063, 430119, 4640, 250, 0, '', NOW(), 'Gaheris_Patrol_56_100_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_56_100', 6, 580764, 431273, 4616, 250, 0, '', NOW(), 'Gaheris_Patrol_56_100_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_56_100', 7, 580688, 431155, 4628, 250, 0, '', NOW(), 'Gaheris_Patrol_56_100_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_56_100', 8, 580699, 431360, 4609, 250, 0, '', NOW(), 'Gaheris_Patrol_56_100_8');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_56_100', 9, 580618, 431286, 4620, 250, 0, '', NOW(), 'Gaheris_Patrol_56_100_9');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_56_100', 10, 580242, 431290, 4628, 250, 0, '', NOW(), 'Gaheris_Patrol_56_100_10');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_56_100', 11, 580185, 431373, 4619, 250, 0, '', NOW(), 'Gaheris_Patrol_56_100_11');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_56_100', 12, 580116, 431286, 4628, 250, 0, '', NOW(), 'Gaheris_Patrol_56_100_12');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_56_103', 1, 579906, 429265, 5026, 250, 0, '', NOW(), 'Gaheris_Patrol_56_103_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_56_103', 2, 580682, 429230, 5042, 250, 0, '', NOW(), 'Gaheris_Patrol_56_103_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_56_103', 3, 580639, 430073, 5026, 250, 0, '', NOW(), 'Gaheris_Patrol_56_103_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_56_103', 4, 580611, 431084, 5026, 250, 0, '', NOW(), 'Gaheris_Patrol_56_103_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_56_103', 5, 579857, 431027, 5026, 250, 0, '', NOW(), 'Gaheris_Patrol_56_103_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_56_103', 6, 579314, 431060, 5042, 250, 0, '', NOW(), 'Gaheris_Patrol_56_103_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_56_103', 7, 579374, 430297, 5026, 250, 0, '', NOW(), 'Gaheris_Patrol_56_103_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_56_106', 1, 579064, 429281, 5490, 250, 0, '', NOW(), 'Gaheris_Patrol_56_106_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_56_106', 2, 579333, 429289, 5490, 250, 0, '', NOW(), 'Gaheris_Patrol_56_106_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_56_106', 3, 579060, 428982, 5490, 250, 0, '', NOW(), 'Gaheris_Patrol_56_106_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_56_106', 4, 579337, 428984, 5490, 250, 0, '', NOW(), 'Gaheris_Patrol_56_106_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_57_100', 1, 601298, 428721, 5664, 250, 0, '', NOW(), 'Gaheris_Patrol_57_100_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_57_100', 2, 601514, 429810, 5664, 250, 0, '', NOW(), 'Gaheris_Patrol_57_100_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_57_100', 3, 601381, 428797, 5664, 250, 0, '', NOW(), 'Gaheris_Patrol_57_100_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_57_100', 4, 601376, 428650, 5664, 250, 0, '', NOW(), 'Gaheris_Patrol_57_100_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_57_100', 5, 601457, 428732, 5664, 250, 0, '', NOW(), 'Gaheris_Patrol_57_100_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_57_100', 6, 601589, 429710, 5664, 250, 0, '', NOW(), 'Gaheris_Patrol_57_100_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_57_100', 7, 601693, 428776, 5664, 250, 0, '', NOW(), 'Gaheris_Patrol_57_100_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_57_100', 8, 601760, 428684, 5664, 250, 0, '', NOW(), 'Gaheris_Patrol_57_100_8');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_57_100', 9, 601766, 428838, 5664, 250, 0, '', NOW(), 'Gaheris_Patrol_57_100_9');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_57_100', 10, 601838, 428773, 5664, 250, 0, '', NOW(), 'Gaheris_Patrol_57_100_10');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_57_100', 11, 601659, 429821, 5664, 250, 0, '', NOW(), 'Gaheris_Patrol_57_100_11');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_57_103', 1, 600673, 429309, 6096, 250, 0, '', NOW(), 'Gaheris_Patrol_57_103_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_57_103', 2, 601598, 428982, 6073, 250, 0, '', NOW(), 'Gaheris_Patrol_57_103_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_57_103', 3, 602485, 429273, 6096, 250, 0, '', NOW(), 'Gaheris_Patrol_57_103_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_57_103', 4, 602532, 431609, 6096, 250, 0, '', NOW(), 'Gaheris_Patrol_57_103_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_58_100', 1, 506348, 308510, 6832, 250, 0, '', NOW(), 'Gaheris_Patrol_58_100_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_58_100', 2, 508091, 310122, 6832, 250, 0, '', NOW(), 'Gaheris_Patrol_58_100_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_58_100', 3, 508020, 310125, 6832, 250, 0, '', NOW(), 'Gaheris_Patrol_58_100_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_58_100', 4, 508096, 310221, 6832, 250, 0, '', NOW(), 'Gaheris_Patrol_58_100_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_58_100', 5, 507993, 310201, 6832, 250, 0, '', NOW(), 'Gaheris_Patrol_58_100_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_58_100', 6, 507258, 309468, 6832, 250, 0, '', NOW(), 'Gaheris_Patrol_58_100_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_58_100', 7, 507764, 310385, 6832, 250, 0, '', NOW(), 'Gaheris_Patrol_58_100_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_58_100', 8, 507766, 310486, 6832, 250, 0, '', NOW(), 'Gaheris_Patrol_58_100_8');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_58_100', 9, 507680, 310393, 6832, 250, 0, '', NOW(), 'Gaheris_Patrol_58_100_9');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_58_100', 10, 507251, 309570, 6832, 250, 0, '', NOW(), 'Gaheris_Patrol_58_100_10');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_58_100', 11, 507664, 310466, 6832, 250, 0, '', NOW(), 'Gaheris_Patrol_58_100_11');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_58_100', 12, 507124, 309541, 6832, 250, 0, '', NOW(), 'Gaheris_Patrol_58_100_12');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_75_100', 1, 648583, 583232, 7440, 250, 0, '', NOW(), 'Gaheris_Patrol_75_100_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_75_100', 2, 648817, 585480, 7361, 250, 0, '', NOW(), 'Gaheris_Patrol_75_100_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_75_100', 3, 648756, 584262, 7432, 250, 0, '', NOW(), 'Gaheris_Patrol_75_100_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_75_100', 4, 648743, 585555, 7360, 250, 0, '', NOW(), 'Gaheris_Patrol_75_100_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_75_100', 5, 648739, 584564, 7432, 250, 0, '', NOW(), 'Gaheris_Patrol_75_100_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_75_100', 6, 648497, 585612, 7357, 250, 0, '', NOW(), 'Gaheris_Patrol_75_100_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_75_100', 7, 648436, 585529, 7373, 250, 0, '', NOW(), 'Gaheris_Patrol_75_100_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_75_100', 8, 648349, 585603, 7358, 250, 0, '', NOW(), 'Gaheris_Patrol_75_100_8');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_75_100', 9, 648572, 584412, 7432, 250, 0, '', NOW(), 'Gaheris_Patrol_75_100_9');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_75_100', 10, 648403, 584548, 7432, 250, 0, '', NOW(), 'Gaheris_Patrol_75_100_10');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_75_100', 11, 648422, 584246, 7432, 250, 0, '', NOW(), 'Gaheris_Patrol_75_100_11');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_75_102', 1, 649538, 584210, 7688, 250, 0, '', NOW(), 'Gaheris_Patrol_75_102_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_75_102', 2, 649355, 584757, 7688, 250, 0, '', NOW(), 'Gaheris_Patrol_75_102_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_75_102', 3, 649037, 585016, 7688, 250, 0, '', NOW(), 'Gaheris_Patrol_75_102_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_75_102', 4, 648662, 585239, 7736, 250, 0, '', NOW(), 'Gaheris_Patrol_75_102_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_75_102', 5, 648114, 585016, 7688, 250, 0, '', NOW(), 'Gaheris_Patrol_75_102_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_75_102', 6, 647782, 584726, 7688, 250, 0, '', NOW(), 'Gaheris_Patrol_75_102_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_75_102', 7, 647614, 584212, 7688, 250, 0, '', NOW(), 'Gaheris_Patrol_75_102_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_75_106', 1, 648435, 583371, 8304, 250, 0, '', NOW(), 'Gaheris_Patrol_75_106_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_75_106', 2, 648471, 583242, 8304, 250, 0, '', NOW(), 'Gaheris_Patrol_75_106_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_75_106', 3, 648600, 582892, 8304, 250, 0, '', NOW(), 'Gaheris_Patrol_75_106_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_75_106', 4, 648817, 583277, 8304, 250, 0, '', NOW(), 'Gaheris_Patrol_75_106_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_76_100', 1, 676882, 626747, 5192, 250, 0, '', NOW(), 'Gaheris_Patrol_76_100_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_76_100', 2, 676996, 627763, 5184, 250, 0, '', NOW(), 'Gaheris_Patrol_76_100_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_76_100', 3, 677132, 628996, 5180, 250, 0, '', NOW(), 'Gaheris_Patrol_76_100_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_76_100', 4, 676996, 628028, 5184, 250, 0, '', NOW(), 'Gaheris_Patrol_76_100_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_76_100', 5, 677062, 628736, 5184, 250, 0, '', NOW(), 'Gaheris_Patrol_76_100_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_76_100', 6, 677089, 629112, 5161, 250, 0, '', NOW(), 'Gaheris_Patrol_76_100_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_76_100', 7, 677035, 628995, 5183, 250, 0, '', NOW(), 'Gaheris_Patrol_76_100_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_76_100', 8, 676875, 627919, 5184, 250, 0, '', NOW(), 'Gaheris_Patrol_76_100_8');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_76_100', 9, 676732, 628988, 5184, 250, 0, '', NOW(), 'Gaheris_Patrol_76_100_9');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_76_100', 10, 676641, 629125, 5158, 250, 0, '', NOW(), 'Gaheris_Patrol_76_100_10');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_76_100', 11, 676587, 628988, 5180, 250, 0, '', NOW(), 'Gaheris_Patrol_76_100_11');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_76_100', 12, 676752, 628034, 5184, 250, 0, '', NOW(), 'Gaheris_Patrol_76_100_12');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_76_102', 1, 677783, 627725, 5440, 250, 0, '', NOW(), 'Gaheris_Patrol_76_102_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_76_102', 2, 677660, 628279, 5440, 250, 0, '', NOW(), 'Gaheris_Patrol_76_102_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_76_102', 3, 677312, 628490, 5440, 250, 0, '', NOW(), 'Gaheris_Patrol_76_102_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_76_102', 4, 676967, 628755, 5488, 250, 0, '', NOW(), 'Gaheris_Patrol_76_102_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_76_102', 5, 676418, 628536, 5440, 250, 0, '', NOW(), 'Gaheris_Patrol_76_102_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_76_102', 6, 676146, 628222, 5440, 250, 0, '', NOW(), 'Gaheris_Patrol_76_102_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_76_102', 7, 675979, 627735, 5440, 250, 0, '', NOW(), 'Gaheris_Patrol_76_102_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_76_106', 1, 676659, 626770, 6056, 250, 0, '', NOW(), 'Gaheris_Patrol_76_106_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_76_106', 2, 676765, 626771, 6056, 250, 0, '', NOW(), 'Gaheris_Patrol_76_106_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_76_106', 3, 676836, 626427, 6056, 250, 0, '', NOW(), 'Gaheris_Patrol_76_106_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_76_106', 4, 677088, 626789, 6056, 250, 0, '', NOW(), 'Gaheris_Patrol_76_106_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_77_100', 1, 678844, 653362, 5702, 250, 0, '', NOW(), 'Gaheris_Patrol_77_100_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_77_100', 2, 679071, 654523, 5712, 250, 0, '', NOW(), 'Gaheris_Patrol_77_100_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_77_100', 3, 678926, 653201, 5676, 250, 0, '', NOW(), 'Gaheris_Patrol_77_100_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_77_100', 4, 678993, 653594, 5712, 250, 0, '', NOW(), 'Gaheris_Patrol_77_100_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_77_100', 5, 679084, 654250, 5712, 250, 0, '', NOW(), 'Gaheris_Patrol_77_100_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_77_100', 6, 679083, 653340, 5704, 250, 0, '', NOW(), 'Gaheris_Patrol_77_100_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_77_100', 7, 679263, 653319, 5704, 250, 0, '', NOW(), 'Gaheris_Patrol_77_100_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_77_100', 8, 679205, 654414, 5712, 250, 0, '', NOW(), 'Gaheris_Patrol_77_100_8');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_77_100', 9, 679385, 653193, 5674, 250, 0, '', NOW(), 'Gaheris_Patrol_77_100_9');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_77_100', 10, 679309, 654260, 5712, 250, 0, '', NOW(), 'Gaheris_Patrol_77_100_10');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_77_100', 11, 679496, 653326, 5690, 250, 0, '', NOW(), 'Gaheris_Patrol_77_100_11');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_77_100', 12, 679302, 654533, 5712, 250, 0, '', NOW(), 'Gaheris_Patrol_77_100_12');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_77_102', 1, 678232, 654604, 5968, 250, 0, '', NOW(), 'Gaheris_Patrol_77_102_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_77_102', 2, 678419, 654056, 5968, 250, 0, '', NOW(), 'Gaheris_Patrol_77_102_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_77_102', 3, 678738, 653799, 5968, 250, 0, '', NOW(), 'Gaheris_Patrol_77_102_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_77_102', 4, 679112, 653574, 6016, 250, 0, '', NOW(), 'Gaheris_Patrol_77_102_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_77_102', 5, 679662, 653799, 5968, 250, 0, '', NOW(), 'Gaheris_Patrol_77_102_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_77_102', 6, 679995, 654088, 5968, 250, 0, '', NOW(), 'Gaheris_Patrol_77_102_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_77_102', 7, 680168, 654609, 5968, 250, 0, '', NOW(), 'Gaheris_Patrol_77_102_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_77_106', 1, 679320, 655572, 6584, 250, 0, '', NOW(), 'Gaheris_Patrol_77_106_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_77_106', 2, 679407, 655820, 6584, 250, 0, '', NOW(), 'Gaheris_Patrol_77_106_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_77_106', 3, 679086, 655475, 6584, 250, 0, '', NOW(), 'Gaheris_Patrol_77_106_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_77_106', 4, 678977, 655796, 6584, 250, 0, '', NOW(), 'Gaheris_Patrol_77_106_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_78_100', 1, 701496, 628117, 4424, 250, 0, '', NOW(), 'Gaheris_Patrol_78_100_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_78_100', 2, 701684, 630094, 4416, 250, 0, '', NOW(), 'Gaheris_Patrol_78_100_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_78_100', 3, 701688, 630343, 4402, 250, 0, '', NOW(), 'Gaheris_Patrol_78_100_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_78_100', 4, 701591, 629225, 4416, 250, 0, '', NOW(), 'Gaheris_Patrol_78_100_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_78_100', 5, 701591, 629393, 4416, 250, 0, '', NOW(), 'Gaheris_Patrol_78_100_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_78_100', 6, 701600, 630465, 4379, 250, 0, '', NOW(), 'Gaheris_Patrol_78_100_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_78_100', 7, 701526, 630339, 4403, 250, 0, '', NOW(), 'Gaheris_Patrol_78_100_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_78_100', 8, 701493, 629300, 4416, 250, 0, '', NOW(), 'Gaheris_Patrol_78_100_8');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_78_100', 9, 701368, 630332, 4404, 250, 0, '', NOW(), 'Gaheris_Patrol_78_100_9');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_78_100', 10, 701275, 630448, 4382, 250, 0, '', NOW(), 'Gaheris_Patrol_78_100_10');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_78_100', 11, 701211, 630322, 4406, 250, 0, '', NOW(), 'Gaheris_Patrol_78_100_11');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_78_100', 12, 701375, 629413, 4416, 250, 0, '', NOW(), 'Gaheris_Patrol_78_100_12');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_78_102', 1, 702458, 629088, 4672, 250, 0, '', NOW(), 'Gaheris_Patrol_78_102_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_78_102', 2, 702268, 629639, 4672, 250, 0, '', NOW(), 'Gaheris_Patrol_78_102_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_78_102', 3, 701950, 629896, 4672, 250, 0, '', NOW(), 'Gaheris_Patrol_78_102_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_78_102', 4, 701576, 630121, 4720, 250, 0, '', NOW(), 'Gaheris_Patrol_78_102_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_78_102', 5, 701026, 629896, 4672, 250, 0, '', NOW(), 'Gaheris_Patrol_78_102_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_78_102', 6, 700692, 629607, 4672, 250, 0, '', NOW(), 'Gaheris_Patrol_78_102_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_78_102', 7, 700513, 629084, 4672, 250, 0, '', NOW(), 'Gaheris_Patrol_78_102_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_78_106', 1, 701259, 627883, 5288, 250, 0, '', NOW(), 'Gaheris_Patrol_78_106_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_78_106', 2, 701385, 628131, 5288, 250, 0, '', NOW(), 'Gaheris_Patrol_78_106_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_78_106', 3, 701618, 628220, 5288, 250, 0, '', NOW(), 'Gaheris_Patrol_78_106_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_78_106', 4, 701706, 627883, 5288, 250, 0, '', NOW(), 'Gaheris_Patrol_78_106_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_79_100', 1, 706824, 656297, 5184, 250, 0, '', NOW(), 'Gaheris_Patrol_79_100_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_79_100', 2, 706927, 657216, 5184, 250, 0, '', NOW(), 'Gaheris_Patrol_79_100_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_79_100', 3, 706844, 656011, 5184, 250, 0, '', NOW(), 'Gaheris_Patrol_79_100_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_79_100', 4, 706936, 657006, 5184, 250, 0, '', NOW(), 'Gaheris_Patrol_79_100_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_79_100', 5, 706912, 655882, 5184, 250, 0, '', NOW(), 'Gaheris_Patrol_79_100_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_79_100', 6, 707022, 656006, 5184, 250, 0, '', NOW(), 'Gaheris_Patrol_79_100_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_79_100', 7, 707117, 656000, 5184, 250, 0, '', NOW(), 'Gaheris_Patrol_79_100_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_79_100', 8, 707025, 657147, 5184, 250, 0, '', NOW(), 'Gaheris_Patrol_79_100_8');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_79_100', 9, 707245, 655868, 5183, 250, 0, '', NOW(), 'Gaheris_Patrol_79_100_9');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_79_100', 10, 707309, 656000, 5184, 250, 0, '', NOW(), 'Gaheris_Patrol_79_100_10');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_79_100', 11, 707143, 657005, 5184, 250, 0, '', NOW(), 'Gaheris_Patrol_79_100_11');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_79_100', 12, 707135, 657226, 5184, 250, 0, '', NOW(), 'Gaheris_Patrol_79_100_12');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_79_102', 1, 706069, 657295, 5440, 250, 0, '', NOW(), 'Gaheris_Patrol_79_102_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_79_102', 2, 706259, 656744, 5440, 250, 0, '', NOW(), 'Gaheris_Patrol_79_102_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_79_102', 3, 706577, 656487, 5440, 250, 0, '', NOW(), 'Gaheris_Patrol_79_102_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_79_102', 4, 706952, 656262, 5488, 250, 0, '', NOW(), 'Gaheris_Patrol_79_102_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_79_102', 5, 707501, 656487, 5440, 250, 0, '', NOW(), 'Gaheris_Patrol_79_102_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_79_102', 6, 707835, 656776, 5440, 250, 0, '', NOW(), 'Gaheris_Patrol_79_102_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_79_102', 7, 708013, 657296, 5440, 250, 0, '', NOW(), 'Gaheris_Patrol_79_102_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_79_106', 1, 707270, 658502, 6056, 250, 0, '', NOW(), 'Gaheris_Patrol_79_106_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_79_106', 2, 707148, 658257, 6056, 250, 0, '', NOW(), 'Gaheris_Patrol_79_106_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_79_106', 3, 706922, 658155, 6056, 250, 0, '', NOW(), 'Gaheris_Patrol_79_106_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_79_106', 4, 706826, 658499, 6056, 250, 0, '', NOW(), 'Gaheris_Patrol_79_106_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_80_100', 1, 738425, 655860, 7024, 250, 0, '', NOW(), 'Gaheris_Patrol_80_100_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_80_100', 2, 738666, 656032, 7024, 250, 0, '', NOW(), 'Gaheris_Patrol_80_100_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_80_100', 3, 738418, 655761, 7024, 250, 0, '', NOW(), 'Gaheris_Patrol_80_100_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_80_100', 4, 738529, 655740, 7024, 250, 0, '', NOW(), 'Gaheris_Patrol_80_100_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_80_100', 5, 739381, 656634, 7024, 250, 0, '', NOW(), 'Gaheris_Patrol_80_100_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_80_100', 6, 739240, 656476, 7024, 250, 0, '', NOW(), 'Gaheris_Patrol_80_100_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_80_100', 7, 738713, 655605, 7024, 250, 0, '', NOW(), 'Gaheris_Patrol_80_100_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_80_100', 8, 738695, 655502, 7024, 250, 0, '', NOW(), 'Gaheris_Patrol_80_100_8');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_80_100', 9, 739395, 656472, 7024, 250, 0, '', NOW(), 'Gaheris_Patrol_80_100_9');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_80_100', 10, 738779, 655511, 7024, 250, 0, '', NOW(), 'Gaheris_Patrol_80_100_10');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_80_100', 11, 739392, 656305, 7024, 250, 0, '', NOW(), 'Gaheris_Patrol_80_100_11');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_80_100', 12, 739575, 656503, 7024, 250, 0, '', NOW(), 'Gaheris_Patrol_80_100_12');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_80_102', 1, 738584, 656760, 7280, 250, 0, '', NOW(), 'Gaheris_Patrol_80_102_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_80_102', 2, 738631, 656350, 7280, 250, 0, '', NOW(), 'Gaheris_Patrol_80_102_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_80_102', 3, 738726, 655922, 7328, 250, 0, '', NOW(), 'Gaheris_Patrol_80_102_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_80_102', 4, 739278, 655703, 7280, 250, 0, '', NOW(), 'Gaheris_Patrol_80_102_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_80_102', 5, 739721, 655668, 7280, 250, 0, '', NOW(), 'Gaheris_Patrol_80_102_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_80_102', 6, 740212, 655913, 7280, 250, 0, '', NOW(), 'Gaheris_Patrol_80_102_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_80_102', 7, 738836, 657283, 7280, 250, 0, '', NOW(), 'Gaheris_Patrol_80_102_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_80_106', 1, 740286, 657199, 7896, 250, 0, '', NOW(), 'Gaheris_Patrol_80_106_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_80_106', 2, 740550, 657293, 7896, 250, 0, '', NOW(), 'Gaheris_Patrol_80_106_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_80_106', 3, 740061, 657277, 7896, 250, 0, '', NOW(), 'Gaheris_Patrol_80_106_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_80_106', 4, 740213, 657604, 7896, 250, 0, '', NOW(), 'Gaheris_Patrol_80_106_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_81_100', 1, 699115, 679898, 6912, 250, 0, '', NOW(), 'Gaheris_Patrol_81_100_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_81_100', 2, 698624, 680695, 6904, 250, 0, '', NOW(), 'Gaheris_Patrol_81_100_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_81_100', 3, 698360, 680966, 6904, 250, 0, '', NOW(), 'Gaheris_Patrol_81_100_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_81_100', 4, 697709, 681735, 6902, 250, 0, '', NOW(), 'Gaheris_Patrol_81_100_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_81_100', 5, 697584, 681803, 6887, 250, 0, '', NOW(), 'Gaheris_Patrol_81_100_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_81_100', 6, 697694, 681634, 6904, 250, 0, '', NOW(), 'Gaheris_Patrol_81_100_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_81_100', 7, 697390, 681567, 6886, 250, 0, '', NOW(), 'Gaheris_Patrol_81_100_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_81_100', 8, 697260, 681593, 6865, 250, 0, '', NOW(), 'Gaheris_Patrol_81_100_8');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_81_100', 9, 698343, 680681, 6904, 250, 0, '', NOW(), 'Gaheris_Patrol_81_100_9');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_81_100', 10, 697378, 681454, 6904, 250, 0, '', NOW(), 'Gaheris_Patrol_81_100_10');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_81_100', 11, 697277, 681461, 6891, 250, 0, '', NOW(), 'Gaheris_Patrol_81_100_11');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_81_100', 12, 698069, 680631, 6904, 250, 0, '', NOW(), 'Gaheris_Patrol_81_100_12');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_81_102', 1, 697728, 679896, 7160, 250, 0, '', NOW(), 'Gaheris_Patrol_81_102_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_81_102', 2, 699107, 681269, 7160, 250, 0, '', NOW(), 'Gaheris_Patrol_81_102_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_81_102', 3, 698584, 681527, 7160, 250, 0, '', NOW(), 'Gaheris_Patrol_81_102_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_81_102', 4, 698174, 681480, 7160, 250, 0, '', NOW(), 'Gaheris_Patrol_81_102_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_81_102', 5, 697746, 681386, 7208, 250, 0, '', NOW(), 'Gaheris_Patrol_81_102_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_81_102', 6, 697527, 680833, 7160, 250, 0, '', NOW(), 'Gaheris_Patrol_81_102_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_81_102', 7, 697492, 680390, 7160, 250, 0, '', NOW(), 'Gaheris_Patrol_81_102_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_81_106', 1, 698930, 679887, 7776, 250, 0, '', NOW(), 'Gaheris_Patrol_81_106_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_81_106', 2, 699020, 679814, 7776, 250, 0, '', NOW(), 'Gaheris_Patrol_81_106_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_81_106', 3, 699136, 679556, 7776, 250, 0, '', NOW(), 'Gaheris_Patrol_81_106_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_81_106', 4, 699254, 680072, 7776, 250, 0, '', NOW(), 'Gaheris_Patrol_81_106_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_82_100', 1, 678769, 709887, 6912, 250, 0, '', NOW(), 'Gaheris_Patrol_82_100_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_82_100', 2, 678670, 709982, 6912, 250, 0, '', NOW(), 'Gaheris_Patrol_82_100_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_82_100', 3, 677726, 710328, 6912, 250, 0, '', NOW(), 'Gaheris_Patrol_82_100_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_82_100', 4, 678890, 709961, 6912, 250, 0, '', NOW(), 'Gaheris_Patrol_82_100_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_82_100', 5, 678773, 710071, 6912, 250, 0, '', NOW(), 'Gaheris_Patrol_82_100_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_82_100', 6, 677911, 710407, 6912, 250, 0, '', NOW(), 'Gaheris_Patrol_82_100_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_82_100', 7, 678846, 710520, 6912, 250, 0, '', NOW(), 'Gaheris_Patrol_82_100_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_82_100', 8, 678946, 710624, 6912, 250, 0, '', NOW(), 'Gaheris_Patrol_82_100_8');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_82_100', 9, 678739, 710652, 6912, 250, 0, '', NOW(), 'Gaheris_Patrol_82_100_9');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_82_100', 10, 678859, 710741, 6912, 250, 0, '', NOW(), 'Gaheris_Patrol_82_100_10');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_82_100', 11, 677780, 710587, 6912, 250, 0, '', NOW(), 'Gaheris_Patrol_82_100_11');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_100_100', 1, 426118, 318202, 4728, 250, 0, '', NOW(), 'Gaheris_Patrol_100_100_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_100_100', 2, 426583, 318202, 4728, 250, 0, '', NOW(), 'Gaheris_Patrol_100_100_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_100_100', 3, 426320, 318434, 4728, 250, 0, '', NOW(), 'Gaheris_Patrol_100_100_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_100_100', 4, 427556, 318178, 4728, 250, 0, '', NOW(), 'Gaheris_Patrol_100_100_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_100_100', 5, 427391, 318256, 4728, 250, 0, '', NOW(), 'Gaheris_Patrol_100_100_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_100_100', 6, 427700, 318273, 4728, 250, 0, '', NOW(), 'Gaheris_Patrol_100_100_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_100_100', 7, 427536, 318610, 4728, 250, 0, '', NOW(), 'Gaheris_Patrol_100_100_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_100_100', 8, 426100, 318708, 4728, 250, 0, '', NOW(), 'Gaheris_Patrol_100_100_8');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_100_100', 9, 426590, 318693, 4728, 250, 0, '', NOW(), 'Gaheris_Patrol_100_100_9');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_100_100', 10, 427453, 318668, 4728, 250, 0, '', NOW(), 'Gaheris_Patrol_100_100_10');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_100_100', 11, 427658, 318687, 4728, 250, 0, '', NOW(), 'Gaheris_Patrol_100_100_11');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_100_100', 12, 427527, 318752, 4728, 250, 0, '', NOW(), 'Gaheris_Patrol_100_100_12');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_100_102', 1, 425119, 318493, 5144, 250, 0, '', NOW(), 'Gaheris_Patrol_100_102_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_100_102', 2, 425099, 317669, 5144, 250, 0, '', NOW(), 'Gaheris_Patrol_100_102_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_100_102', 3, 427092, 317711, 5144, 250, 0, '', NOW(), 'Gaheris_Patrol_100_102_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_100_102', 4, 427065, 319750, 5144, 250, 0, '', NOW(), 'Gaheris_Patrol_100_102_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_100_102', 5, 425100, 319778, 5144, 250, 0, '', NOW(), 'Gaheris_Patrol_100_102_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_100_102', 6, 425148, 319060, 5144, 250, 0, '', NOW(), 'Gaheris_Patrol_100_102_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_100_102', 7, 425502, 318743, 5144, 250, 0, '', NOW(), 'Gaheris_Patrol_100_102_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_100_108', 1, 425076, 318624, 5944, 250, 0, '', NOW(), 'Gaheris_Patrol_100_108_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_100_108', 2, 425333, 318595, 5944, 250, 0, '', NOW(), 'Gaheris_Patrol_100_108_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_100_108', 3, 425342, 318861, 5944, 250, 0, '', NOW(), 'Gaheris_Patrol_100_108_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_100_108', 4, 425086, 318891, 5944, 250, 0, '', NOW(), 'Gaheris_Patrol_100_108_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_101_100', 1, 435970, 367981, 4088, 250, 0, '', NOW(), 'Gaheris_Patrol_101_100_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_101_100', 2, 437621, 367995, 4136, 250, 0, '', NOW(), 'Gaheris_Patrol_101_100_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_101_100', 3, 438308, 367994, 4135, 250, 0, '', NOW(), 'Gaheris_Patrol_101_100_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_101_100', 4, 437476, 368654, 4088, 250, 0, '', NOW(), 'Gaheris_Patrol_101_100_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_101_100', 5, 437313, 368386, 4088, 250, 0, '', NOW(), 'Gaheris_Patrol_101_100_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_101_100', 6, 437032, 368628, 4088, 250, 0, '', NOW(), 'Gaheris_Patrol_101_100_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_101_100', 7, 436086, 368487, 4088, 250, 0, '', NOW(), 'Gaheris_Patrol_101_100_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_101_100', 8, 435832, 368487, 4037, 250, 0, '', NOW(), 'Gaheris_Patrol_101_100_8');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_101_100', 9, 435953, 368381, 4082, 250, 0, '', NOW(), 'Gaheris_Patrol_101_100_9');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_101_100', 10, 437079, 368077, 4088, 250, 0, '', NOW(), 'Gaheris_Patrol_101_100_10');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_101_100', 11, 435971, 368113, 4088, 250, 0, '', NOW(), 'Gaheris_Patrol_101_100_11');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_101_100', 12, 436038, 368047, 4088, 250, 0, '', NOW(), 'Gaheris_Patrol_101_100_12');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_101_103', 1, 436337, 367085, 4504, 250, 0, '', NOW(), 'Gaheris_Patrol_101_103_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_101_103', 2, 437720, 366832, 4512, 250, 0, '', NOW(), 'Gaheris_Patrol_101_103_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_101_103', 3, 438398, 366955, 4504, 250, 0, '', NOW(), 'Gaheris_Patrol_101_103_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_101_103', 4, 438323, 367715, 4503, 250, 0, '', NOW(), 'Gaheris_Patrol_101_103_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_101_103', 5, 438048, 368013, 4503, 250, 0, '', NOW(), 'Gaheris_Patrol_101_103_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_101_103', 6, 438368, 368196, 4503, 250, 0, '', NOW(), 'Gaheris_Patrol_101_103_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_101_103', 7, 438309, 369109, 4504, 250, 0, '', NOW(), 'Gaheris_Patrol_101_103_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_101_103', 8, 437097, 369177, 4512, 250, 0, '', NOW(), 'Gaheris_Patrol_101_103_8');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_101_103', 9, 436340, 368931, 4504, 250, 0, '', NOW(), 'Gaheris_Patrol_101_103_9');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_101_103', 10, 436212, 368254, 4520, 250, 0, '', NOW(), 'Gaheris_Patrol_101_103_10');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_101_108', 1, 438217, 367887, 5304, 250, 0, '', NOW(), 'Gaheris_Patrol_101_108_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_101_108', 2, 438481, 367887, 5304, 250, 0, '', NOW(), 'Gaheris_Patrol_101_108_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_101_108', 3, 438486, 368106, 5304, 250, 0, '', NOW(), 'Gaheris_Patrol_101_108_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_101_108', 4, 438201, 368103, 5304, 250, 0, '', NOW(), 'Gaheris_Patrol_101_108_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_102_100', 1, 402944, 366173, 4840, 250, 0, '', NOW(), 'Gaheris_Patrol_102_100_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_102_100', 2, 403553, 367031, 4792, 250, 0, '', NOW(), 'Gaheris_Patrol_102_100_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_102_100', 3, 403543, 367496, 4792, 250, 0, '', NOW(), 'Gaheris_Patrol_102_100_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_102_100', 4, 403267, 367295, 4792, 250, 0, '', NOW(), 'Gaheris_Patrol_102_100_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_102_100', 5, 403526, 368482, 4792, 250, 0, '', NOW(), 'Gaheris_Patrol_102_100_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_102_100', 6, 403429, 368358, 4792, 250, 0, '', NOW(), 'Gaheris_Patrol_102_100_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_102_100', 7, 403315, 368470, 4792, 250, 0, '', NOW(), 'Gaheris_Patrol_102_100_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_102_100', 8, 403073, 368471, 4792, 250, 0, '', NOW(), 'Gaheris_Patrol_102_100_8');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_102_100', 9, 402989, 368600, 4792, 250, 0, '', NOW(), 'Gaheris_Patrol_102_100_9');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_102_100', 10, 402941, 368359, 4792, 250, 0, '', NOW(), 'Gaheris_Patrol_102_100_10');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_102_100', 11, 402950, 367478, 4792, 250, 0, '', NOW(), 'Gaheris_Patrol_102_100_11');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_102_100', 12, 402866, 368491, 4792, 250, 0, '', NOW(), 'Gaheris_Patrol_102_100_12');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_102_102', 1, 401895, 366081, 5208, 250, 0, '', NOW(), 'Gaheris_Patrol_102_102_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_102_102', 2, 402623, 366136, 5208, 250, 0, '', NOW(), 'Gaheris_Patrol_102_102_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_102_102', 3, 402939, 366465, 5208, 250, 0, '', NOW(), 'Gaheris_Patrol_102_102_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_102_102', 4, 403150, 366096, 5208, 250, 0, '', NOW(), 'Gaheris_Patrol_102_102_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_102_102', 5, 403990, 366082, 5208, 250, 0, '', NOW(), 'Gaheris_Patrol_102_102_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_102_102', 6, 403994, 368065, 5208, 250, 0, '', NOW(), 'Gaheris_Patrol_102_102_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_102_102', 7, 403201, 368216, 5208, 250, 0, '', NOW(), 'Gaheris_Patrol_102_102_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_102_102', 8, 401888, 368069, 5208, 250, 0, '', NOW(), 'Gaheris_Patrol_102_102_8');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_102_108', 1, 402811, 366338, 6008, 250, 0, '', NOW(), 'Gaheris_Patrol_102_108_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_102_108', 2, 402775, 366087, 6008, 250, 0, '', NOW(), 'Gaheris_Patrol_102_108_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_102_108', 3, 403037, 366057, 6008, 250, 0, '', NOW(), 'Gaheris_Patrol_102_108_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_102_108', 4, 403104, 366309, 6008, 250, 0, '', NOW(), 'Gaheris_Patrol_102_108_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_103_100', 1, 397256, 399085, 4328, 250, 0, '', NOW(), 'Gaheris_Patrol_103_100_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_103_100', 2, 397465, 399355, 4328, 250, 0, '', NOW(), 'Gaheris_Patrol_103_100_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_103_100', 3, 397719, 399121, 4328, 250, 0, '', NOW(), 'Gaheris_Patrol_103_100_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_103_100', 4, 398700, 399193, 4328, 250, 0, '', NOW(), 'Gaheris_Patrol_103_100_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_103_100', 5, 398631, 399264, 4328, 250, 0, '', NOW(), 'Gaheris_Patrol_103_100_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_103_100', 6, 398843, 399277, 4328, 250, 0, '', NOW(), 'Gaheris_Patrol_103_100_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_103_100', 7, 398704, 399349, 4328, 250, 0, '', NOW(), 'Gaheris_Patrol_103_100_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_103_100', 8, 397263, 399700, 4328, 250, 0, '', NOW(), 'Gaheris_Patrol_103_100_8');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_103_100', 9, 398696, 399627, 4328, 250, 0, '', NOW(), 'Gaheris_Patrol_103_100_9');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_103_100', 10, 397663, 399705, 4328, 250, 0, '', NOW(), 'Gaheris_Patrol_103_100_10');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_103_100', 11, 398625, 399716, 4328, 250, 0, '', NOW(), 'Gaheris_Patrol_103_100_11');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_103_100', 12, 398831, 399716, 4328, 250, 0, '', NOW(), 'Gaheris_Patrol_103_100_12');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_103_103', 1, 396722, 398632, 4784, 250, 0, '', NOW(), 'Gaheris_Patrol_103_103_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_103_103', 2, 397477, 398567, 4752, 250, 0, '', NOW(), 'Gaheris_Patrol_103_103_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_103_103', 3, 398350, 399076, 4784, 250, 0, '', NOW(), 'Gaheris_Patrol_103_103_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_103_103', 4, 398400, 400002, 4752, 250, 0, '', NOW(), 'Gaheris_Patrol_103_103_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_103_103', 5, 398345, 400367, 4784, 250, 0, '', NOW(), 'Gaheris_Patrol_103_103_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_103_103', 6, 397094, 400921, 4752, 250, 0, '', NOW(), 'Gaheris_Patrol_103_103_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_103_103', 7, 396723, 400860, 4784, 250, 0, '', NOW(), 'Gaheris_Patrol_103_103_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_103_108', 1, 396248, 399599, 5544, 250, 0, '', NOW(), 'Gaheris_Patrol_103_108_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_103_108', 2, 396501, 399556, 5544, 250, 0, '', NOW(), 'Gaheris_Patrol_103_108_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_103_108', 3, 396541, 399860, 5544, 250, 0, '', NOW(), 'Gaheris_Patrol_103_108_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_103_108', 4, 396272, 399901, 5544, 250, 0, '', NOW(), 'Gaheris_Patrol_103_108_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_104_100', 1, 430963, 403525, 4952, 250, 0, '', NOW(), 'Gaheris_Patrol_104_100_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_104_100', 2, 433307, 403590, 5000, 250, 0, '', NOW(), 'Gaheris_Patrol_104_100_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_104_100', 3, 432017, 404230, 4952, 250, 0, '', NOW(), 'Gaheris_Patrol_104_100_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_104_100', 4, 432217, 403928, 4952, 250, 0, '', NOW(), 'Gaheris_Patrol_104_100_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_104_100', 5, 430927, 404155, 4952, 250, 0, '', NOW(), 'Gaheris_Patrol_104_100_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_104_100', 6, 430787, 404039, 4940, 250, 0, '', NOW(), 'Gaheris_Patrol_104_100_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_104_100', 7, 430944, 403933, 4952, 250, 0, '', NOW(), 'Gaheris_Patrol_104_100_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_104_100', 8, 432408, 403591, 4952, 250, 0, '', NOW(), 'Gaheris_Patrol_104_100_8');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_104_100', 9, 430804, 403599, 4952, 250, 0, '', NOW(), 'Gaheris_Patrol_104_100_9');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_104_102', 1, 431412, 402537, 5368, 250, 0, '', NOW(), 'Gaheris_Patrol_104_102_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_104_102', 2, 433395, 402525, 5368, 250, 0, '', NOW(), 'Gaheris_Patrol_104_102_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_104_102', 3, 433346, 403260, 5368, 250, 0, '', NOW(), 'Gaheris_Patrol_104_102_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_104_102', 4, 433021, 403576, 5368, 250, 0, '', NOW(), 'Gaheris_Patrol_104_102_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_104_102', 5, 433397, 403800, 5368, 250, 0, '', NOW(), 'Gaheris_Patrol_104_102_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_104_102', 6, 433397, 404639, 5368, 250, 0, '', NOW(), 'Gaheris_Patrol_104_102_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_104_102', 7, 431404, 404617, 5368, 250, 0, '', NOW(), 'Gaheris_Patrol_104_102_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_104_102', 8, 431272, 403843, 5368, 250, 0, '', NOW(), 'Gaheris_Patrol_104_102_8');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_104_108', 1, 433144, 403480, 6168, 250, 0, '', NOW(), 'Gaheris_Patrol_104_108_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_104_108', 2, 433434, 403445, 6168, 250, 0, '', NOW(), 'Gaheris_Patrol_104_108_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_104_108', 3, 433473, 403711, 6168, 250, 0, '', NOW(), 'Gaheris_Patrol_104_108_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_104_108', 4, 433187, 403754, 6168, 250, 0, '', NOW(), 'Gaheris_Patrol_104_108_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_105_100', 1, 414743, 442843, 2888, 250, 0, '', NOW(), 'Gaheris_Patrol_105_100_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_105_100', 2, 415453, 442795, 2888, 250, 0, '', NOW(), 'Gaheris_Patrol_105_100_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_105_100', 3, 414037, 442106, 2888, 250, 0, '', NOW(), 'Gaheris_Patrol_105_100_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_105_100', 4, 414169, 442120, 2888, 250, 0, '', NOW(), 'Gaheris_Patrol_105_100_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_105_100', 5, 414048, 441967, 2888, 250, 0, '', NOW(), 'Gaheris_Patrol_105_100_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_105_100', 6, 414192, 441998, 2888, 250, 0, '', NOW(), 'Gaheris_Patrol_105_100_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_105_100', 7, 414388, 441807, 2888, 250, 0, '', NOW(), 'Gaheris_Patrol_105_100_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_105_100', 8, 414334, 441645, 2888, 250, 0, '', NOW(), 'Gaheris_Patrol_105_100_8');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_105_100', 9, 414527, 441784, 2888, 250, 0, '', NOW(), 'Gaheris_Patrol_105_100_9');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_105_100', 10, 414502, 441678, 2888, 250, 0, '', NOW(), 'Gaheris_Patrol_105_100_10');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_105_100', 11, 416099, 443358, 2936, 250, 0, '', NOW(), 'Gaheris_Patrol_105_100_11');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_105_100', 12, 415073, 443182, 2888, 250, 0, '', NOW(), 'Gaheris_Patrol_105_100_12');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_105_102', 1, 414041, 442799, 3303, 250, 0, '', NOW(), 'Gaheris_Patrol_105_102_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_105_102', 2, 414493, 442121, 3304, 250, 0, '', NOW(), 'Gaheris_Patrol_105_102_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_105_102', 3, 415519, 441290, 3304, 250, 0, '', NOW(), 'Gaheris_Patrol_105_102_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_105_102', 4, 416923, 442697, 3304, 250, 0, '', NOW(), 'Gaheris_Patrol_105_102_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_105_102', 5, 416355, 443196, 3304, 250, 0, '', NOW(), 'Gaheris_Patrol_105_102_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_105_102', 6, 415919, 443172, 3304, 250, 0, '', NOW(), 'Gaheris_Patrol_105_102_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_105_102', 7, 416021, 443587, 3304, 250, 0, '', NOW(), 'Gaheris_Patrol_105_102_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_105_102', 8, 415437, 444188, 3304, 250, 0, '', NOW(), 'Gaheris_Patrol_105_102_8');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_105_108', 1, 416288, 443347, 4104, 250, 0, '', NOW(), 'Gaheris_Patrol_105_108_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_105_108', 2, 416049, 443182, 4104, 250, 0, '', NOW(), 'Gaheris_Patrol_105_108_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_105_108', 3, 416140, 443552, 4104, 250, 0, '', NOW(), 'Gaheris_Patrol_105_108_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_105_108', 4, 415901, 443399, 4104, 250, 0, '', NOW(), 'Gaheris_Patrol_105_108_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_106_100', 1, 369017, 395931, 4624, 250, 0, '', NOW(), 'Gaheris_Patrol_106_100_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_106_100', 2, 369037, 395480, 4624, 250, 0, '', NOW(), 'Gaheris_Patrol_106_100_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_106_100', 3, 369252, 395714, 4624, 250, 0, '', NOW(), 'Gaheris_Patrol_106_100_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_106_100', 4, 368995, 394496, 4624, 250, 0, '', NOW(), 'Gaheris_Patrol_106_100_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_106_100', 5, 369064, 394395, 4624, 250, 0, '', NOW(), 'Gaheris_Patrol_106_100_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_106_100', 6, 369120, 394491, 4624, 250, 0, '', NOW(), 'Gaheris_Patrol_106_100_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_106_100', 7, 369415, 394510, 4624, 250, 0, '', NOW(), 'Gaheris_Patrol_106_100_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_106_100', 8, 369482, 394388, 4624, 250, 0, '', NOW(), 'Gaheris_Patrol_106_100_8');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_106_100', 9, 369510, 395946, 4624, 250, 0, '', NOW(), 'Gaheris_Patrol_106_100_9');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_106_100', 10, 369521, 395506, 4624, 250, 0, '', NOW(), 'Gaheris_Patrol_106_100_10');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_106_100', 11, 369558, 394509, 4624, 250, 0, '', NOW(), 'Gaheris_Patrol_106_100_11');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_106_100', 12, 369535, 396834, 4672, 250, 0, '', NOW(), 'Gaheris_Patrol_106_100_12');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_106_102', 1, 368506, 394921, 5040, 250, 0, '', NOW(), 'Gaheris_Patrol_106_102_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_106_102', 2, 369281, 394800, 5040, 250, 0, '', NOW(), 'Gaheris_Patrol_106_102_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_106_102', 3, 370593, 394952, 5040, 250, 0, '', NOW(), 'Gaheris_Patrol_106_102_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_106_102', 4, 370584, 396913, 5040, 250, 0, '', NOW(), 'Gaheris_Patrol_106_102_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_106_102', 5, 369831, 396866, 5040, 250, 0, '', NOW(), 'Gaheris_Patrol_106_102_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_106_102', 6, 369588, 396565, 5040, 250, 0, '', NOW(), 'Gaheris_Patrol_106_102_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_106_102', 7, 369337, 396917, 5040, 250, 0, '', NOW(), 'Gaheris_Patrol_106_102_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_106_102', 8, 368492, 396907, 5040, 250, 0, '', NOW(), 'Gaheris_Patrol_106_102_8');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_106_108', 1, 369663, 396683, 5840, 250, 0, '', NOW(), 'Gaheris_Patrol_106_108_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_106_108', 2, 369688, 396915, 5840, 250, 0, '', NOW(), 'Gaheris_Patrol_106_108_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_106_108', 3, 369409, 396959, 5840, 250, 0, '', NOW(), 'Gaheris_Patrol_106_108_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_106_108', 4, 369382, 396724, 5840, 250, 0, '', NOW(), 'Gaheris_Patrol_106_108_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_110_100', 1, 401797, 464102, 2888, 250, 0, '', NOW(), 'Gaheris_Patrol_110_100_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_110_100', 2, 401818, 464192, 2888, 250, 0, '', NOW(), 'Gaheris_Patrol_110_100_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_110_100', 3, 401923, 464085, 2888, 250, 0, '', NOW(), 'Gaheris_Patrol_110_100_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_110_100', 4, 401903, 464212, 2888, 250, 0, '', NOW(), 'Gaheris_Patrol_110_100_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_110_100', 5, 402114, 464396, 2888, 250, 0, '', NOW(), 'Gaheris_Patrol_110_100_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_110_100', 6, 401208, 465029, 2888, 250, 0, '', NOW(), 'Gaheris_Patrol_110_100_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_110_100', 7, 402200, 464368, 2888, 250, 0, '', NOW(), 'Gaheris_Patrol_110_100_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_110_100', 8, 402092, 464485, 2888, 250, 0, '', NOW(), 'Gaheris_Patrol_110_100_8');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_110_100', 9, 401309, 464985, 2888, 250, 0, '', NOW(), 'Gaheris_Patrol_110_100_9');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_110_100', 10, 402195, 464463, 2888, 250, 0, '', NOW(), 'Gaheris_Patrol_110_100_10');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_110_100', 11, 401284, 465094, 2888, 250, 0, '', NOW(), 'Gaheris_Patrol_110_100_11');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_110_100', 12, 400312, 465968, 2888, 250, 0, '', NOW(), 'Gaheris_Patrol_110_100_12');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_111_92', 1, 348227, 371433, 4875, 250, 0, '', NOW(), 'Gaheris_Patrol_111_92_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_111_92', 2, 348305, 371503, 4880, 250, 0, '', NOW(), 'Gaheris_Patrol_111_92_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_111_92', 3, 348447, 372493, 4880, 250, 0, '', NOW(), 'Gaheris_Patrol_111_92_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_111_92', 4, 348316, 371345, 4859, 250, 0, '', NOW(), 'Gaheris_Patrol_111_92_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_111_92', 5, 348391, 371445, 4878, 250, 0, '', NOW(), 'Gaheris_Patrol_111_92_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_111_92', 6, 348532, 372428, 4880, 250, 0, '', NOW(), 'Gaheris_Patrol_111_92_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_111_92', 7, 348632, 371441, 4877, 250, 0, '', NOW(), 'Gaheris_Patrol_111_92_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_111_92', 8, 348622, 372491, 4880, 250, 0, '', NOW(), 'Gaheris_Patrol_111_92_8');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_111_92', 9, 348710, 371376, 4865, 250, 0, '', NOW(), 'Gaheris_Patrol_111_92_9');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_111_92', 10, 348701, 371533, 4880, 250, 0, '', NOW(), 'Gaheris_Patrol_111_92_10');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_111_92', 11, 348785, 371447, 4878, 250, 0, '', NOW(), 'Gaheris_Patrol_111_92_11');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_111_92', 12, 348532, 373826, 4880, 250, 0, '', NOW(), 'Gaheris_Patrol_111_92_12');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_111_95', 1, 347628, 371956, 5312, 250, 0, '', NOW(), 'Gaheris_Patrol_111_95_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_111_95', 2, 348542, 371635, 5292, 250, 0, '', NOW(), 'Gaheris_Patrol_111_95_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_111_95', 3, 349617, 372532, 5248, 250, 0, '', NOW(), 'Gaheris_Patrol_111_95_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_111_95', 4, 349464, 374279, 5312, 250, 0, '', NOW(), 'Gaheris_Patrol_111_95_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_111_95', 5, 348570, 374423, 5248, 250, 0, '', NOW(), 'Gaheris_Patrol_111_95_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_111_95', 6, 347470, 373692, 5248, 250, 0, '', NOW(), 'Gaheris_Patrol_111_95_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_198_99', 1, 770923, 628413, 6992, 250, 0, '', NOW(), 'Gaheris_Patrol_198_99_1');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_198_99', 2, 770760, 628430, 6992, 250, 0, '', NOW(), 'Gaheris_Patrol_198_99_2');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_198_99', 3, 770896, 628220, 6992, 250, 0, '', NOW(), 'Gaheris_Patrol_198_99_3');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_198_99', 4, 771525, 627268, 6992, 250, 0, '', NOW(), 'Gaheris_Patrol_198_99_4');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_198_99', 5, 770724, 628274, 6992, 250, 0, '', NOW(), 'Gaheris_Patrol_198_99_5');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_198_99', 6, 771638, 627101, 6992, 250, 0, '', NOW(), 'Gaheris_Patrol_198_99_6');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_198_99', 7, 771374, 627301, 6992, 250, 0, '', NOW(), 'Gaheris_Patrol_198_99_7');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_198_99', 8, 771383, 627113, 6992, 250, 0, '', NOW(), 'Gaheris_Patrol_198_99_8');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_198_99', 9, 770321, 627657, 6992, 250, 0, '', NOW(), 'Gaheris_Patrol_198_99_9');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_198_99', 10, 770153, 627702, 6992, 250, 0, '', NOW(), 'Gaheris_Patrol_198_99_10');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_198_99', 11, 770320, 627524, 6992, 250, 0, '', NOW(), 'Gaheris_Patrol_198_99_11');
INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, LastTimeRowUpdated, PathPoints_ID) VALUES ('Gaheris_Patrol_198_99', 12, 770190, 627525, 6992, 250, 0, '', NOW(), 'Gaheris_Patrol_198_99_12');
UPDATE mob SET PathID='Gaheris_Patrol_50_100' WHERE Mob_ID='0c2e3b9c-57d3-4728-9712-f647235f2127';
UPDATE mob SET PathID='Gaheris_Patrol_50_100' WHERE Mob_ID='2062d9ef-db4c-4ddc-9677-15546a907f7f';
UPDATE mob SET PathID='Gaheris_Patrol_50_100' WHERE Mob_ID='21df8cf4-25ab-4a54-b517-da6d999fb1f8';
UPDATE mob SET PathID='Gaheris_Patrol_50_100' WHERE Mob_ID='30efe766-1f7c-4868-96a6-649e0439cd79';
UPDATE mob SET PathID='Gaheris_Patrol_50_100' WHERE Mob_ID='40bc9729-47ff-485b-8e37-0bb7b6b1b397';
UPDATE mob SET PathID='Gaheris_Patrol_50_100' WHERE Mob_ID='83519cc3-e502-4856-b843-3f678b6a01ad';
UPDATE mob SET PathID='Gaheris_Patrol_50_100' WHERE Mob_ID='acd4b3ec-39e1-46ed-b2bd-f7be3a8731aa';
UPDATE mob SET PathID='Gaheris_Patrol_50_100' WHERE Mob_ID='b3958e1b-3c72-4ef9-bcb7-36eb7fd53cb7';
UPDATE mob SET PathID='Gaheris_Patrol_50_100' WHERE Mob_ID='b51d4cdf-c4eb-4efd-83de-a20f72982943';
UPDATE mob SET PathID='Gaheris_Patrol_50_100' WHERE Mob_ID='e15f4633-e836-42b6-bbf1-c857aa5ddf2d';
UPDATE mob SET PathID='Gaheris_Patrol_50_100' WHERE Mob_ID='ebbffa2c-2bcb-40fe-89de-83c665bc8c8d';
UPDATE mob SET PathID='Gaheris_Patrol_50_100' WHERE Mob_ID='f3c2e31b-20c6-41e2-8f4a-d5b7d3b1faa4';
UPDATE mob SET PathID='Gaheris_Patrol_50_103' WHERE Mob_ID='029b0db9-5030-418e-9244-07d32f1c3087';
UPDATE mob SET PathID='Gaheris_Patrol_50_103' WHERE Mob_ID='202fc1da-fd71-4bfd-8b5a-4d3723e1f391';
UPDATE mob SET PathID='Gaheris_Patrol_50_103' WHERE Mob_ID='48bfdf18-f717-45ad-83ed-cc2e422165e1';
UPDATE mob SET PathID='Gaheris_Patrol_50_103' WHERE Mob_ID='710fbcce-4344-44e1-bd91-bf62e327f95c';
UPDATE mob SET PathID='Gaheris_Patrol_50_103' WHERE Mob_ID='787439df-50f1-4119-bc5b-6fa6f31fe234';
UPDATE mob SET PathID='Gaheris_Patrol_50_103' WHERE Mob_ID='8c4bf866-35f1-4605-b89d-890da8b71539';
UPDATE mob SET PathID='Gaheris_Patrol_50_103' WHERE Mob_ID='8e224460-d4bc-4c6a-81e6-76ef73e6899d';
UPDATE mob SET PathID='Gaheris_Patrol_50_106' WHERE Mob_ID='066a6bf4-7fff-426e-aefa-48d24bc801c3';
UPDATE mob SET PathID='Gaheris_Patrol_50_106' WHERE Mob_ID='9b8825ec-535e-47b9-8c1e-31abe838933c';
UPDATE mob SET PathID='Gaheris_Patrol_50_106' WHERE Mob_ID='e9c77bf9-a95a-401f-80d4-073954b198b6';
UPDATE mob SET PathID='Gaheris_Patrol_50_106' WHERE Mob_ID='efa0834a-bb59-448a-884e-157d4d9a711c';
UPDATE mob SET PathID='Gaheris_Patrol_51_100' WHERE Mob_ID='19c22835-8f62-4ebc-b286-5ffc56da06e8';
UPDATE mob SET PathID='Gaheris_Patrol_51_100' WHERE Mob_ID='35c7e790-dc0f-414a-9715-a05a8990e573';
UPDATE mob SET PathID='Gaheris_Patrol_51_100' WHERE Mob_ID='3f646663-8140-41b9-bdbf-ef1c6a26e210';
UPDATE mob SET PathID='Gaheris_Patrol_51_100' WHERE Mob_ID='61f30aa5-4f40-4b9d-a0c9-1db3fbdffa59';
UPDATE mob SET PathID='Gaheris_Patrol_51_100' WHERE Mob_ID='7e326a64-ffec-4280-b4ad-3a3b2067991e';
UPDATE mob SET PathID='Gaheris_Patrol_51_100' WHERE Mob_ID='af8c28a2-02bc-4b6a-a6be-016d80eb0c7b';
UPDATE mob SET PathID='Gaheris_Patrol_51_100' WHERE Mob_ID='c4b93c4f-baaa-47e9-ada7-f115061ab173';
UPDATE mob SET PathID='Gaheris_Patrol_51_100' WHERE Mob_ID='dce32476-d289-4348-8d30-fe2f916e18cc';
UPDATE mob SET PathID='Gaheris_Patrol_51_100' WHERE Mob_ID='e687526d-a5f4-4f11-bc81-f7d68e9cfb95';
UPDATE mob SET PathID='Gaheris_Patrol_51_100' WHERE Mob_ID='ea781701-9f46-4119-b451-fb887f2e5414';
UPDATE mob SET PathID='Gaheris_Patrol_51_100' WHERE Mob_ID='fcf3925e-4b7b-4a9c-8202-c8102afa35c9';
UPDATE mob SET PathID='Gaheris_Patrol_51_103' WHERE Mob_ID='1f491219-999d-478e-8d5f-d1f4f6c2a58c';
UPDATE mob SET PathID='Gaheris_Patrol_51_103' WHERE Mob_ID='60242c01-2574-4777-ba0f-f75063879c01';
UPDATE mob SET PathID='Gaheris_Patrol_51_103' WHERE Mob_ID='603cdf4a-af7c-4660-a9e1-2aa550ae2e99';
UPDATE mob SET PathID='Gaheris_Patrol_51_103' WHERE Mob_ID='aca54691-ca9b-4d97-b184-44affc16b679';
UPDATE mob SET PathID='Gaheris_Patrol_51_103' WHERE Mob_ID='b1922fe6-8c88-4da9-82ed-ed1975587d6f';
UPDATE mob SET PathID='Gaheris_Patrol_51_103' WHERE Mob_ID='b26c892f-7841-4002-8151-9d0e03c96b28';
UPDATE mob SET PathID='Gaheris_Patrol_51_103' WHERE Mob_ID='b735f24f-39be-4e01-acd2-e04e5fd9ee96';
UPDATE mob SET PathID='Gaheris_Patrol_51_106' WHERE Mob_ID='31bd3edb-afb5-4f76-979a-fae7b55468fb';
UPDATE mob SET PathID='Gaheris_Patrol_51_106' WHERE Mob_ID='8566208d-e0e3-4b4c-90d3-301652ab3260';
UPDATE mob SET PathID='Gaheris_Patrol_51_106' WHERE Mob_ID='c5ff253d-de1c-495c-87d6-41058ac4ac44';
UPDATE mob SET PathID='Gaheris_Patrol_51_106' WHERE Mob_ID='cd2ec0aa-0485-4c9f-9471-a78074b11ba2';
UPDATE mob SET PathID='Gaheris_Patrol_52_100' WHERE Mob_ID='28be8b5b-cc01-4fb8-a14b-786699840f8d';
UPDATE mob SET PathID='Gaheris_Patrol_52_100' WHERE Mob_ID='2f4c87d8-8692-4173-b358-004efb3833bf';
UPDATE mob SET PathID='Gaheris_Patrol_52_100' WHERE Mob_ID='6cf636a7-7352-4d1c-b0ee-cf5eed311c53';
UPDATE mob SET PathID='Gaheris_Patrol_52_100' WHERE Mob_ID='6e8b4b65-3f20-4eaf-a1e6-14e462bcc9cb';
UPDATE mob SET PathID='Gaheris_Patrol_52_100' WHERE Mob_ID='7aadc3af-134e-4128-b546-302c9b76bef1';
UPDATE mob SET PathID='Gaheris_Patrol_52_100' WHERE Mob_ID='8bee9c1e-96fd-472b-b2d8-6312f7a01f71';
UPDATE mob SET PathID='Gaheris_Patrol_52_100' WHERE Mob_ID='b2440669-33e3-4df7-9b60-d774985f8596';
UPDATE mob SET PathID='Gaheris_Patrol_52_100' WHERE Mob_ID='b8ed7197-dc15-4b46-aa73-3e2cc00017e4';
UPDATE mob SET PathID='Gaheris_Patrol_52_100' WHERE Mob_ID='cdf19d1f-cdbb-4e0f-93bf-bc55b47ee374';
UPDATE mob SET PathID='Gaheris_Patrol_52_100' WHERE Mob_ID='d0de911f-8a1a-46f0-8a65-f316fb9e8a6e';
UPDATE mob SET PathID='Gaheris_Patrol_52_100' WHERE Mob_ID='e0764686-f974-487f-bf71-0567fb03b22e';
UPDATE mob SET PathID='Gaheris_Patrol_52_100' WHERE Mob_ID='e2e21a7b-4335-46dd-a981-c9a29da648d5';
UPDATE mob SET PathID='Gaheris_Patrol_52_103' WHERE Mob_ID='0d5d77b5-3b18-4cf1-88d6-4ef9693986ca';
UPDATE mob SET PathID='Gaheris_Patrol_52_103' WHERE Mob_ID='42f559bb-950a-4c08-a360-0accdc688228';
UPDATE mob SET PathID='Gaheris_Patrol_52_103' WHERE Mob_ID='47884dc9-fd19-4409-acb9-d0a759610248';
UPDATE mob SET PathID='Gaheris_Patrol_52_103' WHERE Mob_ID='4be34aeb-e579-4dff-b3d1-8acf3be67575';
UPDATE mob SET PathID='Gaheris_Patrol_52_103' WHERE Mob_ID='723ac80d-5daf-4929-a8b4-cbe510bc35a3';
UPDATE mob SET PathID='Gaheris_Patrol_52_103' WHERE Mob_ID='9e13a193-ff2a-43d8-a035-81eb9b1e61a1';
UPDATE mob SET PathID='Gaheris_Patrol_52_103' WHERE Mob_ID='c85a48bc-39a6-4c11-8709-209045a80ab5';
UPDATE mob SET PathID='Gaheris_Patrol_52_106' WHERE Mob_ID='1fd4f741-0768-40ab-a240-cc879d92ac25';
UPDATE mob SET PathID='Gaheris_Patrol_52_106' WHERE Mob_ID='2fba7abc-09d5-43f8-a752-5bbefb8b6f5b';
UPDATE mob SET PathID='Gaheris_Patrol_52_106' WHERE Mob_ID='984087ba-24e1-41b7-8338-205ba0e4c008';
UPDATE mob SET PathID='Gaheris_Patrol_52_106' WHERE Mob_ID='a2d233d9-b56c-4d6b-8213-749c8ed257d3';
UPDATE mob SET PathID='Gaheris_Patrol_53_100' WHERE Mob_ID='1d6ac95c-e629-46ff-8578-be49d6b6d4e2';
UPDATE mob SET PathID='Gaheris_Patrol_53_100' WHERE Mob_ID='2b7a38bd-9468-4aac-803c-d8f787ae66a6';
UPDATE mob SET PathID='Gaheris_Patrol_53_100' WHERE Mob_ID='37b12202-2e56-44be-a7ca-7ea849d1c6f2';
UPDATE mob SET PathID='Gaheris_Patrol_53_100' WHERE Mob_ID='3d33ac26-2e05-4e62-9005-e7182f04a361';
UPDATE mob SET PathID='Gaheris_Patrol_53_100' WHERE Mob_ID='531d2028-ec43-4566-90de-9f98f61ad47a';
UPDATE mob SET PathID='Gaheris_Patrol_53_100' WHERE Mob_ID='5bcbb4ae-2b83-4571-a5fa-3f6d6f090814';
UPDATE mob SET PathID='Gaheris_Patrol_53_100' WHERE Mob_ID='a3645d67-de82-4be6-984d-b7b00d8402c1';
UPDATE mob SET PathID='Gaheris_Patrol_53_100' WHERE Mob_ID='c0b36901-3d5f-471c-8ab4-934e9c98e6eb';
UPDATE mob SET PathID='Gaheris_Patrol_53_100' WHERE Mob_ID='d3ea9f72-2cc9-447f-abcc-39bee6037de7';
UPDATE mob SET PathID='Gaheris_Patrol_53_100' WHERE Mob_ID='d407d554-c782-4015-95b4-12269248f14e';
UPDATE mob SET PathID='Gaheris_Patrol_53_100' WHERE Mob_ID='dcd55044-657c-44ce-af3d-90bdb0fb0e95';
UPDATE mob SET PathID='Gaheris_Patrol_53_100' WHERE Mob_ID='e831983c-d17e-45a6-b58b-8b4da0bddbcc';
UPDATE mob SET PathID='Gaheris_Patrol_53_103' WHERE Mob_ID='0ff04b93-3ed5-41a7-b25c-657852a005e2';
UPDATE mob SET PathID='Gaheris_Patrol_53_103' WHERE Mob_ID='1d58eba6-c436-4abd-86cb-01d6892545be';
UPDATE mob SET PathID='Gaheris_Patrol_53_103' WHERE Mob_ID='3093f934-25c8-49a8-9827-f40e44000d5e';
UPDATE mob SET PathID='Gaheris_Patrol_53_103' WHERE Mob_ID='47dbe451-ad18-4c40-8d63-808378a7ac38';
UPDATE mob SET PathID='Gaheris_Patrol_53_103' WHERE Mob_ID='6e70d182-7bec-46d2-be01-b47f595a9d1c';
UPDATE mob SET PathID='Gaheris_Patrol_53_103' WHERE Mob_ID='b7289ca8-3e64-4c77-b124-0be1b891e153';
UPDATE mob SET PathID='Gaheris_Patrol_53_103' WHERE Mob_ID='f6affd42-e7f0-4589-a335-fb06925542ff';
UPDATE mob SET PathID='Gaheris_Patrol_53_106' WHERE Mob_ID='026f9ed0-6224-42ee-a909-ffac06a461c6';
UPDATE mob SET PathID='Gaheris_Patrol_53_106' WHERE Mob_ID='d1d87adc-38ce-4398-b843-601e03f712b1';
UPDATE mob SET PathID='Gaheris_Patrol_53_106' WHERE Mob_ID='f81cf5cd-5f7e-4520-b01c-9ecfcfd6f990';
UPDATE mob SET PathID='Gaheris_Patrol_53_106' WHERE Mob_ID='fda2c5c5-bab4-448f-ac97-2ecb256d2ebf';
UPDATE mob SET PathID='Gaheris_Patrol_54_100' WHERE Mob_ID='0079383a-0dd7-4502-a1a4-b67e5bff9edb';
UPDATE mob SET PathID='Gaheris_Patrol_54_100' WHERE Mob_ID='15217d9a-7ee2-453a-bf18-60d9bc827aa0';
UPDATE mob SET PathID='Gaheris_Patrol_54_100' WHERE Mob_ID='23082f18-0771-4a52-bb97-1cc5412fec51';
UPDATE mob SET PathID='Gaheris_Patrol_54_100' WHERE Mob_ID='482c7590-7cb5-4ab0-8298-ff64a9349390';
UPDATE mob SET PathID='Gaheris_Patrol_54_100' WHERE Mob_ID='4fae1d59-91f2-4427-ab2d-fd56539a8684';
UPDATE mob SET PathID='Gaheris_Patrol_54_100' WHERE Mob_ID='6442d2aa-c3fa-40f2-bff3-6334bfe1dfc4';
UPDATE mob SET PathID='Gaheris_Patrol_54_100' WHERE Mob_ID='7ebc8357-ab4b-4ef4-9e79-d236988d18ca';
UPDATE mob SET PathID='Gaheris_Patrol_54_100' WHERE Mob_ID='919f6502-00ba-4658-a153-d15e3b1678f9';
UPDATE mob SET PathID='Gaheris_Patrol_54_100' WHERE Mob_ID='c1048c87-99e7-4955-b1ca-08fe3f035251';
UPDATE mob SET PathID='Gaheris_Patrol_54_100' WHERE Mob_ID='c7b8a8e9-40b8-4203-ae08-d568186508e9';
UPDATE mob SET PathID='Gaheris_Patrol_54_100' WHERE Mob_ID='eddc89c9-bcfb-43db-995c-fac0f99e5f58';
UPDATE mob SET PathID='Gaheris_Patrol_54_100' WHERE Mob_ID='f466253c-825f-483a-9909-8d36763e02ba';
UPDATE mob SET PathID='Gaheris_Patrol_54_103' WHERE Mob_ID='266b824e-b0d6-48d4-ad19-9f3f62ef4bd8';
UPDATE mob SET PathID='Gaheris_Patrol_54_103' WHERE Mob_ID='5344501e-1c17-4153-99f2-470890902962';
UPDATE mob SET PathID='Gaheris_Patrol_54_103' WHERE Mob_ID='5d0c45b9-b0d7-4d0b-a24c-0942cdec0f64';
UPDATE mob SET PathID='Gaheris_Patrol_54_103' WHERE Mob_ID='72a8217c-fc68-40ee-b35d-063454c793b3';
UPDATE mob SET PathID='Gaheris_Patrol_54_103' WHERE Mob_ID='a9431021-d7fd-458a-be13-3511dff3a40e';
UPDATE mob SET PathID='Gaheris_Patrol_54_103' WHERE Mob_ID='bf1fc8d3-64a5-4a5d-9648-31333d71791b';
UPDATE mob SET PathID='Gaheris_Patrol_54_103' WHERE Mob_ID='f28c3fc1-64ee-442a-b198-2e5247643771';
UPDATE mob SET PathID='Gaheris_Patrol_54_106' WHERE Mob_ID='396a2cbd-6419-4bd9-9c4b-1f30c0fd5e88';
UPDATE mob SET PathID='Gaheris_Patrol_54_106' WHERE Mob_ID='8af071f3-580a-44df-b031-c6ed244307f3';
UPDATE mob SET PathID='Gaheris_Patrol_54_106' WHERE Mob_ID='901020d1-ea93-428a-a69c-4d2ee3f22899';
UPDATE mob SET PathID='Gaheris_Patrol_54_106' WHERE Mob_ID='bb3e4fe2-22d8-49fd-989a-86c45ed57e83';
UPDATE mob SET PathID='Gaheris_Patrol_55_100' WHERE Mob_ID='1c4e2b1b-dbb5-4b30-87e2-21448b57610a';
UPDATE mob SET PathID='Gaheris_Patrol_55_100' WHERE Mob_ID='1fa5c7ef-396b-4b71-8fae-823e11116584';
UPDATE mob SET PathID='Gaheris_Patrol_55_100' WHERE Mob_ID='26ca4068-e86b-44c9-8fbe-468a777b555a';
UPDATE mob SET PathID='Gaheris_Patrol_55_100' WHERE Mob_ID='270a6085-0595-44fe-818b-5d61a30d74fb';
UPDATE mob SET PathID='Gaheris_Patrol_55_100' WHERE Mob_ID='73e2f3ba-bfae-4df2-911b-fb6189de0d22';
UPDATE mob SET PathID='Gaheris_Patrol_55_100' WHERE Mob_ID='7f5d52b1-8058-4c3c-857b-2936665292c5';
UPDATE mob SET PathID='Gaheris_Patrol_55_100' WHERE Mob_ID='a563fd7f-c5e1-43ee-b8f0-2a841940707e';
UPDATE mob SET PathID='Gaheris_Patrol_55_100' WHERE Mob_ID='af0c391f-af1b-4288-bc74-56d9162d00b1';
UPDATE mob SET PathID='Gaheris_Patrol_55_100' WHERE Mob_ID='b38b78d8-b6ec-4360-aad1-70e4ad395ee7';
UPDATE mob SET PathID='Gaheris_Patrol_55_100' WHERE Mob_ID='b87f3ed5-4445-4e8f-a40e-b44aae46083a';
UPDATE mob SET PathID='Gaheris_Patrol_55_100' WHERE Mob_ID='bff3beff-9a52-4d9c-b443-e232173c52e0';
UPDATE mob SET PathID='Gaheris_Patrol_55_100' WHERE Mob_ID='de80aca2-d450-490f-a2f6-3814ec74afe5';
UPDATE mob SET PathID='Gaheris_Patrol_55_103' WHERE Mob_ID='451c3003-ba84-4407-86a7-43d352a48ef6';
UPDATE mob SET PathID='Gaheris_Patrol_55_103' WHERE Mob_ID='48caf125-ce2f-4b2a-9e80-928beb3cc5f8';
UPDATE mob SET PathID='Gaheris_Patrol_55_103' WHERE Mob_ID='663e89b6-7c9f-4534-b6a2-b9c663bca89d';
UPDATE mob SET PathID='Gaheris_Patrol_55_103' WHERE Mob_ID='a3289684-758d-4617-8897-6a56f4d9c60a';
UPDATE mob SET PathID='Gaheris_Patrol_55_103' WHERE Mob_ID='b1d00506-a56c-489b-b8d2-5f28cc090c9c';
UPDATE mob SET PathID='Gaheris_Patrol_55_103' WHERE Mob_ID='e2173b96-1ef7-468d-b8bc-738eaa90fec0';
UPDATE mob SET PathID='Gaheris_Patrol_55_103' WHERE Mob_ID='f20fbcfd-fca9-4526-b1f7-7e27badc9826';
UPDATE mob SET PathID='Gaheris_Patrol_55_106' WHERE Mob_ID='36378366-2eba-4731-9d9e-aa7984f82592';
UPDATE mob SET PathID='Gaheris_Patrol_55_106' WHERE Mob_ID='74787b5f-84cb-48ba-82a0-61e06da06126';
UPDATE mob SET PathID='Gaheris_Patrol_55_106' WHERE Mob_ID='77a55a62-7cf8-496e-acbd-1f0c3bbb56cc';
UPDATE mob SET PathID='Gaheris_Patrol_55_106' WHERE Mob_ID='c5029465-24e7-482b-8dbb-b733310ad7c9';
UPDATE mob SET PathID='Gaheris_Patrol_56_100' WHERE Mob_ID='2946c25a-de57-4347-a4a5-2c312a59eabc';
UPDATE mob SET PathID='Gaheris_Patrol_56_100' WHERE Mob_ID='2ed48c41-8707-4811-a63f-29c1b96637b4';
UPDATE mob SET PathID='Gaheris_Patrol_56_100' WHERE Mob_ID='4fa7b574-f389-4cd9-9d25-024d934c8331';
UPDATE mob SET PathID='Gaheris_Patrol_56_100' WHERE Mob_ID='5c4064f0-e59a-4f5d-bd09-f126651d12a2';
UPDATE mob SET PathID='Gaheris_Patrol_56_100' WHERE Mob_ID='60e84217-f187-4fff-a434-311fa2d58906';
UPDATE mob SET PathID='Gaheris_Patrol_56_100' WHERE Mob_ID='62298feb-c083-41c4-93ce-6426c04e26f9';
UPDATE mob SET PathID='Gaheris_Patrol_56_100' WHERE Mob_ID='6c2fbe5b-5a33-4112-8ca5-e06812afb68a';
UPDATE mob SET PathID='Gaheris_Patrol_56_100' WHERE Mob_ID='94f79222-cd82-414a-89c0-8712e9349fbb';
UPDATE mob SET PathID='Gaheris_Patrol_56_100' WHERE Mob_ID='96e6609a-cb8c-4cd8-a898-424ea50de86c';
UPDATE mob SET PathID='Gaheris_Patrol_56_100' WHERE Mob_ID='b15c3d80-a09b-408b-a6b0-152414a89c85';
UPDATE mob SET PathID='Gaheris_Patrol_56_100' WHERE Mob_ID='cd359bcc-8c24-47c4-ad51-52821baefec9';
UPDATE mob SET PathID='Gaheris_Patrol_56_100' WHERE Mob_ID='d0c1f2e7-c763-4125-8b51-aa392fe25fc4';
UPDATE mob SET PathID='Gaheris_Patrol_56_103' WHERE Mob_ID='09dd08fd-e0e8-48ab-98e9-9683cad113b3';
UPDATE mob SET PathID='Gaheris_Patrol_56_103' WHERE Mob_ID='17b23713-29fc-423d-86eb-e764221ab9c5';
UPDATE mob SET PathID='Gaheris_Patrol_56_103' WHERE Mob_ID='5289040b-aa0f-42e8-84b6-379f9298c9b2';
UPDATE mob SET PathID='Gaheris_Patrol_56_103' WHERE Mob_ID='6f537973-ce62-461a-af34-d5c70b75849c';
UPDATE mob SET PathID='Gaheris_Patrol_56_103' WHERE Mob_ID='d61b7420-a87b-4846-8923-71cefd3c6e39';
UPDATE mob SET PathID='Gaheris_Patrol_56_103' WHERE Mob_ID='f603d78c-3c8b-4bae-89b6-fcf70c382f52';
UPDATE mob SET PathID='Gaheris_Patrol_56_103' WHERE Mob_ID='f9651076-0c59-4820-98a3-f6d119d60934';
UPDATE mob SET PathID='Gaheris_Patrol_56_106' WHERE Mob_ID='2133d4ee-cdc9-42dd-b41b-0a274a916278';
UPDATE mob SET PathID='Gaheris_Patrol_56_106' WHERE Mob_ID='2344ddd2-c0d9-40a6-9acf-21beb15307f4';
UPDATE mob SET PathID='Gaheris_Patrol_56_106' WHERE Mob_ID='5ccc769c-3739-454c-8325-592ba9c52e00';
UPDATE mob SET PathID='Gaheris_Patrol_56_106' WHERE Mob_ID='ec0f306d-567b-4421-bab5-ab93da57d921';
UPDATE mob SET PathID='Gaheris_Patrol_57_100' WHERE Mob_ID='1f4d4aeb-f33f-4067-aef3-407bea2379e7';
UPDATE mob SET PathID='Gaheris_Patrol_57_100' WHERE Mob_ID='228bbbdd-97e6-4c34-94b7-6c1de4aa40e7';
UPDATE mob SET PathID='Gaheris_Patrol_57_100' WHERE Mob_ID='3314abee-3989-4874-8529-3935b5f28452';
UPDATE mob SET PathID='Gaheris_Patrol_57_100' WHERE Mob_ID='38e1b780-d70b-4461-b258-2ec49286770e';
UPDATE mob SET PathID='Gaheris_Patrol_57_100' WHERE Mob_ID='7cb08dd4-0cee-4082-997c-e8a44d66c599';
UPDATE mob SET PathID='Gaheris_Patrol_57_100' WHERE Mob_ID='80f3a06a-c7ea-48d8-ba78-f23632d0c1c4';
UPDATE mob SET PathID='Gaheris_Patrol_57_100' WHERE Mob_ID='9703dac4-3b7b-4934-bfc1-8f7608a07c49';
UPDATE mob SET PathID='Gaheris_Patrol_57_100' WHERE Mob_ID='bd2d1913-5e19-4f41-aea7-f526cd9ca9e2';
UPDATE mob SET PathID='Gaheris_Patrol_57_100' WHERE Mob_ID='cc0d9040-9b90-4a0b-965a-8564821fa0d3';
UPDATE mob SET PathID='Gaheris_Patrol_57_100' WHERE Mob_ID='ef741bb2-4f1b-45d3-9afc-3483378c7c14';
UPDATE mob SET PathID='Gaheris_Patrol_57_100' WHERE Mob_ID='ff5561af-e28d-4528-8f4c-043a99bb5e10';
UPDATE mob SET PathID='Gaheris_Patrol_57_103' WHERE Mob_ID='072c70d2-f182-42a8-9c2f-7b4e2759bd43';
UPDATE mob SET PathID='Gaheris_Patrol_57_103' WHERE Mob_ID='811325db-98e7-408c-910a-184f70e02d05';
UPDATE mob SET PathID='Gaheris_Patrol_57_103' WHERE Mob_ID='b3810048-7a2b-44b4-8535-2eb2fd774dd0';
UPDATE mob SET PathID='Gaheris_Patrol_57_103' WHERE Mob_ID='bfc68ba1-3395-4369-829d-9e8f647dff45';
UPDATE mob SET PathID='Gaheris_Patrol_58_100' WHERE Mob_ID='2ed0d185-8f01-4f51-9bb1-8087999c48f9';
UPDATE mob SET PathID='Gaheris_Patrol_58_100' WHERE Mob_ID='4165c376-15d7-4f5e-98ac-0c880943dcfb';
UPDATE mob SET PathID='Gaheris_Patrol_58_100' WHERE Mob_ID='487cf83f-9e85-425b-9426-3e48339ed578';
UPDATE mob SET PathID='Gaheris_Patrol_58_100' WHERE Mob_ID='56f4712e-2b4f-45c4-bb52-efb7a288db99';
UPDATE mob SET PathID='Gaheris_Patrol_58_100' WHERE Mob_ID='674beb06-d16d-47ba-813a-8ed000348fec';
UPDATE mob SET PathID='Gaheris_Patrol_58_100' WHERE Mob_ID='792a70a5-e3f4-4ed2-a857-3618f3f249cf';
UPDATE mob SET PathID='Gaheris_Patrol_58_100' WHERE Mob_ID='a0698d77-b633-44c0-b67c-df1bdaef37ca';
UPDATE mob SET PathID='Gaheris_Patrol_58_100' WHERE Mob_ID='a9ba4c5a-d36f-40f2-91f2-892cb9cfddcd';
UPDATE mob SET PathID='Gaheris_Patrol_58_100' WHERE Mob_ID='aa6201f6-d799-404c-8c05-36c3f0efdcd7';
UPDATE mob SET PathID='Gaheris_Patrol_58_100' WHERE Mob_ID='be8993d2-026b-4c04-b8ed-8581dbdb14df';
UPDATE mob SET PathID='Gaheris_Patrol_58_100' WHERE Mob_ID='c38a9bd7-a0f0-4616-8aba-08f9430d0ebb';
UPDATE mob SET PathID='Gaheris_Patrol_58_100' WHERE Mob_ID='e965bea6-ffa0-4e27-bd4d-c1f5035798a3';
UPDATE mob SET PathID='Gaheris_Patrol_75_100' WHERE Mob_ID='1e01183d-2a40-43a2-9309-dd679d10dab0';
UPDATE mob SET PathID='Gaheris_Patrol_75_100' WHERE Mob_ID='27d214f0-2aab-4372-9cea-e3549b15dfa3';
UPDATE mob SET PathID='Gaheris_Patrol_75_100' WHERE Mob_ID='472f05c6-9a22-4a7d-820c-c2bb7ab445a8';
UPDATE mob SET PathID='Gaheris_Patrol_75_100' WHERE Mob_ID='4ce03ddb-e900-4ee6-9a2c-61fd48e4abb7';
UPDATE mob SET PathID='Gaheris_Patrol_75_100' WHERE Mob_ID='698c0b55-40ad-4728-8b09-f8419c413ea4';
UPDATE mob SET PathID='Gaheris_Patrol_75_100' WHERE Mob_ID='bfb3fe14-3aaf-4b6d-a052-80f41c52694c';
UPDATE mob SET PathID='Gaheris_Patrol_75_100' WHERE Mob_ID='cb85c316-4f0e-4ce3-88af-8252edecbebc';
UPDATE mob SET PathID='Gaheris_Patrol_75_100' WHERE Mob_ID='cea3cfba-f513-4554-9e3e-de139f5ef3ea';
UPDATE mob SET PathID='Gaheris_Patrol_75_100' WHERE Mob_ID='e347804e-38dd-478e-85df-f8ac5343b07c';
UPDATE mob SET PathID='Gaheris_Patrol_75_100' WHERE Mob_ID='e5dc6b4e-26f0-433b-b561-58600fb9ac24';
UPDATE mob SET PathID='Gaheris_Patrol_75_100' WHERE Mob_ID='feeedbaf-00f3-4fe1-9c7e-cffdafb0919b';
UPDATE mob SET PathID='Gaheris_Patrol_75_102' WHERE Mob_ID='0a741fd9-afef-4842-b823-2850904512bf';
UPDATE mob SET PathID='Gaheris_Patrol_75_102' WHERE Mob_ID='16cd928a-f634-4d28-ad23-f0c8f198731c';
UPDATE mob SET PathID='Gaheris_Patrol_75_102' WHERE Mob_ID='4424017b-6dad-447a-acdc-74a9c626f57b';
UPDATE mob SET PathID='Gaheris_Patrol_75_102' WHERE Mob_ID='910bcfa3-7cca-4d11-b2a0-072850d8e34d';
UPDATE mob SET PathID='Gaheris_Patrol_75_102' WHERE Mob_ID='95591292-3323-4d48-8eff-e1e57a68b473';
UPDATE mob SET PathID='Gaheris_Patrol_75_102' WHERE Mob_ID='a039bdb7-78b9-4700-b36b-6f6cae96a1f1';
UPDATE mob SET PathID='Gaheris_Patrol_75_102' WHERE Mob_ID='aee35042-2e5f-441d-b4a2-70f81f7ee061';
UPDATE mob SET PathID='Gaheris_Patrol_75_106' WHERE Mob_ID='21456ab8-fe78-43b8-87fd-af6f560ef5c7';
UPDATE mob SET PathID='Gaheris_Patrol_75_106' WHERE Mob_ID='4d1964d9-2e3b-4798-bae4-f07806a40e8d';
UPDATE mob SET PathID='Gaheris_Patrol_75_106' WHERE Mob_ID='4ef462b1-a46d-4119-aa7e-576bad84a0a7';
UPDATE mob SET PathID='Gaheris_Patrol_75_106' WHERE Mob_ID='dd856d25-d045-4e03-a93f-9c7bb7c880d7';
UPDATE mob SET PathID='Gaheris_Patrol_76_100' WHERE Mob_ID='0c547048-a95b-4579-9b0e-69cbcd078357';
UPDATE mob SET PathID='Gaheris_Patrol_76_100' WHERE Mob_ID='19ba3d49-6065-4837-8270-e444c3cd9e07';
UPDATE mob SET PathID='Gaheris_Patrol_76_100' WHERE Mob_ID='263f3c98-b0cc-4e3a-9bf5-03d0a819bf46';
UPDATE mob SET PathID='Gaheris_Patrol_76_100' WHERE Mob_ID='3157a174-466f-46c8-891a-332cb25358dc';
UPDATE mob SET PathID='Gaheris_Patrol_76_100' WHERE Mob_ID='413fd1f5-4e6a-484b-8a4d-e5f59164c191';
UPDATE mob SET PathID='Gaheris_Patrol_76_100' WHERE Mob_ID='438eef1a-7010-412b-8a1a-658f49326b4d';
UPDATE mob SET PathID='Gaheris_Patrol_76_100' WHERE Mob_ID='4ec2a661-63f6-45cb-be31-ed3b4fb27f68';
UPDATE mob SET PathID='Gaheris_Patrol_76_100' WHERE Mob_ID='7b3a0b1f-a4a9-4890-97b7-37058308dfaa';
UPDATE mob SET PathID='Gaheris_Patrol_76_100' WHERE Mob_ID='9b9f08af-5c0f-4ee1-a4df-6c09dfb377de';
UPDATE mob SET PathID='Gaheris_Patrol_76_100' WHERE Mob_ID='9bec7b0c-dfd9-4e31-9a42-efa7be41ed4a';
UPDATE mob SET PathID='Gaheris_Patrol_76_100' WHERE Mob_ID='ac5c808d-dff8-4ddd-bf82-a2da760626f9';
UPDATE mob SET PathID='Gaheris_Patrol_76_100' WHERE Mob_ID='bfe57c90-a8c6-4591-b1ae-c4c345dc800d';
UPDATE mob SET PathID='Gaheris_Patrol_76_100' WHERE Mob_ID='fe62064c-36a1-46f2-898a-6afeae3cf542';
UPDATE mob SET PathID='Gaheris_Patrol_76_102' WHERE Mob_ID='3856833b-e22a-4a7b-94b8-ef3158fc3845';
UPDATE mob SET PathID='Gaheris_Patrol_76_102' WHERE Mob_ID='54b70a57-2603-4dd7-98a2-bdaa21806059';
UPDATE mob SET PathID='Gaheris_Patrol_76_102' WHERE Mob_ID='909ff452-3ed9-4475-a460-124f87dc12e4';
UPDATE mob SET PathID='Gaheris_Patrol_76_102' WHERE Mob_ID='c6d15170-0f4e-4103-8f46-e9c9ef7aad67';
UPDATE mob SET PathID='Gaheris_Patrol_76_102' WHERE Mob_ID='d830ae6b-2154-4372-8387-861bbaf77de2';
UPDATE mob SET PathID='Gaheris_Patrol_76_102' WHERE Mob_ID='f81af0cc-24b9-4e0f-af0a-012398cecba9';
UPDATE mob SET PathID='Gaheris_Patrol_76_102' WHERE Mob_ID='fa29df77-cef5-4a89-ad0d-2d9f9aa9dfda';
UPDATE mob SET PathID='Gaheris_Patrol_76_106' WHERE Mob_ID='05dc5e26-12f4-4020-bf3c-00e8310d93fb';
UPDATE mob SET PathID='Gaheris_Patrol_76_106' WHERE Mob_ID='12b29841-f690-4d80-bc65-82701b6d77e3';
UPDATE mob SET PathID='Gaheris_Patrol_76_106' WHERE Mob_ID='42bd333e-a83d-48ff-9357-b6b329695df4';
UPDATE mob SET PathID='Gaheris_Patrol_76_106' WHERE Mob_ID='8eda8a61-02e3-49ce-b213-1e1bf8532578';
UPDATE mob SET PathID='Gaheris_Patrol_77_100' WHERE Mob_ID='024a7152-dd21-47e0-8a82-1a2af2011cc1';
UPDATE mob SET PathID='Gaheris_Patrol_77_100' WHERE Mob_ID='25036a1b-8c1d-4417-83a1-e4a804ba132c';
UPDATE mob SET PathID='Gaheris_Patrol_77_100' WHERE Mob_ID='2ed2aa0a-4e36-4810-a20c-171ed1664756';
UPDATE mob SET PathID='Gaheris_Patrol_77_100' WHERE Mob_ID='332c120f-42e8-4900-8629-045071f62a88';
UPDATE mob SET PathID='Gaheris_Patrol_77_100' WHERE Mob_ID='34450fce-aef8-4661-b0dd-87283d3d41b5';
UPDATE mob SET PathID='Gaheris_Patrol_77_100' WHERE Mob_ID='9d8dd280-a71e-42c3-966c-4719e79780fe';
UPDATE mob SET PathID='Gaheris_Patrol_77_100' WHERE Mob_ID='aee46640-72ec-4f20-a367-92272f141675';
UPDATE mob SET PathID='Gaheris_Patrol_77_100' WHERE Mob_ID='bddaaf42-c846-43eb-a6eb-b01eb107b112';
UPDATE mob SET PathID='Gaheris_Patrol_77_100' WHERE Mob_ID='c790a985-e6b4-4ef3-821d-22d1268758df';
UPDATE mob SET PathID='Gaheris_Patrol_77_100' WHERE Mob_ID='cfd8dfbe-1522-4d03-b36d-1d23fb9b93bd';
UPDATE mob SET PathID='Gaheris_Patrol_77_100' WHERE Mob_ID='d8943236-14c1-4ed5-a720-4517fe440454';
UPDATE mob SET PathID='Gaheris_Patrol_77_100' WHERE Mob_ID='df826790-7862-4241-9d80-aaba0499dd57';
UPDATE mob SET PathID='Gaheris_Patrol_77_100' WHERE Mob_ID='e1e9ad80-0110-42d3-89aa-5916fd266887';
UPDATE mob SET PathID='Gaheris_Patrol_77_102' WHERE Mob_ID='1caee862-eaef-4227-ac7e-e2278246cc31';
UPDATE mob SET PathID='Gaheris_Patrol_77_102' WHERE Mob_ID='3d21f0b3-f09d-4a47-92e4-4bc208f1b069';
UPDATE mob SET PathID='Gaheris_Patrol_77_102' WHERE Mob_ID='3f5f6800-2162-44d4-89df-422a7980c439';
UPDATE mob SET PathID='Gaheris_Patrol_77_102' WHERE Mob_ID='4ab662a2-ba5a-4e1f-a582-cde906a4604d';
UPDATE mob SET PathID='Gaheris_Patrol_77_102' WHERE Mob_ID='759e6946-70ae-45ba-b29c-46444c5752c5';
UPDATE mob SET PathID='Gaheris_Patrol_77_102' WHERE Mob_ID='dbffb1ef-73b0-42d3-a40a-0d2b85e62373';
UPDATE mob SET PathID='Gaheris_Patrol_77_102' WHERE Mob_ID='e28eda76-3ae4-40ed-903b-92decf541298';
UPDATE mob SET PathID='Gaheris_Patrol_77_106' WHERE Mob_ID='7f0cbbc0-4e64-4fc2-aff0-182ce499ce10';
UPDATE mob SET PathID='Gaheris_Patrol_77_106' WHERE Mob_ID='90d8d7f6-2472-429c-a41b-507beaa9f535';
UPDATE mob SET PathID='Gaheris_Patrol_77_106' WHERE Mob_ID='be0b7b13-a73d-4ef9-a6f1-92c1ab6810f4';
UPDATE mob SET PathID='Gaheris_Patrol_77_106' WHERE Mob_ID='efd04ac7-0f9c-4ffb-a978-9375bd6ed2b0';
UPDATE mob SET PathID='Gaheris_Patrol_78_100' WHERE Mob_ID='3e684cdf-ea2c-4b8c-84df-2c30b4160232';
UPDATE mob SET PathID='Gaheris_Patrol_78_100' WHERE Mob_ID='5475a6f0-cf21-467e-b3cd-e9798827bd7d';
UPDATE mob SET PathID='Gaheris_Patrol_78_100' WHERE Mob_ID='73ab43c7-bc88-41dc-8580-7ca9851eaf93';
UPDATE mob SET PathID='Gaheris_Patrol_78_100' WHERE Mob_ID='8d372558-8c20-41aa-b076-c35302a91797';
UPDATE mob SET PathID='Gaheris_Patrol_78_100' WHERE Mob_ID='9989360f-f171-4372-affb-8bf86d0a5399';
UPDATE mob SET PathID='Gaheris_Patrol_78_100' WHERE Mob_ID='a6bb151d-4b1e-4833-b532-761aec8b3890';
UPDATE mob SET PathID='Gaheris_Patrol_78_100' WHERE Mob_ID='ad1197a7-02e2-4aca-b78e-d35a9872fce9';
UPDATE mob SET PathID='Gaheris_Patrol_78_100' WHERE Mob_ID='b61a3bbc-e4a5-401f-bc42-e4f130fbf049';
UPDATE mob SET PathID='Gaheris_Patrol_78_100' WHERE Mob_ID='c702c5bd-0557-4c8b-bb34-8410ec2ba392';
UPDATE mob SET PathID='Gaheris_Patrol_78_100' WHERE Mob_ID='cda916ef-1ef2-40c6-bbd3-53e237d3af75';
UPDATE mob SET PathID='Gaheris_Patrol_78_100' WHERE Mob_ID='db665bb6-ec86-401e-b8cc-28c0866a440a';
UPDATE mob SET PathID='Gaheris_Patrol_78_100' WHERE Mob_ID='ddbcae2a-5b04-4fdb-a85d-b1c5a76bcf04';
UPDATE mob SET PathID='Gaheris_Patrol_78_100' WHERE Mob_ID='e4a62751-d18d-4257-810a-c380c3d35f04';
UPDATE mob SET PathID='Gaheris_Patrol_78_102' WHERE Mob_ID='0438293a-43d9-46ed-92e6-e0b08e8edbec';
UPDATE mob SET PathID='Gaheris_Patrol_78_102' WHERE Mob_ID='21085a45-7979-4264-87ec-6cd9aebfb7f6';
UPDATE mob SET PathID='Gaheris_Patrol_78_102' WHERE Mob_ID='450d727c-f98c-4e7f-8cd0-6ab90c148b9a';
UPDATE mob SET PathID='Gaheris_Patrol_78_102' WHERE Mob_ID='5e154539-012d-4cb8-a6ca-c976fe0ea5c6';
UPDATE mob SET PathID='Gaheris_Patrol_78_102' WHERE Mob_ID='7a5363d2-cb74-4e33-8a68-a4eae7a86331';
UPDATE mob SET PathID='Gaheris_Patrol_78_102' WHERE Mob_ID='b05c8423-97a6-4517-b5e3-87dfafad03c8';
UPDATE mob SET PathID='Gaheris_Patrol_78_102' WHERE Mob_ID='d3c5dab1-6e3d-4097-8891-bad6d0220f47';
UPDATE mob SET PathID='Gaheris_Patrol_78_106' WHERE Mob_ID='266ed9f0-4ca5-402c-9f25-022819c75aae';
UPDATE mob SET PathID='Gaheris_Patrol_78_106' WHERE Mob_ID='7d5f1d6e-c7e3-4b47-bc4f-b66bac8204a5';
UPDATE mob SET PathID='Gaheris_Patrol_78_106' WHERE Mob_ID='ce67e8da-9fa6-4e83-9d16-1fa49324259b';
UPDATE mob SET PathID='Gaheris_Patrol_78_106' WHERE Mob_ID='da7b6ee2-776b-410a-8fcc-f15e24dd4de7';
UPDATE mob SET PathID='Gaheris_Patrol_79_100' WHERE Mob_ID='154f609f-df7d-44be-909e-5aec2c1dda4d';
UPDATE mob SET PathID='Gaheris_Patrol_79_100' WHERE Mob_ID='1e6956f6-3d95-4d2a-8b52-2a2e0b59e5a1';
UPDATE mob SET PathID='Gaheris_Patrol_79_100' WHERE Mob_ID='1f957219-1708-42bc-91fa-c9756f6f88c6';
UPDATE mob SET PathID='Gaheris_Patrol_79_100' WHERE Mob_ID='3650defb-9a4a-45c6-b488-cfdd0a64f345';
UPDATE mob SET PathID='Gaheris_Patrol_79_100' WHERE Mob_ID='4153e421-ffe3-4600-ab22-4d9d0c0dc114';
UPDATE mob SET PathID='Gaheris_Patrol_79_100' WHERE Mob_ID='44f135cb-532b-40fe-9f29-9b559085f1b2';
UPDATE mob SET PathID='Gaheris_Patrol_79_100' WHERE Mob_ID='45e9efb4-8508-4f48-91c5-09709bb66f43';
UPDATE mob SET PathID='Gaheris_Patrol_79_100' WHERE Mob_ID='8d418ca8-4a34-46e1-8c1b-80a1d63a92a1';
UPDATE mob SET PathID='Gaheris_Patrol_79_100' WHERE Mob_ID='8e24a0be-b17f-4e5a-8a59-893a646b4a6a';
UPDATE mob SET PathID='Gaheris_Patrol_79_100' WHERE Mob_ID='99d62497-49fb-446e-8366-dd26039c2c29';
UPDATE mob SET PathID='Gaheris_Patrol_79_100' WHERE Mob_ID='9a55e252-de42-412a-bcf2-6062707ec3ff';
UPDATE mob SET PathID='Gaheris_Patrol_79_100' WHERE Mob_ID='a36471e6-986f-4dd8-8b17-3847e260d048';
UPDATE mob SET PathID='Gaheris_Patrol_79_100' WHERE Mob_ID='c15df0de-f275-444d-afb8-793a184d2c7c';
UPDATE mob SET PathID='Gaheris_Patrol_79_102' WHERE Mob_ID='084e239b-0cbb-4c6c-bd33-c9ddc0ad657a';
UPDATE mob SET PathID='Gaheris_Patrol_79_102' WHERE Mob_ID='0db907ce-99a2-418e-9846-9111b5de6224';
UPDATE mob SET PathID='Gaheris_Patrol_79_102' WHERE Mob_ID='64cd02b8-1a81-4d63-b29c-ae0d855bc9ac';
UPDATE mob SET PathID='Gaheris_Patrol_79_102' WHERE Mob_ID='6612ead1-6e6f-4419-a030-6e6cef4ec71f';
UPDATE mob SET PathID='Gaheris_Patrol_79_102' WHERE Mob_ID='6b651a29-22f5-4a5c-9a15-816d6181b9a7';
UPDATE mob SET PathID='Gaheris_Patrol_79_102' WHERE Mob_ID='823f92b0-4d27-4634-a325-fad8d7794421';
UPDATE mob SET PathID='Gaheris_Patrol_79_102' WHERE Mob_ID='e7826ca7-f337-43a8-b75e-b221476ad661';
UPDATE mob SET PathID='Gaheris_Patrol_79_106' WHERE Mob_ID='297bc6e5-1e1d-4291-a6d0-2e3592d1dc3b';
UPDATE mob SET PathID='Gaheris_Patrol_79_106' WHERE Mob_ID='94663859-3798-46bd-aa17-ff60aab39fa9';
UPDATE mob SET PathID='Gaheris_Patrol_79_106' WHERE Mob_ID='c9d1df6f-df14-440c-b898-3a0c5de8ccb2';
UPDATE mob SET PathID='Gaheris_Patrol_79_106' WHERE Mob_ID='ed2a3d17-dbec-4e08-9199-8b3c277e83b4';
UPDATE mob SET PathID='Gaheris_Patrol_80_100' WHERE Mob_ID='52a1de0f-69ab-45fc-8efe-ad60c9686e3a';
UPDATE mob SET PathID='Gaheris_Patrol_80_100' WHERE Mob_ID='543059df-c422-4a96-89e0-a2c478cf1d2a';
UPDATE mob SET PathID='Gaheris_Patrol_80_100' WHERE Mob_ID='5d771da3-4b7e-4c51-b921-25e56a4310f3';
UPDATE mob SET PathID='Gaheris_Patrol_80_100' WHERE Mob_ID='72f74178-52dc-4814-83f7-275112ffb142';
UPDATE mob SET PathID='Gaheris_Patrol_80_100' WHERE Mob_ID='772a3b34-106c-4ae6-9245-e173987c35ab';
UPDATE mob SET PathID='Gaheris_Patrol_80_100' WHERE Mob_ID='8522b615-2446-4474-8810-88d62157dbc7';
UPDATE mob SET PathID='Gaheris_Patrol_80_100' WHERE Mob_ID='8df38b8c-099c-4a8d-9aae-833fb3d6d61d';
UPDATE mob SET PathID='Gaheris_Patrol_80_100' WHERE Mob_ID='905a0cf0-8a6b-4d89-89d3-72e4d458967a';
UPDATE mob SET PathID='Gaheris_Patrol_80_100' WHERE Mob_ID='a80ff7a7-dba2-4438-9f71-9167990a15af';
UPDATE mob SET PathID='Gaheris_Patrol_80_100' WHERE Mob_ID='b85a7450-7e5b-48d3-9c20-98be4be27b7c';
UPDATE mob SET PathID='Gaheris_Patrol_80_100' WHERE Mob_ID='ca00a2fb-9f96-4b45-b0ef-8cd229d757f1';
UPDATE mob SET PathID='Gaheris_Patrol_80_100' WHERE Mob_ID='dd550ddd-4de9-424d-aed3-ec0304a42cab';
UPDATE mob SET PathID='Gaheris_Patrol_80_100' WHERE Mob_ID='e21e0b78-7461-444f-af95-2e8714dec690';
UPDATE mob SET PathID='Gaheris_Patrol_80_102' WHERE Mob_ID='099da49a-ba8d-4ddf-8ac4-fac7d6cc6b09';
UPDATE mob SET PathID='Gaheris_Patrol_80_102' WHERE Mob_ID='3840135b-a82a-4898-bee1-7d34383da438';
UPDATE mob SET PathID='Gaheris_Patrol_80_102' WHERE Mob_ID='384a297e-719e-48d9-9055-c588510ef8de';
UPDATE mob SET PathID='Gaheris_Patrol_80_102' WHERE Mob_ID='5bb3d078-8f6e-4fe7-9858-84092ceab5bd';
UPDATE mob SET PathID='Gaheris_Patrol_80_102' WHERE Mob_ID='6d3afa8b-3a6c-49ce-b112-d880353ac81a';
UPDATE mob SET PathID='Gaheris_Patrol_80_102' WHERE Mob_ID='a8274dda-d442-462f-acc8-4e0ade648827';
UPDATE mob SET PathID='Gaheris_Patrol_80_102' WHERE Mob_ID='ea274b76-7e18-4bab-9c05-d0259798eca3';
UPDATE mob SET PathID='Gaheris_Patrol_80_106' WHERE Mob_ID='29eed4fc-1cc6-41f2-bb2a-d38dc0a4ec5f';
UPDATE mob SET PathID='Gaheris_Patrol_80_106' WHERE Mob_ID='4fc2930a-de95-4ec7-a69d-e939f568e00f';
UPDATE mob SET PathID='Gaheris_Patrol_80_106' WHERE Mob_ID='99789021-86eb-4903-8914-2fe94b29b381';
UPDATE mob SET PathID='Gaheris_Patrol_80_106' WHERE Mob_ID='e2691304-d06b-4333-8c86-98cd242f4e38';
UPDATE mob SET PathID='Gaheris_Patrol_81_100' WHERE Mob_ID='2cc0d7c8-822c-49c3-be96-4560fba83457';
UPDATE mob SET PathID='Gaheris_Patrol_81_100' WHERE Mob_ID='3b787f37-9898-4c74-bf23-00fb14fb14dd';
UPDATE mob SET PathID='Gaheris_Patrol_81_100' WHERE Mob_ID='3ec59773-1dbb-4c4c-b9e2-dd9feb12ca9e';
UPDATE mob SET PathID='Gaheris_Patrol_81_100' WHERE Mob_ID='5de222a3-4dd9-4db2-a24c-f9dc6ba22689';
UPDATE mob SET PathID='Gaheris_Patrol_81_100' WHERE Mob_ID='7500c150-e192-47bd-9b7e-ef3e0bb71106';
UPDATE mob SET PathID='Gaheris_Patrol_81_100' WHERE Mob_ID='8739f5cc-1f79-409b-98e5-734b611b24c3';
UPDATE mob SET PathID='Gaheris_Patrol_81_100' WHERE Mob_ID='8ee76ae6-e8fe-4a7a-b313-68d560c9286e';
UPDATE mob SET PathID='Gaheris_Patrol_81_100' WHERE Mob_ID='96572842-e326-4986-9267-4628230c8938';
UPDATE mob SET PathID='Gaheris_Patrol_81_100' WHERE Mob_ID='96cd0b3a-2c49-40d3-b033-027ff23205a8';
UPDATE mob SET PathID='Gaheris_Patrol_81_100' WHERE Mob_ID='98d49667-47d1-4534-810a-c4756a734ab0';
UPDATE mob SET PathID='Gaheris_Patrol_81_100' WHERE Mob_ID='abde5ff4-540c-483d-901b-30d04a7beb31';
UPDATE mob SET PathID='Gaheris_Patrol_81_100' WHERE Mob_ID='d19dff4e-f6f9-497e-8725-e15fefd59756';
UPDATE mob SET PathID='Gaheris_Patrol_81_100' WHERE Mob_ID='eaa8dbf5-117d-4780-b0d9-493dd97fd191';
UPDATE mob SET PathID='Gaheris_Patrol_81_100' WHERE Mob_ID='f4092313-3705-45f1-b8a8-7503bf655fc5';
UPDATE mob SET PathID='Gaheris_Patrol_81_102' WHERE Mob_ID='29e2ddaa-5797-4dbe-9d56-96180069dec4';
UPDATE mob SET PathID='Gaheris_Patrol_81_102' WHERE Mob_ID='44383909-e3c3-464c-87d8-fdbea35f1c87';
UPDATE mob SET PathID='Gaheris_Patrol_81_102' WHERE Mob_ID='66c62b58-bab2-4053-8a6e-c1096504df73';
UPDATE mob SET PathID='Gaheris_Patrol_81_102' WHERE Mob_ID='6e25a775-1143-41d7-af8b-a47a9a8f4b38';
UPDATE mob SET PathID='Gaheris_Patrol_81_102' WHERE Mob_ID='a3d124da-3769-4888-9f94-135326f03834';
UPDATE mob SET PathID='Gaheris_Patrol_81_102' WHERE Mob_ID='d2db926a-3685-4448-9117-aa6808e53ac8';
UPDATE mob SET PathID='Gaheris_Patrol_81_102' WHERE Mob_ID='eab318bc-7e46-434e-a286-a5090d679d67';
UPDATE mob SET PathID='Gaheris_Patrol_81_106' WHERE Mob_ID='2fdb2ea8-6cd5-42e9-bec7-898df76aea4e';
UPDATE mob SET PathID='Gaheris_Patrol_81_106' WHERE Mob_ID='bb105f6a-e533-4799-894a-4afc56705ee5';
UPDATE mob SET PathID='Gaheris_Patrol_81_106' WHERE Mob_ID='c891ebfc-bb7e-4816-9ace-2539da798058';
UPDATE mob SET PathID='Gaheris_Patrol_81_106' WHERE Mob_ID='e3ec2bdc-6007-42fe-9758-e4dc87eb84ea';
UPDATE mob SET PathID='Gaheris_Patrol_82_100' WHERE Mob_ID='14fd9590-07a4-41ad-96bb-2fbcbee55fcb';
UPDATE mob SET PathID='Gaheris_Patrol_82_100' WHERE Mob_ID='4413d2a2-4304-4cc9-8a42-52d3a066f8a2';
UPDATE mob SET PathID='Gaheris_Patrol_82_100' WHERE Mob_ID='4bb96536-14d2-4cdc-851f-30741c97e861';
UPDATE mob SET PathID='Gaheris_Patrol_82_100' WHERE Mob_ID='5422336f-c966-4d9c-b42a-24829b835321';
UPDATE mob SET PathID='Gaheris_Patrol_82_100' WHERE Mob_ID='5a43f7e9-a698-4f71-af8c-bd3c8a0d339d';
UPDATE mob SET PathID='Gaheris_Patrol_82_100' WHERE Mob_ID='67fb45d2-6c8c-4e8a-b03b-3c15f0ab57d3';
UPDATE mob SET PathID='Gaheris_Patrol_82_100' WHERE Mob_ID='6c76a954-2021-4edc-b53b-2577e381ef55';
UPDATE mob SET PathID='Gaheris_Patrol_82_100' WHERE Mob_ID='7ed0c6dc-f277-4a35-a2eb-e9e3677f3d76';
UPDATE mob SET PathID='Gaheris_Patrol_82_100' WHERE Mob_ID='8e3ce4f6-481a-4f8c-9625-d0cba252770a';
UPDATE mob SET PathID='Gaheris_Patrol_82_100' WHERE Mob_ID='d69c6ca7-4628-4867-8429-911798f15bc5';
UPDATE mob SET PathID='Gaheris_Patrol_82_100' WHERE Mob_ID='eb6a1fce-f72d-4073-8966-d462e412c3da';
UPDATE mob SET PathID='Gaheris_Patrol_100_100' WHERE Mob_ID='3d791514-977a-4325-a791-68526881b691';
UPDATE mob SET PathID='Gaheris_Patrol_100_100' WHERE Mob_ID='3e6fff21-c248-4ca1-a9fb-e9e89fa533c0';
UPDATE mob SET PathID='Gaheris_Patrol_100_100' WHERE Mob_ID='4926a15f-e916-4576-946e-282dd193edbf';
UPDATE mob SET PathID='Gaheris_Patrol_100_100' WHERE Mob_ID='715c51b5-bf9a-4589-b934-c7b829b894dd';
UPDATE mob SET PathID='Gaheris_Patrol_100_100' WHERE Mob_ID='746bf1b3-1819-4f9d-857c-69aab73fd625';
UPDATE mob SET PathID='Gaheris_Patrol_100_100' WHERE Mob_ID='78717dbb-1ce3-48a2-9d68-747867d1f4e6';
UPDATE mob SET PathID='Gaheris_Patrol_100_100' WHERE Mob_ID='7a56183c-d4ae-4f5b-ac3d-1e066012c194';
UPDATE mob SET PathID='Gaheris_Patrol_100_100' WHERE Mob_ID='7b23d568-c5b4-4810-bb08-68fcd8d991e7';
UPDATE mob SET PathID='Gaheris_Patrol_100_100' WHERE Mob_ID='8f9fdee9-fe49-4315-b35d-713395b7a83b';
UPDATE mob SET PathID='Gaheris_Patrol_100_100' WHERE Mob_ID='92dbc6e9-1f02-411c-a4a5-883146451522';
UPDATE mob SET PathID='Gaheris_Patrol_100_100' WHERE Mob_ID='a1a36153-eb94-4d96-b062-b4fc631f696b';
UPDATE mob SET PathID='Gaheris_Patrol_100_100' WHERE Mob_ID='b51ec1b2-cdcf-4531-aaad-6638e291295f';
UPDATE mob SET PathID='Gaheris_Patrol_100_100' WHERE Mob_ID='baa153c1-c6f3-433d-bbe5-d90dbd88b3b7';
UPDATE mob SET PathID='Gaheris_Patrol_100_100' WHERE Mob_ID='c912922c-332c-480a-bc50-eda7cafae3bb';
UPDATE mob SET PathID='Gaheris_Patrol_100_102' WHERE Mob_ID='179b41c6-30a6-47af-883f-5541448af7b2';
UPDATE mob SET PathID='Gaheris_Patrol_100_102' WHERE Mob_ID='334fa38a-966c-4b81-b0fb-d5451fbe6729';
UPDATE mob SET PathID='Gaheris_Patrol_100_102' WHERE Mob_ID='3633e242-7894-4b01-aacb-785fd204d170';
UPDATE mob SET PathID='Gaheris_Patrol_100_102' WHERE Mob_ID='58125471-f49f-457b-907f-1bc6ca7208fd';
UPDATE mob SET PathID='Gaheris_Patrol_100_102' WHERE Mob_ID='8a7b60dd-cd61-4b72-84bb-6a56134f6565';
UPDATE mob SET PathID='Gaheris_Patrol_100_102' WHERE Mob_ID='9fd6d35a-2163-4831-b804-5def62acab6a';
UPDATE mob SET PathID='Gaheris_Patrol_100_102' WHERE Mob_ID='c15bef4c-34bc-40e0-ba88-f235f19c0e18';
UPDATE mob SET PathID='Gaheris_Patrol_100_108' WHERE Mob_ID='44605ab9-e2e0-476c-b864-8109ea69479f';
UPDATE mob SET PathID='Gaheris_Patrol_100_108' WHERE Mob_ID='75c8b8a8-0a73-46bf-88c8-22a50c77c607';
UPDATE mob SET PathID='Gaheris_Patrol_100_108' WHERE Mob_ID='78b8dc49-3e4c-49ce-ab2b-66a22cfb1e87';
UPDATE mob SET PathID='Gaheris_Patrol_100_108' WHERE Mob_ID='96ea45b1-bd12-4815-9b19-ec6afea43dc0';
UPDATE mob SET PathID='Gaheris_Patrol_101_100' WHERE Mob_ID='058db3ca-bd34-4ab4-baba-d35e85899232';
UPDATE mob SET PathID='Gaheris_Patrol_101_100' WHERE Mob_ID='08665912-287b-499d-b64d-c616586ca74d';
UPDATE mob SET PathID='Gaheris_Patrol_101_100' WHERE Mob_ID='253d62a1-3423-4d09-8d26-124dccdffc04';
UPDATE mob SET PathID='Gaheris_Patrol_101_100' WHERE Mob_ID='27b277f7-f22e-4e07-a9b5-11b0c7d8fd55';
UPDATE mob SET PathID='Gaheris_Patrol_101_100' WHERE Mob_ID='27f519d0-e505-401a-bec4-7d60213868fb';
UPDATE mob SET PathID='Gaheris_Patrol_101_100' WHERE Mob_ID='3103982a-fac3-414c-b547-bde947340321';
UPDATE mob SET PathID='Gaheris_Patrol_101_100' WHERE Mob_ID='3af8dc91-3192-48d4-94a4-58cfe2389dae';
UPDATE mob SET PathID='Gaheris_Patrol_101_100' WHERE Mob_ID='509094c7-fbb0-4b38-a4e3-271463954445';
UPDATE mob SET PathID='Gaheris_Patrol_101_100' WHERE Mob_ID='5e3a1e0a-de87-4964-bf8e-91258307d614';
UPDATE mob SET PathID='Gaheris_Patrol_101_100' WHERE Mob_ID='609467aa-4562-44a2-b3fa-e9d8c84bf388';
UPDATE mob SET PathID='Gaheris_Patrol_101_100' WHERE Mob_ID='694cc93f-ce03-479d-8786-251434a1ef2f';
UPDATE mob SET PathID='Gaheris_Patrol_101_100' WHERE Mob_ID='95cd8bfb-b7ea-47b5-a057-31c59c46ef96';
UPDATE mob SET PathID='Gaheris_Patrol_101_100' WHERE Mob_ID='ba5ef481-5e79-46df-aa0e-a5b9346d5e84';
UPDATE mob SET PathID='Gaheris_Patrol_101_100' WHERE Mob_ID='d73e1b83-8fe3-4d35-863c-c9371d3e629b';
UPDATE mob SET PathID='Gaheris_Patrol_101_103' WHERE Mob_ID='0462f47c-4891-4fb5-8141-b2e3b35c7ba8';
UPDATE mob SET PathID='Gaheris_Patrol_101_103' WHERE Mob_ID='0bd1c435-e3e5-4f6d-ace8-7ffc7cd1eaf8';
UPDATE mob SET PathID='Gaheris_Patrol_101_103' WHERE Mob_ID='295a0eb8-a756-47cc-92b2-7f9cccbaca6e';
UPDATE mob SET PathID='Gaheris_Patrol_101_103' WHERE Mob_ID='59332dc1-4c83-41ee-af67-78ac282f29d4';
UPDATE mob SET PathID='Gaheris_Patrol_101_103' WHERE Mob_ID='6b8a8ecb-dfa0-439e-bb72-d7d8fad37728';
UPDATE mob SET PathID='Gaheris_Patrol_101_103' WHERE Mob_ID='6ed2ca6a-0ca2-4ef5-92fa-e825435f7ef8';
UPDATE mob SET PathID='Gaheris_Patrol_101_103' WHERE Mob_ID='7fbc81c1-ae5f-4190-990c-04279fdc130c';
UPDATE mob SET PathID='Gaheris_Patrol_101_103' WHERE Mob_ID='82483765-408a-4c97-b613-a109a7913e1e';
UPDATE mob SET PathID='Gaheris_Patrol_101_103' WHERE Mob_ID='d69a6152-8dcd-4b8f-a1f0-917eec5c89b6';
UPDATE mob SET PathID='Gaheris_Patrol_101_103' WHERE Mob_ID='e1f67201-ee63-4180-9168-67e7f9a9dc17';
UPDATE mob SET PathID='Gaheris_Patrol_101_108' WHERE Mob_ID='360a3c3b-176d-4ff5-b5a8-aebc3fe69440';
UPDATE mob SET PathID='Gaheris_Patrol_101_108' WHERE Mob_ID='8910808c-99f2-433c-a503-8eeda17517d8';
UPDATE mob SET PathID='Gaheris_Patrol_101_108' WHERE Mob_ID='b41fa513-c1cb-46ad-a6b9-0b5a161993d3';
UPDATE mob SET PathID='Gaheris_Patrol_101_108' WHERE Mob_ID='f2265548-10e2-4eee-8a2d-0e8eddc0457e';
UPDATE mob SET PathID='Gaheris_Patrol_102_100' WHERE Mob_ID='0bc3602d-ae2b-4002-b6a0-87c712e1b1eb';
UPDATE mob SET PathID='Gaheris_Patrol_102_100' WHERE Mob_ID='0dc83ad9-948e-45f0-8027-e498ac79d033';
UPDATE mob SET PathID='Gaheris_Patrol_102_100' WHERE Mob_ID='905f71f2-43ea-4a8f-97fd-1400444542a4';
UPDATE mob SET PathID='Gaheris_Patrol_102_100' WHERE Mob_ID='a02133eb-c6e8-48f7-992c-2f5dd52ba682';
UPDATE mob SET PathID='Gaheris_Patrol_102_100' WHERE Mob_ID='a6f34bc5-df66-4535-a9c3-9fdd7eaa4eab';
UPDATE mob SET PathID='Gaheris_Patrol_102_100' WHERE Mob_ID='a8d77499-9fa3-46b0-98c0-ff1867f2097d';
UPDATE mob SET PathID='Gaheris_Patrol_102_100' WHERE Mob_ID='b11c8333-daf2-4afa-a113-b4a658e570c8';
UPDATE mob SET PathID='Gaheris_Patrol_102_100' WHERE Mob_ID='b9945960-b405-4cf3-bae7-d44be6ec1526';
UPDATE mob SET PathID='Gaheris_Patrol_102_100' WHERE Mob_ID='e448ba5b-ae94-42d4-9559-c97717367092';
UPDATE mob SET PathID='Gaheris_Patrol_102_100' WHERE Mob_ID='ea7ed88b-a6cd-4918-bd7b-d587483f9c8c';
UPDATE mob SET PathID='Gaheris_Patrol_102_100' WHERE Mob_ID='eb365d4e-9fbb-4813-85c8-ad2e7b0cd7db';
UPDATE mob SET PathID='Gaheris_Patrol_102_100' WHERE Mob_ID='f2339526-56de-4eda-a48b-a7824549cacf';
UPDATE mob SET PathID='Gaheris_Patrol_102_100' WHERE Mob_ID='f858516d-b022-4cb6-835a-52d4422d082a';
UPDATE mob SET PathID='Gaheris_Patrol_102_100' WHERE Mob_ID='f97160b1-db8e-4698-8f11-d31152976e56';
UPDATE mob SET PathID='Gaheris_Patrol_102_102' WHERE Mob_ID='2059a518-b66d-4932-96bc-51d463fae79c';
UPDATE mob SET PathID='Gaheris_Patrol_102_102' WHERE Mob_ID='5041b36f-0a93-407a-a481-ec9e1ccde345';
UPDATE mob SET PathID='Gaheris_Patrol_102_102' WHERE Mob_ID='69c51ead-6864-44b7-b0ab-4e4a0c152fd7';
UPDATE mob SET PathID='Gaheris_Patrol_102_102' WHERE Mob_ID='6c84209b-4125-4af9-bd7c-2965eaeb1fc0';
UPDATE mob SET PathID='Gaheris_Patrol_102_102' WHERE Mob_ID='772ef035-b8bb-4131-ad66-f6f2c6f67245';
UPDATE mob SET PathID='Gaheris_Patrol_102_102' WHERE Mob_ID='a3a0f80d-c21b-4436-b9c1-32fc4a55708f';
UPDATE mob SET PathID='Gaheris_Patrol_102_102' WHERE Mob_ID='bbf7c2d0-2705-4822-b84e-097243a170c7';
UPDATE mob SET PathID='Gaheris_Patrol_102_102' WHERE Mob_ID='d0f79922-f776-4b4f-b132-1ffc66ead149';
UPDATE mob SET PathID='Gaheris_Patrol_102_108' WHERE Mob_ID='6e173ec4-c633-4c1f-b2aa-2964c7d63654';
UPDATE mob SET PathID='Gaheris_Patrol_102_108' WHERE Mob_ID='8490ec63-8a31-49e8-bde3-0d4b029ad600';
UPDATE mob SET PathID='Gaheris_Patrol_102_108' WHERE Mob_ID='9934b984-f9a3-4fae-a1b1-2e75a0ecc3c5';
UPDATE mob SET PathID='Gaheris_Patrol_102_108' WHERE Mob_ID='a4a831eb-bbef-44c1-b564-145b552a966e';
UPDATE mob SET PathID='Gaheris_Patrol_103_100' WHERE Mob_ID='04cdda0e-02a1-408c-ba77-0a931aba25b1';
UPDATE mob SET PathID='Gaheris_Patrol_103_100' WHERE Mob_ID='0a3a7bb1-af1d-4121-9106-c709114d0566';
UPDATE mob SET PathID='Gaheris_Patrol_103_100' WHERE Mob_ID='0d7fd474-bcd1-48a6-90cc-8cb88d4c9b00';
UPDATE mob SET PathID='Gaheris_Patrol_103_100' WHERE Mob_ID='1a2baee8-18cb-4d1c-b801-33ef48892ed0';
UPDATE mob SET PathID='Gaheris_Patrol_103_100' WHERE Mob_ID='48b15791-bd39-4d8f-88f0-6333c11c66c4';
UPDATE mob SET PathID='Gaheris_Patrol_103_100' WHERE Mob_ID='7cafa883-3f09-49f6-955e-202ed938a8d7';
UPDATE mob SET PathID='Gaheris_Patrol_103_100' WHERE Mob_ID='84b9b704-4aa0-4901-8da7-cff064155363';
UPDATE mob SET PathID='Gaheris_Patrol_103_100' WHERE Mob_ID='8bf6a57d-ac4e-4a6e-8a7a-8e8c0813bf52';
UPDATE mob SET PathID='Gaheris_Patrol_103_100' WHERE Mob_ID='b69801f1-67d1-4889-9111-4af0bafc1353';
UPDATE mob SET PathID='Gaheris_Patrol_103_100' WHERE Mob_ID='c3678086-6ebf-4eeb-b3c5-4a26372a77b8';
UPDATE mob SET PathID='Gaheris_Patrol_103_100' WHERE Mob_ID='eba0a637-b6d1-4735-807f-1dc2c068ea1f';
UPDATE mob SET PathID='Gaheris_Patrol_103_100' WHERE Mob_ID='f12b9194-97a2-479c-bcc3-857a7a69bd52';
UPDATE mob SET PathID='Gaheris_Patrol_103_100' WHERE Mob_ID='ff107939-55c2-4535-8931-70a4d691a02f';
UPDATE mob SET PathID='Gaheris_Patrol_103_103' WHERE Mob_ID='1c82473b-a1ca-47f7-8d37-2dac5c3d0258';
UPDATE mob SET PathID='Gaheris_Patrol_103_103' WHERE Mob_ID='684997eb-93f4-4c88-a0f6-4319283cfeb8';
UPDATE mob SET PathID='Gaheris_Patrol_103_103' WHERE Mob_ID='a10808e7-c0d5-4ae9-a0b2-fa5b4f69616a';
UPDATE mob SET PathID='Gaheris_Patrol_103_103' WHERE Mob_ID='a264167a-3e5d-406d-941a-03f0b5fc7793';
UPDATE mob SET PathID='Gaheris_Patrol_103_103' WHERE Mob_ID='ad64fbbb-2b1f-4c79-a2a6-b7e22f6cca9f';
UPDATE mob SET PathID='Gaheris_Patrol_103_103' WHERE Mob_ID='b993309a-0037-4f00-a9be-ac2e6c7b4981';
UPDATE mob SET PathID='Gaheris_Patrol_103_103' WHERE Mob_ID='f6d36945-419c-4ed8-ba61-d0c6a28fb15d';
UPDATE mob SET PathID='Gaheris_Patrol_103_108' WHERE Mob_ID='4cd62eb9-0a33-4200-a249-2d743742fa21';
UPDATE mob SET PathID='Gaheris_Patrol_103_108' WHERE Mob_ID='77af489c-3851-4e1c-a635-616ecccc3495';
UPDATE mob SET PathID='Gaheris_Patrol_103_108' WHERE Mob_ID='a32d77b6-59ce-4576-9533-f20bf9aedf20';
UPDATE mob SET PathID='Gaheris_Patrol_103_108' WHERE Mob_ID='aa732403-e630-4a7d-9015-a6ad417c02c0';
UPDATE mob SET PathID='Gaheris_Patrol_104_100' WHERE Mob_ID='35d70181-f13e-449c-b205-836997767faf';
UPDATE mob SET PathID='Gaheris_Patrol_104_100' WHERE Mob_ID='56bcf1e0-6a7a-4ded-8fb6-db91065ae521';
UPDATE mob SET PathID='Gaheris_Patrol_104_100' WHERE Mob_ID='6570c8dc-2e5d-4d75-afa2-a3f980870e21';
UPDATE mob SET PathID='Gaheris_Patrol_104_100' WHERE Mob_ID='688bc136-76f3-4df0-b0aa-4a00b41b12ef';
UPDATE mob SET PathID='Gaheris_Patrol_104_100' WHERE Mob_ID='73803813-6c21-4e0f-a66d-ef5dbc949221';
UPDATE mob SET PathID='Gaheris_Patrol_104_100' WHERE Mob_ID='a1c9690e-2ba7-42a9-bb5a-5e541c2d244f';
UPDATE mob SET PathID='Gaheris_Patrol_104_100' WHERE Mob_ID='b5451ca5-8359-451b-8ca6-ec4b5a95d1ce';
UPDATE mob SET PathID='Gaheris_Patrol_104_100' WHERE Mob_ID='dfb4f649-ca79-4b58-ad65-26412faaa1e6';
UPDATE mob SET PathID='Gaheris_Patrol_104_100' WHERE Mob_ID='f90b0b15-938a-408e-bcff-953771ef7e2b';
UPDATE mob SET PathID='Gaheris_Patrol_104_102' WHERE Mob_ID='09c82c69-5b50-48ab-bb9e-b2ec2826b58a';
UPDATE mob SET PathID='Gaheris_Patrol_104_102' WHERE Mob_ID='0b67eb3b-81d6-4c66-bdf5-da2202aab13d';
UPDATE mob SET PathID='Gaheris_Patrol_104_102' WHERE Mob_ID='2f09f147-ac3c-45c6-93cd-82e8eefe5f83';
UPDATE mob SET PathID='Gaheris_Patrol_104_102' WHERE Mob_ID='39e8c5b2-7592-4cc6-9c91-c50e3ebec2d7';
UPDATE mob SET PathID='Gaheris_Patrol_104_102' WHERE Mob_ID='a5b7ce61-6708-418b-9783-e6ef9d731a9c';
UPDATE mob SET PathID='Gaheris_Patrol_104_102' WHERE Mob_ID='b5f552c0-7131-48ab-aef1-c8b55fefe63d';
UPDATE mob SET PathID='Gaheris_Patrol_104_102' WHERE Mob_ID='d02a161a-34b1-475a-bb22-03886070cc61';
UPDATE mob SET PathID='Gaheris_Patrol_104_102' WHERE Mob_ID='e0d741fb-917a-4310-b6d2-c5f61bfe47b2';
UPDATE mob SET PathID='Gaheris_Patrol_104_108' WHERE Mob_ID='037146ab-bc0b-4051-ab7f-2f7ad0ed3604';
UPDATE mob SET PathID='Gaheris_Patrol_104_108' WHERE Mob_ID='6fe02a75-139c-4c8a-8905-49771e579de8';
UPDATE mob SET PathID='Gaheris_Patrol_104_108' WHERE Mob_ID='ab61427a-e668-4e50-b4f3-95422011839b';
UPDATE mob SET PathID='Gaheris_Patrol_104_108' WHERE Mob_ID='dc600ea3-73da-4524-b68d-1324c6897cdc';
UPDATE mob SET PathID='Gaheris_Patrol_105_100' WHERE Mob_ID='06bb0a50-2f23-4f94-b90d-62cb275dc3b2';
UPDATE mob SET PathID='Gaheris_Patrol_105_100' WHERE Mob_ID='1a6751ec-c983-45f0-855f-4ad6f08a346b';
UPDATE mob SET PathID='Gaheris_Patrol_105_100' WHERE Mob_ID='22e41aec-bfa8-41a8-8e5a-c8f1a6e60f79';
UPDATE mob SET PathID='Gaheris_Patrol_105_100' WHERE Mob_ID='5a5bac69-dccd-4391-b2b7-0fff0119b714';
UPDATE mob SET PathID='Gaheris_Patrol_105_100' WHERE Mob_ID='63edfc50-c510-4138-8361-4e27f9262d4e';
UPDATE mob SET PathID='Gaheris_Patrol_105_100' WHERE Mob_ID='6a0248cc-1f6d-4721-9a39-892dd0990235';
UPDATE mob SET PathID='Gaheris_Patrol_105_100' WHERE Mob_ID='8883eed9-2948-40a8-8e3c-25da0b073d61';
UPDATE mob SET PathID='Gaheris_Patrol_105_100' WHERE Mob_ID='8a0a1771-9d69-44be-803c-a04ae8338f5f';
UPDATE mob SET PathID='Gaheris_Patrol_105_100' WHERE Mob_ID='d5a092b0-bafd-4bc5-b92f-66fecf61ba9d';
UPDATE mob SET PathID='Gaheris_Patrol_105_100' WHERE Mob_ID='d780f630-0e8b-471d-ace9-b6d035308204';
UPDATE mob SET PathID='Gaheris_Patrol_105_100' WHERE Mob_ID='d9d043c4-e9e7-42bf-9c5e-44200f7bb9cc';
UPDATE mob SET PathID='Gaheris_Patrol_105_100' WHERE Mob_ID='e5f6bfb6-4f01-4a06-b299-88afa2278036';
UPDATE mob SET PathID='Gaheris_Patrol_105_100' WHERE Mob_ID='e613af26-7e75-42e0-a543-d8068a042cd8';
UPDATE mob SET PathID='Gaheris_Patrol_105_100' WHERE Mob_ID='f2645901-cd5d-445c-aaa5-1abae885b28c';
UPDATE mob SET PathID='Gaheris_Patrol_105_102' WHERE Mob_ID='0e5f9478-331d-493b-9787-ad53e989bcfd';
UPDATE mob SET PathID='Gaheris_Patrol_105_102' WHERE Mob_ID='1c53b586-c92e-4530-965f-fef53d346e39';
UPDATE mob SET PathID='Gaheris_Patrol_105_102' WHERE Mob_ID='459b4630-509b-477d-b8de-408af87890e0';
UPDATE mob SET PathID='Gaheris_Patrol_105_102' WHERE Mob_ID='48fa3431-3d8f-4194-9bd0-932e5633da21';
UPDATE mob SET PathID='Gaheris_Patrol_105_102' WHERE Mob_ID='584e8201-c97f-4fbf-bb9e-d7ca0012a1e8';
UPDATE mob SET PathID='Gaheris_Patrol_105_102' WHERE Mob_ID='93afe671-e94b-4002-850f-b5c51cbca0f3';
UPDATE mob SET PathID='Gaheris_Patrol_105_102' WHERE Mob_ID='9f7a3b8e-7390-4673-bc72-2089c3c7d0d6';
UPDATE mob SET PathID='Gaheris_Patrol_105_102' WHERE Mob_ID='e974c021-8d78-4e8e-a5bc-186a6db2682b';
UPDATE mob SET PathID='Gaheris_Patrol_105_108' WHERE Mob_ID='002b203b-47d7-4aa8-b988-91e9e3036a18';
UPDATE mob SET PathID='Gaheris_Patrol_105_108' WHERE Mob_ID='4335e663-c384-49c3-bf83-fa56af1427a0';
UPDATE mob SET PathID='Gaheris_Patrol_105_108' WHERE Mob_ID='803e4676-041a-4070-a394-647e4118a7d2';
UPDATE mob SET PathID='Gaheris_Patrol_105_108' WHERE Mob_ID='b127f829-9ace-4991-98e7-0113cd68d79f';
UPDATE mob SET PathID='Gaheris_Patrol_106_100' WHERE Mob_ID='04968981-836e-4235-bfc0-7e55d412a7a0';
UPDATE mob SET PathID='Gaheris_Patrol_106_100' WHERE Mob_ID='2077f74d-b4c4-48b7-96bd-ca2678152efc';
UPDATE mob SET PathID='Gaheris_Patrol_106_100' WHERE Mob_ID='52a7d536-8f41-4818-a661-d7e88fa17e6b';
UPDATE mob SET PathID='Gaheris_Patrol_106_100' WHERE Mob_ID='87f1dd87-96b7-48e9-9ca1-580e07aa80d2';
UPDATE mob SET PathID='Gaheris_Patrol_106_100' WHERE Mob_ID='8d16bcfd-6f12-43ee-913c-15ed660f49b5';
UPDATE mob SET PathID='Gaheris_Patrol_106_100' WHERE Mob_ID='9844757e-0fbb-4dcc-85a2-fec88849a60c';
UPDATE mob SET PathID='Gaheris_Patrol_106_100' WHERE Mob_ID='9d3e7b05-4764-471e-8ed6-7ff4f7e0e3b0';
UPDATE mob SET PathID='Gaheris_Patrol_106_100' WHERE Mob_ID='c374c84b-7ef8-4f40-8814-e243d2495a65';
UPDATE mob SET PathID='Gaheris_Patrol_106_100' WHERE Mob_ID='c8193026-fea2-46c4-9628-e224a8b20dc1';
UPDATE mob SET PathID='Gaheris_Patrol_106_100' WHERE Mob_ID='cc7b3b00-c866-4b77-a4e3-668c97bf5167';
UPDATE mob SET PathID='Gaheris_Patrol_106_100' WHERE Mob_ID='e3f0326f-ee6a-4533-b68d-514ed5697d4b';
UPDATE mob SET PathID='Gaheris_Patrol_106_100' WHERE Mob_ID='f9e05fc4-1854-4f77-bb92-6403ef38820d';
UPDATE mob SET PathID='Gaheris_Patrol_106_102' WHERE Mob_ID='5e5cb9b0-9b6d-43a5-877c-afa34714d945';
UPDATE mob SET PathID='Gaheris_Patrol_106_102' WHERE Mob_ID='607b051a-0918-4fbc-ae89-ad528ce15cdd';
UPDATE mob SET PathID='Gaheris_Patrol_106_102' WHERE Mob_ID='7c360720-0711-4c52-adbe-5dbe88f161fd';
UPDATE mob SET PathID='Gaheris_Patrol_106_102' WHERE Mob_ID='7ee03640-e1e7-4af6-b399-ac16f1abbc5d';
UPDATE mob SET PathID='Gaheris_Patrol_106_102' WHERE Mob_ID='a6053807-c02b-402d-ab45-e849422b5cbf';
UPDATE mob SET PathID='Gaheris_Patrol_106_102' WHERE Mob_ID='ad3d3784-8d9c-4f76-b440-d9ba63408828';
UPDATE mob SET PathID='Gaheris_Patrol_106_102' WHERE Mob_ID='b737cfaa-7ae6-4732-969c-233628d528d3';
UPDATE mob SET PathID='Gaheris_Patrol_106_102' WHERE Mob_ID='c7a70b24-8774-4508-a982-e1456a1f61e0';
UPDATE mob SET PathID='Gaheris_Patrol_106_108' WHERE Mob_ID='0850e14d-36f0-4f7d-974e-f5dc2b6acaac';
UPDATE mob SET PathID='Gaheris_Patrol_106_108' WHERE Mob_ID='3ab5412b-aae1-4f0f-a888-f47a5cae93c1';
UPDATE mob SET PathID='Gaheris_Patrol_106_108' WHERE Mob_ID='7dc12fa7-ff01-4749-847b-5d18b5cf00ec';
UPDATE mob SET PathID='Gaheris_Patrol_106_108' WHERE Mob_ID='d7dbfb4f-69ef-4bc9-a0d0-7ff222d7e0d8';
UPDATE mob SET PathID='Gaheris_Patrol_110_100' WHERE Mob_ID='07be70fa-2cbb-4eb5-b049-8d01dc48bf73';
UPDATE mob SET PathID='Gaheris_Patrol_110_100' WHERE Mob_ID='12b83b6f-89b9-45f9-a0be-5fdbe6bb9f4d';
UPDATE mob SET PathID='Gaheris_Patrol_110_100' WHERE Mob_ID='2b22e51d-cde8-48e6-9138-95a6e578e618';
UPDATE mob SET PathID='Gaheris_Patrol_110_100' WHERE Mob_ID='3438f0f6-9045-4c4b-ac12-1269d9069b5b';
UPDATE mob SET PathID='Gaheris_Patrol_110_100' WHERE Mob_ID='4c1134e1-59cb-4590-aa55-57f88cef0ba8';
UPDATE mob SET PathID='Gaheris_Patrol_110_100' WHERE Mob_ID='5d2ddef7-46f5-485e-b5ff-efd9e1174289';
UPDATE mob SET PathID='Gaheris_Patrol_110_100' WHERE Mob_ID='821b5c6b-7383-4eaf-a48c-80b433bec3ec';
UPDATE mob SET PathID='Gaheris_Patrol_110_100' WHERE Mob_ID='8536748e-2296-4b8e-a361-6d54534f810a';
UPDATE mob SET PathID='Gaheris_Patrol_110_100' WHERE Mob_ID='8ece275e-21c0-44ad-8192-0caa927c238d';
UPDATE mob SET PathID='Gaheris_Patrol_110_100' WHERE Mob_ID='c1030f24-f22c-456e-907d-130486d3e07b';
UPDATE mob SET PathID='Gaheris_Patrol_110_100' WHERE Mob_ID='f167917b-ca4d-497e-9950-f76887b71727';
UPDATE mob SET PathID='Gaheris_Patrol_110_100' WHERE Mob_ID='f76d223b-c1c4-4c69-a15b-8ff17b6e1846';
UPDATE mob SET PathID='Gaheris_Patrol_111_92' WHERE Mob_ID='2033b0e2-3ab2-4d1f-ac88-d8140c0cbfe3';
UPDATE mob SET PathID='Gaheris_Patrol_111_92' WHERE Mob_ID='3364cbd2-4978-4824-b99a-9cbea4a71cde';
UPDATE mob SET PathID='Gaheris_Patrol_111_92' WHERE Mob_ID='43854874-6575-4069-aed9-798993bb0f32';
UPDATE mob SET PathID='Gaheris_Patrol_111_92' WHERE Mob_ID='49de757d-e692-48a7-b1e6-30c6d6976367';
UPDATE mob SET PathID='Gaheris_Patrol_111_92' WHERE Mob_ID='4f9b0340-cc0b-4d79-b450-d069e8434b19';
UPDATE mob SET PathID='Gaheris_Patrol_111_92' WHERE Mob_ID='a7810d33-d145-449f-bff3-8e251a5154d7';
UPDATE mob SET PathID='Gaheris_Patrol_111_92' WHERE Mob_ID='a99125fc-5e04-43c0-b0a0-0e263460097e';
UPDATE mob SET PathID='Gaheris_Patrol_111_92' WHERE Mob_ID='d3f08777-bba7-45dd-8ec0-5038df189576';
UPDATE mob SET PathID='Gaheris_Patrol_111_92' WHERE Mob_ID='d8c9c469-2f2c-4c6a-800d-23e8808fb9a8';
UPDATE mob SET PathID='Gaheris_Patrol_111_92' WHERE Mob_ID='d934a1e3-699c-44fb-a618-92efbc70b852';
UPDATE mob SET PathID='Gaheris_Patrol_111_92' WHERE Mob_ID='e4272634-5cfe-4409-9652-3b9c87afc280';
UPDATE mob SET PathID='Gaheris_Patrol_111_92' WHERE Mob_ID='e90a85e6-7007-438b-b549-0e4dbca6e08d';
UPDATE mob SET PathID='Gaheris_Patrol_111_95' WHERE Mob_ID='1155a192-489a-4221-8e22-0bde8f3b9bd1';
UPDATE mob SET PathID='Gaheris_Patrol_111_95' WHERE Mob_ID='246be635-e14d-4c7d-948c-bea6a5fdcc41';
UPDATE mob SET PathID='Gaheris_Patrol_111_95' WHERE Mob_ID='6479545b-c304-448c-a26d-44d9bb4e8b76';
UPDATE mob SET PathID='Gaheris_Patrol_111_95' WHERE Mob_ID='b31c48fa-e767-4d93-ba3c-1e66997cc59b';
UPDATE mob SET PathID='Gaheris_Patrol_111_95' WHERE Mob_ID='d49c473a-38c1-4833-97ff-c4d500bb2af6';
UPDATE mob SET PathID='Gaheris_Patrol_111_95' WHERE Mob_ID='eabb4f74-2ba9-477e-bca2-774762d12466';
UPDATE mob SET PathID='Gaheris_Patrol_198_99' WHERE Mob_ID='01769651-5e6b-4d72-8097-5cde213f7c13';
UPDATE mob SET PathID='Gaheris_Patrol_198_99' WHERE Mob_ID='202a943a-f227-4228-a78f-0d8d350196d5';
UPDATE mob SET PathID='Gaheris_Patrol_198_99' WHERE Mob_ID='2a4ffb8c-cc96-4150-aede-6968e4bf678a';
UPDATE mob SET PathID='Gaheris_Patrol_198_99' WHERE Mob_ID='3e45d7a6-b8b2-4fe2-8df9-0b1a2fdd0d10';
UPDATE mob SET PathID='Gaheris_Patrol_198_99' WHERE Mob_ID='5a43bcd5-a312-49fd-8318-4000f6eb6f14';
UPDATE mob SET PathID='Gaheris_Patrol_198_99' WHERE Mob_ID='5ae561e5-bc52-4cce-922c-133587d497fd';
UPDATE mob SET PathID='Gaheris_Patrol_198_99' WHERE Mob_ID='6dd61a0f-81f1-4fbb-bbe5-f9c05866320e';
UPDATE mob SET PathID='Gaheris_Patrol_198_99' WHERE Mob_ID='7ca1abe4-64d2-451e-8e65-a20118fa644a';
UPDATE mob SET PathID='Gaheris_Patrol_198_99' WHERE Mob_ID='915d2639-ca7b-4a90-9146-f2d995e8987c';
UPDATE mob SET PathID='Gaheris_Patrol_198_99' WHERE Mob_ID='a11cfe27-e7b9-46f4-864a-fe5522b70dfa';
UPDATE mob SET PathID='Gaheris_Patrol_198_99' WHERE Mob_ID='cbd32ce5-87b8-44ab-a90d-94319e49a666';
UPDATE mob SET PathID='Gaheris_Patrol_198_99' WHERE Mob_ID='f51a4f96-7ad3-4829-a78c-8a4c555837eb';

-- ---------------------------------------------------------------------------
-- 6. The Dreaded Seal economy
-- ---------------------------------------------------------------------------
-- OpenDAoC already implements the mechanism: DreadedSealCollector.cs and
-- LootGeneratorDreadedSeals.cs, with tuning properties whose defaults
-- reproduce the live Gaheris reward table exactly. Only the data was missing.
--
-- Adapted from Eve ServerType.PVE.DreadedSeals.sql. The one substantive change
-- is loot generator scope: Eve registers region 163 (New Frontiers), which is
-- unreachable here, so it is replaced with Old Frontiers regions 1, 100 and
-- 200 plus Darkness Falls (249), where 2,493 mobs and 9 of 10 named bosses
-- already exist.
--
-- The Apocalypse loot row is retained but inert -- that mob does not exist in
-- this database.
-- ---------------------------------------------------------------------------

### Adds Dreaded Seal content, including the seals themselves, crafting recipes, and collectors.

# Add Dreaded Seal Collectors to mob
DELETE FROM `Mob` WHERE `Name` IN ('Lady Nina','Fiana','Relena');
REPLACE INTO `Mob` (`Name`,`ClassType`,`Guild`,`X`,`Y`,`Z`,`Speed`,`Strength`,`Constitution`,`Dexterity`,`Quickness`,`Intelligence`,`Piety`,`Empathy`,`Charisma`,`RespawnInterval`,`OwnerID`,`VisibleWeaponSlots`,`HouseNumber`,`Heading`,`Region`,`Model`,`Size`,`Level`,`EquipmentTemplateID`,`PackageID`,`Realm`,`Mob_ID`)
	VALUES ('Lady Nina','DOL.GS.DreadedSealCollector','Dreaded Seal Collector',33505,22668,8479,0,0,0,0,0,0,0,0,0,0,0,0,0,1035,10,283,49,30,'LadyNina','DreadedSeal',1,'Dreaded_Seal_Lady_Nina');
REPLACE INTO `Mob` (`Name`,`ClassType`,`Guild`,`X`,`Y`,`Z`,`Speed`,`Strength`,`Constitution`,`Dexterity`,`Quickness`,`Intelligence`,`Piety`,`Empathy`,`Charisma`,`RespawnInterval`,`OwnerID`,`VisibleWeaponSlots`,`HouseNumber`,`Heading`,`Region`,`Model`,`Size`,`Level`,`EquipmentTemplateID`,`PackageID`,`Realm`,`Mob_ID`)
	VALUES ('Fiana','DOL.GS.DreadedSealCollector','Dreaded Seal Collector',31613,33839,8030,0,0,0,0,0,0,0,0,0,0,0,0,0,3231,101,162,48,30,'Fiana','DreadedSeal',2,'Dreaded_Seal_Fiana');
REPLACE INTO `Mob` (`Name`,`ClassType`,`Guild`,`X`,`Y`,`Z`,`Speed`,`Strength`,`Constitution`,`Dexterity`,`Quickness`,`Intelligence`,`Piety`,`Empathy`,`Charisma`,`RespawnInterval`,`OwnerID`,`VisibleWeaponSlots`,`HouseNumber`,`Heading`,`Region`,`Model`,`Size`,`Level`,`EquipmentTemplateID`,`PackageID`,`Realm`,`Mob_ID`)
	VALUES ('Relena','DOL.GS.DreadedSealCollector','Dreaded Seal Collector',32263,33049,7998,0,0,0,0,0,0,0,0,0,0,0,0,0,2150,201,388,52,30,'Relena','DreadedSeal',3,'Dreaded_Seal_Relena');

# Add Dreaded Seal Collectors stuff to NPCEquipment
REPLACE INTO `NPCEquipment` (`TemplateID`,`Slot`,`Model`,`Color`,`NPCEquipment_ID`)
	VALUES ('LadyNina',25,98,40,'LadyNina1');
REPLACE INTO `NPCEquipment` (`TemplateID`,`Slot`,`Model`,`Color`,`NPCEquipment_ID`)
	VALUES ('LadyNina',26,96,43,'LadyNina2');
REPLACE INTO `NPCEquipment` (`TemplateID`,`Slot`,`Model`,`Color`,`NPCEquipment_ID`)
	VALUES ('Fiana',22,137,9,'Fiana1');
REPLACE INTO `NPCEquipment` (`TemplateID`,`Slot`,`Model`,`Color`,`NPCEquipment_ID`)
	VALUES ('Fiana',23,138,9,'Fiana2');
REPLACE INTO `NPCEquipment` (`TemplateID`,`Slot`,`Model`,`Color`,`NPCEquipment_ID`)
	VALUES ('Fiana',25,134,9,'Fiana3');
REPLACE INTO `NPCEquipment` (`TemplateID`,`Slot`,`Model`,`Color`,`NPCEquipment_ID`)
	VALUES ('Fiana',26,96,72,'Fiana4');
REPLACE INTO `NPCEquipment` (`TemplateID`,`Slot`,`Model`,`Color`,`NPCEquipment_ID`)
	VALUES ('Fiana',27,152,73,'Fiana5');
REPLACE INTO `NPCEquipment` (`TemplateID`,`Slot`,`Model`,`Color`,`NPCEquipment_ID`)
	VALUES ('Fiana',28,141,73,'Fiana6');
REPLACE INTO `NPCEquipment` (`TemplateID`,`Slot`,`Model`,`Color`,`NPCEquipment_ID`)
	VALUES ('Relena',23,143,43,'Relena1');
REPLACE INTO `NPCEquipment` (`TemplateID`,`Slot`,`Model`,`Color`,`NPCEquipment_ID`)
	VALUES ('Relena',25,58,43,'Relena2');
REPLACE INTO `NPCEquipment` (`TemplateID`,`Slot`,`Model`,`Color`,`NPCEquipment_ID`)
	VALUES ('Relena',26,57,0,'Relena3');

# Add Dreaded Seals to ItemTemplate
REPLACE INTO `ItemTemplate` (`Id_nb`,`Name`,`Level`,`Item_Type`,`Model`,`CanDropAsLoot`,`IsTradable`,`IsIndestructible`,`Object_Type`,`IsDropable`,`Quality`,`Weight`,`MaxCondition`,`MaxDurability`,`Condition`,`Durability`,`MaxCount`,`Description`,`Price`,`CanUseEvery`,`AllowedClasses`,`IsPickable`,`PackSize`)
	VALUES ('glowing_dreaded_seal','Glowing Dreaded Seal',30,14,483,1,1,0,0,1,70,0,100,100,100,100,10,'To show appreciation for service fighting these enemies -\nthe lords of the land will award Realm points and Realm abilities to those who defeat them.\nThe people who accept these seals are in the 3 major cities:\nRelena in Tir Na Nog\nLady Nina in Camelot\nand Fiana in Jordheim.',3000,0,'',1,1);
REPLACE INTO `ItemTemplate` (`Id_nb`,`Name`,`Level`,`Item_Type`,`Model`,`CanDropAsLoot`,`IsTradable`,`IsIndestructible`,`Object_Type`,`IsDropable`,`Quality`,`Weight`,`MaxCondition`,`MaxDurability`,`Condition`,`Durability`,`MaxCount`,`Description`,`Price`,`CanUseEvery`,`AllowedClasses`,`IsPickable`,`PackSize`)
	VALUES ('sanguine_dreaded_seal','Sanguine Dreaded Seal',30,14,484,1,1,0,0,1,70,0,100,100,100,100,5,'To show appreciation for service fighting these enemies -\nthe lords of the land will award Realm points and Realm abilities to those who defeat them.\nThe people who accept these seals are in the 3 major cities:\nRelena in Tir Na Nog\nLady Nina in Camelot\nand Fiana in Jordheim.',3000,0,'',1,1);
REPLACE INTO `ItemTemplate` (`Id_nb`,`Name`,`Level`,`Item_Type`,`Model`,`CanDropAsLoot`,`IsTradable`,`IsIndestructible`,`Object_Type`,`IsDropable`,`Quality`,`Weight`,`MaxCondition`,`MaxDurability`,`Condition`,`Durability`,`MaxCount`,`Description`,`Price`,`CanUseEvery`,`AllowedClasses`,`IsPickable`,`PackSize`)
	VALUES ('lambent_dreaded_seal','Lambent Dreaded Seal',30,14,485,1,1,0,0,1,70,0,100,100,100,100,5,'To show appreciation for service fighting these enemies -\nthe lords of the land will award Realm points and Realm abilities to those who defeat them.\nThe people who accept these seals are in the 3 major cities:\nRelena in Tir Na Nog\nLady Nina in Camelot\nand Fiana in Jordheim.\n\nThis seal is worth 10 times the Glowing variety.',30000,0,'',1,1);
REPLACE INTO `ItemTemplate` (`Id_nb`,`Name`,`Level`,`Item_Type`,`Model`,`CanDropAsLoot`,`IsTradable`,`IsIndestructible`,`Object_Type`,`IsDropable`,`Quality`,`Weight`,`MaxCondition`,`MaxDurability`,`Condition`,`Durability`,`MaxCount`,`Description`,`Price`,`CanUseEvery`,`AllowedClasses`,`IsPickable`,`PackSize`)
	VALUES ('lambent_dreaded_seal2','Lambent Dreaded Seal',30,14,485,1,1,0,0,1,70,0,100,100,100,100,5,'To show appreciation for service fighting these enemies -\nthe lords of the land will award Realm points and Realm abilities to those who defeat them.\nThe people who accept these seals are in the 3 major cities:\nRelena in Tir Na Nog\nLady Nina in Camelot\nand Fiana in Jordheim.\n\nThis seal is worth 10 times the Glowing variety.',30000,0,'',1,1);
REPLACE INTO `ItemTemplate` (`Id_nb`,`Name`,`Level`,`Item_Type`,`Model`,`CanDropAsLoot`,`IsTradable`,`IsIndestructible`,`Object_Type`,`IsDropable`,`Quality`,`Weight`,`MaxCondition`,`MaxDurability`,`Condition`,`Durability`,`MaxCount`,`Description`,`Price`,`CanUseEvery`,`AllowedClasses`,`IsPickable`,`PackSize`)
	VALUES ('fulgent_dreaded_seal','Fulgent Dreaded Seal',30,14,486,1,1,0,0,1,70,0,100,100,100,100,1,'To show appreciation for service fighting these enemies -\nthe lords of the land will award Realm points and Realm abilities to those who defeat them.\nThe people who accept these seals are in the 3 major cities:\nRelena in Tir Na Nog\nLady Nina in Camelot\nand Fiana in Jordheim.\n\nThis seal is worth 50 times the Glowing variety.',150000,0,'',1,1);
REPLACE INTO `ItemTemplate` (`Id_nb`,`Name`,`Level`,`Item_Type`,`Model`,`CanDropAsLoot`,`IsTradable`,`IsIndestructible`,`Object_Type`,`IsDropable`,`Quality`,`Weight`,`MaxCondition`,`MaxDurability`,`Condition`,`Durability`,`MaxCount`,`Description`,`Price`,`CanUseEvery`,`AllowedClasses`,`IsPickable`,`PackSize`)
	VALUES ('effulgent_dreaded_seal','Effulgent Dreaded Seal',30,14,487,1,1,0,0,1,70,0,100,100,100,100,5,'To show appreciation for service fighting these enemies -\nthe lords of the land will award Realm points and Realm abilities to those who defeat them.\nThe people who accept these seals are in the 3 major cities:\nRelena in Tir Na Nog\nLady Nina in Camelot\nand Fiana in Jordheim.\n\nThis seal is worth 250 times the Glowing variety.',750000,0,'',1,1);

# Add crafting recipes to CraftedItem
REPLACE INTO `CraftedItem` (`Id_nb`,`CraftedItemID`,`CraftingLevel`,`CraftingSkillType`,`MakeTemplated`)
	VALUES ('lambent_dreaded_seal',4894,1,15,1);
REPLACE INTO `CraftedItem` (`Id_nb`,`CraftedItemID`,`CraftingLevel`,`CraftingSkillType`,`MakeTemplated`)
	VALUES ('lambent_dreaded_seal2',4895,1,15,1);
REPLACE INTO `CraftedItem` (`Id_nb`,`CraftedItemID`,`CraftingLevel`,`CraftingSkillType`,`MakeTemplated`)
	VALUES ('fulgent_dreaded_seal',4896,1,15,1);
REPLACE INTO `CraftedItem` (`Id_nb`,`CraftedItemID`,`CraftingLevel`,`CraftingSkillType`,`MakeTemplated`)
	VALUES ('effulgent_dreaded_seal',4897,1,15,1);
REPLACE INTO `CraftedItem` (`Id_nb`,`CraftedItemID`,`CraftingLevel`,`CraftingSkillType`,`MakeTemplated`)
	VALUES ('lambent_dreaded_seal',11834,1,15,1);
REPLACE INTO `CraftedItem` (`Id_nb`,`CraftedItemID`,`CraftingLevel`,`CraftingSkillType`,`MakeTemplated`)
	VALUES ('lambent_dreaded_seal2',11835,1,15,1);
REPLACE INTO `CraftedItem` (`Id_nb`,`CraftedItemID`,`CraftingLevel`,`CraftingSkillType`,`MakeTemplated`)
	VALUES ('fulgent_dreaded_seal',11836,1,15,1);
REPLACE INTO `CraftedItem` (`Id_nb`,`CraftedItemID`,`CraftingLevel`,`CraftingSkillType`,`MakeTemplated`)
	VALUES ('effulgent_dreaded_seal',11837,1,15,1);
REPLACE INTO `CraftedItem` (`Id_nb`,`CraftedItemID`,`CraftingLevel`,`CraftingSkillType`,`MakeTemplated`)
	VALUES ('lambent_dreaded_seal',16564,1,15,1);
REPLACE INTO `CraftedItem` (`Id_nb`,`CraftedItemID`,`CraftingLevel`,`CraftingSkillType`,`MakeTemplated`)
	VALUES ('lambent_dreaded_seal2',16565,1,15,1);
REPLACE INTO `CraftedItem` (`Id_nb`,`CraftedItemID`,`CraftingLevel`,`CraftingSkillType`,`MakeTemplated`)
	VALUES ('fulgent_dreaded_seal',16566,1,15,1);
REPLACE INTO `CraftedItem` (`Id_nb`,`CraftedItemID`,`CraftingLevel`,`CraftingSkillType`,`MakeTemplated`)
	VALUES ('effulgent_dreaded_seal',16567,1,15,1);

# Add crafting recipes to CraftedXItem
REPLACE INTO `CraftedXItem` (`CraftedItemId_nb`,`IngredientId_nb`,`Count`,`CraftedXItem_ID`)
	VALUES ('lambent_dreaded_seal','glowing_dreaded_seal',10,'craft_lambent_dreaded_seal');
REPLACE INTO `CraftedXItem` (`CraftedItemId_nb`,`IngredientId_nb`,`Count`,`CraftedXItem_ID`)
	VALUES ('lambent_dreaded_seal2','sanguine_dreaded_seal',10,'craft_sanguine_dreaded_seal');
REPLACE INTO `CraftedXItem` (`CraftedItemId_nb`,`IngredientId_nb`,`Count`,`CraftedXItem_ID`)
	VALUES ('fulgent_dreaded_seal','lambent_dreaded_seal2',5,'craft_fulgent_dreaded_seal');	
REPLACE INTO `CraftedXItem` (`CraftedItemId_nb`,`IngredientId_nb`,`Count`,`CraftedXItem_ID`)
	VALUES ('effulgent_dreaded_seal','fulgent_dreaded_seal',10,'craft_effulgent_dreaded_seal');	

# Add Dreaded Seals to Loot Generator
REPLACE INTO `LootGenerator` (`RegionID`,`LootGeneratorClass`,`LootGenerator_ID`)
	VALUES
	('1','DOL.GS.Scripts.LootGeneratorGaherisSeals','dreadedseals_of_albion'),
	('100','DOL.GS.Scripts.LootGeneratorGaherisSeals','dreadedseals_of_midgard'),
	('200','DOL.GS.Scripts.LootGeneratorGaherisSeals','dreadedseals_of_hibernia'),
	('249','DOL.GS.Scripts.LootGeneratorGaherisSeals','dreadedseals_darkness_falls'),
	('245','DOL.GS.Scripts.LootGeneratorGaherisSeals','dreadedseals_labyrinth');
	
# Added Dreaded Seals to Loot Templates
REPLACE INTO `LootTemplate` (`TemplateName`,`ItemTemplateId`,`Chance`,`COUNT`,`LootTemplate_ID`)
VALUES
('Cuuldurach the Glimmer King','sanguine_dreaded_seal',100,10,'Cuuldurach the Glimmer King_sanguine_dreaded_seal'),
('Gjalpinulva','sanguine_dreaded_seal',100,10,'Gjalpinulva_sanguine_dreaded_seal'),
('Golestandt','sanguine_dreaded_seal',100,10,'Golestandt_sanguine_dreaded_seal'),
('Apocalypse','sanguine_dreaded_seal',100,10,'Apocalypse_sanguine_dreaded_seal'),
('King Tuscar','sanguine_dreaded_seal',100,10,'King Tuscar_sanguine_dreaded_seal'),
('Olcasgean','sanguine_dreaded_seal',100,10,'Olcasgean_sanguine_dreaded_seal');
