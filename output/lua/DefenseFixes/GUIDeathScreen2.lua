-- ======= Copyright (c) 2003-2021, Unknown Worlds Entertainment, Inc. All rights reserved. =======
--
-- lua\GUIDeathScreen2.lua
--
-- Created by: Darrell Gentry (darrell@unkownworlds.com)
--
-- ========= For more information, visit us at http://www.unknownworlds.com =====================

Script.Load("lua/GUI/GUIObject.lua")
Script.Load("lua/GUI/GUIText.lua")
Script.Load("lua/DeathMessage_Client.lua")
Script.Load("lua/menu2/PlayerScreen/GUIMenuSkillTierIcon.lua")

local kBackgroundTexture = PrecacheAsset("ui/deathscreen/background.dds")

local kCallingCardSize = Vector(274, 274, 0)
local kFontName = "Agency"

local kCenterSectionWidth = 310
local kSectionPadding = 35 -- Padding between text and center section
local kBackgroundDesiredShowTime = 2 -- Desired seconds to show the black background
local kContentsDesiredShowTime = 5 -- How long to show the calling card, name, etc
local kBackgroundFadeInDelay = 0.45 -- When the black background starts fading in, compared to the contents
local kSubtextColor = HexToColor("8aa5ad")

local kBigFontSize = 38
local kSmallFontSize = 18

class 'GUIDeathScreen2' (GUIObject)

local function UpdateResolutionScaling(self, newX, newY)

    local mockupRes = Vector(1920, 1080, 0)
    local screenRes = Vector(newX, newY, 0)
    local scale = screenRes / mockupRes
    scale = math.min(scale.x, scale.y)

    self:SetSize(newX, newY)
    self.background:SetScale(scale, scale)

end

function GUIDeathScreen2:Initialize(params, errorDepth)
    errorDepth = (errorDepth or 1) + 1

    GUIObject.Initialize(self, params, errorDepth)

    self.contentsObjs = {}

    self:SetSize(Client.GetScreenWidth(), Client.GetScreenHeight())
    self:SetLayer(kGUILayerDeathScreen) -- GUI rendering is depth-first...
    self:SetColor(0,0,0,1)
    self:SetOpacity(0)

    self.background = CreateGUIObject("background", GUIObject, self)
    self.background:AlignCenter()
    self.background:SetTexture(kBackgroundTexture)
    self.background:SetSizeFromTexture()
    self.background:SetColor(1,1,1)
    table.insert(self.contentsObjs, self.background)

    self.callingCard = CreateGUIObject("callingCard", GUIObject, self.background)
    self.callingCard:SetSize(kCallingCardSize)
    self.callingCard:SetColor(1,1,1)
    self.callingCard:AlignTop()
    self.callingCard:SetY(22)
    table.insert(self.contentsObjs, self.callingCard)

    local sideWidth = math.floor((self.background:GetSize().x - (kCenterSectionWidth)) / 2)
    local startLeftFromRight = -sideWidth - kCenterSectionWidth - kSectionPadding
    local startRightFromLeft = sideWidth + kCenterSectionWidth + kSectionPadding

    self.killedByLabel = CreateGUIObject("killedByLabel", GUIText, self.background)
    self.killedByLabel:AlignRight()
    self.killedByLabel:SetFont(kFontName, kBigFontSize)
    self.killedByLabel:SetText(Locale.ResolveString("DEATHSCREEN_LEFTLABEL_TOP"))
    self.killedByLabel:SetPosition(startLeftFromRight, -20)
    self.killedByLabel:SetColor(HexToColor("ff5757"))
    table.insert(self.contentsObjs, self.killedByLabel)

    self.killedByLabelPrefix = CreateGUIObject("killedByLabel", GUIText, self.background)
    self.killedByLabelPrefix:AlignRight()
    self.killedByLabelPrefix:SetFont(kFontName, kBigFontSize)
    self.killedByLabelPrefix:SetText(string.format("%s%s", Locale.ResolveString("DEATHSCREEN_LEFTLABEL_TOP_PREFIX"), " "))
    self.killedByLabelPrefix:SetPosition(startLeftFromRight - self.killedByLabel:GetSize().x, -20)
    self.killedByLabelPrefix:SetColor(1,1,1)
    table.insert(self.contentsObjs, self.killedByLabelPrefix)

    self.killedByLabel2 = CreateGUIObject("killedByLabel2", GUIText, self.background)
    self.killedByLabel2:AlignRight()
    self.killedByLabel2:SetFont(kFontName, kSmallFontSize)
    self.killedByLabel2:SetText(Locale.ResolveString("DEATHSCREEN_LEFTLABEL_BOTTOM"))
    self.killedByLabel2:SetPosition(startLeftFromRight, 20)
    self.killedByLabel2:SetColor(kSubtextColor)
    table.insert(self.contentsObjs, self.killedByLabel2)

    self.killedWithLabel = CreateGUIObject("killedWithLabel", GUIText, self.background)
    self.killedWithLabel:AlignLeft()
    self.killedWithLabel:SetFont(kFontName, kSmallFontSize)
    self.killedWithLabel:SetText(Locale.ResolveString("DEATHSCREEN_RIGHTLABEL_TOP"))
    self.killedWithLabel:SetPosition(startRightFromLeft, -40)
    self.killedWithLabel:SetColor(kSubtextColor)
    table.insert(self.contentsObjs, self.killedWithLabel)

    self.killedWithLabel2 = CreateGUIObject("killedWithLabel2", GUIText, self.background)
    self.killedWithLabel2:AlignLeft()
    self.killedWithLabel2:SetFont(kFontName, kBigFontSize)
    self.killedWithLabel2:SetPosition(startRightFromLeft, 0)
    self.killedWithLabel2:SetColor(1,1,1)
    table.insert(self.contentsObjs, self.killedWithLabel2)

    self.killerName = CreateGUIObject("killerName", GUIText, self.background) -- TODO(Salads): Change this to a truncated text? names can get pretty long..
    self.killerName:AlignTop()
    self.killerName:SetFont(kFontName, kBigFontSize)
    self.killerName:SetPosition(self.callingCard:GetSize().y + 5, -20)
    self.killerName:SetColor(1,1,1)
    self.killerName:SetPosition(0, self.callingCard:GetSize().y + 5)
    table.insert(self.contentsObjs, self.killerName)

    self.weaponIcon = CreateGUIObject("weaponIcon", GUIObject, self.killedWithLabel2)
    self.weaponIcon:AlignLeft()
    self.weaponIcon:SetTexture(kInventoryIconsTexture)
    self.weaponIcon:SetColor(1,1,1)
    self.weaponIcon:SetSize(DeathMsgUI_GetTechWidth(), DeathMsgUI_GetTechHeight())
    self.weaponIcon:SetPosition(self.killedWithLabel2:GetSize().x, 0)
    table.insert(self.contentsObjs, self.weaponIcon)

    self.skillbadge = CreateGUIObject("skillbadge", GUIMenuSkillTierIcon, self.background)
    self.skillbadge:AlignTop()
    table.insert(self.contentsObjs, self.skillbadge:GetIconObject())
    self:HookEvent(GetGlobalEventDispatcher(), "OnResolutionChanged", UpdateResolutionScaling)
    UpdateResolutionScaling(self, Client.GetScreenWidth(), Client.GetScreenHeight())

    self.lastIsDead = PlayerUI_GetIsDead()
    self.lastIsSpawning = false
    self.hasOpenedMap = false
    self.shouldStopShowingBackground = false
    self.shouldStopShowingContents = false
    self.shouldStopShowing = false
    self.spawningStarted = false

    self:ShowContents(false, true)
    self:ShowBackground(false, true)
    self:SetUpdates(true)

end

function GUIDeathScreen2:GetIsFullyShown()
    return (not self.callingCard:GetIsAnimationPlaying("Opacity")) and (not self:GetIsAnimationPlaying("Opacity"))
end

function GUIDeathScreen2:OnUpdate()

    local player = Client.GetLocalPlayer()
    local isSpawning = player and player.GetIsRespawning and player:GetIsRespawning() == true or false
    isSpawning = isSpawning or GetPlayerIsSpawning() -- TODO(Salads): >:( Will need to hook up infantry portal with "SetIsRespawning" message for MarineSpectator.
    local isSpawningChanged = self.lastIsSpawning ~= isSpawning

    local isDead = PlayerUI_GetIsDead()
    local isDeadChanged = isDead ~= self.lastIsDead

    if isDeadChanged then

        if isDead then
            -- Just died, so show it
            if self:UpdateContentsFromKillerInfo() then
                self.lastIsDead = true
                self.lastIsSpawning = false
                self.hasOpenedMap = false
                self.shouldStopShowingBackground = false
                self.shouldStopShowingContents = false
                self.shouldStopShowing = false
                self.spawningStarted = false
                self:ShowContents(true, false)
            end
        else
            -- Fully Alive, so just hide it. (instant)
            self:CleanupTimedCallbacks()
            self:ShowContents(false, true)
            self:ShowBackground(false, true)
            self:ShowDeathCinematic(false)
            self.lastIsDead = false
        end

    elseif isDead and
            not isSpawning and
            not self.shouldStopShowing and
            not self.spawningStarted and
            not player:isa("Spectator") then -- Sigh... the input events for showing map just stop coming if being held down
        -- (Fixes map being "not visible" when it is when player class becomes Spectator)

        -- Just show/hide instantly, since we dont block the minimap at any point.
        local isMapOpen = player:GetIsMinimapVisible()
        self.hasOpenedMap = self.hasOpenedMap or isMapOpen
        if self.hasOpenedMap then
            if isMapOpen then
                self:ShowContents(false, true)
            elseif not self.shouldStopShowingContents then
                self:ShowContents(true, true)
            end
        end

    elseif isSpawningChanged and isSpawning then
        self:CleanupTimedCallbacks()
        self:ShowContents(false)
        self:ShowBackground(false)
        self:ShowDeathCinematic(false)
        self.lastIsSpawning = true
        self.spawningStarted = true
    end

end

function GUIDeathScreen2:OnBackgroundMaxShowtimeReached()
    self:ShowBackground(false)
    self:ShowDeathCinematic(false)
    self.shouldStopShowingBackground = true
    if kBackgroundDesiredShowTime >= kContentsDesiredShowTime then
        self.shouldStopShowing = true
    end
end

function GUIDeathScreen2:OnContentsMaxShowtimeReached()
    self:ShowContents(false)
    self.shouldStopShowingContents = true
    if kContentsDesiredShowTime >= kBackgroundDesiredShowTime then
        self.shouldStopShowing = true
    end
end

function GUIDeathScreen2:FadeInBackground()
    self:ShowBackground(true)
end

function GUIDeathScreen2:ShowContents(show, instant)

    local opacityTarget = show and 1 or 0

    for i = 1, #self.contentsObjs do
        local obj = self.contentsObjs[i]
        local currentOpacity = obj:GetOpacity()
        obj:ClearPropertyAnimations("Opacity")
        obj:SetOpacity(currentOpacity) -- When clearing animations, it'll set it to animation's baseValue.

        if instant then
            obj:SetOpacity(opacityTarget)
        else
            obj:AnimateProperty("Opacity", opacityTarget, MenuAnimations.Fade)
        end
    end

end

function GUIDeathScreen2:ShowBackground(show, instant)

    local opacityTarget = show and 1 or 0
    local currentOpacity = self:GetOpacity()
    self:ClearPropertyAnimations("Opacity")
    self:SetOpacity(currentOpacity) -- When clearing animations, it'll set it to animation's baseValue.

    if instant then
        self:SetOpacity(opacityTarget)
    else
        self:AnimateProperty("Opacity", opacityTarget, MenuAnimations.DeathScreenFade)
    end

end

function GUIDeathScreen2:ShowDeathCinematic(show)

    if show then
        local player = Client.GetLocalPlayer()
        if player and not self.cinematic and not PlayerUI_GetIsSpecating() then
            self.cinematic = Client.CreateCinematic(RenderScene.Zone_ViewModel)
            self.cinematic:SetCinematic(FilterCinematicName(player:GetFirstPersonDeathEffect()))
        end
    else
        if self.cinematic then

            if IsValid(self.cinematic) then
                self.cinematic:SetIsVisible(false)
                Client.DestroyCinematic(self.cinematic)
            end
            self.cinematic = nil

        end
    end

end

function GUIDeathScreen2:CleanupTimedCallbacks()
    self:RemoveTimedCallback(self.backgroundFadeInCallback)
    self:RemoveTimedCallback(self.contentsMaxShowtimeReachedCallback)
    self:RemoveTimedCallback(self.backgroundMaxShowtimeReachedCallback)
end

function GUIDeathScreen2:UpdateContentsFromKillerInfo()

    local killerInfo = GetAndClearKillerInfo()

    if not killerInfo.Name then -- Killer name not set yet (sent via network message)
        return false
    end

    if not killerInfo.CallingCard then
        killerInfo.CallingCard = kCallingCards.ForScience;
        killerInfo.SteamId = 0;
        killerInfo.IsRookie = 0;
        killerInfo.Skill = 4000;
        killerInfo.AdagradSum = 0;
        killerInfo.Name = "Kharaa"
    end

    self:ShowDeathCinematic(true)
    self:CleanupTimedCallbacks()

    self.backgroundFadeInCallback = self:AddTimedCallback(self.FadeInBackground, kBackgroundFadeInDelay, false) -- show black background

    -- lifetime callbacks
    self.contentsMaxShowtimeReachedCallback = self:AddTimedCallback(self.OnContentsMaxShowtimeReached, kContentsDesiredShowTime, false)
    self.backgroundMaxShowtimeReachedCallback = self:AddTimedCallback(self.OnBackgroundMaxShowtimeReached, kBackgroundDesiredShowTime, false)

    -- Now we have the info ready, we can finally start updating the UI
    self.killerName:SetText(killerInfo.Name) -- Always available

    local context = killerInfo.Context
    if context == kDeathSource.Player or context == kDeathSource.Structure then -- We have information about the player who killed us (Structure = Commander)

        -- All elements should be used here.
        local cardTextureDetails = GetCallingCardTextureDetails(killerInfo.CallingCard)

        self.callingCard:SetTexture(cardTextureDetails.texture)
        self.callingCard:SetTexturePixelCoordinates(cardTextureDetails.texCoords)
        self.callingCard:SetVisible(true)

        self.killerName:SetVisible(true)

        self.skillbadge:SetSteamID64(Shared.ConvertSteamId32To64(killerInfo.SteamId))
        self.skillbadge:SetIsRookie(killerInfo.IsRookie)
        self.skillbadge:SetSkill(killerInfo.Skill)
        self.skillbadge:SetAdagradSum(killerInfo.AdagradSum)
        self.skillbadge:SetIsBot(killerInfo.SteamId == 0)
        self.skillbadge:SetVisible(true)

        -- Right Side
        self.killedWithLabel2:SetText(EnumToString(kDeathMessageIcon, killerInfo.WeaponIconIndex))

        local xOffset = DeathMsgUI_GetTechOffsetX(0)
        local yOffset = DeathMsgUI_GetTechOffsetY(killerInfo.WeaponIconIndex)
        local iconWidth = DeathMsgUI_GetTechWidth(0)
        local iconHeight = DeathMsgUI_GetTechHeight(0)

        self.weaponIcon:SetPosition(self.killedWithLabel2:GetSize().x, 0)
        self.weaponIcon:SetTexturePixelCoordinates(xOffset, yOffset, xOffset + iconWidth, yOffset + iconHeight)

        local showRightSide = killerInfo.WeaponIconIndex ~= kDeathMessageIcon.None
        self.killedWithLabel:SetVisible(showRightSide)
        self.killedWithLabel2:SetVisible(showRightSide)
        self.weaponIcon:SetVisible(showRightSide)


    else -- Hiding skill badge, and right side (StructureNoCommander, DeathTrigger, KilledSelf), but everything else is visible.

        local cardTextureDetails = GetCallingCardTextureDetails(killerInfo.CallingCard)
        self.callingCard:SetTexture(cardTextureDetails.texture)
        self.callingCard:SetTexturePixelCoordinates(cardTextureDetails.texCoords)
        self.callingCard:SetVisible(true)

        self.killerName:SetVisible(true)
        self.skillbadge:SetVisible(false)

        -- Right Side
        local showRightSide = context == kDeathSource.KilledSelf and killerInfo.WeaponIconIndex ~= kDeathMessageIcon.None
        if showRightSide then

            local xOffset = DeathMsgUI_GetTechOffsetX(0)
            local yOffset = DeathMsgUI_GetTechOffsetY(killerInfo.WeaponIconIndex)
            local iconWidth = DeathMsgUI_GetTechWidth(0)
            local iconHeight = DeathMsgUI_GetTechHeight(0)

            self.killedWithLabel:SetVisible(true)
            self.killedWithLabel2:SetText(EnumToString(kDeathMessageIcon, killerInfo.WeaponIconIndex))
            self.killedWithLabel2:SetVisible(true)
            self.weaponIcon:SetPosition(self.killedWithLabel2:GetSize().x, 0)
            self.weaponIcon:SetTexturePixelCoordinates(xOffset, yOffset, xOffset + iconWidth, yOffset + iconHeight)
            self.weaponIcon:SetVisible(true)

        else

            self.killedWithLabel:SetVisible(false)
            self.killedWithLabel2:SetVisible(false)
            self.weaponIcon:SetVisible(false)

        end

    end

    -- If the player does not have a calling card, move the killer name and it's badge to the center, height-wise
    -- Also make sure calling card is not visible.
    if killerInfo.CallingCard == kCallingCards.None then

        self.callingCard:SetVisible(false)
        self.killerName:SetY((self.background:GetSize().y / 2) - (self.killerName:GetSize().y / 2))
        self.skillbadge:SetY(self.killerName:GetPosition().y + self.killerName:GetSize().y)

    else -- We have a calling card to display, so make sure everything is in the proper place.

        self.callingCard:SetVisible(true) -- Just in case
        self.killerName:SetPosition(0, self.callingCard:GetSize().y + 5)

        local centerBorderSize = 22
        local spaceLeftY = self.background:GetSize().y - centerBorderSize - (self.killerName:GetSize().y + self.killerName:GetPosition().y) - self.skillbadge:GetSize().y
        local paddingY = spaceLeftY / 2
        self.skillbadge:SetY(self.killerName:GetSize().y + self.killerName:GetPosition().y + paddingY - 10)

    end

    return true

end