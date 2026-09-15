#!/usr/bin/env bash
#
# install-starship.sh — install the dotfiles Starship config onto this machine.
#
# - Backs up any existing ~/.config/starship.toml to *.bak.<date>
# - Copies the repo's .config/starship.toml into place
# - First new shell prompt renders with the dotfiles config
#
# Usage: scripts/install-starship.sh [-y|--yes] [-n|--dry-run]

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
STARSHIP_SRC="$REPO_ROOT/.config/starship.toml"

CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/starship.toml"
STAMP="$(date +%Y%m%d-%H%M%S)"

# Shell startup files that should init starship (checked in this order).
SHELL_RCS=("$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.config/fish/config.fish")

STARSHIP_INITED=0
INIT_FILE=""
INIT_LINE=""

preflight() {
  echo "Preflight checks:"

  if command -v starship >/dev/null 2>&1; then
    printf '  [ OK ]  starship %s\n' "$(starship --version | sed -n 's/^starship //p')"
  else
    printf '  [WARN]  starship binary not installed (config still placed; install it when ready)\n'
  fi

  local rc
  for rc in "${SHELL_RCS[@]}"; do
    [[ -f "$rc" ]] || continue
    [[ -z "$INIT_FILE" ]] && INIT_FILE="$rc"
    if grep -qs "starship init" "$rc"; then
      STARSHIP_INITED=1
      INIT_FILE="$rc"
      break
    fi
  done

  if [[ $STARSHIP_INITED -eq 1 ]]; then
    printf '  [ OK ]  starship init found in %s\n' "$INIT_FILE"
  elif [[ -n "$INIT_FILE" ]]; then
    case "$INIT_FILE" in
      *.zshrc) INIT_LINE='eval "$(starship init zsh)"' ;;
      *config.fish) INIT_LINE='starship init fish | source' ;;
      *) INIT_LINE='eval "$(starship init bash)"' ;;
    esac
    printf '  [WARN]  no "starship init" line in your shell startup files\n'
    printf '            add it to %s (e.g. %s)\n' "$INIT_FILE" "$INIT_LINE"
  else
    printf '  [WARN]  no shell startup files found (.bashrc/.zshrc/fish config)\n'
  fi
}

if [[ ! -f "$STARSHIP_SRC" ]]; then
  echo "error: no starship config found in dotfiles repo: $STARSHIP_SRC" >&2
  exit 1
fi

if [[ -L "$CONFIG_FILE" ]]; then
  echo "info: $CONFIG_FILE is already a symlink to $(readlink "$CONFIG_FILE") — nothing to do."
  exit 0
fi

# Pick the init line for the first shell config we found.
print_plan() {
  echo "Plan:"
  echo "  Backup:"
  if [[ -e "$CONFIG_FILE" ]]; then
    echo "    $CONFIG_FILE -> ${CONFIG_FILE}.bak.${STAMP}"
  else
    echo "    (nothing to back up)"
  fi
  echo "  Install:"
  echo "    $STARSHIP_SRC -> $CONFIG_FILE"
}

if ((DRY_RUN)); then
  echo "This will back up your current Starship config to *.bak.$STAMP and"
  echo "install the dotfiles config at $CONFIG_FILE."
  echo
  preflight
  echo
  print_plan
  echo "dry run — not changing anything."
  exit 0
fi

echo "This will back up your current Starship config to *.bak.$STAMP and"
echo "install the dotfiles config at $CONFIG_FILE."
echo
preflight
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

if [[ -e "$CONFIG_FILE" ]]; then
  mv "$CONFIG_FILE" "${CONFIG_FILE}.bak.${STAMP}"
  echo "backed up: $CONFIG_FILE -> ${CONFIG_FILE}.bak.${STAMP}"
fi

mkdir -p "$(dirname "$CONFIG_FILE")"
cp "$STARSHIP_SRC" "$CONFIG_FILE"
echo "installed: $STARSHIP_SRC -> $CONFIG_FILE"

echo
if [[ $STARSHIP_INITED -eq 1 ]]; then
  echo "Next: open a new terminal — starship will render with the dotfiles config."
elif [[ -n "$INIT_FILE" ]]; then
  echo "Next: add starship to your shell, then open a new terminal:"
  echo "    echo '${INIT_LINE}' >> $INIT_FILE"
  echo "To roll back: move ${CONFIG_FILE}.bak.$STAMP back to $CONFIG_FILE."
else
  echo "Next: install starship, add its init line to your shell rc, re-open the terminal."
fi