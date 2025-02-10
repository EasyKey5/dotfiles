local icons = require("icons")
local colors = require("colors")

local popup_toggle = "sketchybar --set $NAME popup.drawing=toggle"

local apple_logo = sbar.add("item", {
	padding_right = 15,
	click_script = popup_toggle,
	icon = {
		string = icons.apple,
		font = {
			style = "Regular",
		},
		color = colors.accent,
		width = 37,
		padding_right = 10,
		padding_left = 10,
	},
	label = {
		drawing = false,
	},
	popup = {
		height = 35,
	},
})

local apple_prefs = sbar.add("item", {
	position = "popup." .. apple_logo.name,
	icon = icons.preferences,
	label = "Preferences",
	padding_left = 0,
	padding_right = 0,
	background = { color = colors.transparent },
})

apple_prefs:subscribe("mouse.clicked", function(_)
	sbar.exec("open -a 'System Preferences'")
	apple_logo:set({ popup = { drawing = false } })
end)
