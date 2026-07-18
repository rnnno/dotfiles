#!/usr/bin/env bash
# plan-review.sh
# PreToolUse hook: intercepts ExitPlanMode and, when the plan's complexity
# score exceeds a threshold, requires a zero-context readability review by a
# haiku-model subagent BEFORE the plan is presented for user approval.
#
# Protocol injected into permissionDecisionReason:
#   1. Spawn a haiku subagent that reads the plan file with no conversation
#      context and lists implicit knowledge / ambiguities / missing criteria
#   2. Main triages findings (real plan gaps vs reviewer-capability noise)
#   3. Main revises the plan file to close the real gaps
#   4. Repeat from step 1 until no critical/major findings (max 3 rounds)
#   5. Append the issued approval token as a marker line in the plan file,
#      then retry ExitPlanMode
#
# Review completion is recorded IN the plan file itself: while the deny is
# being handled the session is still in plan mode, where the plan file is the
# only file the agent may write — and plan-file edits need no permission
# prompt, unlike shell commands. The hook issues a single-use token with each
# deny; the agent just copies it into the marker line. All hashing (staleness
# detection after later edits) happens hook-side.

set -euo pipefail

# ── Tunables (env-overridable) ────────────────────────────────────────────────
THRESHOLD="${PLAN_REVIEW_THRESHOLD:-15}"
MAX_DENIES="${PLAN_REVIEW_MAX_DENIES:-3}"
MAX_ROUNDS="${PLAN_REVIEW_MAX_ROUNDS:-3}"
STATE_DIR="${PLAN_REVIEW_STATE_DIR:-$HOME/.claude/plan-review-state}"
MARKER_PREFIX='<!-- plan-review:approved'

# ── Fail open if required tools are missing ───────────────────────────────────
command -v jq >/dev/null 2>&1 || exit 0
command -v shasum >/dev/null 2>&1 || exit 0

TOOL_INPUT="$(cat)"
PLAN_FILE="$(printf '%s' "$TOOL_INPUT" | jq -r '.tool_input.planFilePath // ""' 2>/dev/null || echo "")"

# Fail open when the plan file is unknown or missing
if [ -z "$PLAN_FILE" ] || [ ! -f "$PLAN_FILE" ]; then
    exit 0
fi

# ── Complexity score ──────────────────────────────────────────────────────────
NONEMPTY_LINES="$(grep -cv '^[[:space:]]*$' "$PLAN_FILE" || true)"
STEPS="$(grep -cE '^[[:space:]]*([0-9]+[.)][[:space:]]|[-*][[:space:]]\[[ xX]\])' "$PLAN_FILE" || true)"
# .spec./.test. は実体ファイルと同一視し、論理ファイル単位で数える
FILE_MENTIONS="$(grep -oE '[A-Za-z0-9_~/.-]*[A-Za-z0-9_-]\.[A-Za-z][A-Za-z0-9]{0,7}' "$PLAN_FILE" | sed -E 's/\.(spec|test)\./\./' | sort -u | wc -l | tr -d ' ' || true)"
SCORE=$(( NONEMPTY_LINES / 10 + STEPS * 2 + FILE_MENTIONS ))

if [ "$SCORE" -lt "$THRESHOLD" ]; then
    exit 0
fi

# ── Already reviewed? ─────────────────────────────────────────────────────────
# Hash of the plan content excluding marker lines, for staleness detection
CONTENT_HASH="$(grep -v "^${MARKER_PREFIX}" "$PLAN_FILE" | shasum | awk '{print $1}' | cut -c1-12 || true)"

mkdir -p "$STATE_DIR"
PATH_HASH="$(printf '%s' "$PLAN_FILE" | shasum | awk '{print $1}' | cut -c1-12)"
STATE_FILE="${STATE_DIR}/$(basename "$PLAN_FILE" .md)-${PATH_HASH}.json"
DENY_COUNT=0
ISSUED_TOKEN=""
APPROVED_HASH=""
LAST_CONTENT_HASH=""
if [ -f "$STATE_FILE" ]; then
    DENY_COUNT="$(jq -r '.deny_count // 0' "$STATE_FILE" 2>/dev/null || echo 0)"
    ISSUED_TOKEN="$(jq -r '.issued_token // ""' "$STATE_FILE" 2>/dev/null || echo "")"
    APPROVED_HASH="$(jq -r '.approved_hash // ""' "$STATE_FILE" 2>/dev/null || echo "")"
    LAST_CONTENT_HASH="$(jq -r '.last_content_hash // ""' "$STATE_FILE" 2>/dev/null || echo "")"
fi

# Content already approved and unchanged since → allow
if [ -n "$APPROVED_HASH" ] && [ "$APPROVED_HASH" = "$CONTENT_HASH" ]; then
    exit 0
fi

# Content changed since the last recorded run (new review cycle) → reset the deny budget
if [ "$LAST_CONTENT_HASH" != "$CONTENT_HASH" ]; then
    DENY_COUNT=0
fi

# Marker carries the token issued with the last deny → review round-trip done.
# Consume the token, reset the deny budget, and record the approved content hash.
MARKER_TOKEN="$(grep "^${MARKER_PREFIX}" "$PLAN_FILE" 2>/dev/null | tail -1 | sed -nE 's/.*token=([A-Za-z0-9-]+).*/\1/p' || true)"
if [ -n "$MARKER_TOKEN" ] && [ "$MARKER_TOKEN" = "$ISSUED_TOKEN" ]; then
    jq -n \
        --arg h "$CONTENT_HASH" \
        '{"deny_count": 0, "issued_token": "", "approved_hash": $h, "last_content_hash": $h}' \
        > "$STATE_FILE" 2>/dev/null || true
    exit 0
fi

# ── Backstop: too many consecutive denies → warn and allow ────────────────────
if [ "$DENY_COUNT" -ge "$MAX_DENIES" ]; then
    printf '[plan-review] Backstop reached (%d denies). Allowing ExitPlanMode.\n' "$DENY_COUNT" >&2
    exit 0
fi

DENY_COUNT=$((DENY_COUNT + 1))
NEW_TOKEN="t${DENY_COUNT}-$(printf '%s' "$CONTENT_HASH" | cut -c1-8)"
jq -n \
    --argjson dc "$DENY_COUNT" \
    --argjson sc "$SCORE" \
    --arg t "$NEW_TOKEN" \
    --arg ch "$CONTENT_HASH" \
    '{"deny_count": $dc, "last_score": $sc, "issued_token": $t, "approved_hash": "", "last_content_hash": $ch}' \
    > "$STATE_FILE" 2>/dev/null || true

# ── Emit deny JSON ────────────────────────────────────────────────────────────
REASON="Plan complexity review required before requesting approval (score ${SCORE} >= threshold ${THRESHOLD}; lines=${NONEMPTY_LINES}, steps=${STEPS}, files=${FILE_MENTIONS}; gate attempt ${DENY_COUNT}/${MAX_DENIES}).

Goal: surface the implicit knowledge this plan assumes. A reader with zero context must be able to execute it. Follow this protocol exactly:

STEP 1 — REVIEW: Spawn a subagent with model: haiku (its lack of conversation context is the point) with this instruction: \"Read the implementation plan at ${PLAN_FILE}. You are the implementer and have NO prior context — you have not seen the conversation that produced this plan. Return numbered findings with severity (critical/major/minor): (a) steps you could not execute without asking someone a question, (b) terms, paths, commands or assumptions the plan relies on but never defines, (c) statements interpretable in more than one way, (d) missing completion criteria or verification steps. If the plan is fully self-contained, state that explicitly.\"

STEP 2 — TRIAGE: Split the findings into real plan gaps vs noise from the reviewer's capability limits. Only real gaps require action.

STEP 3 — REVISE: Edit ${PLAN_FILE} to close every real gap: define terms, add exact paths and commands, make ambiguous steps concrete, add completion criteria. Editing the plan file is allowed in plan mode.

STEP 4 — LOOP: Re-run STEP 1 on the revised plan. Repeat until the reviewer reports no critical/major findings, up to ${MAX_ROUNDS} review rounds total.

STEP 5 — MARK REVIEWED: Append this single line at the very end of ${PLAN_FILE} (a plan-file edit, allowed in plan mode; replace N with the number of review rounds performed):
${MARKER_PREFIX} token=${NEW_TOKEN} rounds=N -->
Then call ExitPlanMode again. Do not run any shell command for this step."

jq -n --arg reason "$REASON" \
    '{"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "deny", "permissionDecisionReason": $reason}}'

exit 0
