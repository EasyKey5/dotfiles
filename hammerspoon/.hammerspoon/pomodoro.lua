local hyper = require("hyper")

hyper.bindKey("i", function ()
	local result, command = hs.dialog.textPrompt("Applescript", "Input your command here","", "Execute", "Cancel")
	print(hs.inspect(command))
	hs.osascript.applescript('tell application "Bartender 5" to show "me.justinyan.justfocus-Item-0"')
	if command then
		hs.osascript.applescript(command)
	end
end
)


hyper.bindKey("p", function()
	local picker = hs.chooser.new(function(choice)
		print(choice.id)
		if choice.id == "start" then
			hs.osascript.applescript('tell application "JustFocus" to start pomodoro')
		elseif choice.id == "stop" then
			hs.osascript.applescript('tell application "JustFocus" to stop')
		elseif choice.id == "short" then
			hs.osascript.applescript('tell application "JustFocus" to stop')
			hs.osascript.applescript('tell application "JustFocus" to short break')
		elseif choice.id == "long" then
			hs.osascript.applescript('tell application "JustFocus" to stop')
			hs.osascript.applescript('tell application "JustFocus" to long break')
		end
	end)

	local choices = function()

		local result = { {
				text = "Start Pomodoro",
				subText = "Start a Pomodoro session",
				id = "start",
			},
			{
				text = "Stop Pomodoro",
				subText = "Stop the current Pomodoro session",
				id = "stop",
			},
			{
				text = "Start Short Break",
				subText = "Start a short break",
				id = "short",
			},
			{
				text = "Start Long Break",
				subText = "Start a long break",
				id = "long",
			},

		}

		print(hs.inspect(result))
		return result
	end

	picker:choices(choices())
	picker:show()
end)
