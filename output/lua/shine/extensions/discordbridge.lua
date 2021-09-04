--[[
	Shine discord bridge plugin
]]

local Message = Shared.Message -- Overridden by Shine later for some dumb reason

local Shine = Shine
local Plugin = {}

Plugin.Version			= "4.0.0"
Plugin.HasConfig		= true
Plugin.ConfigName		= "DiscordBridge.json"
Plugin.DefaultState		= true
Plugin.NS2Only			= false
Plugin.CheckConfig		= true
Plugin.CheckConfigTypes = true
Plugin.DefaultConfig	= {
	SendPlayerAllChat = true,
	SendPlayerJoin	  = true,
	SendPlayerLeave   = true,
	SendAdminPrint	  = false,
}

local fieldSep = ""

function Plugin:Initialise()
	if self.Config.SendAdminPrint then
		self:SimpleTimer(0.5, function()
			local old = ServerAdminPrint
			function ServerAdminPrint(client, message)
				old(client, message)
				if self.Enabled then
					self:SendToDiscord("adminprint", message)
				end
			end
		end)
	end

	local old = Server.StartWorld
	function Server.StartWorld(mods, mapname)
		if self.Enabled then
			local numPlayers  = Server.GetNumPlayersTotal()
			local maxPlayers  = Server.GetMaxPlayers()
			local playerCount = numPlayers .. "/" .. maxPlayers
			self:SendToDiscord("changemap", mapname, playerCount)
		end
		old(mods, mapname)
	end

	local old = function() end

	Event.Hook("WebRequest", function(actions)
		if	   actions.request == "discordsend" then
			Shine:NotifyDualColour(nil, 114, 137, 218, "(Discord) " .. actions.user .. ":", 181, 172, 229, actions.msg)
		elseif actions.request == "discordinfo" then
			return "application/json", Plugin:HandleDiscordInfoMessage()
		elseif actions.rcon then
			Shared.ConsoleCommand(actions.rcon)
		else
			return old(actions)
		end
	end)

	local old_Hook = Event.Hook
	function Event.Hook(t, f, ...)
		if t == "WebRequest" then
			old = f
		else
			return old_Hook(t, f, ...)
		end
	end

	self.lastGameStateChangeTime = Shared.GetTime()

	self.Enabled = true
	return self.Enabled
end

function Server.GetActiveModTitle(activeModNum)
	local activeId = Server.GetActiveModId( activeModNum )
	for modNum = 1, Server.GetNumMods() do
		local modId = Server.GetModId( modNum )
		if modId == activeId then
			return Server.GetModTitle( modNum )
		end
	end
	return "<unknown mod>"
end

local function CollectActiveMods()
	local modIds = {}
	for modNum = 1, Server.GetNumActiveMods() do
		table.insert(modIds, {
			id = Server.GetActiveModId( modNum ),
			name = Server.GetActiveModTitle( modNum ),
		})
	end
	return modIds
end

function Plugin:HandleDiscordInfoMessage()
	local gameTime = Shared.GetTime() - self.lastGameStateChangeTime

	local teams = {}
	for _, team in ipairs( GetGamerules():GetTeams() ) do
		local numPlayers, numRookies = team:GetNumPlayers()
		local teamNumber = team:GetTeamNumber()

		local playerList = {}
		local function addToPlayerlist(player)
			table.insert(playerList, player:GetName())
		end
		team:ForEachPlayer(addToPlayerlist)

		teams[teamNumber] = {numPlayers=numPlayers, numRookies=numRookies, players = playerList}
	end

	local message = {
		serverIp	   = IPAddressToString( Server.GetIpAddress() ),
		serverPort	   = Server.GetPort(),
		serverName	   = Server.GetName(),
		version		   = Shared.GetBuildNumber(),
		mods		   = CollectActiveMods(),
		map			   = Shared.GetMapName(),
		state		   = kGameState[GetGameInfoEntity():GetState()],
		gameTime	   = tonumber( string.format( "%.2f", gameTime ) ),
		numPlayers	   = Server.GetNumPlayersTotal(),
		maxPlayers	   = Server.GetMaxPlayers(),
		numRookies	   = teams[kTeamReadyRoom].numRookies + teams[kTeam1Index].numRookies + teams[kTeam2Index].numRookies + teams[kSpectatorIndex].numRookies,
		teams = teams,
	}

	return json.encode(message)
end

Plugin.ResponseHandlers = {
	chat = Plugin.HandleDiscordChatMessage,
	info = Plugin.HandleDiscordInfoMessage,
}

function Plugin:SendToDiscord(type, ...)
	local message = "--DISCORD--|" .. type
	for i = 1, select('#', ...) do
		message = message .. fieldSep .. select(i, ...)
	end

	Message(message)
end

function Plugin:PlayerSay(client, message)
	if not message.teamOnly and self.Config.SendPlayerAllChat and message.message ~= "" then
		local player = client:GetControllingPlayer()
		self:SendToDiscord("chat",
			player:GetName(),
			player:GetSteamId(),
			player:GetTeamNumber(),
			message.message
		)
	end
end


function Plugin:ClientConfirmConnect(client)
	if self.Config.SendPlayerJoin and Shared.GetTime() > 60 then -- don't show when players join within 60 seconds of map change
		local player = client:GetControllingPlayer()
		local numPlayers = Server.GetNumPlayersTotal()
		local maxPlayers = Server.GetMaxPlayers()
		self:SendToDiscord("player", "join", player:GetName(), player:GetSteamId(), numPlayers .. "/" .. maxPlayers)
	end
end


function Plugin:ClientDisconnect(client)
	if self.Config.SendPlayerLeave then
		local player = client:GetControllingPlayer()
		if player ~= nil then
			local numPlayers = math.max(Server.GetNumPlayersTotal() -1, 0)
			local maxPlayers = Server.GetMaxPlayers()
			self:SendToDiscord("player", "leave", player:GetName(), player:GetSteamId(), numPlayers .. "/" .. maxPlayers)
		end
	end
end

local function UpdateGameState()
	local CurState = kGameState[GetGamerules():GetGameState()]
	local numPlayers = Server.GetNumPlayersTotal()
	local maxPlayers = Server.GetMaxPlayers()
	local roundTime = Shared.GetTime()
	local playerCount = numPlayers .. "/" .. maxPlayers

	Plugin:SendToDiscord("status", CurState, Shared.GetMapName(), playerCount)
	Plugin.gamestate_timer = nil
end


function Plugin:SetGameState(_, CurState)
	self.lastGameStateChangeTime = Shared.GetTime()

	local timer = self.gamestate_timer
	if not timer then
		self.gamestate_timer = self:SimpleTimer(1, UpdateGameState)
	end
end

function Plugin:MapPostLoad()
	self:SendToDiscord("init", Shared.GetMapName())
end

Shine:RegisterExtension("discordbridge", Plugin)
