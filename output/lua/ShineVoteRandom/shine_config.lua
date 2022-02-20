local oldLoadfile = loadfile
function loadfile(filename, mode, env)
	if filename == 'lua/shine/extensions/voterandom/team_balance.lua' then
		filename = 'lua/shine/extensions/voterandom/team_balance_bob.lua'
	end
	return oldLoadfile(filename, mode, env)
end



local DefenseMaps = {
	ns2_def_troopers    = "Troopers",
	ns2_kf_farm         = "KF Farm",
	ns2_tow_biodome     = "TOW Biodome",
	ns2_tow_combi       = "TOW Combi",
	ns2_tow_summit 		= "TOW Summit",
	ns2_tow_summit_2021 = "TOW Summit",
	ns2_tow_stag        = "TOW Stag",
	ns2_tow_descent     = "TOW Descent",
	ns2_tow_refinery    = "TOW Refinery",
}

local SiegeMaps = {
	ns1_aliensiege_2017 = "Aliensiege",
	ns1_aliensiege_2020b = "Aliensiege",
	ns1_beemersiege_2018a = "Beemersiege",
	ns1_beemersiege_2018b = "Beemersiege",
	ns1_birdsiege_2015 = "Birdsiege",
	ns1_climbsiege_2017b = "Climbsiege",
	ns1_csiege_2018 = "Csiege",
	ns1_darksiege_2016b = "Darksiege",
	ns1_darksiege_2018 = "Darksiege",
	ns1_epicsiege_2017 = "Epicsiege",
	ns1_fortsiege_2018 = "Fortsiege",
	ns1_herosiege_r2016 = "Herosiege",
	ns1_oh_no_more_sieges_2016a = "Oh no more",
	ns1_powersiege_2017 = "Powersiege",
	ns1_siege005_2015c = "005",
	ns1_siege005_2018 = "005",
	ns1_siege005_2020a = "005",
	ns1_siege007_2018 = "007",
	ns1_space_cow_ranch_siege_2018 = "Space Cow Ranch",
	ns1_supersiege_2020a = "Supersiege",
	ns1_supersiege_derp = "Supersiege",
	ns2_domesiege2_2015a = "Domesiege",
	ns2_hivesiege6_2017 = "Hivesiege",
	ns2_trainsiege2_2018 = "Trainsiege",
	ns2_trimsiege = "Trimsiege",
	ns2_unforgiving_siege_v00002 = "Unforgiving",
	ns_chucksiege_remade = "Chucksiege remade",
	ns_interstellar_siege = "Interstellar",
	sg_descent = "Descent",
}

Shine.Hook.Add( "OnGetNiceMapName", "MyGetNiceMapName", function( MapName)
	if DefenseMaps[MapName] ~= nil then
		return "Defense: " .. DefenseMaps[MapName]
	end
	if SiegeMaps[MapName] ~= nil then
		return "Siege: " .. SiegeMaps[MapName]
	end
	return false
end )