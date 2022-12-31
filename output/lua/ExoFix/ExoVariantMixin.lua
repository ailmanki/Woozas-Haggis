
if Client then

    function ExoVariantMixin:GetWeaponLoadoutClass()

        if self:isa("Exosuit") or self:isa("ReadyRoomExo") then
            local modelName = self:GetModelName()   --hacks
            if StringEndsWith( modelName, "_mm.model" ) then
                return "Minigun"
            elseif StringEndsWith( modelName, "_rr.model" ) then
                return "Railgun"
            end
        else
            local wep = self:GetActiveWeapon()
            if wep then
                --This assumes no mixed weapons are allowed (only sets)
                return wep:GetLeftSlotWeapon():GetClassName()
            end
            return "Minigun"
        end
    end
end