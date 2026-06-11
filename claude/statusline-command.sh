#!/bin/sh

# ── Colors (256-color palette) ────────────────────────────────────────────────
RESET='\033[0m'
DIR_C='\033[38;5;75m'           # cwd (sky blue)
BRANCH_C='\033[38;5;176m'       # git branch (violet)
ADD_C='\033[38;5;114m'          # git insertions (green)
DEL_C='\033[38;5;167m'          # git deletions (red)
MODEL_C='\033[38;5;174m'        # model name (muted rose)
EFFORT_C='\033[38;5;138m'       # effort level (dusty rose)
CTX_OK_C='\033[38;5;184m'       # ctx < 70% (muted yellow)
CTX_WARN_C='\033[38;5;208m'     # ctx >= 70%
CTX_DANGER_C='\033[38;5;196m'   # ctx >= 90%
IN_C='\033[38;5;74m'            # input tokens (steel blue, near dir)
OUT_C='\033[38;5;137m'          # output tokens (clay orange)
CACHE_C='\033[38;5;140m'        # cached tokens (purple)
SESSION_C='\033[38;5;80m'       # session clock (turquoise)
COST_C='\033[38;5;179m'         # cost (yellow)
SEP_C='\033[38;5;240m'          # separators / parens (gray)
RL_OK_TXT='\033[38;5;114m'      # rate limit text normal
RL_WARN_TXT='\033[38;5;208m'    # rate limit text warning (>= 70%)
RL_DANGER_TXT='\033[38;5;196m'  # rate limit text danger  (>= 90%)
RL_OK_BAR='\033[2;38;5;114m'    # rate limit bar normal (dim)
RL_WARN_BAR='\033[2;38;5;208m'  # rate limit bar warning (dim)
RL_DANGER_BAR='\033[2;38;5;196m' # rate limit bar danger (dim)

# ── Nerd Font icons (octal UTF-8 escapes) ────────────────────────────────────
ICON_DIR="$(printf '\357\201\274')"        # U+F07C  nf-fa-folder_open
ICON_BRANCH="$(printf '\356\234\245')"     # U+E725  nf-dev-git_branch
ICON_MODEL="$(printf '\363\260\247\221')"  # U+F09D1 nf-md-brain
ICON_CTX="$(printf '\363\260\215\233')"    # U+F035B nf-md-memory
ICON_IN="$(printf '\357\201\243')"         # U+F063  nf-fa-arrow_down
ICON_OUT="$(printf '\357\201\242')"        # U+F062  nf-fa-arrow_up
ICON_CACHE="$(printf '\357\207\200')"      # U+F1C0  nf-fa-database
ICON_RATE="$(printf '\363\260\223\205')"   # U+F04C5 nf-md-speedometer
ICON_CLOCK="$(printf '\357\200\227')"      # U+F017  nf-fa-clock
ICON_COST="$(printf '\357\205\225')"       # U+F155  nf-fa-dollar

# ── Parse input ───────────────────────────────────────────────────────────────
input=$(cat)

cwd=$(echo "$input"    | jq -r '.workspace.current_dir // .cwd // ""')
model=$(echo "$input"  | jq -r '.model.display_name // .model.id // "unknown"')
effort_level=$(echo "$input" | jq -r '.effort.level // empty')

# Context window
ctx_used=$(echo "$input"   | jq -r '.context_window.used_percentage // empty')
in_tok=$(echo "$input"     | jq -r '.context_window.total_input_tokens // empty')
out_tok=$(echo "$input"    | jq -r '.context_window.total_output_tokens // empty')
cache_tok=$(echo "$input"  | jq -r '(.context_window.current_usage.cache_read_input_tokens // 0) + (.context_window.current_usage.cache_creation_input_tokens // 0) | if . == 0 then empty else . end')

# Cost
total_cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')
total_duration_ms=$(echo "$input" | jq -r '.cost.total_api_duration_ms // empty')

# Rate limits
five_hour_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
seven_day_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
five_hour_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
seven_day_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

# ── Row 1: CWD ❯ Git branch (changes) ─────────────────────────────────────────
dir_label=$(echo "$cwd" | sed "s|$HOME|~|")

git_branch=""
insertions=""
deletions=""
if [ -n "$cwd" ] && git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  git_branch=$(git --no-optional-locks -C "$cwd" symbolic-ref --short HEAD 2>/dev/null \
               || git --no-optional-locks -C "$cwd" rev-parse --short HEAD 2>/dev/null)

  diff_stat=$(git --no-optional-locks -C "$cwd" diff --shortstat HEAD 2>/dev/null)
  insertions=$(echo "$diff_stat" | grep -o '[0-9]* insertion' | grep -o '[0-9]*')
  deletions=$(echo "$diff_stat" | grep -o '[0-9]* deletion' | grep -o '[0-9]*')
fi

row1=""
row1="${row1}$(printf "${DIR_C}${ICON_DIR} %s${RESET}" "$dir_label")"
if [ -n "$git_branch" ]; then
  row1="${row1}$(printf " ${SEP_C}❯${RESET} ${BRANCH_C}${ICON_BRANCH} %s${RESET}" "$git_branch")"
  if [ "${insertions:-0}" -gt 0 ] || [ "${deletions:-0}" -gt 0 ] 2>/dev/null; then
    row1="${row1}$(printf " ${SEP_C}(${ADD_C}+%s${RESET} ${DEL_C}-%s${SEP_C})${RESET}" "${insertions:-0}" "${deletions:-0}")"
  fi
fi

# ── Row 2: Model · ctx NN% · in NNk · out NNk · cached NNk ───────────────────
ctx_color="$CTX_OK_C"
if [ -n "$ctx_used" ]; then
  ctx_int=$(printf '%.0f' "$ctx_used")
  ctx_label="${ctx_int}%"
  if [ "$ctx_int" -ge 90 ] 2>/dev/null; then
    ctx_color="$CTX_DANGER_C"
  elif [ "$ctx_int" -ge 70 ] 2>/dev/null; then
    ctx_color="$CTX_WARN_C"
  fi
else
  ctx_label="--"
fi

rate_reset_info() {
  resets_at="$1"
  style="$2"
  icon="$(printf '\357\200\236')" # U+F01E nf-fa-rotate_right
  case "$resets_at" in ''|*[!0-9]*) return;; esac
  now=$(date +%s)
  remaining=$((resets_at - now))
  [ "$remaining" -le 0 ] && return
  if [ "$style" = "dh" ] && [ "$remaining" -ge 86400 ]; then
    total_h=$(( (remaining + 3599) / 3600 ))
    d=$((total_h / 24))
    h=$((total_h % 24))
    if [ "$h" -gt 0 ]; then
      printf '%s%dd %dh' "$icon" "$d" "$h"
    else
      printf '%s%dd' "$icon" "$d"
    fi
  elif [ "$remaining" -ge 3600 ]; then
    if [ "$style" = "dh" ]; then
      printf '%s%dh' "$icon" $(( (remaining + 3599) / 3600 ))
    else
      h=$((remaining / 3600))
      m=$(( (remaining % 3600 + 59) / 60 ))
      if [ "$m" -ge 60 ]; then
        h=$((h + 1))
        m=0
      fi
      if [ "$m" -gt 0 ]; then
        printf '%s%dh %dm' "$icon" "$h" "$m"
      else
        printf '%s%dh' "$icon" "$h"
      fi
    fi
  else
    printf '%s%dm' "$icon" $(( (remaining + 59) / 60 ))
  fi
}

rate_segment() {
  label="$1"
  pct="$2"
  extra="$3"
  filled=$(printf '%.0f' "$(echo "$pct" | awk '{v=$1/10; if(v>10)v=10; if(v<0)v=0; printf "%.0f",v}')")
  bar=""
  i=0
  while [ "$i" -lt 10 ]; do
    if [ "$i" -lt "$filled" ]; then bar="${bar}█"; else bar="${bar}░"; fi
    i=$((i+1))
  done
  pct_int=$(printf '%.0f' "$pct")
  if [ "$pct_int" -ge 90 ] 2>/dev/null; then
    txt_color="$RL_DANGER_TXT"
    bar_color="$RL_DANGER_BAR"
  elif [ "$pct_int" -ge 70 ] 2>/dev/null; then
    txt_color="$RL_WARN_TXT"
    bar_color="$RL_WARN_BAR"
  else
    txt_color="$RL_OK_TXT"
    bar_color="$RL_OK_BAR"
  fi
  if [ -n "$extra" ]; then
    printf "${txt_color}%s ${bar_color}%s${RESET}${txt_color} %d%% %s${RESET}" "$label" "$bar" "$pct_int" "$extra"
  else
    printf "${txt_color}%s ${bar_color}%s${RESET}${txt_color} %d%%${RESET}" "$label" "$bar" "$pct_int"
  fi
}

fmt_tok() {
  val="$1"
  if [ -z "$val" ]; then printf '%s' "--"; return; fi
  if [ "$val" -ge 1000000 ] 2>/dev/null; then
    printf "%.1fM" "$(echo "$val" | awk '{printf "%.1f", $1/1000000}')"
  elif [ "$val" -ge 1000 ] 2>/dev/null; then
    printf "%.1fk" "$(echo "$val" | awk '{printf "%.1f", $1/1000}')"
  else
    printf "%s" "$val"
  fi
}

in_fmt=$(fmt_tok "$in_tok")
out_fmt=$(fmt_tok "$out_tok")
cache_fmt=$(fmt_tok "$cache_tok")

row2=""
row2="${row2}$(printf "${MODEL_C}${ICON_MODEL} %s${RESET}" "$model")"
if [ -n "$effort_level" ]; then
  row2="${row2}$(printf " ${SEP_C}(${EFFORT_C}%s${SEP_C})${RESET}" "$effort_level")"
fi
row2="${row2}$(printf " ${SEP_C}·${RESET} ${ctx_color}${ICON_CTX} ctx %s${RESET}" "$ctx_label")"
row2="${row2}$(printf " ${SEP_C}·${RESET} ${IN_C}${ICON_IN} in %s${RESET}" "$in_fmt")"
row2="${row2}$(printf " ${SEP_C}·${RESET} ${OUT_C}${ICON_OUT} out %s${RESET}" "$out_fmt")"
row2="${row2}$(printf " ${SEP_C}·${RESET} ${CACHE_C}${ICON_CACHE} cached %s${RESET}" "$cache_fmt")"

# ── Rate limits row (between row2 and row3) ──────────────────────────────────
rl_row=""
if [ -n "$five_hour_pct" ]; then
  rl_row="$(rate_segment "${ICON_RATE} 5h" "$five_hour_pct" "$(rate_reset_info "$five_hour_reset")")"
fi
if [ -n "$seven_day_pct" ]; then
  if [ -n "$rl_row" ]; then
    seg="$(rate_segment '7d' "$seven_day_pct" "$(rate_reset_info "$seven_day_reset" dh)")"
    rl_row="${rl_row}$(printf " ${SEP_C}·${RESET} ")${seg}"
  else
    rl_row="$(rate_segment "${ICON_RATE} 7d" "$seven_day_pct" "$(rate_reset_info "$seven_day_reset" dh)")"
  fi
fi

# ── Row 3: Session clock · Session cost ──────────────────────────────────────
elapsed=""
if [ -n "$total_duration_ms" ]; then
  diff_s=$((total_duration_ms / 1000))
  h=$((diff_s / 3600))
  m=$(( (diff_s % 3600) / 60 ))
  s=$((diff_s % 60))
  elapsed=$(printf "%02d:%02d:%02d" "$h" "$m" "$s")
fi

cost_fmt=""
if [ -n "$total_cost" ]; then
  cost_fmt=$(printf '$%.4f' "$total_cost")
fi

row3=""
if [ -n "$elapsed" ]; then
  row3="${row3}$(printf "${SESSION_C}${ICON_CLOCK} session %s${RESET}" "$elapsed")"
else
  row3="${row3}$(printf "${SESSION_C}${ICON_CLOCK} session --${RESET}")"
fi
if [ -n "$cost_fmt" ]; then
  row3="${row3}$(printf " ${SEP_C}·${RESET} ${COST_C}${ICON_COST} cost %s${RESET}" "$cost_fmt")"
else
  row3="${row3}$(printf " ${SEP_C}·${RESET} ${COST_C}${ICON_COST} cost --${RESET}")"
fi

# ── Output ────────────────────────────────────────────────────────────────────
if [ -n "$rl_row" ]; then
  printf "%b\n%b\n%b\n%b" "$row1" "$row2" "$rl_row" "$row3"
else
  printf "%b\n%b\n%b" "$row1" "$row2" "$row3"
fi
