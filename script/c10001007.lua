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
	--security attack
	local e1=aux.EnableInheritedEffectCustom(c,EFFECT_UPDATE_CHECK)
	e1:SetValue(1)
	--add description
	aux.RegisterDescription(c,aux.Stringid(sid,0))
end
