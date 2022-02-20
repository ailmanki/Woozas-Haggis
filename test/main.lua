-- Splits player data into teams
local function getTeam(i_players, teamName, maxPlayers)
	maxPlayers      = maxPlayers or math.huge
	local team      = {}
	for _, v in ipairs(i_players) do
		if (v.pref == 1) then
			print(v.name)
			v.pref = "marine"
		end
		if (v.pref == 2) then
			v.pref = "alien"
		end
		if v.pref == nil then
			v.pref = "none"
		end
		if v.pref == teamName then
			if maxPlayers > #team then
				if v.marine == 0 then
					v.marine = 4000
				end
				if v.alien == 0 then
					v.alien = 4000
				end
				table.insert(team, v)
			else
				v.pref = "none"
			end
		else
		
		end
	end
	return team
end


---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------

local maxPlayersDefault  = 44

local bobshuffle = require('bobshuffle')

-- Prepare team data for shuffling
local sampledata     = require('sampledata')
for file in io.popen([[dir "C:\ns2mods\ns2_haggis\test\voterandom\" /b]]):lines() do
	if string.find(file, ".json") then
		if  file == 'test.json'
			--or file == '20220108202111_44_input.json'
			--	or file == '20220108220845_40_input.json'
			--	or file == '20220108232601_42_input.json'
			--	or file == '20220109002015_34_input.json'
			--	or file == '20220109003333_27_input.json'
			--	or file == '20220109194055_32_input.json'
			--	or file == '20220109195432_42_input.json'
			--	or file == '20220109224344_35_input.json'
		
		then
			--local i_players  = sampledata.s48 -- 10 marines, 20 aliens, 18 rr
			--local i_players  = sampledata.s44 -- 22 marines, 22 aliens, 00 rr
			--local i_players = sampledata.s44_alien_max_2000 -- 22 marines, 22 aliens, max 2000 skill on alien
			--local i_players = sampledata.s44_marine_max_2000 -- 22 marines, 22 aliens, max 2000 skill on marines
			--local i_players = sampledata.s9 -- 5 marines, 4 aliens,
			--local i_players = sampledata.s43 -- 22 marines, 21 aliens,
			--local i_players = sampledata.s23 -- 12 marines, 11 aliens,
			--local i_players = sampledata.s44_allsame -- all 5000 skill
			--local i_players = sampledata.s43_allsame -- all 5000 skill
			--local i_players = sampledata.r_1 -- 22 marines, 21 aliens,
			local i_players  = sampledata(file)
			local playerCount = #i_players
			local maxPlayers
			if (playerCount < maxPlayersDefault) then
				maxPlayers = playerCount
			else
				maxPlayers = maxPlayersDefault
			end
			local maxPlayersTeam
			if maxPlayers > 10 then
				if (maxPlayers % 2 == 0) then
					maxPlayersTeam = math.floor(maxPlayers / 2)
				else
					maxPlayersTeam = math.ceil(maxPlayers / 2)
				end
				
			
			
				-- t0 is non-afk ready room players
				-- t1 is marines
				-- t2 is alien
				local teamMarine = getTeam(i_players, "marine", maxPlayersTeam)
				local teamAlien  = getTeam(i_players, "alien", maxPlayersTeam)
				local teamNone   = getTeam(i_players, "none")
				
				-- helper function to show informations about the teams created
			
				local text, m_marineMean, m_alienMean, v_marineVariance, v_alienVariance, v_marineSkewness, v_alienSkewness, asymmetryTeams = bobshuffle.showTeams(teamNone, teamMarine, teamAlien)
			
				--print(text)
				local start_time = os.clock()
				bobshuffle.main(teamNone, teamMarine, teamAlien, maxPlayersTeam)
				local end_time = os.clock()
				print(bobshuffle.showTeams(teamNone, teamMarine, teamAlien))
				
				print("Maxplayers: "..maxPlayersTeam)
				--print(text)
				--print("time spent: " .. (end_time - start_time) .. "sec")
				--end
			end
		end
	end
end