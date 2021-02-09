--ST3-13 Heaven's Gate
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	--gain effect (gain digimon power)
	aux.AddMainEffect(c,aux.UpdatePowerOperation(PLAYER_SELF,Card.IsFaceup,LOCATION_MZONE,0,1,1,3000,RESET_PHASE+PHASE_END))
	--gain effect, to hand
	aux.AddSecurityEffect(c,scard.op1)
end
--gain effect, to hand
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--gain digimon power
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_POWER)
	e1:SetValue(5000)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.BattleAreaBoolFunction(nil))
	e2:SetLabelObject(e1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetTargetRange(LOCATION_ALL,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SECURITY))
	Duel.RegisterEffect(e3,tp)
	--workaround to keep hand when [Security] effect is resolved
	e:SetProperty(e:GetProperty()+EFFECT_FLAG_CANCEL_TRASH)
	--Duel.SendtoHand(c,PLAYER_OWNER,REASON_EFFECT)
end
