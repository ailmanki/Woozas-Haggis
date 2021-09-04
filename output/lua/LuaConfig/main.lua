-- Run when entry file is read

ModLoader.SetupFileHook("lua/shine/core/shared/config.lua", "lua/LuaConfig/shine_config.lua", "post")

local byte = string.byte

local function loadconfigjson(path)
	local data, _
	local file, err = io.open(path)
	if not err then
		data, _, err = json.decode(file:read "*a")
	end
	if err then
		Shared.Message("Error while opening " .. path .. ": " .. err)
	end
	if file then file:close() end
	return data, err
end

local function errorhandler(e)
	Shared.Message(debug.traceback(e, 2))
	return e
end

local function loadconfiglua(jsonpath)
	local luapath = jsonpath:sub(1, -5) .. "lua" -- We assume that jsonpath ends in .json

	if not GetFileExists(luapath) then
		return false
	end

	local file, err = io.open(luapath)
	if err ~= nil then
		Print("[ERROR] Could not load configuration file %s: %s", luapath, err)
		if file then file:close() end
		return false, err
	end

	local chunk, err = loadstring(file:read "*a", luapath)
	file:close()
	if err ~= nil then
		Print("[ERROR] Could not load configuration file %s: %s", luapath, err)
		return false, err
	end

	local success, data = xpcall(chunk, errorhandler)
	if success == false then
		return false, data
	end

	return data
end

function LoadConfigFileAbsolute(name, default, check)
	local data, err = loadconfiglua(name)
	if not data then
		data, err = loadconfigjson(name)
	end
	if data ~= nil then
		if default and check then
			local updated
			updated, data = CheckConfig(data, default)

			if updated then
				Print("Configuration file %s was incorrect and has as such been updated!", name)
				local luapath = "config://" .. name:sub(1, -5) .. "lua"
				if GetFileExists(luapath) then
					Print("\tPlease update %s to reflect these changes", luapath)
				end
				SaveConfigFile(name, data)
			end
		end
	elseif default then
		WriteDefaultConfigFile(name, default)
		data = default
	end
	return data, err
end

function LoadConfigFile(name, ...)
	return LoadConfigFileAbsolute("config://" .. name, ...)
end
