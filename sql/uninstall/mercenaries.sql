-- Take the mercenaries back out.
--
-- The counterpart to 06-mercenaries.sql and 40-city-recruiters.sql, which
-- between them touch one table: `mob`. So this is exact rather than a
-- best effort -- there is nothing else to find.
--
-- Two things go back:
--
--   The recruiters. One in Tir na Nog from 06, and the Camelot and Jordheim
--   pair from 40. All three carry ClassType MercenaryRecruiter, so one delete
--   covers every one of them however they were placed.
--
--   The seal collectors. 06 repoints the stock DreadedSealCollector at
--   GaherisSealCollector, a subclass that also credits the company's realm
--   points on a turn-in. This puts the stock class back, so the collectors
--   keep working exactly as they did before the mercenaries arrived rather
--   than being deleted along with them.
--
-- What this does NOT remove, because it never wrote it: any company a player
-- has already hired. Hires live in their own rows keyed to the employer and
-- are cleaned up by the roster, not by this. A player who has a company when
-- the feature is removed simply stops being able to hire another.
--
-- The script files come out by hand -- see docs/features.md. Leaving them in
-- is harmless: they compile against stock OpenDAoC and simply have no
-- recruiter to be hired from.
--
-- Safe to re-run.

DELETE FROM `mob`
 WHERE `ClassType` = 'DOL.GS.Scripts.MercenaryRecruiter';

UPDATE `mob`
   SET `ClassType` = 'DOL.GS.DreadedSealCollector'
 WHERE `ClassType` = 'DOL.GS.Scripts.GaherisSealCollector';
