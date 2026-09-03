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

-- and stand him where the old deepest creature stood
UPDATE instancexelement SET NPCTemplate = '999670000' WHERE InstanceID = 'TaskDungeon423.1' AND NPCTemplate = '60164942' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670001' WHERE InstanceID = 'Taskdungeon048.1' AND NPCTemplate = '60159244' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670002' WHERE InstanceID = 'Taskdungeon256.1' AND NPCTemplate = '13035' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670003' WHERE InstanceID = 'Taskdungeon257.1' AND NPCTemplate = '60158976' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670004' WHERE InstanceID = 'Taskdungeon258.1' AND NPCTemplate = '12241' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670005' WHERE InstanceID = 'Taskdungeon278.1' AND NPCTemplate = '60157817' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670006' WHERE InstanceID = 'Taskdungeon279.1' AND NPCTemplate = '12505' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670007' WHERE InstanceID = 'Taskdungeon280.1' AND NPCTemplate = '60159443' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670008' WHERE InstanceID = 'Taskdungeon281.1' AND NPCTemplate = '12018' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670009' WHERE InstanceID = 'Taskdungeon282.1' AND NPCTemplate = '12019' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670010' WHERE InstanceID = 'Taskdungeon283.1' AND NPCTemplate = '60165579' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670011' WHERE InstanceID = 'Taskdungeon284.1' AND NPCTemplate = '12426' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670012' WHERE InstanceID = 'Taskdungeon285.1' AND NPCTemplate = '12426' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670013' WHERE InstanceID = 'Taskdungeon286.1' AND NPCTemplate = '12424' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670014' WHERE InstanceID = 'Taskdungeon287.1' AND NPCTemplate = '60161124' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670015' WHERE InstanceID = 'Taskdungeon288.1' AND NPCTemplate = '60161124' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670016' WHERE InstanceID = 'Taskdungeon289.1' AND NPCTemplate = '60167525' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670017' WHERE InstanceID = 'Taskdungeon290.1' AND NPCTemplate = '60157869' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670018' WHERE InstanceID = 'Taskdungeon291.1' AND NPCTemplate = '60157869' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670019' WHERE InstanceID = 'Taskdungeon292.1' AND NPCTemplate = '60157996' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670020' WHERE InstanceID = 'Taskdungeon293.1' AND NPCTemplate = '12217' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670021' WHERE InstanceID = 'Taskdungeon294.1' AND NPCTemplate = '12053' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670022' WHERE InstanceID = 'Taskdungeon295.1' AND NPCTemplate = '12380' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670023' WHERE InstanceID = 'Taskdungeon296.1' AND NPCTemplate = '60164091' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670024' WHERE InstanceID = 'Taskdungeon297.1' AND NPCTemplate = '60166609' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670025' WHERE InstanceID = 'Taskdungeon298.1' AND NPCTemplate = '60164093' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670026' WHERE InstanceID = 'Taskdungeon300.1' AND NPCTemplate = '12229' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670027' WHERE InstanceID = 'Taskdungeon301.1' AND NPCTemplate = '12352' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670028' WHERE InstanceID = 'Taskdungeon302.1' AND NPCTemplate = '546789' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670029' WHERE InstanceID = 'Taskdungeon303.1' AND NPCTemplate = '12545' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670030' WHERE InstanceID = 'Taskdungeon304.1' AND NPCTemplate = '60157821' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670031' WHERE InstanceID = 'Taskdungeon305.1' AND NPCTemplate = '12019' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670032' WHERE InstanceID = 'Taskdungeon306.1' AND NPCTemplate = '12018' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670033' WHERE InstanceID = 'Taskdungeon307.1' AND NPCTemplate = '12018' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670034' WHERE InstanceID = 'Taskdungeon308.1' AND NPCTemplate = '60161312' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670035' WHERE InstanceID = 'Taskdungeon309.1' AND NPCTemplate = '12018' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670036' WHERE InstanceID = 'Taskdungeon310.1' AND NPCTemplate = '12425' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670037' WHERE InstanceID = 'Taskdungeon311.1' AND NPCTemplate = '60161453' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670038' WHERE InstanceID = 'Taskdungeon312.1' AND NPCTemplate = '12432' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670039' WHERE InstanceID = 'Taskdungeon313.1' AND NPCTemplate = '12429' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670040' WHERE InstanceID = 'Taskdungeon314.1' AND NPCTemplate = '12429' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670041' WHERE InstanceID = 'Taskdungeon315.1' AND NPCTemplate = '60161124' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670042' WHERE InstanceID = 'Taskdungeon316.1' AND NPCTemplate = '60161124' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670043' WHERE InstanceID = 'Taskdungeon317.1' AND NPCTemplate = '60161124' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670044' WHERE InstanceID = 'Taskdungeon318.1' AND NPCTemplate = '60161124' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670045' WHERE InstanceID = 'Taskdungeon319.1' AND NPCTemplate = '60161074' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670046' WHERE InstanceID = 'Taskdungeon320.1' AND NPCTemplate = '60161038' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670047' WHERE InstanceID = 'Taskdungeon321.1' AND NPCTemplate = '60160833' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670048' WHERE InstanceID = 'Taskdungeon322.1' AND NPCTemplate = '60158590' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670049' WHERE InstanceID = 'Taskdungeon323.1' AND NPCTemplate = '60157996' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670050' WHERE InstanceID = 'Taskdungeon324.1' AND NPCTemplate = '60161038' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670051' WHERE InstanceID = 'Taskdungeon379.1' AND NPCTemplate = '60161241' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670052' WHERE InstanceID = 'Taskdungeon382.1' AND NPCTemplate = '60167272' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670053' WHERE InstanceID = 'Taskdungeon383.1' AND NPCTemplate = '60159117' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670054' WHERE InstanceID = 'Taskdungeon386.1' AND NPCTemplate = '60160322' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670055' WHERE InstanceID = 'Taskdungeon387.1' AND NPCTemplate = '60160321' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670056' WHERE InstanceID = 'Taskdungeon388.1' AND NPCTemplate = '60161297' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670057' WHERE InstanceID = 'Taskdungeon400.1' AND NPCTemplate = '12040' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670058' WHERE InstanceID = 'Taskdungeon401.1' AND NPCTemplate = '60160248' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670059' WHERE InstanceID = 'Taskdungeon402.1' AND NPCTemplate = '12412' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670060' WHERE InstanceID = 'Taskdungeon403.1' AND NPCTemplate = '12634' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670061' WHERE InstanceID = 'Taskdungeon404.1' AND NPCTemplate = '12623' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670062' WHERE InstanceID = 'Taskdungeon405.1' AND NPCTemplate = '60162039' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670063' WHERE InstanceID = 'Taskdungeon406.1' AND NPCTemplate = '60164092' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670064' WHERE InstanceID = 'Taskdungeon407.1' AND NPCTemplate = '60164092' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670065' WHERE InstanceID = 'Taskdungeon408.1' AND NPCTemplate = '60164092' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670066' WHERE InstanceID = 'Taskdungeon409.1' AND NPCTemplate = '60164092' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670067' WHERE InstanceID = 'Taskdungeon410.1' AND NPCTemplate = '12603' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670068' WHERE InstanceID = 'Taskdungeon411.1' AND NPCTemplate = '35003' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670069' WHERE InstanceID = 'Taskdungeon412.1' AND NPCTemplate = '35002' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670070' WHERE InstanceID = 'Taskdungeon413.1' AND NPCTemplate = '35002' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670071' WHERE InstanceID = 'Taskdungeon414.1' AND NPCTemplate = '60161457' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670072' WHERE InstanceID = 'Taskdungeon415.1' AND NPCTemplate = '60159117' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670073' WHERE InstanceID = 'Taskdungeon416.1' AND NPCTemplate = '60159120' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670074' WHERE InstanceID = 'Taskdungeon417.1' AND NPCTemplate = '60161307' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670075' WHERE InstanceID = 'Taskdungeon418.1' AND NPCTemplate = '60161241' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670076' WHERE InstanceID = 'Taskdungeon419.1' AND NPCTemplate = '60159119' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670077' WHERE InstanceID = 'Taskdungeon420.1' AND NPCTemplate = '60164943' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670078' WHERE InstanceID = 'Taskdungeon421.1' AND NPCTemplate = '60166043' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670079' WHERE InstanceID = 'Taskdungeon422.1' AND NPCTemplate = '60160322' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670080' WHERE InstanceID = 'Taskdungeon424.1' AND NPCTemplate = '60165973' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670081' WHERE InstanceID = 'Taskdungeon427.1' AND NPCTemplate = '12638' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670082' WHERE InstanceID = 'Taskdungeon428.1' AND NPCTemplate = '12147' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670083' WHERE InstanceID = 'Taskdungeon431.1' AND NPCTemplate = '12053' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670084' WHERE InstanceID = 'Taskdungeon432.1' AND NPCTemplate = '12492' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670085' WHERE InstanceID = 'Taskdungeon441.1' AND NPCTemplate = '60164985' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670086' WHERE InstanceID = 'Taskdungeon444.1' AND NPCTemplate = '12868' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670087' WHERE InstanceID = 'Taskdungeon445.1' AND NPCTemplate = '60167177' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670088' WHERE InstanceID = 'Taskdungeon448.1' AND NPCTemplate = '60158317' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670089' WHERE InstanceID = 'Taskdungeon449.1' AND NPCTemplate = '60165180' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670090' WHERE InstanceID = 'Taskdungeon450.1' AND NPCTemplate = '200' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670091' WHERE InstanceID = 'Taskdungeon451.1' AND NPCTemplate = '12411' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670092' WHERE InstanceID = 'Taskdungeon452.1' AND NPCTemplate = '12636' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670093' WHERE InstanceID = 'Taskdungeon453.1' AND NPCTemplate = '12380' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670094' WHERE InstanceID = 'Taskdungeon454.1' AND NPCTemplate = '12540' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670095' WHERE InstanceID = 'Taskdungeon455.1' AND NPCTemplate = '60158986' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670096' WHERE InstanceID = 'Taskdungeon456.1' AND NPCTemplate = '60165169' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670097' WHERE InstanceID = 'Taskdungeon457.1' AND NPCTemplate = '60165169' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670098' WHERE InstanceID = 'Taskdungeon458.1' AND NPCTemplate = '60158985' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670099' WHERE InstanceID = 'Taskdungeon459.1' AND NPCTemplate = '12870' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670100' WHERE InstanceID = 'Taskdungeon460.1' AND NPCTemplate = '60162045' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670101' WHERE InstanceID = 'Taskdungeon461.1' AND NPCTemplate = '60163955' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670102' WHERE InstanceID = 'Taskdungeon462.1' AND NPCTemplate = '60163955' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670103' WHERE InstanceID = 'Taskdungeon463.1' AND NPCTemplate = '60162045' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670104' WHERE InstanceID = 'Taskdungeon464.1' AND NPCTemplate = '60162010' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670105' WHERE InstanceID = 'Taskdungeon465.1' AND NPCTemplate = '60168034' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670106' WHERE InstanceID = 'Taskdungeon466.1' AND NPCTemplate = '60161124' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670107' WHERE InstanceID = 'Taskdungeon467.1' AND NPCTemplate = '60163082' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670108' WHERE InstanceID = 'Taskdungeon468.1' AND NPCTemplate = '60158317' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670109' WHERE InstanceID = 'Taskdungeon469.1' AND NPCTemplate = '60158317' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670110' WHERE InstanceID = 'Taskdungeon471.1' AND NPCTemplate = '12978' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670111' WHERE InstanceID = 'Taskdungeon472.1' AND NPCTemplate = '60157996' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670112' WHERE InstanceID = 'Taskdungeon473.1' AND NPCTemplate = '12766' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670113' WHERE InstanceID = 'Taskdungeon474.1' AND NPCTemplate = '12979' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670114' WHERE InstanceID = 'Taskdungeon477.1' AND NPCTemplate = '60162045' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670115' WHERE InstanceID = 'Taskdungeon478.1' AND NPCTemplate = '60162039' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670116' WHERE InstanceID = 'Taskdungeon481.1' AND NPCTemplate = '60163955' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670117' WHERE InstanceID = 'Taskdungeon482.1' AND NPCTemplate = '60159244' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670118' WHERE InstanceID = 'Taskdungeon485.1' AND NPCTemplate = '60158590' ORDER BY InstanceXElement_ID LIMIT 1;
UPDATE instancexelement SET NPCTemplate = '999670119' WHERE InstanceID = 'Taskdungeon486.1' AND NPCTemplate = '60158590' ORDER BY InstanceXElement_ID LIMIT 1;
