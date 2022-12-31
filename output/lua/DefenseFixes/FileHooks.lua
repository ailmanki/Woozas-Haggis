local defenseMod = ModLoader.GetModInfo("defense")
if defenseMod then
    ModLoader.SetupFileHook( "lua/Submachinegun/GUIDeathMessages.lua", "lua/DefenseFixes/empty.lua","replace" )
    ModLoader.SetupFileHook( "lua/Cannon/GUIDeathMessages.lua", "lua/DefenseFixes/empty.lua","replace" )
    ModLoader.SetupFileHook( "lua/Revolver/GUIDeathMessages.lua", "lua/DefenseFixes/empty.lua","replace" )
    ModLoader.SetupFileHook( "lua/FadedWaveKF.lua", "lua/DefenseFixes/FadedWaveKF.lua","replace" )
    ModLoader.SetupFileHook("lua/GUIDeathScreen2.lua", "lua/DefenseFixes/GUIDeathScreen2.lua", "replace")
    ModLoader.SetupFileHook("lua/ARC.lua", "lua/DefenseFixes/ARC.lua", "pre")
    ModLoader.SetupFileHook("lua/Defense/Balance.lua", "lua/DefenseFixes/Balance.lua", "post")
    ModLoader.SetupFileHook("lua/Defense/BalanceMisc.lua", "lua/DefenseFixes/BalanceMisc.lua", "post")
    ModLoader.SetupFileHook("lua/Defense/Sentry.lua", "lua/DefenseFixes/Sentry.lua", "post")
end
