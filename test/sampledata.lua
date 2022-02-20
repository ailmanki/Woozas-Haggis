local json = require('lib.dkjson')

local function read_file(path)
	local file = io.open(path, "rb") -- r read mode and b binary mode
	if not file then return nil end
	local content = file:read "*a" -- *a or *all reads the whole file
	file:close()
	return content
end
local function getJson(path)
	path = 'voterandom/' .. path
	local str = read_file(path)
	
	-- http://dkolf.de/src/dkjson-lua.fsl/wiki?name=Documentation
	local obj, pos, err = json.decode (str, 1, nil, nil)
	if err then
		print ("Error:", err)
	else
		return obj
	end
end

return getJson