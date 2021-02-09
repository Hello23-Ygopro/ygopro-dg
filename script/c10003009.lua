--ST3-09 Angewomon
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
	--recover
	local e1=aux.AddSingleTriggerEffect(c,0,EVENT_PLAY_SUCCESS,aux.RecoveryOperation(PLAYER_SELF,1,LOCATION_DECK))
	e1:SetCondition(aux.AND(aux.DigivolvingCondition,aux.IsSecurityBelowCondition(PLAYER_SELF,3)))
end
