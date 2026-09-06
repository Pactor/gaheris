-- One lord to a keep, and no stacked healers.
--
-- Every New Frontiers keep built on a rotation-0 keep component fielded two
-- lords, and three keep designs carried healers standing inside one another.
-- All of it comes from four rows this conversion added to keepposition that
-- are not in the public Dawn of Light database, which is where the rest of the
-- table came from.
--
-- How a guard reaches a keep is worth stating, because none of this is
-- obvious from the table. Positions are keyed on the component's SKIN, not on
-- the keep, so one row serves every keep built from the same piece -- and they
-- are keyed on the component's ROTATION as well, which is the part that hides
-- things:
--
--     var whereClause = DB.Column("ComponentSkin").IsEqualTo(Skin);
--     if (Skin != Keep && Skin != Tower && Skin != Gate)
--         whereClause = whereClause.And(
--             DB.Column("ComponentRotation").IsEqualTo(ComponentHeading));
--
-- So a keep takes only the positions matching the heading of its own keep
-- component. Region 163's 21 keeps split 6 / 9 / 3 / 3 across headings 0 to 3,
-- and only the six at heading 0 were affected by the extra lord.
--
-- Checked against the public database rather than judged by eye. On skin 30 it
-- holds exactly one lord template per rotation:
--
--     rot 0  3ab163f0   rot 1  f25317ac   rot 2  3ab163f0   rot 3  3ab163f0
--
-- and no healer on skin 30 at all. Ours added a second lord at rotation 0, two
-- healers at rotation 0 standing on the same spot as each other, and a third
-- healer on skin 27 at rotation 1 duplicating the one the reference already
-- places on skin 27 at rotation 3.
--
-- Deleting by TemplateID, which is what identifies a guard slot. Core builds
-- one guard per TemplateID per component -- `sKey = position.TemplateID + ID`
-- in FillPositions -- so removing the row removes exactly one guard from every
-- keep that carried it, and nothing else moves.
--
-- Left alone deliberately: thirteen extra GameKeepDoor rows, also ours and
-- also absent from the reference. Two of them are plainly corrupt, with
-- offsets of (155181, -93037) and (-433701, 574589) where every real offset is
-- in the hundreds, and several others duplicate a door at coordinates a few
-- units apart. Doors are how a keep is taken, so they are recorded here to be
-- looked at on their own rather than swept up in a guard fix.
--
-- Re-running changes nothing: after the first pass the rows are gone.

DELETE FROM keepposition
 WHERE TemplateID IN (
    -- second lord, skin 30 rotation 0
    '1b00608f-a85f-40c1-8d0f-447ffdebc7a7',
    -- two healers on skin 30 rotation 0, both at (757,-894)
    'd882019d-9a31-4e09-8b8e-5aae1fdb4dc0',
    '9373db51-6991-43c9-9c50-ad13ff8470e6',
    -- healer on skin 27 rotation 1, duplicating the reference one at rotation 3
    'c020245a-4efa-4de1-b12e-40a82bf0c3f7'
 );
