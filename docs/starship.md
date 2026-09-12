# Starship prompt

> **Platforms:** all — works identically in fish, zsh, bash or any prompted
> shell on Linux, macOS, or Windows (WSL).

Config lives at [`terminal/starship.toml`](../terminal/starship.toml), symlinked
to `~/.config/starship.toml`.

## Look

Catppuccin Macchiato palette with powerline-style chevrons and no newline:

```
█ 󰣇  duguy   dir    _ branch  status   … 
                                               status ⎈ k8s   time
```

## Segments

**Left** (in order): OS icon → username → directory → git branch/status.

**Right**: exit-code status → Kubernetes context/namespace → clock
(`%Y-%m-%d %H:%M:%S`).

## Details / quirks

- Full Catppuccin Macchiato palette (all 26 colors) defined inline via
  `palette`, so it renders correctly without starship's built-in Catppuccin
  theme.
- `directory` uses custom powerline styling, truncates at 10 components with
  `…/`, and `truncate_to_repo = false` (shows the real path, not the repo
  root).
- `status` shows ✓/✗ with color-coded success/failure.
- Kubernetes shows `context` and `(namespace)` when present.
- OS symbols included for **Windows**, **macOS**, **Ubuntu**, **Arch**,
  **Manjaro**, etc. so the same config adapts to whatever machine prompts it.