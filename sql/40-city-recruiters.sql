-- A Mercenary Recruiter in Camelot and Jordheim.
--
-- There were four: one out in each realm's countryside -- Albion, Midgard and
-- Hibernia -- and one inside Tir na Nog. So Hibernia's capital had a recruiter
-- and the other two did not, which makes going city to city to raise a company
-- work in one realm out of three.
--
-- Both new ones stand beside the Gate Warden, which is where a player arrives
-- in a capital and so the one spot in the city they are certain to find.
-- Everything else is copied from the Tir na Nog recruiter, that being the one
-- already proven to work indoors.

DELETE FROM mob
 WHERE ClassType = 'DOL.GS.Scripts.MercenaryRecruiter'
   AND Region IN (10, 101);

INSERT INTO mob (Mob_ID, ClassType, Name, Guild, X, Y, Z, Heading, Region,
                 Model, Size, Level, Realm, Flags, PackageID,
                 LastTimeRowUpdated, OwnerID, NPCTemplateID)
VALUES
 (UUID(), 'DOL.GS.Scripts.MercenaryRecruiter', 'Mercenary Recruiter',
  'Mercenary Recruiter', 33720, 22730, 8479, 2100, 10,
  334, 52, 50, 1, 16, 'GaherisMercs', '2000-01-01 00:00:00', '', 0),

 (UUID(), 'DOL.GS.Scripts.MercenaryRecruiter', 'Mercenary Recruiter',
  'Mercenary Recruiter', 31820, 33880, 8030, 2100, 101,
  334, 52, 50, 2, 16, 'GaherisMercs', '2000-01-01 00:00:00', '', 0);
