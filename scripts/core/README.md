# core/

OpenDAoC bugs and omissions. Nothing here is about this server or any
expansion -- if you run OpenDAoC, you have these problems.

| File | Fixes |
|---|---|
| `ArmorFactorBuff.cs` | The core's plain `ArmorFactorBuff` handler cannot be constructed, so the spell has no handler at all |
| `EligibleRaces.cs` | Six races are commented out of `GlobalConstants.STARTING_STATS_DICT`, which silently removes them from every class that allowed them |
| `LostClasses.cs` | Heretic, Warlock, Vampiir and all three Maulers ship switched off and cannot be created or promoted to |
| `StrandedCharacters.cs` | A character saved inside a runtime instance is stranded in a region that no longer exists at next boot |

`LostClasses.cs` also carries `gaheris_no_base_classes`, which retires the
base archetypes. That is this server's rule rather than a core fix, and the
property defaults off -- it should be split out into `gaheris/` eventually.

None of these depend on anything else in `scripts/`.
