-- Only load these changes inside the Server VM
if not Server then return end

Script.Load("lua/Utility.lua")

local function setDecimalPlaces(num, idp)
    local mult = 10^(idp or 0)
    if num >= 0 then return math.floor(num * mult) / mult
    else return math.ceil(num * mult) / mult end
end


-- Give some XP to the damaging entity.
function WeldableMixin:OnWeld(doer, elapsedTime, player)

    if self:GetCanBeWelded(doer) then

        --if self.GetIsBuilt and GetGamerules():GetHasTimelimitPassed() then
        -- Do nothing
        local weldXP = 0
        if self.OnWeldOverride then
            self:OnWeldOverride(doer, elapsedTime)
            weldXP = kPlayerArmorWeldRate * elapsedTime
        elseif doer:isa("MAC") then
            self:AddHealth(MAC.kRepairHealthPerSecond * elapsedTime)
        elseif doer:isa("Welder") then
            weldXP = self:AddHealth(doer:GetRepairRate(self) * elapsedTime)

        end
        local kPlayerArmorWeldXpRate = 0.5
        local maxXp = GetXpValue(self)
        print("Values: " .. "maxXp: " .. maxXp .. " kPlayerArmorWeldXpRate: " .. kPlayerArmorWeldXpRate .. " kHealXpRate: " .. kHealXpRate .. " weldXP: " .. weldXP .. " self:GetMaxHealth(): " .. self:GetMaxHealth())
        if self:isa("Player") then
            weldXP = setDecimalPlaces(maxXp * kPlayerArmorWeldXpRate * kHealXpRate * weldXP / self:GetMaxHealth(), 1)
        else
            weldXP = setDecimalPlaces(maxXp * kHealXpRate * weldXP / self:GetMaxHealth(), 1)
        end

        -- Award XP.
        if weldXP > 0 then
            local doerPlayer = doer:GetParent()
            if doerPlayer and doerPlayer.AddXp then
                doerPlayer:AddXp(weldXP)
            end
        end

        if player and player.OnWeldTarget then
            player:OnWeldTarget(self)
        end

    end

end