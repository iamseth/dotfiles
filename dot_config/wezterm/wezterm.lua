local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font_size = 14.0
config.tab_max_width = 200
config.use_fancy_tab_bar = true
-- Accepted tradeoff: 100,000 lines of scrollback per pane can use significant memory.
config.scrollback_lines = 100000
config.window_decorations = "TITLE | RESIZE"
config.color_scheme = 'tokyonight_night'
config.hide_tab_bar_if_only_one_tab = true
config.font = wezterm.font("JetBrains Mono")
config.adjust_window_size_when_changing_font_size = false
config.window_padding = { top = 8, left = 8, right = 8, bottom = 8 }
-- Accepted tradeoff: using CTRL+l as the leader prevents shells from receiving it for clear-screen.
config.leader = { key = "l", mods = "CTRL", timeout_milliseconds = 2000 }
config.window_frame = {
  font_size = 13.0,
  font = wezterm.font({ family = "JetBrains Mono" }),
}

local zen_columns = 120
local zen_tabs = {}
local zen_windows = {}

local function clean_up_zen_state()
  local live_tabs = {}
  local live_windows = {}

  for _, mux_window in ipairs(wezterm.mux.all_windows()) do
    live_windows[mux_window:window_id()] = true
    for _, tab in ipairs(mux_window:tabs()) do
      live_tabs[tab:tab_id()] = true
    end
  end

  for tab_id in pairs(zen_tabs) do
    if not live_tabs[tab_id] then
      zen_tabs[tab_id] = nil
    end
  end
  for window_id in pairs(zen_windows) do
    if not live_windows[window_id] then
      zen_windows[window_id] = nil
    end
  end
end

local function apply_zen_mode(window, pane)
  local tab_id = window:active_tab():tab_id()
  local enabled = zen_tabs[tab_id] == true
  local dimensions = window:get_dimensions()
  local window_key = window:mux_window():window_id()
  local previous = zen_windows[window_key]

  -- Avoid repeatedly applying the same override. Recalculate Zen padding after
  -- a window resize, since the 120-column region needs to remain centered.
  if previous
    and previous.enabled == enabled
    and (not enabled or previous.pixel_width == dimensions.pixel_width)
  then
    return
  end

  local overrides = window:get_config_overrides() or {}
  if enabled then
    local pane_dimensions = pane:get_dimensions()
    local cell_width = pane_dimensions.pixel_width / pane_dimensions.cols
    local side_padding = math.max(
      8,
      math.floor((dimensions.pixel_width - zen_columns * cell_width) / 2 + 0.5)
    )

    overrides.window_padding = {
      top = 8,
      left = side_padding,
      right = side_padding,
      bottom = 8,
    }
  else
    -- Removing the override restores config.window_padding below.
    overrides.window_padding = nil
  end

  zen_windows[window_key] = {
    enabled = enabled,
    pixel_width = dimensions.pixel_width,
  }
  window:set_config_overrides(overrides)
end

wezterm.on("update-status", function(window, pane)
  clean_up_zen_state()
  apply_zen_mode(window, pane)
end)

config.colors = {
  foreground = "#FFFFFF",
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
  -- Toggle a centered, 120-column reading layout with LEADER+z
  {
    key = "z",
    mods = "LEADER",
    action = wezterm.action_callback(function(window, pane)
      local tab_id = window:active_tab():tab_id()
      zen_tabs[tab_id] = not zen_tabs[tab_id]

      -- Force an immediate update rather than waiting for update-status.
      zen_windows[window:mux_window():window_id()] = nil
      apply_zen_mode(window, pane)
    end),
  },

  -- Navigation between tabs and panes
  { key = "[", mods = "CMD", action = wezterm.action.ActivateTabRelative(-1) },
  { key = "]", mods = "CMD", action = wezterm.action.ActivateTabRelative(1) },
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

  -- Accepted tradeoff: these prevent terminal apps from receiving CTRL+v and CTRL+t.
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

  -- Clear scrollback with ALT+SHIFT+k
  { key = "k", mods = "ALT|SHIFT", action = wezterm.action.ClearScrollback("ScrollbackAndViewport") },
}

if wezterm.target_triple:find("windows") ~= nil then
  -- Accepted requirement: this Windows setup must provide a domain named exactly WSL:archlinux.
  config.default_domain = "WSL:archlinux"
end


wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local title = tab.active_pane.title

  -- Prefer explicit tab title if set
  if tab.tab_title and #tab.tab_title > 0 then
    title = tab.tab_title
  end

  -- Add the index and truncate the title to keep the complete label within max_width.
  local tab_index = tab.tab_index + 1
  local prefix = " " .. tab_index .. ": "
  local suffix = " "
  local title_width = math.max(0, max_width - #prefix - #suffix)
  local formatted_title = prefix .. wezterm.truncate_right(title, title_width) .. suffix

  if tab.is_active then
    return {
      { Attribute = { Intensity = "Bold" } },
      { Text = formatted_title },
    }
  end

  return {
    { Text = formatted_title },
  }
end)


-- left       = '\x02\x1b[D', -- Ctrl+B, Left
-- right      = '\x02\x1b[C', -- Ctrl+B, Right
-- up         = '\x02\x1b[A', -- Ctrl+B, Up
-- down       = '\x02\x1b[B', -- Ctrl+B, Down


local herdr = {
  left  = '\x02h', -- Ctrl+B, h
  right = '\x02l', -- Ctrl+B, l
  up    = '\x02k', -- Ctrl+B, k
  down  = '\x02j', -- Ctrl+B, j
  next_tab   = '\x02n',      -- Ctrl+B, n
  prev_tab   = '\x02p',      -- Ctrl+B, p
  zoom       = '\x02z',      -- Ctrl+B, z

  next_space = nil, -- Set to herdr's actual sequence
  prev_space = nil, -- Set to herdr's actual sequence
}

config.keys = config.keys or {}

local function bind_controller(key, sequence)
  if sequence then
    table.insert(config.keys, {
      key = key,
      mods = 'CTRL|ALT',
      action = wezterm.action.SendString(sequence),
    })
  end
end

bind_controller('LeftArrow',  herdr.left)
bind_controller('RightArrow', herdr.right)
bind_controller('UpArrow',    herdr.up)
bind_controller('DownArrow',  herdr.down)
bind_controller('n',          herdr.next_tab)
bind_controller('p',          herdr.prev_tab)
bind_controller('s',          herdr.next_space)
bind_controller('a',          herdr.prev_space)
bind_controller('z',          herdr.zoom)





return config
