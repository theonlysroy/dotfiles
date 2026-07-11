local wezterm = require("wezterm")
local commands = require("commands")
local config = wezterm.config_builder()

-- Font settings
config.font_size = 11
config.line_height = 1.2
config.font = wezterm.font("Maple Mono", {weight = "Regular"})

-- Colors
config.colors = {
    cursor_bg = "white",
    cursor_border = "white"
}

-- Appearance
config.enable_wayland = true
config.window_decorations = "NONE"
config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.95
config.tab_bar_at_bottom = true
config.initial_cols = 140
config.initial_rows = 30
config.adjust_window_size_when_changing_font_size = false
config.window_padding = {
    left = "16px",
    right = "16px",
    top = "16px",
    bottom = "16px"
}
config.color_scheme = "Black Metal (base16)"
-- config.color_scheme = "Default (dark) (terminal.sexy)"
-- config.color_scheme = "Default (dark)"
config.scrollback_lines = 5000
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
config.audible_bell = "Disabled"

-- Cloud VMS, EC2, local server (ssh) specific configs
config.term = "xterm-256color"
-- config.enable_csi_u_key_encoding = false
-- config.enable_kitty_keyboard = false
-- config.swap_backspace_and_delete = false

-- layouts
config.keys = {
  -- -- Split Horizontally (Side-by-side, like Kitty's Horizontal/Grid)
  -- { key = 's', mods = 'CTRL|SHIFT', action = wezterm.action.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },
  -- -- Split Vertically (Stacked, like Kitty's Vertical)
  -- { key = 'v', mods = 'CTRL|SHIFT', action = wezterm.action.SplitVertical({ domain = 'CurrentPaneDomain' }) },
  -- -- Toggle Zoom (Like Kitty's Stack/Maximize layout)
  -- { key = 'z', mods = 'CTRL|SHIFT', action = wezterm.action.TogglePaneZoomState },
  -- Single keybinding mimicking Kitty's dynamic automatic layout engine
    {
      key = 'Enter',
      mods = 'CTRL|SHIFT',
      action = wezterm.action_callback(function(window, pane)
        -- 1. Grab the precise real-time dimension metrics of the focused pane
        local dims = pane:get_dimensions()
        local cols = dims.cols
        local rows = dims.viewport_rows

        -- 2. Define the threshold multiplier (Kitty uses a standard 1.6 to 1.8 golden ratio)
        -- If columns/width is significantly larger than rows/height, split right (vertical split).
        -- We scale rows by 1.8 because character height is physically larger than cell width.
        if cols > (rows * 1.8) then
          window:perform_action(
            wezterm.action.SplitHorizontal({ domain = 'CurrentPaneDomain' }),
            pane
          )
        else
          -- If the panel is tall or balanced, split down (horizontal split)
          window:perform_action(
            wezterm.action.SplitVertical({ domain = 'CurrentPaneDomain' }),
            pane
          )
        end
      end),
    },
  -- Navigate between panels using vim arrows
  { key = 'h', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection('Left') },
  { key = 'j', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection('Down') },
  { key = 'k', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection('Up') },
  { key = 'l', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection('Right') },
}

-- Custom commands
wezterm.on("augment-command-palette", function ()
	return commands
end)

return config
