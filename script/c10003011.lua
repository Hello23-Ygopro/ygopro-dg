--ST3-11 Seraphimon
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddLevel(c,6)
	aux.AddForm(c,FORM_MEGA)
	aux.AddAttribute(c,ATTRIBUTE_VACCINE)
	aux.AddRace(c,RACE_SERAPH,RACE_THREE_GREAT_ANGELS)
	--digimon
	aux.EnableDigimonAttribute(c)
	--digivolution condition
	aux.AddDigivolutionCondition(c,4)
	--gain effect (lose digimon power)
	aux.AddSingleTriggerEffect(c,0,EVENT_ATTACK_ANNOUNCE,scard.op1)
end
--gain effect (lose digimon power)
scard.op1=aux.UpdatePowerOperation(PLAYER_SELF,Card.IsFaceup,0,LOCATION_MZONE,1,1,-4000,RESET_PHASE+PHASE_END)
