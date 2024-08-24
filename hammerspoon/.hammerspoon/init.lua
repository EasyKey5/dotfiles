local hyper = require("hyper")
local yabai = require("yabai")
local float = require("floatapp")
local networksetup = require("networksetup")
local pomodoro = require("pomodoro")

hyper.install("F18", 0.15)

-- Global Application Keyboard Shortcuts
hyper.bindKey("r", function()
	hs.reload()
end)

float.hotkeyTerm("shift", "t")


print("Hello, World")
