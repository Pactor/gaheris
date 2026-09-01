# Gaheris

A co-operative PvE conversion for [OpenDAoC](https://github.com/OpenDAoC/OpenDAoC-Core),
rebuilding the old Dark Age of Camelot co-op ruleset: one realm against the
world, keeps held by monsters instead of players, and a full group of hired
companions so a solo player can run group content.

**This is not a fork.** It is an overlay. Every file here is either dropped
into OpenDAoC's custom-script directory or applied to its database as a
migration. Upstream is used exactly as published, and nothing in this repo
requires you to build it.

```
OpenDAoC-Core         stock, pulled as a Docker image -- 0 files changed
OpenDAoC-Database     stock -- 0 files changed
this repo             8 scripts, 14 migrations, a small compose delta
```

---

## Install

You need Docker and about 4 GB of disk. Nothing else -- the gameserver image
ships the world database and seeds it on first boot.

```bash
git clone https://github.com/Pactor/gaheris.git
cd gaheris
cp .env.example .env          # set DB_PASSWORD to something of your own
docker compose up -d          # first boot seeds the DB; give it a few minutes
./install.sh                  # applies the conversion
docker compose restart gameserver
```

Then point a 1.127 client at `127.0.0.1:10300`. `AUTO_ACCOUNT_CREATION` is on,
so the first login with a new name creates the account.

Optional extras:

```bash
./install.sh --testkit        # faster seals, softer doors, a level 50 test kit
./install.sh --maintenance    # one-off repairs; see sql/maintenance/
```

`install.sh` is safe to re-run. Every migration is written to be idempotent,
so re-running it after a `git pull` is the normal way to take an update.

The clone is the deployment: the compose file mounts `./scripts` straight
into the container, so editing a script here and restarting the gameserver is
the whole edit loop. There is no copy step.

If you keep the server somewhere else and only use this repo as a source,
`./sync-to-live.sh [target]` pushes the scripts across instead.

---

## What changed, and why

### The premise

Gaheris was DAoC's co-operative server: no realm-versus-realm, all three
realms friendly, and the frontier keeps garrisoned by monsters that retake
them over time. OpenDAoC implements the mechanisms but ships the standard
three-realm PvP dataset, so the conversion is mostly data -- plus the code
needed where a mechanism assumes a player on the other side.

---

### 1. Monster-held keeps &mdash; `MonsterGarrison.cs`, `sql/01`, `03`, `04`

Every frontier keep is regarrisoned with monsters and a monster lord. Clearing
a keep is the content; it repopulates on a timer (20 minutes for the garrison,
longer for the lord) so it can be run again.

The awkward part is that Gaheris guards are ordinary `mob` rows rather than
`keepposition` rows, which means **`guard.Component` is always null**. A
surprising amount of core assumes otherwise, and it bit in four separate
places: world initialisation, seal payout, `LordBrain.BringFriends`, and
`GameKeepGuard.SetLevel`. That last one is why `MonsterGarrison.cs` sets guard
levels itself -- core cannot, because the setter is gated on the Component
these guards do not have.

`MonsterKeepGuardBrain` overrides `CheckNpcAggro`, because core's version
ignores non-pet NPCs entirely and the hired companions are deliberately not
pets. Patrolling guards also had two genuine bugs fixed here: a breadcrumb was
dropped per hit rather than per waypoint, and a patrol whose target went null
resumed from the wrong leg.

### 2. A full group of hired companions &mdash; `Mercenaries.cs`, `MercenaryLoadout.cs`

The centrepiece, and the largest file. A player hires up to a full group from
a recruiter and keeps them across logouts, zones and teleports.

**They are real classes, not archetypes.** All 47 playable classes, each one
resolved from the live game data rather than invented:

```
classxspecialization -> spellline.Spec -> SkillBase.GetSpellList
                        SkillBase.GetStyleList(spec, classId)
                        SkillBase.GetSpecAbilityList(spec, classId)
                        SkillBase.GetClassRealmAbilities(classId)
```

So a Necromancer gets a real bone pet and real damage-over-time spells, a
Warden gets the real pulsing damage shield, a Hero gets real weapon styles.
They spec as a player would, they learn styles and abilities, and they spend
realm points down their own class's realm-ability lines as those are earned.

**They are not pets, deliberately.** Making them `ControlledMobBrain` pets is
the obvious implementation and it is wrong: core hands the owner 30% of pet
damage as aggro, so mobs walked *through* the group to reach the player
standing behind it. Uncoupling them fixed the aggro but broke four other
things that all resolve a killer through `IControlledBrain` -- attacking at
all, experience credit, seal credit, and every loot generator. Those are what
`GaherisServerRules.cs` and `GaherisLoot.cs` exist to repair.

**Gear is the player's.** You hand them your items; they wear them, and the
right property channels actually read them. Armour is checked against real
class proficiency, so an Eldritch refuses plate the same way a player's
Eldritch would. Everything handed over is recoverable with `[recover]` at any
recruiter, which sweeps by owner-id prefix so gear left under an older name
is still found.

**Persistence** is keyed to the character, in `DOLCharactersXCustomParam`:

| Key | Holds |
|---|---|
| `GaherisMercRoster` | who is hired |
| `GaherisMercRealmPoints` | earned realm points |
| `GaherisMercTactic` | last tactic set |
| `GaherisMercFormation` | last formation set |
| `GaherisMercCrowdControl` | crowd-control toggle |

### 3. Tactics and formations &mdash; `MercenaryCommands.cs`

| Command | Effect |
|---|---|
| `/tactic` | report what they are doing now |
| `/tactic balanced` | tanks hold the line, healers mend whoever is worst off |
| `/tactic pbaoe` | they stack on you and the casters go in close |
| `/tactic focus` | your pet holds everything; nobody taunts, the pet is healed first |
| `/tactic cc` | toggle crowd control on or off |
| `/mercgear` | what each of them is wearing |
| `/mercwatch` | where they are and what they last did &mdash; the debugging view |

Formations are set by talking to any of them: `[circle]`, `[line]`,
`[column]`, `[wedge]`. The ring is deliberately 80 units across, inside
`WorldMgr.GIVE_ITEM_DISTANCE` (128), because a wider ring puts them out of
range to hand an item to.

`focus` exists for the caster pull: send the pet in, let it drag the train
back with a damage shield up, and the group holds until the pull lands rather
than blasting it in the field.

### 4. Travel &mdash; `GaherisTravel.cs`, `sql/05`

34 Gate Wardens: one at every frontier keep, at the three border keeps, and in
each capital. Every warden reaches every other one, which is the Gaheris rule
-- with one realm there is nowhere you are not allowed to go.

Mercenary Recruiters also stand at the border keeps, so a company can be hired
at the staging point rather than only back in the city.

Teleporting moves the player, their whole company **and** their pet. A travel
network the group cannot follow you through is not a travel network.

### 5. Loot and the seal economy &mdash; `GaherisLoot.cs`, `GaherisSeals.cs`, `sql/02`, `07`

Dreaded Seals are the Gaheris currency, adapted from Eve-of-Darkness. OpenDAoC
already implements the mechanism; only the data was missing.

Two fixes were needed beyond the data:

- The seal generator was registered against regions 1/100/200/245/249 -- the
  frontiers and Darkness Falls. Nothing killed while levelling could ever drop
  one. `RegisterLootGenerator` treats region 0 as global, so one row replaces
  the five.
- Core's random-object generator picks a class to roll for with
  `foreach (GamePlayer player in group.GetMembersInTheGroup())`. That returns
  `GameLiving`, so with companions in the group the cast throws, the exception
  is swallowed, and the result is **no gear at all** -- not less, none. Putting
  them in a group silently turned gear drops off entirely. `GaherisLootRog` is
  a rewrite that rolls for a random class among the player and their hires, so
  a group of seven gets gear it can actually wear.

Base random-object chance is raised from 14 to 35, because gearing a group of
seven from scratch is not the same problem as gearing one character.

### 6. Rates &mdash; `sql/08`, `09`, `10`

- Experience `10x`. The keeps are the content; grinding 5&ndash;50 solo before any
  of it opens is a toll, not a game.
- **RvR-zone experience also `10x`.** `GamePlayer.GainExperience` picks *one*
  of the two rates, and `rvr_zones_xp_rate` defaulted to `1.0` -- so Darkness
  Falls and the frontiers paid a tenth of what the open world paid.
- New characters start at level 5, where the game lets you promote out of a
  base class. The recruiters refuse anyone still holding an archetype, so this
  means a new character picks a class and has a group the same minute.

### 7. Server rules &mdash; `GaherisServerRules.cs`

`AbstractServerRules.IsAllowedToAttack` refuses NPC-versus-NPC unless the
attacker is somebody's pet. Since the companions are not pets, they could not
attack anything. This widens the rule so a hire may attack a hostile NPC.

It installs itself: `ScriptMgr.CreateServerRules` searches the scripts
assembly *before* core, so a `[ServerRules(EGameServerType.GST_PvE)]` class in
a script replaces the built-in PvE rules with no core change.

---

## Layout

```
docker-compose.yml     stock upstream compose + 5 lines (see below)
install.sh             applies sql/ in order, idempotent
sync-to-live.sh        pushes scripts to a deployment elsewhere
scripts/               compiled at boot into GameServerScripts.dll
sql/                   numbered, applied in order
  optional/            testing kit and power sustain -- not part of the conversion
  maintenance/         one-off repairs, safe to skip on a fresh install
tools/                 generators for the bulk SQL, and the compile harness
docs/                  reference notes
```

### The compose delta

Our `docker-compose.yml` differs from upstream's by exactly six things:

1. `GAME_TYPE: "PvE"` (was `Normal`)
2. mount `./scripts:/app/scripts/custom`
3. a `healthcheck` on the db service
4. `depends_on: db: condition: service_healthy`
5. `restart: unless-stopped` on the gameserver
6. `name: opendaoc` &mdash; see below

**The project name is pinned on purpose.** Compose defaults it to the
directory name and prefixes every volume with it, so running this from a
checkout called anything else would silently create new, empty volumes and
the world database would appear to have been wiped. Pinning it means the
repo can live anywhere and still finds `opendaoc_opendaoc-db-data`.

---

## Working on this

**The scripts directory compiles as one assembly.** A single bad file takes
down the entire server, not just that file. Always compile-check before
restarting:

```bash
~/.dotnet/dotnet build ~/scriptcheck/scriptcheck.csproj
```

`tools/scriptcheck.csproj` is that harness -- point it at your scripts
directory and a checkout of OpenDAoC-Core for references.

**OpenDAoC has no shutdown handler.** `docker compose restart` kills the
process without calling `GameServer.Stop()`, so nothing is saved. Autosave is
every 10 minutes. Log characters out before restarting or they lose progress.

**There is no pathfinding.** The Detour native library is absent and there are
no navmesh files, so NPCs walk straight lines and snag on terrain. The
companions carry a teleport-rescue as a workaround; it is a workaround, not a
fix.

**Brains stop when nobody can see them.** `ABrain.IsActive` includes
`Body.IsVisibleToPlayers`, so anything that must keep running while out of
sight belongs on an `ECSGameTimer`, which ticks unconditionally.

---

## Database

This repo ships **migrations, not a dump**. That is deliberate:

- A dump of a live server contains `account` rows with password hashes.
- The migrations are ~300 KB of readable, reviewable SQL; a dump is 60 MB+ of
  generated `INSERT`s.
- The migrations are idempotent and written to rebuild the world on a fresh
  upstream import, which is what makes an update a `git pull` rather than a
  reinstall.

`.gitignore` blocks `backup-*.sql`, `*.dump` and `.env` for this reason. If
you ever do need to move a world, dump it separately and move it out of band.

---

## Licence

GPL-3.0, matching [OpenDAoC-Core](https://github.com/OpenDAoC/OpenDAoC-Core).
These scripts are compiled against and derived from GameServer, so they are
covered by the same terms. See [LICENSE](LICENSE).

Seal data adapted from Eve-of-Darkness. Gaheris is a Dark Age of Camelot
ruleset; DAoC is the property of Electronic Arts.
