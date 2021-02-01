--MetalGreymon (ST1-09)
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
	--inherited effect
	aux.AddInheritedEffect(c,scard.op1)
end
--inherited effect
function scard.op1(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
	--gain memory
	local e1=aux.AddSingleTriggerEffect(rc,0,EVENT_CUSTOM+EVENT_BECOME_BLOCKED,aux.DuelOperation(Duel.AddMemory,PLAYER_SELF,3))
	e1:SetCondition(aux.TurnPlayerCondition(PLAYER_SELF))
	--add description
	aux.RegisterDescription(rc,aux.Stringid(sid,1))
end
