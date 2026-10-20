#!/usr/bin/env bash
#
# export-opencode.sh — export current OpenCode config from this machine into the dotfiles repo.
#
# - Copies from ~/.config/opencode/ to $REPO_ROOT/.config/opencode/
# - Backs up the repo's existing copy to .bak.<date> before overwriting
#
# Usage: scripts/export-opencode.sh [-y|--yes] [-n|--dry-run]

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
OPENCODE_DST="$REPO_ROOT/.config/opencode"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/opencode"
STAMP="$(date +%Y%m%d-%H%M%S)"

echo "OpenCode config exporter"
echo "  Live config: $CONFIG_DIR"
echo "  Repo target: $OPENCODE_DST"
echo

if [[ ! -d "$CONFIG_DIR" ]]; then
  echo "error: no live opencode config found at $CONFIG_DIR" >&2
  exit 1
fi

if [[ -L "$CONFIG_DIR" ]]; then
  echo "warning: $CONFIG_DIR is a symlink pointing to $(readlink -f "$CONFIG_DIR")"
  echo "         Exporting will copy from the symlinked location."
  echo
fi

print_plan() {
  echo "Plan:"
  echo "  Backup repo copy (stamp: $STAMP):"
  if [[ -d "$OPENCODE_DST" ]]; then
    echo "    $OPENCODE_DST -> ${OPENCODE_DST}.bak.${STAMP}"
  else
    echo "    (nothing to back up)"
  fi
  echo "  Export:"
  echo "    $CONFIG_DIR/ -> $OPENCODE_DST/"
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
  read -r -p "Proceed? This will overwrite files in the dotfiles repo. [y/N] " answer
  if [[ ! "$answer" =~ ^[Yy] ]]; then
    echo "aborted."
    exit 1
  fi
fi

if [[ -d "$OPENCODE_DST" ]]; then
  bak="$OPENCODE_DST.bak.${STAMP}"
  cp -r "$OPENCODE_DST" "$bak"
  echo "backed up repo copy: $OPENCODE_DST -> $bak"
  rm -rf "$OPENCODE_DST"
fi

mkdir -p "$OPENCODE_DST"

for item in cli.json tui.json themes commands package.json; do
  if [[ -e "$CONFIG_DIR/$item" ]]; then
    if [[ -d "$CONFIG_DIR/$item" ]]; then
      cp -r "$CONFIG_DIR/$item" "$OPENCODE_DST/"
    else
      cp "$CONFIG_DIR/$item" "$OPENCODE_DST/"
    fi
    echo "  copied: $item"
  fi
done

echo
echo "Done."
echo "Review: git -C $REPO_ROOT diff"
echo "Commit: git -C $REPO_ROOT add .config/opencode && git -C $REPO_ROOT commit -m 'update opencode config'"
