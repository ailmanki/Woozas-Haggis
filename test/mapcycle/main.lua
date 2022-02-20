local json = require ('lib.dkjson')

-- Clear console
if not os.execute("clear") then os.execute("cls") end

local mapcycle = require('mapCycle')
local data = json.encode(mapcycle, {indent= 2})

file = io.open('mapCycle.json', "w")
file:write(data)
io.close(file)

print(data)