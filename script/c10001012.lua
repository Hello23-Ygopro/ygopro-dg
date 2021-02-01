--Tai Kamiya (ST1-12)
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	--tamer
	aux.EnableTamerAttribute(c)
	--gain power
	local e1=aux.AddContinuousUpdatePower(c,LOCATION_SZONE,1000,LOCATION_MZONE,0,aux.BattleAreaBoolFunction(nil))
	e1:SetCondition(aux.TurnPlayerCondition(PLAYER_SELF))
	--play tamer
	aux.AddSecurityEffect(c,aux.TamerOperation)
end
