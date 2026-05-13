local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font_size = 14.0
config.tab_max_width = 200
config.use_fancy_tab_bar = true
config.scrollback_lines = 100000
config.window_decorations = "TITLE | RESIZE"
config.color_scheme = "Github Dark (Gogh)"
config.hide_tab_bar_if_only_one_tab = true
config.colors = { foreground = "#FFFFFF" }
config.font = wezterm.font("JetBrains Mono")
config.adjust_window_size_when_changing_font_size = false
config.window_padding = { top = 8, left = 8, right = 8, bottom = 8 }
config.leader = { key = "l", mods = "CTRL", timeout_milliseconds = 2000 }
config.window_frame = {
  font_size = 13.0,
  font = wezterm.font({ family = "JetBrains Mono" }),
}
config.colors = {
  tab_bar = {
    background = "#0b0e14",
    active_tab = {
      bg_color = "#7aa2f7",
      fg_color = "#0b0e14",
      intensity = "Bold",
    },
    inactive_tab = {
      bg_color = "#1a1b26",
      fg_color = "#a9b1d6",
    },

    inactive_tab_hover = {
      bg_color = "#24283b",
      fg_color = "#c0caf5",
      italic = false,
    },

    new_tab = {
      bg_color = "#1a1b26",
      fg_color = "#a9b1d6",
    },

    new_tab_hover = {
      bg_color = "#7aa2f7",
      fg_color = "#0b0e14",
      intensity = "Bold",
    },
  },
}
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
  { key = "k", mods = "ALT|SHIFT", action = wezterm.action.ClearScrollback("ScrollbackAndViewport") },
}

if wezterm.target_triple:find("windows") ~= nil then
  config.default_domain = "WSL:archlinux"
end


wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local title = tab.active_pane.title

  -- Prefer explicit tab title if set
  if tab.tab_title and #tab.tab_title > 0 then
    title = tab.tab_title
  end

  -- Add index and truncate
  local tab_index = tab.tab_index + 1
  local formatted_title = " " .. tab_index .. ": " .. wezterm.truncate_right(title, max_width - 4) .. " "

  if tab.is_active then
    return {
      { Attribute = { Intensity = "Bold" } },
      { Text = formatted_title },
    }
  end

  return {
    { Text = " " .. tab_index .. ": " .. wezterm.truncate_right(title, max_width - 4) .. " " },
  }
end)


return config
