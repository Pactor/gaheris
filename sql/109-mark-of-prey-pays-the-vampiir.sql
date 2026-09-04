-- Mark of Prey needs an effect that remembers who cast it.
--
-- The Vampiir's RR5 grants his group a damage add, and every point of it is
-- meant to come back to him as power. It never has: the payout hung on
-- GameLivingEvent.AttackFinished, which this server does not raise.
--
-- The replacement reads GameObjectEvent.TakeDamage, which is raised and names
-- both ends of a blow. One thing was missing to make that work -- the core's
-- MarkofPreyEffect keeps its caster in a private field and exposes it to
-- nothing, so from outside there is no way to know which Vampiir to pay.
--
-- scripts/realmabilities/BlowsThatNeverLanded.cs carries a subclass that
-- records both ends, and an ability that starts it. This points the ability
-- table at that ability. Everything else -- range, duration, group targeting,
-- the ten minute reuse -- is inherited from the core's version unchanged.
--
-- The other three abilities fixed alongside it needed no database change:
-- Shield Trip, Entwining Snakes and Fury of Nature are all reached by reading
-- the effect off the living, which needs no help from the ability that started
-- it.

UPDATE ability
   SET Implementation = 'DOL.GS.Scripts.MarkOfPreyThatPays'
 WHERE KeyName = 'Mark of Prey';
