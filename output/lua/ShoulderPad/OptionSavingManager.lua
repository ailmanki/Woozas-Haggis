-- make it store this shoulder pad id in a different location
Event.Hook("LoadComplete", function()
	local oldClientGetOptionInteger = Client.GetOptionInteger
	local oldClientSetOptionInteger = Client.SetOptionInteger
	Client.GetOptionInteger = function(path, default)
		if path == "shoulderPad" then
			path = "woozaShoulderPad"
		end
		return oldClientGetOptionInteger( path, default)
	end
	Client.SetOptionInteger = function(path, value)
		if path == "shoulderPad" then
			path = "woozaShoulderPad"
		end
		return oldClientSetOptionInteger( path, value)
	end
end)