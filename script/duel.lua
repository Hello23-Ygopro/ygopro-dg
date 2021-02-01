--Overwritten Duel functions
--play a digimon card
--Note: Overwritten to notify a player if all zones are occupied
local duel_special_summon_step=Duel.SpecialSummonStep
function Duel.SpecialSummonStep(c,sumtype,sumplayer,target_player,nocheck,nolimit,pos,zone)
	if not Duel.CheckBattleArea(target_player) then
		Duel.Hint(HINT_MESSAGE,sumplayer,ERROR_NOBZONES)
		return false
	end
	return duel_special_summon_step(c,sumtype,sumplayer,target_player,nocheck,nolimit,pos,zone)
end
local duel_special_summon=Duel.SpecialSummon
function Duel.SpecialSummon(targets,sumtype,sumplayer,target_player,nocheck,nolimit,pos,zone)
	if type(targets)=="Card" then targets=Group.FromCards(targets) end
	local res=0
	for tc in aux.Next(targets) do
		if Duel.CheckBattleArea(target_player) then
			if Duel.SpecialSummonStep(tc,sumtype,sumplayer,target_player,nocheck,nolimit,pos,zone) then
				res=res+1
			end
		else
			Duel.Hint(HINT_MESSAGE,sumplayer,ERROR_NOBZONES)
		end
	end
	Duel.SpecialSummonComplete()
	return res
end
--change the position of a card
--Note: Overwritten so that only two arguments are required
local duel_change_position=Duel.ChangePosition
function Duel.ChangePosition(targets,pos)
	return duel_change_position(targets,pos)
end
--draw a card
--Note: Overwritten to check if a player's deck size is less than the number of cards they will draw
local duel_draw=Duel.Draw
function Duel.Draw(player,count,reason)
	local deck_count=Duel.GetFieldGroupCount(player,LOCATION_DECK,0)
	if deck_count>0 and count>deck_count then count=deck_count end
	--you only lose the game if you cannot draw a card from your deck during your draw phase
	if deck_count==0 and bit.band(reason,REASON_RULE)==0 then count=0 end
	return duel_draw(player,count,reason)
end
--check if a player can draw a card
--Note: Overwritten to check if a player's deck size is less than the number of cards they will draw
local duel_is_player_can_draw=Duel.IsPlayerCanDraw
function Duel.IsPlayerCanDraw(player,count)
	count=count or 0
	local deck_count=Duel.GetFieldGroupCount(player,LOCATION_DECK,0)
	if deck_count>0 and count>deck_count then count=deck_count end
	return duel_is_player_can_draw(player,count)
end
--select a card
--Note: Overwritten to notify a player if there are no cards to select
local duel_select_matching_card=Duel.SelectMatchingCard
function Duel.SelectMatchingCard(sel_player,f,player,s,o,min,max,ex,...)
	if not Duel.IsExistingMatchingCard(f,player,s,o,1,ex,...) then
		Duel.Hint(HINT_MESSAGE,sel_player,ERROR_NOTARGETS)
	end
	return duel_select_matching_card(sel_player,f,player,s,o,min,max,ex,...)
end
--target a card
--Note: Overwritten to notify a player if there are no cards to select
local duel_select_target=Duel.SelectTarget
function Duel.SelectTarget(sel_player,f,player,s,o,min,max,ex,...)
	if not Duel.IsExistingTarget(f,player,s,o,1,ex,...) then
		Duel.Hint(HINT_MESSAGE,sel_player,ERROR_NOTARGETS)
	end
	return duel_select_target(sel_player,f,player,s,o,min,max,ex,...)
end
--New Duel functions
--end the turn
function Duel.EndTurn()
	local turnp=Duel.GetTurnPlayer()
	if Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE) and Duel.GetCurrentChain()>0 then
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			skip_phase(turnp)
		end)
		Duel.RegisterEffect(e1,turnp)
	else
		skip_phase(turnp)
	end
end
function skip_phase(turnp)
	Duel.SkipPhase(turnp,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(turnp,PHASE_BREEDING,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
	Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,turnp)
end
--get a player's memory gauge
function Duel.GetMemoryGauge(player)
	return Duel.GetFirstMatchingCard(Card.IsCode,player,LOCATION_ONFIELD,0,nil,CARD_MEMORY_GAUGE)
end
--get the amount of memory a player has
function Duel.GetMemory(player)
	return Duel.GetMemoryGauge(player):GetCounter(COUNTER_MEMORY)
end
--check if a player's memory is equal to a given value
function Duel.IsMemory(player,count)
	return Duel.GetMemory(player)==count
end
--check if a player's memory is less than or equal to a given value
function Duel.IsMemoryBelow(player,count)
	return Duel.GetMemory(player)<=count
end
--check if a player's memory greater than or equal to a given value
function Duel.IsMemoryAbove(player,count)
	return Duel.GetMemory(player)>=count
end
--get the maximum amount of memory a player can have
function Duel.GetMaxMemory(player)
	return 10
end
--increase a player's memory
function Duel.AddMemory(player,count)
	local memory=Duel.GetMemory(player)
	local max_memory=Duel.GetMaxMemory(player)
	if memory+count>max_memory then count=max_memory-memory end
	if Duel.GetMemoryGauge(player):AddCounter(COUNTER_MEMORY,count) then
		--end the turn
		if Duel.IsMemoryAbove(1-player,1) and Duel.GetFlagEffect(player,FLAG_CODE_OVERSPENT)==0 then
			Duel.EndTurn()
			Duel.RegisterFlagEffect(player,FLAG_CODE_OVERSPENT,0,0,1)
		end
	end
end
--decrease a player's memory
function Duel.RemoveMemory(player,count)
	local memory=Duel.GetMemory(player)
	local add=memory-count
	Duel.GetMemoryGauge(player):RemoveCounter(player,COUNTER_MEMORY,count,REASON_RULE)
	--carry over remaining amount
	if add<0 then
		Duel.GetMemoryGauge(1-player):AddCounter(COUNTER_MEMORY,-add,REASON_RULE)
	end
	--end the turn
	if Duel.IsMemoryAbove(1-player,1) and Duel.GetFlagEffect(player,FLAG_CODE_OVERSPENT)==0 then
		Duel.EndTurn()
		Duel.RegisterFlagEffect(player,FLAG_CODE_OVERSPENT,0,0,1)
	end
end
--set a player's memory
function Duel.SetMemory(player,count)
	local memory=Duel.GetMemory(player)
	Duel.GetMemoryGauge(player):RemoveCounter(player,COUNTER_MEMORY,memory,REASON_RULE)
	Duel.AddMemory(player,count)
	--end the turn
	if Duel.IsMemoryAbove(1-player,1) and Duel.GetFlagEffect(player,FLAG_CODE_OVERSPENT)==0 then
		Duel.EndTurn()
		Duel.RegisterFlagEffect(player,FLAG_CODE_OVERSPENT,0,0,1)
	end
end
--send a card from the top of a player's deck to the security stack
function Duel.SendDecktoptoSecurity(player,count,reason)
	local g=Duel.GetDecktopGroup(player,count)
	Duel.DisableShuffleCheck()
	return Duel.SendtoSecurity(g,POS_FACEDOWN,reason)
end
--send a digimon to its owner's breeding area
function Duel.SendtoBreeding(targets)
	if type(targets)=="Card" then targets=Group.FromCards(targets) end
	local res=0
	for tc in aux.Next(targets) do
		if Duel.MoveToField(tc,tc:GetOwner(),tc:GetOwner(),LOCATION_MZONE,POS_FACEUP_UNSUSPENDED,true,ZONE_MZONE_EX_LEFT) then
			res=res+1
		end
	end
	return res
end
--check if a player has an unoccupied zone in the breeding area to hatch a digimon
function Duel.CheckBreedingArea(player)
	return not Duel.GetFirstMatchingCard(Card.IsSequence,player,LOCATION_MZONE,0,nil,SEQ_MZONE_EX_LEFT)
end
--check if a player has an unoccupied zone in the battle area to a play a digimon
function Duel.CheckBattleArea(player)
	return Duel.GetLocationCount(player,LOCATION_MZONE)>1
end
--check if a player can pay a cost
function Duel.CheckCost(player,cost)
	local memory=Duel.GetMemory(player)
	local max_memory1=Duel.GetMaxMemory(player)
	local max_memory2=Duel.GetMaxMemory(1-player)
	local max_cost=memory+max_memory1
	return max_cost>=cost and max_cost<=max_memory1+max_memory2
end
--pay a cost
function Duel.PayCost(player,cost)
	local memory=Duel.GetMemory(player)
	local add=memory-cost
	Duel.SetMemory(player,add)
	--carry over remaining amount
	if add<0 then
		Duel.SetMemory(1-player,-add)
	end
	--end the turn
	if Duel.IsMemoryAbove(1-player,1) and Duel.GetFlagEffect(player,FLAG_CODE_OVERSPENT)==0 then
		Duel.EndTurn()
		Duel.RegisterFlagEffect(player,FLAG_CODE_OVERSPENT,0,0,1)
	end
end
--play a digimon
function Duel.PlayDigimon(targets,play_player,pos,playtype,zone)
	--targets: the digimon to play
	--play_player: the player who plays the digimon
	--pos: POS_FACEUP_UNSUSPENDED to play in unsuspended or POS_FACEUP_SUSPENDED to play in suspended
	--playtype: how the pokemon is played (SUMMON_TYPE)
	--zone: the zone to put the digimon in
	pos=pos or POS_FACEUP_UNSUSPENDED
	playtype=playtype or 0
	zone=zone or ZONE_BATTLE
	return Duel.SpecialSummon(targets,playtype,play_player,play_player,false,false,pos,zone)
end
--digivolve a card
function Duel.Digivolve(c,targets,player)
	--c: the digimon to play
	--targets: the digimon to digivolve
	--player: the player who digivolves the digimon
	if type(targets)=="Card" then targets=Group.FromCards(targets) end
	local res=0
	c:SetMaterial(targets) --required for EVENT_BE_MATERIAL
	for tc in aux.Next(targets) do
		local pos=tc:GetPosition()
		local zone=bit.lshift(0x1,tc:GetSequence())
		--workaround to play in ex mzone
		if tc:IsSequence(SEQ_MZONE_EX_LEFT) then
			Duel.MoveSequence(tc,SEQ_MZONE_LEFT)
			zone=ZONE_MZONE_LEFT
			c:RegisterFlagEffect(FLAG_CODE_PLAY_EX,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
		end
		--transfer digivolution cards
		local g=tc:GetDigivolutionGroup()
		if g:GetCount()>0 then
			Duel.Overlay(c,g)
		end
		Duel.Overlay(c,tc)
		res=res+Duel.PlayDigimon(c,player,pos,SUMMON_TYPE_DIGIVOLVE,zone)
	end
	return res
end
--trash a digivolution card on the bottom of a digimon
function Duel.DiscardDigivolutionCard(player,targets,f,min,max,reason,ex,...)
	--player: the player who trashes the card
	--targets: the digimon whose digivolution card to
	--f: filter function if the card is specified
	--min,max: the number of cards to trash
	--reason: the reason for trashing the card
	if type(targets)=="Card" then targets=Group.FromCards(targets) end
	f=f or aux.TRUE
	local res=0
	for tc in aux.Next(targets) do
		local g=tc:GetDigivolutionGroup()
		if g:GetCount()==0 then break end
		Duel.Hint(HINT_SELECTMSG,player,HINTMSG_TRASH)
		local sg=g:FilterSelect(player,f,min,max,ex,...)
		res=res+Duel.Trash(sg,reason)
	end
	return res
end
--play a tamer
function Duel.PlayTamer(targets,play_player)
	--targets: the tamer to play
	--play_player: the player who plays the tamer
	if type(targets)=="Card" then targets=Group.FromCards(targets) end
	local res=0
	for tc in aux.Next(targets) do
		if Duel.MoveToField(tc,play_player,play_player,LOCATION_SZONE,POS_FACEUP,true) then
			res=res+1
		end
	end
	return res
end
--Renamed Duel functions
--delete a card
Duel.Delete=Duel.Destroy
--send a card to the security stack
Duel.SendtoSecurity=Duel.Remove
--trash a card
Duel.Trash=Duel.SendtoGrave
--reserved
--[[
--reveal the top cards of a player's digi-egg deck
Duel.ConfirmDigiEggtop=Duel.ConfirmExtratop
--shuffle a player's digi-egg deck
Duel.ShuffleDigiEgg=Duel.ShuffleExtra
--get the top cards of a player's digi-egg deck
Duel.GetDigiEggtopGroup=Duel.GetExtraTopGroup
]]
