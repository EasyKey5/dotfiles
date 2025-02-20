local hyper = require("hyper")
local yabai = require("yabai")
local float = require("floatapp")
-- local networksetup = require("networksetup")
local pomodoro = require("pomodoro")

hyper.install("F18", 0.15)

-- Global Application Keyboard Shortcuts
hyper.bindKey("r", function()
	hs.reload()
end)

float.hotkeyTerm("shift", "t")

hyper.bindKey("o", function()
	-- hs.print("TExT")
	hs.alert("THIS IS A TEST")
	-- os.execute("darwin-rebuild switch --flake /Users/tama/dotfiles/nix/.config/nix/")
end)

print("Hello, World")
