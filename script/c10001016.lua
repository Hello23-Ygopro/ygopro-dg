--ST1-16 Gaia Force
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	--delete
	aux.AddMainEffect(c,aux.DeleteOperation(PLAYER_SELF,aux.BattleAreaFilter(Card.IsFaceup),0,LOCATION_MZONE,1,1))
	--activate effect
	aux.AddSecurityEffect(c,aux.SelfActivateMainOperation)
end
