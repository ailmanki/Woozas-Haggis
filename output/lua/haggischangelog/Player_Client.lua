local oldPlayerOnInitLocalClient = Player.OnInitLocalClient
function Player:OnInitLocalClient()
    oldPlayerOnInitLocalClient(self)
    if self:GetTeamNumber() == kTeamReadyRoom then
        local target = GetHaggisChangelog()
        target:DelayedInit();
    end
end
