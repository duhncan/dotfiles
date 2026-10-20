#!/usr/bin/env bash
#
# install.sh — central dotfiles installer
#
# Usage:
#   ./install.sh                    # interactive menu
#   ./install.sh nvim               # install specific component
#   ./install.sh starship opencode  # install multiple
#   curl -fsSL https://raw.githubusercontent.com/duhncan/dotfiles/main/install.sh | bash -s -- nvim
#

set -euo pipefail

REPO_URL="https://github.com/duhncan/dotfiles.git"
REPO_DIR="${DOTFILES_DIR:-$HOME/code/personal/dotfiles}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $*"; }
log_success() { echo -e "${GREEN}[OK]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error() { echo -e "${RED}[ERR]${NC} $*" >&2; }

declare -A INSTALLERS=(
  ["nvim"]="./scripts/install-nvim.sh"
  ["starship"]="./scripts/install-starship.sh"
  ["opencode"]="./scripts/install-opencode.sh"
  ["gitconfig"]="./scripts/install-gitconfig.sh"
)

show_menu() {
  echo -e "${BLUE}╔════════════════════════════════════╗${NC}"
  echo -e "${BLUE}║      duguy dotfiles installer      ║${NC}"
  echo -e "${BLUE}╚════════════════════════════════════╝${NC}"
  echo
  echo "Available components:"
  echo "  1) nvim      - Neovim configuration"
  echo "  2) starship  - Starship prompt"
  echo "  3) opencode  - OpenCode configuration"
  echo "  4) gitconfig - Git configuration"
  echo "  5) all       - Install everything"
  echo "  q) quit"
  echo
}

ensure_repo() {
  if [[ ! -d "$REPO_DIR" ]]; then
    log_info "Dotfiles repo not found at $REPO_DIR"
    read -r -p "Clone it now? [Y/n] " ans
    if [[ ! "$ans" =~ ^[Nn] ]]; then
      mkdir -p "$(dirname "$REPO_DIR")"
      git clone "$REPO_URL" "$REPO_DIR"
      log_success "Cloned to $REPO_DIR"
    else
      log_error "Cannot proceed without repo"
      exit 1
    fi
  fi
  cd "$REPO_DIR"
}

install_component() {
  local comp="$1"
  local script="${INSTALLERS[$comp]:-}"
  
  if [[ -z "$script" ]]; then
    log_error "Unknown component: $comp"
    return 1
  fi
  
  if [[ ! -f "$script" ]]; then
    log_error "Installer not found: $script"
    return 1
  fi
  
  log_info "Installing $comp..."
  bash "$script" "${@:2}"
}

main() {
  ensure_repo
  
  if [[ $# -gt 0 ]]; then
    for comp in "$@"; do
      case "$comp" in
        all)
          for c in nvim starship opencode gitconfig; do
            install_component "$c"
          done
          ;;
        -y|--yes)
          INSTALL_FLAGS="-y"
          continue
          ;;
        *)
          install_component "$comp"
          ;;
      esac
    done
    exit 0
  fi
  
  while true; do
    show_menu
    read -r -p "Select an option: " choice
    case "$choice" in
      1|nvim) install_component nvim ;;
      2|starship) install_component starship ;;
      3|opencode) install_component opencode ;;
      4|gitconfig) install_component gitconfig ;;
      5|all) 
        for c in nvim starship opencode gitconfig; do
          install_component "$c"
        done
        ;;
      q|quit|exit) 
        log_info "Goodbye!"
        exit 0
        ;;
      *)
        log_warn "Invalid option"
        ;;
    esac
    echo
    read -r -p "Press Enter to continue..." 
    clear 2>/dev/null || true
  done
}

main "$@"
