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
»31 December 2022
    ● Fixed Meter skill
»19 December 2022
    ● Add Defense mod
»10 December 2022
    ● Patch 343 has been released
        ● Defense mod is broken (disabled)
        ● Combat mod
            ● Prowler is broken (disabled)
            ● Map co_nest is broken (disabled)
»5 December 2022
    ● Add Extreme Shadows mod, see Options->Mods (add yesterday)
    ● Add Outage mod, makes the power outage use the original light color (add a while ago)
    ● Made sentry animations smooth
»27 November 2022
    ● Defense
        ● Add new map ns2_tow_fusion
        ● Commander can drop up to 128 sentries instead of 6 per room
        ● Sentry dmg increased from 4 to 5
        ● Sentry shoot distance increase from 20 to 60
        ● Reduced ARC range
    ● Removed Badges mod panel
»17 October 2022
    ● Fixed server error in combat mode, related to auto welding.
»16 October 2022
    ● Fixed wrong date for previous news.
    ● Removed +40% team preference boost in shuffle algorithm.
    ● Add Scatter's weapons to Defense mod.
»8 October 2022
    ● Add happiness history to improve shuffle team preferences. It now also looks at past rounds if the player got into the preferred team.
»6 August 2022
    ● Modular Exosuits updated, preparations so we can add it to "vanilla" - thx to Scatter
        ● adjusted costs
        ● adjusted weights
        ● lowered railgun dmg
        ● preparations for new abilities
»2 August 2022
    ● Add auto-popup for the Playground News and removed icon animation.
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