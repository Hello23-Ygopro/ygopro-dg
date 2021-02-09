--ST3-15 Holy Flame
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	--gain effect
	aux.AddMainEffect(c,scard.op1)
	--gain effect
	aux.AddSecurityEffect(c,scard.op2)
end
--gain effect
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DIGIMON)
	local g=Duel.SelectMatchingCard(tp,aux.BattleAreaFilter(Card.IsFaceup),tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()==0 then return end
	Duel.HintSelection(g)
	local reset_count=(Duel.GetTurnPlayer()~=tp and 2 or 1)
	--security attack
	local e1=aux.AddTempEffectCustom(e:GetHandler(),g:GetFirst(),EFFECT_UPDATE_CHECK,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,reset_count)
	e1:SetValue(-3)
end
--gain effect
function scard.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.BattleAreaFilter(Card.IsFaceup),tp,0,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		--security attack
		local e1=aux.AddTempEffectCustom(e:GetHandler(),tc,EFFECT_UPDATE_CHECK,RESET_PHASE+PHASE_END)
		e1:SetValue(-1)
	end
end
