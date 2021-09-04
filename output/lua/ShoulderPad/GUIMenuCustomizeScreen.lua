
local oldUpdateBuyButton = GUIMenuCustomizeScreen.UpdateBuyButton
function GUIMenuCustomizeScreen:UpdateBuyButton(itemId, forceRecheck)
	if itemId == 40000 then
		itemId = 0
		return
	end
	return oldUpdateBuyButton(self, itemId, forceRecheck)
end