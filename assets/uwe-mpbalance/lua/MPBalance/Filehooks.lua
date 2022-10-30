
ModLoader.SetupFileHook("lua/menu2/GUIMainMenu.lua", "lua/MPBalance/menu2/GUIMainMenu.lua", "post")

local kVersion = "1.9"
function GetMPBVersion()
    return kVersion
end

if Client then

    Event.Hook("Console_mpb_version", function()
        Log(string.format("MP Balance Mod Version: %s", GetMPBVersion()))
    end)

end
