-- Keep hook points: the anchor slots on a keep wall where siege equipment,
-- boiling oil and the like attach. Keyed by KeepComponentSkinID, so they are
-- inert until keep components exist, which is migration 33. We had none.
--
-- Reversible in one line: DELETE FROM keephookpoint;

INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 33, 0, 665, -473, 12, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 129, 0, 374, -353, 373, -58, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 0, 564, -285, 365, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 1, 199, -135, 332, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 1, 297, -22, 332, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 1, 13, -115, 332, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 1, -11, -208, 332, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 1, 266, -113, 332, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 65, 1, 219, -208, 344, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 1, 69, -235, 349, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 1, 125, -160, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 11, 1, -11, -208, 339, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 1, 125, -160, 339, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 0, 191, -285, 365, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 1, 266, -113, 339, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 1, 53, -176, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 1, 199, -135, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 1, 297, -22, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 1, 13, -115, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 1, -11, -208, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 1, 266, -113, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 65, 1, 213, -190, 603, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 1, 69, -235, 603, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 1, 125, -160, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 36, 0, 778, 169, 12, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 11, 1, -11, -208, 339, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 1, 125, -160, 339, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 1, 266, -113, 339, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 1, 53, -176, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 1, 199, -135, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 1, 297, -22, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 1, 13, -115, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 1, -11, -208, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 1, 266, -113, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 65, 1, 213, -190, 603, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 35, 0, -72, 142, 12, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 1, 69, -235, 603, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 2, 176, -160, 337, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 65, 2, 227, -235, 347, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 2, 248, -176, 337, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 2, 102, -135, 337, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 2, 4, -22, 337, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 2, 288, -116, 337, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 2, 313, -208, 337, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 2, 35, -114, 337, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 2, 88, -190, 347, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 34, 0, 89, -448, 12, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 2, 176, -160, 336, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 11, 2, 313, -208, 92, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 2, 176, -160, 92, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 2, 35, -113, 92, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 2, 248, -176, 336, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 2, 102, -135, 336, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 2, 4, -22, 336, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 2, 288, -115, 336, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 2, 313, -208, 336, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 2, 35, -113, 336, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 33, 0, 665, -473, 12, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 2, 88, -190, 346, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 65, 2, 231, -235, 345, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 2, 176, -160, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 11, 2, 313, -208, 339, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 2, 176, -160, 339, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 2, 35, -113, 339, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 2, 248, -176, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 2, 102, -135, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 2, 4, -22, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 2, 288, -115, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 129, 0, 374, -353, 388, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 2, 313, -208, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 2, 35, -113, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 2, 88, -190, 603, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 65, 2, 231, -235, 600, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 2, 176, -160, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 11, 2, 313, -208, 339, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 2, 176, -160, 339, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 2, 35, -113, 339, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 2, 248, -176, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 2, 102, -135, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 15, 0, 109, -290, 101, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 2, 4, -22, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 2, 288, -115, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 2, 313, -208, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 2, 35, -113, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 2, 88, -190, 603, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 65, 2, 231, -235, 600, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 129, 11, 503, -200, 455, -2018, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 11, 241, -900, 703, -3064, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 11, 566, -1112, 703, -29, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 11, 436, -602, 702, -2099, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 14, 0, 638, -290, 101, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 11, 766, -790, 702, -1056, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 11, 315, -1243, 446, 91, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 11, 673, -1243, 446, 18, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 11, 677, -237, 446, -2075, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 11, 319, -237, 446, -1975, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 34, 11, 833, -886, 83, 942, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 33, 11, 525, -837, 83, -2154, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 97, 11, 493, -853, 713, -1999, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 33, 11, 492, -869, 83, -1974, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 129, 11, 503, -200, 455, -1950, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 13, 0, 109, -8, 373, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 97, 11, 493, -853, 940, -2082, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 11, 523, -729, 693, 976, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 11, 703, -951, 467, -3050, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 11, 241, -900, 931, 987, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 11, 566, -1112, 931, 156, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 11, 436, -602, 931, -2080, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 11, 766, -790, 930, -1051, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 11, 315, -1243, 446, -15, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 11, 673, -1243, 446, 66, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 11, 677, -237, 446, -1890, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 0, 109, -290, 95, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 12, 0, 368, -10, 378, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 11, 319, -237, 446, -1931, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 34, 11, 833, -886, 83, -2998, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 129, 11, 503, -200, 595, -1936, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 97, 11, 493, -853, 1081, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 11, 722, -557, 829, 943, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 11, 956, -697, 595, -2028, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 11, 241, -900, 1077, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 11, 566, -1112, 1077, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 11, 436, -602, 1076, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 11, 766, -790, 1076, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 11, 0, 638, -8, 373, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 11, 315, -1243, 592, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 11, 673, -1243, 592, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 11, 677, -237, 592, -1964, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 11, 319, -237, 592, -2032, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 34, 11, 833, -886, 83, -3071, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 33, 11, 498, -889, 83, -2069, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 129, 11, 503, -200, 595, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 11, 11, 523, -729, 1071, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 11, 523, -729, 842, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 11, 703, -951, 616, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 0, 109, -290, 373, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 11, 241, -900, 1309, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 11, 566, -1112, 1309, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 11, 436, -602, 1308, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 11, 766, -790, 1308, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 11, 315, -1243, 596, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 11, 673, -1243, 596, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 11, 677, -237, 596, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 11, 319, -237, 596, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 97, 11, 493, -853, 1317, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 34, 11, 833, -886, 83, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 0, 638, -290, 373, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 33, 11, 483, -837, 83, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 0, 3, 0, 0, 0, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 3, -24, -219, 334, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 3, 160, -110, 334, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 3, 109, -161, 334, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 3, 177, -34, 334, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 3, 121, 2, 334, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 3, -3, -126, 334, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 3, 37, -179, 334, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 3, 223, 26, 334, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 0, 112, 17, 583, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 65, 3, 236, -51, 344, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 3, 58, -222, 350, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 3, -24, -219, 332, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 13, 3, 158, -102, 91, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 12, 3, -23, -212, 91, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 11, 3, 105, -153, 91, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 3, 223, 26, 91, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 3, 160, -110, 332, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 3, 109, -161, 332, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 3, 177, -34, 332, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 0, 643, 17, 583, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 3, 121, 2, 332, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 3, -3, -126, 332, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 3, 37, -179, 332, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 3, 223, 26, 332, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 65, 3, 245, -60, 344, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 3, 58, -222, 349, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 3, -24, -219, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 13, 3, 158, -102, 339, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 12, 3, -23, -212, 339, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 11, 3, 105, -153, 339, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 0, 778, -225, 631, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 3, 223, 26, 339, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 3, 160, -110, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 3, 109, -161, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 3, 177, -34, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 3, 121, 2, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 3, -3, -126, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 3, 37, -179, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 3, 223, 26, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 65, 3, 243, -58, 601, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 3, 58, -222, 603, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 0, -22, -225, 631, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 3, -24, -219, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 13, 3, 158, -102, 339, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 12, 3, -23, -212, 339, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 11, 3, 105, -153, 339, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 3, 223, 26, 339, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 3, 160, -110, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 3, 109, -161, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 3, 177, -34, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 3, 121, 2, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 3, -3, -126, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 0, 102, -324, 631, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 3, 37, -179, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 3, 223, 26, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 65, 3, 243, -58, 601, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 3, 58, -222, 603, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 4, 82, -370, 403, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 97, 4, 224, -225, 399, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 13, 4, 340, -331, 403, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 12, 4, 85, -81, 397, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 11, 4, 94, -299, 396, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 4, 374, -369, 403, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 0, 654, -324, 631, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 4, 93, -232, 396, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 4, 224, -352, 396, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 4, 309, -369, 390, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 4, 94, -141, 390, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 4, 53, -222, 404, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 4, 222, -401, 402, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 4, 147, -365, 396, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 4, 57, -272, 396, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 0, 4, 0, 0, 0, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 4, 82, -370, 647, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 0, 638, -290, 95, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 0, 564, -285, 631, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 97, 4, 224, -225, 643, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 15, 4, 222, -355, 346, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 14, 4, 98, -222, 348, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 13, 4, 340, -331, 647, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 12, 4, 85, -81, 641, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 11, 4, 94, -299, 640, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 4, 374, -369, 647, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 4, 93, -232, 640, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 4, 224, -352, 640, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 4, 309, -369, 634, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 0, 191, -285, 631, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 4, 94, -141, 634, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 4, 53, -222, 648, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 4, 222, -401, 646, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 4, 147, -365, 640, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 4, 57, -272, 640, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 4, 82, -370, 883, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 97, 4, 224, -225, 879, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 19, 4, 98, -222, 93, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 18, 4, 222, -355, 91, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 17, 4, 222, -355, 347, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 36, 0, 778, 169, 12, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 16, 4, 98, -222, 349, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 15, 4, 222, -355, 613, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 14, 4, 98, -222, 615, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 13, 4, 340, -331, 884, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 12, 4, 85, -81, 877, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 11, 4, 94, -299, 876, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 4, 374, -369, 884, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 4, 93, -232, 876, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 4, 224, -352, 876, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 4, 309, -369, 870, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 35, 0, -72, 142, 12, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 4, 94, -141, 870, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 4, 53, -222, 884, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 4, 222, -401, 882, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 4, 147, -365, 876, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 4, 57, -272, 876, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 4, 82, -370, 883, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 97, 4, 224, -225, 879, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 19, 4, 98, -222, 93, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 18, 4, 222, -355, 91, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 17, 4, 222, -355, 347, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 34, 0, 89, -448, 12, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 16, 4, 98, -222, 349, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 15, 4, 222, -355, 613, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 14, 4, 98, -222, 615, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 13, 4, 340, -331, 884, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 12, 4, 85, -81, 877, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 11, 4, 94, -299, 876, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 4, 374, -369, 884, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 4, 93, -232, 876, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 4, 224, -352, 876, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 4, 309, -369, 870, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 33, 0, 665, -473, 12, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 4, 94, -141, 870, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 4, 53, -222, 884, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 4, 222, -401, 882, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 4, 147, -365, 876, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 4, 57, -272, 876, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 19, 153, -87, 332, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 19, 80, -73, 332, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 19, 223, -71, 332, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 19, 259, 0, 333, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 19, 44, -2, 333, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 130, 0, 374, -182, 322, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 19, 8, -92, 331, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 19, 302, -84, 332, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 65, 19, 223, -129, 343, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 19, 78, -142, 347, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 5, 216, -218, 331, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 14, 5, 149, -46, 333, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 13, 5, 22, -153, 333, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 12, 5, 196, -4, 333, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 11, 5, -3, -205, 333, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 5, 145, -198, 332, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 129, 0, 374, -353, 623, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 5, 177, -155, 332, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 5, 72, -202, 333, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 5, 198, -76, 333, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 5, 244, -1, 333, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 5, 0, -252, 333, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 5, 74, -273, 346, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 65, 5, 273, -73, 344, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 5, 237, -153, 333, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 5, 147, -252, 333, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 5, 216, -206, 333, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 19, 0, 109, -290, 100, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 19, 5, 242, -142, 91, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 18, 5, 152, -244, 91, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 17, 5, 0, -232, 91, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 16, 5, 209, -201, 91, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 15, 5, 230, 3, 91, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 14, 5, 149, -34, 333, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 13, 5, 22, -141, 333, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 12, 5, 196, 7, 333, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 11, 5, -3, -193, 333, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 5, 145, -186, 333, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 18, 0, 638, -290, 100, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 5, 177, -143, 333, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 5, 72, -190, 333, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 5, 198, -65, 333, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 5, 244, 9, 333, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 5, 0, -241, 333, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 5, 74, -273, 342, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 65, 5, 303, -70, 345, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 5, 237, -142, 333, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 5, 147, -241, 333, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 5, 216, -212, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 0, 112, 17, 316, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 17, 0, 109, -8, 345, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 19, 5, 242, -148, 333, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 18, 5, 152, -250, 333, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 17, 5, 0, -238, 333, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 16, 5, 209, -207, 333, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 15, 5, 230, -2, 333, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 14, 5, 149, -40, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 13, 5, 22, -147, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 12, 5, 196, 1, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 11, 5, -3, -199, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 5, 145, -192, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 16, 0, 638, -8, 345, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 5, 177, -149, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 5, 72, -196, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 5, 198, -71, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 5, 244, 3, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 5, 0, -247, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 5, 74, -279, 596, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 65, 5, 291, -76, 601, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 5, 237, -148, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 5, 147, -247, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 5, 216, -212, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 15, 0, 109, -290, 336, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 19, 5, 242, -148, 333, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 18, 5, 152, -250, 333, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 17, 5, 0, -238, 333, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 16, 5, 209, -207, 333, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 15, 5, 230, -2, 333, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 14, 5, 149, -40, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 13, 5, 22, -147, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 12, 5, 196, 1, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 11, 5, -3, -199, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 5, 145, -192, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 14, 0, 638, -290, 336, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 5, 177, -149, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 5, 72, -196, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 5, 198, -71, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 5, 244, 3, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 5, 0, -247, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 5, 74, -279, 596, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 65, 5, 291, -76, 601, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 5, 237, -148, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 5, 147, -247, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 6, 160, -164, 332, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 13, 0, 109, -8, 608, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 11, 6, 238, -102, 332, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 6, 105, -247, 332, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 6, 175, -73, 344, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 6, 72, -178, 345, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 6, 304, -130, 332, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 6, 129, -305, 332, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 6, 302, -5, 332, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 6, 4, -228, 332, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 6, 229, -3, 332, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 6, 146, -149, 333, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 12, 0, 368, -10, 613, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 14, 6, -14, -212, 90, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 13, 6, 210, 16, 90, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 12, 6, 152, -154, 90, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 11, 6, 224, -87, 333, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 6, 90, -232, 333, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 6, 173, -63, 351, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 6, 64, -165, 344, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 6, 290, -115, 333, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 6, 114, -290, 333, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 6, 287, 9, 342, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 11, 0, 638, -8, 608, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 6, -14, -285, 338, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 6, -10, -213, 333, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 6, 215, 11, 333, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 6, 146, -149, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 14, 6, -14, -212, 333, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 13, 6, 210, 16, 333, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 12, 6, 152, -154, 333, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 11, 6, 224, -87, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 6, 90, -232, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 6, 173, -63, 605, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 0, 109, -290, 608, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 6, 64, -165, 598, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 6, 290, -115, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 6, 114, -290, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 6, 287, 9, 596, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 6, -14, -285, 592, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 6, -10, -213, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 6, 215, 11, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 6, 146, -149, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 14, 6, -14, -212, 333, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 13, 6, 210, 16, 333, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 0, 638, -290, 608, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 12, 6, 152, -154, 333, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 11, 6, 224, -87, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 6, 90, -232, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 6, 173, -63, 605, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 6, 64, -165, 598, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 6, 290, -115, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 6, 114, -290, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 6, 287, 9, 596, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 6, -14, -285, 592, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 6, -10, -213, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 0, 112, 17, 818, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 6, 215, 11, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 7, 147, -389, 390, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 97, 7, 147, -221, 401, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 7, 152, -343, 79, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 7, 11, -294, 385, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 7, 285, -294, 385, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 7, 282, -359, 385, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 7, 14, -355, 385, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 7, 58, -327, 390, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 7, 231, -327, 390, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 0, 643, 17, 316, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 0, 643, 17, 818, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 7, 62, -372, 390, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 7, 231, -369, 390, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 7, 145, -371, 649, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 97, 7, 148, -217, 647, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 14, 7, 150, -325, 79, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 13, 7, 150, -49, 640, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 12, 7, 157, -58, 350, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 11, 7, 150, -325, 350, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 7, 12, -273, 644, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 7, 279, -276, 648, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 0, 778, -225, 866, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 7, 280, -342, 648, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 7, 14, -335, 644, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 7, 58, -309, 648, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 7, 230, -311, 649, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 7, 60, -353, 644, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 7, 230, -353, 649, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 14, 7, 152, -343, 80, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 97, 7, 147, -221, 885, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 13, 7, 147, -67, 874, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 12, 7, 152, -76, 586, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 0, -22, -225, 866, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 11, 7, 152, -343, 330, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 7, 152, -343, 567, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 7, 11, -294, 872, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 7, 285, -294, 872, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 7, 282, -359, 872, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 7, 14, -355, 872, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 7, 58, -327, 878, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 7, 231, -327, 878, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 7, 62, -372, 878, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 7, 231, -369, 878, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 0, 102, -324, 866, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 7, 147, -389, 878, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 7, 147, -389, 878, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 97, 7, 147, -221, 885, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 14, 7, 152, -343, 80, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 13, 7, 147, -67, 874, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 12, 7, 152, -76, 586, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 11, 7, 152, -343, 330, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 7, 152, -343, 567, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 7, 11, -294, 872, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 7, 285, -294, 872, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 0, 654, -324, 866, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 7, 282, -359, 872, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 7, 14, -355, 872, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 7, 58, -327, 878, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 7, 231, -327, 878, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 7, 62, -372, 878, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 7, 231, -369, 878, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 8, 80, -81, 333, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 8, 33, -206, 344, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 8, 50, -134, 333, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 8, 137, -43, 333, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 0, 564, -285, 866, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 8, 116, 32, 333, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 8, -42, -116, 333, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 8, -31, -194, 333, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 8, 193, 31, 333, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 8, 206, -32, 344, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 8, 114, -113, 344, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 8, 80, -81, 344, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 14, 8, 200, 42, 90, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 13, 8, -38, -199, 90, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 12, 8, 43, -129, 90, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 0, 191, -285, 866, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 11, 8, 121, -36, 90, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 8, 33, -206, 353, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 8, 50, -134, 344, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 8, 137, -43, 344, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 8, 116, 32, 344, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 8, -42, -116, 344, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 8, -31, -194, 344, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 8, 193, 31, 344, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 8, 206, -32, 352, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 8, 120, -123, 353, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 36, 0, 778, 169, 12, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 8, 80, -81, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 14, 8, 200, 42, 333, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 13, 8, -38, -199, 333, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 12, 8, 43, -129, 333, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 11, 8, 121, -36, 333, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 8, 33, -206, 601, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 8, 50, -134, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 8, 137, -43, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 8, 116, 32, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 8, -42, -116, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 35, 0, -72, 142, 12, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 8, -31, -194, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 8, 193, 31, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 8, 206, -32, 600, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 8, 120, -123, 601, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 8, 80, -81, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 14, 8, 200, 42, 333, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 13, 8, -38, -199, 333, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 12, 8, 43, -129, 333, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 11, 8, 121, -36, 333, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 8, 33, -206, 601, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 34, 0, 89, -448, 12, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 8, 50, -134, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 8, 137, -43, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 8, 116, 32, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 8, -42, -116, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 8, -31, -194, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 8, 193, 31, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 8, 206, -32, 600, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 8, 120, -123, 601, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 33, 10, 956, -844, 102, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 130, 10, 976, -706, 541, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 0, 778, -225, 365, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 33, 0, 665, -473, 12, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 129, 10, 976, -268, 541, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 97, 10, 424, -483, 852, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 36, 10, 972, -135, 102, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 35, 10, 168, -216, 93, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 34, 10, 181, -754, 93, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 33, 10, 956, -844, 104, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 97, 10, 424, -483, 847, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 130, 10, 976, -706, 543, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 129, 10, 976, -268, 543, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 36, 10, 972, -135, 104, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 130, 0, 374, -182, 322, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 35, 10, 168, -216, 95, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 34, 10, 181, -754, 95, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 33, 10, 956, -844, 104, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 97, 10, 424, -483, 1117, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 130, 10, 976, -706, 543, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 129, 10, 976, -268, 543, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 36, 10, 972, -135, 104, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 35, 10, 168, -216, 95, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 34, 10, 181, -754, 95, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 33, 10, 956, -844, 104, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 129, 0, 374, -353, 623, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 97, 10, 424, -483, 1357, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 130, 10, 976, -706, 543, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 129, 10, 976, -268, 543, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 36, 10, 972, -135, 104, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 35, 10, 168, -216, 95, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 34, 10, 181, -754, 95, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 9, 153, -87, 332, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 9, 80, -73, 332, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 9, 223, -71, 332, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 9, 259, 0, 333, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 19, 0, 109, -290, 100, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 9, 44, -2, 333, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 9, 8, -92, 331, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 9, 302, -84, 332, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 65, 9, 223, -129, 343, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 9, 78, -142, 347, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 9, 302, -84, 88, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 65, 9, 223, -129, 343, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 9, 80, -73, 332, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 9, 223, -71, 332, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 9, 259, 0, 333, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 18, 0, 638, -290, 100, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 9, 44, -2, 333, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 9, 8, -92, 331, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 9, 302, -84, 332, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 9, 78, -142, 347, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 9, 153, -87, 332, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 11, 9, 8, -92, 88, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 9, 153, -87, 88, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 9, 153, -87, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 11, 9, 8, -92, 339, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 9, 153, -87, 339, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 17, 0, 109, -8, 345, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 9, 302, -84, 339, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 9, 80, -81, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 9, 231, -85, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 9, 259, 0, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 9, 44, -2, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 9, 8, -92, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 9, 302, -84, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 65, 9, 228, -142, 603, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 9, 78, -142, 603, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 9, 153, -87, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 16, 0, 638, -8, 345, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 11, 9, 8, -92, 339, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 9, 153, -87, 339, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 9, 302, -84, 339, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 9, 80, -81, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 9, 231, -85, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 9, 259, 0, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 9, 44, -2, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 9, 8, -92, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 9, 302, -84, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 65, 9, 228, -142, 603, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 15, 0, 109, -290, 336, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 9, 78, -142, 603, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 13, 153, -87, 335, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 13, 80, -81, 335, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 13, 231, -85, 335, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 13, 259, 0, 335, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 13, 44, -2, 335, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 13, 8, -92, 335, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 13, 302, -84, 335, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 65, 13, 228, -142, 351, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 13, 78, -142, 351, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 14, 0, 638, -290, 336, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 13, 153, -87, 332, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 11, 13, 8, -92, 89, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 13, 153, -87, 89, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 13, 302, -84, 89, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 13, 80, -81, 332, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 13, 231, -85, 332, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 13, 259, 0, 332, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 13, 44, -2, 332, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 13, 8, -92, 332, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 13, 302, -84, 332, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 13, 0, 109, -8, 608, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 65, 13, 228, -142, 349, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 13, 78, -142, 349, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 13, 153, -87, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 13, 78, -142, 603, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 13, 228, -142, 603, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 13, 302, -84, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 13, 8, -92, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 13, 44, -2, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 13, 259, 0, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 13, 231, -85, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 0, -22, -225, 365, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 12, 0, 368, -10, 613, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 13, 80, -81, 587, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 13, 302, -84, 339, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 11, 13, 153, -87, 339, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 12, 13, 8, -92, 339, 0, 2, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 13, 153, -87, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 11, 13, 8, -92, 339, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 13, 153, -87, 339, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 13, 302, -84, 339, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 13, 80, -81, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 13, 231, -85, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 11, 0, 638, -8, 608, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 13, 259, 0, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 13, 44, -2, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 13, 8, -92, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 13, 302, -84, 587, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 65, 13, 228, -152, 600, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 13, 78, -142, 603, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 0, 20, 0, 0, 0, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 20, 153, -87, 587, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 11, 20, 8, -92, 339, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 20, 153, -87, 339, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 0, 109, -290, 608, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 20, 302, -84, 339, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 20, 80, -81, 587, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 20, 231, -85, 587, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 20, 259, 0, 587, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 20, 44, -2, 587, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 20, 8, -92, 587, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 20, 302, -84, 587, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 65, 20, 228, -142, 603, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 20, 78, -142, 603, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 0, 638, -290, 608, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 0, 112, 17, 818, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 0, 643, 17, 818, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 0, 778, -225, 866, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 0, -22, -225, 866, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 0, 102, -324, 866, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 0, 654, -324, 866, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 0, 102, -324, 365, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 0, 564, -285, 866, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 0, 191, -285, 866, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 36, 0, 778, 169, 12, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 35, 0, -72, 142, 12, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 34, 0, 89, -448, 12, 0, 3, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 1, 125, -160, 333, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 1, 53, -176, 333, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 7, 1, 199, -135, 333, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 6, 1, 297, -22, 333, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 5, 1, 13, -115, 333, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 0, 654, -324, 365, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 4, 1, -11, -208, 333, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 3, 1, 266, -113, 333, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 65, 1, 222, -187, 349, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 2, 1, 69, -235, 349, 0, 0, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 1, 1, 125, -160, 332, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 12, 1, 151, -66, 332, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 11, 1, -11, -208, 90, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 10, 1, 125, -160, 90, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 9, 1, 266, -113, 90, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
INSERT INTO keephookpoint (KeepHookPoint_ID, HookPointID, KeepComponentSkinID, X, Y, Z, Heading, Height, LastTimeRowUpdated) VALUES (UUID(), 8, 1, 53, -176, 332, 0, 1, '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepHookPoint_ID` = `KeepHookPoint_ID`;
