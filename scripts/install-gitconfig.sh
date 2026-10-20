#!/usr/bin/env bash
#
# install-gitconfig.sh — install the dotfiles gitconfig onto this machine.
#
# - Backs up any existing ~/.gitconfig to *.bak.<date>
# - Copies the repo's .gitconfig into place
#
# Usage: scripts/install-gitconfig.sh [-y|--yes] [-n|--dry-run]

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
GITCONFIG_SRC="$REPO_ROOT/.gitconfig"

CONFIG_FILE="$HOME/.gitconfig"
STAMP="$(date +%Y%m%d-%H%M%S)"

echo "gitconfig dotfiles installer"
echo "  Repo config: $GITCONFIG_SRC"
echo "  Target:      $CONFIG_FILE"
echo

if [[ ! -f "$GITCONFIG_SRC" ]]; then
  echo "error: no .gitconfig found in dotfiles repo: $GITCONFIG_SRC" >&2
  exit 1
fi

if [[ -L "$CONFIG_FILE" ]]; then
  echo "info: $CONFIG_FILE is already a symlink to $(readlink -f "$CONFIG_FILE")"
  echo "      This script copies files, not symlinks. Remove the symlink first if you want to switch to this approach."
  exit 0
fi

print_plan() {
  echo "Plan:"
  echo "  Backup (stamp: $STAMP):"
  if [[ -e "$CONFIG_FILE" && ! -L "$CONFIG_FILE" ]]; then
    echo "    $CONFIG_FILE -> ${CONFIG_FILE}.bak.${STAMP}"
  else
    echo "    (nothing to back up)"
  fi
  echo "  Install:"
  echo "    $GITCONFIG_SRC -> $CONFIG_FILE"
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

if [[ -e "$CONFIG_FILE" && ! -L "$CONFIG_FILE" ]]; then
  mv "$CONFIG_FILE" "${CONFIG_FILE}.bak.${STAMP}"
  echo "backed up: $CONFIG_FILE -> ${CONFIG_FILE}.bak.${STAMP}"
elif [[ -e "$CONFIG_FILE" ]]; then
  rm -rf "$CONFIG_FILE"
fi

cp "$GITCONFIG_SRC" "$CONFIG_FILE"
echo "installed: $GITCONFIG_SRC -> $CONFIG_FILE"

echo
echo "Done."
