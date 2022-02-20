local function ModLoader_SetupFileHook(file, replace_type)
    local FTFix_file = string.gsub(file, "lua/", "lua/FTFix/", 1)

    ModLoader.SetupFileHook(file,  FTFix_file, replace_type)
end

ModLoader_SetupFileHook( "lua/Weapons/Marine/Flamethrower.lua", "post" )
ModLoader_SetupFileHook( "lua/bot/TeamBrain.lua", "post" )