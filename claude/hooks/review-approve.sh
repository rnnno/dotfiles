#!/usr/bin/env bash
# review-approve.sh
# Records the current staged diff hash as "approved" so the next git commit
# attempt passes through the pre-commit-review hook without being blocked.
#
# Run this after code-reviewer reports no addressable findings (or after
# exhausting the 3 review iterations).

set -euo pipefail

GIT_DIR="$(git rev-parse --git-dir 2>/dev/null)" || {
    printf 'Error: not inside a git repository.\n' >&2
    exit 1
}

STATE_FILE="${GIT_DIR}/claude-review-state.json"

STAGED_HASH="$(git diff --cached 2>/dev/null | shasum | awk '{print $1}')"

if [ -z "$STAGED_HASH" ] || [ "$STAGED_HASH" = "da39a3ee5e6b4b0d3255bfef95601890afd80709" ]; then
    printf 'Error: no staged changes found. Stage your changes before approving.\n' >&2
    exit 1
fi

# Preserve existing state fields, update approved_hash
BLOCK_COUNT=0
PREV_STAGED_HASH=""
if [ -f "$STATE_FILE" ]; then
    BLOCK_COUNT="$(jq -r '.block_count // 0' "$STATE_FILE" 2>/dev/null || echo "0")"
    PREV_STAGED_HASH="$(jq -r '.staged_hash // ""' "$STATE_FILE" 2>/dev/null || echo "")"
fi

jq -n \
    --arg sh "$STAGED_HASH" \
    --argjson bc "$BLOCK_COUNT" \
    --arg ah "$STAGED_HASH" \
    '{"staged_hash": $sh, "block_count": $bc, "approved_hash": $ah}' \
    > "$STATE_FILE"

printf 'Review approved. Staged hash: %s\nThe next git commit will proceed without review blocking.\n' "$STAGED_HASH"
