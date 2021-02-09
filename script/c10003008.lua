--ST3-08 MagnaAngemon
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddLevel(c,5)
	aux.AddForm(c,FORM_ULTIMATE)
	aux.AddAttribute(c,ATTRIBUTE_VACCINE)
	aux.AddRace(c,RACE_ARCHANGEL)
	--digimon
	aux.EnableDigimonAttribute(c)
	--digivolution condition
	aux.AddDigivolutionCondition(c,3)
	--inherited effect
	aux.AddInheritedEffect(c,scard.op1)
end
--inherited effect
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
	--gain effect (lose digimon power)
	local e1=aux.AddSingleTriggerEffect(rc,0,EVENT_ATTACK_ANNOUNCE,scard.op2)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	--add description
	aux.RegisterDescription(rc,aux.Stringid(sid,1))
end
--gain effect (lose digimon power)
scard.op2=aux.UpdatePowerOperation(PLAYER_SELF,Card.IsFaceup,0,LOCATION_MZONE,1,1,-1000,RESET_PHASE+PHASE_END)
