#!/usr/bin/env bash
#
# install.sh — central dotfiles installer
#
# Usage:
#   ./install.sh                    # interactive menu
#   ./install.sh nvim               # install specific component
#   ./install.sh starship opencode  # install multiple
#   curl -fsSL https://raw.githubusercontent.com/duhncan/dotfiles/main/install.sh | bash -s -- opencode
#

set -euo pipefail

REPO_URL="https://github.com/duhncan/dotfiles.git"
BRANCH="${DOTFILES_BRANCH:-feat/install-scripts}" # change to main once merged

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

check_requirements() {
  local missing=()
  local required=(git)
  
  for cmd in "${required[@]}"; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      missing+=("$cmd")
    fi
  done
  
  if (( ${#missing[@]} > 0 )); then
    log_error "Missing required dependencies:"
    for cmd in "${missing[@]}"; do
      echo "  - $cmd" >&2
    done
    echo >&2
    log_error "Please install them first and try again."
    exit 1
  fi
}

setup_repo_dir() {
  # If explicitly set via env, use it
  if [[ -n "${DOTFILES_DIR:-}" ]]; then
    REPO_DIR="$DOTFILES_DIR"
    CLEANUP_REPO=0
    return
  fi
  
  # If running non-interactively (piped from curl) or no TTY, use temp dir
  if [[ ! -t 0 ]]; then
    REPO_DIR="$(mktemp -d -t dotfiles.XXXXXX)"
    CLEANUP_REPO=1
    log_info "Non-interactive mode detected, using temporary directory: $REPO_DIR"
    return
  fi
  
  # Interactive mode - use persistent location
  REPO_DIR="$HOME/code/personal/dotfiles"
  CLEANUP_REPO=0
}

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
  check_requirements
  setup_repo_dir
  
  # Check if repo exists and is a git repo
  if [[ -d "$REPO_DIR/.git" ]]; then
    log_info "Using existing dotfiles repo at $REPO_DIR"
  elif [[ -d "$REPO_DIR" ]]; then
    log_warn "$REPO_DIR exists but is not a git repo"
    if [[ -t 0 ]]; then
      read -r -p "Remove and re-clone? [y/N] " ans
      if [[ "$ans" =~ ^[Yy] ]]; then
        rm -rf "$REPO_DIR"
      else
        log_error "Cannot proceed"
        exit 1
      fi
    else
      rm -rf "$REPO_DIR"
    fi
  fi
  
  if [[ ! -d "$REPO_DIR/.git" ]]; then
    if [[ -t 0 && "${CLEANUP_REPO:-0}" == 0 ]]; then
      log_info "Dotfiles repo not found at $REPO_DIR"
      read -r -p "Clone it now? [Y/n] " ans
      if [[ "$ans" =~ ^[Nn] ]]; then
        log_error "Cannot proceed without repo"
        exit 1
      fi
    else
      log_info "Cloning dotfiles repo..."
    fi
    
    mkdir -p "$(dirname "$REPO_DIR")"
    
    # Try to clone with branch if specified, fallback to default branch
    if [[ -n "${BRANCH:-}" && "$BRANCH" != "main" ]]; then
      log_info "Cloning branch: $BRANCH"
      if ! git clone --depth 1 -b "$BRANCH" "$REPO_URL" "$REPO_DIR" 2>/dev/null; then
        log_warn "Branch $BRANCH not found, trying default branch"
        git clone --depth 1 "$REPO_URL" "$REPO_DIR"
      fi
    else
      git clone --depth 1 "$REPO_URL" "$REPO_DIR"
    fi
    
    log_success "Cloned to $REPO_DIR"
  fi
  
  cd "$REPO_DIR"
  
  # Setup cleanup trap for temp dirs
  if [[ "${CLEANUP_REPO:-0}" == 1 ]]; then
    trap 'log_info "Cleaning up temporary dotfiles repo at $REPO_DIR"; rm -rf "$REPO_DIR" 2>/dev/null || true' EXIT
  fi
}

install_component() {
  local comp="$1"
  shift || true
  local script="${INSTALLERS[$comp]:-}"
  
  if [[ -z "$script" ]]; then
    log_error "Unknown component: $comp"
    return 1
  fi
  
  if [[ ! -f "$script" ]]; then
    log_error "Installer not found: $script"
    log_error "Make sure you're running from the dotfiles repo"
    return 1
  fi
  
  log_info "Installing $comp..."
  bash "$script" "$@"
}

main() {
  ensure_repo
  
  if [[ $# -gt 0 ]]; then
    for comp in "$@"; do
      case "$comp" in
        all)
          for c in nvim starship opencode gitconfig; do
            install_component "$c" || log_warn "Failed to install $c"
          done
          ;;
        -y|--yes)
          export INSTALL_ASSUME_YES=1
          continue
          ;;
        *)
          install_component "$comp" || log_warn "Failed to install $comp"
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
          install_component "$c" || log_warn "Failed to install $c"
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
