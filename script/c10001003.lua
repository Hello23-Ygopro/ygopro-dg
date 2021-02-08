--ST1-03 Agumon
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddLevel(c,3)
	aux.AddForm(c,FORM_ROOKIE)
	aux.AddAttribute(c,ATTRIBUTE_VACCINE)
	aux.AddRace(c,RACE_REPTILE)
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
	--gain digimon power
	local e1=aux.AddTempEffectUpdatePower(rc,rc,1000)
	e1:SetCondition(aux.TurnPlayerCondition(PLAYER_SELF))
	--add description
	aux.RegisterDescription(rc,aux.Stringid(sid,0))
end
