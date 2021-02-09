--ST3-10 Magnadramon
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddLevel(c,6)
	aux.AddForm(c,FORM_MEGA)
	aux.AddAttribute(c,ATTRIBUTE_VACCINE)
	aux.AddRace(c,RACE_HOLY_DRAGON,RACE_FOUR_GREAT_DRAGONS)
	--digimon
	aux.EnableDigimonAttribute(c)
	--digivolution condition
	aux.AddDigivolutionCondition(c,2)
end
