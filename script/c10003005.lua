--ST3-05 Angemon
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddLevel(c,4)
	aux.AddForm(c,FORM_CHAMPION)
	aux.AddAttribute(c,ATTRIBUTE_VACCINE)
	aux.AddRace(c,RACE_ANGEL)
	--digimon
	aux.EnableDigimonAttribute(c)
	--digivolution condition
	aux.AddDigivolutionCondition(c,2)
	--gain memory
	local e1=aux.AddSingleInheritedTriggerEffect(c,0,EVENT_ATTACK_ANNOUNCE,aux.DuelOperation(Duel.AddMemory,PLAYER_SELF,1))
	e1:SetCondition(aux.IsSecurityAboveCondition(PLAYER_SELF,4))
	--add description
	aux.RegisterDescription(c,aux.Stringid(sid,1))
end
