# Installing the mercenaries on your own server

Hired companions: a recruiter you buy them from, a company that follows you,
fights with you, wears gear you hand it, and travels with you.

This adds **only** that. It does not convert your server to anything, does not
change experience rates, classes, keeps or the world. Two database rows' worth
of content and six script files. It comes back out again with one command.

Tested 7 September 2026 on a database built from the stock OpenDAoC dump.

---

## What you need first

- An **OpenDAoC server running in Docker**, as the standard setup does
- The server **started at least once** against its database
- The database password

That second one is not a formality. Several migrations in this repository only
*update* server-property rows, and the server creates those rows the first time
it boots. The installer checks and refuses if it looks like the server has
never run. Mercenaries do not depend on those rows, but the check is global.

---

## Step 1 — get the repository

```bash
git clone https://github.com/Pactor/gaheris.git
cd gaheris
```

## Step 2 — tell it your database password

```bash
cp .env.example .env
```

Open `.env` and set `DB_PASSWORD` to your database password. That is the only
value the installer reads.

If your container or database is not named `opendaoc-db` / `opendaoc`, pass
them in when you run the installer:

```bash
DB_CONTAINER=my-db DB_NAME=my_database bash install.sh mercenaries
```

## Step 3 — copy six script files

The installer handles the database. It does **not** copy code, so this part is
by hand. Copy these into your server's `scripts/` directory, keeping the folder
structure:

```
scripts/gaheris/Mercenaries.cs
scripts/gaheris/MercenaryLoadout.cs
scripts/gaheris/MercenaryCommands.cs
scripts/gaheris/MercenaryTravel.cs
scripts/gaheris/Settings.cs
scripts/classes/catacombs/warlock/WarlockPairing.cs
```

All six are needed. The last one is there because a hired Warlock casts two
spells at once the way a real one does, and the mercenary code calls into it.

Nothing else from this repository is required. In particular `MonsterGarrison.cs`
is **not** needed.

## Step 4 — see what it would do, without doing it

```bash
bash install.sh --dry-run mercenaries
```

You should see exactly two files named and nothing applied:

```
Applying: mercenaries
  would apply  06-mercenaries.sql
  would apply  40-city-recruiters.sql
```

If you see thirty-odd migrations, you have an older copy of this repository --
pull again.

## Step 5 — install

```bash
bash install.sh mercenaries
```

It takes a backup of your database first, automatically, then applies the two
migrations. Expect:

```
Backing up 'opendaoc' first:
  opendaoc-20260907-072841.sql.gz    ok
Applying: mercenaries
  06-mercenaries.sql              ok
  40-city-recruiters.sql          ok
```

## Step 6 — restart the server

```bash
docker compose restart gameserver
```

**Log any character out first.** OpenDAoC has no shutdown handler, so a restart
kills the process without saving and anything since the last autosave -- ten
minutes -- is lost.

---

## Checking it worked

Three **Mercenary Recruiters** are placed, one per capital, each beside the
Gate Warden where you arrive:

| Realm | City | Region |
|---|---|---|
| Albion | Camelot | 10 |
| Midgard | Jordheim | 101 |
| Hibernia | Tir na Nog | 201 |

Talk to one and it will offer the classes it can raise. Hire one and it follows
you.

From the database, if you would rather check that way:

```sql
SELECT Name, Region FROM mob
 WHERE ClassType = 'DOL.GS.Scripts.MercenaryRecruiter';
```

Three rows is right.

---

## Taking it back out

```bash
bash install.sh --uninstall mercenaries
docker compose restart gameserver
```

This takes a backup first as well. It removes the recruiters and puts the stock
class back on any seal collectors the install had repointed, so those keep
working exactly as before rather than being deleted along with the mercenaries.

Verified on a stock database: the uninstall returned it to precisely the row
count it started with.

Two things it deliberately does not do. It leaves the six script files in
place -- they compile against stock OpenDAoC and simply have no recruiter to be
hired from, so removing them is optional. And it does not delete a company a
player has already hired; those belong to the roster, which cleans them up.

If you would rather roll the whole thing back:

```bash
bash install.sh --restore
```

That replaces the database with the newest backup, losing everything since --
characters and items included. The targeted uninstall above is almost always
what you want.

---

## If something goes wrong

**`./install.sh: Permission denied`** — run it as `bash install.sh ...`
instead. The execute bit does not always survive a clone.

**"has only 0 server properties, so the gameserver has probably never run"** —
start the server, wait for `Server is now listening`, stop it, and run the
installer again. It will offer to carry on anyway; for mercenaries alone that
is actually safe, but the clean path is to boot first.

**`Container 'opendaoc-db' is not running`** — start your stack with
`docker compose up -d`, or pass `DB_CONTAINER=` with the real name.

**No recruiters after restarting** — check the server log for compile errors in
`scripts/`. If one of the six files is missing, or one landed in the wrong
folder, the whole scripts assembly fails to build and none of it loads.

**Safe to re-run.** Installing twice does not create six recruiters, and
uninstalling twice is not an error. Both were tested.

---

## What you are testing

The mercenary system on an otherwise untouched server. If a hired class
behaves oddly, that is worth reporting -- but note that class-specific repairs
in this project live in other features and are not part of this install, so a
hired Bainshee or Valkyrie is running on your server's own class data, not on
fixed versions of it.
