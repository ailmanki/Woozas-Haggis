-- ======= Copyright (c) 2021, Unknown Worlds Entertainment, Inc. All rights reserved. =============
--
-- lua/menu2/GUIMenuBalanceChangelogButton.lua
--
--    Created by:  Darrell Gentry (darrell@naturalselection2.com)
--
--    Button that opens the balance mod's changelog.
--
-- ========= For more information, visit us at http://www.unknownworlds.com ========================

Script.Load("lua/menu2/GUIMenuExitButton.lua")
Script.Load("lua/menu2/wrappers/Tooltip.lua")
Script.Load("lua/menu2/GUIBalanceChangelog.lua")
Script.Load("lua/menu2/GUIBalanceChangelogData.lua")

local kBalanceChangelogViewedOptionKey = "balance_mod/lastVersionViewed"

---@class GUIMenuBalanceChangelogButton : GUIMenuExitButton
local baseClass = GUIMenuExitButton
baseClass = GetTooltipWrappedClass(baseClass)
class "GUIMenuBalanceChangelogButton" (baseClass)

GUIMenuBalanceChangelogButton.kTextureRegular = PrecacheAsset("ui/newMenu/balance_icon.dds")
GUIMenuBalanceChangelogButton.kTextureHover   = PrecacheAsset("ui/newMenu/balance_icon_hover.dds")

GUIMenuBalanceChangelogButton.kShadowScale = Vector(10, 5, 1)

GUIMenuBalanceChangelogButton:AddClassProperty("WantsAttention", false)

function GUIMenuBalanceChangelogButton:OnPressed()
    self.changelog:Open()
end

function GUIMenuBalanceChangelogButton:Initialize(params, errorDepth)
    errorDepth = (errorDepth or 1) + 1
    baseClass.Initialize(self, params, errorDepth)
    self:SetTooltip("Balance Changelog")

    self:SetGraphicsRotationOffset(Vector(0.67, 1, 0))

    self.changelog = CreateGUIObject("changelog", GUIBalanceChangelog) -- Vanilla creates links before navbar, so we poll for it
    self.changelog:LoadChangelog(gHaggisChangelogData)
    self:HookEvent(self.changelog, "Opened", self.OnChangelogOpened)

    self:HookEvent(GetMainMenu(), "OnClosed", self.OnMainMenuClosed)
    self:HookEvent(self, "OnMouseOverChanged", self.OnMouseOverChanged)
    self:HookEvent(self, "OnAngleChanged", self.OnAngleChanged)
    self:HookEvent(self, "OnWantsAttentionChanged", self.OnWantsAttentionChanged)


end
local function yolo()
        self.callback = self:AddTimedCallback(self.NavBarPollCallback, 0.5, true)
end

if Client then
    Event.Hook("LoadComplete", yolo)
end

function GUIMenuBalanceChangelogButton:OnChangelogOpened()

    Client.SetOptionString(kBalanceChangelogViewedOptionKey, GetMPBVersion())
    self:SetWantsAttention(false)
    self:StopRockingAnimation()

end

local RockingAnimation =
{
    speed = 0.25,
    halfDistance = math.pi/20,

    func = function(obj, time, params, currentValue, startValue, endValue, startTime)
        local radsTraversed = time * params.speed
        local radianOneRange = params.halfDistance
        local range = radianOneRange - (-radianOneRange) -- max - min
        return math.abs(((radsTraversed + range) % (range * 2)) - range) - radianOneRange, false
    end
}

function GUIMenuBalanceChangelogButton:SetGraphicsRotationOffset(rotationOffset)
    self.normalGraphic:SetRotationOffsetNormalized(rotationOffset)
    self.hoverGraphic:SetRotationOffsetNormalized(rotationOffset)
end

function GUIMenuBalanceChangelogButton:OnAngleChanged()
    local angle = self:GetAngle()
    self.normalGraphic:SetAngle(angle)
    self.hoverGraphic:SetAngle(angle)
end

function GUIMenuBalanceChangelogButton:OnMouseOverChanged()

    local isMouseOver = self:GetMouseOver()
    if isMouseOver then
        self:StartRockingAnimation()
    elseif not self:GetWantsAttention() then
        self:StopRockingAnimation()
    end

end

function GUIMenuBalanceChangelogButton:StartRockingAnimation()
    self:AnimateProperty("Angle", 0, RockingAnimation)
end

function GUIMenuBalanceChangelogButton:StopRockingAnimation()
    self:ClearPropertyAnimations("Angle")
    self:SetAngle(0)
end

function GUIMenuBalanceChangelogButton:NavBarPollCallback()
    local navBar = GetNavBar()
    if not navBar then return end

    self.changelog:SetParent(navBar)
    self:MaybeOpenChangelog()

    self:RemoveTimedCallback(self.callback)
    self.callback = nil

end

local function GetIsVersionOlderThanCurrent(oldVersion)
    local lastVersionUnits = string.Explode(oldVersion, "%.")
    local currentVersionUnits = string.Explode(GetMPBVersion(), "%.")
    local maxUnitPos = math.min(#lastVersionUnits, #currentVersionUnits)

    for i = 1, maxUnitPos do
        if tonumber(lastVersionUnits[i]) < tonumber(currentVersionUnits[i]) then
            return true
        end
    end

    return false

end

function GUIMenuBalanceChangelogButton:MaybeOpenChangelog()
    local lastChangelogVerViewed = Client.GetOptionString(kBalanceChangelogViewedOptionKey, "0")
    self:SetWantsAttention(GetIsVersionOlderThanCurrent(lastChangelogVerViewed))
end

function GUIMenuBalanceChangelogButton:OnWantsAttentionChanged()
    if self:GetWantsAttention() then
        self:StartRockingAnimation()
    else
        self:StopRockingAnimation()
    end
end

function GUIMenuBalanceChangelogButton:OnMainMenuClosed()
    self.changelog:Close()
end

if Client then
    Event.Hook("Console_mpb_reset_changelog", function()
        Client.SetOptionString(kBalanceChangelogViewedOptionKey, "0")
    end)
end