local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font_size = 12.0
config.tab_max_width = 30
config.use_fancy_tab_bar = false
config.scrollback_lines = 100000
-- config.window_decorations = "RESIZE"
config.window_decorations = "TITLE | RESIZE"
config.color_scheme = "Github Dark (Gogh)"
config.hide_tab_bar_if_only_one_tab = true
config.colors = { foreground = "#FFFFFF" }
config.font = wezterm.font("JetBrains Mono")
config.adjust_window_size_when_changing_font_size = false
config.window_padding = { top = 8, left = 8, right = 8, bottom = 8 }
config.leader = { key = "l", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = {
  -- Navigation between tabs and panes
  { key = "[", mods = "ALT", action = wezterm.action.ActivateTabRelative(-1) },
  { key = "]", mods = "ALT", action = wezterm.action.ActivateTabRelative(1) },
	{ key = "h", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "j", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Down") },
	{ key = "k", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "l", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Right") },
	{ key = "LeftArrow", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "DownArrow", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Down") },
	{ key = "UpArrow", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "RightArrow", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Right") },

  -- Split panes with LEADER+h and LEADER+v
	{ key = "h", mods = "LEADER", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	{ key = "v", mods = "LEADER", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },

  -- Paste with CTRL+V
	{ key = "v", mods = "CTRL", action = wezterm.action({ PasteFrom = "Clipboard" }) },

  -- Create new tab with CTRL+T
	{ key = "t", mods = "CTRL", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },

  -- Toggle fullscreen with CMD+SHIFT+f
	{ key = "f", mods = "CMD|SHIFT", action = wezterm.action.ToggleFullScreen },

  -- Rename tab with LEADER+r
	{ key = "r", mods = "LEADER", action = wezterm.action.PromptInputLine({
      description = "Enter new tab name",
			action = wezterm.action_callback(function(window, _, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},

  -- Clear scrollback with CTRL+k
  { key = "k", mods = "CTRL", action = wezterm.action.ClearScrollback("ScrollbackAndViewport") },
}

if wezterm.target_triple:find("windows") ~= nil then
  config.default_domain = "WSL:archlinux"
  config.window_decorations = "TITLE | RESIZE"
end

return config
