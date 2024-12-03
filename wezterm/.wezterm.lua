-- .wezterm.lua
-- My Wezterm Configuration

local wezterm = require 'wezterm'
local act = wezterm.action
-- Use config builder if possible
local config = {}
if wezterm.config_builder then config = wezterm.config_builder()
end

-- Shell
config.default_domain = 'WSL:Ubuntu'

-- Colour Scheme & Font
config.color_scheme = 'Catppuccin Macchiato'
config.font = wezterm.font("0xProto Nerd Font", {weight="Regular", stretch="Normal", style="Normal"}) -- C:\USERS\DUHNC\APPDATA\LOCAL\MICROSOFT\WINDOWS\FONTS\0XPROTONERDFONT-REGULAR.TTF, DirectWrite

-- Window 
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.9

-- Tab
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false 
config.tab_and_split_indices_are_zero_based = true
config.hide_tab_bar_if_only_one_tab = false

-- Key Mappings
config.leader = { key = "q", mods = "ALT", timeout_milliseconds = 1500 }
config.keys = {
    {
        mods = "LEADER",
        key = "c",
        action = wezterm.action.SpawnTab "CurrentPaneDomain",
    },
    {
        mods = "LEADER",
        key = "x",
        action = wezterm.action.CloseCurrentPane { confirm = true }
    },
    {
        mods = "LEADER",
        key = "b",
        action = wezterm.action.ActivateTabRelative(-1)
    },
    {
        mods = "LEADER",
        key = "n",
        action = wezterm.action.ActivateTabRelative(1)
    },
    {
        mods = "LEADER",
        key = "o",
        action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" }
    },
    {
        mods = "LEADER",
        key = "p",
        action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" }
    },
    { 
        key = ' ', 
        mods = 'LEADER', 
        action = wezterm.action.QuickSelect 
    }, 
}

-- Leader Key Activity
wezterm.on("update-right-status", function(window, _)
  local SOLID_LEFT_ARROW = ""
  local ARROW_FOREGROUND = { Foreground = { Color = "#c6d0f6" } }
  local prefix = ""

  if window:leader_is_active() then
    prefix = " " .. utf8.char(0x1F440)
    SOLID_LEFT_ARROW = utf8.char(0xe0b2)
  end

  if window:active_tab():tab_id() ~= 0 then
    ARROW_FOREGROUND = { Foreground = { Color = "#1e2030" } }
  end

  window:set_left_status(wezterm.format {
    { Background = { Color = "#b7bdf8"} },
    { Text = prefix },
    ARROW_FOREGROUND,
    { Text = SOLID_LEFT_ARROW}
  })
end)

return config
