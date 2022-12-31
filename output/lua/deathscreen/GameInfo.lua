
Log("WTF9")
function GameInfo:OnCreate()

    Entity.OnCreate(self)

    if Server then

        self:SetPropagate(Entity.Propagate_Always)
        self:SetUpdates(false)

        self:SetState(kGameState.NotStarted)

        self.startTime = 0
        self.averagePlayerSkill = 0
        self.numClientsTotal = 0
        self.numPlayers = 0
        self.numBots = 0
        self.isDedicated = Server.IsDedicated()
        self.serverIp = "84.254.89.219" --Server.GetIpAddress()
        self.serverPort = Server.GetPort()

    end

    --Default values to all possible "Normal" skins
    self.team1Cosmetic1 = 1
    self.team1Cosmetic2 = 1
    self.team1Cosmetic3 = 1
    self.team1Cosmetic4 = 1
    self.team1Cosmetic5 = 1

    self.team2Cosmetic1 = 1
    self.team2Cosmetic2 = 1
    self.team2Cosmetic3 = 1
    self.team2Cosmetic4 = 1
    self.team2Cosmetic5 = 1
    self.team2Cosmetic6 = 1

    -- Initialize GameInfo vars for the end of round stats UI.
    if Server then
        self.showEndStatsAuto = AdvancedServerOptions["autodisplayendstats"].currentValue == true
        self.showEndStatsTeamBreakdown = AdvancedServerOptions["endstatsteambreakdown"].currentValue == true
    end

    if Client then
        self.prevWinner = nil
        self.prevTimeLength = nil
        self.prevTeamsSkills = nil
    end

end