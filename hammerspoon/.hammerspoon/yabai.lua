local yabaiOutput, _, _, _ = hs.execute("which yabai", true)
local yabai = string.gsub(yabaiOutput, "%s+", "")

local hyper = require("hyper")

local function execYabai(args)
	local command = string.format("%s %s", yabai, args)
	print(string.format("yabai: %s", command))
	os.execute(command)
end

-- "directions" for vim keybindings
local directions = {
	h = "west",
	l = "east",
	k = "north",
	j = "south",
}

for key, direction in pairs(directions) do
	-- focus windows
	-- cmd + ctrl
	hyper.bindKey(key, function()
		print(key)
		execYabai(string.format("-m window --focus %s", direction))
	end)
	-- move windows
	-- cmd + shift
	hyper.bindShiftKey(key, function()
		execYabai(string.format("-m window --warp %s", direction))
	end)
	-- swap windows
	-- alt + shift
	hyper.bindKeyWithModifiers(key, { "alt" }, function()
		execYabai(string.format("-m window --swap %s", direction))
	end)
end

-- throw/focus monitors
local targets = {
	x = "recent",
	z = "prev",
	c = "next",
}
for key, target in pairs(targets) do
	hyper.bindKey(key, function()
		execYabai(string.format("-m display --focus %s", target))
	end)
	hyper.bindShiftKey(key, function()
		execYabai(string.format("-m window --display %s", target))
		execYabai(string.format("-m display --focus %s", target))
	end)
end

-- numbered monitors
for i = 1, 5 do
	hs.hotkey.bind({ "ctrl", "alt" }, tostring(i), function()
		execYabai(string.format("-m display --focus %s", i))
	end)
	hs.hotkey.bind({ "ctrl", "cmd" }, tostring(i), function()
		execYabai(string.format("-m window --display %s", i))
		execYabai(string.format("-m display --focus %s", i))
	end)
end

-- numbered spaces
for i = 1, 9 do
	hyper.bindKey(tostring(i), function()
		execYabai(string.format("-m space --focus %s", i))
	end)
end

for i = 1, 9 do
	hs.hotkey.bind({ "alt" }, tostring(i), function()
		execYabai(string.format("-m window --space %s", i))
		execYabai(string.format("-m space --focus %s", i))
		hs.alert(string.format("Moved to space %s", i))
	end)
end

-- window float settings
-- alt + shift
-- WARN: Doesn't seem to be working (yabai doesn't know what a `grid` is)

--[[ local floating = {
	-- full
	up = "4:4:1:1:2:2",
	-- left half
	left = "1:2:0:0:1:1",
	-- right half
	right = "1:2:1:0:1:1",
}
for key, gridConfig in pairs(floating) do
	hs.hotkey.bind({ "alt", "shift" }, key, function()
		execYabai("-m window --toggle float")
		execYabai(string.format("-m window --grid %s", gridConfig))
	end)
end ]]

-- Float window
hyper.bindKey("g", function()
	execYabai("-m window --toggle float")
	execYabai("-m window --grid 10:10:1:1:8:8")
end)

--NOTE: unused
-- balance window size

hs.hotkey.bind({ "alt", "shift" }, "0", function()
	execYabai("-m space --balance")
end)



-- layout settings
local layouts = {
	b = "bsp",
	f = "float",
}
for key, layout in pairs(layouts) do
	hs.hotkey.bind({ "alt", "shift" }, key, function()
		execYabai(string.format("-m space --layout %s", layout))
	end)
end

--NOTE: toggle OPTIONS (alt)
local toggleArgs = {
	a = "-m space --toggle padding; opt/homebrew/bin/yabai -m space --toggle gap",
	s = "-m window --toggle sticky",
	g = "-m window --toggle float; /opt/homebrew/bin/yabai -m window --grid 4:4:1:1:2:2",
	-- d = "-m window --toggle zoom-parent",
	e = "-m window --toggle split",
	-- o = "-m window --toggle topmost",
	r = "-m space --rotate 90",
	x = "-m space --mirror x-axis",
	y = "-m space --mirror y-axis",
}

-- toggle fullscreen
hyper.bindShiftKey("f", function ()
	execYabai("-m window --toggle zoom-fullscreen")
end)

for key, command in pairs(toggleArgs) do
	hyper.bindKeyWithModifiers(key, { "alt" }, function()
		execYabai(command)
	end)
end

--NOTE: Toggle an app

hs.application.enableSpotlightForNameSearches(true)
local toggleApp = function(appName, launch)
	launch = launch or false
	local app = hs.application.get(appName)
	if app then
		if app:isFrontmost() then
			app:hide()
		else
			app:activate()
		end
	else
		if launch then
			hs.application.launchOrFocus(appName)
		else
			hs.alert.show("App '" .. appName .. "' is not loaded!")
		end
	end
end

return {
	yabai = yabai,
	execYabai = execYabai,
}
