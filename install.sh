#!/usr/bin/env bash
#
# Applies the Gaheris conversion to a running OpenDAoC database.
#
# Every migration is idempotent, so this is safe to re-run -- after pulling
# an update, or when you want to be sure the world matches the repo.
#
# Usage:
#   ./install.sh                 core conversion only
#   ./install.sh --testkit       also the optional testing kit
#   ./install.sh --maintenance   also the one-off repair scripts
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

echo 'Applying the conversion:'
for file in sql/[0-9]*.sql; do
  apply "$file"
done

for arg in "$@"; do
  case "$arg" in
    --testkit)
      echo 'Applying the testing kit:'
      for file in sql/optional/*.sql; do apply "$file"; done
      ;;
    --maintenance)
      echo 'Applying maintenance scripts:'
      for file in sql/maintenance/*.sql; do apply "$file"; done
      ;;
    *)
      echo "Unknown option: $arg" >&2
      exit 1
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
