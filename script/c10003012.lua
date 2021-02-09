--ST3-12 T.K. Takaishi
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	--tamer
	aux.EnableTamerAttribute(c)
	--gain power
	local e1=aux.AddContinuousUpdatePower(c,LOCATION_SZONE,2000,LOCATION_ALL,0,aux.TargetBoolFunction(Card.IsType,TYPE_SECURITY))
	e1:SetCondition(aux.TurnPlayerCondition(PLAYER_OPPO))
	--play tamer
	aux.AddSecurityEffect(c,aux.TamerOperation)
end
