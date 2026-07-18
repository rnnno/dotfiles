#!/usr/bin/env bash
# pre-commit-review.sh
# PreToolUse hook: intercepts `git commit` and enforces the 3-agent review protocol.
#
# Protocol injected into permissionDecisionReason:
#   1. Spawn code-reviewer (effort high) on `git diff --cached`
#   2. Main selects findings to address (iteration 1: all / iteration 2+: critical+high only)
#   3. Pass selected findings to review-fixer (effort medium) → fix → `git add`
#   4. Repeat from step 1 until no addressable findings (max 3 review iterations)
#   5. Run `bash ~/.claude/hooks/review-approve.sh` then retry the commit

set -euo pipefail

# ── Read tool input from stdin ──────────────────────────────────────────────
TOOL_INPUT="$(cat)"
COMMAND="$(printf '%s' "$TOOL_INPUT" | jq -r '.tool_input.command // ""' 2>/dev/null || echo "")"

# ── Only intercept actual `git commit` commands ──────────────────────────────
# Pass through: git commit --help, git commit-tree, git status, etc.
if ! printf '%s' "$COMMAND" | grep -qE '(^|[;&|]) *git commit($| [^-]| -[^-]| --[^h])' 2>/dev/null; then
    exit 0
fi
HELP_SEGMENT="$(printf '%s' "$COMMAND" | grep -oE '(^|[;&|]) *git commit[^;&|]*' | head -n1)" || true
HELP_SEGMENT="$(printf '%s' "$HELP_SEGMENT" | sed -E 's/"[^"]*"//g')"
HELP_SEGMENT="$(printf '%s' "$HELP_SEGMENT" | sed -E "s/'[^']*'//g")"
if printf '%s' "$HELP_SEGMENT" | grep -qE '(--help|[[:space:]]-h([[:space:]]|$))'; then
    exit 0
fi

# ── Resolve git repo root and state file ────────────────────────────────────
GIT_DIR="$(git rev-parse --git-dir 2>/dev/null)" || { exit 0; }
STATE_FILE="${GIT_DIR}/claude-review-state.json"

# ── Compute staged diff hash ─────────────────────────────────────────────────
STAGED_HASH="$(git diff --cached 2>/dev/null | shasum | awk '{print $1}')"

# Nothing staged — let git handle the "nothing to commit" error naturally
if [ -z "$STAGED_HASH" ] || [ "$STAGED_HASH" = "da39a3ee5e6b4b0d3255bfef95601890afd80709" ]; then
    exit 0
fi

# ── Load existing state ───────────────────────────────────────────────────────
APPROVED_HASH=""
BLOCK_COUNT=0
PREV_STAGED_HASH=""

if [ -f "$STATE_FILE" ]; then
    APPROVED_HASH="$(jq -r '.approved_hash // ""' "$STATE_FILE" 2>/dev/null || echo "")"
    PREV_STAGED_HASH="$(jq -r '.staged_hash // ""' "$STATE_FILE" 2>/dev/null || echo "")"
    BLOCK_COUNT="$(jq -r '.block_count // 0' "$STATE_FILE" 2>/dev/null || echo "0")"
fi

# ── Already approved for this exact staged content → ALLOW ───────────────────
if [ -n "$APPROVED_HASH" ] && [ "$APPROVED_HASH" = "$STAGED_HASH" ]; then
    exit 0
fi

# ── STEP 0: Format / Lint / Typecheck (fast gates before AI review) ───────────
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || REPO_ROOT=""
if [ -n "$REPO_ROOT" ]; then
    ORIG_DIR="$PWD"
    cd "$REPO_ROOT"

    # Format — run if script or biome config exists
    if [ -f "package.json" ] && grep -q '"format"' package.json 2>/dev/null; then
        npm run format --silent 2>/dev/null || true
    elif [ -f "biome.json" ]; then
        npx biome format --write . 2>/dev/null || true
    fi

    # If formatter changed any staged file → block and ask to re-stage
    if ! git diff --quiet 2>/dev/null; then
        cd "$ORIG_DIR"
        jq -n '{"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "deny", "permissionDecisionReason": "Formatter changed files. Run `git add` to re-stage the formatted files, then retry the commit."}}'
        exit 0
    fi

    # Lint
    set +e
    LINT_EXIT=0
    LINT_OUTPUT=""
    if [ -f "package.json" ] && grep -q '"lint"' package.json 2>/dev/null; then
        LINT_OUTPUT="$(npm run lint 2>&1)"
        LINT_EXIT=$?
    elif [ -f "biome.json" ]; then
        LINT_OUTPUT="$(npx biome check . 2>&1)"
        LINT_EXIT=$?
    fi
    set -e

    if [ "$LINT_EXIT" -ne 0 ]; then
        cd "$ORIG_DIR"
        jq -n --arg r "Lint errors must be fixed before committing. Fix the errors below and retry.

${LINT_OUTPUT}" \
            '{"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "deny", "permissionDecisionReason": $r}}'
        exit 0
    fi

    # Typecheck (TypeScript only)
    if [ -f "tsconfig.json" ]; then
        set +e
        TC_EXIT=0
        TC_OUTPUT=""
        if [ -f "package.json" ] && grep -q '"typecheck"' package.json 2>/dev/null; then
            TC_OUTPUT="$(npm run typecheck 2>&1)"
            TC_EXIT=$?
        else
            TC_OUTPUT="$(npx tsc --noEmit 2>&1)"
            TC_EXIT=$?
        fi
        set -e

        if [ "$TC_EXIT" -ne 0 ]; then
            cd "$ORIG_DIR"
            jq -n --arg r "TypeScript errors must be fixed before committing.

${TC_OUTPUT}" \
                '{"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "deny", "permissionDecisionReason": $r}}'
            exit 0
        fi
    fi

    # Unit tests (vitest/jest etc. via `npm test`) — fast gate before AI review.
    # E2E suites (build + external deps like DynamoDB/Mailosaur) are intentionally
    # NOT run here. Bypass for a single commit with SKIP_PRECOMMIT_TESTS=1.
    TEST_SCRIPT="$(jq -r '.scripts.test // ""' package.json 2>/dev/null || echo "")"
    if [ "${SKIP_PRECOMMIT_TESTS:-}" != "1" ] && [ -f "package.json" ] && [ -n "$TEST_SCRIPT" ] && ! printf '%s' "$TEST_SCRIPT" | grep -q 'no test specified'; then
        set +e
        TEST_OUTPUT="$(CI=true npm test 2>&1)"
        TEST_EXIT=$?
        set -e

        if [ "$TEST_EXIT" -ne 0 ]; then
            cd "$ORIG_DIR"
            jq -n --arg r "Unit tests must pass before committing. Fix the failures below and retry, or set SKIP_PRECOMMIT_TESTS=1 to bypass for this commit.

${TEST_OUTPUT}" \
                '{"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "deny", "permissionDecisionReason": $r}}'
            exit 0
        fi
    fi

    cd "$ORIG_DIR"
fi

# ── Update block count ────────────────────────────────────────────────────────
if [ "$PREV_STAGED_HASH" != "$STAGED_HASH" ]; then
    # Staged content changed (new round) — reset
    BLOCK_COUNT=1
else
    BLOCK_COUNT=$((BLOCK_COUNT + 1))
fi

# Save updated state
jq -n \
    --arg sh "$STAGED_HASH" \
    --argjson bc "$BLOCK_COUNT" \
    --arg ah "$APPROVED_HASH" \
    '{"staged_hash": $sh, "block_count": $bc, "approved_hash": $ah}' \
    > "$STATE_FILE" 2>/dev/null || true

# ── Backstop: too many consecutive blocks → warn and allow ───────────────────
if [ "$BLOCK_COUNT" -gt 5 ]; then
    printf '[pre-commit-review] Backstop reached (%d blocks). Allowing commit.\n' "$BLOCK_COUNT" >&2
    exit 0
fi

# ── Determine iteration label for instructions ───────────────────────────────
if [ "$BLOCK_COUNT" -le 1 ]; then
    ITERATION_INSTRUCTION="This is review iteration 1. Address ALL findings that require action (all severities: critical, high, medium, low)."
else
    ITERATION_INSTRUCTION="This is review iteration ${BLOCK_COUNT}. Address ONLY critical and high severity findings. Ignore medium and low to avoid infinite fix loops."
fi

# ── Emit deny JSON ────────────────────────────────────────────────────────────
REASON="Pre-commit review required. Follow this protocol exactly:

STEP 1 — REVIEW: Spawn the \`code-reviewer\` subagent (effort: high) with the instruction: \"Review the staged changes via \`git diff --cached\`. Return a severity-classified findings report.\"

STEP 2 — TRIAGE: Read the findings report. ${ITERATION_INSTRUCTION}

STEP 3 — FIX (if findings to address): Spawn the \`review-fixer\` subagent (effort: medium) and pass it the selected findings list with file paths, line numbers, descriptions, and suggested fixes. Wait for its fix report.

STEP 4 — RE-STAGE: After review-fixer completes, run \`git add\` on all modified files.

STEP 5 — LOOP: Go back to STEP 1 for another review round. Maximum 3 review iterations total. If iteration 3 has no critical/high findings (or 3 iterations are exhausted), proceed to STEP 6.

STEP 6 — APPROVE AND COMMIT: Run \`bash ~/.claude/hooks/review-approve.sh\` to record approval, then retry the git commit command."

jq -n --arg reason "$REASON" \
    '{"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "deny", "permissionDecisionReason": $reason}}'

exit 0
