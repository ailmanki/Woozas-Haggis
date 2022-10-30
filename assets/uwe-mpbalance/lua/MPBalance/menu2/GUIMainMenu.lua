
Script.Load("lua/menu2/GUIMenuBalanceChangelogButton.lua")

function GUIMainMenu:CreateLinksButtons()

    -- Create wiki button.
    CreateGUIObject("wikiButton", GUIMenuWikiButton, self.linkButtonsHolder)

    -- Create a discord button.
    CreateGUIObject("wikiButton", GUIMenuDiscordButton, self.linkButtonsHolder)

    -- changelog button
    CreateGUIObject("changelogButton", GUIMenuBalanceChangelogButton, self.linkButtonsHolder)

end

