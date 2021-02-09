--ST3-05 Angemon
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddLevel(c,4)
	aux.AddForm(c,FORM_CHAMPION)
	aux.AddAttribute(c,ATTRIBUTE_VACCINE)
	aux.AddRace(c,RACE_ANGEL)
	--digimon
	aux.EnableDigimonAttribute(c)
	--digivolution condition
	aux.AddDigivolutionCondition(c,2)
	--inherited effect
	aux.AddInheritedEffect(c,scard.op1)
end
--inherited effect
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
	--gain memory
	local e1=aux.AddSingleTriggerEffect(rc,0,EVENT_ATTACK_ANNOUNCE,aux.DuelOperation(Duel.AddMemory,PLAYER_SELF,1))
	e1:SetCondition(aux.IsSecurityAboveCondition(PLAYER_SELF,4))
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	--add description
	aux.RegisterDescription(rc,aux.Stringid(sid,1))
end
