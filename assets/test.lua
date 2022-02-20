local NumPlayers = 155

local Max = math.max
local Min = math.min
local Floor = math.floor
local function Clamp( Number, Lower, Upper )
	return Max( Min( Number, Upper ), Lower )
end

function math.Round( Number, DecimalPlaces )
	local Mult = 10 ^ ( DecimalPlaces or 0 )
	return Floor( Number * Mult + 0.5 ) / Mult
end
--[[
	Remaps the given value from [OldStart, OldEnd] into [NewStart, NewEnd], e.g.
		math.Remap( 0.5, 0, 1, 10, 20 ) == 15
]]
function math.Remap( Value, OldStart, OldEnd, NewStart, NewEnd )
	local FractionIntoRange = ( Value - OldStart ) / ( OldEnd - OldStart )
	return NewStart + FractionIntoRange * ( NewEnd - NewStart )
end


local wolo = (""..math.Round( math.Remap( Clamp( NumPlayers, 24, 50 ), 50, 24, 1, 5 ) ))
print(wolo)