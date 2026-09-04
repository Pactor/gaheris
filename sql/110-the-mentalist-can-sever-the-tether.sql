-- The Mentalist's Realm Rank 5 ability was granted and never written.
--
-- `AtlasOF_SeveringTheTether` is granted to class 42 and its ability row names
-- `DOL.GS.RealmAbilities.AtlasOF_SeveringTheTether`. No such class exists
-- anywhere in the server; the only other occurrence of the name is the
-- commented-out helper script that inserts the grant. SkillBase warned once at
-- boot, substituted an inert default Ability, and said nothing further -- so a
-- Mentalist reaching RR5 got a button on the bar that did nothing at all.
--
-- Written in scripts/realmabilities/SeveringTheTether.cs against the published
-- description: a ground targeted effect with a thousand unit radius that
-- unmakes summoned pets and breaks the hold on charmed ones. Thirty minutes
-- reuse when it catches something, three seconds when it catches nothing.
--
-- This is the one ability in this pass that had to be written rather than
-- rewired. Everything else was present and merely unreachable.
--
-- Two choices worth recording, since neither came from a source:
--
--   Charms are released by ending the charm effect rather than by unpicking
--   it. CharmECSGameEffect.OnStopEffect already restores the creature's own
--   brain, clears aggro and turns a sustained charm back on its holder.
--
--   Who it may touch is left to GameServer.ServerRules.IsAllowedToAttack on
--   the pet's OWNER, rather than a hand-written rule. On a co-operative server
--   that means monster pets and never a groupmate's or a hired hand's.
--
-- Worth knowing before it is judged: on live this is an RvR counter to enemy
-- pet classes. Here the only pets it will meet are monsters', so it is a much
-- narrower ability than it was designed to be. It works; it is not often
-- useful.

UPDATE ability
   SET Implementation = 'DOL.GS.Scripts.SeveringTheTether'
 WHERE KeyName = 'AtlasOF_SeveringTheTether';
