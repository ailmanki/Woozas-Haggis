local init = false
local force_next = false

wave_nb = 0
squad_nb = 1
local last_squad_created = Shared.GetTime()

local trader_wave = false
-- local trader_delay = 25
local trader_armory = nil
local next_wave_time = 0
trooper_start_grace = 60

local remaining_lifeform = {}
local unspawn_lifeform = {}

local force_next_wave = false


-- Grind settings
local count_per_min = 3.0

local timing_scale = 0.60
skulk_timing =  0 * timing_scale
gorge_timing =  5 * timing_scale
fade_timing  = 13 * timing_scale
lerk_timing  = 16 * timing_scale
onos_timing  = 17 * timing_scale

-- local grind_limit_count = 0 --1 + (FadedRoundTimer_GetRoundTime() * 2 / 60)
-- --

wave_pop = 0
wave_max_pop = 0
defense_hell_wave = false
defense_hell_wave_type = nil
defense_hell_wave_maxdifficulty = false
defense_rain_hell = false
waveFinishedTime = 0

function FadedRoundTimer_GetGameStartTime()
    local entityList = Shared.GetEntitiesWithClassname("GameInfo")
    if (entityList:GetSize() > 0) then
        local gameInfo = entityList:GetEntityAtIndex(0)
        local state = gameInfo:GetState()

        if (state == kGameState.Started) then
            return gameInfo:GetStartTime()
        else
            return -1
        end
    end

    return 0
end

function FadedRoundTimer_GetRoundTime()
    return math.floor(Shared.GetTime() - FadedRoundTimer_GetGameStartTime())
end


function get_grind_limit_count()
    local roundTime = FadedRoundTimer_GetRoundTime()
    local count = 1 + (roundTime * count_per_min / 60)

    if roundTime/60 >= skulk_timing then
        count = count
    elseif roundTime/60 >= lerk_timing then
        count = count - (lerk_timing * count_per_min) / 2
    elseif roundTime/60 >= fade_timing then
        count = count - (fade_timing * count_per_min) / 2
    elseif roundTime/60 >= onos_timing then
        count = count - (onos_timing * count_per_min) / 2
    elseif roundTime/60 >= gorge_timing then
        count = count - (gorge_timing * count_per_min) / 2
    end

    return count
end

function getUnspawnedLifeform(mapName)
    if (unspawn_lifeform[mapName]) then
        return (unspawn_lifeform[mapName])
    end
    return 0
end


function lifeformCounterSet(mapName, nb)
    remaining_lifeform[mapName] = nb
end

function unspawnLifeformCounterSet(mapName, nb)
    unspawn_lifeform[mapName] = nb
end

local function genSquad(minplayer, babblers, skulk, gorge, lerk, fade, onos, bonewall)
    local squad = {minplayer = minplayer[1]}

    if (babblers and babblers > 0)then table.insert(squad, {mapName = Babbler.kMapName, nb = babblers}) end
    if (skulk and skulk > 0) then table.insert(squad, {mapName =    Skulk.kMapName, nb = skulk}) end
    if (gorge and gorge > 0) then table.insert(squad, {mapName =    Gorge.kMapName, nb = gorge}) end
    if (lerk  and lerk  > 0) then table.insert(squad, {mapName =     Lerk.kMapName, nb = lerk})  end
    if (fade  and fade  > 0) then table.insert(squad, {mapName =     Fade.kMapName, nb = fade})  end
    if (onos  and onos  > 0) then table.insert(squad, {mapName =     Onos.kMapName, nb = onos})  end
    -- if (bonewall and bonewall > 0) then table.insert(squad, {mapName = BoneWall.kMapName, nb = bonewall}) end

    return (squad)
end

-- return wave.tunnel_dropper
-- return wave.tunnel_drop_rate

local waveScaleFix = 60/100
local dmgScaleFix = 100/100
local hpScaleFix = 100/100

defense_waves_config =
{
}

function getWaveNb()
    return wave_nb
end

-- function isLastSquadForWave()
--    if (wave_nb and defense_waves_config[wave_nb]
--        and defense_waves_config[wave_nb].squads
--        and wave_nb <= #defense_waves_config) then
--       return squad_nb > #defense_waves_config[wave_nb].squads
--    else
--       return false
--    end
-- end

function isTraderWave()
    return trader_wave
end

function getBotsNumberAlive()
    local nb_bot = 0
    -- , "BoneWall" -- Do not count bonewalls, they are buggy
    for _, ent_name in ipairs({"Alien", "Hallucination"}) do
        for _, entity in ipairs(GetEntitiesForTeam(ent_name, 2)) do
            if (entity and entity:GetIsAlive())-- and (not entity:isa("Alien") or DefIsVirtual(entity)))
            then
                nb_bot = nb_bot + 1
            end
        end
    end
    return nb_bot
end

function forceNextSquad(player, nb_squad)
    force_next = nb_squad and nb_squad or 1
end

hell_lifeforms = {
    -- 0 Babblers, it's better to use CPU for other lifeforms than wasting them on that
    {mapName = Babbler.kMapName , nb = 0},
    {mapName = Skulk.kMapName   , nb = 120*2},
    {mapName = Gorge.kMapName   , nb = 35*2},
    {mapName = Lerk.kMapName    , nb = 50*2},
    {mapName = Fade.kMapName    , nb = 28*2},
    {mapName = Onos.kMapName    , nb = 17*2},
    {mapName = BoneWall.kMapName, nb = 0}--6*0.8}
}
skulk_hell_lifeforms = {
    -- 0 Babblers, it's better to use CPU for other lifeforms than wasting them on that
    {mapName = Babbler.kMapName , nb = 0},
    {mapName = Skulk.kMapName   , nb = 260},
    {mapName = Gorge.kMapName   , nb = 0},
    {mapName = Lerk.kMapName    , nb = 0},
    {mapName = Fade.kMapName    , nb = 0},
    {mapName = Onos.kMapName    , nb = 0},
    {mapName = BoneWall.kMapName, nb = 0}
}
lerk_hell_lifeforms = {
    -- 0 Babblers, it's better to use CPU for other lifeforms than wasting them on that
    {mapName = Babbler.kMapName , nb = 0},
    {mapName = Skulk.kMapName   , nb = 0},
    {mapName = Gorge.kMapName   , nb = 0},
    {mapName = Lerk.kMapName    , nb = 200},
    {mapName = Fade.kMapName    , nb = 0},
    {mapName = Onos.kMapName    , nb = 0},
    {mapName = BoneWall.kMapName, nb = 0}
}
grind_hell_lifeforms = {
    {mapName = Babbler.kMapName , nb = 0},
    {mapName = Skulk.kMapName   , nb = 100*1.8},
    {mapName = Gorge.kMapName   , nb = 35*2},
    {mapName = Lerk.kMapName    , nb = 50*2.6},
    {mapName = Fade.kMapName    , nb = 30*2},
    {mapName = Onos.kMapName    , nb = 20*2.2},
    {mapName = BoneWall.kMapName, nb = 15}--6*5}
}


function getRemainingLifeform(mapName)
    if defense_hell_wave_type == "Grind" then

        local unlocked = false
        local total_aliens = 0
        local lifeform_count = 1
        local roundTime = FadedRoundTimer_GetRoundTime()

        -- if mapName == Skulk.kMapName and roundTime/60 >= skulk_timing then
        --     unlocked = true
        -- elseif mapName == Lerk.kMapName and roundTime/60 >= lerk_timing then
        --     unlocked = true
        -- elseif mapName == Fade.kMapName and roundTime/60 >= fade_timing then
        --     unlocked = true
        -- elseif mapName == Onos.kMapName and roundTime/60 >= onos_timing then
        --     unlocked = true
        -- elseif mapName == Gorge.kMapName and roundTime/60 >= gorge_timing then
        --     unlocked = true
        -- end

        for _, l in ipairs(grind_hell_lifeforms) do
            local unlocked_alien = false
            if l.mapName == Skulk.kMapName and roundTime/60 >= skulk_timing then
                unlocked_alien = true
            elseif l.mapName == Lerk.kMapName and roundTime/60 >= lerk_timing then
                unlocked_alien = true
            elseif l.mapName == Fade.kMapName and roundTime/60 >= fade_timing then
                unlocked_alien = true
            elseif l.mapName == Onos.kMapName and roundTime/60 >= onos_timing then
                unlocked_alien = true
            elseif l.mapName == Gorge.kMapName and roundTime/60 >= gorge_timing then
                unlocked_alien = true
            end
            if unlocked_alien then
                total_aliens = total_aliens + l.nb
                if mapName == l.mapName then
                    lifeform_count = l.nb
                end
            end
        end

        -- Log("%d / %d / %d", get_grind_limit_count() , lifeform_count, total_aliens)
        return math.floor(get_grind_limit_count() * (lifeform_count / total_aliens))

    else
        if (remaining_lifeform[mapName]) then
            return (remaining_lifeform[mapName])
        end
        return 0
    end
end

-- TODO: if on the same pos for 5s, deni current target (lastdamagedealt + pos) (global pos)

local wave_balance_scale = 0.65--0.72
predef_lifeforms = {
    nil,
    nil,
    -- {
    --    {mapName = Babbler.kMapName , nb = 350 * wave_balance_scale},
    --    {mapName = Skulk.kMapName   , nb = 150 * wave_balance_scale},
    --    {mapName = Gorge.kMapName   , nb = 3 * wave_balance_scale},
    --    {mapName = Lerk.kMapName    , nb = 10 * wave_balance_scale},
    --    {mapName = Fade.kMapName    , nb = 2 * wave_balance_scale},
    --    {mapName = Onos.kMapName    , nb = 2 * wave_balance_scale},
    --    {mapName = BoneWall.kMapName, nb = 3 * wave_balance_scale},
    --    hook = true,
    --    alien_scale_bonus = 2,
    -- },
    -- {
    --    {mapName = Babbler.kMapName , nb = 50 * wave_balance_scale},
    --    {mapName = Skulk.kMapName   , nb = 5 * wave_balance_scale},
    --    {mapName = Gorge.kMapName   , nb = 2 * wave_balance_scale},
    --    {mapName = Lerk.kMapName    , nb = 70 * wave_balance_scale},
    --    {mapName = Fade.kMapName    , nb = 1 * wave_balance_scale},
    --    {mapName = Onos.kMapName    , nb = 3 * wave_balance_scale},
    --    {mapName = BoneWall.kMapName, nb = 2 * wave_balance_scale},
    --    hook = true,
    --    alien_scale_bonus = 0.6,
    -- },
}

function forceNextWave()
    squad_nb = 999999
    for _, ent_name in ipairs({"Babbler", "Alien", "BoneWall", "Hallucination", "Clog", "Hydra", "TunnelEntrance"}) do
        for _, entity in ipairs(GetEntitiesForTeam(ent_name, 2)) do
            if (entity and entity:GetIsAlive() and (not entity:isa("Alien") or DefIsVirtual(entity))) then
                entity:Kill()
            end
        end
    end
    -- if (isTraderWave()) then
    next_wave_time = 0--Shared.GetTime()
    -- else
    remaining_lifeform = {}
    unspawn_lifeform = {}
    trader_wave = false
    force_next_wave = true
end

function generateWaves(hell)
    local max_wave_nb = 10-- + math.floor(getScalarPlayers(1, 40, 0, 3))
    local upgrades = {}

    if (isSpecialMap()) then
        upgrades = {false,
                    kTechId.Armor1, kTechId.Weapons1,
                    kTechId.Armor2, kTechId.Weapons2,
                    kTechId.Armor3, kTechId.Weapons3
        }
    end
    defense_waves_config = {}

    for i = 1, max_wave_nb do
        table.insert(defense_waves_config, {})
        if i <= #upgrades and upgrades[i] then
            defense_waves_config[i].upgrades = {upgrades[i]}
        else
            defense_waves_config[i].upgrades = {}
        end

        defense_waves_config[i].hp_scalar = getScalar(1, i, 1, max_wave_nb, 0.4, 1)
        defense_waves_config[i].dmg_scalar = getScalar(1, i, 1, max_wave_nb, 0.5, 1.1)
        defense_waves_config[i].speed_scalar = getScalar(1, i, 1, max_wave_nb, 0.4, 0.9)
        defense_waves_config[i].tunnel_dropper = Clamp((math.random() * 100), 55, 85) / 100
        defense_waves_config[i].tunnel_drop_rate = 0.08
        defense_waves_config[i].alien_scale = getScalar(1, i, 1, max_wave_nb, 0.01, 0.10)
        if (predef_lifeforms[i] and predef_lifeforms[i].hook == true and predef_lifeforms[i].alien_scale_bonus) then
            defense_waves_config[i].alien_scale = defense_waves_config[i].alien_scale * predef_lifeforms[i].alien_scale_bonus
        end

        -- if (predef_lifeforms[i]) then
        --    lifeforms = predef_lifeforms[i]
        -- else
        local lifeforms =
        {
            {mapName = Babbler.kMapName , nb = 0  + getScalar(1, i, 1, max_wave_nb, 0, 0 * wave_balance_scale)},
            {mapName = Skulk.kMapName   , nb = 11 + getScalar(1, i, 1, max_wave_nb, 0, 125 * wave_balance_scale)},
            -- {mapName = Skulk.kMapName   , nb = 100000 + getScalar(1, i, 1, max_wave_nb, 0, 85/2.1)},
            {mapName = Gorge.kMapName   , nb = 3  + getScalar(1, i, 1, max_wave_nb, 0, 25 * wave_balance_scale)},
            {mapName = Lerk.kMapName    , nb = 0  + getScalar(1, i, 1, max_wave_nb, 0, 55 * wave_balance_scale)},
            {mapName = Fade.kMapName    , nb = 0  + getScalar(1, i, 1, max_wave_nb, 0, 12 * wave_balance_scale)},
            {mapName = Onos.kMapName    , nb = 0  + getScalar(1, i, 1, max_wave_nb, 0, 20 * wave_balance_scale)},
            {mapName = BoneWall.kMapName, nb = 1  + getScalar(1, i, 1, max_wave_nb, 0, 3 * wave_balance_scale)}
        }
        -- end

        defense_waves_config[i].squads = {}
        local nb_squad  = 0--5  + getScalar(1, i, max_wave_nb, 1, max_wave_nb)

        -- One squad per lifeform, waves are a lot smoother in pressure
        for j = 1, #lifeforms do
            if (predef_lifeforms[i] and predef_lifeforms[i].hook == true) then
                lifeforms[j].nb = getScalar(1, i, 1, max_wave_nb, 0, predef_lifeforms[i][j].nb)
            end

            if (hell) then
                if (defense_hell_wave_type == "Skulk" or defense_hell_wave_type == "Extra_Skulk") then
                    lifeforms[j].nb = skulk_hell_lifeforms[j].nb
                elseif (defense_hell_wave_type == "Lerk") then
                    lifeforms[j].nb = lerk_hell_lifeforms[j].nb
                elseif (defense_hell_wave_type == "Grind") then
                    lifeforms[j].nb = grind_hell_lifeforms[j].nb
                else
                    lifeforms[j].nb = hell_lifeforms[j].nb
                end

                defense_waves_config[i].hp_scalar = 1.1
                defense_waves_config[i].dmg_scalar = 0.8
                defense_waves_config[i].speed_scalar = 1.2
                defense_waves_config[i].tunnel_dropper = 0.3
                defense_waves_config[i].tunnel_drop_rate = 0.08
                defense_waves_config[i].alien_scale = 666
                -- else
                --    lifeforms[j].nb = math.floor(lifeforms[j].nb * (getScalarPlayers(1, 8, 45, 100) / 100))
            end

            -- No Onos below wave 3
            -- if (lifeforms[j].mapName ~= Onos.kMapName or getWaveNb() >= 3) then
            nb_squad = nb_squad + lifeforms[j].nb --* getScalarPlayers(1, 24, 0.14, 1.05)
            nb_squad = nb_squad
                    - getScalar(1, math.random(), 0, 1, 0, nb_squad / 10)
                    + getScalar(1, math.random(), 0, 1, 0, nb_squad / 5)
            -- end
        end

        local squad = {}
        nb_squad = nb_squad * 4
        for e = 1, nb_squad do
            local do_create_squad = false

            for id = 1, #lifeforms do
                if (squad[id] == nil) then
                    squad[id] = 0
                end
                squad[id] = squad[id] + lifeforms[id].nb / nb_squad
            end

            for id = 1, #lifeforms do
                if (squad[id] > 0) then
                    do_create_squad = true
                    break
                end
            end

            if (i <= 2) then
                squad[1] = 0 -- Babbler
            end
            if (i < 2) then
                squad[3] = 0 -- Gorge
            end
            if (i < 3) then
                squad[4] = 0 -- Lerk
            end
            if (i < 4) then
                squad[5] = 0 -- Fade
            end
            -- No Onos below wave 3
            if (i < 5) then
                squad[6] = 0
            end

            if (do_create_squad) then
                table.insert(defense_waves_config[i].squads,
                        genSquad({0},
                                math.floor(squad[1]),
                                math.floor(squad[2]),
                                math.floor(squad[3]),
                                math.floor(squad[4]),
                                math.floor(squad[5]),
                                math.floor(squad[6]),
                                math.floor(squad[7])
                        ))
                for id = 1, #lifeforms do
                    squad[id] = squad[id] - math.floor(squad[id])
                end
            end
        end

    end

    -- if (hell and wave_nb >= 1) then
    if (hell) then
        -- forceNextWave()
        wave_nb = #defense_waves_config - 1
        squad_nb = 1
    end
    -- end
end

function resetWaves()
    init = true
    defense_hell_wave = false
    defense_hell_wave_type = nil
    defense_rain_hell = false
    force_next = false
    wave_nb = 0
    squad_nb = 1
    trader_wave = 0
    trader_armory = nil
    next_wave_time = 0
    last_squad_created = Shared.GetTime()
    setTraderArmoryId(-1)
    setTraderProtoId(-1)

    sacrified_marine = {} -- Do not keep sacrified marine in between rounds

    generateWaves()

    waveFinishedTime = 0
end

local hive_build_count = 0
local hive_check_delay = Shared.GetTime()
local function _getBuildHiveNb()
    if (hive_check_delay + 1 < Shared.GetTime()) then
        hive_check_delay = Shared.GetTime()

        local nb_hive = 0
        for _, hive in ipairs(GetEntitiesForTeam("Hive", 2)) do
            if (hive.GetIsBuilt and hive:GetIsBuilt()) then
                nb_hive = nb_hive + 1
            end
        end
        hive_build_count = nb_hive
    end
    return hive_build_count
end

local def_nb_spur = 0
local last_spur_check = 0
function getAlienSpeedScalar()
    if (wave_nb == 0) then
        if (last_spur_check + 5 < Shared.GetTime()) then
            last_spur_check = Shared.GetTime()
            def_nb_spur = Clamp(#GetEntities("Spur"), 0, 3)
        end

        return 1.05 + 0.03 * def_nb_spur
    end

    local scalar = 1
    -- local wave_scalar = (1 / #defense_waves_config) * wave_nb
    scalar = getScalarPlayers(1, 20, 0.90, 1.10)

    local nb_hive = _getBuildHiveNb()

    -- if (GetGamerules():GetTeam2():GetNumPlayers() > 0) then
    --    scalar = scalar * 1.15 -- Less possible to put pressure by hand, make it easier
    -- end

    return scalar + scalar * (nb_hive * 0.05)
end

local def_nb_players = 0
local def_nb_shell = 0
local last_shell_check = 0
-- local speed_balance = 0
function getAlienHealthScalar()
    if (true or wave_nb == 0) then
        if (last_shell_check + 5 < Shared.GetTime()) then
            last_shell_check = Shared.GetTime()
            def_nb_shell = Clamp(#GetEntities("Shell"), 0, 3)
            def_nb_players = #GetEntitiesForTeam("Player", 1)
        end
        return (1.10 + 0.05 * def_nb_shell + def_nb_players * 0.01)-- * speed_balance
    end

    -- local scalar = 1
    -- local nb_hive = _getBuildHiveNb()

    -- -- defense_waves_config[wave_nb].hp_scalar
    -- local wave_scalar = (1 / #defense_waves_config) * wave_nb
    -- local min_scalar = 0.6

    -- if (defense_hell_wave) then
    --    min_scalar = 1
    -- end

    -- if (Shared.GetMapName() == "ns2_def_troopers") then
    --    scalar = getScalarPlayers(wave_scalar, 24, min_scalar, 2)
    -- else
    --    scalar = getScalarPlayers(wave_scalar, 24, min_scalar, 1.6)
    -- end

    return scalar + scalar * (nb_hive * 0.10)
end

function getAlienDamageScalar()
    local scalar = 1
    if (true or wave_nb == 0) then
        scalar = getScalarPlayers(1, 6, 0.4, 1)
        return scalar
    end

    local nb_hive = _getBuildHiveNb()

    local min_scalar = 0.10

    if (defense_hell_wave) then
        min_scalar = 0.6
    end

    -- defense_waves_config[wave_nb].dmg_scalar
    local wave_scalar = (1 / #defense_waves_config) * wave_nb
    scalar = getScalarPlayers(wave_scalar, 24, min_scalar, 1.2)
    return scalar + scalar * (nb_hive * 0.08)
end

-- function GetStartVoteAllowed(voteName, client)

--     if not GetStartVoteAllowedForThunderdome(voteName) then
--             return kVoteCannotStartReason.ThunderdomeDisallowed
--         end

--         -- Check that there is no current vote.
--         if activeVoteName then
--             return kVoteCannotStartReason.VoteInProgress
--         end




local lastWaveMsgDisplayed = false
function areAllWavesFinished()
    local wave = defense_waves_config[wave_nb]


    if (wave_nb > #defense_waves_config or
            (wave_nb == #defense_waves_config and squad_nb >= #wave.squads and getBotsNumberAlive() <= 3)) then
        if defense_hell_wave_type == "Grind" then
            triggerGrindHellWave() -- Reset
            return false
        end

        if (GetStartVoteAllowed("") == kVoteCannotStartReason.VoteInProgress) then
            waveFinishedTime = 0 -- Reset countdown to leave time for the vote to complete
            -- Shared:FadedMessage("Vote detected")
        end

        local concedeTime = 20

        if (waveFinishedTime == 0) then
            waveFinishedTime = Shared.GetTime()
            if (not lastWaveMsgDisplayed) then
                Shared:FadedMessage("Last wave defeated: aliens will concede in " .. tostring(concedeTime) .. "s")
                Shared:FadedMessage("(Unless you vote for a hell wave :p)")
                lastWaveMsgDisplayed = true
            end
        end


        if (Shared.GetTime() - waveFinishedTime > concedeTime) then -- 20s buffer before ending the round
            return true
        end
    else
        waveFinishedTime = 0
    end
    return false
end

function getWaveAlienNb()
    return wave_nb
    --  if wave then
    --  end

    -- local total_alien = 0
    -- local nb_players = getNbPlayerAliveForTeam1()
    -- local wave = defense_waves_config[wave_nb]
    -- for _, squad in ipairs(wave.squads) do
    --    if (squad.minplayer <= nb_players) then
    --       for _, alien in ipairs(squad) do
    --          total_alien = total_alien + alien.nb
    --       end
    --    end
    -- end
    -- return total_alien
end

function canAlienFieldComSpawnAlien(self, player, spawn_orig)
    local isPositionValid = true

    isPositionValid = self:GetDropMapName() == Skulk.kMapName or getUnspawnedLifeform(self:GetDropMapName()) > 0
    if (not isPositionValid) then

        for _, bot in ipairs(GetEntitiesForTeam(self:GetDropMapName(), 2)) do
            if (bot and DefIsVirtual(bot) and #GetEntitiesForTeamWithinRange("Player", 1, bot:GetOrigin(), 25) == 0)
            then
                DestroyEntity(bot)
                isPositionValid = true
                break
            end
        end

        if (Server and isPositionValid == false) then
            player:FadedMessage("No more " .. self:GetDropMapName() .. " to spawn")
        end
        return false
    end
    isPositionValid, errmsg = isValidAlienSpawnPointOrig(spawn_orig, true)
    if (not isPositionValid) then
        if (Server) then
            player:FadedMessage(errmsg)
        end
        return false
    end
    -- isPositionValid = wave_pop < wave_max_pop
    -- if (not isPositionValid) then
    --    if (Server) then
    --       player:FadedMessage("Max pop reached (" .. wave_max_pop .. " * " .. (wave_max_pop) .. ")")
    --    end
    --    return false
    -- end
    -- isPositionValid = isServerLoadGood()
    -- if (not isPositionValid) then
    --    if (Server) then
    --       player:FadedMessage("Server too busy (can't spawn more bots)")
    --    end
    --    return false
    -- end
    return true
end


function getMinAlienOnMap(automatic_mod)

    if (wave_nb == 0) then
        return 0
    end

    local function _popMalusScalePerAlienPlayer()
        local pop_malus = 0

        -- Make an alien player count as N bots to balance (quick to implement and good enough atm)
        for _, p in ipairs(GetGamerules():GetTeam2():GetPlayers()) do
            if (p and p:isa("Alien") and p:GetIsAlive() and not DefIsVirtual(p)) then
                if (p:isa("Skulk")) then
                    pop_malus = 1
                elseif (p:isa("Gorge")) then
                    pop_malus = 3
                elseif (p:isa("Lerk")) then
                    pop_malus = 2 -- Lerk bots are probabily more evil/aggressive than players
                elseif (p:isa("Fade")) then
                    pop_malus = 4
                elseif (p:isa("Onos")) then
                    pop_malus = 5
                end
            end
        end

        return pop_malus
    end

    -- if (automatic_mod) then
    --    if (GetGamerules():GetTeam2():GetNumPlayers() > 0) then
    --       return 0 -- Only spawn if 0 alien on map
    --    end
    -- end

    local wave = defense_waves_config[wave_nb]
    local max_aliens = (defense_hell_wave_type == "Extra_Skulk" and 42 or 36) * 1.20-- 200 -- max allowed (limite before server can't handle)

    -- max_aliens = 150

    local nb_players = GetGamerules():GetTeam1():GetNumPlayers()--getNbPlayerAliveForTeam1()
    local min_aliens = 0

    if (wave) then
        min_aliens = math.floor(max_aliens - max_aliens * math.exp(-wave.alien_scale * (nb_players / 0.70)))
    end

    -- if (not defense_hell_wave) then
    --    min_aliens = getScalar(1, squad_nb, 1, #defense_waves_config[wave_nb].squads, 0.5, min_aliens * 1.4)
    -- end

    min_aliens = Clamp(min_aliens - _popMalusScalePerAlienPlayer(), 5, max_aliens) * 1.4
    -- if (Shared.GetMapName() == "ns2_def_troopers") then
    --    min_aliens = min_aliens * 1.4
    -- elseif (Shared.GetMapName() == "ns2_kf_farm") then
    --    min_aliens = min_aliens * 1.1
    -- end

    -- -- Increase game pace if alien control a lot of territory
    -- if (not (Shared.GetMapName() == "ns2_kf_farm" or Shared.GetMapName() == "ns2_def_troopers")) then
    --    min_aliens = min_aliens * getScalar(1, #GetEntities("Harvester"), 0, #GetEntities("ResourcePoint"), 0.7, 2)
    -- end

    min_aliens = math.max(min_aliens, 2) -- Note: TODO: this is a hack, fixme (no bot spawning)

    return min_aliens
end


function refreshPopCounterData()
    -- +5 to give the alien field com a bit of freedom (less restrictive)
    wave_pop = getBotsNumberAlive()
    wave_max_pop = getMinAlienOnMap(false) + 5
    for _, entname in ipairs({"Player", "Spectator"}) do
        for _, marine in ipairs(GetEntities(entname)) do
            if (not DefIsVirtual(marine)) then
                Server.SendNetworkMessage(marine, "LifeformCounterSetPop", {
                    pop = wave_pop,
                    max_pop = wave_max_pop}, true)
            end
        end
    end
end

function refreshAllCounterData(team_specifique)
    refreshPopCounterData()
    for _, entname in ipairs({"Player", "Spectator"}) do
        local ents = nil
        if (team_specifique) then
            ents = GetEntitiesForTeam(entname, team_specifique)
        else
            ents = GetEntities(entname)
        end

        for _, marine in ipairs(ents) do
            if (not DefIsVirtual(marine)) then
                Server.SendNetworkMessage(marine, "LifeformCounterSet", {
                    lifeformMapName = Skulk.kMapName,
                    nb = remaining_lifeform[Skulk.kMapName],
                    unspawn_nb = unspawn_lifeform[Skulk.kMapName]}, true)
                Server.SendNetworkMessage(marine, "LifeformCounterSet", {
                    lifeformMapName = Lerk.kMapName,
                    nb = remaining_lifeform[Lerk.kMapName],
                    unspawn_nb = unspawn_lifeform[Lerk.kMapName]}, true)
                Server.SendNetworkMessage(marine, "LifeformCounterSet", {
                    lifeformMapName = Gorge.kMapName,
                    nb = remaining_lifeform[Gorge.kMapName],
                    unspawn_nb = unspawn_lifeform[Gorge.kMapName]}, true)
                Server.SendNetworkMessage(marine, "LifeformCounterSet", {
                    lifeformMapName = Fade.kMapName,
                    nb = remaining_lifeform[Fade.kMapName],
                    unspawn_nb = unspawn_lifeform[Fade.kMapName]}, true)
                Server.SendNetworkMessage(marine, "LifeformCounterSet", {
                    lifeformMapName = Onos.kMapName,
                    nb = remaining_lifeform[Onos.kMapName],
                    unspawn_nb = unspawn_lifeform[Onos.kMapName]}, true)
            end
        end
    end


    -- Shared:FadedMessage("Skulks: " .. tostring(unspawn_lifeform[Skulk.kMapName]))
    -- Shared:FadedMessage("Gorges: " .. tostring(unspawn_lifeform[Gorge.kMapName]))
    -- Shared:FadedMessage("Lerks : " .. tostring(unspawn_lifeform[Lerk.kMapName]))
    -- Shared:FadedMessage("Fades : " .. tostring(unspawn_lifeform[Fade.kMapName]))
    -- Shared:FadedMessage("Onoses: " .. tostring(unspawn_lifeform[Onos.kMapName]))

end

if (Server) then

    function lifeformSpawned(mapName)
        if (unspawn_lifeform[mapName] and unspawn_lifeform[mapName] > 0) then
            unspawn_lifeform[mapName] = unspawn_lifeform[mapName] - 1
            refreshAllCounterData(2) -- Marines do not need that info updaded
        end
    end

    function lifeformKilled(mapName)
        if (remaining_lifeform[mapName] and remaining_lifeform[mapName] > 0) then
            remaining_lifeform[mapName] = remaining_lifeform[mapName] - 1
            refreshAllCounterData()
        end
    end

    local function PushTarget(player)
        if (Server and player:isa("Player")) then
            -- player:DisableGroundMove(0.1)
            -- player:SetVelocity(Vector(GetSign(math.random() - 0.5) * 2, 3, GetSign(math.random() - 0.5) * 2))
            player:SetVelocity(math.random() * 7 + Vector((math.random() - 0.5) * 2, (math.random() - 0.5) * 2, (math.random() - 0.5) * 2))
        end
    end

    local extrahard_sp = {}
    function ExtraHardSkulkWave_AddSpawnPoint(sp)
        local newLoc = GetLocationAroundFor(sp, kTechId.SentryBattery, 7) or sp

        if newLoc then
            table.insert(extrahard_sp, 1, newLoc)
            if #extrahard_sp > 6 then
                table.remove(extrahard_sp, #extrahard_sp)
            end
        end
    end
    function ExtraHardSkulkWave_GetRandomSpawnPoint()
        return extrahard_sp[math.random(1, #extrahard_sp)]
    end

    local skulkOnKill = Skulk.OnKill
    function Skulk:OnKill(attacker, doer, point, direction)

        local lifespan = Shared.GetTime() - self:GetCreationTime()
        if (defense_hell_wave_type == "Extra_Skulk" and (math.random() < 0.75 or defense_hell_wave_maxdifficulty))
        then

            local nbNearbyRequired = defense_hell_wave_maxdifficulty and 3 or 6
            local numSkulk = #GetEntitiesForTeamWithinRange("Alien", 2, self.infinit_backorigin_s[1], 10)

            if numSkulk >= nbNearbyRequired then

                local ent = nil
                local AllSkulks = GetEntities("Skulk")

                Shared.SortEntitiesByDistance(self.infinit_backorigin_s[1], AllSkulks)

                -- Log("Skulk hidden, close spawn <============")
                local amountTeleported = defense_hell_wave_maxdifficulty and 5 or 3
                local farSkulkOrig = AllSkulks[#AllSkulks]:GetOrigin()

                local nbClose = #GetEntitiesForTeamWithinRange("Alien", 2, self.infinit_backorigin_s[1], 3.2)
                if nbClose >= 5 then

                    if lifespan < 10 and (not defense_hell_wave_maxdifficulty) then
                        amountTeleported = 1
                    end

                    for i = #AllSkulks, math.max(1, #AllSkulks - amountTeleported), -1 do
                        if not AllSkulks[i].def_teleported then
                            AllSkulks[i]:SetOrigin(self.infinit_backorigin_s[1]
                                    + Vector((math.random() - 0.5) / 10,
                                    (math.random() - 0.5) / 10,
                                    (math.random() - 0.5) / 10))
                            AllSkulks[i]:SetAngles(self:GetAngles())
                            AllSkulks[i].def_teleported = Shared.GetTime()
                        end
                        -- Log(" Teleporting Skulk <=========================")
                    end


                    -- ent = CreateEntity(Skulk.kMapName, farSkulkOrig, 2)
                    -- ent = CreateEntity(Skulk.kMapName, self.infinit_backorigin_s[1], 2)
                    -- ent:SetVelocity(Vector(
                    --                     math.random() < 0.5 and 1 or -1,
                    --                     math.random() < 0.80 and 3 or -0.2,
                    --                     math.random() < 0.5 and 1 or -1
                    --                       ) * 10
                    -- )
                else
                    -- Log("Skulk hidden, close spawn")
                    if self.infinit_backorigin[1]:GetDistanceTo(self:GetOrigin()) > 12 then
                        ent = CreateEntity(Skulk.kMapName, self.infinit_backorigin[1], 2)
                        AllSkulks[#AllSkulks]:SetOrigin(self.infinit_backorigin[1]
                                + Vector((math.random() - 0.5) / 10,
                                (math.random() - 0.1) / 10,
                                (math.random() - 0.5) / 10))
                        ExtraHardSkulkWave_AddSpawnPoint(self.infinit_backorigin[1])

                    end
                end

                if ent then
                    Entity.AddTimedCallback(ent, PushTarget, 0)
                    lifeformKilled(Skulk.kMapName)
                end
            end
        else
            lifeformKilled(Skulk.kMapName)
        end

        if (skulkOnKill) then skulkOnKill(self, attacker, doer, point, direction) end


    end
    local gorgeOnKill = Gorge.OnKill
    function Gorge:OnKill()
        if (gorgeOnKill) then gorgeOnKill(self) end
        lifeformKilled(Gorge.kMapName)
    end
    local lerkOnKill = Lerk.OnKill
    function Lerk:OnKill()
        if (lerkOnKill) then lerkOnKill(self) end
        lifeformKilled(Lerk.kMapName)
    end
    local fadeOnKill = Fade.OnKill
    function Fade:OnKill()
        if (fadeOnKill) then fadeOnKill(self) end
        lifeformKilled(Fade.kMapName)
    end
    local onosOnKill = Onos.OnKill
    function Onos:OnKill()
        if (onosOnKill) then onosOnKill(self) end
        lifeformKilled(Onos.kMapName)
    end

    -- local babblerOnKill = Babbler.OnKill
    -- function Babbler:OnKill()
    --    if (babblerOnKill) then
    --       babblerOnKill(self)
    --    end
    --    lifeformKilled(Skulk.kMapName)
    -- end
end

function _isServerLoad(minTickRate, minIdlePer)
    -- local server, no stress checks test
    if (Server and Server.IsDedicated()) then
        local perfData = Shared.GetServerPerformanceData()
        if (perfData) then
            local dMs      = math.floor(perfData:GetDurationMs())
            local tickrate = math.floor(1000 / perfData:GetUpdateIntervalMs())
            local idlePer  = math.floor(100  * perfData:GetTimeSpentIdling() / dMs)

            if (tickrate <= minTickRate or idlePer <= minIdlePer) then
                -- Print("Warning: Server perf are dying, delaying aliens spawn (tickrate: " .. tostring(tickrate) .. " idle: " .. tostring(idlePer) .. "%%)")
                -- Print("Warning: Min tickrate/idle percent allowed: " .. tostring(minTickRate) .. " tick / " .. tostring(minIdlePer) .. "%% idle")
                return false
            end
        end
    end
    return true
end

function getDistToSwitchToHalluOnLoad()
    if (Server and Server.IsDedicated()) then
        local perfData = Shared.GetServerPerformanceData()

        if (perfData) then
            local dMs      = math.floor(perfData:GetDurationMs())
            local tickrate = math.floor(1000 / perfData:GetUpdateIntervalMs())
            local idlePer  = math.floor(100  * perfData:GetTimeSpentIdling() / dMs)

            return Clamp(math.floor(idlePer)*5, 20, 35)
        end

    end
    return 40
end

function isServerLoadLimit()
    return _isServerLoad(15, 0)
end

function isServerLoadMin()
    return _isServerLoad(19, 15)
end

function isServerLoadGood()
    return _isServerLoad(20, 25)
end

function isServerLoadReallyGood()
    return _isServerLoad(20, 65)
end

local function triggerNextSquad()

    if (wave_nb == 0) then
        return -1
    end
    local wave = defense_waves_config[wave_nb]
    local bot_alive = getBotsNumberAlive()
    local min_alien = getMinAlienOnMap(true)

    -- for i = 1, 25 do
    --    local min_alien2 = math.floor(max_aliens - max_aliens * math.exp(-wave.alien_scale * i))
    --    Shared:FadedMessage("Min_alien for " .. tostring(i) .. " : " .. tostring(min_alien2))
    -- end
    -- Shared:FadedMessage("Min_alien for " .. tostring(nb_players) .. " : " .. tostring(min_alien))

    -- See lua/ServerPerformanceData.lua for these (info displayed in console with net_stats)

    if (bot_alive == 0 or bot_alive < min_alien) then
        return 0
    end

    if (defense_hell_wave) then
        if (not isServerLoadMin()) then
            return -1
        end
    else
        if (not isServerLoadGood()) then
            return -1
        end
    end


    -- if ((SharedGetTime() - last_squad_created) > wave.max_delay_between_squad) then
    --    return 0
    -- end
    return -1
end

local function updateGUICounter()
    local wave = defense_waves_config[wave_nb]
    local total_wave = 0
    local progress = 0
    local total_squads = 0
    local current_squad_nb = 0

    local i = 1
    local nb_players = GetGamerules():GetTeam1():GetNumPlayers()
    for _, squad in ipairs(wave.squads) do
        if (squad_nb == i) then
            current_squad_nb = total_squads
        end
        if (nb_players >= squad.minplayer) then
            total_squads = total_squads + 1
        end
        i = i + 1
    end

    progress = (current_squad_nb / total_squads) * 100
    if (trader_wave) then
        progress = 100
    end
    -- for _, marine in ipairs(GetEntities("Player")) do
    --    Server.SendNetworkMessage(marine, "GUIAlienCounter", {
    --                                 progress = progress,
    --                                 wave_nb = wave_nb,
    --                                 wave_total = #defense_waves_config
    --                                                         }, true)
    -- end
end
local function getRandomHive()
    for _, hive in ipairs(GetEntitiesForTeam("Hive", 2)) do
        if (hive.GetIsBuilt and hive:GetIsBuilt()) then
            return hive
        end
    end
    return nil
end
local function getRandomTunnel()
    local _tunnels = GetEntitiesForTeam("TunnelEntrance", 2)
    local tunnels = {}
    local marines = {}

    for _, t in ipairs(_tunnels) do
        -- Do not use tunnel far away from marines
        marines = GetEntitiesForTeamWithinRange("Player", 1, t:GetOrigin(), 40)
        if (t:GetIsAlive()
                and t:GetTunnelEntity() and #marines > 0 and t:GetIsBuilt()
                and t:GetCreationTime() + 10 < Shared.GetTime())
        then
            if (t.def_last_spawn == nil or t.def_last_spawn + 2 < Shared.GetTime()) then
                table.insert(tunnels, t)
            end
        end
    end
    if (#tunnels > 0) then
        return tunnels[math.random(1, #tunnels)]
    end
    return nil
end

function wavesGetTunnelDropperChances() -- Chances to be a gorge capable of dropping tunnel
    local wave = defense_waves_config[wave_nb]

    if (wave) then
        return wave.tunnel_dropper
    end
    return 0
end

function wavesGetTunnelDropChances() -- Chances to spawn a tunnel each sec
    local wave = defense_waves_config[wave_nb]

    if (wave) then
        return wave.tunnel_drop_rate
    end
    return 0
end

local function spawnEntUsingTunnel(tunnel, mapname)

    if (not (tunnel and tunnel:GetIsAlive())) then
        return
    end


    local internal_tunnel = tunnel:GetTunnelEntity()

    l = spawnAlienCreature(mapname, getRandomCystAroundMarine():GetOrigin())

    if (l) then
        if (internal_tunnel:GetExitA()) then
            internal_tunnel:UseExit(l, internal_tunnel:GetExitA(), kTunnelExitSide.A)
        elseif (internal_tunnel:GetExitB()) then
            internal_tunnel:UseExit(l, internal_tunnel:GetExitB(), kTunnelExitSide.B)
        else
            return
        end
        -- function Tunnel:UseExit(entity, exit, exitSide)
    end

    return
end

local function spawnNextSquad()
    if (wave_nb == 0) then
        return 0
    end

    if defense_hell_wave_type == "Grind" then
        if (#GetEntitiesForTeam("Alien", 2) + #GetEntitiesForTeam("Hallucination", 2)) >= get_grind_limit_count() then
            return 0
        end
    end

    for _, marine in ipairs(GetEntities("Player")) do
        if (not DefIsVirtual(marine)) then
            Server.SendNetworkMessage(marine, "GUIAlienCounter", {
                progress = nil,
                wave_nb = wave_nb,
                wave_total = #defense_waves_config,
                hell_type = defense_hell_wave_type or "",
                rain_type = defense_rain_hell
            }, true)
        end
    end

    local wave = defense_waves_config[wave_nb]

    local next_squad = nil
    local nb_players = GetGamerules():GetTeam1():GetNumPlayers()

    if (wave and squad_nb > #wave.squads) then
        defenseToggleMinimap(true)
    end

    while (wave and squad_nb <= #wave.squads) do
        next_squad = wave.squads[squad_nb]
        if (next_squad.minplayer <= nb_players) then
            local static_target = getTargetsStatic()
            local squad_spawn_point = nil

            if (static_target) then
                squad_spawn_point = getRandomCystAroundMarine(static_target:GetOrigin())
            else
                squad_spawn_point = getRandomCystAroundMarine()
            end

            -- Shared:FadedMessage("Squad " .. tostring(squad_nb) .. "/" .. tostring(#wave.squads) .. " spawned")
            -- updateGUICounter()

            local numSpawn = 0
            local numSpawnMax = 0
            for _, alien in ipairs(next_squad) do
                numSpawnMax = numSpawnMax + alien.nb
                for i = 1, alien.nb do
                    local isLifeformUnlocked = false


                    if defense_hell_wave_type == "Grind" then
                        if alien.mapName == Skulk.kMapName and FadedRoundTimer_GetRoundTime()/60 >= skulk_timing then
                            isLifeformUnlocked = true
                        elseif alien.mapName == Lerk.kMapName and FadedRoundTimer_GetRoundTime()/60 >= lerk_timing then
                            isLifeformUnlocked = true
                        elseif alien.mapName == Fade.kMapName and FadedRoundTimer_GetRoundTime()/60 >= fade_timing then
                            isLifeformUnlocked = true
                        elseif alien.mapName == Onos.kMapName and FadedRoundTimer_GetRoundTime()/60 >= onos_timing then
                            isLifeformUnlocked = true
                        elseif alien.mapName == Gorge.kMapName and FadedRoundTimer_GetRoundTime()/60 >= gorge_timing then
                            isLifeformUnlocked = true
                        end
                    else
                        isLifeformUnlocked = true
                    end

                    if not isLifeformUnlocked then
                        alien.mapName = Skulk.kMapName
                        isLifeformUnlocked = true
                    end

                    if (getUnspawnedLifeform(alien.mapName) > 0 and isLifeformUnlocked) then
                        tunnel = getRandomTunnel()
                        if (tunnel and (math.random() < 0.45 or (defense_hell_wave and math.random() < 0.85))) then
                            tunnel.def_last_spawn = Shared.GetTime()
                            spawnEntUsingTunnel(tunnel, alien.mapName)
                        else
                         local hive = getRandomHive
                         spawnAlienCreature(alien.mapName, hive:GetOrigin())
                        end
                        lifeformSpawned(alien.mapName)
                        numSpawn = numSpawn + 1
                    end
                end
            end

            squad_nb = squad_nb + 1
            last_squad_created = Shared.GetTime()
            return 1
        end
        squad_nb = squad_nb + 1 -- Skip squad (only available with more players)
    end
    return 0
end

local last_message = 0
local function triggerNextWave()
    if (wave_nb == 0) then
        return 0
    end

    if (trader_wave == false or (trader_wave == true and next_wave_time < Shared.GetTime())) then
        if (wave_nb <= #defense_waves_config) then
            if (squad_nb > #defense_waves_config[wave_nb].squads) then
                if (wave_nb < #defense_waves_config
                        and (getBotsNumberAlive() <= 3 or last_squad_created + 75 < Shared.GetTime())) then
                    def_last_damages_point = {}
                    return 0
                elseif wave_nb == #defense_waves_config and getBotsNumberAlive() == 0 then
                    if defense_hell_wave_type == "Grind" then
                        triggerGrindHellWave() -- Reset
                    end

                    return 0
                end
            end
        end
    end
    return -1
end

local old_TechTree_GetHasTech = TechTree.GetHasTech
function TechTree:GetHasTech(techId)

    if self:GetTeamNumber() ~= 1 then

        return old_TechTree_GetHasTech(self, techId)

    else

        if techId == kTechId.None then
            return true
        else

            local hasTech = false

            local node = self:GetTechNode(techId)

            if node then
                hasTech = node:GetHasTech()
            end

            return hasTech

        end
    end

    return false

end

local function startNextWave()
    squad_nb = 1
    trader_wave = false
    wave_nb = wave_nb + 1
    defenseToggleMinimap(false)

    if (wave_nb <= #defense_waves_config) then
        local musics =
        {
            "sound/NS2.fev/ambient/ns1_pad_1",
            "sound/NS2.fev/ambient/ns1_pad_2",
            "sound/NS2.fev/ambient/ns1_pad_3"
        }


        local wave = defense_waves_config[wave_nb]
        local nb_players = getNbPlayerAliveForTeam1()

        remaining_lifeform = {}
        unspawn_lifeform = {}
        for _, squad in ipairs(wave.squads) do
            if (squad.minplayer <= nb_players) then
                for _, lifeform in ipairs(squad) do
                    if (remaining_lifeform[lifeform.mapName] == nil) then
                        remaining_lifeform[lifeform.mapName] = 0
                    end
                    if (unspawn_lifeform[lifeform.mapName] == nil) then
                        unspawn_lifeform[lifeform.mapName] = 0
                    end
                    remaining_lifeform[lifeform.mapName] = remaining_lifeform[lifeform.mapName] + lifeform.nb
                    unspawn_lifeform[lifeform.mapName] = unspawn_lifeform[lifeform.mapName] + lifeform.nb
                end
            end
        end

        -- for _, marine in ipairs(GetEntitiesForTeam("Player", 1)) do
        --    Server.SendNetworkMessage(marine, "PlayClientPrivateMusic", { music = "sound/NS2.fev/ambient/descent/docking_background_music", volume = 2 }, true)
        -- end

        if (wave) then
            if (wave.upgrades) then
                local marinetechtree = GetTechTree(kTeam1Index)
                for _, up in ipairs(wave.upgrades) do
                    if (up and not marinetechtree:GetTechNode(up):GetResearched())
                    then -- Unlock if not already on
                        local armslab = GetEntitiesForTeam("ArmsLab", 1)
                        if (#armslab > 0) then
                            marinetechtree:GetTechNode(up):SetResearched(true)
                            marinetechtree:QueueOnResearchComplete(up, armslab[1])
                        end
                    end
                end
            end

            if (wave_nb < #defense_waves_config) then -- No music after the last round
                for _, marine in ipairs(GetEntitiesForTeam("Player", 1)) do
                    marine.def_nb_alien_on_it = 0 -- Reset, just in case

                    -- local music = musics[math.random(1, #musics)]
                    -- Server.SendNetworkMessage(marine, "PlayClientPrivateMusic", { music = music, volume = 2 }, true)
                    if (marine.ClearOrders) then
                        marine:ClearOrders()
                    end
                    Server.SendNetworkMessage(marine, "setTraderBuildingIds", { armory_id = -1, proto_id = -1 }, true)
                end
            end

            setTraderArmoryId(-1)
            setTraderProtoId(-1)

        end
    end

    -- Shared:FadedMessage("Wave n'" .. tostring(wave_nb) .. "/" .. #defense_waves_config
    --                        .. " --> aliens: " .. tostring(getWaveAlienNb()))
end

local function triggerTraderWave()
    if (wave_nb > 0 and triggerNextWave() == 0 and trader_wave == false) then
        return 0
    end
    return -1
end

local function respawnDeadMarines()
    local marine_spawn_points = {}
    for _, alive_p in ipairs(GetEntitiesForTeam("InfantryPortal", 1))
    do
        table.insert(marine_spawn_points, alive_p)
    end
    -- if (#marine_spawn_points == 0) then
    --    for _, alive_p in ipairs(GetEntitiesForTeam("Armory", 1))
    --    do
    --       table.insert(marine_spawn_points, alive_p)
    --    end
    -- end
    if (#marine_spawn_points == 0) then
        for _, alive_p in ipairs(GetEntitiesForTeam("Player", 1))
        do
            table.insert(marine_spawn_points, alive_p)
        end
    end

    if (#marine_spawn_points > 0) then
        local i = math.random(1, #marine_spawn_points)
        for _, player in ipairs(GetEntitiesForTeam("Player", 1))
        do
            local sp = marine_spawn_points[i]:GetOrigin()
            local orig = GetLocationAroundFor(sp, kTechId.Marine, 12)
            if (player and player:GetIsAlive() ~= true) then
                local np = player:Replace(Marine.kMapName, 1, false, orig)
                if (np) then
                    np:SetCameraDistance(0)
                end
            end
        end
    end
end

function skipTraderWave()
    next_wave_time = Shared.GetTime()
end

local function startTraderWave()
    remaining_lifeform = {}
    unspawn_lifeform = {}

    trader_wave = true
    if (Shared.GetMapName() == "ns2_def_troopers") then
        next_wave_time = Shared.GetTime() + 5 + 7 * wave_nb * 1.7 -- trader_delay
    else
        next_wave_time = Shared.GetTime() + 5 + 7 * wave_nb * 1.7 -- trader_delay
    end

    if wave_nb == 6 then
        next_wave_time = next_wave_time + wave_nb * 2
        if wave_nb == 6 then
            next_wave_time = next_wave_time + 10
        end
    end

    if (wave_nb > #defense_waves_config) then
        next_wave_time = Shared.GetTime() + 0 -- Skip trader after end of last wave
    end

    for _, marine in ipairs(GetEntitiesForTeam("Player", 1)) do
        Server.SendNetworkMessage(marine, "PlayClientPrivateMusic", { music = "sound/NS2.fev/ambient/Decaypad", volume = 2 }, true)
    end
    -- respawnDeadMarines()
    -- updateGUICounter()
    local armories = GetEntitiesForTeam("Armory", 1)
    if (#armories > 0) then
        for i = 1, 20 do
            local it = math.random(1, #armories)
            new_armory = armories[it]
            if (new_armory ~= trader_armory) then
                break
            end
        end
        if (new_armory) then
            trader_armory = new_armory
        end
        ------
        local protolabs = GetEntitiesForTeamWithinRange("PrototypeLab", 1, trader_armory:GetOrigin(), 15)
        local proto_id = -1
        if (#protolabs > 0) then
            proto_id = protolabs[1]:GetId()
        end
        -- ------
        -- for _, marine in ipairs(GetEntitiesForTeam("Player", 1)) do
        --    if (marine.GiveOrder) then
        --       marine:GiveOrder(kTechId.Move, trader_armory:GetId(), nil)
        --    end
        --    Server.SendNetworkMessage(marine, "setTraderBuildingIds", { armory_id = trader_armory:GetId(), proto_id = proto_id }, true)
        -- end


        setTraderArmoryId(trader_armory:GetId())
        setTraderProtoId(proto_id)
    end
    -- Shared:FadedMessage("Next wave in " .. tostring(trader_delay) .. "s")
end

local freezeBots = false
function toggleBotSpawn(player)
    freezeBots = not freezeBots
    if (freezeBots) then
        for _, a in ipairs(GetEntities("Alien")) do
            a:Kill()
        end
    end
    -- player:FadedMessage("Toggling bots : " .. tostring(freezeBots))
end



local wave_check_delay = 0
function handleWaves()

    -- Log("Order count: %d entities", #GetEntities("Order"))

    if (init == false) then
        resetWaves()
    end

    if (not GetGamerules():GetGameStarted() or freezeBots) then
        return true
    end

    -- for _, skulk_player in ipairs(GetEntitiesForTeam("Alien", 2)) do
    --    if (skulk_player and skulk_player.client) then
    --       changeToAlienFieldCom(skulk_player)
    --    end
    -- end


    if Shared.GetMapName() == "ns2_def_troopers" and FadedRoundTimer_GetRoundTime() < trooper_start_grace then
        return true
    end

    -- if (Shared.GetMapName() ~= "ns2_def_troopers") then -- too heavy on perf
    --    randomBonusDrop()
    -- end

    -- wave_check_delay = wave_check_delay + timePassed
    -- if (wave_check_delay >= 1) then
    --    wave_check_delay = 0

    if (force_next) then
        for i = 1, math.min(30, force_next) do
            spawnNextSquad()
        end
        force_next = false
    else
        if (force_next_wave or triggerTraderWave() == 0) then
            startTraderWave()
        end
        if (force_next_wave or triggerNextWave() == 0) then
            startNextWave()
            force_next_wave = false
        else
            local i = 0

            --
            local max_babblers = 0
            local num_babblers = #GetEntities("Babbler")
            if defense_rain_hell then
                local marines = GetEntitiesForTeam("Player", 1)
                for i = 0, 3, 1 do -- Bomb 3 marines randomly
                    local aliens = GetEntitiesForTeam("Gorge", 2)
                    local m = marines and marines[math.random(1, #marines)]
                    local a = aliens and aliens[math.random(1, #aliens)]

                    if not a then
                        a = CreateEntity(Gorge.kMapName,
                                m:GetOrigin() + Vector(math.random()*15-7, 40, math.random()*15-7),
                                2)
                    end

                    if m and a then
                        if math.random() < 0.4 then
                            a:CreatePredictedProjectile( "Bomb",
                                    m:GetOrigin() + Vector(math.random()*15-7, 20, math.random()*15-7),
                                    Vector(0, -3, 0), 0, 0, nil )
                        end

                        -- a:CreatePredictedProjectile( "Bomb",
                        --                              m:GetOrigin() + Vector(math.random()*15-7, 25, math.random()*15-7),
                        --                              Vector(0, -1, 0), 0, 0, nil )
                        -- a:CreatePredictedProjectile( "Bomb",
                        --                              m:GetOrigin() + Vector(math.random()*15-7, 30, math.random()*15-7),
                        --                              Vector(0, -4, 0), 0, 0, nil )

                        if i == 0 and isServerLoadMin() and getBotsNumberAlive() < 45 then
                            CreateEntity(math.random() < 0.7 and Skulk.kMapName or Lerk.kMapName, m:GetOrigin()
                                    + Vector(math.random()*15-7, 35, math.random()*15-7), 2)
                        end

                        -- for i = 0, 5, 1 do
                        for j = 0, 1, 1 do
                            if (math.random() > num_babblers / max_babblers) then -- The more babb, the less we spawn them
                                local b = CreateEntity(Babbler.kMapName,
                                        (m:GetOrigin()
                                                + Vector(math.random()*20-10, 35, math.random()*20-10)),
                                        2)

                                if b then
                                    b:SetMoveType(kBabblerMoveType.Attack, m, m:GetOrigin())
                                end
                            end

                        end
                        -- end
                    end
                end
            end

            --

            while (i < 5 and (triggerNextSquad() == 0)) do
                spawnNextSquad()
                spawnNextSquad()
                spawnNextSquad()
                spawnNextSquad()
                if defense_hell_wave then
                    spawnNextSquad()
                    spawnNextSquad()
                    spawnNextSquad()
                    spawnNextSquad()
                    spawnNextSquad()
                    spawnNextSquad()
                end
                if (spawnNextSquad() ~= 1) then
                    break
                end
                i = i + 1
            end
        end
    end
    -- end
    refreshAllCounterData()
    return true
end
