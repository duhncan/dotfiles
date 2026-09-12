# WezTerm

> **Platforms:** Linux (primary), Windows/WSL — WezTerm's own config format is
> cross-platform; this file is tuned for Linux but the keymap/theme parts work
> everywhere.

Config lives at [`wezterm/.wezterm.lua`](../wezterm/.wezterm.lua), symlinked to
`~/.wezterm.lua`.

## Look & feel

| Setting | Value |
|---------|-------|
| Color scheme | **Catppuccin Macchiato** |
| Font size | 15 |
| Window background | 95% opacity |
| Window decorations | RESIZE only |
| Tab bar | Bottom, non-fancy (native) |
| Wayland | Disabled (`enable_wayland = false`) |

## Leader key

Everything routes through **`ALT+q`** (leader timeout 1500 ms):

| Leader shortcut | Action |
|-----------------|--------|
| `ALT+q` `c`    | New tab |
| `ALT+q` `x`    | Close current pane (with confirm) |
| `ALT+q` `b` / `n` | Previous / next tab |
| `ALT+q` `o` / `p` | Split horizontal / vertical |
| `ALT+q` `space` | QuickSelect |

A small 👀 indicator slides into the left status line whenever the leader is
active (`update-right-status` hook).