local icons = require("icons")

local battery = sbar.add("item", {
	position = "right",
	icon = {
		font = {
			style = "Regular",
			size = 25,
		},
	},
	label = { drawing = true },
	update_freq = 120,
})

local function battery_update()
	sbar.exec("pmset -g batt", function(batt_info)
		local icon = "!"

		local found, _, charge = batt_info:find("(%d+)%%")

		if string.find(batt_info, "AC Power") then
			icon = icons.battery.charging
		else
			if found then
				charge = tonumber(charge)
			end

			if found and charge > 80 then
				icon = icons.battery._100
			elseif found and charge > 60 then
				icon = icons.battery._80
			elseif found and charge > 30 then
				icon = icons.battery._60
			elseif found and charge > 10 then
				icon = icons.battery._30
			else
				icon = icons.battery._0
			end
		end

		battery:set({ icon = icon, label = charge .. "%" })
	end)
end

battery:subscribe({ "routine", "power_source_change", "system_woke" }, battery_update)
