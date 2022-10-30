-- ======= Copyright (c) 2021, Unknown Worlds Entertainment, Inc. All rights reserved. =============
--
-- lua/menu2/GUIMenuBalanceChangelogButton.lua
--
--    Created by:  Darrell Gentry (darrell@naturalselection2.com)
--
--    Button that opens the balance mod's changelog.
--
-- ========= For more information, visit us at http://www.unknownworlds.com ========================

--    Button that opens the haggis mod's changelog.
Script.Load("lua/menu2/GUIMenuExitButton.lua")
Script.Load("lua/menu2/wrappers/Tooltip.lua")
Script.Load("lua/haggischangelog/menu2/GUIHaggisChangelog.lua")
Script.Load("lua/haggischangelog/menu2/GUIHaggisChangelogData.lua")

---@class GUIMenuHaggisChangelogButton : GUIMenuExitButton
local baseClass = GUIMenuExitButton
baseClass = GetTooltipWrappedClass(baseClass)
class "GUIMenuHaggisChangelogButton" (baseClass)

GUIMenuHaggisChangelogButton.kTextureRegular = PrecacheAsset("ui/haggisChangelog/haggis_icon.dds")
GUIMenuHaggisChangelogButton.kTextureHover   = PrecacheAsset("ui/haggisChangelog/haggis_icon_hover.dds")
GUIMenuHaggisChangelogButton.kShadowScale = Vector(10, 5, 1)


function GUIMenuHaggisChangelogButton:Initialize(params, errorDepth)
    errorDepth = (errorDepth or 1) + 1
    baseClass.Initialize(self, params, errorDepth)
    self:SetTooltip("The Playground News")


    self.changelog = CreateGUIObject("changelog", GUIHaggisChangelog) -- Vanilla creates links before navbar, so we poll for it
    self.changelog:LoadChangelog(gHaggisChangelogData)

end

function GUIMenuHaggisChangelogButton:OnPressed()
    self.changelog:Open()
end

