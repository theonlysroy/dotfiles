local wezterm = require("wezterm")
local commands = require("commands")
local config = wezterm.config_builder()

-- Font settings
config.font_size = 19
config.line_height = 1.2
config.font = wezterm.font("Maple Mono")

-- Colors
config.colors = {
    cursor_bg = "white",
    cursor_border = "white"
}

-- Appearance
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true

-- Custom commands
wezterm.on("augment-command-palette", function ()
	return commands
end)

return config
