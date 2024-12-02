-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Colour Scheme & Font
config.color_scheme = 'Catppuccin Macchiato'
config.font = wezterm.font("0xProto Nerd Font", {weight="Regular", stretch="Normal", style="Normal"}) -- C:\USERS\DUHNC\APPDATA\LOCAL\MICROSOFT\WINDOWS\FONTS\0XPROTONERDFONT-REGULAR.TTF, DirectWrite

-- Window Configuration 
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false 
config.tab_and_split_indices_are_zero_based = true
config.window_background_opacity = 0.9

-- Default Terminal
config.default_domain = 'WSL:Ubuntu'

-- Quick Select 
config.keys = {
    { key = ' ', mods = 'SHIFT|CTRL', action = wezterm.action.QuickSelect },
  }

return config
