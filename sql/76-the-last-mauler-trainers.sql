-- Deduplicate the trainers.
--
-- This file originally re-inserted 65 rows that migration 75 had already
-- placed. The check meant to exclude them came back empty and every one went
-- in a second time, so Vampiir trainers stood at 23 where there should be 13,
-- and Megh existed twice in the Chamber of Stealth.
--
-- Replaced with the repair. One trainer per name and position, keeping the
-- earliest row, across every source rather than only the ones this session
-- tagged -- which is what the first attempt at the repair got wrong too.
--
-- Counts afterwards match the reference database exactly: 13 Vampiir, 11
-- Heretic, 12 Warlock, and 7, 9 and 8 Maulers for Albion, Midgard and
-- Hibernia.

DELETE m FROM mob m
  JOIN (
    SELECT MIN(Mob_ID) AS keep_id, Name, ClassType, Region, X, Y
      FROM mob
     WHERE ClassType LIKE '%VampiirTrainer' OR ClassType LIKE '%HereticTrainer'
        OR ClassType LIKE '%WarlockTrainer' OR ClassType LIKE '%MaulerTrainer'
     GROUP BY Name, ClassType, Region, X, Y
  ) k
    ON  m.Name = k.Name AND m.ClassType = k.ClassType AND m.Region = k.Region
    AND m.X = k.X AND m.Y = k.Y AND m.Mob_ID <> k.keep_id;
