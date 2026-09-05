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

# Common ways of asking for something, and what they really are. The class
# ones all land on `classes` because the class *data* cannot be split: the
# bulk imports at 46 and 89-92 carry every expansion class at once, so there
# is no set of migrations that is the Bainshee and not the Mauler. The
# *scripts* do separate, per folder -- see docs/features.md.
resolve_alias() {
  case "$1" in
    mercs|merc|companions)              echo mercenaries ;;
    catacombs|si|shrouded-isles|class)  echo classes ;;
    maulers|mauler|bainshee|valkyrie|warlock|vampiir|heretic|animist)
                                        echo classes ;;
    champion|champions|masterlevels|ml) echo progression ;;
    toa|artifacts)                      echo atlantis ;;
    dungeons|td)                        echo taskdungeons ;;
    *)                                  echo "$1" ;;
  esac
}

want_feature() {
  local f asked
  asked="$1"
  f="$(resolve_alias "$asked")"

  if [[ "$f" != "$asked" ]]; then
    echo "  '$asked' is part of '$f' -- installing that."
    if [[ "$f" == "classes" ]]; then
      echo "  The class data is one unit: migrations 46 and 89-92 carry every"
      echo "  expansion class at once. The scripts do separate, per folder."
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
    --testkit|--maintenance)
      EXTRAS="$EXTRAS $arg" ;;
    -*)
      echo "Unknown option: $arg" >&2
      exit 1 ;;
    *)
      FEATURES="$FEATURES $arg" ;;
  esac
done

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
