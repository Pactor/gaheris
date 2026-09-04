# The Warlock

The class casts two spells at once, and none of it exists in the core.
Full research note: `docs/warlock.md`.

| File | |
|---|---|
| `WarlockPairing.cs` | A primary opens a weave; the next secondary is hung on it and lands with it, free |
| `ChamberLoader.cs` | Collects the primary and secondary clicked *during* a chamber's cast |
| `WarlockChamber.cs` | The chamber itself: arms when the cast ends, discharges both spells instantly |
| `ChamberRedraw.cs` | Redraws the orbs above his head after zoning or logging in |
| `UseSpellHandler.cs` `UseSkillHandler.cs` | Packet handlers that offer a click to the loader and the pairing before letting it cast |

## Two things to know before editing

**The packet handlers must stay in `DOL.GS.PacketHandler.Client.v168`.**
`ScriptMgr` matches on the namespace ending in the client version literal and
silently skips anything else. They also rewind (`packet.Position = start`) and
delegate to the core handler when the spell is not the Warlock's business.

**`WarlockPairing` is the one leak into `gaheris/`.** It accepts a
`GameMercenary` whose profile is a Warlock, so a hired one plays the class
rather than throwing secondaries with no primary. Delete `gaheris/` and this
file stops compiling until that check is removed -- it is a single `is`
expression in `Pairs()`.

`WarlockChamber` **must** derive from the core's `ChamberSpellHandler`: the
orb packet casts to that type, and an unrelated handler crashes the client
display.
