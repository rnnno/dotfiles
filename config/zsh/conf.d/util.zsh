function project_root() {
  local dir marker
  local -a markers

  dir="${1:-$PWD}"
  markers=(
    .git
    package.json
    deno.json
    deno.jsonc
    Cargo.toml
    go.mod
    pyproject.toml
    Makefile
    justfile
    flake.nix
    Gemfile
  )

  while [[ "$dir" != "/" ]]; do
    for marker in "${markers[@]}"; do
      if [[ -e "$dir/$marker" ]]; then
        print -r -- "$dir"
        return 0
      fi
    done
    dir="${dir:h}"
  done

  return 1
}

function croot() {
  local root

  root="$(project_root)" || {
    print -u2 -- "croot: project root not found"
    return 1
  }

  cd "$root" || return 1
}

function _path_matches() {
  local base pattern type

  base="$1"
  pattern="$2"
  type="$3"

  if command -v rg >/dev/null 2>&1; then
    if [[ "$type" == "file" ]]; then
      (
        cd "$base" &&
          rg --files | rg -F -i -- "$pattern"
      )
    else
      (
        cd "$base" &&
          find . -type d -not -path '.' -print |
          sed 's#^\./##' |
          rg -F -i -- "$pattern"
      )
    fi
  else
    if [[ "$type" == "file" ]]; then
      (
        cd "$base" &&
          find . -type f -print |
          sed 's#^\./##' |
          grep -iF -- "$pattern"
      )
    else
      (
        cd "$base" &&
          find . -type d -not -path '.' -print |
          sed 's#^\./##' |
          grep -iF -- "$pattern"
      )
    fi
  fi
}

function _pick_match() {
  local prompt="$1"
  shift

  local choice
  local -a matches
  matches=("$@")

  if (( ${#matches[@]} == 0 )); then
    return 1
  fi

  if (( ${#matches[@]} == 1 )); then
    print -r -- "${matches[1]}"
    return 0
  fi

  if (( ${#matches[@]} > 20 )); then
    print -u2 -- "${prompt}: too many matches (${#matches[@]}). refine the query."
    return 1
  fi

  local index=1
  local item
  for item in "${matches[@]}"; do
    print -r -- "[$index] $item"
    (( index++ ))
  done

  printf "%s [1-%d]: " "$prompt" "${#matches[@]}"
  read -r choice

  if [[ ! "$choice" == <-> ]] || (( choice < 1 || choice > ${#matches[@]} )); then
    print -u2 -- "invalid selection"
    return 1
  fi

  print -r -- "${matches[$choice]}"
}

function vif() {
  local mode pattern base target
  local -a matches

  mode="open"
  if [[ "$1" == "--print" ]]; then
    mode="print"
    shift
  fi

  pattern="$1"
  if [[ -z "$pattern" ]]; then
    print -u2 -- "usage: vif [--print] <pattern>"
    return 1
  fi

  base="$(project_root 2>/dev/null || print -r -- "$PWD")"
  matches=("${(@f)$(_path_matches "$base" "$pattern" "file")}")
  target="$(_pick_match "select file" "${matches[@]}")" || return 1
  target="$base/$target"

  if [[ "$mode" == "print" ]]; then
    print -r -- "$target"
  else
    "${EDITOR:-nvim}" "$target"
  fi
}

function cdf() {
  local mode pattern base target
  local -a matches

  mode="cd"
  if [[ "$1" == "--print" ]]; then
    mode="print"
    shift
  fi

  pattern="$1"
  if [[ -z "$pattern" ]]; then
    print -u2 -- "usage: cdf [--print] <pattern>"
    return 1
  fi

  base="$(project_root 2>/dev/null || print -r -- "$PWD")"
  matches=("${(@f)$(_path_matches "$base" "$pattern" "dir")}")
  target="$(_pick_match "select dir" "${matches[@]}")" || return 1
  target="$base/$target"

  if [[ "$mode" == "print" ]]; then
    print -r -- "$target"
  else
    cd "$target" || return 1
  fi
}
