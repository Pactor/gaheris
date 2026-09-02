-- Connect the scrolls to the artifacts.
--
-- Selling scrolls was only half a fix. ArtifactMgr.GetPageNumbers decides
-- which page of which artifact a scroll is by comparing the item's NAME
-- against artifact.Scroll1/2/3, and our artifact rows carried placeholders --
-- Dream_Sphere1, Alvarus_Leggings1 -- that match no item in the database. All
-- 57 artifacts scored zero. Every scroll on the merchant would have been inert
-- paper that never combined into anything.
--
-- Three things were wrong and all three are fixed here.
--
-- 1. The generic template ArtifactMgr renames into a scroll did not exist.
--    CreatePages calls CreateUniqueFromTemplate("artifact_scroll"), gets null
--    back, and returns null -- so even combining two correct scrolls produced
--    nothing at all. Created below from the shape of a real scroll.
--
-- 2. GetPageNumbers also requires Object_Type = Magical (41). Every scroll in
--    itemtemplate carried Object_Type = 0, generic. Item_Type was already 40,
--    FirstBackpack, which is the other half of that test.
--
-- 3. artifact.Scroll1/2/3 now name the real scrolls. The pairs -- Scroll12,
--    Scroll13, Scroll23 -- are the intermediate items you get from combining
--    two of three, and need no templates of their own: CreatePages builds them
--    by renaming, so they only have to be unique and readable.
--
-- The pairing came from the official artifact database rather than from
-- matching words, because most sets are named for the story and not the
-- artifact -- Malice Axe is Story of Malice, Traitor's Dagger is Wall Glyph
-- Pieces, Dream Sphere is Loukas' Journal. Word matching reached 30 of 57 and
-- had Healer's Embrace on Healer's Notes, which is Eternal Plant's set.

DELETE FROM itemtemplate WHERE Id_nb = 'artifact_scroll';

CREATE TEMPORARY TABLE _scroll_seed AS
SELECT * FROM itemtemplate WHERE Id_nb = 'Alvarus_Letter,_part_1_of_3';

-- ItemTemplate_ID is unique, and a straight copy of the row brings the
-- original's along with it.
UPDATE _scroll_seed
   SET Id_nb = 'artifact_scroll', Name = 'artifact scroll', Model = 499,
       Object_Type = 41, Item_Type = 40, Level = 50, Price = 0,
       IsDropable = 1, IsPickable = 1, IsTradable = 1,
       ItemTemplate_ID = UUID();

INSERT INTO itemtemplate SELECT * FROM _scroll_seed;
DROP TEMPORARY TABLE _scroll_seed;

UPDATE itemtemplate SET Object_Type = 41 WHERE Id_nb IN (
  'A_Love_Story,_part_1_of_3',
  'A_Love_Story,_part_2_of_3',
  'A_Love_Story,_part_3_of_3',
  'Adness_Letter,_1_of_3',
  'Adness_Letter,_2_of_3',
  'Adness_Letter,_3_of_3',
  'Advisors_Log,_page_1_of_3',
  'Advisors_Log,_page_2_of_3',
  'Advisors_Log,_page_3_of_3',
  'Alvarus_Letter,_part_1_of_3',
  'Alvarus_Letter,_part_2_of_3',
  'Alvarus_Letter,_part_3_of_3',
  'Apprentice_Notes,_1_of_3',
  'Apprentice_Notes,_2_of_3',
  'Apprentice_Notes,_3_of_3',
  'Arbiter_Papers,_1_of_3',
  'Arbiter_Papers,_2_of_3',
  'Arbitors_Paper,_3_of_3',
  'Bane_of_Battler,_1_of_3',
  'Bane_of_Battler,_2_of_3',
  'Bane_of_Battler,_3_of_3',
  'Bellona''s_Diary,_page_1_of_3',
  'Bellona''s_Diary,_page_2_of_3',
  'Bellona''s_Diary,_page_3_of_3',
  'Belt_of_moon_1_of_3',
  'Belt_of_moon_2_of_3',
  'Belt_of_moon_3_of_3',
  'Bence''s_Letter,_1_of_3',
  'Bence''s_Letter,_2_of_3',
  'Bence''s_Letter,_3_of_3',
  'Bronze_Fish_Scale,_2_of_3',
  'Carved_Tablet,_1_of_3',
  'Carved_Tablet,_2_of_3',
  'Carved_Tablet,_3_of_3',
  'Champion''s_Notes,_1_of_3',
  'Champion''s_Notes,_2_of_3',
  'Champion''s_Notes,_3_of_3',
  'Cloudsong,_1_of_3',
  'Cloudsong,_2_of_3',
  'Cloudsong,_3_of_3',
  'Crafter''s_Pages,_1_of_3',
  'Crafter''s_Pages,_2_of_3',
  'Crafter''s_Pages,_3_of_3',
  'Damyons_Journal,_1_of_3',
  'Damyons_Journal,_2_of_3',
  'Damyons_Journal,_3_of_3',
  'Dysis_Tablet,_piece_1_of_3',
  'Dysis_Tablet,_piece_2_of_3',
  'Dysis_Tablet,_piece_3_of_3',
  'Egg_of_Youth,_Scroll_1_of_3',
  'Egg_of_Youth,_Scroll_2_of_3',
  'Egg_of_Youth,_Scroll_3_of_3',
  'Eirenes_Journal,_page_1_of_3',
  'Eirenes_Journal,_page_2_of_3',
  'Eirenes_Journal,_page_3_of_3',
  'Enyalios_Boots,_1_of_3',
  'Enyalios_Boots,_2_of_3',
  'Enyalios_Boots,_3_of_3',
  'Fool''s_Bow_1_of_3',
  'Fool''s_Bow_2_of_3',
  'Fool''s_Bow_3_of_3',
  'Foppish_Sleeves,_1_of_3',
  'Foppish_Sleeves,_2_of_3',
  'Foppish_Sleeves,_3_of_3',
  'Gem_of_Lost_Memories_1_of_3',
  'Gem_of_Lost_Memories_2_of_3',
  'Gem_of_Lost_Memories_3_of_3',
  'Gold_Fish_Scale,_3_of_3',
  'Great_Hunt,_scroll_1_of_3',
  'Great_Hunt,_scroll_2_of_3',
  'Great_Hunt,_scroll_3_of_3',
  'Healer''s_Notes,_1_of_3',
  'Healer''s_Notes,_2_of_3',
  'Healer''s_Notes,_3_of_3',
  'Inscribed_Stone,_1_of_3',
  'Inscribed_Stone,_2_of_3',
  'Inscribed_Stone,_3_of_3',
  'Juleas_Story,_part_1_of_3',
  'Juleas_Story,_part_2_of_3',
  'Juleas_Story,_part_3_of_3',
  'Kalares_Memoirs,_page_1_of_3',
  'Kalares_Memoirs,_page_2_of_3',
  'Kalares_Memoirs,_page_3_of_3',
  'King''s_Vase,_piece_1_of_3',
  'King''s_Vase,_piece_2_of_3',
  'King''s_Vase,_piece_3_of_3',
  'Loukas''_Journal,_volume_1_of_3',
  'Loukas''_Journal,_volume_2_of_3',
  'Loukas''_Journal,_volume_3_of_3',
  'Mad_Tales,_1_of_3',
  'Mad_Tales,_2_of_3',
  'Mad_Tales,_3_of_3',
  'Mariashas_Wall,_piece_1_of_3',
  'Mariashas_Wall,_piece_2_of_3',
  'Mariashas_Wall,_piece_3_of_3',
  'Marricus_Journal,_part_1_of_3',
  'Marricus_Journal,_part_2_of_3',
  'Marricus_Journal,_part_3_of_3',
  'Nailah''s_Diary,_page_1_of_3',
  'Nailah''s_Diary,_page_2_of_3',
  'Nailah''s_Diary,_page_3_of_3',
  'Oglidarshs_Scrolls,_1_of_3',
  'Oglidarshs_Scrolls,_2_of_3',
  'Oglidarshs_Scrolls,_3_of_3',
  'Phoebus_Letters,_1_of_3',
  'Phoebus_Letters,_2_of_3',
  'Phoebus_Letters,_3_of_3',
  'Regarding_Shades,_1_of_3',
  'Regarding_Shades,_2_of_3',
  'Regarding_Shades,_3_of_3',
  'Ring_of_Fire,_Scroll_1_of_3',
  'Ring_of_Fire,_Scroll_2_of_3',
  'Ring_of_Fire,_Scroll_3_of_3',
  'Scholar''s_Notes,_1_of_3',
  'Scholar''s_Notes,_2_of_3',
  'Scholar''s_Notes,_3_of_3',
  'Silvery_Fish_Scale,_1_of_3',
  'Snatcher''s_Tale,_1_of_3',
  'Snatcher''s_Tale,_2_of_3',
  'Snatcher''s_Tale,_3_of_3',
  'Song_of_Erinys,_1_of_3',
  'Song_of_Erinys,_2_of_3',
  'Song_of_Erinys,_3_of_3',
  'Spear''s_History,_part_1_of_3',
  'Spear''s_History,_part_2_of_3',
  'Spear''s_History,_part_3_of_3',
  'Spear_of_Kings,_piece_1_of_3',
  'Spear_of_Kings,_piece_2_of_3',
  'Spear_of_Kings,_piece_3_of_3',
  'Staff_of_God,_Parchment_1_of_3',
  'Staff_of_God,_Parchment_2_of_3',
  'Staff_of_God,_Parchment_3_of_3',
  'Story_of_Malice,_1_of_3',
  'Story_of_Malice,_2_of_3',
  'Story_of_Malice,_3_of_3',
  'Tarin''s_Animal_Skin,_1_of_3',
  'Tarin''s_Animal_Skin,_2_of_3',
  'Tarin''s_Animal_Skin,_3_of_3',
  'Tartaros''_Gift,_1_of_3',
  'Tartaros''_Gift,_2_of_3',
  'Tartaros''_Gift,_3_of_3',
  'Traldor''s_Oracle,_1_of_3',
  'Traldor''s_Oracle_2_of_3',
  'Traldor''s_Oracle_3_of_3',
  'Tribute_to_Adauron,_1_of_3',
  'Tribute_to_Adauron,_2_of_3',
  'Tribute_to_Adauron,_3_of_3',
  'Tyrus''s_Epic_Poem,_part_1_of_3',
  'Tyrus''s_Epic_Poem,_part_2_of_3',
  'Tyrus''s_Epic_Poem,_part_3_of_3',
  'Varas_Medical_Log,_pg._1_of_3',
  'Varas_Medical_Log,_pg._2_of_3',
  'Varas_Medical_Log,_pg._3_of_3',
  'Wall_Glyph_Pieces,_1_of_3',
  'Wall_Glyph_Pieces,_2_of_3',
  'Wall_Glyph_Pieces,_3_of_3',
  'Wings_Dive,_1_of_3',
  'Wings_Dive,_2_of_3',
  'Wings_Dive,_3_of_3',
  'Wooden_Triptych,_part_1_of_3',
  'Wooden_Triptych,_part_2_of_3',
  'Wooden_Triptych,_part_3_of_3');

UPDATE artifact SET
     Scroll1  = 'Alvarus'' Letter, part 1 of 3',
     Scroll2  = 'Alvarus'' Letter, part 2 of 3',
     Scroll3  = 'Alvarus'' Letter, part 3 of 3',
     Scroll12 = 'Alvarus'' Letter, parts 1 and 2 of 3',
     Scroll13 = 'Alvarus'' Letter, parts 1 and 3 of 3',
     Scroll23 = 'Alvarus'' Letter, parts 2 and 3 of 3'
 WHERE ArtifactID = '1001';
UPDATE artifact SET
     Scroll1  = 'Silvery Fish Scale, 1 of 3',
     Scroll2  = 'Bronze Fish Scale, 2 of 3',
     Scroll3  = 'Gold Fish Scale, 3 of 3',
     Scroll12 = 'Fish Scales, parts 1 and 2 of 3',
     Scroll13 = 'Fish Scales, parts 1 and 3 of 3',
     Scroll23 = 'Fish Scales, parts 2 and 3 of 3'
 WHERE ArtifactID = '1002';
UPDATE artifact SET
     Scroll1  = 'Champion''s Notes, 1 of 3',
     Scroll2  = 'Champion''s Notes, 2 of 3',
     Scroll3  = 'Champion''s Notes, 3 of 3',
     Scroll12 = 'Champion''s Notes, parts 1 and 2 of 3',
     Scroll13 = 'Champion''s Notes, parts 1 and 3 of 3',
     Scroll23 = 'Champion''s Notes, parts 2 and 3 of 3'
 WHERE ArtifactID = '1003';
UPDATE artifact SET
     Scroll1  = 'King''s Vase, piece 1 of 3',
     Scroll2  = 'King''s Vase, piece 2 of 3',
     Scroll3  = 'King''s Vase, piece 3 of 3',
     Scroll12 = 'King''s Vase, parts 1 and 2 of 3',
     Scroll13 = 'King''s Vase, parts 1 and 3 of 3',
     Scroll23 = 'King''s Vase, parts 2 and 3 of 3'
 WHERE ArtifactID = '1005';
UPDATE artifact SET
     Scroll1  = 'Bane of Battler, 1 of 3',
     Scroll2  = 'Bane of Battler, 2 of 3',
     Scroll3  = 'Bane of Battler, 3 of 3',
     Scroll12 = 'Bane of Battler, parts 1 and 2 of 3',
     Scroll13 = 'Bane of Battler, parts 1 and 3 of 3',
     Scroll23 = 'Bane of Battler, parts 2 and 3 of 3'
 WHERE ArtifactID = '1006';
UPDATE artifact SET
     Scroll1  = 'Belt of moon 1 of 3',
     Scroll2  = 'Belt of moon 2 of 3',
     Scroll3  = 'Belt of moon 3 of 3',
     Scroll12 = 'Belt of, parts 1 and 2 of 3',
     Scroll13 = 'Belt of, parts 1 and 3 of 3',
     Scroll23 = 'Belt of, parts 2 and 3 of 3'
 WHERE ArtifactID = '1007';
UPDATE artifact SET
     Scroll1  = 'Scholar''s Notes, 1 of 3',
     Scroll2  = 'Scholar''s Notes, 2 of 3',
     Scroll3  = 'Scholar''s Notes, 3 of 3',
     Scroll12 = 'Scholar''s Notes, parts 1 and 2 of 3',
     Scroll13 = 'Scholar''s Notes, parts 1 and 3 of 3',
     Scroll23 = 'Scholar''s Notes, parts 2 and 3 of 3'
 WHERE ArtifactID = '1008';
UPDATE artifact SET
     Scroll1  = 'Apprentice Notes, 1 of 3',
     Scroll2  = 'Apprentice Notes, 2 of 3',
     Scroll3  = 'Apprentice Notes, 3 of 3',
     Scroll12 = 'Apprentice Notes, parts 1 and 2 of 3',
     Scroll13 = 'Apprentice Notes, parts 1 and 3 of 3',
     Scroll23 = 'Apprentice Notes, parts 2 and 3 of 3'
 WHERE ArtifactID = '1009';
UPDATE artifact SET
     Scroll1  = 'Carved Tablet, 1 of 3',
     Scroll2  = 'Carved Tablet, 2 of 3',
     Scroll3  = 'Carved Tablet, 3 of 3',
     Scroll12 = 'Carved Tablet, parts 1 and 2 of 3',
     Scroll13 = 'Carved Tablet, parts 1 and 3 of 3',
     Scroll23 = 'Carved Tablet, parts 2 and 3 of 3'
 WHERE ArtifactID = '1010';
UPDATE artifact SET
     Scroll1  = 'Arbiter Papers, 1 of 3',
     Scroll2  = 'Arbiter Papers, 2 of 3',
     Scroll3  = 'Arbitors Paper, 3 of 3',
     Scroll12 = 'Arbiter Papers, parts 1 and 2 of 3',
     Scroll13 = 'Arbiter Papers, parts 1 and 3 of 3',
     Scroll23 = 'Arbiter Papers, parts 2 and 3 of 3'
 WHERE ArtifactID = '1012';
UPDATE artifact SET
     Scroll1  = 'Cloudsong, 1 of 3',
     Scroll2  = 'Cloudsong, 2 of 3',
     Scroll3  = 'Cloudsong, 3 of 3',
     Scroll12 = 'Cloudsong, parts 1 and 2 of 3',
     Scroll13 = 'Cloudsong, parts 1 and 3 of 3',
     Scroll23 = 'Cloudsong, parts 2 and 3 of 3'
 WHERE ArtifactID = '1013';
UPDATE artifact SET
     Scroll1  = 'Tyrus''s Epic Poem, part 1 of 3',
     Scroll2  = 'Tyrus''s Epic Poem, part 2 of 3',
     Scroll3  = 'Tyrus''s Epic Poem, part 3 of 3',
     Scroll12 = 'Tyrus''s Epic Poem, parts 1 and 2 of 3',
     Scroll13 = 'Tyrus''s Epic Poem, parts 1 and 3 of 3',
     Scroll23 = 'Tyrus''s Epic Poem, parts 2 and 3 of 3'
 WHERE ArtifactID = '1014';
UPDATE artifact SET
     Scroll1  = 'Marricus'' Journal, part 1 of 3',
     Scroll2  = 'Marricus'' Journal, part 2 of 3',
     Scroll3  = 'Marricus'' Journal, part 3 of 3',
     Scroll12 = 'Marricus'' Journal, parts 1 and 2 of 3',
     Scroll13 = 'Marricus'' Journal, parts 1 and 3 of 3',
     Scroll23 = 'Marricus'' Journal, parts 2 and 3 of 3'
 WHERE ArtifactID = '1015';
UPDATE artifact SET
     Scroll1  = 'Advisor''s Log, page 1 of 3',
     Scroll2  = 'Advisor''s Log, page 2 of 3',
     Scroll3  = 'Advisor''s Log, page 3 of 3',
     Scroll12 = 'Advisor''s Log, parts 1 and 2 of 3',
     Scroll13 = 'Advisor''s Log, parts 1 and 3 of 3',
     Scroll23 = 'Advisor''s Log, parts 2 and 3 of 3'
 WHERE ArtifactID = '1016';
UPDATE artifact SET
     Scroll1  = 'Damyon''s Journal, 1 of 3',
     Scroll2  = 'Damyon''s Journal, 2 of 3',
     Scroll3  = 'Damyon''s Journal, 3 of 3',
     Scroll12 = 'Damyon''s Journal, parts 1 and 2 of 3',
     Scroll13 = 'Damyon''s Journal, parts 1 and 3 of 3',
     Scroll23 = 'Damyon''s Journal, parts 2 and 3 of 3'
 WHERE ArtifactID = '1017';
UPDATE artifact SET
     Scroll1  = 'Loukas'' Journal, volume 1 of 3',
     Scroll2  = 'Loukas'' Journal, volume 2 of 3',
     Scroll3  = 'Loukas'' Journal, volume 3 of 3',
     Scroll12 = 'Loukas'' Journal, parts 1 and 2 of 3',
     Scroll13 = 'Loukas'' Journal, parts 1 and 3 of 3',
     Scroll23 = 'Loukas'' Journal, parts 2 and 3 of 3'
 WHERE ArtifactID = '1018';
UPDATE artifact SET
     Scroll1  = 'Crafter''s Pages, 1 of 3',
     Scroll2  = 'Crafter''s Pages, 2 of 3',
     Scroll3  = 'Crafter''s Pages, 3 of 3',
     Scroll12 = 'Crafter''s Pages, parts 1 and 2 of 3',
     Scroll13 = 'Crafter''s Pages, parts 1 and 3 of 3',
     Scroll23 = 'Crafter''s Pages, parts 2 and 3 of 3'
 WHERE ArtifactID = '1019';
UPDATE artifact SET
     Scroll1  = 'Egg of Youth, Scroll 1 of 3',
     Scroll2  = 'Egg of Youth, Scroll 2 of 3',
     Scroll3  = 'Egg of Youth, Scroll 3 of 3',
     Scroll12 = 'Egg of Youth, parts 1 and 2 of 3',
     Scroll13 = 'Egg of Youth, parts 1 and 3 of 3',
     Scroll23 = 'Egg of Youth, parts 2 and 3 of 3'
 WHERE ArtifactID = '1020';
UPDATE artifact SET
     Scroll1  = 'Eirene''s Journal, page 1 of 3',
     Scroll2  = 'Eirene''s Journal, page 2 of 3',
     Scroll3  = 'Eirene''s Journal, page 3 of 3',
     Scroll12 = 'Eirene''s Journal, parts 1 and 2 of 3',
     Scroll13 = 'Eirene''s Journal, parts 1 and 3 of 3',
     Scroll23 = 'Eirene''s Journal, parts 2 and 3 of 3'
 WHERE ArtifactID = '1021';
UPDATE artifact SET
     Scroll1  = 'Enyalios'' Boots, 1 of 3',
     Scroll2  = 'Enyalios'' Boots, 2 of 3',
     Scroll3  = 'Enyalios'' Boots, 3 of 3',
     Scroll12 = 'Enyalios'' Boots, parts 1 and 2 of 3',
     Scroll13 = 'Enyalios'' Boots, parts 1 and 3 of 3',
     Scroll23 = 'Enyalios'' Boots, parts 2 and 3 of 3'
 WHERE ArtifactID = '1022';
UPDATE artifact SET
     Scroll1  = 'Song of Erinys, 1 of 3',
     Scroll2  = 'Song of Erinys, 2 of 3',
     Scroll3  = 'Song of Erinys, 3 of 3',
     Scroll12 = 'Song of Erinys, parts 1 and 2 of 3',
     Scroll13 = 'Song of Erinys, parts 1 and 3 of 3',
     Scroll23 = 'Song of Erinys, parts 2 and 3 of 3'
 WHERE ArtifactID = '1023';
UPDATE artifact SET
     Scroll1  = 'Healer''s Notes, 1 of 3',
     Scroll2  = 'Healer''s Notes, 2 of 3',
     Scroll3  = 'Healer''s Notes, 3 of 3',
     Scroll12 = 'Healer''s Notes, parts 1 and 2 of 3',
     Scroll13 = 'Healer''s Notes, parts 1 and 3 of 3',
     Scroll23 = 'Healer''s Notes, parts 2 and 3 of 3'
 WHERE ArtifactID = '1024';
UPDATE artifact SET
     Scroll1  = 'Fool''s Bow 1 of 3',
     Scroll2  = 'Fool''s Bow 2 of 3',
     Scroll3  = 'Fool''s Bow 3 of 3',
     Scroll12 = 'Fool''s, parts 1 and 2 of 3',
     Scroll13 = 'Fool''s, parts 1 and 3 of 3',
     Scroll23 = 'Fool''s, parts 2 and 3 of 3'
 WHERE ArtifactID = '1025';
UPDATE artifact SET
     Scroll1  = 'Foppish Sleeves, 1 of 3',
     Scroll2  = 'Foppish Sleeves, 2 of 3',
     Scroll3  = 'Foppish Sleeves, 3 of 3',
     Scroll12 = 'Foppish Sleeves, parts 1 and 2 of 3',
     Scroll13 = 'Foppish Sleeves, parts 1 and 3 of 3',
     Scroll23 = 'Foppish Sleeves, parts 2 and 3 of 3'
 WHERE ArtifactID = '1026';
UPDATE artifact SET
     Scroll1  = 'Spear''s History, part 1 of 3',
     Scroll2  = 'Spear''s History, part 2 of 3',
     Scroll3  = 'Spear''s History, part 3 of 3',
     Scroll12 = 'Spear''s History, parts 1 and 2 of 3',
     Scroll13 = 'Spear''s History, parts 1 and 3 of 3',
     Scroll23 = 'Spear''s History, parts 2 and 3 of 3'
 WHERE ArtifactID = '1028';
UPDATE artifact SET
     Scroll1  = 'A Love Story, part 1 of 3',
     Scroll2  = 'A Love Story, part 2 of 3',
     Scroll3  = 'A Love Story, part 3 of 3',
     Scroll12 = 'A Love Story, parts 1 and 2 of 3',
     Scroll13 = 'A Love Story, parts 1 and 3 of 3',
     Scroll23 = 'A Love Story, parts 2 and 3 of 3'
 WHERE ArtifactID = '1029';
UPDATE artifact SET
     Scroll1  = 'Bence''s Letter, 1 of 3',
     Scroll2  = 'Bence''s Letter, 2 of 3',
     Scroll3  = 'Bence''s Letter, 3 of 3',
     Scroll12 = 'Bence''s Letter, parts 1 and 2 of 3',
     Scroll13 = 'Bence''s Letter, parts 1 and 3 of 3',
     Scroll23 = 'Bence''s Letter, parts 2 and 3 of 3'
 WHERE ArtifactID = '1030';
UPDATE artifact SET
     Scroll1  = 'Bellona''s Diary, page 1 of 3',
     Scroll2  = 'Bellona''s Diary, page 2 of 3',
     Scroll3  = 'Bellona''s Diary, page 3 of 3',
     Scroll12 = 'Bellona''s Diary, parts 1 and 2 of 3',
     Scroll13 = 'Bellona''s Diary, parts 1 and 3 of 3',
     Scroll23 = 'Bellona''s Diary, parts 2 and 3 of 3'
 WHERE ArtifactID = '1031';
UPDATE artifact SET
     Scroll1  = 'Vara''s Medical Log, pg. 1 of 3',
     Scroll2  = 'Vara''s Medical Log, pg. 2 of 3',
     Scroll3  = 'Vara''s Medical Log, pg. 3 of 3',
     Scroll12 = 'Vara''s Medical Log, parts 1 and 2 of 3',
     Scroll13 = 'Vara''s Medical Log, parts 1 and 3 of 3',
     Scroll23 = 'Vara''s Medical Log, parts 2 and 3 of 3'
 WHERE ArtifactID = '1032';
UPDATE artifact SET
     Scroll1  = 'Tarin''s Animal Skin, 1 of 3',
     Scroll2  = 'Tarin''s Animal Skin, 2 of 3',
     Scroll3  = 'Tarin''s Animal Skin, 3 of 3',
     Scroll12 = 'Tarin''s Animal Skin, parts 1 and 2 of 3',
     Scroll13 = 'Tarin''s Animal Skin, parts 1 and 3 of 3',
     Scroll23 = 'Tarin''s Animal Skin, parts 2 and 3 of 3'
 WHERE ArtifactID = '1033';
UPDATE artifact SET
     Scroll1  = 'Kalare''s Memoirs, page 1 of 3',
     Scroll2  = 'Kalare''s Memoirs, page 2 of 3',
     Scroll3  = 'Kalare''s Memoirs, page 3 of 3',
     Scroll12 = 'Kalare''s Memoirs, parts 1 and 2 of 3',
     Scroll13 = 'Kalare''s Memoirs, parts 1 and 3 of 3',
     Scroll23 = 'Kalare''s Memoirs, parts 2 and 3 of 3'
 WHERE ArtifactID = '1034';
UPDATE artifact SET
     Scroll1  = 'Gem of Lost Memories 1 of 3',
     Scroll2  = 'Gem of Lost Memories 2 of 3',
     Scroll3  = 'Gem of Lost Memories 3 of 3',
     Scroll12 = 'Gem of Lost, parts 1 and 2 of 3',
     Scroll13 = 'Gem of Lost, parts 1 and 3 of 3',
     Scroll23 = 'Gem of Lost, parts 2 and 3 of 3'
 WHERE ArtifactID = '1035';
UPDATE artifact SET
     Scroll1  = 'Mad Tales, 1 of 3',
     Scroll2  = 'Mad Tales, 2 of 3',
     Scroll3  = 'Mad Tales, 3 of 3',
     Scroll12 = 'Mad Tales, parts 1 and 2 of 3',
     Scroll13 = 'Mad Tales, parts 1 and 3 of 3',
     Scroll23 = 'Mad Tales, parts 2 and 3 of 3'
 WHERE ArtifactID = '1036';
UPDATE artifact SET
     Scroll1  = 'Story of Malice, 1 of 3',
     Scroll2  = 'Story of Malice, 2 of 3',
     Scroll3  = 'Story of Malice, 3 of 3',
     Scroll12 = 'Story of Malice, parts 1 and 2 of 3',
     Scroll13 = 'Story of Malice, parts 1 and 3 of 3',
     Scroll23 = 'Story of Malice, parts 2 and 3 of 3'
 WHERE ArtifactID = '1037';
UPDATE artifact SET
     Scroll1  = 'Nailah''s Diary, page 1 of 3',
     Scroll2  = 'Nailah''s Diary, page 2 of 3',
     Scroll3  = 'Nailah''s Diary, page 3 of 3',
     Scroll12 = 'Nailah''s Diary, parts 1 and 2 of 3',
     Scroll13 = 'Nailah''s Diary, parts 1 and 3 of 3',
     Scroll23 = 'Nailah''s Diary, parts 2 and 3 of 3'
 WHERE ArtifactID = '1038';
UPDATE artifact SET
     Scroll1  = 'Dysis'' Tablet, piece 1 of 3',
     Scroll2  = 'Dysis'' Tablet, piece 2 of 3',
     Scroll3  = 'Dysis'' Tablet, piece 3 of 3',
     Scroll12 = 'Dysis'' Tablet, parts 1 and 2 of 3',
     Scroll13 = 'Dysis'' Tablet, parts 1 and 3 of 3',
     Scroll23 = 'Dysis'' Tablet, parts 2 and 3 of 3'
 WHERE ArtifactID = '1039';
UPDATE artifact SET
     Scroll1  = 'Oglidarsh''s Scrolls, 1 of 3',
     Scroll2  = 'Oglidarsh''s Scrolls, 2 of 3',
     Scroll3  = 'Oglidarsh''s Scrolls, 3 of 3',
     Scroll12 = 'Oglidarsh''s Scrolls, parts 1 and 2 of 3',
     Scroll13 = 'Oglidarsh''s Scrolls, parts 1 and 3 of 3',
     Scroll23 = 'Oglidarsh''s Scrolls, parts 2 and 3 of 3'
 WHERE ArtifactID = '1040';
UPDATE artifact SET
     Scroll1  = 'Great Hunt, scroll 1 of 3',
     Scroll2  = 'Great Hunt, scroll 2 of 3',
     Scroll3  = 'Great Hunt, scroll 3 of 3',
     Scroll12 = 'Great Hunt, parts 1 and 2 of 3',
     Scroll13 = 'Great Hunt, parts 1 and 3 of 3',
     Scroll23 = 'Great Hunt, parts 2 and 3 of 3'
 WHERE ArtifactID = '1041';
UPDATE artifact SET
     Scroll1  = 'Phoebus'' Letters, 1 of 3',
     Scroll2  = 'Phoebus'' Letters, 2 of 3',
     Scroll3  = 'Phoebus'' Letters, 3 of 3',
     Scroll12 = 'Phoebus'' Letters, parts 1 and 2 of 3',
     Scroll13 = 'Phoebus'' Letters, parts 1 and 3 of 3',
     Scroll23 = 'Phoebus'' Letters, parts 2 and 3 of 3'
 WHERE ArtifactID = '1042';
UPDATE artifact SET
     Scroll1  = 'Ring of Fire, Scroll 1 of 3',
     Scroll2  = 'Ring of Fire, Scroll 2 of 3',
     Scroll3  = 'Ring of Fire, Scroll 3 of 3',
     Scroll12 = 'Ring of Fire, parts 1 and 2 of 3',
     Scroll13 = 'Ring of Fire, parts 1 and 3 of 3',
     Scroll23 = 'Ring of Fire, parts 2 and 3 of 3'
 WHERE ArtifactID = '1043';
UPDATE artifact SET
     Scroll1  = 'Tribute to Adauron, 1 of 3',
     Scroll2  = 'Tribute to Adauron, 2 of 3',
     Scroll3  = 'Tribute to Adauron, 3 of 3',
     Scroll12 = 'Tribute to Adauron, parts 1 and 2 of 3',
     Scroll13 = 'Tribute to Adauron, parts 1 and 3 of 3',
     Scroll23 = 'Tribute to Adauron, parts 2 and 3 of 3'
 WHERE ArtifactID = '1044';
UPDATE artifact SET
     Scroll1  = 'Adnes''s Letter, 1 of 3',
     Scroll2  = 'Adnes''s Letter, 2 of 3',
     Scroll3  = 'Adnes''s Letter, 3 of 3',
     Scroll12 = 'Adnes''s Letter, parts 1 and 2 of 3',
     Scroll13 = 'Adnes''s Letter, parts 1 and 3 of 3',
     Scroll23 = 'Adnes''s Letter, parts 2 and 3 of 3'
 WHERE ArtifactID = '1045';
UPDATE artifact SET
     Scroll1  = 'Wooden Triptych, part 1 of 3',
     Scroll2  = 'Wooden Triptych, part 2 of 3',
     Scroll3  = 'Wooden Triptych, part 3 of 3',
     Scroll12 = 'Wooden Triptych, parts 1 and 2 of 3',
     Scroll13 = 'Wooden Triptych, parts 1 and 3 of 3',
     Scroll23 = 'Wooden Triptych, parts 2 and 3 of 3'
 WHERE ArtifactID = '1046';
UPDATE artifact SET
     Scroll1  = 'Regarding Shades, 1 of 3',
     Scroll2  = 'Regarding Shades, 2 of 3',
     Scroll3  = 'Regarding Shades, 3 of 3',
     Scroll12 = 'Regarding Shades, parts 1 and 2 of 3',
     Scroll13 = 'Regarding Shades, parts 1 and 3 of 3',
     Scroll23 = 'Regarding Shades, parts 2 and 3 of 3'
 WHERE ArtifactID = '1047';
UPDATE artifact SET
     Scroll1  = 'Mariasha''s Wall, piece 1 of 3',
     Scroll2  = 'Mariasha''s Wall, piece 2 of 3',
     Scroll3  = 'Mariasha''s Wall, piece 3 of 3',
     Scroll12 = 'Mariasha''s Wall, parts 1 and 2 of 3',
     Scroll13 = 'Mariasha''s Wall, parts 1 and 3 of 3',
     Scroll23 = 'Mariasha''s Wall, parts 2 and 3 of 3'
 WHERE ArtifactID = '1048';
UPDATE artifact SET
     Scroll1  = 'Julea''s Story, part 1 of 3',
     Scroll2  = 'Julea''s Story, part 2 of 3',
     Scroll3  = 'Julea''s Story, part 3 of 3',
     Scroll12 = 'Julea''s Story, parts 1 and 2 of 3',
     Scroll13 = 'Julea''s Story, parts 1 and 3 of 3',
     Scroll23 = 'Julea''s Story, parts 2 and 3 of 3'
 WHERE ArtifactID = '1050';
UPDATE artifact SET
     Scroll1  = 'Snatcher''s Tale, 1 of 3',
     Scroll2  = 'Snatcher''s Tale, 2 of 3',
     Scroll3  = 'Snatcher''s Tale, 3 of 3',
     Scroll12 = 'Snatcher''s Tale, parts 1 and 2 of 3',
     Scroll13 = 'Snatcher''s Tale, parts 1 and 3 of 3',
     Scroll23 = 'Snatcher''s Tale, parts 2 and 3 of 3'
 WHERE ArtifactID = '1051';
UPDATE artifact SET
     Scroll1  = 'Staff of God, Parchment 1 of 3',
     Scroll2  = 'Staff of God, Parchment 2 of 3',
     Scroll3  = 'Staff of God, Parchment 3 of 3',
     Scroll12 = 'Staff of God, parts 1 and 2 of 3',
     Scroll13 = 'Staff of God, parts 1 and 3 of 3',
     Scroll23 = 'Staff of God, parts 2 and 3 of 3'
 WHERE ArtifactID = '1052';
UPDATE artifact SET
     Scroll1  = 'Spear of Kings, piece 1 of 3',
     Scroll2  = 'Spear of Kings, piece 2 of 3',
     Scroll3  = 'Spear of Kings, piece 3 of 3',
     Scroll12 = 'Spear of Kings, parts 1 and 2 of 3',
     Scroll13 = 'Spear of Kings, parts 1 and 3 of 3',
     Scroll23 = 'Spear of Kings, parts 2 and 3 of 3'
 WHERE ArtifactID = '1053';
UPDATE artifact SET
     Scroll1  = 'Tartaros'' Gift, 1 of 3',
     Scroll2  = 'Tartaros'' Gift, 2 of 3',
     Scroll3  = 'Tartaros'' Gift, 3 of 3',
     Scroll12 = 'Tartaros'' Gift, parts 1 and 2 of 3',
     Scroll13 = 'Tartaros'' Gift, parts 1 and 3 of 3',
     Scroll23 = 'Tartaros'' Gift, parts 2 and 3 of 3'
 WHERE ArtifactID = '1055';
UPDATE artifact SET
     Scroll1  = 'Wall Glyph Pieces, 1 of 3',
     Scroll2  = 'Wall Glyph Pieces, 2 of 3',
     Scroll3  = 'Wall Glyph Pieces, 3 of 3',
     Scroll12 = 'Wall Glyph Pieces, parts 1 and 2 of 3',
     Scroll13 = 'Wall Glyph Pieces, parts 1 and 3 of 3',
     Scroll23 = 'Wall Glyph Pieces, parts 2 and 3 of 3'
 WHERE ArtifactID = '1056';
UPDATE artifact SET
     Scroll1  = 'Traldor''s Oracle, 1 of 3',
     Scroll2  = 'Traldor''s Oracle 2 of 3',
     Scroll3  = 'Traldor''s Oracle 3 of 3',
     Scroll12 = 'Traldor''s Oracle, parts 1 and 2 of 3',
     Scroll13 = 'Traldor''s Oracle, parts 1 and 3 of 3',
     Scroll23 = 'Traldor''s Oracle, parts 2 and 3 of 3'
 WHERE ArtifactID = '1057';
UPDATE artifact SET
     Scroll1  = 'Inscribed Stone, 1 of 3',
     Scroll2  = 'Inscribed Stone, 2 of 3',
     Scroll3  = 'Inscribed Stone, 3 of 3',
     Scroll12 = 'Inscribed Stone, parts 1 and 2 of 3',
     Scroll13 = 'Inscribed Stone, parts 1 and 3 of 3',
     Scroll23 = 'Inscribed Stone, parts 2 and 3 of 3'
 WHERE ArtifactID = '1058';
UPDATE artifact SET
     Scroll1  = 'Wings Dive, 1 of 3',
     Scroll2  = 'Wings Dive, 2 of 3',
     Scroll3  = 'Wings Dive, 3 of 3',
     Scroll12 = 'Wings Dive, parts 1 and 2 of 3',
     Scroll13 = 'Wings Dive, parts 1 and 3 of 3',
     Scroll23 = 'Wings Dive, parts 2 and 3 of 3'
 WHERE ArtifactID = '1059';
