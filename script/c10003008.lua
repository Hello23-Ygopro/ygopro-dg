--ST3-08 MagnaAngemon
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddLevel(c,5)
	aux.AddForm(c,FORM_ULTIMATE)
	aux.AddAttribute(c,ATTRIBUTE_VACCINE)
	aux.AddRace(c,RACE_ARCHANGEL)
	--digimon
	aux.EnableDigimonAttribute(c)
	--digivolution condition
	aux.AddDigivolutionCondition(c,3)
	--gain effect (lose digimon power)
	aux.AddSingleInheritedTriggerEffect(c,0,EVENT_ATTACK_ANNOUNCE,scard.op1)
	--add description
	aux.RegisterDescription(c,aux.Stringid(sid,1))
end
--gain effect (lose digimon power)
scard.op1=aux.UpdatePowerOperation(PLAYER_SELF,Card.IsFaceup,0,LOCATION_MZONE,1,1,-1000,RESET_PHASE+PHASE_END)
