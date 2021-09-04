-- make it store this shoulder pad id in a different location
local oldClientGetOptionInteger = Client.GetOptionInteger
local oldClientSetOptionInteger = Client.SetOptionInteger
Client.GetOptionInteger = function(path, default)
	if path == "shoulderPad" then
		return oldClientGetOptionInteger( "haggisShoulderPad", default)
	end
	return oldClientGetOptionInteger(path, default)
end
Client.SetOptionInteger = function(path, value)
	if path == "shoulderPad" then
		return oldClientSetOptionInteger( "haggisShoulderPad", value)
	end
	return oldClientSetOptionInteger(path, value)
end