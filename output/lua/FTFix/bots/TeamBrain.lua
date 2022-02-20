function TeamBrain:GetMemories()
    if self.lastUpdate < Shared.GetTime() - 0.2 then
        self:Update()
    end

    return self.entMemories
end