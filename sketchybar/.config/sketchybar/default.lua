local settings = require("settings")
local colors = require("colors")

-- Equivalent to the --default domain
sbar.default({
	updates = "when_shown",
	icon = {
		font = {
			family = settings.font,
			style = "Bold",
			size = 20.0,
		},
		color = colors.white,
		padding_left = 10,
		padding_right = 4,
	},
	label = {
		font = {
			family = settings.font,
			style = "Regular",
			size = 20.0,
		},
		color = colors.white,
		padding_left = 4,
		padding_right = 10,
	},
	background = {
		height = 26,
		corner_radius = 9,
		border_width = 2,
		color = colors.bg,
	},
	popup = {
		background = {
			border_width = 2,
			corner_radius = 9,
			border_color = colors.popup.border,
			color = colors.popup.bg,
			shadow = { drawing = true },
		},
		blur_radius = 20,
	},
	padding_left = 5,
	padding_right = 5,
})
