local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.enable_wayland = true
config.font_size = 12.0
config.tab_max_width = 30
config.use_fancy_tab_bar = false
config.scrollback_lines = 100000
config.window_decorations = "RESIZE"
config.color_scheme = "Github Dark (Gogh)"
config.hide_tab_bar_if_only_one_tab = true
config.colors = { foreground = "#FFFFFF" }
config.font = wezterm.font("JetBrains Mono Nerd Font")
config.adjust_window_size_when_changing_font_size = false
config.window_padding = { top = 8, left = 8, right = 0, bottom = 0 }

config.leader = { key = "l", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = {
	-- Pane Navigation
	{ key = "LeftArrow", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "DownArrow", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Down") },
	{ key = "UpArrow", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "RightArrow", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Right") },
	{ key = "h", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "j", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Down") },
	{ key = "k", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "l", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Right") },
	{ key = "r", mods = "LEADER", action = wezterm.action.PromptInputLine({
			description = "Enter new tab name",
			action = wezterm.action_callback(function(window, _, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	{ key = "w", mods = "LEADER", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
	{ key = "k", mods = "LEADER", action = wezterm.action.ClearScrollback("ScrollbackAndViewport") },
	{ key = "h", mods = "LEADER", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	{ key = "v", mods = "LEADER", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },

	{ key = "v", mods = "CTRL", action = wezterm.action({ PasteFrom = "Clipboard" }) }, -- Copy Paste
	{ key = "t", mods = "CTRL", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) }, -- New Tab

	{ key = "F11", action = wezterm.action.ToggleFullScreen },
	{ key = "f", mods = "CMD|SHIFT", action = wezterm.action.ToggleFullScreen },
}

-- wezterm.on("update-status", function(window, pane)
--   local date = wezterm.strftime("%Y-%m-%d %H:%M:%S")
--   local battery = ""
--   for _, b in ipairs(wezterm.battery_info()) do
--     battery = string.format("%.0f%%", b.state_of_charge * 100)
--   end
--   window:set_right_status(wezterm.format({
--     {Text=string.format("%s | %s", battery, date)},
--   }))
-- end)



return config



