local hyper = require("hyper")
local yabai = require("yabai")

hyper.install("F18", 0.15)

-- Global Application Keyboard Shortcuts
hyper.bindKey("r", function()
	hs.reload()
end)

print("Hello, World")
