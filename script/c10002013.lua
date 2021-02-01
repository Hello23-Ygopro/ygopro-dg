--Hammer Spark (ST2-13)
local scard,sid=aux.GetID()
function scard.initial_effect(c)
	--gain memory
	aux.AddMainEffect(c,aux.DuelOperation(Duel.AddMemory,PLAYER_SELF,1))
	--gain memory
	aux.AddSecurityEffect(c,aux.DuelOperation(Duel.AddMemory,PLAYER_SELF,2))
end
