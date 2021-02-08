--ST1-15 Giga Destroyer
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	--delete
	aux.AddMainEffect(c,aux.DeleteOperation(PLAYER_SELF,aux.BattleAreaFilter(scard.delfilter),0,LOCATION_MZONE,1,2))
	--activate effect
	aux.AddSecurityEffect(c,aux.SelfActivateMainOperation)
end
--delete
function scard.delfilter(c)
	return c:IsFaceup() and c:IsPowerBelow(4000)
end
