#!/usr/bin/env bash
#
# install-nvim.sh — install the dotfiles Neovim config onto this machine.
#
# - Backs up any existing nvim config/data/state/cache to *.bak.<date>
# - Copies the repo's .config/nvim into place
# - First `nvim` launch installs all plugins (lazy-lock.json) + Mason tools
#
# Usage: scripts/install-nvim.sh [-y|--yes] [-n|--dry-run]

set -euo pipefail

ASSUME_YES=0
DRY_RUN=0
for arg in "$@"; do
  case "$arg" in
    -y | --yes) ASSUME_YES=1 ;;
    -n | --dry-run) DRY_RUN=1 ;;
    *)
      echo "usage: $0 [-y|--yes] [-n|--dry-run]" >&2
      exit 2
      ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
NVIM_SRC="$REPO_ROOT/.config/nvim"

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/nvim"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/nvim"

STAMP="$(date +%Y%m%d-%H%M%S)"
MIN_NVIM_VERSION="0.12.0"

# Hard requirements — lazy.nvim / Mason refuse to bootstrap without these.
REQUIRED_CMDS=("git" "curl" "unzip")
# Soft requirements — power plugins (Neogit, snacks picker, diffs, etc).
# Documented in docs/packages.md.
RECOMMENDED_CMDS=("lazygit" "fd" "fzf" "rg" "jq" "delta")

version_ge() {
  [[ "$(printf '%s\n%s\n' "$1" "$2" | sort -V | head -n1)" == "$2" ]]
}

nvim_ver=""
check_cmd() {
  local cmd="$1" required="$2"
  if command -v "$cmd" >/dev/null 2>&1; then
    printf '  [ OK ]  %s\n' "$cmd"
  elif ((required)); then
    printf '  [FAIL]  %s — missing (required)\n' "$cmd"
    MISSING=1
  else
    printf '  [WARN]  %s — missing (optional, see docs/packages.md)\n' "$cmd"
  fi
}

preflight() {
  local MISSING=0
  echo "Preflight checks:"

  if command -v nvim >/dev/null 2>&1; then
    nvim_ver="$(nvim --version | head -n1 | sed -E 's/.*NVIM v([0-9]+\.[0-9]+\.[0-9]+).*/\1/')"
    if version_ge "$nvim_ver" "$MIN_NVIM_VERSION"; then
      printf '  [ OK ]  nvim v%s\n' "$nvim_ver"
    else
      printf '  [WARN]  nvim v%s — this config needs >= %s (upgrade to bootstrap)\n' "$nvim_ver" "$MIN_NVIM_VERSION"
    fi
  else
    nvim_ver=""
    printf '  [WARN]  nvim — not installed (install >= %s to run the config)\n' "$MIN_NVIM_VERSION"
  fi

  local c
  for c in "${REQUIRED_CMDS[@]}"; do check_cmd "$c" 1; done
  echo "  (optional tools, recommended for the full setup):"
  for c in "${RECOMMENDED_CMDS[@]}"; do check_cmd "$c" 0; done

  if ((MISSING)); then
    echo
    echo "error: missing required tools — install them first (see docs/packages.md)." >&2
    return 1
  fi
  return 0
}

if [[ ! -d "$NVIM_SRC" ]]; then
  echo "error: no nvim config found in dotfiles repo: $NVIM_SRC" >&2
  exit 1
fi

if [[ -L "$CONFIG_DIR" ]]; then
  echo "info: $CONFIG_DIR is already a symlink to $(readlink "$CONFIG_DIR") — nothing to do."
  exit 0
fi

existing_dirs=()
for dir in "$CONFIG_DIR" "$DATA_DIR" "$STATE_DIR" "$CACHE_DIR"; do
  if [[ -d "$dir" && ! -L "$dir" ]]; then
    existing_dirs+=("$dir")
  fi
done

print_plan() {
  echo "Plan:"
  echo "  Backup (stamp: $STAMP):"
  if [[ ${#existing_dirs[@]} -eq 0 ]]; then
    echo "    (nothing to back up)"
  else
    for dir in "${existing_dirs[@]}"; do
      echo "    $dir -> ${dir}.bak.${STAMP}"
    done
  fi
  echo "  Install:"
  echo "    $NVIM_SRC -> $CONFIG_DIR"
}

if ((DRY_RUN)); then
  echo "This will back up your current Neovim setup to *.bak.$STAMP and"
  echo "install the dotfiles config at $CONFIG_DIR."
  echo
  if ! preflight; then exit 1; fi
  echo
  print_plan
  echo "dry run — not changing anything."
  exit 0
fi

echo "This will back up your current Neovim setup to *.bak.$STAMP and"
echo "install the dotfiles config at $CONFIG_DIR."
echo
if ! preflight; then exit 1; fi
echo
print_plan
echo

if ((!ASSUME_YES)); then
  read -r -p "Proceed? [y/N] " answer
  if [[ ! "$answer" =~ ^[Yy] ]]; then
    echo "aborted."
    exit 1
  fi
fi

for dir in "${existing_dirs[@]}"; do
  mv "$dir" "${dir}.bak.${STAMP}"
  echo "backed up: $dir -> ${dir}.bak.${STAMP}"
done

mkdir -p "$(dirname "$CONFIG_DIR")"
[[ -e "$CONFIG_DIR" ]] && rm -rf "$CONFIG_DIR"
cp -rT "$NVIM_SRC" "$CONFIG_DIR"
echo "installed: $NVIM_SRC -> $CONFIG_DIR"

echo
if [[ -z "$nvim_ver" ]]; then
  echo "Next: install Neovim >= $MIN_NVIM_VERSION, then run 'nvim' to bootstrap everything."
elif ! version_ge "$nvim_ver" "$MIN_NVIM_VERSION"; then
  echo "Next: your Neovim is v$nvim_ver but this config needs >= $MIN_NVIM_VERSION — upgrade first,"
  echo "      then run 'nvim' to bootstrap plugins."
else
  echo "Next: run 'nvim' — lazy.nvim + Mason install everything automatically."
fi
echo "To roll back: move the *.bak.$STAMP dirs back into place (removing the new $CONFIG_DIR first)."