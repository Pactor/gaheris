-- The Midgard and Hibernia Maulers train each other's champion trees.
--
-- Every class is granted its realm's champion specialisation plus every
-- archetype tree in that realm except its own -- Albion has six archetypes so
-- its classes get five, Hibernia has five so they get four, Midgard has four
-- so they get three. That rule holds across the whole table.
--
-- The three Maulers:
--
--   60 MaulerAlb   Champion Level Albion    + 5 Albion trees, no Fighter    correct
--   61 MaulerMid   Champion Level Hibernia  + 4 Hibernia trees, no Guardian WRONG
--   62 MaulerHib   Champion Level Midgard   + 3 Midgard trees, no Mystic... WRONG
--
-- They are not merely wrong, they are each other's. 61 holds precisely the set
-- a Hibernian Mauler should have -- four Hibernia trees excluding Guardian,
-- Hibernia's fighter archetype -- and 62 holds precisely the set a Midgard
-- Mauler should have, three Midgard trees excluding Viking. So this is one
-- swap rather than two separate mistakes, which is also why it survived: both
-- rows look individually plausible.
--
-- Everything else about them is right. Both keep the correct MaulerMidCareer
-- and MaulerHibCareer markers, the same weapon lines, and the shared Master
-- Level lines. Only the champion rows crossed over.
--
-- The effect: a Midgard Mauler reaching champion level was offered Hibernia's
-- trees and a Hibernian Mauler was offered Midgard's. Since the champion tree
-- is built from these rows -- LiveChampionsSpecialization gathers the player's
-- CL specs and asks each for its skills -- they would have trained the wrong
-- realm's abilities entirely.
--
-- Swapped in one statement so there is never a moment where both rows claim
-- the same class.

UPDATE classxspecialization
   SET ClassID = CASE ClassID WHEN 61 THEN 62 ELSE 61 END
 WHERE ClassID IN (61, 62)
   AND (SpecKeyName LIKE 'Champion Level%' OR SpecKeyName LIKE 'CL %');
