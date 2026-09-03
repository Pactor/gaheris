-- Put Sevinia where the Camelot Herald says she stands.
--
-- She was placed on Mag Mell's travel catalogue coordinate, which is the town
-- centre and exactly where the Gate Warden stands -- so she was both in the
-- wrong place and impossible to click.
--
-- The Herald gives 27.9k, 5.2k in Lough Derg. Converted against that zone's
-- own offsets (39, 59, so 319488 and 483328) that is 347388, 488528, which
-- sits about a thousand units from Sian, Anice and Sedric on the edge of Mag
-- Mell. That is "within Mag Mell", and it is clear of the Warden.
--
-- The same source gives the dungeon at 30.3k, 1.9k -- 349788, 485228 -- and
-- our zonepoint is at 349777, 485325, ninety-seven units away. Two records
-- that were never copied from each other agreeing that closely is the best
-- evidence available that the entrance really is there.

UPDATE mob SET X = 347388, Y = 488528, Z = 5210
 WHERE Name = 'Taskmaster Sevinia';
