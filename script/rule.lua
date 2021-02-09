Rule={}
--register rules
--Not fully implemented: Tap a card to have it attack
function Rule.RegisterRules(c)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_NO_TURN_RESET)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_ALL)
	e1:SetCountLimit(1)
	e1:SetOperation(Rule.ApplyRules)
	c:RegisterEffect(e1)
end
function Rule.ApplyRules(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(PLAYER_ONE,FLAG_CODE_RULES)>0 then return end
	Duel.RegisterFlagEffect(PLAYER_ONE,FLAG_CODE_RULES,0,0,0)
	--remove rules
	Rule.remove_rules(PLAYER_ONE)
	Rule.remove_rules(PLAYER_TWO)
	--shuffle deck
	Rule.shuffle_deck(PLAYER_ONE)
	Rule.shuffle_deck(PLAYER_TWO)
	--shuffle digi-egg deck
	--Duel.ShuffleDigiEgg(PLAYER_ONE)
	--Duel.ShuffleDigiEgg(PLAYER_TWO)
	--workaround to shuffle digi-egg deck
	Rule.shuffle_digiegg_deck(PLAYER_ONE)
	Rule.shuffle_digiegg_deck(PLAYER_TWO)
	--check deck size
	local b1=Duel.GetFieldGroupCount(PLAYER_ONE,LOCATION_DECK,0)~=50
	local b2=Duel.GetFieldGroupCount(PLAYER_TWO,LOCATION_DECK,0)~=50
	--check digi-egg deck size
	local b3=Duel.GetFieldGroupCount(PLAYER_ONE,LOCATION_DIGIEGG,0)>5
	local b4=Duel.GetFieldGroupCount(PLAYER_TWO,LOCATION_DIGIEGG,0)>5
	if b1 then Duel.Hint(HINT_MESSAGE,PLAYER_ONE,ERROR_DECKCOUNT) end
	if b2 then Duel.Hint(HINT_MESSAGE,PLAYER_TWO,ERROR_DECKCOUNT) end
	if b3 then Duel.Hint(HINT_MESSAGE,PLAYER_ONE,ERROR_DIGIEGGCOUNT) end
	if b4 then Duel.Hint(HINT_MESSAGE,PLAYER_TWO,ERROR_DIGIEGGCOUNT) end
	if (b1 and b2) or (b3 and b4) then
		Duel.Win(PLAYER_NONE,WIN_REASON_INVALID)
		return
	elseif b1 or b3 then
		Duel.Win(PLAYER_TWO,WIN_REASON_INVALID)
		return
	elseif b2 or b4 then
		Duel.Win(PLAYER_ONE,WIN_REASON_INVALID)
		return
	end
	--set lp
	Duel.SetLP(PLAYER_ONE,1)
	Duel.SetLP(PLAYER_TWO,1)
	--set memory
	Duel.SetMemory(PLAYER_ONE,0)
	Duel.SetMemory(PLAYER_TWO,0)
	--set security cards
	Duel.SendDecktoSecurity(PLAYER_ONE,5,REASON_RULE)
	Duel.SendDecktoSecurity(PLAYER_TWO,5,REASON_RULE)
	--draw starting hand
	Duel.Draw(PLAYER_ONE,5,REASON_RULE)
	Duel.Draw(PLAYER_TWO,5,REASON_RULE)
	--unsuspend phase
	local e1=Effect.GlobalEffect()
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetDescription(DESC_UNSUSPEND_PHASE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_UNSUSPEND_PHASE)
	e1:SetCondition(Rule.UnsuspendCondition)
	e1:SetOperation(Rule.UnsuspendOperation)
	Duel.RegisterEffect(e1,0)
	--breeding phase
	local e2=Effect.GlobalEffect()
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetDescription(DESC_BREEDING_PHASE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_BREEDING)
	e2:SetCountLimit(1)
	e2:SetOperation(Rule.BreedingOperation)
	Duel.RegisterEffect(e2,0)
	--cannot attack (summoning sickness)
	local e3=Effect.GlobalEffect()
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(Rule.CannotAttackTarget)
	Duel.RegisterEffect(e3,0)
	--add description (summoning sickness)
	local e3b=Effect.GlobalEffect()
	e3b:SetDescription(DESC_SUMMONSICKNESS)
	e3b:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CLIENT_HINT)
	e3b:SetType(EFFECT_TYPE_SINGLE)
	local e3c=Effect.GlobalEffect()
	e3c:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3c:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3c:SetTarget(Rule.CannotAttackTarget)
	e3c:SetLabelObject(e3b)
	Duel.RegisterEffect(e3c,0)
	--tap to attack workaround
	local e4=Effect.GlobalEffect()
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_DAMAGE_STEP_END)
	e4:SetOperation(Rule.AttackTapOperation)
	Duel.RegisterEffect(e4,0)
	--enable attack player
	local e5=Effect.GlobalEffect()
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_ATTACK_PLAYER)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	Duel.RegisterEffect(e5,0)
	--check security
	local e6=Effect.GlobalEffect()
	e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_ATTACK_PLAYER)
	e6:SetCondition(Rule.CheckCondition)
	e6:SetOperation(Rule.CheckOperation)
	Duel.RegisterEffect(e6,0)
	--trash resolved cards
	local e7=Effect.GlobalEffect()
	e7:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_CHAINING)
	e7:SetOperation(Rule.ResolveOperation1)
	Duel.RegisterEffect(e7,0)
	local e8=e7:Clone()
	e8:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_DELAY)
	e8:SetCode(EVENT_CHAIN_SOLVED)
	e8:SetOperation(Rule.ResolveOperation2)
	Duel.RegisterEffect(e8,0)
	--pass turn
	local e9=Effect.GlobalEffect()
	e9:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_PHASE+PHASE_END)
	e9:SetCountLimit(1)
	e9:SetOperation(Rule.PassOperation)
	Duel.RegisterEffect(e9,0)
	--delete 0 digimon power
	local e10=Effect.GlobalEffect()
	e10:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_ADJUST)
	e10:SetOperation(Rule.DeleteOperation)
	Duel.RegisterEffect(e10,0)
	--trash level 2 or lower
	local e11=e10:Clone()
	e11:SetOperation(Rule.TrashOperation)
	Duel.RegisterEffect(e11,0)
	--override yugioh rules
	--attack first turn
	Rule.attack_first_turn()
	--cannot summon
	Rule.cannot_summon()
	--cannot mset
	Rule.cannot_mset()
	--cannot sset
	Rule.cannot_sset()
	--infinite hand
	Rule.infinite_hand()
	--infinite attacks
	Rule.infinite_attacks()
	--cannot conduct main phase 2
	Rule.cannot_main_phase2()
	--cannot change position
	Rule.cannot_change_position()
	--no battle damage
	Rule.avoid_battle_damage()
	--set def equal to atk
	Rule.def_equal_atk()
	--destroy equal/less def
	Rule.destroy_equal_less_def()
	--cannot replay
	Rule.cannot_replay()
	--ignore extra monster zone
	Rule.ignore_extra_monster_zone()
end
--remove rules
function Rule.remove_rules(tp)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_ALL,0,nil,CARD_RULES)
	if g:GetCount()>0 then
		Duel.DisableShuffleCheck()
		Duel.SendtoDeck(g,PLAYER_OWNER,SEQ_DECK_UNEXIST,REASON_RULE)
	end
	--add memory gauge
	local c=Duel.CreateToken(tp,CARD_MEMORY_GAUGE)
	Duel.MoveToField(c,PLAYER_ONE,tp,LOCATION_SZONE,POS_FACEUP,true)
end
--shuffle deck
function Rule.shuffle_deck(tp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoDeck(g,PLAYER_OWNER,SEQ_DECK_SHUFFLE,REASON_RULE)
	Duel.ShuffleDeck(tp)
end
--workaround to shuffle digi-egg deck
function Rule.shuffle_digiegg_deck(tp)
	local g1=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_DIGIEGG,0,nil)
	if g1:GetCount()<=1 then return end
	Duel.Remove(g1,POS_FACEDOWN,REASON_RULE)
	local g2=Group.CreateGroup()
	for c in aux.Next(g1) do
		Duel.MoveToField(c,tp,tp,LOCATION_MZONE,POS_FACEDOWN_UNSUSPENDED,true)
		g2:AddCard(c)
	end
	Duel.ShuffleSetCard(g2)
	Duel.SendtoDeck(g2,PLAYER_OWNER,SEQ_DECK_SHUFFLE,REASON_RULE)
end
--unsuspend phase
function Rule.UnsuspendCondition(e)
	return Duel.IsExistingMatchingCard(Card.IsAbleToUnsuspendRule,Duel.GetTurnPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function Rule.UnsuspendOperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToUnsuspendRule,Duel.GetTurnPlayer(),LOCATION_ONFIELD,0,nil)
	Duel.ChangePosition(g,POS_FACEUP_UNSUSPENDED)
end
--breeding phase
function Rule.MoveDigimonFilter(c)
	return c:IsFaceup() and c:IsDigiLevelAbove(3) and c:IsSequence(SEQ_MZONE_EX_LEFT)
end
function Rule.BreedingOperation(e,tp,eg,ep,ev,re,r,rp)
	local turnp=Duel.GetTurnPlayer()
	local c=Duel.GetFirstMatchingCard(Rule.MoveDigimonFilter,turnp,LOCATION_MZONE,0,nil)
	local option_list={}
	local t={}
	if not c and Duel.CheckBreedingArea(turnp) and Duel.GetFieldGroupCount(turnp,LOCATION_DIGIEGG,0)>0 then
		table.insert(option_list,OPTION_HATCH)
		table.insert(t,1)
		table.insert(option_list,OPTION_SKIP)
		table.insert(t,3)
	end
	if c and Duel.CheckBattleArea(turnp) then
		table.insert(option_list,OPTION_MOVE)
		table.insert(t,2)
		table.insert(option_list,OPTION_SKIP)
		table.insert(t,3)
	end
	if #t==0 then return end
	local opt=t[Duel.SelectOption(turnp,table.unpack(option_list))+1]
	--hatch
	if opt==1 then
		--Duel.ConfirmDigiEggtop(turnp,1)
		--local c=Duel.GetDigiEggtopGroup(turnp,1):GetFirst()
		local c=Duel.GetMatchingGroup(aux.TRUE,turnp,LOCATION_DIGIEGG,0,nil):GetFirst()
		Duel.SendtoBreeding(c)
	--move
	elseif opt==2 then
		local check1=true
		local check2=true
		local check3=true
		local check4=true
		local g=Duel.GetMatchingGroup(Card.IsSequenceBelow,turnp,LOCATION_MZONE,0,nil,4)
		for tc in aux.Next(g) do
			if tc:IsSequence(SEQ_MZONE_MID_LEFT) then check1=false end
			if tc:IsSequence(SEQ_MZONE_MID) then check2=false end
			if tc:IsSequence(SEQ_MZONE_MID_RIGHT) then check3=false end
			if tc:IsSequence(SEQ_MZONE_RIGHT) then check4=false end
		end
		if check1 then Duel.MoveSequence(c,SEQ_MZONE_MID_LEFT)
		elseif check2 then Duel.MoveSequence(c,SEQ_MZONE_MID)
		elseif check3 then Duel.MoveSequence(c,SEQ_MZONE_MID_RIGHT)
		elseif check4 then Duel.MoveSequence(c,SEQ_MZONE_RIGHT) end
	--skip
	elseif opt==3 then
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SKIP_SP)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_BREEDING)
		Duel.RegisterEffect(e1,0)
	end
end
--cannot attack (summoning sickness)
function Rule.CannotAttackTarget(e,c)
	return c:IsStatus(STATUS_PLAY_TURN) and not c:IsCanAttackTurn()
end
--tap to attack workaround
function Rule.AttackTapOperation(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	if a:IsRelateToBattle() then
		Duel.ChangePosition(a,POS_FACEUP_SUSPENDED)
	end
end
--check security
function Rule.CheckCondition(e)
	return Duel.GetAttackTarget()==nil
end
function Rule.CheckOperation(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local cp=a:GetControler()
	local ct=a:GetCheckCount()
	if ct>0 then
		for i=1,ct do
			local g=Duel.GetFieldGroup(cp,0,LOCATION_SECURITY)
			local c=g:GetFirst()
			if not a:IsOnField() or a:IsStatus(STATUS_BATTLE_DESTROYED) or not c then break end
			--ignore yugioh rules
			--no battle damage
			Rule.no_battle_damge(c,tp)
			--workaround to flip over the top security card
			Duel.SendtoHand(c,PLAYER_OWNER,REASON_RULE)
			Duel.ConfirmCards(1-c:GetControler(),c)
			if c:IsType(TYPE_DIGIMON) then
				--become security digimon
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetValue(TYPE_MONSTER+TYPE_SECURITY)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e1)
				--battle
				Duel.CalculateDamage(a,c)
				--trash (damage step end)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_DAMAGE_STEP_END)
				e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e2:SetLabelObject(c)
				e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
					local c=e:GetLabelObject()
					if not c:IsLocation(LOCATION_TRASH) then
						Duel.Trash(c,REASON_RULE)
					end
				end)
				e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
				Duel.RegisterEffect(e2,tp)
			end
			--raise event for "[Security]" effects
			Duel.RaiseSingleEvent(c,EVENT_CUSTOM+EVENT_CHECK_SECURITY,e,0,0,0,0)
		end
	else
		if Duel.GetSecurityCount(1-cp)>0 then
			--ignore yugioh rules
			--no battle damage
			Rule.no_battle_damge(e:GetHandler(),tp)
		end
	end
end
function Rule.no_battle_damge(c,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
--trash resolved cards
function Rule.ResolveOperation1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:GetFlagEffect(1)==0 and (rc:IsType(TYPE_OPTION) or re:IsHasCategory(CATEGORY_SECURITY)) then
		rc:RegisterFlagEffect(1,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	end
end
function Rule.ResolveOperation2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:IsHasProperty(EFFECT_FLAG_CANCEL_TRASH) then return end
	if rc:GetFlagEffect(1)>0 then
		Duel.Trash(rc,REASON_RULE)
	end
end
--pass turn
function Rule.PassOperation(e,tp,eg,ep,ev,re,r,rp)
	local turnp=Duel.GetTurnPlayer()
	if Duel.GetFlagEffect(turnp,FLAG_CODE_OVERSPENT)==0 then
		Duel.SetMemory(turnp,0)
		Duel.SetMemory(1-turnp,3)
	end
	Duel.ResetFlagEffect(turnp,FLAG_CODE_OVERSPENT)
end
--delete 0 digimon power
function Rule.DeleteFilter(c)
	return c:IsFaceup() and c:IsType(TYPE_DIGIMON) and c:IsPower(0)
		and c:IsSequenceBelow(4) and not c:IsStatus(STATUS_DELETE_CONFIRMED)
end
function Rule.DeleteOperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Rule.DeleteFilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	if Duel.Delete(g,REASON_ZERODP+REASON_RULE)>0 then
		Duel.Readjust()
	end
end
--trash level 2 or lower
function Rule.TrashFilter(c)
	return c:IsFaceup() and c:IsType(TYPE_DIGIMON) and c:IsLevelBelow(2)
		and c:IsSequenceBelow(4) and not c:IsStatus(STATUS_DELETE_CONFIRMED)
end
function Rule.TrashOperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Rule.TrashFilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	if Duel.Trash(g,REASON_RULE)>0 then
		Duel.Readjust()
	end
end
--override yugioh rules
--attack first turn
function Rule.attack_first_turn()
	local e1=Effect.GlobalEffect()
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_BP_FIRST_TURN)
	e1:SetTargetRange(1,1)
	Duel.RegisterEffect(e1,0)
end
--cannot summon
function Rule.cannot_summon()
	local e1=Effect.GlobalEffect()
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetTargetRange(1,1)
	Duel.RegisterEffect(e1,0)
end
--cannot mset
function Rule.cannot_mset()
	local e1=Effect.GlobalEffect()
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_MSET)
	e1:SetTargetRange(1,1)
	Duel.RegisterEffect(e1,0)
end
--cannot sset
function Rule.cannot_sset()
	local e1=Effect.GlobalEffect()
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SSET)
	e1:SetTargetRange(1,1)
	Duel.RegisterEffect(e1,0)
end
--infinite hand
function Rule.infinite_hand()
	local e1=Effect.GlobalEffect()
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_HAND_LIMIT)
	e1:SetTargetRange(1,1)
	e1:SetValue(MAX_NUMBER)
	Duel.RegisterEffect(e1,0)
end
--infinite attacks
function Rule.infinite_attacks()
	local e1=Effect.GlobalEffect()
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetValue(MAX_NUMBER)
	Duel.RegisterEffect(e1,0)
end
--cannot conduct main phase 2
function Rule.cannot_main_phase2()
	local e1=Effect.GlobalEffect()
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SKIP_M2)
	e1:SetTargetRange(1,1)
	Duel.RegisterEffect(e1,0)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_M2)
	Duel.RegisterEffect(e2,0)
end
--cannot change position
function Rule.cannot_change_position()
	local e1=Effect.GlobalEffect()
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	Duel.RegisterEffect(e1,0)
end
--no battle damage
function Rule.avoid_battle_damage()
	local e1=Effect.GlobalEffect()
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetValue(1)
	Duel.RegisterEffect(e1,0)
end
--set def equal to atk
function Rule.def_equal_atk()
	local e1=Effect.GlobalEffect()
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_BASE_DEFENSE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetValue(function(e,c)
		return c:GetPower()
	end)
	Duel.RegisterEffect(e1,0)
end
--destroy equal/less def
function Rule.destroy_equal_less_def()
	local e1=Effect.GlobalEffect()
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetOperation(Rule.DestroyOperation)
	Duel.RegisterEffect(e1,0)
end
function Rule.DestroyOperation(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a or not a:IsOnField() or not d or not d:IsOnField() or not d:IsDefensePos() then return end
	local ef1=a:IsHasEffect(EFFECT_INDESTRUCTIBLE) or a:IsHasEffect(EFFECT_INDESTRUCTIBLE_BATTLE)
	local ef2=d:IsHasEffect(EFFECT_INDESTRUCTIBLE) or d:IsHasEffect(EFFECT_INDESTRUCTIBLE_BATTLE)
	local g=Group.CreateGroup()
	if a:GetAttack()<d:GetDefense() then
		if not ef1 and a:IsRelateToBattle() then g:AddCard(a) end
	elseif a:GetAttack()==d:GetDefense() then
		if not ef1 and a:IsRelateToBattle() then g:AddCard(a) end
		if not ef2 and d:IsRelateToBattle() then g:AddCard(d) end
	end
	Duel.Delete(g,REASON_BATTLE+REASON_RULE)
end
--cannot replay
function Rule.cannot_replay()
	local e1=Effect.GlobalEffect()
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_ONFIELD) and Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local a=Duel.GetAttacker()
		local d=Duel.GetAttackTarget()
		--[[if not d or not d:IsLocation(LOCATION_MZONE) then
			Duel.ChangePosition(a,POS_FACEUP_SUSPENDED)
			return
		end]]
		Duel.ChangeAttackTarget(d)
	end)
	Duel.RegisterEffect(e1,0)
end
--ignore extra monster zone
function Rule.ignore_extra_monster_zone()
	--cannot attack
	local e1=Effect.GlobalEffect()
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSequence,SEQ_MZONE_EX_LEFT))
	Duel.RegisterEffect(e1,0)
	--cannot be battle target
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetValue(aux.TRUE)
	Duel.RegisterEffect(e2,0)
	--negate effect
	local e3=e1:Clone()
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCode(EFFECT_DISABLE)
	Duel.RegisterEffect(e3,0)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_DISABLE_EFFECT)
	Duel.RegisterEffect(e4,0)
	--cannot activate effect
	local e5=Effect.GlobalEffect()
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetTargetRange(1,1)
	e5:SetValue(Rule.CannotActivateValue)
	Duel.RegisterEffect(e5,0)
end
function Rule.CannotActivateValue(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsLocation(LOCATION_MZONE) and rc:IsSequence(SEQ_MZONE_EX_LEFT)
end
