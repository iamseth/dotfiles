local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.font_size = 11.0
config.tab_bar_at_bottom = false
config.colors = { foreground = "#FFFFFF" }
config.hide_tab_bar_if_only_one_tab = true
config.font = wezterm.font('JetBrains Mono Nerd Font')

config.window_padding = {
  top = 8,
  left = 8,
  right = 0,
  bottom = 0,
}

config.window_frame = {
  font_size = 11,
  font = require('wezterm').font 'JetBrains Mono Nerd Font',
}

config.keys = {
  {key="v", mods="CTRL", action=wezterm.action{PasteFrom="Clipboard"}},
  {key="k", mods="ALT", action=wezterm.action{ClearScrollback="ScrollbackAndViewport"}},
}

return config
