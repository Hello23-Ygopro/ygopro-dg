--ST3-04 Patamon
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddLevel(c,3)
	aux.AddForm(c,FORM_ROOKIE)
	aux.AddAttribute(c,ATTRIBUTE_DATA)
	aux.AddRace(c,RACE_MAMMAL)
	--digimon
	aux.EnableDigimonAttribute(c)
	--digivolution condition
	aux.AddDigivolutionCondition(c,0)
	--inherited effect
	aux.AddInheritedEffect(c,scard.op1)
end
--inherited effect
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
	--gain effect (gain digimon power)
	local e1=aux.AddTriggerEffect(rc,0,EVENT_DELETED,aux.SelfUpdatePowerOperation(1000,RESET_PHASE+PHASE_END))
	e1:SetCountLimit(1)
	e1:SetCondition(scard.con1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	--add description
	aux.RegisterDescription(rc,aux.Stringid(sid,1))
end
--gain effect (gain digimon power)
function scard.cfilter(c)
	return c:IsType(TYPE_DIGIMON) and c:IsReason(REASON_ZERO_DP) and c:IsPreviousControler(1-tp)
end
function scard.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and eg:IsExists(scard.cfilter,1,nil,tp)
end
