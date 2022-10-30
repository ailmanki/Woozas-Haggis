-- ===================== Faded Mod =====================
--
-- lua\FadedArmsLab.lua
--
--    Created by: JB (jeanbaptiste.laurent.pro@gmail.com)
--
--
-- ===================== Faded Mod =====================

Script.Load("lua/libs/LibLocales-1.0/LibLocales.lua")
--local locale = LibCache:GetLibrary("LibLocales-1.0")
--local strformat = string.format

Script.Load("lua/Armory.lua")

local clientArmoryId = nil

function setTraderArmoryId(id)
    clientArmoryId = id
end
function getTraderArmoryId()
    return clientArmoryId
end

local function canUseArmory(self, player)
    return (getTraderArmoryId() == self:GetId() and player and player:GetTeamNumber() == 1)
end

--function Armory:GetItemList()
--
--    local itemList =
--    {
--        kTechId.Rifle,
--        kTechId.Pistol,
--        kTechId.Axe,
--
--        kTechId.Welder,
--        kTechId.LayMines,
--        kTechId.Shotgun,
--        kTechId.ClusterGrenade,
--        kTechId.GasGrenade,
--        kTechId.PulseGrenade
--    }
--
--    if self:GetTechId() == kTechId.AdvancedArmory then
--
--        itemList =
--        {
--            kTechId.Rifle,
--            kTechId.Pistol,
--            kTechId.Axe,
--
--            kTechId.Welder,
--            kTechId.LayMines,
--            kTechId.Shotgun,
--            kTechId.GrenadeLauncher,
--            kTechId.Flamethrower,
--            kTechId.HeavyMachineGun,
--            kTechId.ClusterGrenade,
--            kTechId.GasGrenade,
--            kTechId.PulseGrenade,
--        }
--
--    end
--
--    return itemList
--
--end

-- function Armory:GetItemList(forPlayer)
--    local itemList = {
--       kTechId.Rifle,
--       kTechId.Welder,
--       kTechId.LayMines,
--       kTechId.LayFlameMines,
--       kTechId.GrenadeLauncher,
--       kTechId.Flamethrower,
--       kTechId.HeavyMachineGun,
--       -- kTechId.HealGrenade, -- Armory buy menu is already full on the GUI menu
--       kTechId.ClusterGrenade,
--       kTechId.PulseGrenade,
--       kTechId.GasGrenade,
--       kTechId.NapalmGrenade
--       -- kTechId.MedPack,
--       -- kTechId.Pistol,
--       -- kTechId.Shotgun,
--    }

--    return itemList
--    -- if (Shared.GetMapName() == "ns2_def_troopers") then
--    --    return itemList
--    -- end
--    -- if (canUseArmory(self, forPlayer)) then
--    --    return itemList
--    -- end
--    -- return ({kTechId.Pistol})
-- end
function AdvancedArmory:GetItemList(forPlayer)
    return Armory.GetItemList(self, forPlayer)
end

if (Server) then
    local armoryResupplyPlayer = Armory.ResupplyPlayer
    function Armory:ResupplyPlayer(player)
        if (player:GetHealth() == player:GetMaxHealth()) then
            player:AddHealth(Armory.kHealAmount / 2.5, false, false)
        end
        armoryResupplyPlayer(self, player)


        --   function Armory:ResupplyPlayer(player)

        -- local resuppliedPlayer = false

        -- -- Heal player first
        -- if (player:GetArmor() < player:GetMaxArmor()) then

        --     -- third param true = ignore armor
        --    player:AddHealth(Armory.kHealAmount, false, true)

        --    self:TriggerEffects("armory_health", {effecthostcoords = Coords.GetTranslation(player:GetOrigin())})

        --     resuppliedPlayer = true

        -- if (Shared.GetMapName() == "ns2_def_troopers") then
        --    armoryResupplyPlayer(self, player)
        -- else
        --    if (canUseArmory(self, player)) then
        --       armoryResupplyPlayer(self, player)
        --    end
        -- end
    end
end

local ArmoryGetShouldResupplyPlayer = Armory.GetShouldResupplyPlayer
function Armory:GetShouldResupplyPlayer(player)
    local ret = ArmoryGetShouldResupplyPlayer(self, player)

    if (player and player:GetIsAlive() and not ret) then
        -- Check player facing so players can't fight while getting benefits of armory
        local viewVec = player:GetViewAngles():GetCoords().zAxis
        local toArmoryVec = self:GetOrigin() - player:GetOrigin()

        if (GetNormalizedVector(viewVec):DotProduct(GetNormalizedVector(toArmoryVec)) > .75) then
            if self:GetTimeToResupplyPlayer(player) then
                if (player:GetArmor() < player:GetMaxArmor()) then
                    ret = true -- Ressuply armor aswell
                end
            end
        end
    end
    return ret
end

-- function Armory:GetCanBeUsed(player, useSuccessTable)
--    useSuccessTable.useSuccess = true
-- end

------------------------

-- This make the building bug (can't buy anything no matter what)
-- function Armory:GetRequiresPower()
--    return false
-- end

-- function InfantryPortal:GetRequiresPower()
--    return false
-- end
-- function Observatory:GetRequiresPower()
--    return false
-- end

-- function ArmsLab:GetRequiresPower()
--    return false
-- end
