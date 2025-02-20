local sbar = require("sketchybar")
local icons = require("icons")

local calendar = sbar.add("item", {
	position = "right",
	update_freq = 15,
	icon = icons.cal,
	-- label = {
	-- 	string = os.date("%a %d %b %H:%M"),
	-- },
})

calendar:subscribe("mouse.clicked", function(env)
	sbar.exec("open /System/Applications/Calendar.app")
end)

local function update()
	date = os.date("%a %d %b %H:%M")
	calendar:set({ label = date })
end

calendar:subscribe("routine", update)
calendar:subscribe("forced", update)
