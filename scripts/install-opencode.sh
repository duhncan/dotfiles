#!/usr/bin/env bash
#
# install-opencode.sh — install the dotfiles OpenCode config onto this machine.
#
# - Backs up any existing opencode config dir to *.bak.<date>
# - Copies the repo's .config/opencode into place at ~/.config/opencode
#
# Usage: scripts/install-opencode.sh [-y|--yes] [-n|--dry-run]

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
OPENCODE_SRC="$REPO_ROOT/.config/opencode"

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/opencode"
STAMP="$(date +%Y%m%d-%H%M%S)"

echo "OpenCode dotfiles installer"
echo "  Repo config: $OPENCODE_SRC"
echo "  Target:      $CONFIG_DIR"
echo

if [[ ! -d "$OPENCODE_SRC" ]]; then
  echo "error: no opencode config found in dotfiles repo: $OPENCODE_SRC" >&2
  exit 1
fi

if [[ -L "$CONFIG_DIR" ]]; then
  echo "info: $CONFIG_DIR is already a symlink to $(readlink -f "$CONFIG_DIR")"
  echo "      This script copies files, not symlinks. Remove the symlink first if you want to switch to this approach."
  exit 0
fi

print_plan() {
  echo "Plan:"
  echo "  Backup (stamp: $STAMP):"
  if [[ -d "$CONFIG_DIR" && ! -L "$CONFIG_DIR" ]]; then
    echo "    $CONFIG_DIR -> ${CONFIG_DIR}.bak.${STAMP}"
  else
    echo "    (nothing to back up)"
  fi
  echo "  Install:"
  echo "    $OPENCODE_SRC/ -> $CONFIG_DIR/"
}

if ((DRY_RUN)); then
  print_plan
  echo
  echo "dry run — not changing anything."
  exit 0
fi

print_plan
echo

if ((!ASSUME_YES)); then
  read -r -p "Proceed? [y/N] " answer
  if [[ ! "$answer" =~ ^[Yy] ]]; then
    echo "aborted."
    exit 1
  fi
fi

if [[ -d "$CONFIG_DIR" && ! -L "$CONFIG_DIR" ]]; then
  mv "$CONFIG_DIR" "${CONFIG_DIR}.bak.${STAMP}"
  echo "backed up: $CONFIG_DIR -> ${CONFIG_DIR}.bak.${STAMP}"
elif [[ -e "$CONFIG_DIR" ]]; then
  rm -rf "$CONFIG_DIR"
fi

mkdir -p "$(dirname "$CONFIG_DIR")"
mkdir -p "$CONFIG_DIR"

cp -rT "$OPENCODE_SRC" "$CONFIG_DIR"
echo "installed: $OPENCODE_SRC -> $CONFIG_DIR"

echo
echo "Done."
echo "Your previous config (if any) is saved as: ${CONFIG_DIR}.bak.${STAMP}"
echo "Launch 'opencode' to verify your theme/settings."
