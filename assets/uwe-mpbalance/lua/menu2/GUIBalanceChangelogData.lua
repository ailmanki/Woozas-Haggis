-- ======= Copyright (c) 2021, Unknown Worlds Entertainment, Inc. All rights reserved. =======
--
-- lua/menu2/GUIBalanceChangelogData.lua
--
--    Created by:   Darrell Gentry (darrell@naturalselection2.com)
--
--    Data for the changelog window.
--
-- ========= For more information, visit us at http://www.unknownworlds.com =====================

-- Each change string should be prefixed with this character.
-- This'll all be parsed and processed when loaded into the changelog window.
function GetChangelogStyleToken()
    return "»"
end

gChangelogData =
[[
»1.9
»»ARC
    - Fix ARCs able to target Contamination
»1.8
»»MAC
    - Fix MACs not able to build structures
»1.7
»»ARC
    - Fix exploit blocking ARCs from shooting hive by placing Hydras
        - ARCs will no longer automatically target Hydras
        - You can now manually set a target for ARCs, including Hydras
»1.6

»»Heal Sound
    - Heal sound for aliens is now only silent when it is caused by regeneration.
»»Aura
    - Updated matched play Aura graphic
»»Lerk
    - Decreased Lerk Carapace armor per biomass bonus to 1 (down from 2)
»»Boneshield
    - Increased t-res research cost to 25 (from 20)
    - Decreased recharge rate to 80 (from 130)
    - Moved UI to be more out of the way of techpoint's hitpoints progress bar
    - Fuel can now be recovered while Boneshield is being used. (damage cooldowns, etc still apply)
    - Fixed recovering too much fuel when being equipped in some cases
    - Fixed UI not scaling with resolution changes
»»ARC
    - Non matched-play games now have a max ARC limit of 5. Matched play games still have a limit of 4.
»1.5

»»Phasegates
    - Increased time before another Marine is allowed to phase through immediately after to 0.6 seconds (from 0.3)
»»Boneshield (Onos)
    - Now blocks damage from only the front again
    - Railgun now damages both Boneshield and Onos.
    - All hand grenades ignore Boneshield.
    - Exo minigun, Rifle, HMG, Shotgun, Grenade Launcher, Welder and Pistol are blocked by Boneshield.
    - Added yellow damage numbers when Onos is blocking with Boneshield.
        - These show up separately for each hit.
    - New third-person Boneshield effect when it's active!
»»Mucous
    - Added new effects for Drifter's Mucous membrane to distinguish from healing mechanics
    - New effects for showing Mucous on Aliens
    - New "blood" hit effects when aliens are hit when mucous is active
»»Heavy Machine Gun
    - Decreased base damage to 7 (from 8)
»»Skulk
    - Leap energy cost decreased to 45 (revert)
»»Fixes
    - Fixed Regen upgrade still applying when Boneshield is blocking all damage.
    - Fixed Alien attacking silently on client-side when at extremely low energy.
    - Fixed Phasegate phase-back (Thanks 4sdf!)
    - Fixed Webs not being 3 webs with 1 charge each in Matched Play servers.
    - Fixed Boneshield not recovering fuel when holstered
    - Fixed exploit with Robotics Factory being able to put structures inside it
    - Fixed Boneshield absorbed damage not accounting for weapon damage types
    - Regen sound for players is now completely silent, instead of only audible for friends.

»1.3

»General
    »»Resources
        - Player p-res income rate is now 0.1 per tick (down from 0.125)
        - Alien starting p-res is now 15 (up from 12)
        - Fade Cost reduced to 35 (down from 37)
        - Onos Cost reduced to 55 (down from 62)
        - Increase Marine starting pres to 20 from 15
    »»Healing Softcap
        - Softcap is now 12% eHP/s with an 80% penalty for excess healing (from 14% / 66%)
»Kharaa
    »»Commander
        - Removed the Onos Charge research
    »»Lerk
        »»»Movement
            - Strafe force changed to 8.3 (from 7)
            - Lerk glide makes a sound if a Lerk is gliding above 4.5 speed
            - Added an air brake functionality to the Movement Modifier key (default is Shift key)
              that will slow glide speed down to 4.5 speed for silent gliding. Lerks will maintain
              a 4.5 speed glide while the key is pressed.
            - Increased glide minimum speed clamp to 4.5 (up from 4)
        »»»Spikes
            - Reduce Spread to 3.3 (down from 3.8)
            - Projectile size reduced to 45mm (from 60mm)
        »»»Spores
            - Move research to Biomass 6 (up from Biomass 5)
        »»»Umbra
            - Increase research cost to 30 (up from 20)
            - Increase research time to 75 seconds (up from 45 seconds)
    »»Fade
        - Blink energy cost changed to 12 (down from 14)
        »»»Metabolize
            - Cost changed to 10 (down from 25)
            - Now restores 20 energy (down from 35)
    »»Tunnels
        - Removed "Infested Tunnel" upgrade
        - Tunnels now become Infested Tunnels automatically upon reaching full maturity
        - Mature health changed to 1400/250 (up from 1250/200)
        - Time to Mature changed to 75 seconds (down from 120)
        - Tunnel resource cost changed to 8 tres (up from 6)
    »»BoneWall
        - No longer flammable
    »»Shade/Shift/Crag
        - Structure movement speed increased by 15%
    »»Contamination
        - Cooldown changed to 3 seconds (down from 6)
        - Health changed to 1500 (up from 1000)
        - No longer flammable
        - Biomass Requirement changed to 12 (up from 10)
        - Can no longer be targeted by ARCs
    »»Eggs
        - Lerk Egg Drop biomass requirement changed to 4 (from 2)
        - Lerk Egg Drop cost changed to 40 (from 30)
        - Gorge Egg Drop cost changed to 20 (from 15)
        - Fade Egg Drop biomass requirement changed to 8 (from 9)
        - Fade Egg Drop cost changed to 80 (down from 100)
        - Fixed an issue where players can spawn out of a Lifeform Egg and delete it as a result
        - Clamped number of Lifeform Egg drops to 2 per Hive
    »»Drifters
        - Hover height to the ground was lowered
        - Drifters cloaked by the Shade hive upgrade will now un-cloak from further away (3m up from 1.5)
        - Turn rate is instant on the first move command, but will return to the normal turn before moving
          behavior on subsequent move orders (this effect has a 4 second cooldown)
        »»»Enzyme
            - Cooldown changed to 3 seconds (from 12 seconds)
        »»»Hallucinations
            - No longer affected by mucous
            - Can no longer have babblers attached
            - Hallucination Onos now has 100 HP
        »»»Mucous
            - Cooldown changed to 3 second (from 12 seconds)
            - Cloud radius changed to 5 (from 8)
            - Shield values now match babbler shield values (except Skulk - remains at 15 HP)
    »»Gorge
        »»»Babblers
            - Now flammable
        »»»Bile Bomb
            - Biomass requirement for research changed to Biomass 2 (down from 3)
        »»»Web
            - Webs become visible from slightly farther away ( +1 meter)
            - Webs have only 1 charge (down from 3) (Matched Play Only)
        »»»Health
            - Gorge health changed to 190 (from 160) (Matched Play Only)
        »»»Spit
            - Gorge spit projectile speed changed to 45 (from 35)
    »»Skulk
        - Leap energy cost changed to 55 (up from 45)
        - Adrenaline upgrade now grants 60% increased energy regeneration (up from 50%)
    »»Cysts
        - Build time changed to 4.5 Seconds (up from 3.33) (Matched Play Only)
        - Shade hive cyst reveal range changed to 8 (from 6)
        - Cyst health changed to 400 near the hive and 200 far away (up from 300 / 200)
          Health falloff range from the hive room decreased slightly
        - Damage bonus from welders changed to 5x from 7x
    »»Shift
        - Echo upgrades cost changed to 2 (from 1)
        - Echo Egg cost changed to 1 (from 2)
    »»Crag player healing
        - Fixed issue where Heal Wave was not correctly increasing crag healing by 30%
        - Changed Crag to heal eHP instead of a flat value
        - Crags now heal players with lifeform specific healing values instead of a percentage
                Skulk: 10 (previously 7)
                Gorge: 15 (previously 11)
                Lerk: 16 (previously 10)
                Fade: 25 (previously 17)
                Onos: 80 (previously 42)
    »»Carapace
        - Base armor bonus reduced
        - Now Grants a small armor bonus for each biomass:
          <Base Armor value> [Biomass Armor Bonus]:
                Skulk: 5 [1]
                Gorge: 12 [2]
                Lerk: 12 [2]
                Fade: 20 [2.5]
                Onos: 50 [20]
    »»Regeneration
        - Healing amount changed to 6% (from 8%)
    »»Aura
        - No longer reveals health (Matched Play Only)
        - Now has a unique UI element for the non-health revealing version (Matched Play Only)
    »»Vampirism
        »»»Lerk
            - Vampirism percentage changed to 6% (from 8%)
    »»Onos
        - Charge is now a baseline ability and does not require research from the commander.
        - Boneshield has been reworked:
            ■ No longer uses “fuel”
            ■ BoneShield now has 1000 hitpoints and prevents all damage
            ■ Boneshield now encompasses the entire onos (not just the front half)
            ■ While the shield is active, energy regeneration is reduced by 50% (this includes all sources)
            ■ BoneShield recharge occurs immediately while out of combat, or 3 seconds after BoneShield is
              deactivated while in combat. Recharge rate is 130 shield hitpoints per second.
            ■ When BoneShield is broken, a unique sound will play and shield recharge penalty is increased
              to 6 seconds, visualized by a "broken" shield ui bar.
»Marine
    »»Medpacks
        - Heal over time effect no longer expires when a marine hits full HP
    »»ARCs
        - Heath changed to 2000/500 (from 2600/400) (Matched Play Only)
        - Commanders can now only create a maximum of 4 ARCs (Matched Play Only)
    »»Pulse Grenade
        - LOS blocking removed
        - Can be used to hit aliens behind RTs
    »»Heavy Machinegun
        - Spread changed to 3.2 (from 4)
    »»Shotgun
        - Shotgun damage per weapon upgrade changed to ~13.33 (from ~10)
    »»Gas Grenade
        - Made much less bouncy
    »»Observatory
        - Build time changed to 12 seconds (down from 17)
    »»Prototype Lab
        - Cost changed to 25 (from 35)
    »»Sentries
        - Battery cost changed to 15 (from 10)
        »»»Confusion from spores
            - Duration changed to 8 seconds (from 4)
            - Time until next attack effect changed to 4 seconds (from 2)
    »»Supply
        - Sentry supply cost changed to 15 (from 10)
        - Sentry Battery supply cost changed to 25 (from 15)
        - Robotics Factory supply cost increased to 10 (from 5)
]]