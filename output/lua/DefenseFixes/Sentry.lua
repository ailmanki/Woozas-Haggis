Sentry.kRange = 60


local oldOnInitialized = Sentry.OnInitialized
function Sentry:OnInitialized()
    oldOnInitialized(self)
    self:SetUpdates(true, 0)
end
