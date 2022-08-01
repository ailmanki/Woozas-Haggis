ModLoader.SetupFileHook("lua/menu2/GUIMainMenu.lua", "lua/haggischangelog/menu2/GUIMainMenu.lua", "post")

-- needs to be a float
local kHaggisVersion = "8.3"
function GetHaggisVersion()
    return kHaggisVersion
end

if Client then

    Event.Hook("Console_haggis_version", function()
        Log(string.format("Haggis Mod Version: %s", GetHaggisVersion()))
    end)

end
