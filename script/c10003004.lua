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
	--gain effect (gain digimon power)
	local e1=aux.AddInheritedTriggerEffect(c,0,EVENT_DELETED,aux.SelfUpdatePowerOperation(1000,RESET_PHASE+PHASE_END))
	e1:SetCountLimit(1)
	e1:SetCondition(scard.con1)
	--add description
	aux.RegisterDescription(c,aux.Stringid(sid,1))
end
--gain effect (gain digimon power)
function scard.cfilter(c,tp)
	return c:IsType(TYPE_DIGIMON) and c:IsReason(REASON_ZERO_DP) and c:IsPreviousControler(1-tp)
end
function scard.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and eg:IsExists(scard.cfilter,1,nil,tp)
end
