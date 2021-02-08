--ST1-06 Coredramon
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddLevel(c,4)
	aux.AddForm(c,FORM_CHAMPION)
	aux.AddAttribute(c,ATTRIBUTE_VIRUS)
	aux.AddRace(c,RACE_DRAGON)
	--digimon
	aux.EnableDigimonAttribute(c)
	--digivolution condition
	aux.AddDigivolutionCondition(c,2)
	--blocker
	aux.EnableBlocker(c)
	--lose memory
	aux.AddSingleTriggerEffect(c,0,EVENT_ATTACK_ANNOUNCE,aux.DuelOperation(Duel.RemoveMemory,PLAYER_SELF,2))
end
