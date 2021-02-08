--ST1-07 Greymon
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddLevel(c,4)
	aux.AddForm(c,FORM_CHAMPION)
	aux.AddAttribute(c,ATTRIBUTE_VACCINE)
	aux.AddRace(c,RACE_DINOSAUR)
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
	--security attack
	local e1=aux.AddTempEffectCustom(rc,rc,EFFECT_UPDATE_CHECK)
	e1:SetValue(1)
	--add description
	aux.RegisterDescription(rc,aux.Stringid(sid,0))
end
