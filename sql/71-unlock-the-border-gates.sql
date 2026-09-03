-- Unlock the border keep gates again.
--
-- Migration 70 locked all twelve. That was wrong: each border keep has TWO
-- doors, and only one of them faces the frontier. The other is the way back
-- out into the realm, and locking it shuts people in.
--
-- Locking was the wrong mechanism anyway. A locked door makes the core's
-- handler fall through and do nothing at all for an ordinary player --
--
--     if (client.Account.PrivLevel == 1)
--         if (!door.Locked) { ... UseDoor(); }
--
-- so a locked gate can never reach the code that would carry someone across.
-- Unlocked, the same handler calls door.Open(player), which is a virtual on
-- the door object and something a script CAN replace.

UPDATE door SET Locked = 0 WHERE InternalID IN
    (11020501, 11020502, 12000101, 12000102,
     102093501, 102093502, 111161301, 111161302,
     206016801, 206016802, 207156901, 207156902);
