# Packages

Packages to install on my personal machines.

## Shell & Prompt
- **zsh** — login shell (Arch: `zsh`)
- **fish** — interactive shell with config at `~/.config/fish` (Arch: `fish`)
- **starship** — prompt, inited from fish (Arch: `starship`)
- **zoxide** — smart `cd` replacement, inited from fish (`~/.local/bin`, also Arch pkg)

## Terminal Emulators
- **wezterm** — primary terminal (Arch: `wezterm`)
- **kitty** — used via `kitten ssh` alias (config at `~/.config/kitty`)
- **tmux** — terminal multiplexer (Arch: `tmux`)

## File Navigation & Searching
- **fzf** — fuzzy finder (Arch: `fzf`)
- **fd** — fast find (Arch: `fd`)
- **ripgrep** — fast grep (Arch: `ripgrep`)
- **eza** — modern `ls` replacement, aliased with icons (Arch: `eza`)
- **bat** — cat replacement with syntax highlighting (Arch: `bat`)
- **jq** — JSON processor (Arch: `jq`)

## Git
- **git** (Arch: `git`)
- **lazygit** — TUI for git (Arch: `lazygit`)

## System Monitoring & Multitasking
- **fastfetch** — system info (Arch: `fastfetch`)
- **btop** — system monitor (Arch: `btop`)
- **bottom (btm)** — system monitor (`~/.cargo/bin/btm`)

## Editors
- **neovim** — primary editor (Arch: `neovim`; plugins via lazy/mason at `~/.local/share/nvim`)
- **vim** — fallback editor (Arch: `vim`)

## CLI Dev Tooling
- **tree-sitter** — parser generator (`~/.cargo/bin/tree-sitter`)
- **yamllint** — YAML linter (Arch: `yamllint`)
- **terraform** — IaC (Arch: `terraform`)
- **terraform-docs** — generate docs from terraform (AUR: `terraform-docs-bin`)
- **opentofu** — terraform fork (Arch: `opentofu`)

## Cloud / AWS
- **awscli** — AWS CLI (pip, system)
- **aws-session-manager-plugin** — SSM (Arch: `aws-session-manager-plugin`)

## AI Harnesses (`~/.local/bin`)
- **claude** — Claude Code
- **copilot** — GitHub Copilot CLI (with fish completions)
- **opencode** — OpenCode

## Language Toolchains
- **Rust** — rustup/cargo/clippy/rust-analyzer (`~/.cargo/bin`)
- **Node.js** — via fnm/nvm (Arch: `fnm`, `nodejs`)
- **Python/uv** — `python-uv`, `uv`/`uvx` in `~/.local/bin`
- **Go** — (Arch: `go`)
- **.NET** — dotnet-sdk / aspnet-runtime (Arch)

## Package Managers
- **yay** — AUR helper (Arch: `yay`)
- **npm**, **cargo**, **pip**, **uv** — language-level
