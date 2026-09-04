-- Take Quickcast back off the Warlock.
--
-- Migration 96 gave it to him, reasoning that ClassWarlock is the only class
-- in the server whose code mentions Quickcast at all -- an override saying
-- which of his spells it may NOT be used on -- and that such an override is
-- meaningless on a class that cannot quickcast.
--
-- That reads the evidence backwards. The override exists to stop Quickcast
-- reaching his spells if he ever acquires it from anywhere, which is a guard
-- rather than a grant. The official class library describes the Warlock at
-- length and never mentions Quickcast, and the class already has its own
-- answer to the same problem: the Uninterruptable primers in Hexing, which
-- make a secondary spell impossible to interrupt at the cost of some of its
-- effectiveness. Giving him Quickcast as well hands him two solutions to one
-- problem, one of which was never his.
--
-- The twelve list casters that legitimately carry it are untouched.

DELETE FROM classxspecialization
 WHERE ClassID = 59 AND SpecKeyName = 'CharacterQuickcastUserCareer';
