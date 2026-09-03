-- Give the New Frontiers keeps their banners back.
--
-- Migration 61 set all 105 to Realm 0 so the Gaheris monster garrison would
-- hold them. That made them render as pure white: SendKeepInfo writes
-- keep.Realm straight to the client
--
--     pak.WriteByte((byte)keep.Realm);
--
-- and the client picks the keep's texture set from it. Realm None has no set,
-- so there is nothing to paint them with and they come out untextured.
--
-- A keep therefore has to carry a realm to be visible at all. Restored to
-- what the New Frontiers data shipped: 35 keeps each to Albion, Midgard and
-- Hibernia.
--
-- They are still held by evil. That test moved out of the keep's realm and
-- into where the keep stands -- see HeldByEvil in MonsterGarrison.cs -- so
-- the garrison is unchanged and only the stonework is fixed.

UPDATE keep SET Realm = 1, OriginalRealm = 1
 WHERE Region = 163 AND KeepID = 50;
UPDATE keep SET Realm = 1, OriginalRealm = 1
 WHERE Region = 163 AND KeepID = 51;
UPDATE keep SET Realm = 1, OriginalRealm = 1
 WHERE Region = 163 AND KeepID = 52;
UPDATE keep SET Realm = 1, OriginalRealm = 1
 WHERE Region = 163 AND KeepID = 53;
UPDATE keep SET Realm = 1, OriginalRealm = 1
 WHERE Region = 163 AND KeepID = 54;
UPDATE keep SET Realm = 1, OriginalRealm = 1
 WHERE Region = 163 AND KeepID = 55;
UPDATE keep SET Realm = 1, OriginalRealm = 1
 WHERE Region = 163 AND KeepID = 56;
UPDATE keep SET Realm = 2, OriginalRealm = 2
 WHERE Region = 163 AND KeepID = 75;
UPDATE keep SET Realm = 2, OriginalRealm = 2
 WHERE Region = 163 AND KeepID = 76;
UPDATE keep SET Realm = 2, OriginalRealm = 2
 WHERE Region = 163 AND KeepID = 77;
UPDATE keep SET Realm = 2, OriginalRealm = 2
 WHERE Region = 163 AND KeepID = 78;
UPDATE keep SET Realm = 2, OriginalRealm = 2
 WHERE Region = 163 AND KeepID = 79;
UPDATE keep SET Realm = 2, OriginalRealm = 2
 WHERE Region = 163 AND KeepID = 80;
UPDATE keep SET Realm = 2, OriginalRealm = 2
 WHERE Region = 163 AND KeepID = 81;
UPDATE keep SET Realm = 3, OriginalRealm = 3
 WHERE Region = 163 AND KeepID = 100;
UPDATE keep SET Realm = 3, OriginalRealm = 3
 WHERE Region = 163 AND KeepID = 101;
UPDATE keep SET Realm = 3, OriginalRealm = 3
 WHERE Region = 163 AND KeepID = 102;
UPDATE keep SET Realm = 3, OriginalRealm = 3
 WHERE Region = 163 AND KeepID = 103;
UPDATE keep SET Realm = 3, OriginalRealm = 3
 WHERE Region = 163 AND KeepID = 104;
UPDATE keep SET Realm = 3, OriginalRealm = 3
 WHERE Region = 163 AND KeepID = 105;
UPDATE keep SET Realm = 3, OriginalRealm = 3
 WHERE Region = 163 AND KeepID = 106;
UPDATE keep SET Realm = 1, OriginalRealm = 1
 WHERE Region = 163 AND KeepID = 306;
UPDATE keep SET Realm = 1, OriginalRealm = 1
 WHERE Region = 163 AND KeepID = 307;
UPDATE keep SET Realm = 1, OriginalRealm = 1
 WHERE Region = 163 AND KeepID = 308;
UPDATE keep SET Realm = 1, OriginalRealm = 1
 WHERE Region = 163 AND KeepID = 309;
UPDATE keep SET Realm = 1, OriginalRealm = 1
 WHERE Region = 163 AND KeepID = 310;
UPDATE keep SET Realm = 1, OriginalRealm = 1
 WHERE Region = 163 AND KeepID = 311;
UPDATE keep SET Realm = 1, OriginalRealm = 1
 WHERE Region = 163 AND KeepID = 312;
UPDATE keep SET Realm = 2, OriginalRealm = 2
 WHERE Region = 163 AND KeepID = 331;
UPDATE keep SET Realm = 2, OriginalRealm = 2
 WHERE Region = 163 AND KeepID = 332;
UPDATE keep SET Realm = 2, OriginalRealm = 2
 WHERE Region = 163 AND KeepID = 333;
UPDATE keep SET Realm = 2, OriginalRealm = 2
 WHERE Region = 163 AND KeepID = 334;
UPDATE keep SET Realm = 2, OriginalRealm = 2
 WHERE Region = 163 AND KeepID = 335;
UPDATE keep SET Realm = 2, OriginalRealm = 2
 WHERE Region = 163 AND KeepID = 336;
UPDATE keep SET Realm = 2, OriginalRealm = 2
 WHERE Region = 163 AND KeepID = 337;
UPDATE keep SET Realm = 3, OriginalRealm = 3
 WHERE Region = 163 AND KeepID = 356;
UPDATE keep SET Realm = 3, OriginalRealm = 3
 WHERE Region = 163 AND KeepID = 357;
UPDATE keep SET Realm = 3, OriginalRealm = 3
 WHERE Region = 163 AND KeepID = 358;
UPDATE keep SET Realm = 3, OriginalRealm = 3
 WHERE Region = 163 AND KeepID = 359;
UPDATE keep SET Realm = 3, OriginalRealm = 3
 WHERE Region = 163 AND KeepID = 360;
UPDATE keep SET Realm = 3, OriginalRealm = 3
 WHERE Region = 163 AND KeepID = 361;
UPDATE keep SET Realm = 3, OriginalRealm = 3
 WHERE Region = 163 AND KeepID = 362;
UPDATE keep SET Realm = 1, OriginalRealm = 1
 WHERE Region = 163 AND KeepID = 562;
UPDATE keep SET Realm = 1, OriginalRealm = 1
 WHERE Region = 163 AND KeepID = 563;
UPDATE keep SET Realm = 1, OriginalRealm = 1
 WHERE Region = 163 AND KeepID = 564;
UPDATE keep SET Realm = 1, OriginalRealm = 1
 WHERE Region = 163 AND KeepID = 565;
UPDATE keep SET Realm = 1, OriginalRealm = 1
 WHERE Region = 163 AND KeepID = 566;
UPDATE keep SET Realm = 1, OriginalRealm = 1
 WHERE Region = 163 AND KeepID = 567;
UPDATE keep SET Realm = 1, OriginalRealm = 1
 WHERE Region = 163 AND KeepID = 568;
UPDATE keep SET Realm = 2, OriginalRealm = 2
 WHERE Region = 163 AND KeepID = 587;
UPDATE keep SET Realm = 2, OriginalRealm = 2
 WHERE Region = 163 AND KeepID = 588;
UPDATE keep SET Realm = 2, OriginalRealm = 2
 WHERE Region = 163 AND KeepID = 589;
UPDATE keep SET Realm = 2, OriginalRealm = 2
 WHERE Region = 163 AND KeepID = 590;
UPDATE keep SET Realm = 2, OriginalRealm = 2
 WHERE Region = 163 AND KeepID = 591;
UPDATE keep SET Realm = 2, OriginalRealm = 2
 WHERE Region = 163 AND KeepID = 592;
UPDATE keep SET Realm = 2, OriginalRealm = 2
 WHERE Region = 163 AND KeepID = 593;
UPDATE keep SET Realm = 3, OriginalRealm = 3
 WHERE Region = 163 AND KeepID = 612;
UPDATE keep SET Realm = 3, OriginalRealm = 3
 WHERE Region = 163 AND KeepID = 613;
UPDATE keep SET Realm = 3, OriginalRealm = 3
 WHERE Region = 163 AND KeepID = 614;
UPDATE keep SET Realm = 3, OriginalRealm = 3
 WHERE Region = 163 AND KeepID = 615;
UPDATE keep SET Realm = 3, OriginalRealm = 3
 WHERE Region = 163 AND KeepID = 616;
UPDATE keep SET Realm = 3, OriginalRealm = 3
 WHERE Region = 163 AND KeepID = 617;
UPDATE keep SET Realm = 3, OriginalRealm = 3
 WHERE Region = 163 AND KeepID = 618;
UPDATE keep SET Realm = 1, OriginalRealm = 1
 WHERE Region = 163 AND KeepID = 818;
UPDATE keep SET Realm = 1, OriginalRealm = 1
 WHERE Region = 163 AND KeepID = 819;
UPDATE keep SET Realm = 1, OriginalRealm = 1
 WHERE Region = 163 AND KeepID = 820;
UPDATE keep SET Realm = 1, OriginalRealm = 1
 WHERE Region = 163 AND KeepID = 821;
UPDATE keep SET Realm = 1, OriginalRealm = 1
 WHERE Region = 163 AND KeepID = 822;
UPDATE keep SET Realm = 1, OriginalRealm = 1
 WHERE Region = 163 AND KeepID = 823;
UPDATE keep SET Realm = 1, OriginalRealm = 1
 WHERE Region = 163 AND KeepID = 824;
UPDATE keep SET Realm = 2, OriginalRealm = 2
 WHERE Region = 163 AND KeepID = 843;
UPDATE keep SET Realm = 2, OriginalRealm = 2
 WHERE Region = 163 AND KeepID = 844;
UPDATE keep SET Realm = 2, OriginalRealm = 2
 WHERE Region = 163 AND KeepID = 845;
UPDATE keep SET Realm = 2, OriginalRealm = 2
 WHERE Region = 163 AND KeepID = 846;
UPDATE keep SET Realm = 2, OriginalRealm = 2
 WHERE Region = 163 AND KeepID = 847;
UPDATE keep SET Realm = 2, OriginalRealm = 2
 WHERE Region = 163 AND KeepID = 848;
UPDATE keep SET Realm = 2, OriginalRealm = 2
 WHERE Region = 163 AND KeepID = 849;
UPDATE keep SET Realm = 3, OriginalRealm = 3
 WHERE Region = 163 AND KeepID = 868;
UPDATE keep SET Realm = 3, OriginalRealm = 3
 WHERE Region = 163 AND KeepID = 869;
UPDATE keep SET Realm = 3, OriginalRealm = 3
 WHERE Region = 163 AND KeepID = 870;
UPDATE keep SET Realm = 3, OriginalRealm = 3
 WHERE Region = 163 AND KeepID = 871;
UPDATE keep SET Realm = 3, OriginalRealm = 3
 WHERE Region = 163 AND KeepID = 872;
UPDATE keep SET Realm = 3, OriginalRealm = 3
 WHERE Region = 163 AND KeepID = 873;
UPDATE keep SET Realm = 3, OriginalRealm = 3
 WHERE Region = 163 AND KeepID = 874;
UPDATE keep SET Realm = 1, OriginalRealm = 1
 WHERE Region = 163 AND KeepID = 1074;
UPDATE keep SET Realm = 1, OriginalRealm = 1
 WHERE Region = 163 AND KeepID = 1075;
UPDATE keep SET Realm = 1, OriginalRealm = 1
 WHERE Region = 163 AND KeepID = 1076;
UPDATE keep SET Realm = 1, OriginalRealm = 1
 WHERE Region = 163 AND KeepID = 1077;
UPDATE keep SET Realm = 1, OriginalRealm = 1
 WHERE Region = 163 AND KeepID = 1078;
UPDATE keep SET Realm = 1, OriginalRealm = 1
 WHERE Region = 163 AND KeepID = 1079;
UPDATE keep SET Realm = 1, OriginalRealm = 1
 WHERE Region = 163 AND KeepID = 1080;
UPDATE keep SET Realm = 2, OriginalRealm = 2
 WHERE Region = 163 AND KeepID = 1099;
UPDATE keep SET Realm = 2, OriginalRealm = 2
 WHERE Region = 163 AND KeepID = 1100;
UPDATE keep SET Realm = 2, OriginalRealm = 2
 WHERE Region = 163 AND KeepID = 1101;
UPDATE keep SET Realm = 2, OriginalRealm = 2
 WHERE Region = 163 AND KeepID = 1102;
UPDATE keep SET Realm = 2, OriginalRealm = 2
 WHERE Region = 163 AND KeepID = 1103;
UPDATE keep SET Realm = 2, OriginalRealm = 2
 WHERE Region = 163 AND KeepID = 1104;
UPDATE keep SET Realm = 2, OriginalRealm = 2
 WHERE Region = 163 AND KeepID = 1105;
UPDATE keep SET Realm = 3, OriginalRealm = 3
 WHERE Region = 163 AND KeepID = 1124;
UPDATE keep SET Realm = 3, OriginalRealm = 3
 WHERE Region = 163 AND KeepID = 1125;
UPDATE keep SET Realm = 3, OriginalRealm = 3
 WHERE Region = 163 AND KeepID = 1126;
UPDATE keep SET Realm = 3, OriginalRealm = 3
 WHERE Region = 163 AND KeepID = 1127;
UPDATE keep SET Realm = 3, OriginalRealm = 3
 WHERE Region = 163 AND KeepID = 1128;
UPDATE keep SET Realm = 3, OriginalRealm = 3
 WHERE Region = 163 AND KeepID = 1129;
UPDATE keep SET Realm = 3, OriginalRealm = 3 WHERE Region = 163 AND KeepID = 1130;
