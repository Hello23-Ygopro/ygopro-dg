--Plesiomon (ST2-10)
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddLevel(c,6)
	aux.AddForm(c,FORM_MEGA)
	aux.AddAttribute(c,ATTRIBUTE_DATA)
	aux.AddRace(c,RACE_PLESIOSAUR)
	--digimon
	aux.EnableDigimonAttribute(c)
	--digivolution condition
	aux.AddDigivolutionCondition(c,2)
end
