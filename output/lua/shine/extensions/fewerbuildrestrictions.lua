local Shine = Shine
local Plugin = {}

Plugin.DefaultState = true
Plugin.NS2Only = false

local function BuildRestrictions(client, state)
	if state == nil then
		Shine:Notify(client, "PM", "BuildRestrictions", tostring(GetBuildRestrictions()))
	else
		SetBuildRestrictions(state)
		Shine:NotifyDualColour(client,
			0, 0, 0,
			"",
			0.9 * 255, 0.2 * 255, 0.2 * 255,
			"Build restrictions have been " .. (state and "enabled again!" or "disabled!")
		)
	end
end

function Plugin:Initialise()
	local command = self:BindCommand("sh_buildrestrictions", "BuildRestrictions", BuildRestrictions)
	command:Help("Set build restrictions state.")
	command:AddParam {
		Type = "boolean",
		Optional = "true",
		Help = "nil: prints current state; false: only resource count restricts; true: like vanilla",
	}
	self.Enabled = true
	return true
end

Shine:RegisterExtension("fewerbuildrestrictions", Plugin)
