--ST1-01 Koromon
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	aux.AddLevel(c,2)
	aux.AddForm(c,FORM_INTRAINING)
	aux.AddAttribute(c,ATTRIBUTE_NONE)
	aux.AddRace(c,RACE_LESSER)
	--digi-egg
	aux.EnableDigiEggAttribute(c)
	--gain digimon power
	local e1=aux.AddInheritedUpdatePower(c,LOCATION_MZONE,1000)
	e1:SetCondition(scard.con1)
	--add description
	aux.RegisterDescription(c,aux.Stringid(sid,0))
end
--gain digimon power
function scard.con1(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer() and e:GetHandler():IsDigivolutionCountAbove(4)
end
