--ST2-11 MetalGarurumon
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddLevel(c,6)
	aux.AddForm(c,FORM_MEGA)
	aux.AddAttribute(c,ATTRIBUTE_DATA)
	aux.AddRace(c,RACE_CYBORG)
	--digimon
	aux.EnableDigimonAttribute(c)
	--digivolution condition
	aux.AddDigivolutionCondition(c,4)
	--unsuspend
	local e1=aux.AddSingleTriggerEffect(c,0,EVENT_DAMAGE_STEP_END,aux.SelfChangePositionOperation(POS_FACEUP_UNSUSPENDED))
	e1:SetCountLimit(1)
end
