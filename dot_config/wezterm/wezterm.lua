-- Pull in the wezterm API
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.font_size = 10.0
config.tab_bar_at_bottom = false
config.window_padding = {
  left = 8,
  right = 8,
  top = 8,
  bottom = 8,
}

config.colors = {
  foreground = "#FFFFFF",
}

-- set the window opacity
--config.window_background_opacity = 0.30


config.hide_tab_bar_if_only_one_tab = true


-- Set the tab bar format.
config.window_frame = {
  -- font = require('wezterm').font 'Roboto',
  font = require('wezterm').font 'JetBrainsMonoNL NFM',
  font_size = 10,
}

config.keys = {
  {key="v", mods="CTRL", action=wezterm.action{PasteFrom="Clipboard"}},
  {key="k", mods="ALT", action=wezterm.action{ClearScrollback="ScrollbackAndViewport"}},
}

return config
