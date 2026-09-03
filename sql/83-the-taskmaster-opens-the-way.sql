-- Take the invisible entrances back out.
--
-- Fifteen of them were placed as NPCs with model 3543, a rock pile. They
-- spawned perfectly and rendered as nothing, because 3543 is a STATIC ITEM
-- model: no mob on this server uses anything in that range except those
-- fifteen. So there was open ground where a cave was supposed to be, which is
-- exactly what was reported.
--
-- Rather than hunt for a model that reads as a cave and works on an NPC, the
-- taskmaster now opens the way directly. That also gives two things the
-- original could not: returning to a dungeon after dying or stepping out, and
-- dropping a task you do not want.
--
-- The frontier return stones have the same fault -- six mobs using model 2603,
-- another static item model that no other mob here uses -- so they are almost
-- certainly invisible too. They are left alone for now because the border keep
-- gates work without them and this is not the moment to change the frontier.

DELETE FROM mob WHERE PackageID = 'gaheris-tdoor';
