-- Set of known compatible/incompatible plugins for your gamemode (any not in this table will use their default behaviour).
local CompatiblePlugins = {
	votesurrender = true,
	pregame = true,
	voterandom = true
}
Shine.Hook.Add( "CanPluginLoad", "MyGamemodeCheck", function( Plugin, GamemodeName )
	return CompatiblePlugins[ Plugin:GetName() ]
end )