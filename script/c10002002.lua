--ST2-02 Gomamon
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddLevel(c,3)
	aux.AddForm(c,FORM_ROOKIE)
	aux.AddAttribute(c,ATTRIBUTE_VACCINE)
	aux.AddRace(c,RACE_SEA_BEAST)
	--digimon
	aux.EnableDigimonAttribute(c)
	--digivolution condition
	aux.AddDigivolutionCondition(c,0)
end
