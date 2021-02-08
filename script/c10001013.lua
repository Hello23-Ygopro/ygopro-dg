--ST1-13 Shadow Wing
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	--gain effect (gain digimon power)
	aux.AddMainEffect(c,aux.UpdatePowerOperation(PLAYER_SELF,Card.IsFaceup,LOCATION_MZONE,0,1,1,3000,RESET_PHASE+PHASE_END))
	--gain effect
	aux.AddSecurityEffect(c,scard.op1)
end
--gain effect
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.BattleAreaFilter(Card.IsFaceup),tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		local reset_count=(Duel.GetTurnPlayer()==tp and 2 or 1)
		--security attack
		local e1=aux.AddTempEffectCustom(e:GetHandler(),tc,EFFECT_UPDATE_CHECK,RESET_PHASE+PHASE_END+RESET_SELF_TURN,reset_count)
		e1:SetValue(1)
	end
end
