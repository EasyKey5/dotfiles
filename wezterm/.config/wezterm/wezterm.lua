local wezterm = require("wezterm")
local config = {}

config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font_with_fallback({
	"SF Mono",
	"FiraCode Nerd Font Mono",
	"Iosevka Nerd Font",
})
config.font_size = 32
config.unicode_version = 15
config.enable_tab_bar = false
config.window_background_opacity = 0.9
-- config.default_prog = { "fish", "-c", "tmux", "attach", "-t", "base", "||", "tmux", "new", "-s", "base" }
config.default_prog = { "/run/current-system/sw/bin/fish", "-c tmux attach -t base || tmux new -s base" }
config.window_decorations = "RESIZE"
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = true

return config
