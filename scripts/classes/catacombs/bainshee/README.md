# The Bainshee

Sound magic, three areas of attack, female only. Research note:
`docs/bainshee.md`.

`BainsheeAura.cs` -- her point blank pulsing auras, which nothing could stop.
Two separate faults: the movement handler was registered against a dead event,
and `CancelPulsingSpell` searched the legacy effect list with the line that
finds the effect commented out, so it always returned false. The `Dying`
handler was registered and firing the whole time, and being told there was
nothing to cancel.

`bainshee_log` reports when an aura starts and what stopped it.

**Still broken, deliberately left alone:** `RangeShield` -- Wraith's Shield,
Barrier and Barricade -- is on a dead event, its arithmetic truncates to 0 or
1, and all three spells carry `Value = 0`. Reviving it as written would grant
total immunity to ranged damage. It needs data before it needs code.
