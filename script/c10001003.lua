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
	--gain digimon power
	local e1=aux.AddInheritedUpdatePower(c,LOCATION_MZONE,1000)
	e1:SetCondition(aux.TurnPlayerCondition(PLAYER_SELF))
	--add description
	aux.RegisterDescription(c,aux.Stringid(sid,0))
end
