if Server then

    -- No enforced balanced teams on join as the auto team balance system balances teams.
    function NS2Gamerules:GetCanJoinTeamNumber(player, teamNumber)

        local team1Players = self.team1:GetNumPlayers()
        local team2Players = self.team2:GetNumPlayers()

        local team1Number = self.team1:GetTeamNumber()
        local team2Number = self.team2:GetTeamNumber()

        -- Every check below is disabled with cheats enabled
        if Shared.GetCheatsEnabled() then
            return true
        end
    
    
        if self.gameState == kGameState.Started then
            local forceEvenTeams = Server.GetConfigSetting("force_even_teams_on_join")
            if forceEvenTeams then
                if (team1Players > team2Players) and (teamNumber == team1Number) then
                    Server.SendNetworkMessage(player, "JoinError", BuildJoinErrorMessage(0), true)
                    return false
                elseif (team2Players > team1Players) and (teamNumber == team2Number) then
                    Server.SendNetworkMessage(player, "JoinError", BuildJoinErrorMessage(0), true)
                    return false
                end
            end
        end

        -- Scenario: Veteran tries to join a team at rookie only server
        if teamNumber ~= kSpectatorIndex then --allow to spectate
            local isRookieOnly = Server.IsDedicated() and not self.botTraining and self.gameInfo:GetRookieMode()

            if isRookieOnly and player:GetSkillTier() > kRookieMaxSkillTier then
                Server.SendNetworkMessage(player, "JoinError", BuildJoinErrorMessage(2), true)
                return false
            end
        end
        
        return true
        
    end
    

end


