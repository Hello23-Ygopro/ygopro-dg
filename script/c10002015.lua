--Kaiser Nail (ST2-15)
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	--play digimon
	local e1=aux.AddMainEffect(c,aux.TargetPlayDigimonOperation(POS_FACEUP_UNSUSPENDED))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(scard.tg1)
	--activate effect
	aux.AddSecurityEffect(c,aux.SelfActivateMainOperation)
end
--play digimon
function scard.cfilter(c,e,tp)
	return c:IsFaceup() and c:GetDigivolutionGroup():IsExists(scard.playfilter,1,nil,e,tp)
end
function scard.playfilter(c,e,tp)
	return c:IsCanBePlayed(e,tp) and c:IsCanBeEffectTarget(e)
end
function scard.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(aux.BattleAreaFilter(scard.cfilter),tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DIGIMON)
	local g1=Duel.SelectMatchingCard(tp,aux.BattleAreaFilter(scard.cfilter),tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.HintSelection(g1)
	local g2=g1:GetFirst():GetDigivolutionGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_PLAY)
	local sg=g2:FilterSelect(tp,scard.playfilter,1,1,nil,e,tp)
	Duel.SetTargetCard(sg)
end
