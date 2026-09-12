# duguy/nvim

**AstroNvim v6** — Neovim 0.12+, built on the [AstroNvim](https://github.com/AstroNvim/AstroNvim) template with [astrocommunity](https://github.com/AstroNvim/astrocommunity) packs for per-language tooling.

---

## Layout

All plugin files live **flat** under `lua/plugins/` — lazy.nvim only scans
top-level `*.lua` there; subdirectories are silently ignored.

```
lua/
├── community.lua        AstroNvim astrocommunity repo spec
├── init.lua             User options (sourced last by init.lua)
├── lazy_setup.lua       Plugin bootstrap — import order matters
├── polish.lua           Post-setup hooks (runs last)
└── plugins/
    ├── astrocore.lua       Options, features, globals
    ├── astrolsp.lua        LSP defaults + format_on_save settings
    ├── astroui.lua         Statusline / UI styling + highlight overrides
    ├── theme.lua           Colorscheme (catppuccin macchiato)
    ├── mappings.lua        ALL custom keymaps (astrocore + astrolsp)
    ├── completion.lua      blink-cmp, LuaSnip, lsp_signature, autopairs
    ├── search.lua          snacks picker (frecency)
    ├── workflow.lua        Neogit, Diffview
    ├── ui.lua              Dashboard header, presence.nvim
    ├── editor.lua          better-escape (disabled)
    ├── format.lua          Extra none-ls / null-ls sources
    ├── mason.lua           Mason defaults
    ├── treesitter.lua      Treesitter defaults
    ├── lang-go.lua         Go pack
    ├── lang-python.lua     Python pack
    ├── lang-rust.lua       Rust pack
    ├── lang-typescript.lua TypeScript / JavaScript pack
    ├── lang-lua.lua        Lua pack
    ├── lang-prose.lua      Markdown pack (+ markview.nvim)
    ├── lang-json.lua       JSON pack
    ├── lang-yaml.lua       YAML pack (+ yaml formatting)
    ├── opencode.lua        opencode.nvim AI agent (<leader>0)
    └── codecompanion.lua   CodeCompanion AI chat (<leader>9)
```

---

## Theme

| Setting | Value |
|---------|-------|
| Colorscheme | **Catppuccin Frappe** (`catppuccin-frappe`) |
| Config file | `lua/plugins/theme.lua` |

Selected with the explicit flavour name (`catppuccin-frappe`, not
`catppuccin`) — the plain name silently falls back to mocha. lazy.nvim
lazy-loads the plugin for you on `ColorSchemePre`. Highlight tweaks and
icons stay in `astroui.lua`; the scheme itself lives in `theme.lua`.

---

## Languages & Formatters

Format-on-save is configured in `astrolsp.lua` and runs automatically on
every file write (controlled per-file or globally via the keymaps below).
Where `conform.nvim` is installed (Go, Python, Lua), it runs first; all
other languages format through the LSP server directly.

| Language       | LSP server | Conform / formatter        | Mason tool(s)                        |
|----------------|------------|----------------------------|---------------------------------------|
| **Go**         | gopls      | goimports → gopls fallback | gopls, goimports, delve, gomodifytags |
| **Python**     | basedpyright | black, isort, ruff_fix   | basedpyright, debugpy, ruff, isort, black |
| **Rust**       | rust-analyzer | *(LSP only — rustfmt)*   | rust-analyzer, codelldb              |
| **TypeScript** | vtsls      | *(LSP only)*               | vtsls, js-debug-adapter               |
| **Lua**        | lua_ls     | stylua                     | lua-language-server, stylua, selene   |
| **Markdown**   | marksman   | *(LSP only)*               | marksman                              |
| **JSON**       | jsonls     | *(LSP only)*               | json-lsp + schemastore.nvim           |
| **YAML**       | yamlls     | *(LSP only)*               | yaml-language-server + schemastore    |

Markdown files are also rendered in-buffer as you read/edit them via
**markview.nvim** (Obsidian-style conceal, no preview window) — added in
`lang-prose.lua`. Toggle with `:Markview toggle` (buffer) or `:Markview`
(attached buffers); `:Markview disable/enable` for per-buffer control.

> `astrocore.list_insert_unique` ensures every pack's Mason tools are
> merged — no duplicates, even if multiple packs request the same package.

---

## Formatting Controls

| Keybinding | Scope | What it does |
|------------|-------|--------------|
| `<Leader>lf` | buffer | Format the current buffer now (manual, one-shot) |
| `<Leader>uf` | buffer | **Toggle** autoformat for this buffer (all future saves) |
| `<Leader>uF` | global | **Toggle** autoformat globally (all buffers) |

**Save once without formatting** — run `:noau w` (`:noautocmd write`). This
skips every `BufWritePre` hook for that single save, including format.

Toggle the default in `astrolsp.lua` under `formatting.format_on_save.enabled`.

---

## Other Keymaps

See `mappings.lua` for the full list. A few highlights:

| Keybinding | Mode | Action |
|------------|------|--------|
| `]b` / `[b` | n | Next / previous buffer |
| `<Leader>bd` | n | Pick buffer from tabline to close |
| `gD` | n | LSP declaration |
| `<Leader>uY` | n | Toggle semantic highlighting (buffer) |
| `<Leader>gG` | n | Neogit status |
| `<Leader>gd` | n | Diffview open |
| `<Leader>0g` | n | opencode.nvim: toggle AI chat |
| `<Leader>0i` | n | opencode.nvim: open input (new session focus) |
| `<Leader>9c` | n/v | CodeCompanion: toggle chat |
| `<Leader>9p` | n/v | CodeCompanion: action palette |
| `<Leader>9q` | n/v | CodeCompanion: inline assistant |
| `<Leader>9a` | v | CodeCompanion: add selection to chat |

---

## Setup

This config lives at `.config/nvim` inside the **dotfiles** repository. On a
new machine, symlink it into place — Neovim then installs every plugin
(pinned by `lazy-lock.json`) and Mason tool automatically on first launch.

### Back up existing config (first time only)

```bash
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
```

### Import onto a new machine (from dotfiles repo root)

```bash
git clone <your-dotfiles-repo-url> ~/dotfiles
ln -s ~/dotfiles/.config/nvim ~/.config/nvim
nvim   # lazy.nvim installs everything automatically
```

### Update this config on a machine (from dotfiles repo root)

```bash
mkdir -p .config && cp -rT ~/.config/nvim .config/nvim
git add .config/nvim && git commit -m "nvim: sync config" && git push
```

Then `git pull` on the new machine. Changes made directly in
`~/.config/nvim` are lost on `cp -rT` if the repo copy is newer — re-run the
sync after editing.

> The plugin folder is **flat** by design (`lua/plugins/*.lua`); lazy only
> reads top-level files there, so keep everything at that level.

---

## Custom Shortcuts

*To be defined — will be added here and in `mappings.lua`.*
