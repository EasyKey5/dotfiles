local hyper = require("hyper")
local execYabai = require("yabai").execYabai

local This = {}

local function float(mods, key, f)
	hyper.bindKeyWithModifiers(key, mods, function()
		print("send keystroke")

		execYabai("-m space --layout float")

		f()

		execYabai("-m window --toggle float")
		execYabai("-m window --grid 4:4:1:1:2:2")
		execYabai("-m space --layout bsp")
	end)
end

This.hotkeyTerm = function(mods, key)
	float(mods, key, function()
		hs.eventtap.keyStroke({ "cmd", "shift", "alt", "ctrl" }, "t")
	end)
end

This.FloatApp = function(mods, key, app)
	float(mods, key, function()
		hs.application.launchOrFocus(app)
	end)
end

return This
