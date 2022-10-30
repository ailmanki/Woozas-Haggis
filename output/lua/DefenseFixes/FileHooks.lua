local defenseMod = ModLoader.GetModInfo("defense")
if defenseMod then
    ModLoader.SetupFileHook( "lua/Submachinegun/GUIDeathMessages.lua", "lua/DefenseFixes/empty.lua","replace" )
    ModLoader.SetupFileHook( "lua/Cannon/GUIDeathMessages.lua", "lua/DefenseFixes/empty.lua","replace" )
    ModLoader.SetupFileHook( "lua/Revolver/GUIDeathMessages.lua", "lua/DefenseFixes/empty.lua","replace" )
    ModLoader.SetupFileHook( "lua/FadedArmory.lua", "lua/DefenseFixes/FadedArmory.lua","replace" )
    ModLoader.SetupFileHook( "lua/FadedWaveKF.lua", "lua/DefenseFixes/FadedWaveKF.lua","replace" )
    ModLoader.SetupFileHook("lua/GUIDeathScreen2.lua", "lua/DefenseFixes/GUIDeathScreen2.lua", "replace")
end
