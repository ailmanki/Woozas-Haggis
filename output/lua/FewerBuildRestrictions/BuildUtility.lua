Script.Load "lua/TechTreeConstants.lua"

local buildRestrictions = true
local RestrictedBuilds = table.array(#kTechId)
for _, v in ipairs {
	"PhaseGate",
	"Veil",
	"Spur",
	"Shell",
	"ArmsLab",
	"RoboticsFactory",
	"InfantryPortal",
	"Observatory",
	"Cyst",
	"Egg",
	"TeleportTunnel",
	"Hive",
} do
	RestrictedBuilds[kTechId[v]] = true

	if rawget(kTechId, "Teleport" .. v) then
		RestrictedBuilds[kTechId["Teleport" .. v]] = true
	end
end

Shared.RegisterNetworkMessage("BuildRestrictions", {
	state = "boolean"
})

if Client then
	Client.HookNetworkMessage("BuildRestrictions", function(msg)
		buildRestrictions = msg.state
	end)
elseif Server then
	function SetBuildRestrictions(state)
		buildRestrictions = state
		Server.SendNetworkMessage("BuildRestrictions", {state = state}, true)
	end

	function GetBuildRestrictions()
		return buildRestrictions
	end

	Event.Hook("ClientConnect", function(client)
		Server.SendNetworkMessage(client, "BuildRestrictions", {state = buildRestrictions}, true)
	end)
end

local function CheckBuildTechAvailable(techId, teamNumber)

	local techTree = GetTechTree(teamNumber)
	local techNode = techTree:GetTechNode(techId)
	assert(techNode)
	return techNode:GetAvailable()

end

local function GetPathingRequirementsMet(position, extents)
	return not Pathing.GetIsFlagSet(position, extents, Pathing.PolyFlag_NoBuild) and Pathing.GetIsFlagSet(position, extents, Pathing.PolyFlag_Walk)
end

local function GetBuildAttachRequirementsMet(techId, position, teamNumber, snapRadius, normal)

	local legalBuild = true
    local attachEntity

	local legalPosition = Vector(position)

	-- Make sure we're within range of something that's required (ie, an infantry portal near a command station)
	local attachRange = LookupTechData(techId, kStructureAttachRange, 0)

	-- Use a special power-aware filter if power is required
	local attachRequiresPower = LookupTechData(techId, kStructureAttachRequiresPower, false)
	local filterFunction = GetEntitiesForTeamWithinRange
	if attachRequiresPower then
		filterFunction = FindPoweredAttachEntities
	end

	local buildNearClass = LookupTechData(techId, kStructureBuildNearClass)
	if buildNearClass then

		local ents = {}

		-- Handle table of class names
		if type(buildNearClass) == "table" then
            for _, className in ipairs(buildNearClass) do
				table.copy(filterFunction(className, teamNumber, position, attachRange), ents, true)
			end
		else
			ents = filterFunction(buildNearClass, teamNumber, position, attachRange)
		end

        legalBuild = (table.icount(ents) > 0)

	end

	local attachId = LookupTechData(techId, kStructureAttachId)
	-- prevent creation if this techId requires another techId in range
	if attachId then

		local supportingTechIds = {}

		if type(attachId) == "table" then
            for _, currentAttachId in ipairs(attachId) do
				table.insert(supportingTechIds, currentAttachId)
			end
		else
			table.insert(supportingTechIds, attachId)
		end

		local ents = GetEntsWithTechIdIsActive(supportingTechIds, attachRange, position)
        legalBuild = (table.icount(ents) > 0)

	end


	-- For build tech that must be attached, find free attachment nearby. Snap position to it.
	local attachClass = LookupTechData(techId, kStructureAttachClass)
	if legalBuild and attachClass then

		-- If attach range specified, then we must be within that range of this entity
		-- If not specified, but attach class specified, we attach to entity of that type
		-- so one must be very close by (.5)

		legalBuild = LookupTechData(techId, kTechDataAttachOptional, false)

		attachEntity = GetNearestFreeAttachEntity(techId, position, snapRadius)
		if attachEntity then

			if not attachRequiresPower or (attachEntity:GetIsBuilt() and attachEntity:GetIsPowered()) then

				legalBuild = true

				VectorCopy(attachEntity:GetOrigin(), legalPosition)
				normal = attachEntity:GetCoords().yAxis

			end

		end

	end

	return legalBuild, legalPosition, attachEntity, normal

end


local function GetTeamNumber(player, ignoreEntity)

	local teamNumber = -1

	if player then
		teamNumber = player:GetTeamNumber()
	elseif ignoreEntity then
		teamNumber = ignoreEntity:GetTeamNumber()
	end

	return teamNumber

end

local function CheckValidIPPlacement(position, extents)

	local trace = Shared.TraceBox(extents, position - Vector(0, 0.3, 0), position - Vector(0, 3, 0), CollisionRep.Default, PhysicsMask.AllButPCs, EntityFilterAll())
	local valid = true
	if trace.fraction == 1 then
		local traceStart = position + Vector(0, 0.3, 0)
		local traceSurface = Shared.TraceRay(traceStart, traceStart - Vector(0, 0.4, 0), CollisionRep.Default, PhysicsMask.AllButPCs, EntityFilterAll())
		valid = traceSurface.surface ~= "no_ip"
	end

	return valid

end

local function GetIsTunnelTech(techId)
    return techId >= kTechId.BuildTunnelEntryOne and techId <= kTechId.BuildTunnelExitFour or techId == kTechId.Tunnel or techId == kTechId.TunnelExit or techId == kTechId.TunnelRelocate
end

local function GetGroundAtPointWithCapsule(position, extents, filter)
	local physicsGroupMask = PhysicsMask.CommanderBuild
	local kCapsuleSize = 0.1

	local topOffset = extents.y + kCapsuleSize
	local startPosition = position + Vector(0, topOffset, 0)
	local endPosition = position - Vector(0, 1000, 0)

	local trace
	if filter == nil then
		trace = Shared.TraceCapsule(startPosition, endPosition, kCapsuleSize, 0, CollisionRep.Move, physicsGroupMask)
	else
		trace = Shared.TraceCapsule(startPosition, endPosition, kCapsuleSize, 0, CollisionRep.Move, physicsGroupMask, filter)
	end

   -- If we didn't hit anything, then use our existing position. This
   -- prevents objects from constantly moving downward if they get outside
   -- of the bounds of the map.
	if trace.fraction ~= 1 then
		return trace.endPoint - Vector(0, 2 * kCapsuleSize, 0), trace.normal
	else
		return position, trace.normal
	end
end

local function GetIsStructureExitValid(origin, direction, range)

	local capsuleRadius = 0.5
	local capsuleHeight = 0.5

	local groundOffset = Vector(0, 0.1 + capsuleHeight/2 + capsuleRadius, 0)
	local startPoint = origin + groundOffset
	local endPoint = startPoint + direction * range
	local trace = Shared.TraceCapsule(startPoint, endPoint, capsuleRadius, capsuleHeight, CollisionRep.Move, PhysicsMask.AIMovement, nil)

	return trace.fraction == 1

end

local function CheckValidExit(techId, position, angle)
end

local function CheckBuildEntityRequirements(techId, position, player, ignoreEntity)

    local legalBuild = true
    local errorString = ""
    
	local techTree
	if Client then
		techTree = GetTechTree()
	else
		techTree = player:GetTechTree()
	end

	local techNode = techTree:GetTechNode(techId)
	local attachClass = LookupTechData(techId, kStructureAttachClass)

	-- Build tech can't be built on top of non-attachment entities.
	if techNode and techNode:GetIsBuild() then

		local trace = Shared.TraceBox(GetExtents(techId), position + Vector(0, 1, 0), position - Vector(0, 3, 0), CollisionRep.Default, PhysicsMask.AllButPCs, EntityFilterOne(ignoreEntity))

        -- $AS - We special case Drop Packs you should not be able to build on top of them.
        if trace.entity and HasMixin(trace.entity, "Pathing") then
            legalBuild = false
        end
        
		-- Now make sure we're not building on top of something that is used for another purpose (ie, armory blocking use of tech point)
		if trace.entity then

			local hitClassName = trace.entity:GetClassName()
			if GetIsAttachment(hitClassName) and (hitClassName ~= attachClass) then
                legalBuild = false
			end

		end

		if not legalBuild then
            errorString = "COMMANDERERROR_CANT_BUILD_ON_TOP"
		end

	end

	return true, ""
end

local function CheckClearForStacking(position, extents, attachEntity, ignoreEntity)
	local filter = CreateFilter(ignoreEntity, attachEntity)
	local trace = Shared.TraceBox(extents, position + Vector(0, 1.5, 0), position - Vector(0, 3, 0), CollisionRep.Default, PhysicsMask.CommanderStack, filter)
	return trace.entity == nil
end

--
--Returns true or false if build attachments are fulfilled, as well as possible attach entity
--to be hooked up to. If snap radius passed, then snap build origin to it when nearby. Otherwise
--use only a small tolerance to see if entity is close enough to an attach class.
--
function GetIsBuildLegal(techId, position, angle, snapRadius, player, ignoreEntity, ignoreChecks)
	local legalBuild     = true
	local extents        = GetExtents(techId)
	local ignoreEntities = LookupTechData(techId, kTechDataCollideWithWorldOnly, false)
	local ignorePathing  = LookupTechData(techId, kTechDataIgnorePathingMesh,    false)

	local attachEntity = nil
	local errorString  = nil

	local filter = CreateFilter(ignoreEntity)

	-- Snap to ground
	local legalPosition, normal = GetGroundAtPointWithCapsule(position, extents, filter)

	-- Check attach points
	local teamNumber = GetTeamNumber(player, ignoreEntity)
	if buildRestrictions then
		legalBuild, legalPosition, attachEntity, normal = GetBuildAttachRequirementsMet(techId, legalPosition, teamNumber, snapRadius, normal)
	end

	errorString = "COMMANDERERROR_OUT_OF_RANGE"

	-- Disabled since it does not work accurately, since extents are not good
	--if legalBuild and buildRestrictions and not attachEntity and GetTechTree(teamNumber):GetTechNode(techId):GetIsBuild() then
	--	local filter = ignoreEntities and EntityFilterAll() or EntityFilterOne(ignoreEntity)
	--	--legalBuild = not Shared.CollideBox(extents, legalPosition + Vector(0, extents.y + .05, 0), CollisionRep.LOS, PhysicsMask.CommanderStack, filter)
	--	legalBuild	 = not (
	--		Shared.TraceRay(legalPosition, legalPosition + extents.y + extents.y, CollisionRep.Default, PhysicsMask.CommanderStack, filter).fraction ~= 1
	--	)
	--	errorString  = "COMMANDERERROR_INVALID_PLACEMENT"
	--end

	if legalBuild and buildRestrictions then
		local spawnBlock = LookupTechData(techId, kTechDataSpawnBlock, false)
		if spawnBlock then
			legalBuild = #GetEntitiesForTeamWithinRange("SpawnBlocker", player:GetTeamNumber(), position, kSpawnBlockRange) == 0
		end
		errorString = "COMMANDERERROR_MUST_WAIT"
	end

	if legalBuild then
		legalBuild  = CheckBuildTechAvailable(techId, teamNumber)
		errorString = "COMMANDERERROR_TECH_NOT_AVAILABLE"
	end

	if legalBuild and buildRestrictions and not attachEntity and not ignorePathing and (RestrictedBuilds == true or RestrictedBuilds[techId]) then
		legalBuild  = GetPathingRequirementsMet(legalPosition, extents)
		errorString = "COMMANDERERROR_INVALID_PLACEMENT"
	end

	if legalBuild then
		legalBuild  = GetInfestationRequirementsMet(techId, legalPosition)
		errorString = "COMMANDERERROR_INFESTATION_REQUIRED"
	end

	if legalBuild then
		legalBuild  = not (LookupTechData(techId, kTechDataNotOnInfestation, false) and GetIsPointOnInfestation(legalPosition))
		errorString = "COMMANDERERROR_NOT_ALLOWED_ON_INFESTATION"
	end

	-- Check special build requirements. We do it here because we have the trace from the building available to find out the normal
	if legalBuild and buildRestrictions then
		local method = LookupTechData(techId, kTechDataBuildRequiresMethod, nil)
		if method then
			legalBuild  = method(techId, legalPosition, normal, player)
			errorString = LookupTechData(techId, kTechDataBuildMethodFailedMessage, "COMMANDERERROR_BUILD_FAILED")
		end
	end

	if legalBuild and not (ignoreChecks and ignoreChecks.ValidExit) and techId == kTechId.RoboticsFactory then
		local directionVec = GetNormalizedVector(Vector(math.sin(angle), 0, math.cos(angle)))

		legalBuild  = GetIsStructureExitValid(position, directionVec, 5)
		errorString = "COMMANDERERROR_NO_EXIT"
	end

	if legalBuild and techId == kTechId.InfantryPortal and buildRestrictions then
		legalBuild  = CheckValidIPPlacement(legalPosition, extents)
		errorString = "COMMANDERERROR_INVALID_PLACEMENTS"
	end

	if legalBuild and GetIsTunnelTech(techId) then
		-- Sanity check to ensure user cannot click down several tunnels really fast -- between
		-- tech tree updates...
		if techId ~= kTechId.TunnelRelocate then
		    local teamInfo = GetTeamInfoEntity(teamNumber)

		    local hiveCount = teamInfo:GetNumCapturedTechPoints()
		    local tunnelCount = Tunnel.GetLivingTunnelCount(teamNumber)
		    if tunnelCount >= hiveCount then
                legalBuild = false
                errorString = "TUNNEL_LIMIT_ONE_PER_HIVE_CAPS"
		    end
		end

		-- confirm that the entrance is not placed too close to an obstacle
		if legalBuild then
		    local capsuleRadius = math.max(extents.x, extents.z)
		    local capsuleHeight = extents.y
		    local groundOffset = 0.3
		    local center = Vector(0, capsuleHeight * 0.5 + capsuleRadius + groundOffset, 0)
		    local spawnPointCenter = position + center
		    local notValid = Shared.CollideCapsule(spawnPointCenter, capsuleRadius, capsuleHeight, CollisionRep.Default, PhysicsMask.AllButPCs, nil)

		    if notValid then
                legalBuild = false
                errorString = "COMMANDERERROR_INVALID_PLACEMENT"
		    end
		end
	end

	return legalBuild, legalPosition, attachEntity, not legalBuild and errorString or nil, normal
end
