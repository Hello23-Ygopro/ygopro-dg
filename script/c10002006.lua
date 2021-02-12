--ST2-06 Garurumon
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddLevel(c,4)
	aux.AddForm(c,FORM_CHAMPION)
	aux.AddAttribute(c,ATTRIBUTE_VACCINE)
	aux.AddRace(c,RACE_BEAST)
	--digimon
	aux.EnableDigimonAttribute(c)
	--digivolution condition
	aux.AddDigivolutionCondition(c,2)
	--trash
	aux.AddSingleInheritedTriggerEffect(c,0,EVENT_ATTACK_ANNOUNCE,scard.op1)
	--add description
	aux.RegisterDescription(c,aux.Stringid(sid,1))
end
--trash
function scard.tgfilter(c)
	return c:IsFaceup() and c:GetDigivolutionGroup():IsExists(Card.IsAbleToTrash,1,nil)
end
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DIGIMON)
	local g=Duel.SelectMatchingCard(tp,aux.BattleAreaFilter(scard.tgfilter),tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()==0 then return end
	Duel.HintSelection(g)
	Duel.TrashDigivolutionCard(tp,g,aux.TRUE,1,1,REASON_EFFECT)
end
