-- Battleground keep structures.
--
-- Our battleground keeps were rows in the keep table and nothing else: no
-- components, so no walls, no doors, no lord, and no garrison raised from the
-- architecture. Regions 236, 237, 239, 240, 242, 251 and 253 had no guards of
-- any kind.
--
-- Scoped by KeepID collision, which is the trap here. A component names a
-- KeepID and nothing else, so it attaches to whatever keep holds that ID in
-- THIS database, not the one it came from. Twenty-one IDs mean different
-- things in the two: 50-56, 75-81 and 100-106 are New Frontiers keeps in the
-- dump and our own old-frontier keeps in regions 1, 100 and 200. Importing on
-- the dump's word alone bolts 798 New Frontiers components onto Albion,
-- Midgard and Hibernia. Only IDs that agree on region, or that we do not have
-- at all, are used below.
--
-- That is not a flaw in the dump. Old and New Frontiers deliberately share one
-- KeepID space: a server runs one or the other and never holds both, so the
-- same IDs describe Castle Sauvage here and a New Frontiers keep there. We run
-- old frontiers, so the old-frontier meaning of 50-56, 75-81 and 100-106 is
-- the correct one and the New Frontiers rows are simply not ours to load.
-- Region 163 stays empty; importing it would mean choosing the other frontier.
--
-- The dump has no keeps for regions 1, 100 or 200 in any case, so our mainland
-- keeps -- and the null Component problem that has bitten us four times -- are
-- not addressed by this data at all.
--
-- One thing to watch on the first boot. GameKeepComponent.LoadPositions
-- filters battleground positions down to doors only, but that filter is
-- guarded by ServerType != GST_PvE and we run PvE, so it does not apply:
-- these components will raise their own guards from the position templates
-- alongside the mob rows we placed by hand.
--
-- Reversible: we had zero components, so DELETE FROM keepcomponent; undoes
-- every structure, and the keep rows below are only IDs we did not have.

INSERT INTO keep (Keep_ID, KeepID, Name, Region, X, Y, Z, Heading, Realm, Level, ClaimedGuildName, AlbionDifficultyLevel, MidgardDifficultyLevel, HiberniaDifficultyLevel, OriginalRealm, KeepType, BaseLevel, SkinType, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 125, 'Fort Brolorn', 234, 557056, 557056, 7808, 0, 3, 0, '', 1, 1, 1, 0, 8, 4, 0, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `Keep_ID` = `Keep_ID`;
INSERT INTO keep (Keep_ID, KeepID, Name, Region, X, Y, Z, Heading, Realm, Level, ClaimedGuildName, AlbionDifficultyLevel, MidgardDifficultyLevel, HiberniaDifficultyLevel, OriginalRealm, KeepType, BaseLevel, SkinType, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 126, 'Leonis Keep', 235, 556749, 556948, 7808, 0, 2, 0, '', 1, 1, 1, 0, 10, 9, 0, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `Keep_ID` = `Keep_ID`;
INSERT INTO keep (Keep_ID, KeepID, Name, Region, X, Y, Z, Heading, Realm, Level, ClaimedGuildName, AlbionDifficultyLevel, MidgardDifficultyLevel, HiberniaDifficultyLevel, OriginalRealm, KeepType, BaseLevel, SkinType, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 127, 'Caer Claret', 236, 556693, 556958, 8272, 0, 3, 0, '', 1, 1, 1, 0, 12, 14, 0, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `Keep_ID` = `Keep_ID`;
INSERT INTO keep (Keep_ID, KeepID, Name, Region, X, Y, Z, Heading, Realm, Level, ClaimedGuildName, AlbionDifficultyLevel, MidgardDifficultyLevel, HiberniaDifficultyLevel, OriginalRealm, KeepType, BaseLevel, SkinType, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 129, 'Thidranki Faste', 238, 549619, 554387, 4424, 345, 3, 0, '', 1, 1, 1, 0, 16, 24, 0, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `Keep_ID` = `Keep_ID`;
INSERT INTO keep (Keep_ID, KeepID, Name, Region, X, Y, Z, Heading, Realm, Level, ClaimedGuildName, AlbionDifficultyLevel, MidgardDifficultyLevel, HiberniaDifficultyLevel, OriginalRealm, KeepType, BaseLevel, SkinType, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 130, 'Dun Braemar', 239, 552389, 558136, 7272, 255, 3, 4, '', 1, 1, 1, 0, 18, 29, 0, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `Keep_ID` = `Keep_ID`;
INSERT INTO keep (Keep_ID, KeepID, Name, Region, X, Y, Z, Heading, Realm, Level, ClaimedGuildName, AlbionDifficultyLevel, MidgardDifficultyLevel, HiberniaDifficultyLevel, OriginalRealm, KeepType, BaseLevel, SkinType, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 131, 'Caer Wilton', 240, 553616, 557282, 7128, 180, 2, 4, '', 1, 1, 1, 0, 20, 34, 0, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `Keep_ID` = `Keep_ID`;
INSERT INTO keep (Keep_ID, KeepID, Name, Region, X, Y, Z, Heading, Realm, Level, ClaimedGuildName, AlbionDifficultyLevel, MidgardDifficultyLevel, HiberniaDifficultyLevel, OriginalRealm, KeepType, BaseLevel, SkinType, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 386, 'Albion Portal Keep', 239, 554386, 584643, 6952, 180, 1, 0, NULL, 1, 1, 1, 1, 0, 100, 0, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `Keep_ID` = `Keep_ID`;
INSERT INTO keep (Keep_ID, KeepID, Name, Region, X, Y, Z, Heading, Realm, Level, ClaimedGuildName, AlbionDifficultyLevel, MidgardDifficultyLevel, HiberniaDifficultyLevel, OriginalRealm, KeepType, BaseLevel, SkinType, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 642, 'Midgard Portal Keep', 239, 582092, 538427, 6776, 90, 2, 0, '', 1, 1, 1, 2, 0, 100, 0, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `Keep_ID` = `Keep_ID`;
INSERT INTO keep (Keep_ID, KeepID, Name, Region, X, Y, Z, Heading, Realm, Level, ClaimedGuildName, AlbionDifficultyLevel, MidgardDifficultyLevel, HiberniaDifficultyLevel, OriginalRealm, KeepType, BaseLevel, SkinType, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 898, 'Hibernia Portal Keep', 239, 533268, 533874, 6768, 300, 3, 0, NULL, 1, 1, 1, 3, 0, 100, 0, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `Keep_ID` = `Keep_ID`;
INSERT INTO keep (Keep_ID, KeepID, Name, Region, X, Y, Z, Heading, Realm, Level, ClaimedGuildName, AlbionDifficultyLevel, MidgardDifficultyLevel, HiberniaDifficultyLevel, OriginalRealm, KeepType, BaseLevel, SkinType, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1156, 'Molvik Albion Tower', 241, 546714, 549524, 5368, 90, 2, 4, '', 1, 1, 1, 1, 0, 39, 0, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `Keep_ID` = `Keep_ID`;
INSERT INTO keep (Keep_ID, KeepID, Name, Region, X, Y, Z, Heading, Realm, Level, ClaimedGuildName, AlbionDifficultyLevel, MidgardDifficultyLevel, HiberniaDifficultyLevel, OriginalRealm, KeepType, BaseLevel, SkinType, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1158, 'Midgard Leirvik Tower', 242, 282660, 294130, 10920, 2898, 2, 4, '', 1, 1, 1, 2, 0, 50, 0, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `Keep_ID` = `Keep_ID`;
INSERT INTO keep (Keep_ID, KeepID, Name, Region, X, Y, Z, Heading, Realm, Level, ClaimedGuildName, AlbionDifficultyLevel, MidgardDifficultyLevel, HiberniaDifficultyLevel, OriginalRealm, KeepType, BaseLevel, SkinType, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1412, 'Molvik Midgard Tower', 241, 554628, 564742, 5440, 15, 2, 4, '', 1, 1, 1, 2, 0, 39, 0, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `Keep_ID` = `Keep_ID`;
INSERT INTO keep (Keep_ID, KeepID, Name, Region, X, Y, Z, Heading, Realm, Level, ClaimedGuildName, AlbionDifficultyLevel, MidgardDifficultyLevel, HiberniaDifficultyLevel, OriginalRealm, KeepType, BaseLevel, SkinType, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1414, 'Albion Leirvik Tower', 242, 302305, 284920, 11136, 121, 2, 4, '', 1, 1, 1, 1, 0, 50, 0, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `Keep_ID` = `Keep_ID`;
INSERT INTO keep (Keep_ID, KeepID, Name, Region, X, Y, Z, Heading, Realm, Level, ClaimedGuildName, AlbionDifficultyLevel, MidgardDifficultyLevel, HiberniaDifficultyLevel, OriginalRealm, KeepType, BaseLevel, SkinType, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1668, 'Molvik Hibernian Tower', 241, 565590, 544849, 5368, 230, 2, 4, '', 1, 1, 1, 3, 0, 39, 0, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `Keep_ID` = `Keep_ID`;
INSERT INTO keep (Keep_ID, KeepID, Name, Region, X, Y, Z, Heading, Realm, Level, ClaimedGuildName, AlbionDifficultyLevel, MidgardDifficultyLevel, HiberniaDifficultyLevel, OriginalRealm, KeepType, BaseLevel, SkinType, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1670, 'Hibernia Leirvik Tower', 242, 295728, 307441, 11080, 1667, 2, 4, '', 1, 1, 1, 3, 0, 50, 0, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `Keep_ID` = `Keep_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 646, 4, 10, 2, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 13, 132, 10, 253, 253, 3, 31200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 130, 9, 4, 248, 0, 23200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 14, 894, 9, 253, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 643, 4, 247, 248, 0, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 16, 130, 2, 10, 0, 3, 23200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 390, 0, 254, 249, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 125, 2, 6, 0, 3, 3200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 16, 637, 9, 0, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 15, 644, 9, 3, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 646, 4, 247, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 902, 4, 7, 245, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 646, 7, 7, 252, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 19, 131, 9, 2, 8, 2, 27200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 18, 129, 9, 8, 9, 2, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 16, 386, 9, 0, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 639, 2, 4, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 897, 9, 8, 249, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 16, 381, 9, 0, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 13, 385, 9, 6, 3, 2, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 639, 7, 250, 254, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 132, 9, 249, 252, 1, 31200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 125, 3, 5, 255, 0, 3200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 898, 4, 7, 245, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 894, 0, 254, 249, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 12, 390, 4, 250, 5, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 12, 386, 4, 250, 5, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 383, 0, 254, 249, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 382, 7, 7, 252, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 16, 899, 9, 0, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 134, 7, 254, 247, 0, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 387, 4, 247, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 899, 9, 8, 249, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 12, 899, 4, 250, 5, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 637, 4, 247, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 13, 894, 9, 6, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 1156, 31, 253, 4, 0, 31200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 12, 637, 4, 250, 5, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 899, 0, 254, 249, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 893, 9, 249, 251, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 129, 9, 6, 250, 0, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 382, 9, 8, 255, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 894, 4, 247, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 132, 9, 4, 248, 0, 31200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 639, 9, 8, 249, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 18, 138, 9, 8, 9, 2, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 386, 4, 247, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 12, 202, 4, 7, -8, 3, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 13, 898, 9, 6, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 201, 5, -2, 1, 2, 80000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 13, 390, 9, 6, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 388, 9, 8, 255, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 381, 7, 250, 254, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 134, 9, 1, 246, 0, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 385, 9, 249, 251, 1, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 642, 4, 10, 2, 2, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 13, 895, 9, 6, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 388, 4, 7, 245, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 125, 6, 251, 6, 0, 3200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 15, 383, 9, 3, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 132, 0, 254, 249, 0, 31200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 201, 8, -2, -3, 1, 80000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 19, 129, 9, 252, 9, 2, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 14, 126, 9, 250, 2, 1, 7200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 390, 1, 251, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 385, 1, 251, 248, 0, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 382, 2, 4, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 641, 9, 249, 251, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 14, 134, 33, 7, 0, 0, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 130, 9, 0, 7, 2, 23200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 381, 4, 7, 245, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 129, 27, 7, -9, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 638, 9, 249, 251, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 1158, 11, 253, 4, 0, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 900, 4, 247, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 12, 131, 1, 7, 4, 3, 27200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 131, 9, 247, 0, 1, 27200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 138, 9, 6, 250, 0, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 382, 9, 8, 249, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 893, 7, 250, 254, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 382, 9, 249, 251, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 382, 0, 254, 249, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 902, 9, 8, 255, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 129, 9, 248, 4, 1, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 19, 130, 1, 6, 7, 2, 23200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 898, 9, 8, 249, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 131, 4, 245, 250, 0, 27200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 383, 2, 4, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 16, 641, 9, 0, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 12, 893, 4, 250, 5, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 390, 4, 247, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 12, 638, 4, 250, 5, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 134, 9, 248, 246, 0, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 639, 1, 251, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 900, 9, 249, 251, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 20, 129, 9, 2, 9, 2, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 12, 643, 4, 250, 5, 1, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 125, 3, 250, 3, 2, 3200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 388, 9, 249, 1, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 14, 902, 9, 253, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 390, 9, 249, 251, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 15, 387, 9, 3, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 902, 2, 4, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 900, 0, 254, 249, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 644, 4, 7, 245, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 19, 138, 9, 252, 9, 2, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 381, 9, 249, 251, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 14, 897, 9, 253, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 15, 900, 9, 3, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 22, 134, 4, 248, 7, 1, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 381, 9, 8, 249, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 387, 7, 250, 254, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 125, 6, 5, 6, 1, 3200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 13, 126, 5, 251, 3, 2, 7200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 131, 9, 249, 249, 0, 27200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 637, 4, 7, 245, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 14, 381, 9, 253, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 14, 387, 9, 253, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 16, 132, 4, 10, 9, 2, 31200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 138, 27, 7, -9, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 127, 24, -2, -2, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 388, 9, 8, 249, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 14, 900, 9, 253, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 643, 4, 10, 2, 2, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 12, 381, 4, 250, 5, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 12, 900, 4, 250, 5, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 138, 9, 248, 4, 1, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 14, 390, 9, 253, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 900, 9, 8, 249, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 13, 641, 9, 6, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 127, 21, 3, 5, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 125, 21, -6, 1, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 642, 4, 247, 248, 0, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 639, 9, 249, 251, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 14, 203, 5, -8, 1, 1, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 386, 4, 7, 245, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 19, 203, 2, -8, 7, 1, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 895, 7, 7, 252, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 646, 9, 8, 255, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 895, 9, 249, 251, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 20, 138, 9, 2, 9, 2, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 129, 9, 3, 250, 0, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 385, 4, 247, 248, 0, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 893, 9, 8, 255, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 13, 202, 9, 7, 3, 2, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 894, 9, 249, 251, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 127, 9, 5, 0, 3, 11200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 893, 4, 247, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 1412, 31, 253, 4, 0, 31200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 381, 9, 8, 255, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 385, 2, 4, 248, 0, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 13, 132, 21, 9, 0, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 12, 129, 9, 10, 5, 3, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 897, 1, 251, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 14, 643, 9, 253, 3, 2, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 387, 1, 251, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 21, 129, 10, 253, 5, 0, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 20, 132, 7, 3, 9, 2, 31200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 390, 2, 4, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 12, 126, 9, 254, 4, 2, 7200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 16, 643, 9, 0, 3, 2, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 639, 7, 7, 252, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 13, 644, 9, 6, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 132, 4, 247, 249, 0, 31200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 203, 9, 3, -7, 0, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 13, 130, 33, 3, 1, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 129, 21, 10, -2, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 129, 21, -5, -6, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 127, 9, 5, 253, 3, 11200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 127, 9, 0, 4, 2, 11200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 132, 9, 251, 248, 0, 31200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 642, 2, 4, 248, 0, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 12, 897, 4, 250, 5, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 13, 381, 9, 6, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 202, 1, 1, 2, 2, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 641, 7, 250, 254, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 14, 646, 9, 253, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 12, 134, 7, 247, 0, 1, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 383, 1, 251, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 14, 386, 9, 253, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 900, 7, 7, 252, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 641, 9, 8, 255, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 14, 131, 3, 249, 7, 2, 27200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 201, 7, 2, 7, 1, 80000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 898, 7, 7, 252, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 19, 134, 9, 255, 9, 2, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 900, 7, 250, 254, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 895, 1, 251, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 15, 381, 9, 3, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 138, 9, 3, 250, 0, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 14, 644, 9, 253, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 387, 9, 249, 1, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 382, 9, 249, 1, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 643, 7, 7, 252, 3, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 14, 642, 9, 253, 3, 2, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 639, 4, 10, 2, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 14, 893, 9, 253, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 12, 138, 9, 10, 5, 3, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 14, 132, 9, 8, 6, 3, 31200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 387, 9, 249, 251, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 20, 134, 9, 5, 9, 2, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 21, 138, 10, 253, 5, 0, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 641, 4, 7, 245, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 14, 130, 2, 8, 250, 3, 23200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 131, 24, 2, -4, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 138, 21, 10, -2, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 129, 21, -2, -6, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 138, 21, -5, -6, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 202, 8, 8, 2, 3, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 895, 9, 249, 1, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 646, 7, 250, 254, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 17, 131, 7, 5, 7, 2, 27200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 12, 895, 4, 250, 5, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 125, 3, 6, 3, 3, 3200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 131, 9, 247, 3, 1, 27200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 894, 9, 8, 249, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 641, 7, 7, 252, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 12, 644, 4, 250, 5, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 126, 5, 251, 249, 1, 7200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 15, 895, 9, 3, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 641, 1, 251, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 202, 7, 4, 2, 2, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 15, 203, 9, -5, -39, 2, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 125, 9, 255, 254, 0, 3200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 15, 639, 9, 3, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 202, 6, 0, -5, 3, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 13, 902, 9, 6, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 893, 0, 254, 249, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 646, 2, 4, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 894, 9, 249, 1, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 899, 2, 4, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 202, 9, -2, 2, 2, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 897, 7, 7, 252, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 14, 388, 9, 253, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 127, 27, -3, 8, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 130, 4, 7, 246, 3, 23200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 131, 9, 252, 249, 0, 27200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 15, 134, 6, 9, 7, 1, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 644, 4, 10, 2, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 644, 7, 7, 252, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 18, 130, 2, 253, 7, 2, 23200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 138, 21, -2, -6, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 202, 4, 0, -6, 0, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 899, 4, 7, 245, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 15, 637, 9, 3, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 134, 33, 4, 0, 0, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 382, 1, 251, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 899, 7, 7, 252, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 898, 2, 4, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 132, 7, 250, 2, 1, 31200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 126, 9, 6, 0, 3, 7200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 14, 639, 9, 253, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 637, 9, 8, 255, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 1670, 11, 253, 4, 0, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 387, 4, 7, 245, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 642, 7, 250, 254, 1, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 15, 201, 6, 5, -2, 2, 80000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 902, 7, 7, 252, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 126, 9, 250, 252, 1, 7200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 203, 3, -7, 8, 2, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 643, 4, 7, 245, 3, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 16, 893, 9, 0, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 21, 132, 7, 0, 9, 2, 31200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 893, 4, 7, 245, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 15, 132, 9, 249, 8, 1, 31200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 895, 2, 4, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 129, 4, 9, 248, 3, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 13, 134, 29, -5, -5, 0, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 638, 9, 8, 255, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 385, 7, 250, 254, 1, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 19, 132, 9, 6, 10, 2, 31200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 386, 4, 10, 2, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 134, 5, 10, 247, 0, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 902, 4, 10, 2, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 12, 902, 4, 250, 5, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 899, 7, 250, 254, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 16, 898, 9, 0, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 126, 5, 5, 249, 0, 7200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 897, 4, 7, 245, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 126, 25, 4, -2, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 126, 21, 0, 8, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 17, 132, 4, 250, 12, 1, 31200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 13, 893, 9, 6, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 131, 9, 9, 254, 3, 27200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 203, 9, -3, -7, 0, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 129, 9, 248, 1, 1, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 893, 2, 4, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 20, 130, 1, 250, 7, 2, 23200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 16, 203, 9, 2, 9, 2, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 12, 641, 4, 250, 5, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 390, 7, 250, 254, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 130, 27, -4, 12, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 646, 0, 254, 249, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 385, 9, 8, 255, 3, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 639, 9, 8, 255, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 12, 639, 4, 250, 5, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 16, 900, 9, 0, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 15, 386, 9, 3, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 390, 9, 8, 255, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 897, 4, 247, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 385, 9, 8, 249, 3, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 16, 383, 9, 0, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 12, 894, 4, 250, 5, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 17, 129, 9, 5, 9, 2, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 131, 21, 11, 3, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 126, 7, 251, 255, 1, 7200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 385, 4, 7, 245, 3, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 14, 382, 9, 253, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 201, 6, -1, 4, 0, 80000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 642, 9, 8, 249, 3, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 16, 897, 9, 0, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 387, 9, 8, 249, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 201, 5, 9, 8, 3, 80000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 16, 390, 9, 0, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 14, 385, 9, 253, 3, 2, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 131, 25, 8, 6, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 638, 7, 250, 254, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 900, 4, 10, 2, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 638, 0, 254, 249, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 639, 4, 7, 245, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 382, 7, 250, 254, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 899, 1, 251, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 897, 7, 250, 254, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 385, 4, 10, 2, 2, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 203, 4, 6, -9, 3, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 13, 897, 9, 6, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 131, 1, 8, 1, 3, 27200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 894, 7, 250, 254, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 138, 4, 9, 248, 3, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 127, 9, 252, 255, 1, 11200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 131, 9, 247, 253, 1, 27200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 386, 9, 8, 255, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 893, 9, 8, 249, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 130, 1, 249, 252, 1, 23200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 15, 129, 4, 12, 8, 2, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 127, 4, 4, 249, 3, 11200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 130, 21, -3, -7, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 134, 27, -15, -5, 0, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 134, 25, 10, -5, 0, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 894, 7, 7, 252, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 138, 9, 248, 1, 1, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 202, 4, -4, -9, 3, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 386, 7, 7, 252, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 638, 4, 247, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 381, 4, 10, 2, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 14, 641, 9, 253, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 125, 3, 251, 255, 1, 3200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 126, 9, 1, 4, 2, 7200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 17, 203, 9, -1, 9, 2, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 383, 4, 7, 245, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 201, 9, -3, 0, 1, 80000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 14, 202, 9, 9, -1, 3, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 643, 0, 254, 249, 0, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 132, 21, 3, -10, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 18, 203, 9, -4, 9, 2, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 14, 638, 9, 253, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 387, 9, 8, 255, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 15, 899, 9, 3, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 646, 9, 249, 1, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 17, 138, 9, 5, 9, 2, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 644, 0, 254, 249, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 898, 9, 8, 255, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 388, 1, 251, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 897, 9, 249, 251, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 132, 7, 7, 0, 3, 31200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 132, 9, 249, 255, 1, 31200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 130, 9, 246, 5, 1, 23200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 16, 646, 9, 0, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 21, 130, 10, 6, 253, 2, 23200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 12, 130, 1, 248, 255, 1, 23200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 383, 9, 8, 255, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 893, 1, 251, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 638, 4, 10, 2, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 129, 9, 10, 2, 3, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 127, 0, 254, 252, 0, 11200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 900, 1, 251, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 897, 9, 249, 1, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 134, 9, 246, 253, 1, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 15, 138, 4, 12, 8, 2, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 643, 9, 8, 255, 3, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 126, 1, 252, 249, 0, 7200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 126, 29, 4, -1, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 130, 28, -7, 5, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 16, 201, 9, 10, 2, 3, 80000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 641, 9, 8, 249, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 134, 9, 11, 1, 3, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 643, 2, 4, 248, 0, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 383, 9, 249, 251, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 900, 4, 7, 245, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 15, 898, 9, 3, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 638, 4, 7, 245, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 386, 7, 250, 254, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 644, 9, 249, 1, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 127, 21, 0, 5, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 902, 9, 8, 249, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 643, 1, 251, 248, 0, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 388, 4, 10, 2, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 12, 132, 9, 249, 5, 1, 31200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 385, 7, 7, 252, 3, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 12, 642, 4, 250, 5, 1, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 130, 4, 13, 6, 2, 23200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 641, 0, 254, 249, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 893, 7, 7, 252, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 646, 4, 7, 245, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 898, 4, 10, 2, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 1414, 11, 253, 4, 0, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 13, 387, 9, 6, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 386, 1, 251, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 201, 7, 9, 5, 3, 80000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 131, 0, 255, 250, 0, 27200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 385, 9, 249, 1, 1, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 902, 9, 249, 251, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 898, 7, 250, 254, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 13, 125, 9, 2, 254, 0, 3200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 388, 0, 254, 249, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 900, 2, 4, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 127, 4, 7, 3, 2, 11200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 381, 7, 7, 252, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 138, 9, 10, 2, 3, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 15, 638, 9, 3, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 900, 9, 249, 1, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 644, 9, 8, 255, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 15, 902, 9, 3, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 642, 4, 7, 245, 3, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 902, 1, 251, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 132, 21, -7, 5, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 134, 28, 13, 2, 3, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 16, 385, 9, 0, 3, 2, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 385, 0, 254, 249, 0, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 127, 4, 253, 6, 1, 11200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 639, 0, 254, 249, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 134, 32, -9, 1, 1, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 390, 4, 10, 2, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 201, 5, 2, 8, 2, 80000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 126, 9, 6, 250, 3, 7200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 15, 642, 9, 3, 3, 2, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 643, 9, 249, 1, 1, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 130, 9, 11, 3, 3, 23200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 127, 4, 250, 252, 0, 11200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 18, 131, 9, 255, 8, 2, 27200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 12, 385, 4, 250, 5, 1, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 642, 9, 8, 255, 3, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 895, 9, 8, 249, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 12, 646, 4, 250, 5, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 130, 9, 3, 7, 2, 23200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 894, 2, 4, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 16, 902, 9, 0, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 126, 9, 4, 4, 2, 7200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 13, 638, 9, 6, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 202, 4, -8, -6, 0, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 14, 637, 9, 253, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 387, 7, 7, 252, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 14, 125, 8, 254, 10, 2, 3200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 125, 25, -3, -2, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 126, 5, 5, 3, 3, 7200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 130, 0, 254, 249, 0, 23200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 16, 639, 9, 0, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 203, 7, 0, -6, 0, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 895, 4, 10, 2, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 639, 4, 247, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 641, 4, 247, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 388, 7, 7, 252, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 202, 2, 8, -4, 3, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 131, 9, 9, 251, 3, 27200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 15, 382, 9, 3, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 130, 4, 247, 249, 0, 23200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 14, 383, 9, 253, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 642, 1, 251, 248, 0, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 13, 643, 9, 6, 3, 2, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 381, 21, 6, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 381, 24, 254, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 381, 27, 7, 247, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 381, 23, 10, 254, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 381, 29, 3, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 381, 21, 251, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 381, 27, 244, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 381, 27, 13, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 381, 21, 4, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 381, 27, 250, 10, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 381, 21, 253, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 381, 23, 247, 3, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 382, 21, 6, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 382, 24, 254, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 382, 27, 7, 247, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 382, 23, 10, 254, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 382, 29, 3, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 382, 21, 251, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 382, 27, 244, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 382, 27, 13, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 382, 21, 4, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 382, 27, 250, 10, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 382, 21, 253, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 382, 23, 247, 3, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 383, 21, 6, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 383, 24, 254, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 383, 27, 7, 247, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 383, 23, 10, 254, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 383, 29, 3, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 383, 21, 251, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 383, 27, 244, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 383, 27, 13, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 383, 21, 4, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 383, 27, 250, 10, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 383, 21, 253, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 383, 23, 247, 3, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 201, 21, 6, 7, 2, 80000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 201, 24, 254, 253, 0, 80000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 201, 27, 7, 247, 3, 80000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 201, 23, 10, 254, 3, 80000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 201, 29, 3, 4, 2, 80000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 201, 21, 251, 250, 0, 80000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 201, 27, 244, 253, 0, 80000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 201, 27, 13, 4, 2, 80000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 201, 21, 4, 250, 0, 80000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 201, 27, 250, 10, 1, 80000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 201, 21, 253, 7, 2, 80000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 201, 23, 247, 3, 1, 80000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 385, 21, 6, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 385, 24, 254, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 385, 27, 7, 247, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 385, 23, 10, 254, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 385, 29, 3, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 385, 21, 251, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 385, 27, 244, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 385, 27, 13, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 385, 21, 4, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 385, 27, 250, 10, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 385, 21, 253, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 385, 23, 247, 3, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 386, 21, 6, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 386, 24, 254, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 386, 27, 7, 247, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 386, 23, 10, 254, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 386, 29, 3, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 386, 21, 251, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 386, 27, 244, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 386, 27, 13, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 386, 21, 4, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 386, 27, 250, 10, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 386, 21, 253, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 386, 23, 247, 3, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 387, 21, 6, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 387, 24, 254, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 387, 27, 7, 247, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 387, 23, 10, 254, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 387, 29, 3, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 387, 21, 251, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 387, 27, 244, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 387, 27, 13, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 387, 21, 4, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 387, 27, 250, 10, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 387, 21, 253, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 387, 23, 247, 3, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 388, 21, 6, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 388, 24, 254, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 388, 27, 7, 247, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 388, 23, 10, 254, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 388, 29, 3, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 388, 21, 251, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 388, 27, 244, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 388, 27, 13, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 388, 21, 4, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 388, 27, 250, 10, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 388, 21, 253, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 388, 23, 247, 3, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 390, 21, 6, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 390, 24, 254, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 390, 27, 7, 247, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 390, 23, 10, 254, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 390, 29, 3, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 390, 21, 251, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 390, 27, 244, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 390, 27, 13, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 390, 21, 4, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 390, 27, 250, 10, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 390, 21, 253, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 390, 23, 247, 3, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 386, 0, 254, 249, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 14, 201, 4, 9, -2, 3, 80000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 134, 9, 11, 254, 3, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 201, 5, 2, -3, 0, 80000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 646, 9, 249, 251, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 390, 9, 249, 1, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 24, 134, 10, 254, 252, 3, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 129, 9, 10, 255, 3, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 388, 7, 250, 254, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 203, 9, 7, -5, 3, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 134, 0, 4, 247, 0, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 132, 4, 7, 246, 3, 31200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 383, 4, 247, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 14, 134, 4, 13, 4, 2, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 17, 202, 1, 4, -6, 0, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 127, 9, 252, 2, 1, 11200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 16, 894, 9, 0, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 899, 9, 249, 251, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 644, 9, 8, 249, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 13, 134, 7, 10, 251, 3, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 203, 0, 6, -2, 3, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 895, 4, 247, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 897, 9, 8, 255, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 381, 9, 249, 1, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 899, 4, 247, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 642, 9, 249, 251, 1, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 203, 9, 7, 4, 3, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 14, 895, 9, 253, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 13, 130, 1, 247, 2, 1, 23200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 898, 0, 254, 249, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 638, 9, 249, 1, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 13, 642, 9, 6, 3, 2, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 125, 9, 253, 9, 1, 3200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 643, 9, 249, 251, 1, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 383, 4, 10, 2, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 14, 129, 4, 249, 11, 1, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 900, 9, 8, 255, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 12, 898, 4, 250, 5, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 638, 9, 8, 249, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 129, 9, 250, 250, 0, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 16, 134, 6, 249, 7, 0, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 899, 9, 8, 255, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 637, 7, 250, 254, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 902, 4, 247, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 893, 9, 249, 1, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 388, 4, 247, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 130, 27, 12, 6, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 134, 32, 10, -4, 3, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 126, 34, -2, -2, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 131, 23, 11, -3, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 127, 27, 10, 2, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 383, 7, 250, 254, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 13, 646, 9, 6, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 895, 0, 254, 249, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 18, 134, 21, 3, 8, 2, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 383, 9, 249, 1, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 898, 4, 247, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 383, 7, 7, 252, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 129, 24, 1, -3, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 138, 9, 10, 255, 3, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 13, 899, 9, 6, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 16, 131, 7, 252, 7, 2, 27200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 17, 134, 3, 6, 8, 3, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 127, 21, -6, 1, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 13, 382, 9, 6, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 638, 1, 251, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 13, 129, 9, 248, 7, 1, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 894, 4, 10, 2, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 130, 30, 5, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 386, 9, 249, 1, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 201, 7, -1, -3, 0, 80000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 127, 9, 3, 4, 2, 11200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 642, 0, 254, 249, 0, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 386, 2, 4, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 201, 9, 6, 0, 0, 80000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 132, 28, -1, 9, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 203, 9, -5, -3, 1, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 382, 4, 7, 245, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 134, 4, 244, 247, 0, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 383, 9, 8, 249, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 15, 390, 9, 3, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 641, 4, 10, 2, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 15, 385, 9, 3, 3, 2, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 14, 138, 4, 249, 11, 1, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 15, 646, 9, 3, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 382, 4, 10, 2, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 894, 9, 8, 255, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 138, 9, 250, 250, 0, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 203, 4, 9, 7, 2, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 637, 4, 10, 2, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 130, 21, 9, 3, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 130, 32, -4, 2, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 15, 134, 33, -8, 0, 0, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 12, 132, 21, -7, 2, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 131, 23, -4, -7, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 388, 2, 4, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 637, 9, 249, 251, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 129, 9, 10, 252, 3, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 390, 9, 8, 249, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 16, 638, 9, 0, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 202, 6, -1, -5, 2, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 126, 7, 5, 253, 3, 7200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 138, 24, 1, -3, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 381, 4, 247, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 387, 2, 4, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 644, 9, 249, 251, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 390, 7, 7, 252, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 21, 134, 7, 2, 8, 2, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 899, 4, 10, 2, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 637, 2, 4, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 381, 2, 4, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 12, 383, 4, 250, 5, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 13, 138, 9, 248, 7, 1, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 125, 9, 252, 254, 0, 3200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 646, 1, 251, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 16, 387, 9, 0, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 13, 203, 6, -7, -2, 3, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 201, 0, 8, 8, 2, 80000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 895, 4, 7, 245, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 12, 203, 7, -8, 4, 1, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 18, 132, 9, 253, 10, 2, 31200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 132, 9, 8, 250, 3, 31200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 134, 9, 251, 246, 0, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 17, 130, 2, 9, 7, 2, 23200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 644, 2, 4, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 130, 9, 251, 248, 0, 23200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 130, 33, -3, 1, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 897, 4, 10, 2, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 895, 9, 8, 255, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 15, 126, 19, 255, 249, 0, 7200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 897, 2, 4, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 15, 894, 9, 3, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 131, 9, 5, 249, 0, 27200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 13, 383, 9, 6, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 130, 24, 0, -4, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 125, 8, 2, 10, 3, 3200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 132, 9, 8, 253, 3, 31200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 131, 30, -2, 5, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 12, 388, 4, 250, 5, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 898, 1, 251, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 390, 4, 7, 245, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 138, 9, 10, 252, 3, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 12, 125, 1, 250, 2, 1, 3200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 637, 1, 251, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 13, 388, 9, 6, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 202, 8, -5, 1, 2, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 638, 2, 4, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 1668, 31, 253, 4, 0, 31200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 381, 0, 254, 249, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 894, 1, 251, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 130, 4, 247, 9, 1, 23200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 203, 4, -7, -6, 0, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 639, 9, 249, 1, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 902, 0, 254, 249, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 381, 1, 251, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 15, 125, 19, 1, 11, 2, 3200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 643, 9, 8, 249, 3, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 129, 0, 253, 251, 0, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 898, 9, 249, 1, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 13, 639, 9, 6, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 637, 7, 7, 252, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 23, 134, 2, 247, 3, 1, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 13, 386, 9, 6, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 12, 387, 4, 250, 5, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 644, 7, 250, 254, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 637, 9, 249, 1, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 15, 130, 2, 9, 253, 3, 23200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 14, 898, 9, 253, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 125, 25, -3, 2, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 386, 9, 249, 251, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 203, 2, 5, 8, 2, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 894, 4, 7, 245, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 132, 9, 8, 3, 3, 31200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 15, 643, 9, 3, 3, 2, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 899, 9, 249, 1, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 20, 131, 10, 250, 4, 0, 27200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 14, 899, 9, 253, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 129, 9, 248, 254, 1, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 644, 1, 251, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 644, 4, 247, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 125, 9, 3, 7, 3, 3200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 13, 900, 9, 6, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 16, 388, 9, 0, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 15, 641, 9, 3, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 126, 25, 4, 5, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 13, 131, 2, 248, 6, 1, 27200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 132, 30, -3, 4, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 642, 9, 249, 1, 1, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 895, 7, 250, 254, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 387, 0, 254, 249, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 638, 7, 7, 252, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 387, 4, 10, 2, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 898, 9, 249, 251, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 15, 897, 9, 3, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 16, 129, 9, 255, 9, 2, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 126, 2, 2, 249, 0, 7200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 388, 9, 249, 251, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 902, 7, 250, 254, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 16, 138, 9, 255, 9, 2, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 642, 7, 7, 252, 3, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 131, 4, 8, 247, 3, 27200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 18, 134, 3, 252, 8, 2, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 16, 895, 9, 0, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 15, 893, 9, 3, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 893, 4, 10, 2, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 15, 388, 9, 3, 3, 2, 29996, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 13, 637, 9, 6, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 138, 0, 253, 251, 0, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 646, 9, 8, 249, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 12, 134, 28, -12, 4, 1, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 202, 0, -5, 0, 1, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 134, 9, 246, 250, 1, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 637, 0, 254, 249, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 16, 644, 9, 0, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 15, 131, 3, 6, 7, 3, 27200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 641, 9, 249, 1, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 131, 27, 8, -10, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 643, 7, 250, 254, 1, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 641, 2, 4, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 129, 4, 246, 251, 0, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 12, 382, 4, 250, 5, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 902, 9, 249, 1, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 138, 4, 246, 251, 0, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 637, 9, 8, 249, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 382, 4, 247, 248, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 138, 9, 248, 254, 1, 19200, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 16, 382, 9, 0, 3, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 134, 9, 11, 248, 3, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 386, 9, 8, 249, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 897, 0, 254, 249, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 16, 642, 9, 0, 3, 2, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 129, 21, -9, 0, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 127, 27, 4, -8, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 132, 24, -3, -7, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 126, 25, -3, 5, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 138, 21, -9, 0, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 125, 34, -2, -2, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 893, 21, 6, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 893, 24, 254, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 893, 27, 7, 247, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 893, 23, 10, 254, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 893, 29, 3, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 893, 21, 251, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 893, 27, 244, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 893, 27, 13, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 893, 21, 4, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 893, 27, 250, 10, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 893, 21, 253, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 893, 23, 247, 3, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 894, 21, 6, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 894, 24, 254, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 894, 27, 7, 247, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 894, 23, 10, 254, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 894, 29, 3, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 894, 21, 251, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 894, 27, 244, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 894, 27, 13, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 894, 21, 4, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 894, 27, 250, 10, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 894, 21, 253, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 894, 23, 247, 3, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 895, 21, 6, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 895, 24, 254, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 895, 27, 7, 247, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 895, 23, 10, 254, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 895, 29, 3, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 895, 21, 251, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 895, 27, 244, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 895, 27, 13, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 895, 21, 4, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 895, 27, 250, 10, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 895, 21, 253, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 895, 23, 247, 3, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 203, 21, 6, 7, 2, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 203, 24, 254, 253, 0, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 203, 27, 7, 247, 3, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 203, 23, 10, 254, 3, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 203, 29, 3, 4, 2, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 203, 21, 251, 250, 0, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 203, 27, 244, 253, 0, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 203, 27, 13, 4, 2, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 203, 21, 4, 250, 0, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 203, 27, 250, 10, 1, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 203, 21, 253, 7, 2, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 203, 23, 247, 3, 1, 20000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 897, 21, 6, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 897, 24, 254, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 897, 27, 7, 247, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 897, 23, 10, 254, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 897, 29, 3, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 897, 21, 251, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 897, 27, 244, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 897, 27, 13, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 897, 21, 4, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 897, 27, 250, 10, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 897, 21, 253, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 897, 23, 247, 3, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 898, 21, 6, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 898, 24, 254, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 898, 27, 7, 247, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 898, 23, 10, 254, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 898, 29, 3, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 898, 21, 251, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 898, 27, 244, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 898, 27, 13, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 898, 21, 4, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 898, 27, 250, 10, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 898, 21, 253, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 898, 23, 247, 3, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 899, 21, 6, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 899, 24, 254, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 899, 27, 7, 247, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 899, 23, 10, 254, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 899, 29, 3, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 899, 21, 251, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 899, 27, 244, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 899, 27, 13, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 899, 21, 4, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 899, 27, 250, 10, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 899, 21, 253, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 899, 23, 247, 3, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 900, 21, 6, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 900, 24, 254, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 900, 27, 7, 247, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 900, 23, 10, 254, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 900, 29, 3, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 900, 21, 251, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 900, 27, 244, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 900, 27, 13, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 900, 21, 4, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 900, 27, 250, 10, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 900, 21, 253, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 900, 23, 247, 3, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 902, 21, 6, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 902, 24, 254, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 902, 27, 7, 247, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 902, 23, 10, 254, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 902, 29, 3, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 902, 21, 251, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 902, 27, 244, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 902, 27, 13, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 902, 21, 4, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 902, 27, 250, 10, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 902, 21, 253, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 902, 23, 247, 3, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 130, 27, 6, -10, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 132, 32, -4, -1, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 637, 21, 6, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 637, 24, 254, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 637, 27, 7, 247, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 637, 23, 10, 254, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 637, 29, 3, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 637, 21, 251, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 637, 27, 244, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 637, 27, 13, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 637, 21, 4, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 637, 27, 250, 10, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 637, 21, 253, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 637, 23, 247, 3, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 638, 21, 6, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 638, 24, 254, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 638, 27, 7, 247, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 638, 23, 10, 254, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 638, 29, 3, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 638, 21, 251, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 638, 27, 244, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 638, 27, 13, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 638, 21, 4, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 638, 27, 250, 10, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 638, 21, 253, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 638, 23, 247, 3, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 639, 21, 6, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 639, 24, 254, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 639, 27, 7, 247, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 639, 23, 10, 254, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 639, 29, 3, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 639, 21, 251, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 639, 27, 244, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 639, 27, 13, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 639, 21, 4, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 639, 27, 250, 10, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 639, 21, 253, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 639, 23, 247, 3, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 202, 21, 6, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 202, 24, 254, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 202, 27, 7, 247, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 202, 23, 10, 254, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 202, 29, 3, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 202, 21, 251, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 202, 27, 244, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 202, 27, 13, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 202, 21, 4, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 202, 27, 250, 10, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 202, 21, 253, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 202, 23, 247, 3, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 641, 21, 6, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 641, 24, 254, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 641, 27, 7, 247, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 641, 23, 10, 254, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 641, 29, 3, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 641, 21, 251, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 641, 27, 244, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 641, 27, 13, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 641, 21, 4, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 641, 27, 250, 10, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 641, 21, 253, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 641, 23, 247, 3, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 642, 21, 6, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 642, 24, 254, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 642, 27, 7, 247, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 642, 23, 10, 254, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 642, 29, 3, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 642, 21, 251, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 642, 27, 244, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 642, 27, 13, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 642, 21, 4, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 642, 27, 250, 10, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 642, 21, 253, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 642, 23, 247, 3, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 643, 21, 6, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 643, 24, 254, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 643, 27, 7, 247, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 643, 23, 10, 254, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 643, 29, 3, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 643, 21, 251, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 643, 27, 244, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 643, 27, 13, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 643, 21, 4, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 643, 27, 250, 10, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 643, 21, 253, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 643, 23, 247, 3, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 644, 21, 6, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 644, 24, 254, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 644, 27, 7, 247, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 644, 23, 10, 254, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 644, 29, 3, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 644, 21, 251, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 644, 27, 244, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 644, 27, 13, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 644, 21, 4, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 644, 27, 250, 10, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 644, 21, 253, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 644, 23, 247, 3, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 646, 21, 6, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 646, 24, 254, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 646, 27, 7, 247, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 646, 23, 10, 254, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 646, 29, 3, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 646, 21, 251, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 646, 27, 244, 253, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 646, 27, 13, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 646, 21, 4, 250, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 646, 27, 250, 10, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 646, 21, 253, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 646, 23, 247, 3, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 131, 25, -5, 6, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 125, 25, 4, 2, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 131, 29, 7, 6, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 130, 27, -10, -4, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 126, 25, -3, -2, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 127, 27, -9, -2, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 132, 27, 6, -13, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 12, 129, 21, 6, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 17, 134, 29, 9, 5, 2, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 0, 134, 24, 4, -5, 0, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 129, 27, 13, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 132, 27, 12, 6, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 12, 138, 21, 6, 7, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 125, 21, 3, 5, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 138, 27, 13, 4, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 129, 27, -6, 10, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 12, 130, 33, 0, 1, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 130, 32, 6, -3, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 129, 21, -9, 3, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 5, 125, 21, 7, -1, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 129, 21, 10, 1, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 138, 27, -6, 10, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 14, 132, 21, 9, 3, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 138, 21, -9, 3, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 138, 21, 10, 1, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 132, 27, -4, 12, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 127, 21, 7, -1, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 129, 27, -12, -3, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 125, 21, 0, 5, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 138, 27, -12, -3, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 4, 132, 27, -10, -7, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 134, 27, -9, 11, 1, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 16, 134, 22, 0, 7, 2, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 8, 134, 27, 16, 5, 2, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 2, 131, 27, -11, -4, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 11, 134, 21, -8, -8, 0, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 7, 126, 21, 3, 8, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 125, 25, 4, -2, 0, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 134, 30, -5, 6, 0, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 10, 131, 29, 1, 6, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 3, 132, 32, 6, -6, 3, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 129, 30, 3, 1, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 134, 21, 1, -8, 0, 40000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 1, 138, 30, 3, 1, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 6, 126, 29, -3, 4, 1, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
INSERT INTO keepcomponent (KeepComponent_ID, ID, KeepID, Skin, X, Y, Heading, Health, CreateInfo, LastTimeRowUpdated) VALUES (UUID(), 9, 132, 29, 5, 6, 2, 30000, '', '2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `KeepComponent_ID` = `KeepComponent_ID`;
