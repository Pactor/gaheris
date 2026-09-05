#!/usr/bin/env bash
#
# Applies the Gaheris conversion to a running OpenDAoC database.
#
# Every migration is idempotent, so this is safe to re-run -- after pulling
# an update, or when you want to be sure the world matches the repo.
#
# Usage:
#   ./install.sh                 the whole conversion
#   ./install.sh --list          what can be installed on its own
#   ./install.sh --dry-run ...   name the migrations without applying any
#   ./install.sh --no-backup     skip the automatic backup taken first
#   ./install.sh --restore       put the newest backup back, undoing an install
#   ./install.sh --diff          which tables differ from the newest backup
#   ./install.sh mercenaries     one feature, and whatever it depends on
#   ./install.sh classes travel  several
#   ./install.sh --testkit       also the optional testing kit
#   ./install.sh --maintenance   also the one-off repair scripts
#
# Naming a feature installs that feature and its dependencies and nothing
# else, for taking a piece of this into another server. See sql/features.conf
# for the map and docs/features.md for what each one is.
#
set -euo pipefail

cd "$(dirname "$0")"

CONTAINER="${DB_CONTAINER:-opendaoc-db}"
DATABASE="${DB_NAME:-opendaoc}"

if [[ ! -f .env ]]; then
  echo "No .env found. Copy .env.example to .env and set DB_PASSWORD first." >&2
  exit 1
fi

PW="$(sed -n 's/^DB_PASSWORD=//p' .env | tr -d '\r\n')"

if [[ -z "$PW" ]]; then
  echo "DB_PASSWORD is empty in .env" >&2
  exit 1
fi

if ! docker ps --format '{{.Names}}' | grep -qx "$CONTAINER"; then
  echo "Container '$CONTAINER' is not running. Start it with: docker compose up -d" >&2
  exit 1
fi

apply() {
  local file="$1"

  if [[ -n "${DRYRUN:-}" ]]; then
    echo "  would apply  $(basename "$file")"
    return 0
  fi

  printf '  %-32s' "$(basename "$file")"
  if docker exec -i -e MYSQL_PWD="$PW" "$CONTAINER" \
       mysql -uroot --default-character-set=utf8mb4 "$DATABASE" < "$file" 2>/dev/null; then
    echo 'ok'
  else
    echo 'FAILED'
    return 1
  fi
}

# Seven migrations only UPDATE serverproperty rows -- 01, 07, 22, 41, 78, 104
# and 117 among them. Those rows do not exist until the gameserver has booted
# once and created them from its own [ServerProperty] attributes: a stock
# database has four of them, a booted one has around four hundred and seventy.
#
# So applying migrations to a database the server has never seen leaves every
# one of those updates matching nothing, silently. The README boots first and
# installs second for exactly this reason, but a feature install is easy to
# reach for on a database that has not been started yet.
check_booted() {
  local n
  n="$(docker exec -i -e MYSQL_PWD="$PW" "$CONTAINER" mysql -uroot -N -B         -e "SELECT COUNT(*) FROM $DATABASE.serverproperty;" 2>/dev/null || echo 0)"

  if [[ "${n:-0}" -lt 50 ]]; then
    cat >&2 <<EOF

  ------------------------------------------------------------------
  '$DATABASE' has only ${n:-0} server properties, so the gameserver has
  probably never run against it.

  The server creates those rows at boot. Until it has, every migration
  that only updates a property matches nothing and does nothing -- the
  experience rates, the loot rates, /level, and several others.

  Start the server once, wait for "Server is now listening", then run
  this again.
  ------------------------------------------------------------------

EOF
    read -r -p "  Carry on anyway? [y/N] " reply < /dev/tty || reply=n
    case "$reply" in
      [yY]*) echo ;;
      *) echo "  Stopped."; exit 1 ;;
    esac
  fi
}

BACKUPS=backups

fingerprint() {
  # A checksum per table. Row counts alone would miss a migration that only
  # updates rows, and most of the class corrections here do exactly that.
  docker exec -i -e MYSQL_PWD="$PW" "$CONTAINER" mysql -uroot -N -B "$DATABASE" -e "
    SELECT CONCAT(table_name)
      FROM information_schema.tables
     WHERE table_schema = '$DATABASE' AND table_type = 'BASE TABLE'
     ORDER BY table_name;" 2>/dev/null |
  while read -r t; do
    [[ -z "$t" ]] && continue
    docker exec -i -e MYSQL_PWD="$PW" "$CONTAINER" mysql -uroot -N -B "$DATABASE"       -e "CHECKSUM TABLE \`$t\`;" 2>/dev/null
  done
}

take_backup() {
  local stamp base
  stamp="$(date +%Y%m%d-%H%M%S)"
  base="$BACKUPS/${DATABASE}-${stamp}"
  mkdir -p "$BACKUPS"

  echo "Backing up '$DATABASE' first:"
  printf '  %-32s' "$(basename "$base").sql.gz"

  if docker exec -e MYSQL_PWD="$PW" "$CONTAINER"        mysqldump -uroot --single-transaction --quick --routines "$DATABASE"        2>/dev/null | gzip > "$base.sql.gz"; then
    echo "ok  ($(du -h "$base.sql.gz" | cut -f1))"
  else
    echo 'FAILED'
    echo "  Refusing to change the database without a backup." >&2
    echo "  Use --no-backup if you really mean to." >&2
    exit 1
  fi

  printf '  %-32s' "$(basename "$base").fingerprint"
  fingerprint > "$base.fingerprint" 2>/dev/null
  echo "ok  ($(wc -l < "$base.fingerprint") tables)"
  echo
}

newest_backup() {
  ls -1t "$BACKUPS/${DATABASE}"-*.sql.gz 2>/dev/null | head -1
}

do_restore() {
  local file="${1:-$(newest_backup)}"

  if [[ -z "$file" || ! -f "$file" ]]; then
    echo "No backup found for '$DATABASE' in $BACKUPS/" >&2
    exit 1
  fi

  echo "About to replace the '$DATABASE' database with:"
  echo "    $file  ($(du -h "$file" | cut -f1), $(date -r "$file" '+%Y-%m-%d %H:%M'))"
  echo
  echo "Everything since that backup is lost -- characters, items, the lot."
  read -r -p "Type the database name to confirm: " reply < /dev/tty || reply=""

  if [[ "$reply" != "$DATABASE" ]]; then
    echo "Stopped."
    exit 1
  fi

  echo "Restoring. Stop the gameserver first if it is running."
  gunzip -c "$file" | docker exec -i -e MYSQL_PWD="$PW" "$CONTAINER"     mysql -uroot --default-character-set=utf8mb3 "$DATABASE"
  echo "Done. Restart the gameserver."
  exit 0
}

do_diff() {
  local file="${1:-}"

  if [[ -z "$file" ]]; then
    file="$(ls -1t "$BACKUPS/${DATABASE}"-*.fingerprint 2>/dev/null | head -1)"
  fi

  if [[ -z "$file" || ! -f "$file" ]]; then
    echo "No fingerprint found for '$DATABASE'. One is written with every backup." >&2
    exit 1
  fi

  echo "Comparing '$DATABASE' against:"
  echo "    $file  ($(date -r "$file" '+%Y-%m-%d %H:%M'))"
  echo

  local now
  now="$(mktemp)"
  fingerprint > "$now"

  if diff -q "$file" "$now" >/dev/null; then
    echo "  No table differs."
  else
    echo "  Tables that differ:"
    join -j1 <(sort "$file") <(sort "$now") 2>/dev/null |
      awk '$2 != $3 { printf "    %-40s
", $1 }' | sed "s|$DATABASE.||"
    comm -13 <(cut -f1 "$file" | sort) <(cut -f1 "$now" | sort) |
      sed "s|^|    + |; s|$DATABASE.||"
  fi

  rm -f "$now"
  exit 0
}

# The two big generated migrations are committed, so this should never fire.
# It is here because their absence is otherwise silent: the loop below globs
# whatever is present, everything reports ok, and you find out weeks later
# that the Gate Warden offers Oceanus and nobody is there.
GENERATED="sql/13-atlantis-mobs.sql sql/15-volcanus.sql"
missing=""

for file in $GENERATED; do
  [[ -f "$file" ]] || missing="$missing $file"
done

if [[ -n "$missing" ]]; then
  cat >&2 <<EOF

  ------------------------------------------------------------------
  Migrations are missing from this checkout:
$(for f in $missing; do echo "      $f"; done)

  These are committed, so something has removed them. A fresh clone or
  a "git checkout -- sql/" will bring them back.

  Without them the conversion still installs and the server still runs
  -- but Atlantis and Deep Volcanus will be empty, and the travel
  network will happily send you to both.
  ------------------------------------------------------------------

EOF
  read -r -p "  Carry on without them? [y/N] " reply < /dev/tty || reply=n
  case "$reply" in
    [yY]*) echo ;;
    *) echo "  Stopped."; exit 1 ;;
  esac
fi

MANIFEST=sql/features.conf

feature_field() {
  # $1 feature, $2 field number (2 = depends on, 3 = migration numbers)
  awk -F'|' -v want="$1" -v col="$2" '
    /^[[:space:]]*#/ || /^[[:space:]]*$/ { next }
    { name = $1; gsub(/^[ 	]+|[ 	]+$/, "", name)
      if (name == want) { f = $col; gsub(/^[ 	]+|[ 	]+$/, "", f); print f; exit } }
  ' "$MANIFEST"
}

feature_names() {
  awk -F'|' '/^[[:space:]]*#/ || /^[[:space:]]*$/ { next }
             { gsub(/^[ 	]+|[ 	]+$/, "", $1); print $1 }' "$MANIFEST"
}

# Everything not named in the manifest belongs to base, so a migration added
# later is applied by default rather than quietly skipped.
base_extras() {
  local listed
  listed=" $(feature_names | while read -r f; do feature_field "$f" 3; done | tr '
' ' ') "
  for file in sql/[0-9]*.sql; do
    local n=${file##*/}; n=${n%%-*}; n=$((10#$n))
    [[ "$listed" == *" $n "* ]] || echo "$n"
  done
}

WANTED=""        # migration numbers to apply
SELECTED=""      # feature names already pulled in

# Common ways of asking for something, and what they really are.
resolve_alias() {
  case "$1" in
    mercs|merc|companions)     echo mercenaries ;;
    mauler)                    echo maulers ;;
    ml|mls|masterlevel)        echo masterlevels ;;
    champions|cl)              echo champion ;;
    ras|realmability|ra)       echo realmabilities ;;
    toa)                       echo atlantis ;;
    dungeons|td)               echo taskdungeons ;;
    # No set of migrations is one expansion: the bulk imports carry every
    # expansion class at once. Asking for an expansion gets all of them.
    catacombs|si|shrouded-isles|class|allclasses)
                               echo classes ;;
    *)                         echo "$1" ;;
  esac
}

want_feature() {
  local f asked
  asked="$1"
  f="$(resolve_alias "$asked")"

  if [[ "$f" != "$asked" ]]; then
    echo "  '$asked' means '$f' here."
    if [[ "$f" == "classes" ]]; then
      echo "  No set of migrations is one expansion -- the bulk imports at 46"
      echo "  and 89-92 carry every expansion class at once. Individual class"
      echo "  fixes ARE separable: try --list."
    fi
  fi

  case " $SELECTED " in *" $f "*) return 0 ;; esac

  local nums deps
  nums="$(feature_field "$f" 3)"
  deps="$(feature_field "$f" 2)"

  if [[ -z "$nums" && -z "$deps" ]]; then
    echo "Unknown feature: $f" >&2
    echo "Try: ./install.sh --list" >&2
    exit 1
  fi

  SELECTED="$SELECTED $f"

  for d in $deps; do
    [[ "$d" == "-" ]] && continue
    want_feature "$d"
  done

  WANTED="$WANTED $nums"
  [[ "$f" == "base" ]] && WANTED="$WANTED $(base_extras)"
  return 0
}

EXTRAS=""
FEATURES=""
DRYRUN=""
NOBACKUP=""
RESTORE=""
DIFF=""

for arg in "$@"; do
  case "$arg" in
    --list)
      echo "Features that can be installed on their own:"
      echo
      while IFS='|' read -r name deps _; do
        case "$name" in \#*|"") continue ;; esac
        name="$(echo "$name" | xargs)"; deps="$(echo "$deps" | xargs)"
        [[ -z "$name" ]] && continue
        printf '  %-14s needs: %s
' "$name" "$deps"
      done < "$MANIFEST"
      echo
      echo "  ./install.sh mercenaries      one feature and its dependencies"
      echo "  ./install.sh                  everything"
      echo
      echo "See docs/features.md for what each one is and which scripts go with it."
      exit 0
      ;;
    --dry-run)
      DRYRUN=1 ;;
    --no-backup)
      NOBACKUP=1 ;;
    --restore)
      RESTORE=1 ;;
    --diff)
      DIFF=1 ;;
    --testkit|--maintenance)
      EXTRAS="$EXTRAS $arg" ;;
    -*)
      echo "Unknown option: $arg" >&2
      exit 1 ;;
    *)
      FEATURES="$FEATURES $arg" ;;
  esac
done

[[ -n "$RESTORE" ]] && do_restore "${FEATURES// /}"
[[ -n "$DIFF" ]] && do_diff "${FEATURES// /}"

if [[ -z "$DRYRUN" ]]; then
  check_booted
fi

# A backup before anything is changed, because there is no down migration and
# no way to take a feature back out by hand.
if [[ -z "$DRYRUN" && -z "$NOBACKUP" ]]; then
  take_backup
fi

# Sorted by number, not as text. A plain glob sorts these lexically, which puts
# 100 between 10 and 11 -- so every migration numbered 100 and up was applied
# before 11 through 99, and the bulk spell imports at 46 and 90 then overwrote
# the corrections those later migrations had just made. Only a fresh install
# was affected; this database was built one migration at a time, in order,
# which is why it never showed here.
#
# The same trap applies to a feature: its migrations are applied in numeric
# order, never in the order they happen to be listed.
if [[ -n "${FEATURES// /}" ]]; then
  for f in $FEATURES; do want_feature "$f"; done

  echo "Applying:$SELECTED"

  for n in $(echo "$WANTED" | tr ' ' '
' | grep -E '^[0-9]+$' | sort -n -u); do
    for file in $(ls sql/[0-9]*.sql | sort -V); do
      b=${file##*/}; num=${b%%-*}
      if [[ $((10#$num)) -eq $n ]]; then apply "$file"; fi
    done
  done
else
  echo 'Applying the conversion:'
  for file in $(ls sql/[0-9]*.sql | sort -V); do
    apply "$file"
  done
fi

for arg in $EXTRAS; do
  case "$arg" in
    --testkit)
      echo 'Applying the testing kit:'
      for file in sql/optional/*.sql; do apply "$file"; done
      ;;
    --maintenance)
      echo 'Applying maintenance scripts:'
      for file in sql/maintenance/*.sql; do apply "$file"; done
      ;;
  esac
done

cat <<'EOF'

Done. The server reads most of this at boot, so restart it now:

    docker compose restart gameserver

Log out any character first -- OpenDAoC has no shutdown handler, so a
restart kills the process without saving, and anything since the last
autosave (10 minutes) is lost.
EOF
