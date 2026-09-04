# toa/ -- Trials of Atlantis

The artifact system, ported from DOLSharp, which OpenDAoC dropped. Trials of
Atlantis added **no classes** -- it brought Master Levels, the artifacts and
the Atlantis zones. The classes of that era are Catacombs; see
`docs/expansion-class-audit.md`.

| | |
|---|---|
| `ArtifactMgr.cs` `InventoryArtifact.cs` `ArtifactCompat.cs` | The system, and the shim over everything DOLSharp had that OpenDAoC renamed or removed |
| `ArtifactQuest.cs` `ArtifactTurnInQuest.cs` `ArtifactEncounter.cs` `Encounters.cs` | Earning one: the encounter, the book, the turn-in |
| `Scholar.cs` `ArtifactScholar.cs` `ArtifactCreditMerchant.cs` `MasterLevelsMerchant.cs` | The people who hand them over |
| `ArtifactExperience.cs` `ArtifactLog.cs` | Levelling one, and tracing it |

`ArtifactExperience.cs` exists because `GamePlayerEvent.GainedExperience` is
never raised by this server -- artifacts would never gain a level. It listens
on `GameLivingEvent.Dying` instead. See `docs/dead-events.md`.

`Scholar`, `ArtifactScholar` and `ArtifactCreditMerchant` are named in
`mob.ClassType` and cannot be renamed without migrating those rows.
