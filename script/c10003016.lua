--ST3-16 Seven Heavens
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	--gain effect (lose digimon power)
	aux.AddMainEffect(c,aux.UpdatePowerOperation(PLAYER_SELF,Card.IsFaceup,0,LOCATION_MZONE,1,1,-10000,RESET_PHASE+PHASE_END))
	--activate effect
	aux.AddSecurityEffect(c,aux.SelfActivateMainOperation)
end
