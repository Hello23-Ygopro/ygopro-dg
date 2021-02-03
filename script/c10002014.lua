--Sorrow Blue (ST2-14)
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	--gain effect
	local e1=aux.AddMainEffect(c,scard.op1,scard.tg1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	--gain effect
	local e2=aux.AddSecurityEffect(c,scard.op2,scard.tg1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
end
--gain effect
function scard.effilter(c)
	return c:IsFaceup() and c:IsDigivolutionCount(0)
end
scard.tg1=aux.TargetCardFunction(PLAYER_SELF,aux.BattleAreaFilter(Card.effilter),0,LOCATION_MZONE,1,1,HINTMSG_TARGET)
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	local reset_count=(Duel.GetTurnPlayer()~=tp and 2 or 1)
	scard.gain_effect(e:GetHandler(),tc,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,reset_count)
end
--gain effect
function scard.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	local reset_count=(Duel.GetTurnPlayer()==tp and 2 or 1)
	scard.gain_effect(e:GetHandler(),tc,RESET_PHASE+PHASE_END+RESET_SELF_TURN,reset_count)
end
function scard.gain_effect(c,tc,reset_flag,reset_count)
	--cannot attack
	aux.AddTempEffectCustom(c,tc,EFFECT_CANNOT_ATTACK,reset_flag,reset_count)
	--cannot block
	aux.AddTempEffectCustom(c,tc,EFFECT_CANNOT_BLOCK,reset_flag,reset_count)
end
