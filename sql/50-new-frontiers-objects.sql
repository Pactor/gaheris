-- The doors, banners and bits of New Frontiers that were not yet loaded.
--
-- Region 163 held 76 of the 94 world objects the dump has for it. These are
-- the remaining 20. Additive; nothing existing is touched.

INSERT INTO worldobject (`WorldObject_ID`,`ClassType`,`TranslationId`,`Name`,`ExamineArticle`,`X`,`Y`,`Z`,`Heading`,`Region`,`Model`,`Emblem`,`Realm`,`RespawnInterval`,LastTimeRowUpdated) VALUES
('15726b40-20b8-480c-8b82-f47ac63ef0b9','DOL.GS.GameRelicPad','','Dun Crauchon Strength Relic Pad','',473006,500381,9702,676,163,2655,3,0,0,'2000-01-01 00:00:00'),
('1f15f056-f27a-4a39-938f-c1586b5ead7a','DOL.GS.GameRelicPad','','Dun Ailinne Strength Relic Pad','',410989,606490,9422,3660,163,2655,3,0,0,'2000-01-01 00:00:00'),
('261e180c-3824-49ce-865b-e2a2697de743','DOL.GS.GameRelicPad','','Glenlock Faste Strength Relic Pad','',610285,376508,9830,1557,163,2655,2,0,0,'2000-01-01 00:00:00'),
('4b465fb8-412d-4ed3-bff9-4f2f2d4b3800','DOL.GS.GameRelicPad','','Caer Boldiam Power Relic Pad','',606730,575525,9806,552,163,2655,11,0,0,'2000-01-01 00:00:00'),
('4c19ae04-597a-4278-a364-2a5e4ab222db','DOL.GS.GameStaticItemNoLoad','','relic pad','',627561,606730,9154,1228,163,2655,1617,0,0,'2000-01-01 00:00:00'),
('6f9634bd-1b95-4882-bf92-57e4fedbdfc2','DOL.GS.GameRelicPad','','Caer Renaris Power Relic Pad','',627648,607182,9502,1719,163,2655,11,0,0,'2000-01-01 00:00:00'),
('738a13db-e809-4a0e-b844-2f50ca782be4','DOL.GS.GameRelicPad','','Bledmeer Faste Power Relic Pad','',534027,407206,9870,1586,163,2655,12,0,0,'2000-01-01 00:00:00'),
('90de8454-4534-4b0a-baae-08be4c7f5030','DOL.GS.GameRelicPad','','Dun nGed Strength Relic Pad','',442866,577375,9806,1602,163,2655,3,0,0,'2000-01-01 00:00:00'),
('a518fbf1-7316-416c-8a2b-c5a711be54c7','DOL.GS.GameRelicPad','','Dun Crauchon Power Relic Pad','',472863,501029,9702,1668,163,2655,13,0,0,'2000-01-01 00:00:00'),
('a6af16e4-d9bb-4a02-802b-fbc89dd97f76','DOL.GS.GameRelicPad','','Bledmeer Faste Strength Relic Pad','',534028,406515,9870,521,163,2655,2,0,0,'2000-01-01 00:00:00'),
('a80a4e82-beaa-40ac-8094-43ed8389a82e','DOL.GS.GameRelicPad','','Glenlock Faste Power Relic Pad','',609595,376514,9830,2504,163,2655,12,0,0,'2000-01-01 00:00:00'),
('b97289ff-5584-4702-9570-f1e4128c7cb3','DOL.GS.GameRelicPad','','Dun Ailinne Power Relic Pad','',411643,606498,9422,461,163,2655,13,0,0,'2000-01-01 00:00:00'),
('cbd99979-f52e-4ce8-8a31-23904ef4e609','DOL.GS.GameRelicPad','','Caer Renaris Strength Relic Pad','',627806,606512,9502,711,163,2655,1,0,0,'2000-01-01 00:00:00'),
('cf811187-4ef2-4b35-af95-cb781813e934','DOL.GS.GameRelicPad','','Dun nGed Power Relic Pad','',442205,577382,9806,2498,163,2655,13,0,0,'2000-01-01 00:00:00'),
('e19b1ac5-0e31-4104-8908-761504f3e746','DOL.GS.GameRelicPad','','Caer Benowyc Strength Relic Pad','',575334,501710,9702,3584,163,2655,1,0,0,'2000-01-01 00:00:00'),
('e3e28a8f-62f9-4cdd-a0d0-40a8010ce5d2','DOL.GS.GameRelicPad','','Fensalir Faste Strength Relic Pad','',638634,345251,9590,3624,163,2655,2,0,0,'2000-01-01 00:00:00'),
('f02f71ed-534d-4e9e-a6fb-e2304d5e1ee9','DOL.GS.Keeps.FrontiersPortalStone','','Frontiers Portal Stone','',396005,618116,9819,3460,163,2603,0,0,0,'2000-01-01 00:00:00'),
('f2c68aba-7038-46e5-908e-1dcfd25279d7','DOL.GS.GameRelicPad','','Caer Benowyc Power Relic Pad','',576039,501720,9702,473,163,2655,11,0,0,'2000-01-01 00:00:00'),
('f5161ac9-e5c6-4d77-9e75-091195310668','DOL.GS.GameRelicPad','','Fensalir Faste Power Relic Pad','',639311,345231,9590,449,163,2655,12,0,0,'2000-01-01 00:00:00'),
('ffdb32b1-bae0-4491-806c-afb2c1ade1df','DOL.GS.GameRelicPad','','Caer Boldiam Strength Relic Pad','',606050,575511,9806,3609,163,2655,1,0,0,'2000-01-01 00:00:00')
ON DUPLICATE KEY UPDATE `WorldObject_ID` = `WorldObject_ID`;
