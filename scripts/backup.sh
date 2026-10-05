#!/bin/bash
# AIOS weekly backup — commit local .agent changes and push to GitHub.
# Scheduled by launchd (see ~/Library/LaunchAgents/com.aios.backup.plist).
# Secrets are excluded by .gitignore and are never staged.

set -uo pipefail

REPO="/Users/zeynepatalubalci/.agent"
LOG="$REPO/.backup.log"
LOCK="/tmp/aios-backup.lock"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG"
}

# Prevent overlapping runs if a previous push is still hanging on the network.
if ! mkdir "$LOCK" 2>/dev/null; then
  log "SKIP: previous run still active (lock held)"
  exit 0
fi
trap 'rmdir "$LOCK" 2>/dev/null' EXIT

cd "$REPO" || { log "ERROR: cannot cd to $REPO"; exit 1; }

log "=== backup run started ==="

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  log "ERROR: not a git repository"
  exit 1
fi

# Belt-and-braces: ensure secrets can never be staged, even if .gitignore is edited.
SECRETS="config/google/ token.json credentials.json .env client_secret"
for pattern in $SECRETS; do
  git check-ignore -q "$pattern" 2>/dev/null || \
    echo "${pattern}" >> "$REPO/.gitignore"
done

git add -A

STAGED=$(git diff --cached --name-only)

if [ -z "$STAGED" ]; then
  log "No changes to commit. Nothing to push."
  exit 0
fi

# Refuse to commit anything that looks like a credential file.
LEAK=$(git diff --cached --name-only | grep -Ei '(^|/)(token|credentials|client_secret|\.env)|\.pem$|id_rsa' || true)
if [ -n "$LEAK" ]; then
  log "ABORT: refusing to commit possible secret files:"
  echo "$LEAK" >> "$LOG"
  exit 1
fi

COUNT=$(echo "$STAGED" | wc -l | tr -d ' ')
log "Staged $COUNT file(s):"
echo "$STAGED" >> "$LOG"

MSG="Weekly AIOS backup: sync local .agent changes"
log "Committing: $MSG"
if ! git commit -m "$MSG" >> "$LOG" 2>&1; then
  log "ERROR: commit failed"
  exit 1
fi

SHA=$(git rev-parse --short HEAD)
log "Committed $SHA"

# Never hang waiting for a password prompt.
export GIT_TERMINAL_PROMPT=0

log "Pushing to origin/main"
if git push origin main >> "$LOG" 2>&1; then
  log "SUCCESS: pushed $SHA to origin/main"
else
  log "ERROR: push failed (see above). Local commit $SHA is safe and unpushed."
  exit 1
fi

log "=== backup run finished ==="