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
