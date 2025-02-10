local colors = require("colors")
local icons = require("icons")

local volume_slider = sbar.add("slider", 100, {
	position = "right",
	updates = true,
	label = { drawing = false },
	icon = { drawing = false },
	slider = {
		padding_left = 5,
		padding_right = 5,
		highlight_color = colors.accent,
		background = {
			height = 6,
			corner_radius = 3,
		},
		knob = {
			string = "",
			drawing = true,
		},
	},
})

local volume_icon = sbar.add("item", {
	position = "right",
	icon = {
		string = icons.volume._0,
		drawing = true,
		-- width = 40,
		-- padding_right = 50,
		align = "left",
		color = colors.white,
		font = {
			style = "Regular",
			size = 25.0,
		},
	},
	label = {
		-- width = 35,
		-- padding_right = 15,
		-- padding_left = 15,
		align = "left",
		font = {
			style = "Regular",
			-- size = 20.0,
		},
	},
})

volume_slider:subscribe("mouse.clicked", function(env)
	sbar.exec("osascript -e 'set volume output volume " .. env["PERCENTAGE"] .. "'")
end)

volume_slider:subscribe("volume_change", function(env)
	local volume = tonumber(env.INFO)
	local icon = icons.volume._0
	if volume > 66 then
		icon = icons.volume._100
	elseif volume > 33 then
		icon = icons.volume._66
	elseif volume > 0 then
		icon = icons.volume._33
	end

	-- NOTE: floor +0.5 will round to the nearest int
	volume_icon:set({ icon = icon, label = math.floor(volume * 16 / 100 + 0.5) })
	volume_slider:set({ slider = { percentage = volume } })
end)

local function animate_slider_width(width)
	sbar.animate("tanh", 30.0, function()
		volume_slider:set({ slider = { width = width } })
	end)
end

volume_icon:subscribe("mouse.clicked", function()
	if tonumber(volume_slider:query().slider.width) > 0 then
		animate_slider_width(0)
	else
		animate_slider_width(100)
	end
end)
