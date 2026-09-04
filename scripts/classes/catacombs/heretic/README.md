# The Heretic

His channelled damage spells ramp the longer they are held. Research note:
`docs/heretic.md`.

`HereticChannel.cs` -- the ramp, and the endings. The core's damage method was
never called by anything, and every interrupt it defines was registered
against events this server does not raise, so the channel dealt no damage and
nothing stopped it.

Damage climbs `heretic_ramp_per_pulse` percent a beat, capped at
`heretic_ramp_cap`. It ends on moving, sitting, swinging, a melee blow, the
target dying, losing the target, or leaving range -- saying which, when
`heretic_log` is on.

The three Blazes are the uninterruptible ones and hold through ranged
attacks. That is data rather than code: migration 101.
