-- A boss worth the name.
--
-- Boss missions could never be drawn. The core decides whether an NPC is a
-- boss by looking at its name:
--
--     if (npc.Name.ToLower() != npc.Name)
--         m_bossName = npc.Name;
--
-- -- a capital letter anywhere is what makes something a boss. Every one of
-- the 230 creature templates these dungeons are built from is named in lower
-- case, the way ordinary monsters are, so m_bossName stayed empty, and the
-- mission type that needs it was never rolled. In practice every task was a
-- clear or a count, and the one people actually used -- slip past the aggro,
-- kill the named thing, walk out -- did not exist.
--
-- So each dungeon gets a boss of its own: a new template cloned from the
-- creature already standing deepest in that dungeon, three levels above it
-- and a good deal larger, carrying a proper name and a title. The creature it
-- was made from stays in the guild line, so a boss still reads as belonging
-- to the dungeon it is in rather than as something dropped in from outside.
--
-- Deterministic: the name is seeded per dungeon.

DELETE FROM npctemplate WHERE PackageID = 'gaheris-boss';

INSERT INTO npctemplate (NpcTemplate_ID,TemplateId,Name,GuildName,ClassType,TranslationId,Suffix,ExamineArticle,MessageArticle,EquipmentTemplateID,ItemsListTemplateID,Spells,Styles,Abilities,Model,Size,Level,AggroLevel,AggroRange,MaxSpeed,PackageID,LastTimeRowUpdated) VALUES
(UUID(),999670000,'Zorath the Hollow','pitch skeleton','DOL.GS.GameNPC','','','','','','','','','','938','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670001,'Corvus the Marrowlord','cliff crawler','DOL.GS.GameNPC','','','','','','','','','','72','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670002,'Nethys the Hollow','Welsh hobgoblin','DOL.GS.GameNPC','','','','','','','','','','249','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670003,'Balgar the Slow Death','cave crawler','DOL.GS.GameNPC','','','','','','','','','','29;30','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670004,'Zorath the Marrowlord','Welsh hobgoblin','DOL.GS.GameNPC','','','','','','','','','','249','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670005,'Belkar the Sunless','ambient rat','DOL.GS.GameNPC','','','','','','','','','','567;1673','55','4',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670006,'Praxis the Unhallowed','bandit infiltrator','DOL.GS.GameNPC','','','','','','','','','','14;32-46;48-55;61-68;254-285;471-502;716-731;805-812','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670007,'Drenn the Unhallowed','corrupted tree spider','DOL.GS.GameNPC','','','','','','','','','','132','46','8',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670008,'Nurgal the Toothed','ghoul knight','DOL.GS.GameNPC','','','','','','','','','','110','55','21',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670009,'Ilvarn the Gorged','ghoul lord','DOL.GS.GameNPC','','','','','','','','','','110;921','55','22',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670010,'Quorl the Blighted','sanguinite ghoul','DOL.GS.GameNPC','','','','','','','','','','111','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670011,'Emberich the Gorged','goblin crawler','DOL.GS.GameNPC','','','','','','','','','','578','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670012,'Pyrran the Unhallowed','goblin crawler','DOL.GS.GameNPC','','','','','','','','','','578','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670013,'Dravok the Sunless','goblin apprentice','DOL.GS.GameNPC','','','','','','','','','','578','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670014,'Ulgrim the Unhallowed','frost spider','DOL.GS.GameNPC','','','','','','','','','','453','32','40',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670015,'Dravok the Toothed','frost spider','DOL.GS.GameNPC','','','','','','','','','','453','32','40',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670016,'Malreth the Hollow','vampiric spider','DOL.GS.GameNPC','','','','','','','','','','60','55','43',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670017,'Ergoth the Hollow','ancient tomb spider','DOL.GS.GameNPC','','','','','','','','','','1607','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670018,'Quorl the Ravener','ancient tomb spider','DOL.GS.GameNPC','','','','','','','','','','1607','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670019,'Grimwold the Slow Death','arbor crawler','DOL.GS.GameNPC','','','','','','','','','','72','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670020,'Balgar the Gorged','skeleton','DOL.GS.GameNPC','','','','','','','','','','24;25;2213','55','5',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670021,'Fellmar the Deep Warden','skeleton','DOL.GS.GameNPC','','','','','','','','','','25;2213','55','5',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670022,'Kelvor the Deep Warden','putrid zombie','DOL.GS.GameNPC','','','','','','','','','','110','55','7',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670023,'Ulgrim the Ravener','miserable zombie','DOL.GS.GameNPC','','','','','','','','','','111;2186','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670024,'Balgar the Ravener','sulphuric ghoul','DOL.GS.GameNPC','','','','','','','','','','110','60','25',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670025,'Malreth the Rotcrown','miserable zombie','DOL.GS.GameNPC','','','','','','','','','','111','60','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670026,'Lorgan the Unhallowed','summoned rat','DOL.GS.GameNPC','','','','','','','','','','567','22','4',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670027,'Jorund the Gorged','Hugrath Wormly','DOL.GS.GameNPC','','','','','','','','','','111','55','11',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670028,'Orvath the Toothed','makeshift battle ram','DOL.GS.GameNPC','','','','','','','','','','2601','60','5',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670029,'Gorash the Blighted','Rat Matriarch','DOL.GS.GameNPC','','','','','','','','','','568','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670030,'Lorgan the Toothed','ambient rat','DOL.GS.GameNPC','','','','','','','','','','567','55','4',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670031,'Lorgan the Rotcrown','ghoul lord','DOL.GS.GameNPC','','','','','','','','','','110;921','55','22',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670032,'Ulgrim the Marrowlord','ghoul knight','DOL.GS.GameNPC','','','','','','','','','','110','55','21',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670033,'Grimwold the Sunless','ghoul knight','DOL.GS.GameNPC','','','','','','','','','','110','55','21',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670034,'Kaggath the Blighted','ghoulie','DOL.GS.GameNPC','','','','','','','','','','110','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670035,'Orvath the Hollow','ghoul knight','DOL.GS.GameNPC','','','','','','','','','','110','55','21',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670036,'Ombrach the Cairnbreaker','goblin cleaner','DOL.GS.GameNPC','','','','','','','','','','578','55','33',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670037,'Ulgrim the Ravener','goblin guard','DOL.GS.GameNPC','','','','','','','','','','246','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670038,'Corvus the Marrowlord','goblin whip','DOL.GS.GameNPC','','','','','','','','','','588','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670039,'Skarn the Unhallowed','goblin patrol leader','DOL.GS.GameNPC','','','','','','','','','','579','55','30',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670040,'Lorgan the Gorged','goblin patrol leader','DOL.GS.GameNPC','','','','','','','','','','579','55','30',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670041,'Grimwold the Toothed','frost spider','DOL.GS.GameNPC','','','','','','','','','','453','32','40',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670042,'Orvath the Blighted','frost spider','DOL.GS.GameNPC','','','','','','','','','','453','32','40',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670043,'Emberich the Rotcrown','frost spider','DOL.GS.GameNPC','','','','','','','','','','453','32','40',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670044,'Fangred the Slow Death','frost spider','DOL.GS.GameNPC','','','','','','','','','','453','32','40',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670045,'Kaggath the Hollow','frenetic wolfspider','DOL.GS.GameNPC','','','','','','','','','','72','55','41',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670046,'Xanthos the Unhallowed','forest spider','DOL.GS.GameNPC','','','','','','','','','','117','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670047,'Grimwold the Sunless','field spider','DOL.GS.GameNPC','','','','','','','','','','117','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670048,'Iskra the Blighted','bog crawler','DOL.GS.GameNPC','','','','','','','','','','470','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670049,'Malreth the Gorged','arbor crawler','DOL.GS.GameNPC','','','','','','','','','','72','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670050,'Quorl the Slow Death','forest spider','DOL.GS.GameNPC','','','','','','','','','','117','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670051,'Xanthos the Unhallowed','gem-dusted skeleton','DOL.GS.GameNPC','','','','','','','','','','25;26;24','60','40',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670052,'Ulgrim the Sunless','triton ghost commander','DOL.GS.GameNPC','','','','','','','','','','33744','60','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670053,'Belkar the Unhallowed','chattering skeleton','DOL.GS.GameNPC','','','','','','','','','','25','60','35',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670054,'Pyrran the Rotcrown','ebon skeleton','DOL.GS.GameNPC','','','','','','','','','','938','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670055,'Ulgrim the Blighted','ebon skeleton','DOL.GS.GameNPC','','','','','','','','','','938','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670056,'Emberich the Toothed','ghostly Hibernian invader','DOL.GS.GameNPC','','','','','','','','','','386','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670057,'Ilvarn the Deep Warden','putrid zombie','DOL.GS.GameNPC','','','','','','','','','','110','55','7',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670058,'Pyrran the Unhallowed','dwarf bone skeleton','DOL.GS.GameNPC','','','','','','','','','','24','49','8',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670059,'Orvath the Slow Death','zombie sow','DOL.GS.GameNPC','','','','','','','','','','103','60','7',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670060,'Skarn the Unhallowed','blighted zombie','DOL.GS.GameNPC','','','','','','','','','','110','56','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670061,'Quorl the Blighted','weak skeleton','DOL.GS.GameNPC','','','','','','','','','','24','60','4',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670062,'Praxis the Hollow','haunted spiritist','DOL.GS.GameNPC','','','','','','','','','','1894','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670063,'Morgath the Marrowlord','miserable zombie','DOL.GS.GameNPC','','','','','','','','','','111','60','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670064,'Hagreth the Hollow','miserable zombie','DOL.GS.GameNPC','','','','','','','','','','111','60','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670065,'Quorl the Gorged','miserable zombie','DOL.GS.GameNPC','','','','','','','','','','111','60','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670066,'Zorath the Ravener','miserable zombie','DOL.GS.GameNPC','','','','','','','','','','111','60','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670067,'Hulvan the Toothed','sylvan goblin chief','DOL.GS.GameNPC','','','','','','','','','','246','60','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670068,'Balgar the Sunless','goblin crawler','DOL.GS.GameNPC','','','','','','','','','','578','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670069,'Vorgath the Deep Warden','goblin watcher','DOL.GS.GameNPC','','','','','','','','','','578','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670070,'Kaggath the Slow Death','goblin watcher','DOL.GS.GameNPC','','','','','','','','','','578','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670071,'Vorgath the Unhallowed','goblin wolfhound','DOL.GS.GameNPC','','','','','','','','','','56','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670072,'Belkar the Hollow','chattering skeleton','DOL.GS.GameNPC','','','','','','','','','','25','60','35',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670073,'Nurgal the Blighted','chattering skeleton','DOL.GS.GameNPC','','','','','','','','','','25','55','35',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670074,'Aggrash the Blighted','ghostly wickerman','DOL.GS.GameNPC','','','','','','','','','','2106','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670075,'Fellmar the Rotcrown','gem-dusted skeleton','DOL.GS.GameNPC','','','','','','','','','','25;26;24','60','40',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670076,'Gorash the Toothed','chattering skeleton','DOL.GS.GameNPC','','','','','','','','','','25','55','35',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670077,'Yrsa the Ravener','pitch skeleton','DOL.GS.GameNPC','','','','','','','','','','938','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670078,'Ilvarn the Cairnbreaker','silver-flecked skeleton','DOL.GS.GameNPC','','','','','','','','','','26;25','60','50',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670079,'Wregan the Ravener','ebon skeleton','DOL.GS.GameNPC','','','','','','','','','','938','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670080,'Jorund the Blighted','shrieking wraith','DOL.GS.GameNPC','','','','','','','','','','441','60','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670081,'Wregan the Slow Death','screeching skeleton','DOL.GS.GameNPC','','','','','','','','','','24','60','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670082,'Ulgrim the Marrowlord','decayed zombie','DOL.GS.GameNPC','','','','','','','','','','110','55','6',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670083,'Belkar the Sunless','skeleton','DOL.GS.GameNPC','','','','','','','','','','25;2213','55','5',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670084,'Torvald the Slow Death','large bloated spider','DOL.GS.GameNPC','','','','','','','','','','72','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670085,'Emberich the Gorged','poisonous cave spider','DOL.GS.GameNPC','','','','','','','','','','117','55','18',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670086,'Orvath the Toothed','cliff spider','DOL.GS.GameNPC','','','','','','','','','','60','55','21',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670087,'Fangred the Rotcrown','torpor worm','DOL.GS.GameNPC','','','','','','','','','','454','60','40',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670088,'Quorl the Ravener','battle-scarred mauler','DOL.GS.GameNPC','','','','','','','','','','101','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670089,'Ilvarn the Sunless','raving battle dancer','DOL.GS.GameNPC','','','','','','','','','','1918','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670090,'Ombrach the Gorged','minor zombie servant','DOL.GS.GameNPC','','','','','','','','','','110','60','4',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670091,'Rhugard the Unhallowed','zombie farmer','DOL.GS.GameNPC','','','','','','','','','','110','60','10',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670092,'Iskra the Blighted','tainted zombie','DOL.GS.GameNPC','','','','','','','','','','110','60','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670093,'Drenn the Blighted','putrid zombie','DOL.GS.GameNPC','','','','','','','','','','110','55','7',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670094,'Ombrach the Cairnbreaker','lost skeleton','DOL.GS.GameNPC','','','','','','','','','','927','60','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670095,'Kaggath the Gorged','cave spider','DOL.GS.GameNPC','','','','','','','','','','117','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670096,'Zorath the Deep Warden','Rathis','DOL.GS.GameNPC','','','','','','','','','','394','60','16',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670097,'Drenn the Deep Warden','Rathis','DOL.GS.GameNPC','','','','','','','','','','394','60','16',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670098,'Drenn the Rotcrown','cave spider','DOL.GS.GameNPC','','','','','','','','','','117','54','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670099,'Belkar the Cairnbreaker','cliff spiderling','DOL.GS.GameNPC','','','','','','','','','','59','55','17',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670100,'Corvus the Sunless','haunting dirge','DOL.GS.GameNPC','','','','','','','','','','214','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670101,'Aggrash the Hollow','mephitic ghoul','DOL.GS.GameNPC','','','','','','','','','','922;921','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670102,'Lorgan the Toothed','mephitic ghoul','DOL.GS.GameNPC','','','','','','','','','','922;921','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670103,'Ilvarn the Cairnbreaker','haunting dirge','DOL.GS.GameNPC','','','','','','','','','','214','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670104,'Fellmar the Deep Warden','haunted appletree','DOL.GS.GameNPC','','','','','','','','','','948','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670105,'Grimwold the Rotcrown','worm','DOL.GS.GameNPC','','','','','','','','','','123;32891','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670106,'Drenn the Gorged','frost spider','DOL.GS.GameNPC','','','','','','','','','','453','32','40',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670107,'Fangred the Gorged','lair worm','DOL.GS.GameNPC','','','','','','','','','','454','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670108,'Balgar the Slow Death','battle-scarred mauler','DOL.GS.GameNPC','','','','','','','','','','101','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670109,'Vorgath the Cairnbreaker','battle-scarred mauler','DOL.GS.GameNPC','','','','','','','','','','101','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670110,'Ilvarn the Sunless','pygmy goblin','DOL.GS.GameNPC','','','','','','','','','','579','55','46',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670111,'Fangred the Hollow','arbor crawler','DOL.GS.GameNPC','','','','','','','','','','72','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670112,'Nethys the Marrowlord','deep goblin','DOL.GS.GameNPC','','','','','','','','','','578','55','45',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670113,'Belkar the Hollow','pygmy goblin tangler','DOL.GS.GameNPC','','','','','','','','','','579','55','48',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670114,'Morgath the Deep Warden','haunting dirge','DOL.GS.GameNPC','','','','','','','','','','214','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670115,'Skarn the Deep Warden','haunted spiritist','DOL.GS.GameNPC','','','','','','','','','','1894','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670116,'Cadris the Hollow','mephitic ghoul','DOL.GS.GameNPC','','','','','','','','','','922;921','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670117,'Torvald the Cairnbreaker','cliff crawler','DOL.GS.GameNPC','','','','','','','','','','72','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670118,'Wregan the Unhallowed','bog crawler','DOL.GS.GameNPC','','','','','','','','','','470','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00'),
(UUID(),999670119,'Aggrash the Rotcrown','bog crawler','DOL.GS.GameNPC','','','','','','','','','','470','55','20',95,600,200,'gaheris-boss','2000-01-01 00:00:00');

-- and stand him at the deepest point in the dungeon.
--
-- Pinned to the coordinates, not to the template he was cloned
-- from. That template belongs to a pack and so appears a dozen
-- times over, and matching on it and taking the first row put the
-- named creature wherever the row ids happened to fall -- in
-- practice often a few paces inside the door, which is the one
-- place a boss must not be.
UPDATE instancexelement SET NPCTemplate = '999670000' WHERE InstanceID = 'TaskDungeon423.1' AND X = 32330 AND Y = 29089 AND Z = 16000 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670001' WHERE InstanceID = 'Taskdungeon048.1' AND X = 30052 AND Y = 31447 AND Z = 15987 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670002' WHERE InstanceID = 'Taskdungeon256.1' AND X = 33936 AND Y = 34844 AND Z = 15989 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670003' WHERE InstanceID = 'Taskdungeon257.1' AND X = 31839 AND Y = 35507 AND Z = 15989 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670004' WHERE InstanceID = 'Taskdungeon258.1' AND X = 33850 AND Y = 34999 AND Z = 15987 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670005' WHERE InstanceID = 'Taskdungeon278.1' AND X = 34623 AND Y = 29384 AND Z = 16010 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670006' WHERE InstanceID = 'Taskdungeon279.1' AND X = 29780 AND Y = 28973 AND Z = 16007 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670007' WHERE InstanceID = 'Taskdungeon280.1' AND X = 32369 AND Y = 28873 AND Z = 16011 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670008' WHERE InstanceID = 'Taskdungeon281.1' AND X = 27993 AND Y = 33008 AND Z = 16011 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670009' WHERE InstanceID = 'Taskdungeon282.1' AND X = 27264 AND Y = 32937 AND Z = 16011 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670010' WHERE InstanceID = 'Taskdungeon283.1' AND X = 27676 AND Y = 28476 AND Z = 16011 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670011' WHERE InstanceID = 'Taskdungeon284.1' AND X = 28925 AND Y = 33462 AND Z = 16002 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670012' WHERE InstanceID = 'Taskdungeon285.1' AND X = 29582 AND Y = 28978 AND Z = 16005 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670013' WHERE InstanceID = 'Taskdungeon286.1' AND X = 29072 AND Y = 33902 AND Z = 16004 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670014' WHERE InstanceID = 'Taskdungeon287.1' AND X = 32953 AND Y = 34538 AND Z = 16263 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670015' WHERE InstanceID = 'Taskdungeon288.1' AND X = 34239 AND Y = 33089 AND Z = 16267 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670016' WHERE InstanceID = 'Taskdungeon289.1' AND X = 29337 AND Y = 33563 AND Z = 16264 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670017' WHERE InstanceID = 'Taskdungeon290.1' AND X = 34361 AND Y = 35009 AND Z = 16001 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670018' WHERE InstanceID = 'Taskdungeon291.1' AND X = 28670 AND Y = 33027 AND Z = 16005 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670019' WHERE InstanceID = 'Taskdungeon292.1' AND X = 32509 AND Y = 27900 AND Z = 16002 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670020' WHERE InstanceID = 'Taskdungeon293.1' AND X = 29252 AND Y = 29683 AND Z = 15279 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670021' WHERE InstanceID = 'Taskdungeon294.1' AND X = 28759 AND Y = 30228 AND Z = 15279 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670022' WHERE InstanceID = 'Taskdungeon295.1' AND X = 28856 AND Y = 28092 AND Z = 15280 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670023' WHERE InstanceID = 'Taskdungeon296.1' AND X = 28083 AND Y = 31177 AND Z = 16003 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670024' WHERE InstanceID = 'Taskdungeon297.1' AND X = 30799 AND Y = 32557 AND Z = 15748 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670025' WHERE InstanceID = 'Taskdungeon298.1' AND X = 28204 AND Y = 31880 AND Z = 16003 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670026' WHERE InstanceID = 'Taskdungeon300.1' AND X = 29758 AND Y = 28667 AND Z = 16010 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670027' WHERE InstanceID = 'Taskdungeon301.1' AND X = 35205 AND Y = 29953 AND Z = 16009 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670028' WHERE InstanceID = 'Taskdungeon302.1' AND X = 34007 AND Y = 32795 AND Z = 17028 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670029' WHERE InstanceID = 'Taskdungeon303.1' AND X = 35252 AND Y = 31310 AND Z = 16262 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670030' WHERE InstanceID = 'Taskdungeon304.1' AND X = 35754 AND Y = 33194 AND Z = 16004 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670031' WHERE InstanceID = 'Taskdungeon305.1' AND X = 30169 AND Y = 33955 AND Z = 15750 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670032' WHERE InstanceID = 'Taskdungeon306.1' AND X = 33621 AND Y = 28889 AND Z = 16008 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670033' WHERE InstanceID = 'Taskdungeon307.1' AND X = 30657 AND Y = 34272 AND Z = 16003 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670034' WHERE InstanceID = 'Taskdungeon308.1' AND X = 37627 AND Y = 30525 AND Z = 16521 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670035' WHERE InstanceID = 'Taskdungeon309.1' AND X = 31668 AND Y = 33351 AND Z = 16267 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670036' WHERE InstanceID = 'Taskdungeon310.1' AND X = 29945 AND Y = 29349 AND Z = 15998 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670037' WHERE InstanceID = 'Taskdungeon311.1' AND X = 34628 AND Y = 29137 AND Z = 16005 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670038' WHERE InstanceID = 'Taskdungeon312.1' AND X = 28808 AND Y = 31239 AND Z = 16005 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670039' WHERE InstanceID = 'Taskdungeon313.1' AND X = 37927 AND Y = 26757 AND Z = 15484 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670040' WHERE InstanceID = 'Taskdungeon314.1' AND X = 31917 AND Y = 36134 AND Z = 16003 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670041' WHERE InstanceID = 'Taskdungeon315.1' AND X = 35418 AND Y = 32882 AND Z = 15745 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670042' WHERE InstanceID = 'Taskdungeon316.1' AND X = 34185 AND Y = 34110 AND Z = 16264 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670043' WHERE InstanceID = 'Taskdungeon317.1' AND X = 29392 AND Y = 37014 AND Z = 15760 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670044' WHERE InstanceID = 'Taskdungeon318.1' AND X = 30829 AND Y = 30201 AND Z = 16262 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670045' WHERE InstanceID = 'Taskdungeon319.1' AND X = 37842 AND Y = 26504 AND Z = 15486 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670046' WHERE InstanceID = 'Taskdungeon320.1' AND X = 29401 AND Y = 35448 AND Z = 16002 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670047' WHERE InstanceID = 'Taskdungeon321.1' AND X = 29788 AND Y = 28988 AND Z = 16007 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670048' WHERE InstanceID = 'Taskdungeon322.1' AND X = 32791 AND Y = 28233 AND Z = 16006 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670049' WHERE InstanceID = 'Taskdungeon323.1' AND X = 28510 AND Y = 29617 AND Z = 16059 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670050' WHERE InstanceID = 'Taskdungeon324.1' AND X = 34965 AND Y = 30257 AND Z = 16004 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670051' WHERE InstanceID = 'Taskdungeon379.1' AND X = 29599 AND Y = 31904 AND Z = 16240 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670052' WHERE InstanceID = 'Taskdungeon382.1' AND X = 29286 AND Y = 34315 AND Z = 16240 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670053' WHERE InstanceID = 'Taskdungeon383.1' AND X = 34227 AND Y = 34839 AND Z = 16240 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670054' WHERE InstanceID = 'Taskdungeon386.1' AND X = 29338 AND Y = 35654 AND Z = 17056 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670055' WHERE InstanceID = 'Taskdungeon387.1' AND X = 27302 AND Y = 31434 AND Z = 15520 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670056' WHERE InstanceID = 'Taskdungeon388.1' AND X = 27139 AND Y = 29246 AND Z = 15520 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670057' WHERE InstanceID = 'Taskdungeon400.1' AND X = 28703 AND Y = 34183 AND Z = 16000 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670058' WHERE InstanceID = 'Taskdungeon401.1' AND X = 28824 AND Y = 28878 AND Z = 17070 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670059' WHERE InstanceID = 'Taskdungeon402.1' AND X = 32839 AND Y = 29251 AND Z = 15760 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670060' WHERE InstanceID = 'Taskdungeon403.1' AND X = 28260 AND Y = 35829 AND Z = 15760 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670061' WHERE InstanceID = 'Taskdungeon404.1' AND X = 34152 AND Y = 29254 AND Z = 16480 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670062' WHERE InstanceID = 'Taskdungeon405.1' AND X = 29091 AND Y = 33602 AND Z = 16003 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670063' WHERE InstanceID = 'Taskdungeon406.1' AND X = 33259 AND Y = 32943 AND Z = 15746 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670064' WHERE InstanceID = 'Taskdungeon407.1' AND X = 29380 AND Y = 33616 AND Z = 16002 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670065' WHERE InstanceID = 'Taskdungeon408.1' AND X = 30990 AND Y = 34645 AND Z = 15748 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670066' WHERE InstanceID = 'Taskdungeon409.1' AND X = 30403 AND Y = 35233 AND Z = 16266 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670067' WHERE InstanceID = 'Taskdungeon410.1' AND X = 29775 AND Y = 33483 AND Z = 16244 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670068' WHERE InstanceID = 'Taskdungeon411.1' AND X = 32146 AND Y = 35688 AND Z = 15988 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670069' WHERE InstanceID = 'Taskdungeon412.1' AND X = 28101 AND Y = 30989 AND Z = 15987 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670070' WHERE InstanceID = 'Taskdungeon413.1' AND X = 31813 AND Y = 36086 AND Z = 15988 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670071' WHERE InstanceID = 'Taskdungeon414.1' AND X = 29619 AND Y = 35313 AND Z = 15991 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670072' WHERE InstanceID = 'Taskdungeon415.1' AND X = 33604 AND Y = 34491 AND Z = 15999 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670073' WHERE InstanceID = 'Taskdungeon416.1' AND X = 32061 AND Y = 35489 AND Z = 16240 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670074' WHERE InstanceID = 'Taskdungeon417.1' AND X = 37502 AND Y = 33413 AND Z = 16480 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670075' WHERE InstanceID = 'Taskdungeon418.1' AND X = 31746 AND Y = 36467 AND Z = 16240 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670076' WHERE InstanceID = 'Taskdungeon419.1' AND X = 34576 AND Y = 35296 AND Z = 15472 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670077' WHERE InstanceID = 'Taskdungeon420.1' AND X = 28380 AND Y = 32355 AND Z = 16816 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670078' WHERE InstanceID = 'Taskdungeon421.1' AND X = 27155 AND Y = 26432 AND Z = 15520 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670079' WHERE InstanceID = 'Taskdungeon422.1' AND X = 33498 AND Y = 26616 AND Z = 15776 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670080' WHERE InstanceID = 'Taskdungeon424.1' AND X = 28889 AND Y = 34493 AND Z = 16512 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670081' WHERE InstanceID = 'Taskdungeon427.1' AND X = 33511 AND Y = 30324 AND Z = 16239 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670082' WHERE InstanceID = 'Taskdungeon428.1' AND X = 28889 AND Y = 31078 AND Z = 16239 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670083' WHERE InstanceID = 'Taskdungeon431.1' AND X = 28900 AND Y = 30319 AND Z = 16239 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670084' WHERE InstanceID = 'Taskdungeon432.1' AND X = 34024 AND Y = 34906 AND Z = 15988 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670085' WHERE InstanceID = 'Taskdungeon441.1' AND X = 29969 AND Y = 34473 AND Z = 15988 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670086' WHERE InstanceID = 'Taskdungeon444.1' AND X = 34230 AND Y = 34782 AND Z = 15990 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670087' WHERE InstanceID = 'Taskdungeon445.1' AND X = 30212 AND Y = 34789 AND Z = 16006 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670088' WHERE InstanceID = 'Taskdungeon448.1' AND X = 35087 AND Y = 29582 AND Z = 16259 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670089' WHERE InstanceID = 'Taskdungeon449.1' AND X = 34054 AND Y = 34885 AND Z = 16518 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670090' WHERE InstanceID = 'Taskdungeon450.1' AND X = 33668 AND Y = 30425 AND Z = 16239 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670091' WHERE InstanceID = 'Taskdungeon451.1' AND X = 30627 AND Y = 30209 AND Z = 16240 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670092' WHERE InstanceID = 'Taskdungeon452.1' AND X = 28807 AND Y = 29619 AND Z = 16000 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670093' WHERE InstanceID = 'Taskdungeon453.1' AND X = 27937 AND Y = 32719 AND Z = 16240 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670094' WHERE InstanceID = 'Taskdungeon454.1' AND X = 28732 AND Y = 33578 AND Z = 16480 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670095' WHERE InstanceID = 'Taskdungeon455.1' AND X = 32203 AND Y = 35821 AND Z = 15988 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670096' WHERE InstanceID = 'Taskdungeon456.1' AND X = 34351 AND Y = 27329 AND Z = 16244 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670097' WHERE InstanceID = 'Taskdungeon457.1' AND X = 29902 AND Y = 26190 AND Z = 16244 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670098' WHERE InstanceID = 'Taskdungeon458.1' AND X = 31231 AND Y = 36072 AND Z = 15712 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670099' WHERE InstanceID = 'Taskdungeon459.1' AND X = 28084 AND Y = 39088 AND Z = 15478 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670100' WHERE InstanceID = 'Taskdungeon460.1' AND X = 34493 AND Y = 34522 AND Z = 16262 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670101' WHERE InstanceID = 'Taskdungeon461.1' AND X = 36016 AND Y = 31095 AND Z = 16010 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670102' WHERE InstanceID = 'Taskdungeon462.1' AND X = 31613 AND Y = 35329 AND Z = 16268 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670103' WHERE InstanceID = 'Taskdungeon463.1' AND X = 24578 AND Y = 29206 AND Z = 16769 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670104' WHERE InstanceID = 'Taskdungeon464.1' AND X = 31866 AND Y = 35931 AND Z = 16776 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670105' WHERE InstanceID = 'Taskdungeon465.1' AND X = 30492 AND Y = 34910 AND Z = 16010 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670106' WHERE InstanceID = 'Taskdungeon466.1' AND X = 35394 AND Y = 32792 AND Z = 16258 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670107' WHERE InstanceID = 'Taskdungeon467.1' AND X = 34825 AND Y = 32872 AND Z = 16517 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670108' WHERE InstanceID = 'Taskdungeon468.1' AND X = 34134 AND Y = 35268 AND Z = 16010 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670109' WHERE InstanceID = 'Taskdungeon469.1' AND X = 31316 AND Y = 35320 AND Z = 16010 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670110' WHERE InstanceID = 'Taskdungeon471.1' AND X = 34151 AND Y = 34062 AND Z = 15987 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670111' WHERE InstanceID = 'Taskdungeon472.1' AND X = 34405 AND Y = 31241 AND Z = 15223 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670112' WHERE InstanceID = 'Taskdungeon473.1' AND X = 33905 AND Y = 34173 AND Z = 15220 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670113' WHERE InstanceID = 'Taskdungeon474.1' AND X = 31170 AND Y = 36072 AND Z = 15732 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670114' WHERE InstanceID = 'Taskdungeon477.1' AND X = 34720 AND Y = 35078 AND Z = 16262 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670115' WHERE InstanceID = 'Taskdungeon478.1' AND X = 33982 AND Y = 34820 AND Z = 16264 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670116' WHERE InstanceID = 'Taskdungeon481.1' AND X = 31857 AND Y = 35809 AND Z = 16267 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670117' WHERE InstanceID = 'Taskdungeon482.1' AND X = 30812 AND Y = 31473 AND Z = 15988 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670118' WHERE InstanceID = 'Taskdungeon485.1' AND X = 31912 AND Y = 33597 AND Z = 15986 LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670119' WHERE InstanceID = 'Taskdungeon486.1' AND X = 34368 AND Y = 31508 AND Z = 15222 LIMIT 1;
