--Fix missing Card function errors
--check if the previous controller of the card is a given player
local card_is_previous_controler=Card.IsPreviousControler
function Card.IsPreviousControler(c,player)
	return card_is_previous_controler(c,player) or c:GetPreviousControler()==player
end
--Temporary Card functions
--check if a card has a given setname
--Note: Overwritten to check for an infinite number of setnames
local card_is_set_card=Card.IsSetCard
function Card.IsSetCard(c,...)
	local setname_list={...}
	for _,setname in ipairs(setname_list) do
		if card_is_set_card(c,setname,...) then return true end
	end
	return false
end
--Overwritten Card functions
--get a card's current play cost
--Note: Overwritten to check for the correct value if it is changed while the card is not in LOCATION_MZONE
local card_get_level=Card.GetLevel
function Card.GetLevel(c)
	local res=c:GetOriginalPlayCost()
	local t1={c:IsHasEffect(EFFECT_UPDATE_LEVEL)}
	for _,te1 in pairs(t1) do
		if type(te1:GetValue())=="function" then
			res=res+te1:GetValue()(te1,c)
		else
			res=res+te1:GetValue()
		end
	end
	local t2={c:IsHasEffect(EFFECT_CHANGE_PLAY_COST)}
	for _,te2 in pairs(t2) do
		if type(te2:GetValue())=="function" then
			res=te2:GetValue()(te2,c)
		else
			res=te2:GetValue()
		end
	end
	return res
end
Card.GetPlayCost=Card.GetLevel
--check if a card's play cost is equal to a given value
--Note: See Card.GetPlayCost
local card_is_level=Card.IsLevel
function Card.IsLevel(c,lv)
	return c:GetLevel()==lv
end
Card.IsPlayCost=Card.IsLevel
--check if a card's play cost is less than or equal to a given value
--Note: See Card.GetPlayCost
local card_is_level_below=Card.IsLevelBelow
function Card.IsLevelBelow(c,lv)
	return c:GetLevel()<=lv
end
Card.IsPlayCostBelow=Card.IsLevelBelow
--check if a card's play cost is greater than or equal to a given value
--Note: See Card.GetPlayCost
local card_is_level_above=Card.IsLevelAbove
function Card.IsLevelAbove(c,lv)
	return c:GetLevel()>=lv
end
Card.IsPlayCostAbove=Card.IsLevelAbove
--get a card's current digimon power
--Note: Overwritten to check for the correct value if it is changed while the card is not in LOCATION_MZONE
local card_get_attack=Card.GetAttack
function Card.GetAttack(c)
	local res=c:GetOriginalPower()
	local t1={c:IsHasEffect(EFFECT_UPDATE_POWER)}
	for _,te1 in pairs(t1) do
		if type(te1:GetValue())=="function" then
			res=res+te1:GetValue()(te1,c)
		else
			res=res+te1:GetValue()
		end
	end
	if c:IsLocation(LOCATION_MZONE) then
		return card_get_attack(c)
	else
		return res
	end
end
Card.GetPower=Card.GetAttack
--check if a card's digimon power is equal to a given value
--Note: See Card.GetPower
local card_is_attack=Card.IsAttack
function Card.IsAttack(c,atk)
	return c:GetAttack()==atk
end
Card.IsPower=Card.IsAttack
--check if a card's digimon power is less than or equal to a given value
--Note: See Card.GetPower
local card_is_attack_below=Card.IsAttackBelow
function Card.IsAttackBelow(c,atk)
	return c:GetAttack()<=atk
end
Card.IsPowerBelow=Card.IsAttackBelow
--check if a card's digimon power is greater than or equal to a given value
--Note: See Card.GetPower
local card_is_attack_above=Card.IsAttackAbove
function Card.IsAttackAbove(c,atk)
	return c:GetAttack()>=atk
end
Card.IsPowerAbove=Card.IsAttackAbove
--get a card's position
--Note: Overwritten to check if a card is suspended in LOCATION_SZONE
local card_get_position=Card.GetPosition
function Card.GetPosition(c)
	local res=0
	if c:IsFaceup() and c:IsLocation(LOCATION_SZONE) and c:IsSequenceBelow(4) then
		--workaround to check if a card is unsuspended in LOCATION_SZONE
		if c:GetFlagEffect(FLAG_CODE_SUSPENDED)==0 then
			res=POS_FACEUP_UNSUSPENDED
		--workaround to check if a card is suspended in LOCATION_SZONE
		elseif c:GetFlagEffect(FLAG_CODE_SUSPENDED)>0 then
			res=POS_FACEUP_SUSPENDED
		end
	else
		if not c:IsLocation(LOCATION_SZONE) then
			res=card_get_position(c)
		end
	end
	return res
end
--check if a card is a given position
--Note: See Card.GetPosition
local card_is_position=Card.IsPosition
function Card.IsPosition(c,pos)
	local res=false
	if c:IsFaceup() and c:IsLocation(LOCATION_SZONE) and c:IsSequenceBelow(4) then
		--workaround to check if a card is unsuspended in LOCATION_SZONE
		if c:GetFlagEffect(FLAG_CODE_SUSPENDED)==0 and pos==POS_FACEUP_UNSUSPENDED then
			res=true
		--workaround to check if a card is suspended in LOCATION_SZONE
		elseif c:GetFlagEffect(FLAG_CODE_SUSPENDED)>0 and pos==POS_FACEUP_SUSPENDED then
			res=true
		end
	else
		if not c:IsLocation(LOCATION_SZONE) then
			res=card_is_position(c,pos)
		end
	end
	return res
end
--check if a digimon can be played
--Note: Overwritten to include Duel.CheckBattleArea
local card_is_can_be_special_summoned=Card.IsCanBeSpecialSummoned
function Card.IsCanBeSpecialSummoned(c,e,playtype,playplayer,...)
	playtype=playtype or 0
	if bit.band(playtype,SUMMON_TYPE_DIGIVOLVE)~=0 then
		return Duel.GetLocationCount(playplayer,LOCATION_MZONE)>=-1
	end
	if not Duel.CheckBattleArea(playplayer) then return false end
	return card_is_can_be_special_summoned(c,e,playtype,playplayer,...)
end
--add a counter to a card
--Note: Overwritten to not add 0, negative counters, or counters exceeding a set amount
local card_add_counter=Card.AddCounter
function Card.AddCounter(c,countertype,count,...)
	if count<=0 then
		return true
	else
		if c:IsCode(CARD_MEMORY_GAUGE) and countertype==COUNTER_MEMORY then
			local player=c:GetControler()
			local memory=Duel.GetMemory(player)
			local max_memory=Duel.GetMaxMemory(player)
			--do not exceed the max memory amount
			if memory+count>max_memory then count=max_memory-memory end
		end
	end
	return card_add_counter(c,countertype,count,...)
end
--remove a counter from a card
--Note: Overwritten to check if a card has less counters than the number of counters the player will remove
local card_remove_counter=Card.RemoveCounter
function Card.RemoveCounter(c,player,countertype,count,reason)
	local counter_count=c:GetCounter(countertype)
	if counter_count>0 and count>counter_count then count=counter_count end
	local res=nil
	if count>0 then res=card_remove_counter(c,player,countertype,count,reason) end
	return res
end
--New Card functions
--check if the serial number of a card's current position is equal to a given value
function Card.IsSequence(c,seq)
	return c:GetSequence()==seq
end
--check if the serial number of a card's current position is less than or equal to a given value
function Card.IsSequenceBelow(c,seq)
	return c:GetSequence()<=seq
end
--check if the serial number of a card's current position is greater than or equal to a given value
function Card.IsSequenceAbove(c,seq)
	return c:GetSequence()>=seq
end
--check if a card can be unsuspended
function Card.IsAbleToUnsuspend(c)
	if c:IsHasEffect(EFFECT_CANNOT_CHANGE_POS_E) then return false end
	return c:IsPosition(POS_FACEUP_SUSPENDED)
end
--check if a card can be suspended
function Card.IsAbleToSuspend(c)
	if c:IsHasEffect(EFFECT_CANNOT_CHANGE_POS_E) then return false end
	return c:IsPosition(POS_FACEUP_UNSUSPENDED)
end
--check if a card can be unsuspended during the unsuspend phase
function Card.IsAbleToUnsuspendRule(c)
	return c:IsPosition(POS_FACEUP_SUSPENDED)
end
--get a digimon's level
function Card.GetDigiLevel(c)
	local res=c.level or 0
	local t1={c:IsHasEffect(EFFECT_UPDATE_DIGILEVEL)}
	for _,te1 in pairs(t1) do
		if type(te1:GetValue())=="function" then
			res=res+te1:GetValue()(te1,c)
		else
			res=res+te1:GetValue()
		end
	end
	local t2={c:IsHasEffect(EFFECT_CHANGE_DIGILEVEL)}
	for _,te2 in pairs(t2) do
		if type(te2:GetValue())=="function" then
			res=te2:GetValue()(te2,c)
		else
			res=te2:GetValue()
		end
	end
	return res
end
--check if a digimon's level is equal to a given value
function Card.IsDigiLevel(c,lv)
	return c:GetDigiLevel()==lv
end
--check if a digimon's level is less than or equal to a given value
function Card.IsDigiLevelBelow(c,lv)
	return c:GetDigiLevel()<=lv
end
--check if a digimon's level is greater than or equal to a given value
function Card.IsDigiLevelAbove(c,lv)
	return c:GetDigiLevel()>=lv
end
--get the cost required to digivolve into this digimon
function Card.GetDigivolveCost(c)
	return c.digivolve_cost or 0
end
--check if the cost required to digivolve into this digimon is equal to a given value
function Card.IsDigivolveCost(c,cost)
	return c:GetDigivolveCost()==cost
end
--check if the cost required to digivolve into this digimon is less than or equal to a given value
function Card.IsDigivolveCostBelow(c,cost)
	return c:GetDigivolveCost()<=cost
end
--check if the cost required to digivolve into this digimon is greater than or equal to a given value
function Card.IsDigivolveCostAbove(c,cost)
	return c:GetDigivolveCost()>=cost
end
--get the color required to digivolve into this digimon
function Card.GetDigivolveColor(c)
	return c.digivolve_color or COLOR_NONE
end
--check if the color required to digivolve into this digimon is a given color
function Card.IsDigivolveColor(c,color)
	return bit.band(c:GetDigivolveColor(),color)~=0
end
--get the level required to digivolve into this digimon
function Card.GetDigivolveLevel(c)
	return c.digivolve_level or 0
end
--check if the level required to digivolve into this digimon is equal to a given value
function Card.IsDigivolveLevel(c,lv)
	return c:GetDigivolveLevel()==lv
end
--check if the level required to digivolve into this digimon is less than or equal to a given value
function Card.IsDigivolveLevelBelow(c,lv)
	return c:GetDigivolveLevel()<=lv
end
--check if the level required to digivolve into this digimon is greater than or equal to a given value
function Card.IsDigivolveLevelAbove(c,lv)
	return c:GetDigivolveLevel()>=lv
end
--check if a digimon's digivolution cards are equal to a given value
function Card.IsDigivolutionCount(c,count)
	return c:GetDigivolutionCount()==count
end
--check if a digimon's digivolution cards are less than or equal to a given value
function Card.IsDigivolutionCountBelow(c,count)
	return c:GetDigivolutionCount()<=count
end
--check if a digimon's digivolution cards are greater than or equal to a given value
function Card.IsDigivolutionCountAbove(c,count)
	return c:GetDigivolutionCount()>=count
end
--check if a digimon can attack during the same turn it is played
function Card.IsCanAttackTurn(c)
	return false
end
--get a digimon's check count
function Card.GetCheckCount(c)
	local res=1
	local t1={c:IsHasEffect(EFFECT_UPDATE_CHECK)}
	for _,te1 in pairs(t1) do
		if type(te1:GetValue())=="function" then
			res=res+te1:GetValue()(te1,c)
		else
			res=res+te1:GetValue()
		end
	end
	local t2={c:IsHasEffect(EFFECT_CHANGE_CHECK)}
	for _,te2 in pairs(t2) do
		if type(te2:GetValue())=="function" then
			res=te2:GetValue()(te2,c)
		else
			res=te2:GetValue()
		end
	end
	return res
end
--check if a digimon can be played
function Card.IsCanBePlayed(c,e,playplayer,playtype)
	return c:IsCanBeSpecialSummoned(e,playtype,playplayer,false,false)
end
--check if a digimon can attack an unsuspended digimon
function Card.IsCanAttackUnsuspended(c)
	return true
end
--check if a digimon can block
function Card.IsCanBlock(c)
	return not c:IsHasEffect(EFFECT_CANNOT_BLOCK)
end
--Renamed Card functions
--get a card's original play cost
Card.GetOriginalPlayCost=Card.GetOriginalLevel
--get a card's color
Card.GetColor=Card.GetAttribute
--get a card's original color
Card.GetOriginalColor=Card.GetOriginalAttribute
--check if a card has a given color
Card.IsColor=Card.IsAttribute
--get a card's original digimon power
Card.GetOriginalPower=Card.GetBaseAttack
--get a digimon's play type (SUMMON_TYPE)
Card.GetPlayType=Card.GetSummonType
--check what a digimon's play type (SUMMON_TYPE) is
Card.IsPlayType=Card.IsSummonType
--get a digimon's digivolution cards
Card.GetDigivolutionGroup=Card.GetOverlayGroup
--get the number of digivolution cards a digimon has
Card.GetDigivolutionCount=Card.GetOverlayCount
--check if a card can be trashed
Card.IsAbleToTrash=Card.IsAbleToGrave
