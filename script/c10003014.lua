--ST3-14 Heaven's Charm
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	--gain effect (lose digimon power)
	aux.AddMainEffect(c,aux.UpdatePowerOperation(PLAYER_SELF,Card.IsFaceup,0,LOCATION_MZONE,1,1,-2000,RESET_PHASE+PHASE_END))
	--to hand
	--workaround to keep hand when [Security] effect is resolved
	aux.AddSecurityEffect(c,scard.op1)
	--aux.AddSecurityEffect(c,aux.DuelOperation(Duel.SendtoHand,c,REASON_EFFECT))
end
--to hand
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	e:SetProperty(e:GetProperty()+EFFECT_FLAG_CANCEL_TRASH)
end
