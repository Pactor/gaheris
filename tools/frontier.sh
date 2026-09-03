#!/usr/bin/env bash
#
# frontier.sh -- switch between Old and New Frontiers, reversibly.
#
#   ./tools/frontier.sh status     what is loaded now
#   ./tools/frontier.sh backup     snapshot, and nothing else
#   ./tools/frontier.sh new        switch to New Frontiers
#   ./tools/frontier.sh old        switch back to Old Frontiers
#   ./tools/frontier.sh restore <file>   put a snapshot back
#
# Why a switch rather than a migration.
#
# Old and New Frontiers share one KeepID space. A server holds one set or the
# other and never both: 50-56, 75-81 and 100-106 are Caer Benowyc, Bledmeer
# Faste, Dun Crauchon and their neighbours in BOTH sets, at different
# coordinates in different regions. So this is not an import that adds
# something, it is a swap that replaces something, and the only safe way to
# offer it is with the way back written at the same time as the way there.
#
# What it moves:
#   keep            the keeps themselves
#   keepcomponent   their structures, and so their doors, lords and garrison
#   regions         which region is flagged as the frontier
#   teleport        the travel catalogue's frontier destinations
#
# What it does NOT move, and you should know before you switch:
#
#   The 872 hand-placed MonsterGuard mobs in regions 1, 100 and 200 stay where
#   they are. They are our Gaheris garrison and they are pinned to coordinates
#   in the old frontier zones. Under New Frontiers those zones still exist and
#   still have the guards standing in them -- they will simply be guarding
#   ground with no keep on it, while the New Frontiers keeps raise their own
#   garrison from keepposition, which names core RvR guard classes rather than
#   ours. That question is written up in docs/new-frontiers-plan.md and is the
#   real work left; this script is the part that makes trying it safe.
#
set -euo pipefail

cd "$(dirname "$0")/.."
[ -f .env ] || { echo "no .env beside docker-compose.yml"; exit 1; }
set -a; . ./.env; set +a

BACKUPS="backups"
PAYLOAD="sql/frontier"
mkdir -p "$BACKUPS"

db() { docker compose exec -T db mysql -uroot -p"$DB_PASSWORD" opendaoc "$@" </dev/null 2>&1 | grep -v "Using a password" || true; }
dbq() { db -N -B -e "$1"; }

# --- what is loaded --------------------------------------------------------
current_mode() {
    local nf old
    nf=$(dbq "SELECT COUNT(*) FROM keep WHERE Region = 163;")
    old=$(dbq "SELECT COUNT(*) FROM keep WHERE Region IN (1,100,200);")
    if   [ "${nf:-0}" -gt 0 ] && [ "${old:-0}" -eq 0 ]; then echo new
    elif [ "${old:-0}" -gt 0 ] && [ "${nf:-0}" -eq 0 ]; then echo old
    elif [ "${old:-0}" -eq 0 ] && [ "${nf:-0}" -eq 0 ]; then echo none
    else echo BOTH
    fi
}

status() {
    local mode; mode=$(current_mode)
    echo "frontier: $mode"
    db -e "SELECT
             (SELECT COUNT(*) FROM keep WHERE Region IN (1,100,200))  AS old_keeps,
             (SELECT COUNT(*) FROM keep WHERE Region = 163)           AS new_keeps,
             (SELECT COUNT(*) FROM keepcomponent c JOIN keep k ON k.KeepID=c.KeepID
                WHERE k.Region = 163)                                 AS new_components,
             (SELECT IsFrontier FROM regions WHERE RegionID = 163)    AS region_163_is_frontier,
             (SELECT COUNT(*) FROM teleport WHERE Type='gaheris' AND RegionID=163) AS nf_destinations;"
    if [ "$mode" = "BOTH" ]; then
        echo
        echo "  BOTH sets are loaded. They share KeepIDs and must not be; run"
        echo "  './tools/frontier.sh old' or '... new' to settle it."
    fi
}

# --- snapshot --------------------------------------------------------------
backup() {
    local tag="${1:-manual}"
    local stamp file
    stamp=$(date +%Y%m%d-%H%M%S)
    file="$BACKUPS/frontier-$tag-$stamp.sql"

    echo "backing up to $file"
    docker compose exec -T db mysqldump -uroot -p"$DB_PASSWORD" \
        --single-transaction --no-tablespaces --complete-insert \
        opendaoc keep keepcomponent keepposition keephookpoint regions teleport \
        </dev/null 2>/dev/null > "$file"

    if [ ! -s "$file" ]; then
        echo "backup is empty -- refusing to go further"; rm -f "$file"; exit 1
    fi
    echo "  $(wc -l < "$file") lines"
    echo "$file"
}

restore() {
    local file="$1"
    [ -s "$file" ] || { echo "no such backup: $file"; exit 1; }
    echo "restoring $file"
    docker compose exec -T db mysql -uroot -p"$DB_PASSWORD" opendaoc < "$file" 2>&1 | grep -v "Using a password" || true
    echo "restored. restart the game server to load it."
}

# --- the switch ------------------------------------------------------------
switch_to() {
    local want="$1" have
    have=$(current_mode)

    if [ "$have" = "$want" ]; then
        echo "already on $want frontiers. nothing to do."
        status
        exit 0
    fi

    [ -f "$PAYLOAD/$want-frontiers.sql" ] || { echo "missing $PAYLOAD/$want-frontiers.sql"; exit 1; }

    backup "before-$want" > /dev/null
    local saved; saved=$(ls -t "$BACKUPS"/frontier-before-"$want"-*.sql | head -1)
    echo "snapshot: $saved"

    echo "clearing the frontier keeps and their structures"
    db -e "DELETE c FROM keepcomponent c JOIN keep k ON k.KeepID = c.KeepID
            WHERE k.Region IN (1, 100, 200, 163);"
    db -e "DELETE FROM keep WHERE Region IN (1, 100, 200, 163);"

    echo "loading $want frontiers"
    docker compose exec -T db mysql -uroot -p"$DB_PASSWORD" opendaoc < "$PAYLOAD/$want-frontiers.sql" 2>&1 | grep -v "Using a password" || true

    echo "pointing travel at the right frontier"
    if [ "$want" = "new" ]; then
        db -e "UPDATE teleport SET Type = 'gaheris' WHERE Type = 'gaheris-parked' AND RegionID = 163;"
    else
        db -e "UPDATE teleport SET Type = 'gaheris-parked' WHERE Type = 'gaheris' AND RegionID = 163;"
    fi

    echo
    status
    echo
    echo "restart the game server to load it:  docker compose restart gameserver"
    echo "to undo:  ./tools/frontier.sh restore $saved"
}

case "${1:-status}" in
    status)  status ;;
    backup)  backup manual ;;
    restore) restore "${2:?usage: frontier.sh restore <file>}" ;;
    new|old) switch_to "$1" ;;
    *) sed -n '3,12p' "$0"; exit 1 ;;
esac
