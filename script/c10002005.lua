--ST2-05 Ikkakumon
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddLevel(c,4)
	aux.AddForm(c,FORM_CHAMPION)
	aux.AddAttribute(c,ATTRIBUTE_VACCINE)
	aux.AddRace(c,RACE_SEA_BEAST)
	--digimon
	aux.EnableDigimonAttribute(c)
	--digivolution condition
	aux.AddDigivolutionCondition(c,2)
end
