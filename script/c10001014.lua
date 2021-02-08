--ST1-14 Starlight Explosion
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	--gain effect
	aux.AddMainEffect(c,scard.op1)
	--gain effect
	aux.AddSecurityEffect(c,scard.op2)
end
--gain effect
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local reset_count=(Duel.GetTurnPlayer()~=tp and 2 or 1)
	scard.gain_effect(e:GetHandler(),tp,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,reset_count)
end
--gain effect
function scard.op2(e,tp,eg,ep,ev,re,r,rp)
	scard.gain_effect(e:GetHandler(),tp,RESET_PHASE+PHASE_END,1)
end
function scard.gain_effect(c,tp,reset_flag,reset_count)
	--gain digimon power
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_POWER)
	e1:SetValue(7000)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SECURITY))
	e2:SetLabelObject(e1)
	e2:SetReset(reset_flag,reset_count)
	Duel.RegisterEffect(e2,tp)
end
