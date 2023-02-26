-- ======= Copyright (c) 2021, Unknown Worlds Entertainment, Inc. All rights reserved. =======
--
-- lua/menu2/GUIBalanceChangelog.lua
--
--    Created by:   Darrell Gentry (darrell@naturalselection2.com)
--
--    Simple window that displays the changelog for the balance mod
--
-- ========= For more information, visit us at http://www.unknownworlds.com =====================

Script.Load("lua/GUI/GUIObject.lua")
Script.Load("lua/menu2/GUIMenuTabbedBox.lua")
Script.Load("lua/menu2/widgets/GUIMenuTabButtonWidget.lua")
Script.Load("lua/menu2/widgets/GUIMenuScrollPane.lua")
Script.Load("lua/GUI/GUIText.lua")
Script.Load("lua/GUI/GUIParagraph.lua")

Script.Load("lua/haggischangelog/menu2/GUIHaggisChangelogData.lua")

--GUIHaggisChangelog.topEdge = 271

local kHaggisChangelogViewedOptionKey = "haggis_mod/lastVersionViewed"

local kInnerBackgroundSideSpacing = 16 -- horizontal spacing between edge of outer background and inner background.
local kInnerBackgroundTopSpacing = 220 -- spacing between top edge of outer background and inner background.
-- spacing between bottom edge of outer background and inner background (not including tab height!).
local kInnerBackgroundBottomSpacing = kInnerBackgroundSideSpacing

local kInnerPaddingTop = 50
local kInnerPaddingBottom = 150

local kTabHeight = 94
local kTabMinWidth = 150

local kUnderlapYSize = kTabHeight + 1

local kTabButtonCloseFont = {family = "MicrogrammaBold", size = 48}
local kTabButtonXFont = {family = "MicrogrammaBold", size = 16}
--local kTabButtonWebFont = {family = "MicrogrammaBold", size = 16}

local kTitlePadding = 75
local kTitleStyle =
{
    padding = kTitlePadding, -- extra pixels added to all 4 sides to make room for outer glow.  Scales with gui object.
    shader = "shaders/GUI/menu/mainBarButtonGlow.surface_shader",
    inputs =
    {
        [1] = {
            name = "innerGlowBlur",
            value = GUIStyle.TextBlur(3)
        },
        [2] = { name = "innerGlowColor", value = HexToColor("f19eb1", 0.1) },

        [3] = {
            name = "outerGlowBlur",
            value = GUIStyle.TextBlur(15)
        },
        [4] = { name = "outerGlowColor", value = HexToColor("ea6492", 1.49) },

        [5] = { name = "baseTexture", value = "__Text", },
        [6] = { name = "textColor", value = HexToColor("ea6492") },
    }
}

local kTitleFont = {family = "AgencyBold", size = 50}

local baseClass = GUIMenuTabbedBox
class "GUIHaggisChangelog" (baseClass)

GUIHaggisChangelog:AddClassProperty("IsOpen", false)

local function UpdateResolutionScaling(self, newX, newY)

    local mockupRes = Vector(3840, 2160, 0)
    local res = Vector(newX, newY, 0)
    local scale = res / mockupRes
    scale = math.min(scale.x, scale.y)

    self:SetScale(scale, scale)
    self:SetPosition(0, 0) --self.topEdge * scale)
    self:AlignCenter()
end

-- needs to be a float
local kHaggisVersion = "8.30"
function GetHaggisVersion()
    return kHaggisVersion
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

local myHaggisChangelog

function GetHaggisChangelog()
    return myHaggisChangelog
end

function GUIHaggisChangelog:Initialize(params, errorDepth)
    errorDepth = (errorDepth or 1) + 1
    myHaggisChangelog = self
    baseClass.Initialize(self, params, errorDepth)

    self.contentObs = {}

    -- Nav bar is to be centered horizontally in the screen.
    self:AlignCenter()
    -- Set initial state of mouse cursor.  We want it visible, but not clipped if this isn't in-game.
    --MouseTracker_SetIsVisible(true, "ui/Cursor_MenuDefault.dds", true)
    --

    self:HookEvent(GetGlobalEventDispatcher(), "OnResolutionChanged", UpdateResolutionScaling)
    UpdateResolutionScaling(self, Client.GetScreenWidth(), Client.GetScreenHeight())



    self:HookEvent(self, "OnVisibleChanged",
            function(self, visible)
                if visible then
                    MouseTracker_SetIsVisible(true, "ui/Cursor_MenuDefault.dds", true)
                else
                    MouseTracker_SetIsVisible(false)
                end
            end)

    self:SetLayer(1200)

    self.title = CreateGUIObject("title", GUIStyledText, self,
    {
        style = kTitleStyle,
        font  = kTitleFont,
        align = "top",
    })
    self.title:SetText("The Playground News")
    self.title:SetY(-(kTitlePadding + 50))


    self:InitializeContentHolders()

    self.tabButtonClose = CreateGUIObject("tabButton", GUIMenuTabButtonWidget, self)
    self.tabButtonClose:SetTabHeight(kTabHeight)
    self.tabButtonClose:SetTabMinWidth(kTabMinWidth)
    self.tabButtonClose:AlignBottom()
    self.tabButtonClose:SetFont(kTabButtonCloseFont)
    self.tabButtonClose:SetLabel("CLOSE")
    self:HookEvent(self.tabButtonClose, "OnPressed", self.Close)
    self:HookEvent(self.tabButtonClose, "OnTabSizeChanged", self.SetTabSize)
    self:SetTabSize(self.tabButtonClose:GetTabSize())

    self.tabButtonX = CreateGUIObject("tabButton", GUIMenuTabButtonWidget, self)
    self.tabButtonX:SetTabHeight(kTabHeight)
    self.tabButtonX:SetTabMinWidth(kTabMinWidth)
    self.tabButtonX:AlignTopRight()
    self.tabButtonX:SetFont(kTabButtonXFont)
    self.tabButtonX:SetLabel("X")
    self.tabButtonX:SetX(120)
    self:HookEvent(self.tabButtonX, "OnPressed", self.Close)

    --self.tabButtonWeb = CreateGUIObject("tabButton", GUIMenuTabButtonWidget, self)
    --self.tabButtonWeb:SetFont(kTabButtonWebFont)
    --self.tabButtonWeb:SetLabel("OPEN IN BROWSER")
    --self.tabButtonWeb:AlignTopLeft()
    --self.tabButtonWeb:SetX(-120)
    --self:HookEvent(self.tabButtonWeb, "OnPressed", self.OpenWebsite)

    self:SetSize(2262, 1600)
    --self:SetY(750)
    self:Close()


end

--local function GUIHaggisChangelogCallbackOpener()
--    local target = GetHaggisChangelog()
--    if target then
--        target:RemoveTimedCallback(target.callback)
--        target.callback = nil
--        target:Open()
--        Client.SetOptionString(kHaggisChangelogViewedOptionKey, GetHaggisVersion())
--    end
--end

function GUIHaggisChangelog:DelayedInit()
    local lastChangelogVerViewed = Client.GetOptionString(kHaggisChangelogViewedOptionKey, "0")
    if GetIsVersionOlderThanCurrent(lastChangelogVerViewed) then
        --Log("New Haggis loaded!")
        --self.callback = self:AddTimedCallback(GUIHaggisChangelogCallbackOpener, 0.5, true)
        self:Open()
        Client.SetOptionString(kHaggisChangelogViewedOptionKey, GetHaggisVersion())
    else
        --Log("Haggis loaded!")
    end
end


--function GUIHaggisChangelog:OpenWebsite()
--    local kHaggisChangelogUrl = "https://www.peyote.ch"
--    Client.ShowWebpage( kHaggisChangelogUrl )
--end

function GUIHaggisChangelog:InitializeContentHolders()

    self.innerBack = CreateGUIObject("innerBack", GUIMenuBasicBox, self)
    self.innerBack:SetPosition(kInnerBackgroundSideSpacing, kInnerBackgroundTopSpacing - kUnderlapYSize)
    self.innerBack:SetFillColor(Color(0, 0, 0, 0.5))
    --self.innerBack:SetStrokeColor(Color(0, 0, 0, 0.4))

    self:HookEvent(self, "OnSizeChanged", self.UpdateInnerBackgroundSize)

    self.scrollPane = CreateGUIObject("scrollPane", GUIMenuScrollPane, self.innerBack)

    self.listLayout = CreateGUIObject("listLayout", GUIListLayout, self.scrollPane,
    {
        backPadding = kInnerPaddingBottom,
        frontPadding = kInnerPaddingTop,
        orientation = "vertical",
        spacing = 0,
    })

    self.scrollPane:HookEvent(self.listLayout, "OnSizeChanged", self.scrollPane.SetPaneSize)

end

function GUIHaggisChangelog:OnListSizeChanged()
    self.scrollPane:SetPaneSize(self.listLayout:GetSize().x, self.listLayout:GetSize().y + 200)
end

local kStyleToFontsMap =
{
    [1] = {family = "AgencyBold", size = 49}, -- largest header
    [2] = {family = "AgencyBold", size = 39},
    [3] = {family = "Agency", size = 31},
    [0] = {family = "Arial", size = 25} -- normal text
}

local kStyleToColorMap =
{
    [1] = MenuStyle.kHighlight,
    [2] = MenuStyle.kOptionHeadingColor,
    [3] = MenuStyle.kOptionHeadingColor,
    [0] = MenuStyle.kOffWhite --Color(0.7, 0, 0),
}

local function AddLineGroup(self, lineGroup, style, lineNumber)

    local lineGroupObj = CreateGUIObject(string.format("lineGroup_%d", lineNumber), GUIParagraph, self.listLayout,
    {
        justification = GUIItem.Align_Min,
        font = kStyleToFontsMap[style],
        color = kStyleToColorMap[style],
        paragraphSize = Vector(self.scrollPane:GetSize().x, -1, 0),
        text = lineGroup
    })
    table.insert(self.contentObs, lineGroupObj)

end

function GUIHaggisChangelog:LoadChangelog(changelogData)

    for i = 1, #self.contentObs do
        self.contentObs[i]:Destroy()
    end

    self.contentObs = {}

    local changelogStyleToken = GetHaggisChangelogStyleToken()
    local changelogLines = string.Explode(changelogData, "\n")

    -- Keep track of consecutive lines that have the same style so we can minimize the amount of objects created
    local lineGroup = ""
    local lineGroupStyle = 0

    for i = 1, #changelogLines do

        local rawLine = changelogLines[i]
        local processedLine, numTokens = string.gsub(rawLine, changelogStyleToken, "")
        processedLine = string.format("  %s", processedLine)

        --Log("$ Line: %s (Style: %s)", processedLine, numTokens)

        if i == 1 then

            lineGroup = processedLine
            lineGroupStyle = numTokens

        else

            local groupLenIfAdded = string.len(lineGroup) + string.len(processedLine)
            if numTokens ~= lineGroupStyle or i == #changelogLines or groupLenIfAdded > 500 then -- We found a string with a different style, so we create a gui obj

                AddLineGroup(self, lineGroup, lineGroupStyle, i)

                lineGroup = processedLine
                lineGroupStyle = numTokens

            else
                lineGroup = string.format("%s\n%s", lineGroup, processedLine)
            end

        end

    end

    AddLineGroup(self, lineGroup, lineGroupStyle, #changelogLines)

end

function GUIHaggisChangelog:UpdateInnerBackgroundSize()
    self.innerBack:SetSize(self:GetSize() - Vector(kInnerBackgroundSideSpacing * 2, kInnerBackgroundBottomSpacing + kInnerBackgroundTopSpacing, 0))
    self.scrollPane:SetSize(self.innerBack:GetSize().x, self.innerBack:GetSize().y)
end

function GUIHaggisChangelog:OnKey(key, down)
    if key == InputKey.Escape then
        self:Close()
    end
end
function GUIHaggisChangelog:Close()
        self:StopListeningForCursorInteractions()
        self:StopListeningForWheelInteractions()
    self:StopListeningForKeyInteractions()
    self:SetVisible(false)
    self:ClearModal()
    self:SetIsOpen(false)
    self:FireEvent("Closed")
end

function GUIHaggisChangelog:Open()
    self:ListenForCursorInteractions()
    self:ListenForWheelInteractions()
    self:ListenForKeyInteractions()
    self:SetVisible(true)
    self:SetModal()
    self:SetIsOpen(true)
    self:FireEvent("Opened")
end



if Client then
    Event.Hook("Console_haggis_reset_version", function()
        Client.SetOptionString(kHaggisChangelogViewedOptionKey, "0")
        Log("Haggis version reset")
    end)

    Event.Hook("Console_haggis_version", function()
        Log(string.format("Haggis Mod Version: %s", GetHaggisVersion()))
    end)

end
