--Temporary Card functions
--check if a card's play cost is equal to a given value
--Note: See Card.GetPlayCost
local card_is_level=Card.IsLevel
function Card.IsLevel(c,lv)
	if card_is_level then
		return card_is_level(c,lv)
	else
		return c:GetLevel()==lv
	end
end
--check if a card's digimon power is equal to a given value
local card_is_attack=Card.IsAttack
function Card.IsAttack(c,atk)
	if card_is_attack then
		return card_is_attack(c,atk)
	else
		return c:GetAttack()==atk
	end
end
--check if a card has a particular property
--Note: Overwritten to check for an infinite number of properties
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
--check if a digimon can be played
--Note: Overwritten to include Duel.CheckBattleArea
local card_is_can_be_special_summoned=Card.IsCanBeSpecialSummoned
function Card.IsCanBeSpecialSummoned(c,e,playtype,playplayer,...)
	if not Duel.CheckBattleArea(playplayer) then return false end
	return card_is_can_be_special_summoned(c,e,playtype,playplayer,...)
end
--add a counter to a card
--Note: Overwritten to not add 0 or negative counters
local card_add_counter=Card.AddCounter
function Card.AddCounter(c,countertype,count,singly)
	if count<=0 then
		return true
	else
		return card_add_counter(c,countertype,count,singly)
	end
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
	return c:IsPosition(POS_FACEUP_SUSPENDED)
end
--check if a card can be suspended
function Card.IsAbleToSuspend(c)
	return c:IsPosition(POS_FACEUP_UNSUSPENDED)
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
--check if the color required to digivolve into this digimon is a particular color
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
--get a card's check count
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
	return res
end
--check if a digimon can be played
function Card.IsCanBePlayed(c,e,playplayer)
	return c:IsCanBeSpecialSummoned(e,0,playplayer,false,false)
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
--get a card's color
Card.GetColor=Card.GetAttribute
--get a card's original color
Card.GetOriginalColor=Card.GetOriginalAttribute
--check if a card has a particular color
Card.IsColor=Card.IsAttribute
--get a card's current digimon power
Card.GetPower=Card.GetAttack
--check if a card's digimon power is equal to a given value
Card.IsPower=Card.IsAttack
--check if a card's digimon power is less than or equal to a given value
Card.IsPowerBelow=Card.IsAttackBelow
--check if a card's digimon power is greater than or equal to a given value
Card.IsPowerAbove=Card.IsAttackAbove
--get a card's original play cost
Card.GetOriginalPlayCost=Card.GetOriginalLevel
--get a digimon's digivolution cards
Card.GetDigivolutionGroup=Card.GetOverlayGroup
--get the number of digivolution cards a digimon has
Card.GetDigivolutionCount=Card.GetOverlayCount
--check if a card can be trashed
Card.IsAbleToTrash=Card.IsAbleToGrave
--get a digimon's play type (SUMMON_TYPE)
Card.GetPlayType=Card.GetSummonType
--check what a digimon's play type (SUMMON_TYPE) is
Card.IsPlayType=Card.IsSummonType
