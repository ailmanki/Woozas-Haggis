-- ======= Copyright (c) 2021, Unknown Worlds Entertainment, Inc. All rights reserved. =============
--
-- lua/menu2/GUIMenuHaggisChangelogButton.lua
--
--    Created by:  Darrell Gentry (darrell@naturalselection2.com)
--
--    Button that opens the haggis mod's changelog.
--
-- ========= For more information, visit us at http://www.unknownworlds.com ========================

Script.Load("lua/menu2/GUIMenuExitButton.lua")
Script.Load("lua/menu2/wrappers/Tooltip.lua")
Script.Load("lua/haggischangelog/menu2/GUIHaggisChangelog.lua")
Script.Load("lua/haggischangelog/menu2/GUIHaggisChangelogData.lua")

local kHaggisChangelogViewedOptionKey = "haggis_mod/lastVersionViewed"
---@class GUIMenuHaggisChangelogButton : GUIMenuExitButton
local baseClass = GUIMenuExitButton
baseClass = GetTooltipWrappedClass(baseClass)
class "GUIMenuHaggisChangelogButton" (baseClass)

GUIMenuHaggisChangelogButton.kTextureRegular = PrecacheAsset("ui/haggisChangelog/haggis_icon.dds")
GUIMenuHaggisChangelogButton.kTextureHover   = PrecacheAsset("ui/haggisChangelog/haggis_icon_hover.dds")

GUIMenuHaggisChangelogButton.kShadowScale = Vector(10, 5, 1)

GUIMenuHaggisChangelogButton:AddClassProperty("WantsAttention", false)

function GUIMenuHaggisChangelogButton:OnPressed()
    self.changelog:Open()
    --local kHaggisChangelogUrl = "https://www.peyote.ch"
    --Client.ShowWebpage( kHaggisChangelogUrl )
end

function GUIMenuHaggisChangelogButton:Initialize(params, errorDepth)
    errorDepth = (errorDepth or 1) + 1
    baseClass.Initialize(self, params, errorDepth)
    self:SetTooltip("The Playground News")

    self:SetGraphicsRotationOffset(Vector(0.67, 1, 0))

    self.changelog = CreateGUIObject("changelog", GUIHaggisChangelog) -- Vanilla creates links before navbar, so we poll for it
    self.changelog:LoadChangelog(gHaggisChangelogData)
    self:HookEvent(self.changelog, "Opened", self.OnChangelogOpened)

    self:HookEvent(GetMainMenu(), "OnClosed", self.OnMainMenuClosed)
    self:HookEvent(self, "OnMouseOverChanged", self.OnMouseOverChanged)
    self:HookEvent(self, "OnAngleChanged", self.OnAngleChanged)
    self:HookEvent(self, "OnWantsAttentionChanged", self.OnWantsAttentionChanged)

    self.callback = self:AddTimedCallback(self.NavBarPollCallback, 0.5, true)

end

function GUIMenuHaggisChangelogButton:OnChangelogOpened()

    Client.SetOptionString(kHaggisChangelogViewedOptionKey, GetHaggisVersion())
    self:SetWantsAttention(false)
    self:StopRockingAnimation()

end

local RockingAnimation =
{
    speed = 0.15,
    halfDistance = math.pi/20,

    func = function(obj, time, params, currentValue, startValue, endValue, startTime)
        local radsTraversed = time * params.speed
        local radianOneRange = params.halfDistance
        local range = radianOneRange - (-radianOneRange) -- max - min
        return math.abs(((radsTraversed + range) % (range * 2)) - range) - radianOneRange, false
    end
}

function GUIMenuHaggisChangelogButton:SetGraphicsRotationOffset(rotationOffset)
    self.normalGraphic:SetRotationOffsetNormalized(rotationOffset)
    self.hoverGraphic:SetRotationOffsetNormalized(rotationOffset)
end

function GUIMenuHaggisChangelogButton:OnAngleChanged()
    local angle = self:GetAngle()
    self.normalGraphic:SetAngle(angle)
    self.hoverGraphic:SetAngle(angle)
end

function GUIMenuHaggisChangelogButton:OnMouseOverChanged()

    local isMouseOver = self:GetMouseOver()
    if isMouseOver then
        self:StartRockingAnimation()
    elseif not self:GetWantsAttention() then
        self:StopRockingAnimation()
    end

end

function GUIMenuHaggisChangelogButton:StartRockingAnimation()
    self:AnimateProperty("Angle", 0, RockingAnimation)
end

function GUIMenuHaggisChangelogButton:StopRockingAnimation()
    self:ClearPropertyAnimations("Angle")
    self:SetAngle(0)
end

function GUIMenuHaggisChangelogButton:NavBarPollCallback()
    local navBar = GetNavBar()
    if not navBar then return end

    self.changelog:SetParent(navBar)
    self:MaybeOpenChangelog()

    self:RemoveTimedCallback(self.callback)
    self.callback = nil

end

local function GetIsVersionOlderThanCurrent(oldVersion)
    local lastVersionUnits = string.Explode(oldVersion, "%.")
    local currentVersionUnits = string.Explode(GetHaggisVersion(), "%.")
    local maxUnitPos = math.min(#lastVersionUnits, #currentVersionUnits)

    for i = 1, maxUnitPos do
        if tonumber(lastVersionUnits[i]) < tonumber(currentVersionUnits[i]) then
            return true
        end
    end

    return false

end

function GUIMenuHaggisChangelogButton:MaybeOpenChangelog()
    local lastChangelogVerViewed = Client.GetOptionString(kHaggisChangelogViewedOptionKey, "0")
    self:SetWantsAttention(GetIsVersionOlderThanCurrent(lastChangelogVerViewed))
end

function GUIMenuHaggisChangelogButton:OnWantsAttentionChanged()
    if self:GetWantsAttention() then
        self:StartRockingAnimation()
    else
        self:StopRockingAnimation()
    end
end

function GUIMenuHaggisChangelogButton:OnMainMenuClosed()
    self.changelog:Close()
end

if Client then
    Event.Hook("Console_haggis_reset_changelog", function()
        Client.SetOptionString(kHaggisChangelogViewedOptionKey, "0")
    end)
end