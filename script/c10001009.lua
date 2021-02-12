--ST1-09 MetalGreymon
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddLevel(c,5)
	aux.AddForm(c,FORM_ULTIMATE)
	aux.AddAttribute(c,ATTRIBUTE_VACCINE)
	aux.AddRace(c,RACE_CYBORG)
	--digimon
	aux.EnableDigimonAttribute(c)
	--digivolution condition
	aux.AddDigivolutionCondition(c,3)
	--gain memory
	local e1=aux.AddSingleInheritedTriggerEffect(c,0,EVENT_CUSTOM+EVENT_BECOME_BLOCKED,aux.DuelOperation(Duel.AddMemory,PLAYER_SELF,3))
	e1:SetCondition(aux.TurnPlayerCondition(PLAYER_SELF))
	--add description
	aux.RegisterDescription(c,aux.Stringid(sid,1))
end
