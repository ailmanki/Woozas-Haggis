
Script.Load("lua/haggischangelog/menu2/GUIMenuHaggisChangelogButton.lua")

local oldGUIMainMenuCreateLinksButtons = GUIMainMenu.CreateLinksButtons
function GUIMainMenu:CreateLinksButtons()
    oldGUIMainMenuCreateLinksButtons(self)

    -- changelog button
    CreateGUIObject("haggisChangelogButton", GUIMenuHaggisChangelogButton, self.linkButtonsHolder)
end