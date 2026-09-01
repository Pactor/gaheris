#!/usr/bin/env bash
#
# Pushes the scripts in this repo to an existing deployment elsewhere.
#
# Only needed if your server directory is not this repo -- which is the case
# for the original E:\DAOC install, where the server lives in ~/opendaoc and
# the repo is a separate checkout. A fresh install does not need this: the
# compose file mounts ./scripts directly, so the repo IS the deployment.
#
# Usage:  ./sync-to-live.sh [target]      (default ~/opendaoc)
#
set -euo pipefail

cd "$(dirname "$0")"

TARGET="${1:-$HOME/opendaoc}"

if [[ ! -d "$TARGET" ]]; then
  echo "No such deployment: $TARGET" >&2
  exit 1
fi

mkdir -p "$TARGET/scripts"
cp -v scripts/*.cs "$TARGET/scripts/"
cp -v sql/[0-9]*.sql sql/optional/*.sql sql/maintenance/*.sql "$TARGET/"

cat <<EOF

Copied to $TARGET.

Compile-check before restarting -- the scripts directory builds as ONE
assembly, so a single bad file takes the whole server down:

    ~/.dotnet/dotnet build ~/scriptcheck/scriptcheck.csproj
EOF
