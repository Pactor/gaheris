-- Thirteen keep doors that were never there.
--
-- The companion to 123. Those four rows gave keeps a second lord and stacked
-- healers; these thirteen give them doubled and misplaced doors. All are rows
-- this conversion added to keepposition and none is in the public Dawn of
-- Light database the rest of the table came from.
--
-- Held back from 123 on purpose, because doors are how a keep is taken and a
-- keep with no door cannot be captured. Checked before removing: no structure
-- in region 163 loses its last door. Towers stay at two, and the largest drop
-- is keep type 7 going from seventeen to nine.
--
-- What each one is, because "extra" is not a reason on its own:
--
-- Two are corrupt. On skin 10 rotation 2 the reference places one door at
-- (980,-490); ours adds two more at (155181,-93037) and (-433701,574589),
-- where every real offset in the table is in the hundreds.
--
-- Two are the same door twice. On skin 30 rotation 2, 559352ac and c7a2b6f0
-- sit at identical coordinates (560,-173) with identical heading -259. Not
-- near each other -- the same point.
--
-- Two are on rotations the reference gives no door at all. Skin 28 has doors
-- at rotation 2 only; ours adds one at rotation 1 and one at rotation 3.
--
-- The rest are near-duplicates of real doors. On skin 24 rotation 1 the
-- reference has four doors around (375-379, -738 to -740) and ours adds five
-- more clustered at (367-388, -891 to -919), a hundred and fifty units away.
-- Skin 24 rotation 0 and skin 30 rotation 1 each add one of the same kind.
--
-- Deleting by TemplateID, which is what identifies a door slot: core builds
-- one door per TemplateID per component, keyed `sKey = position.TemplateID +
-- ID` in FillPositions, so one row removed is one door removed and nothing
-- else shifts.
--
-- Re-running changes nothing: after the first pass the rows are gone.

DELETE FROM keepposition
 WHERE ClassType LIKE '%GameKeepDoor%'
   AND TemplateID IN (
    -- corrupt offsets, skin 10 rotation 2
    'acd90407-e969-4b38-8ad1-a46c23e819e1',
    '85ce99db-50b0-45f4-a8eb-9ec075ebc22d',
    -- the same door twice, skin 30 rotation 2 at (560,-173)
    '559352ac-7fea-4d96-9f54-8bc673919c7e',
    'c7a2b6f0-f8cd-4afb-b2d9-698252c574a9',
    -- rotations the reference gives no door, skin 28
    '0bcde2af-cfdb-421c-88c4-4ad24acf2f28',
    'a680fd4e-6409-4b32-9783-e7d8cb7bd2d3',
    -- near-duplicates, skin 24 rotation 1
    '121c4b56-3d02-490b-a8f3-eaedb80a0ffd',
    '2f8add4d-4687-42c2-b907-2d15ed4f8865',
    'e583d13d-521c-4b1c-8575-afe6b6bfadb7',
    '4855c2b6-d30e-4446-b6fc-8bf1d6d75e45',
    '3ac30fcd-22cd-4ae2-9077-71044a290d14',
    -- near-duplicate, skin 24 rotation 0
    'e19bb713-e92c-47be-a72c-9a5ea1472614',
    -- near-duplicate, skin 30 rotation 1
    '0d5314d5-f161-428f-af77-b53ba33dca7a'
 );
