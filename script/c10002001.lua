--ST2-01 Tsunomon
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddLevel(c,2)
	aux.AddForm(c,FORM_INTRAINING)
	aux.AddAttribute(c,ATTRIBUTE_NONE)
	aux.AddRace(c,RACE_LESSER)
	--digi-egg
	aux.EnableDigiEggAttribute(c)
	--inherited effect
	aux.AddInheritedEffect(c,scard.op1)
end
--inherited effect
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
	--gain digimon power
	local e1=aux.AddTempEffectUpdatePower(rc,rc,1000)
	e1:SetCondition(scard.con1)
	--add description
	aux.RegisterDescription(rc,aux.Stringid(sid,0))
end
--gain digimon power
function scard.con1(e)
	local tp=e:GetHandlerPlayer()
	local tc=e:GetHandler():GetBattleTarget()
	return Duel.GetTurnPlayer()==tp and tc and tc:IsDigivolutionCount(0) and tc:IsControler(1-tp)
end
