Script.Load("lua/ModPanelsPlusPlus/ModPanel.lua")

if Server then
	function InitializeModPanels()
		Log "Creating mod panels"

		local spawnPoints = Server.readyRoomSpawnList
		
		local config = LoadConfigFile("ModPanels.json", {})
		local config_changed  = false

		for index, values in ipairs(kModPanels) do
			local name = values.name

			if config[name] == nil then
				config[name] = true
				config_changed  = true
			end

			if config[name] then
				local spawnPoint = spawnPoints[
				(index - 1) % #spawnPoints + 1
				]
				if spawnPoint ~= nil then
					local spawnPointOrigin = spawnPoint:GetOrigin()
					
					local panel = CreateEntity(
							ModPanel.kMapName,
							spawnPointOrigin
					)
					
					panel:SetModPanelId(index)
					panel:ReInitialize()
					panel:SetOrigin(spawnPointOrigin)
					
					Print("Mod panel '%s' created", panel.name)
				else
					Print("Mod panel '%s' not created, no spawnpoint found", name)
				end
			end
		end

		if config_changed  then
			SaveConfigFile("ModPanels.json", config, true)
		end
	end
end
