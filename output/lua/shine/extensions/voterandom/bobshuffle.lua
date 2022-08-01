-- computes the mean value of team members skills
local function mean(i_players, t_team)
	local sum = 0
	for _, v in ipairs(i_players) do
		sum = sum + v[t_team]
	end
	if sum == 0 then
		return 0
	else
		return sum / #i_players
	end
end

-- computes the variance of team members skills, using a previously computed mean(average) m
-- Use the classic variance definition from https://en.wikipedia.org/wiki/Variance
-- function taken from https://github.com/Bytebit-Org/lua-statistics/blob/master/src/statistics.lua#L119
local function variance(i_players, t_team, m_teamMean)
	local varianceSum = 0
	for _, v in ipairs(i_players) do
		local difference = v[t_team] - m_teamMean
		varianceSum = varianceSum + (difference * difference)
	end
	-- this test is costly here (because nested in loops ultimately)
	-- could be removed by avoiding shuffling when too few players are present
	if varianceSum == 0 then
		return 0
	else
		return varianceSum / (#i_players - 1) -- usual definition of variance (usual bias)
	end
end

-- Counts how many players are unhappy with the team
-- the more unhappy the more it tends to 1
local function unhappiness(i_players, t_team)
	local sum = 0
	for _, v in ipairs(i_players) do
		if v.pref ~= t_team then
			sum = sum + 1
		end
	end
	if sum == 0 then
		return 0
	else
		return sum / #i_players
	end
end

-- computes the skewness of team members skills, using a previously computed mean and variance.
-- Use Fisher’s moment coefficient of skewness at https://en.wikipedia.org/wiki/ Skewness.
-- Avoid useless computations (mostly redundant divisions) by using the expanded formula
local function skewness(i_players, t_team, m_teamAverage, v_teamVariance)
	local cube = 0
	for _, v in ipairs(i_players) do
		cube = cube + (v[t_team] * v[t_team] * v[t_team])
	end
	-- if non-positive, then we don't have enough data / players
	-- this test is costly here (because nested in loops ultimately)
	-- could be removed by avoiding shuffling when too few players are present
	
	cube = cube / #i_players
	return (cube - 3 * m_teamAverage * v_teamVariance - m_teamAverage * m_teamAverage * m_teamAverage) / (math.sqrt(v_teamVariance) * v_teamVariance)
end

-- computes a kind of relative gap between two values.
-- This function must return 0 if values are equal, it must get near 1 when values are different.
-- It must accounts for o negative values because skewness values can be negative and of opposite signs.
-- A proposed formula for such a function is:
-- relative(x,y) = |x−y| / |x|+|y|+|x+y|
-- I made it up to be able to 0compare moves later, check this choice on wolfram alpha for instance to get an
-- idea of how it works. In the case of the denominator being too small (< 10 −12 for instance); just
-- return 0 because it means that both values are really low and negligible for our purposes.
local abs = math.abs
local function relative(x, y)
	
	local denominator = abs(x) + abs(y) + abs(x + y)
	-- really 1e-12 should be small enough given test data skewness, we simply want to avoid dividing by zero
	-- we also want "continuity" in zero of this function for x=y
	-- this (costly because ultimately nested in loops) test could be removed by ensuring we never shuffle with too few players
	-- then we would always have non-zero variance/skewness and computations could be performed without risk
	if 1e-12 < denominator then
		return abs(x - y) / denominator
	else
		return 0
	end
end

local boostMean = 5
local boostVariance = 1
local boostSkewness = 1
local boostUnhappiness = 1.41
-- computes a coefficient that gets higher the more the teams are unbalanced.
-- The more the skill distributions are similar in terms of mean, variance, skewness (not necessarily normal
-- distribution, simply alike), the lower the coefficient gets.
--
-- This function will be used to choose what player swaps/switches to make later on.
-- Its results is between 0 (perfect equality) and 3 (worst case).
-- In theory, returning only relative(s1,s2) should work to choose moves that can
-- balance teams because it contains the mean and variance. But for safety, we
-- put an emphasis on balance average skill and variance on their own.
--[[local function asymmetry(t1, t2)
	local m1 = mean(t1, "marine")
	local m2 = mean(t2, "alien")
	local v1 = variance(t1, "marine", m1)
	local v2 = variance(t2, "alien", m2)
	local s1 = skewness(t1, "marine", m1, v1)
	--local s2 = skewness(t2, "alien", m2, v1)
	local s3 = skewness(t2, "alien", m1, v2)
	return relative(m1, m2)*boostMean + relative(v1, v2)*boostVariance + relative(s1, s3)*boostSkewness
end]]

local function asymmetryCompare(oldAsymmetry, t1, t2)
	
	local h1 = unhappiness(t1, 1)
	local h2 = unhappiness(t2, 2)
	local r0= relative(h1, h2)
	local unhappy =  r0 + ((h1 + h2) * boostUnhappiness)
	
	if false ~= oldAsymmetry and unhappy > oldAsymmetry then
		return unhappy
	end
	
	local m1 = mean(t1, "marine")
	local m2 = mean(t2, "alien")
	local r1 = relative(m1, m2)*boostMean
	if false ~= oldAsymmetry and unhappy + r1 > oldAsymmetry then
		return unhappy + r1
	end
	local v1 = variance(t1, "marine", m1)
	local v2 = variance(t2, "alien", m2)
	local r2 = relative(v1, v2)*boostVariance
	if false ~= oldAsymmetry and unhappy + r1 + r2 > oldAsymmetry then
		return unhappy + r1 + r2
	end
	local s1 = skewness(t1, "marine", m1, v1)
	local s2 = skewness(t2, "alien", m2, v2)
	return unhappy + r1 + r2 + relative(s1, s2)*boostSkewness
end

local function asymmetryInit(oldAsymmetry, t1, t2)
	-- sort players in decreasing skill of their team in both teams
	local marineSkill = {}
	local alienSkill = {}
	for _, v in ipairs(t1) do
		table.insert(marineSkill, v.marine)
	end
	for _, v in ipairs(t2) do
		table.insert(alienSkill, v.alien)
	end
	table.sort(marineSkill, function(k1, k2)
		return k1 > k2
	end)
	table.sort(alienSkill, function(k1, k2)
		return k1 > k2
	end)
	local asym = 0
	-- loop but forget the last one of the largest team if there is one
	-- because that player is lowest skill and matters less
	local count = math.min(#marineSkill, #alienSkill)
	for i = 1, count do
		asym = asym + relative(marineSkill[i], alienSkill[i])
	end
	return asym
end

-- little helper to swap players
local function swapPlayers(t1, t2, i, j)
	local tmp = t1[i] -- only one temporary variable should work from my understanding of lua references/copy
	t1[i] = t2[j]
	t2[j] = tmp
end

-- It must basically keep swapping players between teams until no better swap is found.
-- So it has three nested loops, an external while loop, and two internal for
-- loops over t 1 and t 2 respectively. Inside the nested for loops, try swapping two
-- players and evaluate asymmetry(t 1 ,t 2 ) with the new teams. Once all possible
-- swaps have been evaluated, apply the best one, the one minimizing asymmetry.
-- Break off the while loop once no better swap can be found.
local function swap(asymmetryFunc, t1, t2)
	local iteration = 0
	local old_asym = 600 -- impossible worst initial value to enter loop once at least
	local new_asym = asymmetryFunc(false, t1, t2) -- current value, before any swap
	local count1 = #t1 -- players in team1
	local count2 = #t2 -- players in team2 (actually same as team 1 but could be different if we implement no switch() function)
	local i_index = -1 -- impossible initial index
	local j_index = -1 -- impossible initial index
	
	-- really forget about iter for now
	-- later count iterations with a global variable if performance is bad to see what is a problem
	while (new_asym < old_asym) do
		-- while we find a move to improve balance
		old_asym = new_asym
		for i = 1, count1 do
			-- loop over team 1 players
			for j = 1, count2 do
				if (t1[i].commander == false and t2[j].commander == false) then
					-- loop over team 2 players
					-- swap players i and j of teams 1 and teams 2 respectively
					-- something like t1[i], t2[j] = t2[j], t1[i]
					swapPlayers(t1, t2, i, j)
					-- recompute asymmetry of the teams with the swapped players to see if it’s lower
					local cur_asym = asymmetryFunc(new_asym, t1, t2)
					if cur_asym < new_asym then
						-- if we found a lower asym we save the swap to make to get it
						new_asym = cur_asym -- we save the better asym to get only the best move
						i_index = i
						j_index = j
					end
					-- restore the teams to their original state to try other moves
					-- something like t1[i], t2[j] = t2[j], t1[i]
					swapPlayers(t1, t2, i, j)
				end
			end
		end
		-- i think you moved indexes declaration out of the loop so it must now become:
		-- (otherwise indexes will always be initialized to some value once a move was found in a previous iteration)
		if new_asym < old_asym then
			-- we know there is a better move not thanks to indexes but lower asym
			-- swap (i_index player on team 1 with j_index player on team 2) something like t1[i_index], t2[j_index] = t2[j_index], t1[i_index]
			swapPlayers(t1, t2, i_index, j_index)
		else
			break -- to avoid double testing the same (new_asym < old_asym) in "while (...) do"
		end
		if iteration > 10000 then
			break
		end
		iteration = iteration + 1
	end
end

local function swapPairs(asymmetryFunc, t1, t2)
	local iteration = 0
	local old_asym = 600 -- impossible worst initial value to enter loop once at least
	local new_asym = asymmetryFunc(false, t1, t2) -- current value, before any swap
	local count1 = #t1 -- players in team1
	local count2 = #t2 -- players in team2 (actually same as team 1 but could be different if we implement no switch() function)
	local i_index = -1 -- impossible initial index
	local j_index = -1 -- impossible initial index
	local k_index = -1 -- impossible initial index
	local l_index = -1 -- impossible initial index
	
	-- really forget about iter for now
	-- later count iterations with a global variable if performance is bad to see what is a problem
	while (new_asym < old_asym) do
		-- while we find a move to improve balance
		old_asym = new_asym
		for i = 1, math.ceil(count1/2) do
			-- loop over team 1 players
			for j = 1, math.ceil(count2/2) do
				
				if (t1[i].commander == false and t2[j].commander == false) then
					-- loop over team 2 players
					-- swap players i and j of teams 1 and teams 2 respectively
					-- something like t1[i], t2[j] = t2[j], t1[i]
					swapPlayers(t1, t2, i, j)
					for k = math.floor(count1/2), count1 do
						if (k ~= i) then
							-- loop over team 1 players
							for l = math.floor(count2/2), count2 do
								if (l ~= j) then
									if (t1[k].commander == false and t2[l].commander == false) then
										-- loop over team 2 players
										-- swap players i and j of teams 1 and teams 2 respectively
										-- something like t1[i], t2[j] = t2[j], t1[i]
										swapPlayers(t1, t2, k, l)
										-- recompute asymmetry of the teams with the swapped players to see if it’s lower
										local cur_asym = asymmetryFunc(new_asym, t1, t2)
										if cur_asym < new_asym then
											-- if we found a lower asym we save the swap to make to get it
											new_asym = cur_asym -- we save the better asym to get only the best move
											i_index = i
											j_index = j
											k_index = k
											l_index = l
										end
										-- restore the teams to their original state to try other moves
										-- something like t1[i], t2[j] = t2[j], t1[i]
										swapPlayers(t1, t2, k, l)
									end
								end
							end
						end
					end
					-- restore the teams to their original state to try other moves
					-- something like t1[i], t2[j] = t2[j], t1[i]
					swapPlayers(t1, t2, i, j)
				end
			end
		end
		-- i think you moved indexes declaration out of the loop so it must now become:
		-- (otherwise indexes will always be initialized to some value once a move was found in a previous iteration)
		if new_asym < old_asym then
			-- we know there is a better move not thanks to indexes but lower asym
			-- swap (i_index player on team 1 with j_index player on team 2) something like t1[i_index], t2[j_index] = t2[j_index], t1[i_index]
			swapPlayers(t1, t2, i_index, j_index)
			swapPlayers(t1, t2, k_index, l_index)
		else
			break -- to avoid double testing the same (new_asym < old_asym) in "while (...) do"
		end
		if iteration > 10000 then
			break
		end
		iteration = iteration + 1
	end
end
local function pick_loop(asymmetryFunc, t0, t1, t2, n)
	-- we need n to get the right team skill but makes code look horrible
	local old_asym = 3 -- impossibly bad value because we just look for the best pick but we have to pick anyways...
	-- ... so since we have to pick, we allow a higher asym even if we try to minimize asym with a pick
	local index = -1 -- impossible value to initialize
	local count0 = #t0
	for k = 1, count0 do
		-- try to add any player from RR to smallest team
		-- append t0[k] to smallest team
		if n == 1 then
			-- we add to team1
			-- add the k-th player to team 1
			table.insert(t1, t0[k])
		else
			-- we add to team2
			-- add the k-th player to team 2
			table.insert(t2, t0[k])
		end
		local cur_asym = asymmetryFunc(old_asym, t1, t2) -- recompute asymmetry with the new teams
		if cur_asym < old_asym then
			-- if we found a better pick to balance out
			index = k -- we save the index of the player to add
			old_asym = cur_asym -- to minimize asymmetry
		end
		-- restoring teams before looping over to try another pick:
		if n == 1 then
			-- we need to pop out team 1 the added player
			-- pop out code
			table.remove(t1)
		else
			-- we need to pop out team 2 the added player
			-- pop out code
			table.remove(t2)
		end
	end
	-- append saved best pick to smallest team:
	-- a pick should always be found because initial asym is 3 and teams were checked in parent function
	if n == 1 then
		table.insert(t1, t0[index])
	else
		table.insert(t2, t0[index])
	end
	
	-- remove t0[index] player from t0 table
	table.remove(t0, index)
end

-- takes non-afk ready room players and fills up the teams if these are not full already. Loop over available
-- ready room players and evaluate asymmetry(t 1 ,t 2 ) with the added player to
-- the team with fewer players. Once all possible picks have been evaluated, apply
-- the best one, the one that minimizes asymmetry. Keep doing that until teams
-- are full or no players are available.
--
-- picking players from ready room to minimize asymmetry
-- at some point check that #ti =< #tmax
local function pick(asymmetryFunc, t0, t1, t2, maxPlayersTeam)
	local iteration = 0
	-- as long as we have available players and teams that are not full
	while 0 < #t0 and (#t1 < maxPlayersTeam or #t2 < maxPlayersTeam) do
		-- which team has less players?
		if #t1 < #t2 then
			-- adding to team 1
			pick_loop(asymmetryFunc, t0, t1, t2, 1)
		else
			-- adding to team2 also default
			-- could be improved by adding to the team that balances it out better
			-- would need an entirely new function as a default case
			pick_loop(asymmetryFunc, t0, t1, t2, 2)
		end
		if iteration > 1000 then
			break
		end
		iteration = iteration + 1
	end
end

-- a common function that switches player from larger team to smaller one
-- takes old_asym as a constraint to choose a pick
-- returns the new_asym as well
local function switch_loop(asymmetryFunc, t1, t2, n, old_asym)
	local new_asym = old_asym -- init with current asymmetry state (may be redundant)
	local index = -1 -- impossible negative value to test later
	if n == 1 then
		-- we are adding to team 1 from team 2
		local count2 = #t2
		for j = 1, count2 do
			--looping over team 2
			if (t2[j].commander == false) then
				table.insert(t1, t2[j]) -- adding t2[j] to t1
				table.remove(t2, j)
				local cur_asym = asymmetryFunc(new_asym, t1, t2) -- compute new asymmetry
				if cur_asym < new_asym then
					-- is it better?
					new_asym = cur_asym -- save the new lowest asym
					index = j -- save the best player to switch index
				end
				-- restore teams as they were to try new switches
				table.insert(t2, j, t1[#t1])
				table.remove(t1)
			end
		end
		if 0 < index then
			-- we found a switch to make so apply it
			table.insert(t1, t2[index]) -- add player to team 1 from team 2
			table.remove(t2, index) -- remove t2[index] player from team 2
		end
	else
		-- we are adding to team 2 from team 1
		local count1 = #t1
		for i = 1, count1 do
			--looping over team 1
			if (t1[i].commander == false) then
				table.insert(t2, t1[i]) -- adding t2[j] to t1
				table.remove(t1, i)
				
				local cur_asym = asymmetryFunc(new_asym, t1, t2) -- compute new asymmetry
				if cur_asym < new_asym then
					-- is it better?
					new_asym = cur_asym -- save the new lowest asym
					index = i -- save the best player to switch index
				end
				-- restore teams as they were to try new switches
				table.insert(t1, i, t2[#t2])
				table.remove(t2)
			end
		end
		if 0 < index then
			-- we found a switch to make so apply it
			table.insert(t2, t1[index]) -- add player to team 2 from team 1
			table.remove(t1, index) -- remove t1[index] player from team1
		end
	end
	return new_asym
end

-- a function to switch players while caring for a lower asymmetry
local function switch(asymmetryFunc, t1, t2)
	local iteration = 0
	local old_asym = 3
	local new_asym = asymmetryFunc(false, t1, t2)
	while (new_asym < old_asym) do
		-- while we find an optimization to make
		old_asym = new_asym -- update to break off if needed
		if #t1 < #t2 then
			-- which team has less players
			new_asym = switch_loop(asymmetryFunc, t1, t2, 1, old_asym) -- adding to team 1 from team 2, if we can also lower asymmetry
		
		else
			new_asym = switch_loop(asymmetryFunc, t1, t2, 2, old_asym) -- adding to team 2 from team 1, if we can also lower asymmetry
		
		end
		if iteration > 1000 then
			break
		end
		iteration = iteration + 1
	end
end

-- here we balance the number of players even if we get a worse (an higher) asymmetry because it's more important
-- but we still try to minimize the asymmetry we get in switch_loop()

local function move(asymmetryFunc, t1, t2)
	local iteration = 0
	while 1 < math.abs(#t1 - #t2) do
		-- while teams are too unbalanced in terms of #players
		-- the 3 variable is ignored, because switch_loop returns a useless new asymmetry in this case
		if #t1 < #t2 then
			-- if team2 has more players than team1
			switch_loop(asymmetryFunc, t1, t2, 1, 3) -- add to team 1 from team 2 with initial asym very high because we don't care yet
		else
			switch_loop(asymmetryFunc, t1, t2, 2, 3) -- add to team 2 from team 1 with initial asym very high because we don't care yet
		end
		if iteration > 1000 then
			break
		end
		iteration = iteration + 1
	end
end

local function main(t0, t1, t2, maxPlayersTeam)
	local testNewAsym = true
	
	if testNewAsym then
		pick(asymmetryInit, t0, t1, t2, maxPlayersTeam)
		if #t1 == #t2 then
			swap(asymmetryInit, t1, t2) -- we swap to balance, #t1 == #t2 remains true
			--swap(asymmetryInit, t1, t2)
			swap(asymmetryCompare, t1, t2) -- we swap to balance, #t1 == #t2 remains true
			swapPairs(asymmetryCompare, t1, t2)
			--  swap(asymmetryCompare, t1, t2) -- we swap to balance, #t1 == #t2 remains true
			--swapPairs(asymmetryCompare, t1, t2)
		else
			move(asymmetryInit, t1, t2) -- balances number of players between teams until |#t1 - #t2| == 1 is true
			switch(asymmetryInit, t1, t2) -- may change #t1 and #t2, but |#t1 - #t2| == 1 remains true
			--switch(asymmetryCompare, t1, t2) -- may change #t1 and #t2, but |#t1 - #t2| == 1 remains true
			
			swap(asymmetryInit, t1, t2) -- we swap to balance, #t1 == #t2 remains true
			--swapPairs(asymmetryInit, t1, t2)
			swap(asymmetryCompare, t1, t2) -- we swap to balance, #t1 == #t2 remains true
			swapPairs(asymmetryCompare, t1, t2)
			--swapPairs(t1, t2)
			--swap(t1, t2) -- we swap to balance, #t1 == #t2 remains true
		end
	else
		pick(asymmetryCompare, t0, t1, t2, maxPlayersTeam)
		if #t1 == #t2 then
			swapPairs(asymmetryCompare, t1, t2)
			swap(asymmetryCompare, t1, t2) -- we swap to balance, #t1 == #t2 remains true
		else
			move(asymmetryCompare, t1, t2) -- balances number of players between teams until |#t1 - #t2| == 1 is true
			switch(asymmetryCompare, t1, t2) -- may change #t1 and #t2, but |#t1 - #t2| == 1 remains true
			
			swap(asymmetryCompare, t1, t2) -- we swap to balance, #t1 == #t2 remains true
			swapPairs(asymmetryCompare, t1, t2)
			swap(asymmetryCompare, t1, t2) -- we swap to balance, #t1 == #t2 remains true
			--swapPairs(t1, t2)
			--swap(t1, t2) -- we swap to balance, #t1 == #t2 remains true
		end
	end
	return t0, t1, t2
end

local function showTeams(t0, t1, t2)
	-- strpad left function
	local function lpad (s, l)
		s = s .. ""
		local res = string.rep(' ', l - #s:gsub('[\128-\191]', '')) .. s
		return res, res ~= s
	end
	
	local h_marineUnhappiness = unhappiness(t1, 1)
	local h_alienUnhappiness = unhappiness(t2, 2)
	local r0 = relative(h_marineUnhappiness, h_alienUnhappiness)
	
	local m_marineMean = mean(t1, "marine")
	local m_alienMean = mean(t2, "alien")
	local r1 = relative(m_marineMean, m_alienMean)
	local v_marineVariance = variance(t1, "marine", m_marineMean)
	local v_alienVariance = variance(t2, "alien", m_alienMean)
	local r2 = relative(v_marineVariance, v_alienVariance)
	local v_marineSkewness = skewness(t1, "marine", m_marineMean, v_marineVariance)
	local v_alienSkewness = skewness(t2, "alien", m_alienMean, v_alienVariance)
	local r3 = relative(v_marineSkewness, v_alienSkewness)
	local asymmetryTeams = asymmetryCompare(false, t1, t2)
	local asymmetryInitTeams = asymmetryInit(false, t1, t2)
	local text = ''
	text = text .. "Unhappiness Relative: " .. string.format("%.5f", r0) .. "\n"
	text = text .. "Marine Unhappiness: " .. string.format("%.5f", h_marineUnhappiness) .. "\n"
	text = text .. "Alien Unhappiness: " .. string.format("%.5f", h_alienUnhappiness) .. "\n"
	
	text = text .. "Mean Relative: " .. string.format("%.5f", r1) .. "\n"
	text = text .. "Marine Mean: " .. string.format("%.5f", m_marineMean) .. "\n"
	text = text .. "Alien Mean: " .. string.format("%.5f", m_alienMean) .. "\n"
	
	text = text .. "Mean Relative: " .. string.format("%.5f", r2) .. "\n"
	text = text .. "Marine Variance: " .. string.format("%.5f", v_marineVariance) .. "\n"
	text = text .. "Alien Variance: " .. string.format("%.5f", v_alienVariance) .. "\n"
	
	text = text .. "Mean Relative: " .. string.format("%.5f", r3) .. "\n"
	text = text .. "Marine Skewness: " .. string.format("%.5f", v_marineSkewness) .. "\n"
	text = text .. "Alien Skewness: " .. string.format("%.5f", v_alienSkewness) .. "\n"
	
	text = text .. "Asymmetry Teams: " .. string.format("%.5f", asymmetryTeams) .. "\n"
	text = text .. "Asymmetry Init Teams: " .. string.format("%.5f", asymmetryInitTeams) .. "\n"
	
	table.sort(t1, function(k1, k2)
		return k1.marine > k2.marine
	end)
	table.sort(t2, function(k1, k2)
		return k1.alien > k2.alien
	end)
	
	local max = math.max(#t0, #t1, #t2)
	for i = 1, max do
		local marineString = lpad('', 28)
		if t1[i] ~= nil then
			
			local plus= " -"
			if t1[i].pref == 1 then
				plus = " +"
			end
			local star = ' '
			if t1[i].commander then
				star = '*'
			end
			marineString = star .. lpad(t1[i].name, 22) .. plus.. lpad(t1[i].marine, 5)
		end
		local alienString =  lpad('', 28)
		if t2[i] ~= nil then
			
			local plus= " -"
			if t2[i].pref == 2 then
				plus = " +"
			end
			local star = ' '
			if t2[i].commander then
				star = '*'
			end
			alienString = " " .. star.. lpad(t2[i].name, 22) ..plus.. lpad(t2[i].alien, 5)
		end
		local noneString = ''
		if t0[i] ~= nil then
			noneString = " " .. lpad(t0[i].name, 22) .. lpad(t0[i].marine, 5) .. lpad(t0[i].alien, 5)
		end
		text = text .. lpad(i, 2) .. marineString .. alienString .. noneString .. "\n"
	end
	text = text .. lpad('Marines ' .. #t1, 20) .. lpad('Aliens ' .. #t2, 19) .. lpad('None ' .. #t0, 18) .. "\n"
	return text
end

return {
	main = main,
	showTeams = showTeams
}