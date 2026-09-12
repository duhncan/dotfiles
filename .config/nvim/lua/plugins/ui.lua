---@type LazySpec
-- ============================================================================
-- UI  --  dashboard, presence, anything pretty
-- ============================================================================
-- The colorscheme and highlight overrides live in `astroui.lua`; this file is
-- for additional UI plugins and appearance tweaks.
return {
  -- Dashboard: custom header art
  {
    "folke/snacks.nvim",
    priority = 2000,
    after = {
      "dashboard",
    },
    opts = function(_, opts)
      opts.dashboard.preset.header = table.concat({
        "    ░░░                                ",
        "    ▒▒▒                                ",
        "    ▓▓▓                                ",
        "▄██▀███ ███ ███ ▄██▀██▄ ███ ███ ███ ███",
        "███ ███ ███ ███ ███ ███ ███ ███ ███ ███",
        "███ ███ ███ ███ ███ ███ ███ ███  ▀▀▀███",
        "███ ███ ███ ███ ███ ███ ███ ███ ███ ███",
        "███ ███ ███ ███ ███ ███ ███ ███ ███ ███",
        "▀██▄███ ▀██▄███ ▀██▄███ ▀██▄███ ▀██▄██▀",
        "     ▀█      ▀█ ▄▄▄ ███      ▀█   █▀   ",
        "      ▄       ▄ ▀██▄██▀       ▄   ▄    ",
      }, "\n")
      return opts
    end,
  },
  -- Discord Rich Presence (shows what you're editing)
  "andweeb/presence.nvim",
}