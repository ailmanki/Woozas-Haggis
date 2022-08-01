-- ======= Copyright (c) 2021, Unknown Worlds Entertainment, Inc. All rights reserved. =======
--
-- lua/menu2/GUIBalanceChangelogData.lua
--
--    Created by:   Darrell Gentry (darrell@naturalselection2.com)
--
--    Data for the changelog window.
--
-- ========= For more information, visit us at http://www.unknownworlds.com =====================

-- »h1 Main
-- »»h2 Sub
-- »»»h3 Sub Sub
-- just text
-- ● list symbol
-- ■ list symbol

-- Each change string should be prefixed with this character.
-- This'll all be parsed and processed when loaded into the changelog window.
function GetHaggisChangelogStyleToken()
    return "»"
end

gHaggisChangelogData =
[[
»1 August 2022
    ● Modular Exosuits updated - thx to Scatter
        ● new Catpack upgrade
        ● adjusted exo prices
        ● adjusted minigun, flamer, welder damage
        ● Thrust adjusted
        ● Shield adjusted
        ● Weapon upgrades affect exos again
        ● Descriptions improved
        ● various more little changes
»30 July 2022
    ● Add fixes for shuffle system.
»19 July 2022
    ● Add proper titles in the map vote menu for ns2_tow_veil and ns2_tow_caged.
    ● Add The Playground News.
    ● Removed map loading screens from the bundle. Those are now early loaded through the new mod loading system.
]]