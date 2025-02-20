local mapper = require("app_icon_map")
local colors = require("colors")

local front_app = sbar.add("item", {
	background = {
		color = colors.bg,
	},
	icon = {
		drawing = true,
		font = "sketchybar-app-font:regular:20",
		color = colors.blue,
	},
	label = {
		font = {
			style = "Bold",
		},
		color = colors.blue,
	},
})

front_app:subscribe("front_app_switched", function(env)
	front_app:set({
		label = {
			string = env.INFO,
		},
		icon = mapper[env.INFO],
	})

	-- Or equivalently:
	-- sbar.set(env.NAME, {
	--   label = {
	--     string = env.INFO
	--   }
	-- })
end)
