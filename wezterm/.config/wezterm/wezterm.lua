local wezterm = require("wezterm")
local config = {}

config.color_scheme = "Tokyo Night"
config.font = wezterm.font_with_fallback({
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

return config
