--[[
	Shine Override Server Configs extension

	Allows to join any team, used for Gorge Run.
]]


--local StringFormat = string.format
local TableCopy = table.Copy
--local TableEmpty = table.Empty

local Plugin =  Shine.Plugin( ... )
Plugin.Version = "1.1"

function Plugin:GetServerConfigSettings()
	return {
		AutoBalance = Server.GetConfigSetting( "auto_team_balance" ),
		EndOnTeamUnbalance = Server.GetConfigSetting( "end_round_on_team_unbalance" ),
		ForceEvenTeamsOnJoin = Server.GetConfigSetting( "force_even_teams_on_join" )
	}
end

function Plugin:RestoreConfigSettings()
	if not self.OriginalServerConfig then return end
	Server.SetConfigSetting( "auto_team_balance", self.OriginalServerConfig.AutoBalance )
	Server.SetConfigSetting( "end_round_on_team_unbalance", self.OriginalServerConfig.EndOnTeamUnbalance )
	Server.SetConfigSetting( "force_even_teams_on_join", self.OriginalServerConfig.ForceEvenTeamsOnJoin )

	self.OriginalServerConfig = nil
end

function Plugin:Initialise()
	self.OriginalServerConfig = self:GetServerConfigSettings()

	local AutoBalance = TableCopy( self.OriginalServerConfig.AutoBalance )
	AutoBalance.enabled = false

	Server.SetConfigSetting( "auto_team_balance", AutoBalance )
	Server.SetConfigSetting( "end_round_on_team_unbalance", false )
	Server.SetConfigSetting( "force_even_teams_on_join", false )

	return true
end

function Plugin:Cleanup()
	self:RestoreConfigSettings()
end

-- Restore config settings on map change, in case this plugin is disabled on the next map.
function Plugin:MapChange()
	self:RestoreConfigSettings()
end

return Plugin