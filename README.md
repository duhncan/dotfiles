# duguy dotfiles

```
    ░░░
    ▒▒▒
    ▓▓▓
▄██▀███ ███ ███ ▄██▀██▄ ███ ███ ███ ███
███ ███ ███ ███ ███ ███ ███ ███ ███ ███
███ ███ ███ ███ ███ ███ ███ ███  ▀▀▀███
███ ███ ███ ███ ███ ███ ███ ███ ███ ███
███ ███ ███ ███ ███ ███ ███ ███ ███ ███
▀██▄███ ▀██▄███ ▀██▄███ ▀██▄███ ▀██▄██▀
     ▀█      ▀█ ▄▄▄ ███      ▀█   █▀
      ▄       ▄ ▀██▄██▀       ▄   ▄
```

All my personal dotfiles. Updating as I go :)

> The ASCII banner above is generated with the **CREST** font at
> [TAAG — text art generator](https://patorjk.com/software/taag/) — source in
> [`docs/ascii-art.md`](docs/ascii-art.md).

---

## ✨ What's inside

The configs are **portable**: Neovim, WezTerm and Starship run on my Arch +
Hyprland desktop **and** my WSL-on-Windows machines with the same files.

| Component | Description | Docs |
|-----------|-------------|------|
| **Neovim** | AstroNvim v6 + lazy.nvim — per-language packs, format-on-save, AI assistants (`<leader>0` opencode, `<leader>9` CodeCompanion) | [`.config/nvim/README.md`](.config/nvim/README.md) |
| **WezTerm** | Terminal — Catppuccin Macchiato, `ALT+q` leader keymap, custom status line | [`docs/wezterm.md`](docs/wezterm.md) |
| **Starship** | Cross-shell prompt — same look in fish/zsh on any OS | [`docs/starship.md`](docs/starship.md) |
| **Hyprlock** | Linux/Hyprland lock screen — blurred screenshot, live clock | [`docs/hyprlock.md`](docs/hyprlock.md) |

**Theming:** everything shares the same Catppuccin palette — Frappe in Neovim,
Macchiato everywhere else.

---

## 🚀 Quickstart

Clone the repo and symlink the components you want into place:

Or use the installer script — it backs up any existing nvim setup to
`*.bak.<date>` first, then copies the config into place:

```bash
git clone git@github.com:duhncan/dotfiles.git ~/dotfiles
~/dotfiles/scripts/install-nvim.sh        # preview with --dry-run, force with -y
```

Manual symlink method:

```bash
git clone git@github.com:duhncan/dotfiles.git ~/dotfiles
cd ~/dotfiles

mkdir -p ~/.config
ln -sfn ~/dotfiles/.config/nvim           ~/.config/nvim
ln -sfn ~/dotfiles/.config/starship.toml ~/.config/starship.toml
ln -sfn ~/dotfiles/wezterm/.wezterm.lua   ~/.wezterm.lua        # Linux/Windows
ln -sfn ~/dotfiles/hypr/hyprlock.conf     ~/.config/hypr/hyprlock.conf  # Linux (Hyprland only)
```

> 🐍 First `nvim` launch auto-installs every plugin (pinned by
> `lazy-lock.json`) and Mason tool — nothing else to do.

The tools these configs expect are all listed in
[`docs/packages.md`](docs/packages.md).

---

## 🧱 Stack

Neovim (AstroNvim v6) · WezTerm · fish/zsh + **starship** · tmux · lazygit ·
fzf/fd/ripgrep/eza/bat · btop/fastfetch · Rust/Go/Python/Node toolchains ·
AWS CLI · opencode + CodeCompanion

*(Atomically: Arch + Hyprland + Hyprlock on the Linux box.)*

---

## 📚 Docs

- [**WezTerm**](docs/wezterm.md) · [**Starship**](docs/starship.md) · [**Hyprlock**](docs/hyprlock.md) — per-component guides
- [**Packages**](docs/packages.md) — everything I install, grouped by purpose
- [**Fonts**](docs/fonts.md) — 0xProto Nerd Font
- [**ASCII art**](docs/ascii-art.md) — where the banner art comes from
