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
this repo             46 scripts, 95 migrations, a small compose delta
```

---

## Install

### What you need

* **Windows 11 with WSL2**, or any Linux host. The server itself only ever
  sees Linux; on Windows everything runs inside the WSL distro.
* **Docker Engine** *inside* the distro. Docker Desktop works too, but the
  reference setup is plain `docker.io` installed in Ubuntu.
* About **4 GB** of disk.
* A **Dark Age of Camelot 1.127 client** to connect with.

Nothing else. You do not need to build OpenDAoC, and you do not need a
database dump -- the gameserver image ships the world database and seeds it
into the volume on first boot.

### 1. Docker, inside the distro

```bash
sudo apt update && sudo apt install -y docker.io docker-compose-v2
sudo usermod -aG docker "$USER"     # then close and reopen the shell
```

### 2. Stop WSL from killing the server

**This one bites.** WSL shuts a distro down seconds after its last process
exits, and that `SIGKILL`s the containers out from under you -- the server
just disappears, usually while you are still logged in.

Hold the distro open with one idle process. `windows/wsl-keepalive.vbs` does
exactly that and nothing else; put a shortcut to it in
`shell:startup` so it runs at login:

```
wsl.exe -d Ubuntu -u root -e /bin/sleep infinity
```

### 3. Clone and configure

```bash
git clone https://github.com/Pactor/gaheris.git
cd gaheris
cp .env.example .env
```

Edit `.env` and set `DB_PASSWORD`. MariaDB reads it **once**, when it
initialises its data volume, so choose it before the first boot -- changing it
afterwards means recreating the volume.

### 4. First boot

```bash
docker compose up -d
```

The first run seeds the world database and takes a few minutes; later boots
take about fifteen seconds. Watch it come up:

```bash
docker compose logs -f gameserver
```

You are ready when the log says `Server is now listening`.

### 5. Apply the conversion

```bash
./install.sh
docker compose restart gameserver
```

`install.sh` applies everything in `sql/` in order. It is idempotent, so
re-running it is always safe and is the normal way to take an update.

### 6. Connect

`AUTO_ACCOUNT_CREATION` is on, so the first login with a new name creates the
account. On Windows, `windows/play-local.bat` launches the client against the
local server:

```
play-local.bat <account> <password>
```

It expects the client at `C:\Program Files (x86)\OpenDAoC` -- edit the path in
the file if yours differs. To connect by hand, point a 1.127 client at
`127.0.0.1:10300`.

Characters start at level 5 **as the class you chose**. Live retired base
classes years ago and so does this: pick Vampiir on the creation screen and
you are a Vampiir, trainer and all, with no archetype step in between. Then
find a **Mercenary Recruiter** -- one in each capital, one at each border keep
-- and hire a group.

### Where the world data came from

Everything needed to run this is committed, including the large ones -- a
clone installs without fetching anything else. Two of the migrations were
generated rather than written, and it is worth knowing what from:

| | | |
|---|---|---|
| `sql/13-atlantis-mobs.sql` | 41,727 placements, 11 MB | [db-public](https://github.com/Eve-of-Darkness/db-public) |
| `sql/15-volcanus.sql` | 533 placements | a survey of CapnBry's Bestiary |
| `sql/12-master-levels.sql` | 64 Master Level spells | db-public |

**db-public** is the Dawn of Light community database. It is where the Atlantis
population and the Master Level spells came from, and it is the reason those
two things exist here at all: the zones were in the database and empty, and all
eight Master Level lines existed with no spells between them.

**Deep Volcanus** is the exception db-public could not fill -- it holds nothing
for regions 46, 89 or 146. Those placements come from a radar survey instead,
which records position but no model, so the models there were chosen by hand.
`docs/research-notes.md` says which and why.

The generators that built these are not in the repository. They are ours, they
needed a db-public checkout and a live harvest to run, and nobody installing
the server has any use for them.

### Optional extras

```bash
./install.sh --testkit        # faster seals, softer doors, a level 50 test kit
./install.sh --maintenance    # one-off repairs; see sql/maintenance/
```

The testkit is for development, not play. It is kept separate so it can be
left out, or dropped later, without disturbing the conversion.

---

## Operating it

**The clone is the deployment.** The compose file mounts `./scripts` straight
into the container, so the whole edit loop is: edit a script here, restart the
gameserver. There is no copy step. (If you would rather keep the server
elsewhere and use this repo only as a source, `./sync-to-live.sh [target]`
pushes the scripts across.)

| | |
|---|---|
| Update | `git pull && ./install.sh && docker compose restart gameserver` |
| Logs | `docker compose logs -f gameserver` |
| Restart the server only | `docker compose restart gameserver` |
| Stop everything | `docker compose down` (volumes are kept) |
| Back up the world | `docker exec opendaoc-db mysqldump -uroot -p"$PW" opendaoc \| gzip > backup.sql.gz` |

**Log characters out before restarting.** OpenDAoC has no shutdown handler, so
`docker compose restart` kills the process without calling `GameServer.Stop()`
and nothing is saved. Autosave runs every 10 minutes; anything since the last
one is lost. This is the single easiest way to lose an evening's progress.

**Compile-check before restarting after a script change.** The scripts
directory builds as ONE assembly, so a single bad file takes down the whole
server -- not just that file:

```bash
~/.dotnet/dotnet build ~/scriptcheck/scriptcheck.csproj
```

That harness is a small csproj that compiles `scripts/` against a checkout of
OpenDAoC-Core. It is not in the repository -- it is build tooling rather than
server content -- but it is four references and an `EnableDefaultCompileItems`
of false, and worth recreating if you are going to change a script.

### If the world looks empty after moving the checkout

Compose derives its project name from the directory it runs in and prefixes
every volume with it, so a rename would point the server at fresh, empty
volumes. `docker-compose.yml` pins `name: opendaoc` to prevent exactly that.
If you ever do see an empty world, check that the pin is still there and that
`docker volume ls` shows `opendaoc_opendaoc-db-data`.

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
| `/level` | promote a character to the level the server allows |

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
- New characters start at level 5, already the class they were created as.
  See section 13 for why there is no promotion step. A new character picks a
  class and has a group the same minute.

### 7. Server rules &mdash; `GaherisServerRules.cs`

`AbstractServerRules.IsAllowedToAttack` refuses NPC-versus-NPC unless the
attacker is somebody's pet. Since the companions are not pets, they could not
attack anything. This widens the rule so a hire may attack a hostile NPC.

It installs itself: `ScriptMgr.CreateServerRules` searches the scripts
assembly *before* core, so a `[ServerRules(EGameServerType.GST_PvE)]` class in
a script replaces the built-in PvE rules with no core change.

### 8. New Frontiers &mdash; `sql/48`&ndash;`51`, `60`&ndash;`65`, `69`

The frontier is the New Frontiers map (region 163), not the old three-region
one. Upstream ships the region empty, so the conversion populates it: **8,353
mob placements**, the objects that go with them, and monster garrisons on all
105 keeps and towers under the same rules as section 1.

The old frontier zones are kept rather than deleted. They hold the relic
keeps, and the public database keeps them for exactly that reason -- inside
regions 1/100/200, with no keeps of their own. A player who somehow reaches
one is put back across into New Frontiers rather than left standing in an
empty zone.

Everything that could send you to the old frontier now sends you to the new
one instead: the Gate Wardens, the regular teleporters, and all the world
zonepoints. Travel destinations are the small player camps scattered over the
map, since a keep in monster hands is not somewhere to arrive.

### 9. The border keeps are the way across &mdash; `FrontierGateDoors.cs`, `FrontierReturn.cs`, `sql/70`&ndash;`72`

Six doors, one at each border keep, are the crossing. Click the frontier-side
door from inside the realm and you are put into New Frontiers; click it from
the frontier side and you are put back inside the keep. The other door of each
pair is an ordinary door and still opens on its switch, so you can always walk
back out into your own realm.

Which door of a pair faces the frontier is decided by geography rather than by
the return zonepoint: every old frontier zone lies south of the realm
interior, so the frontier-facing door is the one with the lower Y. Deriving it
from the zonepoints instead got three of the six backwards.

The door is crossed on both `Open()` and `Close()`. The client's idea of a
door's state drifts out of step with the server's, so the first touch arrives
as either one; a 2-second settle guard keeps a single click from firing twice.

### 10. Task dungeons &mdash; `GaherisTaskMaster.cs`, `GaherisTaskDungeonMission.cs`, `sql/66`&ndash;`68`, `80`&ndash;`83`

Taskmasters in the starter towns hand out instanced dungeon tasks, which
upstream builds but refuses to give to anyone -- the check sits at the top of
`Interact`, above everything else, so it cannot be subclassed around:

```csharp
//we need to disable them for players for now
if (player.Client.Account.PrivLevel == 1)
```

**The taskmaster does the travelling.** A task dungeon entrance is a hole in
the client's terrain; the server holds only a zonepoint, and there is no row
for the cave mouth in any coordinate-bearing table of the reference database
within 700 units of any of the fifteen known locations. A marker cannot be
built either, because the models that look like a cave are static-item models
and do not render on an NPC. So rather than send people hunting for a hole
that may no longer be drawn, the taskmaster opens the way itself, and can drop
a task you do not want. Leaving the dungeon ends the task, and so does dying,
which is how it worked on live.

Killing the named creature finishes a boss mission on its own, which is the
point of that task -- slip past the aggro and take the one thing you were sent
for. He is renamed per task, so the same dungeon does not hand out the same
name twice, and on a clear or a count no creature is named at all, because
one standing there reads as a task you were never given.

The mission counts kills itself, because the core's cannot. It sizes an array
by mob count and then indexes it by the world object id of whatever died:

```csharp
m_mobIsAlive = new bool[m_total];              // fourteen, say
if (m_mobIsAlive[eargs.Target.ObjectID - 1])   // ...but this is a region id
```

Every kill reaches past the end of the array, and `GamePlayer.Notify` has no
`try`/`catch` around `Mission.Notify`, so that exception escapes into the kill
handler. Ours surveys what is still standing in the instance after each kill
instead, skipping hired companions so a clear task can actually finish.

Nothing respawns. Instance creatures are built as plain `GameNPC`s, which
leaves `m_respawnInterval` at nought -- and nought does not mean never, it
means work one out. Everything came back a few minutes after it died, so the
count stood still while the dungeon was being cleared.

**There is a way out.** There was not before. Leaving goes through a zonepoint
looked up by the id the client sends, and not one of the 120 task dungeon
regions has a row -- so the door shut again and the player was sealed in with
no recourse but a server restart. The id cannot be supplied from here; it
comes out of the client's own map data. So the exit is taken rather than
described: a door used inside a task dungeon returns the player and their
companions to where the taskmaster found them. Every other door in the world
is handed to the core handler untouched.

### The dungeons teach themselves

These maps are not ours. Each of the 120 regions is 8x8 zone units -- 65,536
game units square -- and the only coordinate we hold for any of them is an
entrance marker that turns out not to be where players arrive: standing in
one, the nearest entrance in the whole table was ten thousand units away.

Three layouts were built on that marker -- a corridor, then three arms, then
packs along them -- and each was a better guess resting on the same bad
coordinate. On a map that size the result is always the same: a knot of
creatures somewhere unreachable and a clear task stranded in the twenties.

So the map is not guessed at any more. Every position a player occupies inside
the instance is, by definition, ground that can be stood on and reached, and
that trail is what the dungeon is laid out from. Creatures the player never
came within five hundred units of are somewhere they cannot get to, however
near they look on a straight line -- a corridor dungeon puts solid rock
between things that are fifteen hundred units apart -- and those are moved
onto walked ground, out of sight, a few at a time.

The trail is kept between visits, keyed on the dungeon rather than the
instance, so the first person to walk one teaches it permanently and every
later run starts knowing where the floor is.

### 11. Atlantis &mdash; Master Levels, artifacts, encounters

`GaherisMasterLevels.cs`, `MasterLevelsMerchant.cs`, `GaherisEncounters.cs`,
the six `Artifact*.cs` files, `Scholar.cs`, and `sql/12`&ndash;`16`, `28`, `29`,
`35`&ndash;`37`, `39`, `42`&ndash;`44`.

Trials of Atlantis ships in the database as empty geography. All eight Master
Level lines existed with no spells between them; the zones existed with no
population. Both are filled in here, along with the artifact chain end to end
-- scrolls drop, scholars trade them, an artifact levels with use, and the
encounters that gate the Master Levels can be run.

### 12. Champion levels and realm ranks &mdash; `GaherisChampionLevels.cs`, `GaherisRealmRanks.cs`, `sql/45`, `52`&ndash;`55`, `84`

Champion levels 1&ndash;10, with the champion spell lines and specs behind them.
`ChampionCareer` is granted to the Champion and nobody else -- the imported
data had it on all 47 classes, which quietly handed every one of them Hibernia
armour, large weapons and a shield, and is why a Vampiir could not equip a
piercing weapon.

Realm ranks run to **RR15**. The core's table stops at 130 and its fallback
past that is a cubic returning about 18 million where the table's own last
entry is 187 million, so the extension continues the table's actual growth
rate rather than falling off it.

### 13. Every class, from the creation screen &mdash; `GaherisLostClasses.cs`, `GaherisRaces.cs`, `GaherisStartingLevel.cs`, `sql/75`&ndash;`79`, `85`&ndash;`92`

Making a Vampiir failed silently -- the client dropped straight back to
character select -- and it was five separate gates stacked on each other, four
of which look like the answer on their own:

1. six classes commented out of `STARTING_CLASSES_DICT`
2. every class's `EligibleRaces` trimmed; Bainshee and Valkyrie had none at all
3. six races commented out of `STARTING_STATS_DICT`, throwing a
   `KeyNotFoundException` that validation swallowed
4. no wildcard `startuplocation`, so the character arrived in region 0
5. **`start_as_base_class`**, which rewrote the class back to its archetype
   after validation had already passed

All five are fixed, and base classes are retired with them: you are the class
you chose, at level 5, from the first login. The races each class may take are
restored from the core's own sources -- `GaherisRaces.cs` is generated, and the
real list is usually sitting commented out directly above the trimmed one.

Beyond creation, the classes needed their content. Trainers for the reopened
six, 216 realm abilities, 128 career abilities, 546 combat styles, and then
the spell side: 81 spell lines, 1,886 spells, 1,667 line entries and 431 style
procs. The Vampiir having no styles at all is why it had no attack icon to put
on the bar.

### 14. Classes that pay for their power &mdash; `GaherisVampiirPower.cs`

A Vampiir and a Mauler do not regenerate power; they take it from a fight.
Only half of that is in the core, and for the Maulers none of it.

`AttackComponent` pays a Vampiir for landing a blow and that is the only place
in the whole server where one is given power at all. Being hit grants nothing,
so it filled at half the rate it should, and the missing half is the one that
pays for standing in the middle of a fight.

The Maulers are worse off. They carry a power bar keyed to Strength, and every
means of filling it names the three of them beside the Vampiir and declines --
`RegenBuff`, `PowerHealSpellHandler`, the Perfecter power heal. That is
correct, because a Mauler is meant to earn it. Nothing granted them any. The
bar filled once and never again, which makes Fist Wraps and Power Strikes
something you use at the start of an evening and not after.

Both now earn power from blows landed and blows taken, on the core's own
curve. `gaheris_vampiir_power_rate` scales it.

The same class of gap runs the other way. A Vampiir refuses every stat buff --
`SingleStatBuff` and `DualStatBuff` check its abilities and apply nothing --
and regeneration buffs are refused to the Vampiir and all three Maulers. The
cast completes; only the effect is declined. A hired healer therefore casts,
sees no effect, and casts again forever: three of them doing that at once
looked exactly like a fight over the same buff. Rather than encode which class
refuses what, a hire is allowed to find out -- three casts at one target for
one slot with nothing to show for it and it stops offering that buff there.

### 15. Odds and ends

| | |
|---|---|
| `sql/17`&ndash;`20` | battlegrounds, keeps and garrisons, Molvik included |
| `sql/56` | 5,893 English language strings the database was missing |
| `sql/57` | doppelgangers (the mobs; the invasion event itself is not built) |
| `sql/58` | Hall of the Corrupt, 2,676 placements |
| `sql/59` | the 1.129b class rebalance |

### 16. Diagnostics kept in the tree

Two of these earned their place and are worth knowing about before something
looks mysterious.

**Unhandled client packets.** 176 of the 256 packet codes had no handler, and
the core drops those in silence -- no log, no warning. Anything the client
sends on one is a feature that quietly does nothing, and there is no way to
tell that from a key that was never pressed. Every code is now claimed and
logs what it received, along with what the player was doing at the time, to
the console and to `scripts/unknown-packets.log`. See
[docs/unhandled-packets.md](docs/unhandled-packets.md).

That question also turned up the rule that explains a whole class of silent
failures: a packet handler is registered only if its **namespace ends with the
client version**, the literal `v168`. A handler in `DOL.GS.Scripts` is skipped
without a word however correct it is.

**Characters saved inside instances.** An instance dies with the server, and a
character autosaved in one keeps that region id. On the next boot there is no
such region, and what the player sees is the client reaching character select
and closing -- with nothing in the server log but a disconnect. Autosave runs
every ten minutes and there is no shutdown handler, so ten minutes in a task
dungeon plus a restart is all it takes. Any character holding an instance
region at boot is stale by definition and goes back to its bind point.

---

## Layout

```
docker-compose.yml     stock upstream compose + 6 lines (see below)
install.sh             applies sql/ in order, idempotent
sync-to-live.sh        pushes scripts to a deployment elsewhere
scripts/               compiled at boot into GameServerScripts.dll
sql/                   numbered, applied in order
  optional/            testing kit and power sustain -- not part of the conversion
  maintenance/         one-off repairs, safe to skip on a fresh install
windows/               client launcher, and the WSL keepalive
docs/                  reference notes -- start with handoff.md
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

## Notes for anyone changing this

The operational traps -- the one-assembly build, and the missing shutdown
handler -- are under [Operating it](#operating-it). These are the ones that
will surprise you in the code.

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
