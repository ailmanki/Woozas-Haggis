-- This is the main MapCycle file, MapCycle.json is only used as a failover if needed (should not be)

local afkdetector     = "4F94D644"
local boombox         = "46513472"
local balancebeta     = "77FAFE74"
local betterns2       = "8fb78f73"
local buymenuhotkey   = "744eb9f4"
local cannon          = "999838e9"
local changeling      = "875ae269"
local clogbalance     = "734de3f1"
local combatpp2       = "8AE61F8F" -- Meteru's version of combat
local combatshrimm    = "93F61EAA" -- Shrimm's version, includes gorge toys and combat equipment
local combatequipment = "84F2921E"
local commtoys        = "886006c4" -- sentry boost and support structure & ability buffs
local crayzmines      = "98AF0CF8"
local creepatmos      = "30BF2431"
local criterion_bal   = "5836B390"
local defense         = "258572bf"
local disableskins    = "59D0C2A0"
local disabledcom     = "97CE3F28"
local disco			  = "7EF598E6"
local director        = "549E4D8A"
local enhancedspec    = "4384B7FE"
local exosuitoverhaul = "5039064F"
local extraweapons    = "99C77763"
local factoryfix      = "9b633356" -- fixes error spam from killed MAC before factory rollout
local fadevoidrocket  = "40540293"
local fastreactionbot = "87908442"
local fewerbuildrestr = "32DFC3D8"
local flamesentry     = "2ebce6c7"
local flamethrower    = "170CE75D"
local flamefix        = "82d3f412" -- twiliteblue's fix for flamethrower
local gorgeenhanced   = "7B9B0165"
local gorgetoysbeta   = "970e3ab3" -- twiliteblue's gorge toys beta , replaces gorgeenhanced      
local gorgetunnels    = "7AA38154"
local gungame         = "701E6E9C"
local hallucloudink   = "7bd91802"
local haggis          = "70DC2712"
local healfieldfast   = "8752CFA2" --"75E2546D"
local hideskilltiers  = "563B607D"
local hightickalpha   = "548DEBE4"
local infested        = "2E813610"
local infestedfix     = "98B51D00" -- endgame stats fix by meteru
local iplimitfree     = "8CDCA6ED"  -- increase IP per CC to 10
local hodgepodge      = "3477E49F"
local hodgepodgebeta  = "64333544"
local improvgorgespit = "660968A3"
local laststand       = "25e20012"
local lerkanimfix     = "53CEF116"
local lerkbalance     = "76B439DD"
local localtalk       = "8B09F28C"
local luaconfig       = "4DE41D6E"
local meterufixes     = "78F8B079"
local modpanelspp     = "55120F3D"
local oldent          = "6C517342" -- Good old entities
local onosoverhaul    = "4fde9611"
local onosrework      = "88d75f3d"
local outage 		  = "8AE093EA"
local pantsu          = "54DC69F2"
local pokemon	      = "685F1F31"
local prowler         = "916AAF0C"
local prowler_tw      = "9805babe"
local prowler_tw2      = "a1ebc2cf"

local persistminimap  = "4586d2da"
local personalshield  = "45f1d75d"
local pregamepeace    = "4FA3146C"
local potpourri       = "34A3DF7F"
local potpourribeta   = "6432FAD8"
local pulsescan       = "8D3027E3"
local ragdoll         = "30367f82"
local ragdollenhanced = "7dac7a7e"
local resbalancer     = "2060f5d4"
local realshuffle     = "58123DF5"
local rebirth         = "34AA8AEC"
local rebirthbots     = "8ae71fa2"
local refactorizationz= "54CFB955" -- NB: Alpha
local riflexl         = "759a8175"
local sentinelai      = "6eef2477"
local shine           = "706D242"
local shinediscord    = "70D6AF23" -- version from Meteru *for of las, las version is in potpourri
local shineepsilon    = "c6fbbb0"  -- part of potpourri
local shinepermute	  = "2ebedabc" -- part of potpourri
--local shineswitch     = "626fc17b"
local siegeshine      = "44D5BA1B"
local simpleshuffle   = "576F3068"
local smarter_mac     = "364799BA"
local spidergorge     = "82AB4CA9" -- updated version by Meterufa
local spookyghost	    = "5B44C62C"
local tbcb327         = "6184C0BA"
local teambalance     = "3250F1D6"
local tunnelinfest    = "89a5dc24" -- connect cysts to infested tunnels
local twibalance      = "7BED6299"
local twochannelpgs   = "4227EC52"
local unbalance       = "5517E2E2"
local unbalancenopres = "55730F92"
local uweextension    = "4241B84E"
local underdog        = "95382F96"
local walkthruallies  = "6425C240"
local wonitor         = "235ee3a6" -- part of potpourri
local siegeone        = 1926022367
local siegezero       = "51f2db08"
local siegebotstuff   = "73e86efc"
local ns1_siege005_2018 = "1713AD7C" -- part of siege cause of balance variables
local macmove         = "88fd08d1" -- aka balance changes from katzenfleisch
local meter           = "8d4db8e7"
local HigherHP30      = "901197AF" -- Increases hive/cc hp for 30%
local april1st        = "9193af4b" -- ready room crouch and jump tweaks
local WeaponCount     = "9382D348"  -- adds weapon/equipment counters to the armory and proto lab. No longer supported, implmented into the base game according to author
local revolver        = "99c779e7" -- scatter's revolver from Combat SA
local smg             = "99d33f34" -- scatter's smg
local shotgunlite     = "9ab7671e" -- twilite's fast shotgun
local shotgunplus     = "758aa9d8" -- minor buffs to shotgun
local intscorescreen  = "9b55583a"
local Devour          = "9c6cf28b"
local Katana          = "9D145A23"
local ScatterBalance  = "9e486da7"
local deathscreenfix= 2726158531
local mapcycle = {}
mapcycle.time  = 28
mapcycle.order = "random"

-- General Mods for every gametype
local mods = {
	--uweextension,
	--flamefix,  -- bundled with haggis 2021/09/04, added 12/08/2020
	haggis,
	--improvgorgespit,
    --iplimitfree, -- bundled with haggis 2021/09/04, added 16/01/2021 to remove IP limit
	--luaconfig,-- bundled with haggis 2021/09/04
	--disabledcom, -- bundled with haggis 2021/09/04
	--underdog, -- bundled with haggis 2021/09/04
	shine,
	-- shinediscord, -- bundled with haggis 2021/09/04
	--shineepsilon,-- bundled with haggis 2021/09/04 (only extrapips and enforcedteamsizes)
	--shinepermute,
	-- wonitor,-- bundled with haggis 2021/09/04
	april1st,
}
-- NS2 only mods
local mods_ns2 = {
    intscorescreen,
	--boombox,
	--buymenuhotkey, -- SRE errors since b337 /wooza
	--changeling,   -- new changeling lifeform, testing DISABLED September 2021
	--clogbalance, DISABLED PATCH 340
    --commtoys,	 
	--disco, -- disabled 2021/09/04 
	enhancedspec,
	gorgeenhanced,
	--gorgetoysbeta, DISABLED PATCH 340
	--fewerbuildrestr, -- 2021-10-02 disabled, probably allows to build outside of map even when not active
	--ragdoll,
	--ragdollenhanced,
	--shineswitch,
	--flamesentry,
	healfieldfast,
	--twibalance,  --DISABLED
	--hallucloudink, --temp disabled 2april 2021
	localtalk,
	--macmove, DISABLED
	meter,
	--teambalance, -- spawn locks if team has more players 22.06.21 DISABLED PATCH 340
	--onosrework,  DISABLED
	--resbalancer,	
	--smarter_mac,
	--persistminimap,
	pregamepeace,
	--tunnelinfest, -- DISABLED
	--balancebeta,
	--combatequipment,
	--meterufixes, DISABLED PATCH 340
	--HigherHP30, DISABLED September 2021
	--WeaponCount, DISABLED September 2021 (No longer supported)
	--prowler_tw, --disabled due to unbalance and possible errors 25/07/21 DISABLED PATCH 340
	--director, -- disabled 2021/09/04
	crayzmines,
	--pulsescan,

	--shotgunlite, DISABLED September 2021
	--shotgunplus,  --NEW DISABLED PATCH 340
	--factoryfix, DISABLED PATCH 340
	--ScatterBalance, DISABLED PATCH 340
	extraweapons,
	--deathscreenfix,
	revolver,
	cannon,
	smg,
	Devour,
	Katana
}

local mods_combat = {
	combatpp2,
	boombox,
	--changeling,   -- new changeling lifeform, testing
	--buymenuhotkey, -- broken patch 337
	--clogbalance, -- broken patch 337
	enhancedspec,
	gorgeenhanced,
	--gorgetoysbeta,
	localtalk, 
	ragdollenhanced,
	meter,
	fadevoidrocket,
	onosrework,  -- new onos mod
	personalshield,
	spidergorge,
	combatequipment,
	pulsescan,
	prowler_tw2,
	--shotgunlite,
	--shotgunplus,
	revolver,
	cannon,
	smg,
	Devour,
	Katana
}
local mods_gungame = {
	gungame,
	--ragdoll,
	boombox,
	localtalk, 
	pantsu,
	enhancedspec,
	ragdollenhanced,
}
local mods_infested = {
	--infested
	infestedfix,
}
local mods_laststand = {
	laststand,
	pantsu,
}
local mods_siege = {
	siegeone,
	meter,
	enhancedspec,
	localtalk
}
local mods_defense = {
  629502655,
	localtalk,
  extraweapons,
	--deathscreenfix,
  revolver,
  cannon,
  smg,
}
-- Goal is to mix combat and standard maps around the combat treshold "CT".
-- So from 0 -> CT we give combat maps a higher chance, and ns2 maps a lower chance!
-- CT -> 50 inverse, combat maps less chance, and ns2 higher chance.
--
-- 0 -> CT
--   combat maps chance stays as configured, max set to CT  if there min lies inside the range
--   ns2 maps, get there chance halfed and max set to CT if there min lies inside the range
--
-- CT -> 50
--   ns2 maps stay as configured
--   combat maps, get there chance halfed? and min set
-- If a map has a min or max making it fall outside of a range, it gets not add.
-- We do use the given chance as is for the higher values, we only manipulate chance for lowering it.
-- So shine mapvote plugin does not support the same mapname more then once, cause it uses the mapname as index in its tables.
-- Till that is better, just  set combat_treshold to 1000, so basically disabling it.
local combat_treshold = 1000
-- by how much shall the chance be changed
local chance_mod_combat = 1
local chance_mod_ns2 = 1
local chance_mod_infested = 0
local chance_mod_siege = 1
local chance_mod_laststand = 0

local vanillaMinPLayers = 12
local maps_ns2 = {
	-- **************************************** Official Maps ****************************************
	--{mods = {          }, map = "ns2_caged",           chance = 0.3, min = 0, rounds = 1}, --see ns2_cagedfree_farmfresh, Causes weird performance issues. 2021-04-28, seems to work better now? Perhaps Eclipse also fixed?
	{mods = {          }, map = "ns2_tanith",          chance = 0.8, min = vanillaMinPLayers, rounds = 1},
	{mods = {          }, map = "ns2_derelict",        chance = 0.3, min = vanillaMinPLayers, rounds = 1},
	{mods = {          }, map = "ns2_mineshaft",       chance = 0.1, min = vanillaMinPLayers, rounds = 1},
	{mods = {          }, map = "ns2_veil",            chance = 0.1, min = vanillaMinPLayers, rounds = 1},
	{mods = {          }, map = "ns2_biodome",         chance = 0.3, min = vanillaMinPLayers, rounds = 1},
	{mods = {          }, map = "ns2_kodiak",          chance = 0.0, min = vanillaMinPLayers, rounds = 1},
	{mods = {          }, map = "ns2_descent",         chance = 0.5, min = vanillaMinPLayers, rounds = 1},
	{mods = {          }, map = "ns2_docking",         chance = 0.1, min = vanillaMinPLayers, rounds = 1},
	{mods = {          }, map = "ns2_refinery",        chance = 0.5, min = vanillaMinPLayers, rounds = 1},
	--{mods = {          }, map = "ns2_eclipse",         chance = 0.2, min = 24, rounds = 1},
	{mods = {          }, map = "ns2_summit",          chance = 0.5, min = vanillaMinPLayers, rounds = 1},
	{mods = {          }, map = "ns2_unearthed",       chance = 0.5, min = vanillaMinPLayers, rounds = 1},
	{mods = {          }, map = "ns2_metro",           chance = 0.4, min = vanillaMinPLayers, rounds = 1},
	{mods = {          }, map = "ns2_origin",          chance = 0.5, min = vanillaMinPLayers, rounds = 1},
	-- **************************************** Custom Maps ****************************************
	--{mods = {"6e538c25"}, map = "ns2_cagedfree_farmfresh", chance = 0.4, min = vanillaMinPLayers,  rounds = 1}, -- Replaces caged to check about perf issues (wooza 2021-03)
	{mods = {"A0D51E0" }, map = "ns2_yana",            chance = 0.4, min = vanillaMinPLayers,  rounds = 1},
	--{mods = {"20FE55AD"}, map = "ns2_dmd_biodome",     chance = 0.2, min = vanillaMinPLayers,  rounds = 1}, -- it has dmd advertisements in it - disabled, Added 2021-04-28, easier for aliens to not lose agri.
	--{mods = {"765D1238"}, map = "ns2_veil_war_fine",   chance = 0.0, min = 45, rounds = 1},
	{mods = {"28ECB17C"}, map = "ns2_veil_prelude",    chance = 0.0, min = -1, rounds = 1},
	{mods = {"52D3C9F4"}, map = "ns2_veilveil",        chance = 0.0, min = 42, rounds = 1}, --removed, 65% alien win ratio despite biomass bug, kills server -way too often- White_magic spam nominate so it became 100%
	{mods = {"32459178"}, map = "ns2_eclipse_redux",   chance = 0.5, min = 42, rounds = 1}, -- Changed to 0.3
	{mods = {"6EC63E14"}, map = "ns2_legacy",          chance = 0.2, min = 42, rounds = 1},
	--{mods = {"644F3CB2"}, map = "ns2_Mineshaft_RE-Caved",  chance = 0.2, min = 45}, -- Extremly favoured for marines.
	--{mods = {"4657a139"}, map = "ns2_refinery_refined",chance = 0.3, min = vanillaMinPLayers, rounds = 1}, -- Removed because ns2_refinery is the exact same map.
	--{mods = {"763F1941"}, map = "ns2_dmd__refinery",   chance = 0.1, min = 12, rounds = 1},
	{mods = {"4B905FD1"}, map = "ns2_prison",          chance = 0.5, min = 42, rounds = 1},
	{mods = {"98EE90A0"}, map = "ns2_ayumi",          chance = 0.5, min = 42, rounds = 1},
	{mods = {"90720463"}, map = "ns2_deburred",          chance = 0.5, min = 42, rounds = 1},
	{mods = {"48B95C32"}, map = "ns2_tram_nextstop",   chance = 0.3, min = 16, rounds = 1},
	{mods = {"D2C2CBA" }, map = "ns2_T10",             chance = 0.1, min = 42, rounds = 1},
	{mods = {"266C0D1D"}, map = "ns2_stag",            chance = 0.2, min = 42, rounds = 1},
	{mods = {"2FA38A0D"}, map = "ns2_mesh",            chance = 0.2, min = 32, rounds = 1},
	{mods = {"1C9636C4"}, map = "ns2_TinCans_Station", chance = 0.4, min = 42, rounds = 1},
	{mods = {"26130594"}, map = "ns2_dark",            chance = 0.3, min = 42, rounds = 1},
	{mods = {"511389CB"}, map = "ns2_altair_beta",     chance = 0.3, min = 42, rounds = 1},
	{mods = {"18FA692C"}, map = "ns2_gorge",           chance = 0.2, min = 42, rounds = 1},
	{mods = {"8F1B64D" }, map = "ns2_fracture",        chance = 0.1, min = 42, rounds = 1},
	{mods = {"1C7AE717"}, map = "ns2_combi",           chance = 0.1, min = 42, rounds = 1},
	{mods = {"136D050A"}, map = "ns2_forgotten",       chance = 0.2, min = 42, rounds = 1},
	{mods = {"147B8E4B"}, map = "ns2_forge",           chance = 0.2, min = 42, rounds = 1},
	
	{mods = {"2B2C1394"}, map = "ns2_ora",             chance = 0.2, min = 42, rounds = 1},
	--{mods = {"5434F944"}, map = "ns2_orab",            chance = 0.2, min = 42, rounds = 1}, -- same as ora, but no center hive
	{mods = {"7B986F5" }, map = "ns2_jambi",           chance = 0.4, min = 16, rounds = 1},
	{mods = {"46F035A" }, map = "ns2_triad",           chance = 0.1, min = 42, rounds = 1},
	{mods = {"EB1AA55" }, map = "ns2_orbital",         chance = 0.2, min = 42, rounds = 1},
	{mods = {"D873977" }, map = "ns2_mineral",         chance = 0.2, min = 42, rounds = 1},
	{mods = {"48DF4ED3"}, map = "ns2_hydra_below",     chance = 0.4, min = 16, rounds = 1},
	{mods = {"17B0E28C"}, map = "ns2_nexus",           chance = 0.3, min = 42, rounds = 1},
	{mods = {"AAAC676" }, map = "ns2_fusion",          chance = 0.3, min = 42, rounds = 1},
	{mods = {"101b4e31"}, map = "ns2_Stratos",         chance = 0.4, min = 42, rounds = 1},
	{mods = {"16C11635"}, map = "ns2_gorgon",          chance = 0.3, min = 42, rounds = 1},
	{mods = {"1121d279"}, map = "ns2_spaceship",       chance = 0.1, min = 42, rounds = 1},
	{mods = {"D2B361D" }, map = "ns2_nothing",         chance = 0.1, min = 42, rounds = 1},
	--{mods = {"4D13E8A" }, map = "ns2_yakushima",         chance = 0.1, min = 42, rounds = 1},
	--{mods = {"18F937A0"}, map = "ns2_duckling2",       chance = 0.1, min = 42, rounds = 1},
	--{mods = {"7c78d1b6"}, map = "ns2_tow_refinery",    chance = 0.0, min = 42, rounds = 1},
	{mods = {"5F9CCF1" }, map = "ns2_icarus",          chance = 0.1, min = 42, rounds = 1},
	--{mods = {"2288DA28"}, map = "ns2_readyrooms",      chance = 0.0, min = 45, rounds = 1},
	--{mods = {"7c07b599"}, map = "ns2_tow_combi",       chance = 0.0, min = 16, max = 52, rounds = 1}, -- active in defense mod - do not enable here! 
	
	-- **************************************** FIVE Techpoint Maps ****************************************
	{mods = {"7BF85E12"}, map = "ns2_alterra",         chance = 0.1, min = vanillaMinPLayers, max = 42, rounds = 1}, -- Added map back to voting.
	{mods = {"FDF2C56" }, map = "ns2_veil_five",       chance = 0.4, min = 38, rounds = 1}, -- Increased from 0.1 to 0.2. Moved to "Five Techpoint"
	{mods = {"391E2CDB"}, map = "ns2_eclipse_five",    chance = 0.4, min = 42, rounds = 1},
	--{mods = {"4BC78185"}, map = "ns2_caged_five",      chance = 0.4, min = 42, rounds = 1},
	{mods = {"35CBB240"}, map = "ns2_derelict5",       chance = 0.4, min = 42, rounds = 1},
	{mods = {"57eb512a"}, map = "ns2_mineshaft_shafted",       chance = 0.4, min = 42, rounds = 1},
	{mods = {2729407046}, map = "ns2_Lithium",       chance = 0.4, min = 42, rounds = 1},
	
	-- **************************************** Secret Maps ****************************************
	-- NB: All maps below can *not* be voted for, only changed to
	-- by an admin through the !map command
	--{mods = {"1A6D72C7"}, map = "ns2_colosseum",       chance = 0.0, min = -1, max = -1, rounds = 1},
	--{mods = {"1ABCF3D9"}, map = "ns2_kleoss",          chance = 0.0, min = -1, max = -1, rounds = 1},
	--{mods = {"3505F78C"}, map = "ns2_docking_a",       chance = 0.0, min = -1, max = -1, rounds = 1},
	--{mods = {"F5E1AEF" }, map = "ns2_temple",          chance = 0.0, min = -1, max = -1, rounds = 1},
	--{mods = {"486CEF9" }, map = "ns2_turtle",          chance = 0.0, min = 32, rounds = 1},
	--{mods = {"E46200F" }, map = "ns2_docking228",      chance = 0.0, min = -1, max = -1, rounds = 1},
	--{mods = {"18EA38E7"}, map = "ns2_kodiak_v1",       chance = 0.0, min = -1, max = -1, rounds = 1},
	--{mods = {"17D96A17"}, map = "ns2_eon",             chance = 0.0, min = -1, max = -1, rounds = 1},
	--{mods = {"724E849" }, map = "ns2_drydosity",       chance = 0.0, min = -1, max = -1, rounds = 1},
	--{mods = {"89AD845" }, map = "ns2_uplift",          chance = 0.1, min = 42, rounds = 1}, -- 2021-09-26 Meteru, this map looks low quality
	--{mods = {"7404CFB" }, map = "ns2_honorguard",      chance = 0.0, min = -1, max = -1,   rounds = 1}, -- has a client error
    --{mods = {"210EDCB6"}, map = "ns2_tunnels",         chance = 0.0, min = -1, max = -1,   rounds = 1}, -- does not load
    --{mods = {"233C093A"}, map = "ns2_Unnamed",         chance = 0.0, min = -1, max = -1,   rounds = 1}, -- does not load
    --{mods = {"20D1707E"}, map = "ns2_discovery",       chance = 0.0, min = -1, max = -1,   rounds = 1}, -- unfinished map
    --{mods = {"3695254E"}, map = "ns2_legacy",          chance = 0.2, min = 40}, -- DMCA
    --{mods = {"36465ABB"}, map = "ns2_combat",          chance = 0.2, min = 40}, -- DMCA
    --{mods = {"27DD9F1C"}, map = "ns2_tvs",             chance = 0.0, min = -1, max = -1,   rounds = 1}, -- unfinished map
    --{mods = {"546DEEF" }, map = "ns2_plant",           chance = 0.0, min = -1, max = -1,   rounds = 1}, -- unfinished map
    --{mods = {"18C3D782"}, map = "ns2_eclipse_v2",      chance = 0.0, min = -1, max = -1, rounds = 1},
    --{mods = {"1737CD04"}, map = "ns2_eclipse_v1",      chance = 0.0, min = -1, max = -1, rounds = 1},
    --{mods = {"35896852"}, map = "ns2_goliathx",        chance = 0.0, min = 34, rounds = 1}, - this is broken, something with techpoints and round start
}

-- ****************************************Combat Maps****************************************
local maps_combat = {
    -- Combat:SA Maps
	{ map = "co_core",			    	mods = { "86B2ABA9"}, chance = 0.35, min = 0, max = 30, rounds = 1}, -- 5/5
	{ map = "co_angst",			        mods = { "91C78BE4"}, chance = 0.35, min = 0, max = 30, rounds = 1},
	{ map = "co_pulse",		        	mods = { "91C81F8E"}, chance = 0.35, min = 0, max = 30, rounds = 1},
	{ map = "co_sava",		        	mods = { "91C881E9"}, chance = 0.35, min = 0, max = 30, rounds = 1},
	{ map = "co_nest",			        mods = { "91CB4B9A"}, chance = 0.35, min = 0, max = 30, rounds = 1},
	{ map = "co_niveus",			    mods = { "8DE6CE2C"}, chance = 0.35, min = 0, max = 30, rounds = 1}, -- dmd ads
	{ map = "co_kestrel",		    	mods = { "92364B5D"}, chance = 0.35, min = 0, max = 30, rounds = 1},
    { map = "co_legacy",			    mods = { "53B898EE"}, chance = 0.35, min = 0, max = 30, rounds = 1},
    { map = "co_skyline",			    mods = { "80D9BF14"}, chance = 0.3, min = 0, max = 30, rounds = 1},
	{ map = "co_ayumi",			        mods = { 2726224024}, chance = 0.3, min = 0, max = 30, rounds = 1},
	{ map = "co_spacefall",			    mods = { "68B3B64E"}, chance = 0.2, min = 0, max = 30, rounds = 1},
	{ map = "co_volcanodrop",		    mods = { "692D1E72"}, chance = 0.3, min = 0, max = 30, rounds = 1},
	
	
	-- "Custom Maps"
	--{ map = "co_atcs",				mods = { "5228DF62"}, chance = 0.3, min = 0, max = 20, rounds = 1},
	--{ map = "co_ingress_beta",		mods = { "A43FF83" }, chance = 0.3, min = 0, max = 30, rounds = 1}, -- crap
	--{ map = "ns2_co_kestrel",		    mods = { "D13BE57" }, chance = 0.3, min = 0, max = 30, rounds = 1}, -- off
	--
	--{ map = "co_pump",				    mods = { "8605EFF7"}, chance = 0.3, min = 0, max = 30, rounds = 1},
	
	--{ map = "co_spacefall",			    mods = { "68B3B64E"}, chance = 0.1, min = 0, max = 30, rounds = 1},
	--{ map = "co_umbra",				mods = { "86087BE2"}, chance = 0.3, min = 0, max = 30, rounds = 1}, -- bots getting stuck
	--{ map = "co_volcanodrop",		    mods = { "692D1E72"}, chance = 0.3, min = 0, max = 30, rounds = 1},
	--{ map = "ns2_co_Bloomfield",	    mods = { "A16B6E3" }, chance = 0.1, min = 0, max = 30, rounds = 1}, -- unfinished texturing
	--{ map = "ns2_co_atles_amenon",	mods = { "751F6C5" }, chance = 0.1, min = 1, max = 30, rounds = 1}, -- off
	--{ map = "ns2_co_battlechamber",	mods = { "890BD4E" }, chance = 0.0, min = 0, max = 30, rounds = 1}, -- unbalanced, boring
	--{ map = "ns2_co_biodome",		    mods = { "52269BAD"}, chance = 0.2, min = 0, max = 30, rounds = 1},
	--{ map = "ns2_co_blackmesa",		    mods = { "52AB57AE"}, chance = 0.1, min = 0, max = 30, rounds = 1},
	--{ map = "ns2_co_combi",			    mods = { "7C8AB1C6"}, chance = 0.3, min = 0, max = 30, rounds = 1},
	--{ map = "ns2_co_descent",		    mods = { "80EF2E5" }, chance = 0.2, min = 0, max = 30, rounds = 1},
	--{ map = "ns2_co_fightbox",		mods = { "A42AA5A" }, chance = 0.1, min = 0, max = 8,  rounds = 1},
	--{ map = "ns2_co_hydra",			    mods = { "587C772B"}, chance = 0.3, min = 20, max = 30, rounds = 1},
	--{ map = "ns2_co_lunacy",		    mods = { "DCE8ABB" }, chance = 0.3, min = 0, max = 30, rounds = 1},
	--{ map = "ns2_co_nest",			mods = { "6B0711E" }, chance = 0.3, min = 0, max = 20, rounds = 1}, -- replaced by co_nest
	--{ map = "ns2_co_redemptioncombat",			mods = { "789D892" }, chance = 0.4, min = 0, max = 30, rounds = 1},
	--{ map = "ns2_co_courtyard",			mods = { "C7E6678" }, chance = 0.4, min = 0, max = 30, rounds = 1},
	
	--{ map = "ns2_co_portals",	    	mods = { "8E07AC8" }, chance = 0.1, min = 0, max = 30, rounds = 1},
	
	--{ map = "ns2_co_rockdown",	    	mods = { "5247ECDB"}, chance = 0.2, min = 0, max = 20, rounds = 1},
	-- { map = "ns2_co_sava",			mods = { "C38836D" }, chance = 0.2, min = 0, max = 30, rounds = 1}, -- original version of ns2_co_sava
	-- { map = "ns2_co_pulse",			mods = { "57C685F" }, chance = 0.2, min = 0, max = 30, rounds = 1}, -- replaced by co_pulse
	-- { map = "ns2_co_sava",		    	mods = { "587C981E"}, chance = 0.3, min = 0, max = 30, rounds = 1}, -- to be verified 	-- Added Sept 28 2020
	--{ map = "ns2_co_angst",			mods = { "89b2fa8" }, chance = 0.3, min = 0, max = 30, rounds = 1}, -- replaced by co_angst
	
	--{ map = "ns2_co_skylight",	    	mods = { "7B92D88" }, chance = 0.1, min = 0, max = 30, rounds = 1},
	--{ map = "ns2_co_stargate",	    	mods = { "7CAAC9A" }, chance = 0.1, min = 10, max = 30, rounds = 1}, --unbalanced
	--{ map = "ns2_co_tram_hub",	    	mods = { "66591C7" }, chance = 0.3, min = 0, max = 30, rounds = 1},
	--{ map = "ns2_co_twither",	    	mods = { "8F2CB50" }, chance = 0.1, min = 0, max = 10, rounds = 1},
	--{ map = "ns2_co_veilcombat",    	mods = { "662442F" }, chance = 0.2, min = 0, max = 30, rounds = 1},
	--{ map = "ns2_corridors",	    	mods = { "74E06DE" }, chance = 0.3, min = 0, max = 30, rounds = 1}, -- to be verified 	-- Added Sept 28 2020
	--{ map = "ns2_summitcombat",		mods = { "4FD7FD4" }, chance = 0.3, min = 0, max = 30, rounds = 1}, -- bots broken, disabled 4.6.2020
	
	--{ map = "co_capacity",		    	mods = { "86D05BD6"}, chance = 0.3, min = 0, max = 30, rounds = 1}, -- 3/5
	--{ map = "ns2_co_core",			mods = { "57F5F9A" }, chance = 0.3, min = 0, max = 30, rounds = 1}, -- replaced by co_core
	--{ map = "co_daimos",		    	mods = { "87B4CE2E"}, chance = 0.3, min = 0, max = 30, rounds = 1}, --
	--{ map = "ns2_co_faceoff",	    	mods = { "4D41F11" }, chance = 0.1, min = 0, max = 30, rounds = 1}, -- to be verified
	--{ map = "ns2_co_faceoff_ns1", 	mods = { "DE2D618" }, chance = 0.3, min = 0, max = 30, rounds = 1}, -- to be verified 	-- Added Sept 28 2020
	--{ map = "co_faceoffns1", 	    	mods = { "87762028" }, chance = 0.3, min = 0, max = 30, rounds = 1}, -- basically same as co_legacy
	--{ map = "ns2_co_ulysses",	    	mods = { "672f332" }, chance = 0.3, min = 0, max = 30, rounds = 1}, -- to be verified
	--{ map = "ns2_co_ulysses",	    	mods = { "858D4BB0"}, chance = 0.0, min = 0, max = 30, rounds = 1},
	--{ map = "co_ulysses2020", 		mods = { "873EAB6E" }, chance = 0.3, min = 0, max = 30, rounds = 1}, --
	--{ map = "co_recharge", 	    	mods = { "7E9152C3" }, chance = 0.3, min = 0, max = 30, rounds = 1}, -- bad gameplay
	--{ map = "co_labrats", 	    	mods = { "81B8A195" }, chance = 0.3, min = 0, max = 30, rounds = 1}, -- apparently no good
	
	
	-- ****************************************Combat Maps + Good old Entities****************************************
	--{ map = "co_chuteout_refined",	mods = { "6D23E6EC", oldent },	chance = 0.2, min = 0, max = 30, rounds = 1},
	--{ map = "co_iam_lemmings",		mods = { "157249F1", oldent },	chance = 0.0, min = 1, max = 30, rounds = 1}, -- off crappy map
	--{ map = "co_loltrain_revised",	mods = { "6C6F1145", oldent },	chance = 0.0, min = 1, max = 10, rounds = 1}, -- off -- crappy map
	--{ map = "ns2_co_hellevator",	    mods = { "82077B8", oldent },	chance = 0.0, min = 1, max = 40, rounds = 1}, -- off
}

local maps_gungame = {
	-- ****************************************Gun Game****************************************
	{mods = { "2e605072" },				map = "gg_lego_arena_sandstorm",	chance = 0.0, min = 1, max = 66, rounds = 1},
    --{mods = { gungame },				map = "gg_shelter", 			chance = 0.0, min = 4, max = 24, rounds = 2},
    --{mods = { gungame, "2685364C" },	map = "gg_mini_mario_2",		chance = 0.0, min = 1, max = 24, rounds = 1},
    --{mods = { gungame },	 			map = "gg_pyramid", 			chance = 0.0, min = 1, max = 32, rounds = 2},
    --{mods = { gungame },	 			map = "gg_match", 				chance = 0.0, min = 14, max = 32, rounds = 2},
    --{mods = { gungame },				map = "gg_basic", 				chance = 0.0, min = 1, max = 24, rounds = 2}
}

local maps_infested = {
	-- **************************************** Official Maps ****************************************
	{mods = {          }, map = "infest_caged",           chance = 0.1, min = 0, rounds = 3},
	{mods = {          }, map = "infest_derelict",        chance = 0.1, min = 0, max = 15, rounds = 3},
	{mods = {          }, map = "infest_mineshaft",       chance = 0.1, min = 0, rounds = 3},
	{mods = {          }, map = "infest_veil",            chance = 0.1, min = 0, rounds = 3},
	{mods = {          }, map = "infest_biodome",         chance = 0.1, min = 0, rounds = 3},
	{mods = {          }, map = "infest_kodiak",          chance = 0.1, min = 0, rounds = 3},
	{mods = {          }, map = "infest_descent",         chance = 0.1, min = 0, rounds = 3},
	{mods = {          }, map = "infest_docking",         chance = 0.1, min = 0, rounds = 3},
	{mods = {          }, map = "infest_summit",          chance = 0.1, min = 0, rounds = 3},
	{mods = {          }, map = "infest_unearthed",       chance = 0.0, min = 0, rounds = 3},
	{mods = {          }, map = "infest_origin",          chance = 0.1, min = 0, rounds = 3},
	-- **************************************** Custom Maps ****************************************
	{mods = {"A0D51E0" }, map = "infest_yana",            chance = 0.0, min = 0, rounds = 3}, -- Will cause UI bugs if mapvote from infest_yana to ns2_yana
	{mods = {"1C7AE717"}, map = "infest_combi",           chance = 0.0, min = 0, rounds = 3},
	--{mods = {"52D3C9F4"}, map = "infest_veilveil",            chance = 0.1, min = 42, rounds = 3} --bugged
}

local maps_siege = {
	--{mods = {"7F9F4E35"}, map = "ns1_aliensiege_2020b",           	chance = 0.2, min = 0, max = 40, rounds = 1}, -- "broken" not more info. Reduced to 0.2.
	--{mods = {"72cf6828"}, map = "ns1_beemersiege_2018a",           	chance = 0.2, min = 0, max = 52, rounds = 1},
	--{mods = {"7FA7B5D8"}, map = "ns1_beemersiege_2018b",           	chance = 0.2, min = 20, max = 52, rounds = 1},
	--{mods = {"303a5220"}, map = "ns1_climbsiege_2017b",           	chance = 0.1, min = 0, max = 52, rounds = 1},
	--{mods = {"5baab848"}, map = "ns1_darksiege_2018",           	chance = 0.1, min = 0, max = 52, rounds = 1}, -- missing textures - see through
	--{mods = {"732cca9c"}, map = "ns1_oh_no_more_sieges_2016a",      chance = 0.3, min = 0, max = 52, rounds = 1},
	--{mods = {"326be0ab"}, map = "ns1_powersiege_2017",           	chance = 0.2, min = 0, max = 52, rounds = 1}, 
	--{mods = {"737f2d4d"}, map = "ns1_siege005_2015c",           	chance = 0.1, min = 0, max = 52, rounds = 1},
	--{mods = {"7F91F1CF"}, map = "ns1_siege005_2020a",           	chance = 0.1, min = 0, max = 52, rounds = 1},
	--{mods = {"51f2db08"}, map = "ns1_supersiege_derp",          	chance = 0.1, min = 0, max = 52, rounds = 1}, -- frontdoor wall is "open
	--{mods = {"548ca540"}, map = "ns2_domesiege2_2015(1)",           chance = 0.0, min = 0, max = 52, rounds = 1}, -- siege room, com cannot build
	--{mods = {"2c9f8516"}, map = "ns2_hivesiege6_2017",           	chance = 0.2, min = 0, max = 52, rounds = 1},
	--{mods = {"732c86d2"}, map = "ns2_hivesiege_4-2015b",           	chance = 0.1, min = 0, max = 52, rounds = 1},-- bad chokepoints probably
	--{mods = {"7e3e5aa9"}, map = "ns2_unforgiving_siege_v00002",     chance = 0.1, min = 0, max = 52, rounds = 1},-- untextured
	--{mods = {"1a55cd41"}, map = "ns_chucksiege_remade",           	chance = 0.4, min = 0, max = 52, rounds = 1}, -- bad balance needs complete rework
	--{mods = {"143c73cc"}, map = "ns1_supersiege_2020a",           	chance = 0.4, min = 0, max = 52, rounds = 1},
	--{mods = {"3a1e617e"}, map = "sg_descent",           	chance = 0.4, min = 20, max = 40, rounds = 1},
	--{mods = {"4ce07743"}, map = "ns_interstellar_siege",           	chance = 0.1, min = 0, max = 40, rounds = 1}, -- Bunny's Map. Reduced to 0.1. Changed minimum to 0
	--{mods = {"36ee0585"}, map = "ns2_trimsiege",           	chance = 0.3, min = 0, max = 40, rounds = 1} -- Zycar's map  // "broken" not more info Reduced to 0.3.
	
	-- darksiege - this version i drew my own siege hall from marine res , that way aliens can also attack marine res if aliens have siege
	{mods = {"738070a3"}, map = "ns1_darksiege_2016b",           	chance = 0.3, min = 0, max = 40, rounds = 1},
	-- aliensiege - can still make modifications to this one tbh, but should still be good version for now maybe
	{mods = {"2d10f980"}, map = "ns1_aliensiege_2017",           	chance = 0.3, min = 0, max = 40, rounds = 1},
	-- birdsiege - this one is a classic in that one of the first few we ran on ns2, can still be updated to be more quality based-look better,lighting and such
	{mods = {"72cf6763"}, map = "ns1_birdsiege_2015",           	chance = 0.3, min = 0, max = 40, rounds = 1},
	-- space_cow - I think is a classic good stable map, still more detailing to do
	{mods = {"32504768"}, map = "ns1_space_cow_ranch_siege_2018",   chance = 0.3, min = 0, max = 40, rounds = 1},
	-- herosiege -  This one is one im also proud of 🙂
	{mods = {"1cce6296"}, map = "ns1_herosiege_r2016",  			chance = 0.3, min = 0, max = 40, rounds = 1},
	-- siege007 - This one is the most recognizable and best siege map to choose, kinda
	{mods = {"1713ad7c"}, map = "ns1_siege007_2018",   				chance = 0.3, min = 0, max = 40, rounds = 1},
	-- domesiege - There is LOTS of domesiege versions, this one I chose because near the start with less modifications, can work our way down the line
	{mods = {"548ca540"}, map = "ns2_domesiege2_2015a",   				chance = 0.3, min = 0, max = 40, rounds = 1},
	-- siege005 - version 2018 - this version i tried to go back to the version the author implied with less of my modifications - may be a bit small? (small map with big marine 2 room) deathmatch hectic confrontation
	{mods = {"1df12b9e"}, map = "ns1_siege005_2018",   				chance = 0.3, min = 0, max = 40, rounds = 1},
	-- fortsiege - I'd say this version is stable, I also have numerous versions of this map. In particular modifications to the marine side, should marines have access to siege from resource room? similar to darksiege with siege outside main base ? hm
	-- this version i added a siege for aliens to bile marine resources
	{mods = {"20a7c685"}, map = "ns1_fortsiege_2018",   			chance = 0.3, min = 0, max = 40, rounds = 1},
	-- trainsiege - this one allows aliens a 4th tech point similar to domesiege, some bad games can allow marines to push in, but can lead to good cliffhanger overall
	--{mods = {"72cf68a7"}, map = "ns2_trainsiege2_2018",   			chance = 0.3, min = 0, max = 40, rounds = 1}, -- cant cyst
	-- @Meteru  epicsiege i'm really proud of this one visually and gameplay wise, i had great memories on ns1 of this from turnip who made it so i did lots of tricks to get this one working , lots of detail here
	{mods = {"23fa4684"}, map = "ns1_epicsiege_2017",   			chance = 0.3, min = 0, max = 40, rounds = 1},
	--csiege is a classic for me. With the marines having their res inside lava room. this version i made the marine base in the lava room. I had to work a lot on alien siede re-drawing the halls from scratch.
	{mods = {"5bb47c1c"}, map = "ns1_csiege_2018",   				chance = 0.3, min = 0, max = 40, rounds = 1},
	
}

local maps_laststand = {
	{mods = {}, map = "ns2_ls_pad",           	chance = 0, min = 0, max = 12, rounds = 1},
	{mods = {"25E64DC3"}, map = "ns2_ls_hangar",           	chance = 0, min = 0, max = 12, rounds = 1},
	{mods = {"25E6451E"}, map = "ns2_ls_frost",           	chance = 0, min = 0, max = 12, rounds = 1},
	{mods = {"85E539B"}, map = "ns2_ls_hellevator",           	chance = 0, min = 0, max = 12, rounds = 1},
	{mods = {"25E6405A"}, map = "ns2_ls_descent",           	chance = 0, min = 0, max = 12, rounds = 1},
	{mods = {"261A4B61"}, map = "ns2_ls_storm",           	chance = 0, min = 0, max = 12, rounds = 1},
	{mods = {"261A4B61"}, map = "ns2_ls_eclipse",           	chance = 0, min = 0, max = 12, rounds = 1},
	{mods = {"2655cd48"}, map = "ns2_ls_traction",           	chance = 0, min = 0, max = 12, rounds = 1}
}
-- ****************************************Cycle Maps****************************************
--{"mods": [ "3fae8c7b", "334982d2" ],  "map": "ns2_biodome_cycle",      "chance": 0.0, "min": 0,  "max": 50},
--{"mods": [ "3fcc0055", "334982d2" ],  "map": "ns2_mineshaft_cycle",    "chance": 0.0, "min": 0,  "max": 50},
--{"mods": [ "3fa288ba", "334982d2" ],  "map": "ns2_caged_cycle",        "chance": 0.0, "min": 0,  "max": 50},
--{"mods": [ "3f986be0", "334982d2" ],  "map": "ns2_refinery_cycle",     "chance": 0.0, "min": 0,  "max": 50},
--{"mods": [ "3ef8beee", "334982d2" ],  "map": "ns2_descent_cycle",      "chance": 0.0, "min": 0,  "max": 50},
--{"mods": [ "3eeb1a80", "334982d2" ],  "map": "ns2_summit_cycle",       "chance": 0.0, "min": 0,  "max": 36},
--{"mods": [ "3edb09df", "334982d2" ],  "map": "ns2_tram_cycle",         "chance": 0.0, "min": 0,  "max": 50},
--{"mods": [ "3ec55d39", "334982d2" ],  "map": "ns2_docking_cycle",      "chance": 0.0, "min": 0,  "max": 50},
--{"mods": [ "3eb9ccfb", "334982d2" ],  "map": "ns2_kodiak_cycle",       "chance": 0.0, "min": 0,  "max": 50},
-- ****************************************TOW Maps****************************************
--{"mods": [ "397d9146", "334982d2"    ], "map": "ns2_tow_combi",	 	 "chance": 0.1, "min": 0,  "max": 100, "rounds": 1},
--{"mods": [ "AC3ACA4",  "334982d2"    ], "map": "ns2_tow_summit",	 "chance": 0.0, "min": 0,   "max": 100, "rounds": 1},
--{"mods": [ "3A0A2CFF", "334982d2"    ], "map": "ns2_tow_descent",	 "chance": 0.0, "min": 42,  "max": 100, "rounds": 1},
--{"mods": [ "0bc6ed6b", "334982d2"    ], "map": "ns2_tow_veil",		 "chance": 0.0, "min": 0,   "max": 100, "rounds": 1},
--{"mods": [ "396E7D93", "334982d2"    ], "map": "ns2_tow_refinery",	 "chance": 0.1, "min": 42,  "max": 100, "rounds": 1},
--{"mods": [ "3fb90249", "334982d2"    ], "map": "ns2_tow_biodome",	 "chance": 0.1, "min": 42,  "max": 100, "rounds": 1},
-- ****************************************Gorge Run****************************************
--{mods = {"33129be9", "3489c56f"}, map = "gr_hamhocks",				 chance = 0.7, min = 1, max = 18},
--{mods = {"33129be9", "35b3a708"}, map = "gr_baconbits",				 chance = 0.7, min = 1, max = 18},
--{mods = {"33129be9", "3402020d"}, map = "gr_warthog",				     chance = 0.7, min = 1, max = 18},
--{mods = {"33129be9", "3312A1C2"}, map = "gr_sowbelly",				 chance = 0.6, min = 1, max = 18},
-- ****************************************Gorge Run****************************************
--{mods =  { "cb225ba", "63e32e35"},  map =  "ns2_sws_metro",      			 chance = 0.3, min = 0,  max = 20},
--{mods =  { "1136E3AC", "63e32e35"}, map =  "ns2_sws_ffa_tram",      		 chance = 0.3, min = 0,  max = 20},
--{mods =  { "112F2A87", "63e32e35"}, map =  "ns2_sws_ffa_biodome",      	 chance = 0.3, min = 0,  max = 20 },
--{mods =  { "cb11261", "63e32e35"},  map =  "ns2_sws_refinery",      		 chance = 0.2, min = 0,  max = 20 },
--{mods =  { "D2BC6F4", "63e32e35"},  map =  "ns2_sws_sphere",      		 chance = 0.3, min = 0,  max = 20 },
--{mods =  { "D12B1E6", "63e32e35"},  map =  "ns2_sws_2gorge",      		 chance = 0.3, min = 0,  max = 20},
--{mods =  { "D1D175F", "63e32e35"},  map =  "ns2_sws_ikea",      			 chance = 0.4, min = 0,  max = 20},
--{mods =  { "1c8eea02", "63e32e35"},  map =  "ns2_sws_eden_fixed",      	 chance = 0.7, min = 0,  max = 20 },
--{mods =  { "D574214", "63e32e35"},  map =  "ns2_sws_gorgasm",      		 chance = 0.5, min = 0,  max = 20 },
--{mods =  { "d601408", "63e32e35"},  map =  "ns2_sws_xpress",      		 chance = 0.3, min = 0,  max = 20 },
--{mods =  { "D2E4E28", "63e32e35"},  map =  "ns2_sws_fissure",      		 chance = 0.3, min = 0,  max = 20},
--{mods =  { "103AFD31", "63e32e35"}, map =  "ns2_sws_rr",      			 chance = 0.7, min = 0,  max = 20}, --Unfinished


local maps_defense = {
	{mods = {"29552747"}, map = "ns2_def_troopers",           chance = 0.35, min = 0, max = 20, rounds = 1},
	{mods = {"9c4d87a1"}, map = "ns2_tow_summit",             chance = 0.4, min = 0, max = 20, rounds = 1},
	{mods = {"3fb90249"}, map = "ns2_tow_biodome",            chance = 0.4, min = 0, max = 20, rounds = 1},
	{mods = {"7c07b599"}, map = "ns2_tow_combi",              chance = 0.4, min = 0, max = 20, rounds = 1},
	{mods = {"9C577D72"}, map = "ns2_tow_stag",               chance = 0.4, min = 0, max = 20, rounds = 1},
	{mods = {"3A0A2CFF"}, map = "ns2_tow_descent",            chance = 0.4, min = 0, max = 20, rounds = 1},
	{mods = {"7C78D1B6"}, map = "ns2_tow_refinery",           chance = 0.4, min = 0, max = 20, rounds = 1},
	{mods = {"2c62070a"}, map = "ns2_kf_farm",                chance = 0.3, min = 0, max = 20, rounds = 1},
}

-- =====================================================================================================================
-- Config End
-- =====================================================================================================================
-- including mods which are valid for all game modes
mapcycle.mods = mods
local maps = {}
--
-- addMaps:
-- maps list to append to
-- newMaps list of maps to append to maps
-- newMods list of mods to append to maps which are add
-- threshold int the playerlimit for lower/upper bound chance
-- chanceModLower float 0-1, multiplicator for chance in 0-treshold
-- chanceModUpper float 0-1, multiplicator for chance in treshold-max
local function addMaps(maps, newMaps, newMods, threshold, chanceModLower, chanceModUpper)
	local maximum = 1000
	-- create some functions
	local function copyTable(inputTable)
		local outputTable = {}
		for _, row in ipairs(inputTable) do
			table.insert(outputTable, row)
		end
		return outputTable;
	end
	local function addTable(inputTable, appendTable)
		for _, row in ipairs(appendTable) do
			table.insert(inputTable, row)
		end
	end
	local function round(num, numDecimalPlaces)
		local mult = 10 ^ (numDecimalPlaces or 0)
		return math.floor(num * mult + 0.5) / mult
	end
	for i = 1, #newMaps do
		local entry = newMaps[i]
		if entry.map then
			-- copy of combat maps, for the combat playercountm reducing chance and adjusting max
			local min = entry.min or 0
			if min < threshold then
				local mods = copyTable(entry.mods)
				addTable(mods, newMods)
				local chance = entry.chance or 0.0
				local rounds = entry.rounds or 1
				local max
				if min >= 0 then
					-- covers min = -1 and max = -1
					max = entry.max or maximum
					if max > threshold then
						max = threshold
					end
				else
					max = entry.max or -1
				end
				if chance > 0 then
					chance = round(chance * chanceModLower, 1)
				end
				local options = {
						--type = "lower bound",
						mods = mods,
						map = entry.map,
						chance = chance,
						min = min,
						rounds = rounds
					}
				if (max ~= maximum) then
					options.max = max
				end
				if entry.percent then
					options.percent = entry.percent
				end
				table.insert(maps, options )
			end
			-- copy of ns2 maps, for the ns2 playercount only adjusting min
			local max = entry.max or maximum
			if maximum ~= max then
				if   max > (threshold + 1) then
					local mods = copyTable(entry.mods)
					addTable(mods, newMods)
					local chance = entry.chance or 0.0
					local rounds = entry.rounds or 1
					if min < (threshold + 1) then
						min = threshold + 1
					end
					if chance > 0 then
						chance = round(chance * chanceModUpper, 1)
					end
					local options = {
						--type = "upper bound",
						mods = mods,
						map = entry.map,
						chance = chance,
						min = min,
						max = max,
						rounds = rounds
					}
					if entry.percent then
						options.percent = entry.percent
					end
					table.insert(maps, options)
				end
			end
		end
	end
end

-- Last stand
--addMaps(maps, maps_laststand, mods_laststand, combat_treshold, 1, chance_mod_laststand)

-- Infested
addMaps(maps, maps_infested, mods_infested, combat_treshold, 1, chance_mod_combat)

-- Combat (broken)
addMaps(maps, maps_combat, mods_combat, combat_treshold, 1, chance_mod_combat)

-- Gun Game (broken)
--addMaps(maps, maps_gungame, mods_gungame, combat_treshold, 1, chance_mod_combat)

-- Vanilla 
addMaps(maps, maps_ns2, mods_ns2, combat_treshold, chance_mod_ns2, 1 )

-- Siege
addMaps(maps, maps_siege, mods_siege, combat_treshold, chance_mod_siege, 1 )

-- Defense
addMaps(maps, maps_defense, mods_defense, combat_treshold, chance_mod_siege, 1 )

mapcycle.maps = maps
return mapcycle