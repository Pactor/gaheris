# New Frontiers: the white keeps

New Frontiers keeps render as untextured white shapes. The buildings are there
and correctly formed -- walls, towers, the right silhouette -- but they have no
surface.

This is the investigation log, kept because the search has already cost more
than the fix probably will, and because several plausible answers turned out to
be wrong in ways worth remembering. **Add to it as things are learned. Do not
re-test anything under "Ruled out" without a reason to think the finding was
wrong** -- and if you do overturn one, say so here rather than deleting it.

Opened 6 September 2026. **Solved the same day.** The keeps were being built at
the wrong height, not drawn without textures. The answer is in "First result"
and "What it was"; everything below that is kept because it is the record of
what was eliminated and why, and because two of the eliminations correct things
this project previously believed.

Separate from `new-frontiers-plan.md`, which is about the conversion itself.
That work is done: the keeps are in region 163 and they load.

---

## The symptom

Reported as "white keeps", with a screenshot of a fully formed but completely
untextured keep. Refined twice since: first to "they are the newer ones", so
the models being drawn are the new-frontier set rather than the old one, and
then to "all may be white, it is too large an area to cover", meaning a
per-keep survey was not practical and the problem may be universal.

It is not missing geometry. The client draws a keep of the right shape in the
right place. Only the surface is wrong.

---

## What was changed, in order

Both of these changed *how* the keeps are built, and both were made while
chasing this. Neither has been confirmed to help or to hurt.

**`sql/120-new-frontiers-keeps-wear-the-new-skins.sql`** set `use_new_keeps`
from 0 to 1. Every keep stores its appearance twice, an old-skin set and a
new-skin set, and `KeepManager` loads one family or the other by that single
global property:

```
if (USE_NEW_KEEPS == 0)  SelectObjects(Skin < 20);
else if (== 1)           SelectObjects(Skin > 20);
```

Region 163 was being assembled out of old-frontier parts, which are the wrong
models for terrain laid out for the new ones. After this the models were
confirmed to be the newer ones, so the switch did what it says. The keeps
stayed white.

**`sql/121-new-frontiers-keeps-stand-at-full-height.sql`** raised region 163
keeps from Level 4 to Level 10. Keep level is not only toughness, it is also
how tall the client builds the keep:

```
GameKeepComponent.Height => Keep.Height
AbstractGameKeep.Height  => KeepManager.GetHeightFromLevel(Level)

    > 15 -> 5    > 10 -> 4    > 7 -> 3    > 4 -> 2    > 1 -> 1    else 0
```

and that height goes straight into the component packet, one byte per wall
section, at `PacketLib170.cs:80`. Four is not greater than four, so every New
Frontiers keep was drawn at the second lowest of six build tiers. Level 4 is
core's `starting_keep_level`, what an *unclaimed* keep sits at, so this was
never a choice anyone made here.

**This change has never been looked at in game.** It went in and the session
moved to other work.

---

## First result, 6 September 2026

**Caer Renaris renders correctly, and it did not before.** Observed on a GM
account after jumping to it in region 163.

Nothing else changed in between. The keep data is untouched since the
comparison against the public database, the client is the same install, and the
only difference between the two viewings is migration 121 -- the raise from
Level 4 to Level 10, which moved every New Frontiers keep from build tier 1 to
build tier 4.

So the leading explanation is now that the keeps were never untextured at all.
They were being drawn at the wrong build tier, and whatever the client puts on
the ground for a tier-1 New Frontiers keep reads as a white shell.

Not yet confirmed as general. Renaris is keep type 6, one of seven designs, and
the 84 towers are a different model again -- a single component at skin 31. See
"Open questions".

### Survey results

Region 163 is only eight shapes: seven keep designs, each existing once per
realm, and 84 towers that are all one component at skin 31. So the survey is
eight stops, not 105.

| Stop | What it covers | Result |
|---|---|---|
| Caer Renaris, type 6 | 3 keeps (one per realm) | **correct** -- was white before |
| Caer Boldiam, type 4 | 3 keeps | **correct** |
| Caer Sursbrooke, type 5 | 3 keeps | **correct** |
| Caer Erasleigh, type 3, and its towers | 3 keeps | **correct** |
| Caer Benowyc, type 1 | 3 keeps | **correct** -- the largest design, 18 components |
| Caer Berkstead, type 2 | 3 keeps | **correct** -- the smallest, 10 components |
| watchtowers, many, in passing | all 84 towers | **correct** |
| Caer Hurbury, type 7 | 3 keeps | not checked |

Six of the seven keep designs and the entire tower population, from the largest
design at 18 components to the smallest at 10, none of which rendered correctly
before. Nothing has been seen white anywhere in region 163 since the level
change and no structure has needed a second look. The seventh design was left
unvisited deliberately rather than forgotten.

Two notes recorded while planning the survey, both of which correct earlier
assumptions:

**Castle Excalibur and Castle Sauvage are not keeps.** Neither appears in the
`keep` table; they are static zone geometry in the client's Albion art. They
render correctly, and that says nothing about keep components, which are built
from packets.

**Battleground keeps are not an old-skin control group.** Fort Brolorn carries
16 old-skin parts and 9 new-skin ones, and `use_new_keeps` is global, so the
battlegrounds have been drawing new skins alongside New Frontiers all along.
Comparing them does not test old models against new. It tests region 163
against everywhere else, which is still worth doing and needs no restart.

---

## What it was

A keep's level decides how tall the client builds it. Every New Frontiers keep
sat at Level 4, and `GetHeightFromLevel` turns that into height 1 -- the second
lowest of six build tiers -- which goes into the component packet one byte per
wall section. Raised to Level 10 the keeps build at height 4, and they render.

So they were never untextured. They were being built wrong, and whatever the
client puts on the ground for a New Frontiers keep at build tier 1 reads as a
white shell. **Why** it reads that way is client side and not established here;
the honest statement is that the height was wrong, fixing it fixed the look,
and the mechanism inside the client was never proven.

Level 4 was not a decision anybody made. It is core's `starting_keep_level`,
the level an *unclaimed* keep sits at, so this is simply what New Frontiers
looked like before anyone had ever taken and upgraded a keep.

Worth keeping in mind: `starting_keep_level` is still 4, so a captured keep
drops back to Level 4 and will look white again until it is upgraded. That is
recorded in migration 121 and left alone on purpose, because raising the
property would apply to every keep in the game on capture, battlegrounds
included, where the levels are tuned to each bracket.

---

## Verified clean

Each of these was checked against an authority rather than reasoned about. The
authority for data is the public Dawn of Light database,
`github.com/Eve-of-Darkness/db-public`, which is where this conversion's keep
data came from in the first place.

| Thing | Finding |
|---|---|
| Keeps in region 163 | 105, identical to the public reference |
| Keep components | 966, and the split matches exactly: 555 old, 402 new, 9 at skin 20 |
| Zones in region 163 | the same 15 at the same offsets; zone 165 is Cathal Valley in its own region, correctly absent |
| `regions.IsFrontier` | 1, as `KeepManager`'s `DEFAULT_FRONTIERS_REGION` constant expects |
| Keeps load at boot | `Loaded 166 keeps successfully`, no keep errors |
| Component packets | `SendKeepInit` sends the keep and every one of its components on region entry, and `RegionEvent.PlayerEnter` **is** raised, at `PlayerInitRequestHandler.cs:27` |
| Client art for zone 163 | present and full size: `tex163` 4.6MB, `ter163` 1.2MB, `lod163` 1.2MB, `dat163` 403KB, plus `figures/skins/skin163.mpk` and `frontiers/nf.mpk` |

The only two zero-length `.mpk` files in the whole client are `csv009` and
`csv103`. Neither is New Frontiers.

---

## Ruled out, and why

**The hardcoded model byte in `SendKeepInfo`.** DOLSharp changes it from `0xF7`
to `0` for 1.124 clients, commented "patch 0072", which looked exactly like the
sort of thing that would strip a keep's appearance. OpenDAoC already carries
the identical override in `PacketLib1124`, and 1125 through 1129 inherit it, so
a 1.127 client already receives the fixed value. Closed.

**The nine components with skin exactly 20.** `KeepManager` loads `Skin < 20`
for old and `Skin > 20` for new, so skin 20 is loaded by neither. That is a
real core bug, and it was recorded here as a defect affecting region 163. It is
not one for us. The component IDs show why: Caer Berkstead's new-skin set is
IDs 0 to 9 and complete, while its old-skin set runs 0 to 19 with **18
missing**, and the skin-20 row is that missing old component 18. The same holds
for all nine, across three keep designs mirrored over the three realms. With
`use_new_keeps = 1` nothing we load is short a piece. It matters only if the
server is switched back to old skins.

**Component loading.** 166 keeps load with no errors and region 163's
components are all accounted for.

**Keep realm.** Every region 163 keep carries realm 1, 2 or 3.

**`regions.Expansion`.** Reads only as access control -- `CheckExpansion`,
`NotAuthorizedToUseExpansionVersion` -- and has nothing to do with rendering.

**Zone registration.** `354 Regions Loaded`, zones loaded for all regions, no
warnings.

**The keep data being ours rather than stock.** It is stock. The only file in
this repo that inserts `keepcomponent` rows is `33-battleground-keeps.sql`, and
that is battlegrounds.

---

## Known, and unrelated

Worth recording so they are not mistaken for symptoms.

**Keep guards spam `MoveOnPath but PathId is null`.** Thousands of lines an
hour, at a rate unchanged across the whole day and unaffected by the keep level
change. Long-standing, and in stock guard data.

**Four keeps have no components at all** and are invisible whatever is set: Dun
Orseo, Braemar Middle Camp, Caer Caledon and Thidranki Faste. None is in region
163. The other componentless rows are Portal Keeps, which are destinations
rather than buildings.

**`keep.SkinType` is ignored.** The column exists with exactly the values that
would allow a per-keep choice -- Any 0, Old 1, New 2 -- but `KeepManager` reads
it only to recognise relic keeps at 99. So old-style battleground keeps and
new-style frontier keeps cannot be mixed; the switch is global. One setting
suits this server, so the limitation costs nothing here, but it is the one
place a redesign would actually buy something.

---

## Open questions

The next things to establish, ordered by how fast each would narrow the search.

**Do old-skin keeps render correctly?** Battleground keeps and the old-frontier
keeps in regions 1, 100 and 200 all use the old family. If those look right and
only New Frontiers is white, the problem is the new-skin models specifically,
and flipping `use_new_keeps` back to 0 is a controlled test that confirms it.
If everything is white everywhere, skins are not the variable and the client
install is where to look. **This one question splits the search in half and has
not been answered.**

**Are towers white as well as keeps?** Different models. Splits it again.

**Does the Level 10 change help?** Applied, never observed. The keeps now build
at height 4 rather than height 1.

**Is it the whole structure or only parts?** Walls, towers, doors and the
lord's building are separate components carrying separate skins.

---

## Things not to repeat

The keep data has now been compared against the public reference three times
and matched every time. It is not the data. Anything beginning "maybe the keep
rows are wrong" needs new evidence before it is worth the time.

Assuming a plausible mechanism without first checking whether the code path is
reachable has cost time twice here: once on the model byte, once on skin 20.
Check the branch is live before building a theory on it.
