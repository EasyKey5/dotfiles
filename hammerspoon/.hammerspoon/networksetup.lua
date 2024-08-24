local hyper = require("hyper")

hyper.bindKey("n", function()
	local choose = hs.chooser.new(function(choice)
		-- run networksetup -switchtolocation choice
		hs.execute("networksetup -switchtolocation " .. choice.id)
	end)

	local choices = function()
		local choices = hs.execute("networksetup -listlocations")

		print(hs.inspect(choices))
		local result = {}
		for choice in choices:gmatch("[^\n]+") do
			table.insert(result, {
				text = choice,
				subText = "Switch to " .. choice .. " location",
				id = choice,
			})
		end

		print(hs.inspect(result))
		return result
	end

	choose:choices(choices())
	choose:show()
end)
