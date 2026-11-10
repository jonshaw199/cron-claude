#!/usr/bin/env bash
# Serve the cron-claude dashboard against the live state dir (all jobs' status.json).
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STATE_DIR="${CRON_CLAUDE_STATE:-$HOME/.local/state/cron-claude}"
: "${DASHBOARD_PORT:=4321}"
mkdir -p "$STATE_DIR"
cp "$ROOT/dashboard/index.html" "$STATE_DIR/index.html"
# Manifest of jobs that have run (one subdir with a status.json each).
names=""
for d in "$STATE_DIR"/*/status.json; do [ -f "$d" ] && names="$names\"$(basename "$(dirname "$d")")\","; done
printf '[%s]\n' "${names%,}" > "$STATE_DIR/jobs.json"
echo "Dashboard: http://localhost:$DASHBOARD_PORT  (Ctrl-C to stop)"
cd "$STATE_DIR" && exec python3 -m http.server "$DASHBOARD_PORT"
