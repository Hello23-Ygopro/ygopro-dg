Auxiliary={}
aux=Auxiliary

--
function Auxiliary.Stringid(code,id)
	return code*16+id
end
--
function Auxiliary.Next(g)
	local first=true
	return	function()
				if first then first=false return g:GetFirst()
				else return g:GetNext() end
			end
end
--
function Auxiliary.NULL()
end
--
function Auxiliary.TRUE()
	return true
end
--
function Auxiliary.FALSE()
	return false
end
--
function Auxiliary.AND(...)
	local function_list={...}
	return	function(...)
				local res=false
				for i,f in ipairs(function_list) do
					res=f(...)
					if not res then return res end
				end
				return res
			end
end
--
function Auxiliary.OR(...)
	local function_list={...}
	return	function(...)
				local res=false
				for i,f in ipairs(function_list) do
					res=f(...)
					if res then return res end
				end
				return res
			end
end
--
function Auxiliary.NOT(f)
	return	function(...)
				return not f(...)
			end
end
--
function Auxiliary.BeginPuzzle(effect)
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TURN_END)
	e1:SetCountLimit(1)
	e1:SetOperation(Auxiliary.PuzzleOp)
	Duel.RegisterEffect(e1,0)
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_SKIP_DP)
	e2:SetTargetRange(1,0)
	Duel.RegisterEffect(e2,0)
	local e3=Effect.GlobalEffect()
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_SKIP_SP)
	e3:SetTargetRange(1,0)
	Duel.RegisterEffect(e3,0)
end
function Auxiliary.PuzzleOp(e,tp)
	Duel.SetLP(0,0)
end
--
function Auxiliary.TargetEqualFunction(f,value,...)
	local ext_params={...}
	return	function(effect,target)
				return f(target,table.unpack(ext_params))==value
			end
end
--
function Auxiliary.TargetBoolFunction(f,...)
	local ext_params={...}
	return	function(effect,target)
				return f(target,table.unpack(ext_params))
			end
end
--
function Auxiliary.FilterEqualFunction(f,value,...)
	local ext_params={...}
	return	function(target)
				return f(target,table.unpack(ext_params))==value
			end
end
--
function Auxiliary.FilterBoolFunction(f,...)
	local ext_params={...}
	return	function(target)
				return f(target,table.unpack(ext_params))
			end
end
--get a card script's name and id
function Auxiliary.GetID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local scard=_G[str]
	local sid=tonumber(string.sub(str,2))
	return scard,sid
end
--add a setcode to a card
--required to register a card's properties
function Auxiliary.AddSetcode(c,setname)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetValue(setname)
	c:RegisterEffect(e1)
	local m=_G["c"..c:GetOriginalCode()]
	if not m.overlay_setcode_check then
		m.overlay_setcode_check=true
		--fix for cards in LOCATION_DIGIVOLUTION not getting a setcode
		local e2=Effect.GlobalEffect()
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_ADD_SETCODE)
		e2:SetTargetRange(LOCATION_DIGIVOLUTION,LOCATION_DIGIVOLUTION)
		e2:SetLabel(c:GetCode())
		e2:SetTarget(function(e,c)
			return c:GetCode()==e:GetLabel()
		end)
		e2:SetValue(setname)
		Duel.RegisterEffect(e2,0)
	end
end
--register a card's level (lv.)
--required for Card.IsDigiLevel
function Auxiliary.AddLevel(c,val)
	local mt=getmetatable(c)
	mt.level=val
end
--register a card's form
--reserved for Card.IsForm
function Auxiliary.AddForm(c,...)
	if c.form==nil then
		local mt=getmetatable(c)
		mt.form={}
		for _,formname in ipairs{...} do
			table.insert(mt.form,formname)
		end
	else
		for _,formname in ipairs{...} do
			table.insert(c.form,formname)
		end
	end
end
--register a card's attribute
--reserved for Card.IsDigiAttribute
function Auxiliary.AddAttribute(c,...)
	if c.attribute==nil then
		local mt=getmetatable(c)
		mt.attribute={}
		for _,attrname in ipairs{...} do
			table.insert(mt.attribute,attrname)
		end
	else
		for _,attrname in ipairs{...} do
			table.insert(c.attribute,attrname)
		end
	end
end
--register a card's type (race)
--reserved for Card.IsDigiRace
function Auxiliary.AddRace(c,...)
	if c.race==nil then
		local mt=getmetatable(c)
		mt.race={}
		for _,racename in ipairs{...} do
			table.insert(mt.race,racename)
		end
	else
		for _,racename in ipairs{...} do
			table.insert(c.race,racename)
		end
	end
end
--register a card's digivolution conditions
--required for digivolving
function Auxiliary.AddDigivolutionCondition(c,cost,color,lv)
	cost=cost or 0
	color=color or c:GetOriginalColor()
	lv=lv or c.level-1
	local mt=getmetatable(c)
	mt.digivolve_cost=cost
	mt.digivolve_color=color
	mt.digivolve_level=lv
end
--register EFFECT_FLAG_CLIENT_HINT to a card
function Auxiliary.RegisterDescription(c,desc,reset_flag,reset_count)
	reset_flag=reset_flag or 0
	reset_count=reset_count or 1
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+reset_flag,EFFECT_FLAG_CLIENT_HINT,reset_count,0,desc)
end

--digi-egg
function Auxiliary.EnableDigiEggAttribute(c)
	--register card info
	Auxiliary.RegisterCardInfo(c)
end
--register card info
function Auxiliary.RegisterCardInfo(c)
	if not FormList then FormList={} end
	if not AttributeList then AttributeList={} end
	if not RaceList then RaceList={} end
	local m=_G["c"..c:GetCode()]
	--register form
	if m and m.form then
		for _,formname in ipairs(m.form) do
			Auxiliary.AddSetcode(c,formname)
			table.insert(FormList,formname)
		end
	end
	--register attribute
	if m and m.attribute then
		for _,attrname in ipairs(m.attribute) do
			Auxiliary.AddSetcode(c,attrname)
			table.insert(AttributeList,attrname)
		end
	end
	--register race
	if m and m.race then
		for _,racename in ipairs(m.race) do
			Auxiliary.AddSetcode(c,racename)
			table.insert(RaceList,racename)
		end
	end
	--display level
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_PLAY_COST)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetValue(function(e,c)
		return c:GetDigiLevel()
	end)
	c:RegisterEffect(e1)
end

--digimon
function Auxiliary.EnableDigimonAttribute(c)
	--register card info
	Auxiliary.RegisterCardInfo(c)
	--play
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(DESC_PLAY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1)
	e1:SetCondition(Auxiliary.PlayCondition)
	e1:SetCost(Auxiliary.PlayCost)
	e1:SetTarget(Auxiliary.PlayDigimonTarget)
	e1:SetOperation(Auxiliary.PlayDigimonOperation)
	c:RegisterEffect(e1)
	--cannot be battle target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(Auxiliary.CannotBeBattleTargetCondition)
	e2:SetValue(Auxiliary.CannotBeBattleTargetValue)
	c:RegisterEffect(e2)
	--digivolution procedure
	Auxiliary.AddDigivolutionProcedure(c)
end
--play
function Auxiliary.PlayDigimonTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.CheckBattleArea(tp) and c:IsCanBePlayed(e,tp) end
end
function Auxiliary.PlayDigimonOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.PlayDigimon(c,tp)
end
--cannot be battle target
function Auxiliary.CannotBeBattleTargetCondition(e)
	return e:GetHandler():IsPosition(POS_FACEUP_UNSUSPENDED)
end
function Auxiliary.CannotBeBattleTargetValue(e,c)
	return c:IsCanAttackUnsuspended()
end
--digivolution procedure
function Auxiliary.AddDigivolutionProcedure(c)
	--digivolve
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(DESC_DIGIVOLVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1)
	e1:SetCondition(Auxiliary.PlayCondition)
	e1:SetCost(Auxiliary.DigivolveCost)
	e1:SetTarget(Auxiliary.DigivolveTarget)
	e1:SetOperation(Auxiliary.DigivolveOperation)
	c:RegisterEffect(e1)
	--workaround to play in ex mzone (see Duel.Digivolve)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if c:GetFlagEffect(FLAG_CODE_PLAY_EX)>0 then
			Duel.MoveSequence(c,SEQ_MZONE_EX_LEFT)
			c:ResetFlagEffect(FLAG_CODE_PLAY_EX)
		end
	end)
	c:RegisterEffect(e2)
end
--digivolve
function Auxiliary.DigivolveCost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local cost=c:GetDigivolveCost()
	if chk==0 then return Duel.CheckCost(tp,cost) end
	Duel.PayCost(tp,cost)
end
function Auxiliary.DigivolveFilter(c,color,lv)
	return c:IsFaceup() and c:IsColor(color) and c:IsDigiLevel(lv)
end
function Auxiliary.DigivolveTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local color=c:GetDigivolveColor()
	local lv=c:GetDigivolveLevel()
	if chk==0 then return Duel.IsExistingMatchingCard(Auxiliary.DigivolveFilter,tp,LOCATION_MZONE,0,1,nil,color,lv)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>=-1 and c:IsCanBePlayed(e,tp,SUMMON_TYPE_DIGIVOLVE) end
end
function Auxiliary.DigivolveOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local color=c:GetDigivolveColor()
	local lv=c:GetDigivolveLevel()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DIGIVOLVE)
	local g=Duel.SelectMatchingCard(tp,Auxiliary.DigivolveFilter,tp,LOCATION_MZONE,0,1,1,nil,color,lv)
	if g:GetCount()==0 then return end
	Duel.HintSelection(g)
	Duel.Digivolve(c,g,tp)
	Duel.Draw(tp,1,REASON_EFFECT)
end

--tamer
function Auxiliary.EnableTamerAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(Auxiliary.PlayCondition)
	e1:SetCost(Auxiliary.PlayCost)
	e1:SetOperation(Auxiliary.TamerOperation)
	c:RegisterEffect(e1)
	return e1
end
function Auxiliary.TamerOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.PlayTamer(c,tp)
end

--Inherited effects
--e.g. "Koromon" (ST1-01)
function Auxiliary.AddInheritedEffect(c,op_func)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetCondition(Auxiliary.InheritedEffectCondition)
	e1:SetOperation(op_func)
	c:RegisterEffect(e1)
	return e1
end
function Auxiliary.InheritedEffectCondition(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_DIGIVOLVE
end
--"[Security]" effects
--e.g. "Tai Kamiya" (ST1-12)
function Auxiliary.AddSecurityEffect(c,op_func)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SECURITY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_CUSTOM+EVENT_CHECK_SECURITY)
	e1:SetOperation(op_func)
	c:RegisterEffect(e1)
	return e1
end
--"[Main]" effects
--e.g. "Shadow Wing" (ST1-13)
function Auxiliary.AddMainEffect(c,op_func,targ_func)
	targ_func=targ_func or Auxiliary.HintTarget
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	if c:IsType(TYPE_OPTION) then
		e1:SetRange(LOCATION_HAND)
	else
		e1:SetRange(LOCATION_ONFIELD)
	end
	e1:SetHintTiming(TIMING_MAIN_END+TIMING_BATTLE_END,0)
	if c:IsType(TYPE_OPTION) then
		e1:SetCondition(aux.AND(Auxiliary.PlayCondition,Auxiliary.OptionCondition))
	else
		e1:SetCondition(Auxiliary.PlayCondition)
	end
	e1:SetCost(Auxiliary.PlayCost)
	if targ_func then e1:SetTarget(targ_func) end
	e1:SetOperation(op_func)
	c:RegisterEffect(e1)
	local m=_G["c"..c:GetCode()]
	m.main_effect=e1
	return e1
end
function Auxiliary.OptionFilter(c,typ,color)
	return c:IsFaceup() and c:IsType(typ) and c:IsColor(color)
end
function Auxiliary.OptionCondition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local color=c:GetColor()
	return Duel.IsExistingMatchingCard(Auxiliary.BattleAreaFilter(Auxiliary.OptionFilter),tp,LOCATION_MZONE,0,1,nil,TYPE_DIGIMON,color)
		or Duel.IsExistingMatchingCard(Auxiliary.OptionFilter,tp,LOCATION_ONFIELD,0,1,nil,TYPE_TAMER,color)
end
--"<Blocker> (When an opponent's Digimon attacks, you may suspend this Digimon to force the opponent to attack it instead.)"
--e.g. "Coredramon" (ST1-06)
function Auxiliary.EnableBlocker(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(DESC_BLOCKER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(Auxiliary.BlockerCondition)
	e1:SetCost(Auxiliary.BlockerCost)
	e1:SetTarget(Auxiliary.HintTarget)
	e1:SetOperation(Auxiliary.BlockerOperation)
	c:RegisterEffect(e1)
end
function Auxiliary.BlockerCondition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()~=c and c:IsCanBlock()
end
function Auxiliary.BlockerCost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToSuspend()
		and not Duel.GetAttacker():IsStatus(STATUS_ATTACK_CANCELED) and Duel.GetCurrentChain()==0 end
	Duel.ChangePosition(c,POS_FACEUP_SUSPENDED)
end
function Auxiliary.BlockerOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
	local tc=Duel.GetAttacker()
	if not tc or not tc:IsAttackable() or tc:IsImmuneToEffect(e) or tc:IsStatus(STATUS_ATTACK_CANCELED) then return end
	Duel.ChangeAttackTarget(c)
	--raise event for "When this Digimon is blocked"
	Duel.RaiseSingleEvent(tc,EVENT_CUSTOM+EVENT_BECOME_BLOCKED,e,0,0,0,0)
end
--EFFECT_TYPE_SINGLE trigger effects
--code: EVENT_ATTACK_ANNOUNCE for "[When Attacking]" (e.g. "Coredramon" ST1-06)
--code: EVENT_PLAY_SUCCESS for "[When Digivolving]" (e.g. "Garudamon" ST1-08)
--code: EVENT_CUSTOM+EVENT_BECOME_BLOCKED for "When this Digimon is blocked" (e.g. "MetalGreymon" ST1-09)
function Auxiliary.AddSingleTriggerEffect(c,desc_id,code,op_func,prop)
	prop=prop or 0
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(code)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+prop)
	e1:SetTarget(Auxiliary.HintTarget)
	e1:SetOperation(op_func)
	c:RegisterEffect(e1)
	return e1
end
--EFFECT_TYPE_FIELD trigger effects
--code: EVENT_UNSUSPEND_PHASE for "[Start of Your Turn]" (e.g. "Matt Ishida" ST2-12)
function Auxiliary.AddTriggerEffect(c,desc_id,code,op_func,prop)
	prop=prop or 0
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(code)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+prop)
	if c:IsType(TYPE_DIGIMON) then
		e1:SetRange(LOCATION_MZONE)
	elseif c:IsType(TYPE_TAMER) then
		e1:SetRange(LOCATION_SZONE)
	end
	e1:SetTarget(Auxiliary.HintTarget)
	e1:SetOperation(op_func)
	c:RegisterEffect(e1)
	return e1
end
--add an effect to a card
--code: EFFECT_UPDATE_CHECK for "<Security Attack>" (e.g. "WarGreymon" ST1-11)
function Auxiliary.EnableEffectCustom(c,code,con_func,s_range,o_range,targ_func)
	--s_range: the location of your card to provide the effect to
	--o_range: the location of your opponent's card to provide the effect to
	local e1=Effect.CreateEffect(c)
	if s_range or o_range then
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_ONFIELD)
		e1:SetTargetRange(s_range,o_range)
		if targ_func then e1:SetTarget(targ_func) end
	else
		e1:SetType(EFFECT_TYPE_SINGLE)
	end
	e1:SetCode(code)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	if con_func then e1:SetCondition(con_func) end
	c:RegisterEffect(e1)
	return e1
end
--add a temporary effect to a card
--code: EFFECT_UPDATE_CHECK for "<Security Attack>" (e.g. "Greymon" ST1-07)
--code: EFFECT_CANNOT_ATTACK for "can't attack" (e.g. "Sorrow Blue" ST2-14)
--code: EFFECT_CANNOT_BLOCK for "can't block" (e.g. "Sorrow Blue" ST2-14)
function Auxiliary.AddTempEffectCustom(c,tc,code,reset_flag,reset_count)
	--c: the card that adds the effect
	--tc: the card to add the effect to
	reset_flag=reset_flag or 0
	if tc==c then reset_flag=reset_flag+RESET_DISABLE end
	reset_count=reset_count or 1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(code)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+reset_flag,reset_count)
	tc:RegisterEffect(e1)
	return e1
end
--"All of your Digimon get +N000 DP."
--e.g. "Tai Kamiya" (ST1-12)
function Auxiliary.AddContinuousUpdatePower(c,range,val,s_range,o_range,targ_func)
	local e1=Effect.CreateEffect(c)
	if s_range or o_range then
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetTargetRange(s_range,o_range)
		if targ_func then e1:SetTarget(targ_func) end
	else
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	end
	e1:SetCode(EFFECT_UPDATE_POWER)
	e1:SetRange(range)
	e1:SetValue(val)
	c:RegisterEffect(e1)
	return e1
end
--e.g. "Koromon" (ST1-01)
function Auxiliary.AddTempEffectUpdatePower(c,tc,val,reset_flag,reset_count)
	reset_flag=reset_flag or 0
	if tc==c then reset_flag=reset_flag+RESET_DISABLE end
	reset_count=reset_count or 1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_POWER)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+reset_flag,reset_count)
	tc:RegisterEffect(e1)
	return e1
end

--condition to check if the current phase is the battle phase
function Auxiliary.BattlePhaseCondition()
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end
--condition for "[Main]"
function Auxiliary.MainCondition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Auxiliary.BattlePhaseCondition()
end
--condition to play digimon and tamer cards
function Auxiliary.PlayCondition(e,tp,eg,ep,ev,re,r,rp)
	return Auxiliary.MainCondition() and Duel.GetTurnPlayer()==tp and Duel.GetCurrentChain()==0
		and not Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE)
end
--condition for "[Your Turn]"
--e.g. "Koromon" (ST1-01), "MetalGreymon" (ST1-09)
function Auxiliary.TurnPlayerCondition(p)
	return	function(e)
				local tp=e:GetHandlerPlayer()
				local player=(p==PLAYER_SELF and tp) or (p==PLAYER_OPPO and 1-tp)
				return Duel.GetTurnPlayer()==player
			end
end
--condition for "[When Digivolving]"
--e.g. "Garudamon" (ST1-08)
function Auxiliary.DigivolvingCondition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPlayType(SUMMON_TYPE_DIGIVOLVE)
end
--cost to play cards
function Auxiliary.PlayCost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local cost=c:GetPlayCost()
	if chk==0 then return Duel.CheckCost(tp,cost) end
	Duel.PayCost(tp,cost)
end
--target for Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
function Auxiliary.HintTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
--target for effects that target cards
--e.g. "Sorrow Blue" (ST2-14)
function Auxiliary.TargetCardFunction(p,f,s,o,min,max,desc,ex,...)
	--p: the player who targets the card (PLAYER_SELF or PLAYER_OPPO)
	--f: filter function if the card is specified
	--s: your location
	--o: opponent's location
	--min,max: the number of cards to target
	--desc: hint message
	local ext_params={...}
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				local player=(p==PLAYER_SELF and tp) or (p==PLAYER_OPPO and 1-tp)
				max=max or min
				desc=desc or HINTMSG_TARGET
				local exg=Group.CreateGroup()
				if type(ex)=="Card" then exg:AddCard(ex)
				elseif type(ex)=="Group" then exg:Merge(ex)
				elseif type(ex)=="function" then
					exg=ex(e,tp,eg,ep,ev,re,r,rp)
				end
				if chk==0 then
					if e:IsHasType(EFFECT_TYPE_TRIGGER_F) or e:IsHasType(EFFECT_TYPE_QUICK_F) then return true end
					return Duel.IsExistingTarget(f,tp,s,o,1,exg,e,tp,eg,ep,ev,re,r,rp,table.unpack(ext_params))
				end
				Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
				Duel.Hint(HINT_SELECTMSG,player,desc)
				Duel.SelectTarget(player,f,tp,s,o,min,max,exg,e,tp,eg,ep,ev,re,r,rp,table.unpack(ext_params))
			end
end
--operation for effects that let a player (PLAYER_SELF or PLAYER_OPPO) do something
--f: Duel.RemoveMemory to make a player lose memory (e.g. "Coredramon" ST1-06)
--f: Duel.AddMemory to make a player gain memory (e.g. "MetalGreymon" ST1-09)
function Auxiliary.DuelOperation(f,p,...)
	local ext_params={...}
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local player=(p==PLAYER_SELF and tp) or (p==PLAYER_OPPO and 1-tp)
				f(player,table.unpack(ext_params))
			end
end
--operation for effects that increase/reduce digimon power
--e.g. "Garudamon" (ST1-08)
function Auxiliary.UpdatePowerOperation(p,f,s,o,min,max,val,reset_flag,reset_count,ex,...)
	local ext_params={...}
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				local player=(p==PLAYER_SELF and tp) or (p==PLAYER_OPPO and 1-tp)
				max=max or min
				reset_flag=reset_flag or RESET_PHASE+PHASE_END
				reset_count=reset_count or 1
				local desc=(val>0 and HINTMSG_GAINPOWER) or (val<0 and HINTMSG_LOSEPOWER)
				local g=Duel.GetMatchingGroup(aux.AND(Auxiliary.BattleAreaFilter,f),tp,s,o,ex,table.unpack(ext_params))
				if g:GetCount()==0 then return end
				if min and max then
					Duel.Hint(HINT_SELECTMSG,player,desc)
					local sg=g:Select(player,min,max,ex,table.unpack(ext_params))
					Duel.HintSelection(sg)
					--gain/lose digimon power
					Auxiliary.AddTempEffectUpdatePower(c,sg:GetFirst(),val,reset_flag,reset_count)
				else
					for tc in aux.Next(g) do
						--gain/lose digimon power
						Auxiliary.AddTempEffectUpdatePower(c,tc,val,reset_flag,reset_count)
					end
				end
			end
end
--operation for effects that delete cards
--e.g. "Giga Destroyer" (ST1-15)
function Auxiliary.DeleteOperation(p,f,s,o,min,max,ex,...)
	local ext_params={...}
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local player=(p==PLAYER_SELF and tp) or (p==PLAYER_OPPO and 1-tp)
				max=max or min
				local g=Duel.GetMatchingGroup(f,tp,s,o,ex,table.unpack(ext_params))
				if g:GetCount()==0 then return end
				if min and max then
					Duel.Hint(HINT_SELECTMSG,player,HINTMSG_DELETE)
					local sg=g:Select(player,min,max,ex,table.unpack(ext_params))
					local hg=sg:Filter(Card.IsLocation,nil,LOCATION_ONFIELD)
					Duel.HintSelection(hg)
					Duel.Delete(sg,REASON_EFFECT)
				else
					Duel.Delete(g,REASON_EFFECT)
				end
			end
end
--operation for effects that send cards to the hand
--e.g. "Cocytus Breath" (ST2-16)
function Auxiliary.SendtoHandOperation(p,f,s,o,min,max,conf,ex,...)
	--p,min,max: nil to send all cards to the hand
	--conf: true to show cards added from the deck to the opponent
	local ext_params={...}
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local player=(p==PLAYER_SELF and tp) or (p==PLAYER_OPPO and 1-tp)
				max=max or min
				local desc=HINTMSG_RTOHAND
				local g=Duel.GetMatchingGroup(aux.AND(Card.IsAbleToHand,f),tp,s,o,ex,table.unpack(ext_params))
				if g:GetCount()==0 then return end
				if min and max then
					if bit.band(s,LOCATION_DECK)~=0 or bit.band(o,LOCATION_DECK)~=0 then desc=HINTMSG_ATOHAND end
					Duel.Hint(HINT_SELECTMSG,player,desc)
					local sg=g:Select(player,min,max,ex,table.unpack(ext_params))
					local hg=sg:Filter(Card.IsLocation,nil,LOCATION_ONFIELD)
					Duel.HintSelection(hg)
					Duel.SendtoHand(sg,PLAYER_OWNER,REASON_EFFECT)
				else
					Duel.SendtoHand(g,PLAYER_OWNER,REASON_EFFECT)
				end
				local cffilter=function(c,p,loc)
					return c:IsControler(p) and c:IsPreviousLocation(loc)
				end
				local og1=Duel.GetOperatedGroup():Filter(cffilter,nil,tp,LOCATION_DECK)
				local og2=Duel.GetOperatedGroup():Filter(cffilter,nil,1-tp,LOCATION_DECK)
				local og3=Duel.GetOperatedGroup():Filter(cffilter,nil,tp,LOCATION_TRASH+LOCATION_SECURITY+LOCATION_DIGIVOLUTION)
				local og4=Duel.GetOperatedGroup():Filter(cffilter,nil,1-tp,LOCATION_TRASH+LOCATION_SECURITY+LOCATION_DIGIVOLUTION)
				--show cards taken from the deck only if the effect says to do so
				if conf and og1:GetCount()>0 then Duel.ConfirmCards(1-tp,og1) end
				if conf and og2:GetCount()>0 then Duel.ConfirmCards(tp,og2) end
				--show cards taken from the trash, security stack, and digivolution by default
				if og3:GetCount()>0 then Duel.ConfirmCards(1-tp,og3) end
				if og4:GetCount()>0 then Duel.ConfirmCards(tp,og4) end
			end
end
--operation for effects that target digimon to play
--e.g. "Kaiser Nail" (ST2-15)
function Auxiliary.TargetPlayDigimonOperation(pos)
	--pos: POS_FACEUP_UNSUSPENDED to play in unsuspended or POS_FACEUP_SUSPENDED to play in suspended
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
				if not g then return end
				local sg=g:Filter(Card.IsRelateToEffect,nil,e)
				Duel.PlayDigimon(sg,tp,pos)
			end
end
--operation for effects that activate the [Main] effect of the card itself
--e.g. "Giga Destroyer" (ST1-15)
function Auxiliary.SelfActivateMainOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local m=_G["c"..c:GetCode()]
	local te=m.main_effect
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
--operation for effects that change the position of the card itself
--e.g. "MetalGarurumon" (ST2-11)
function Auxiliary.SelfChangePositionOperation(pos)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				Duel.ChangePosition(e:GetHandler(),pos)
			end
end
--filter for a card in the battle area
function Auxiliary.BattleAreaFilter(f)
	return	function(target,...)
				return target:IsLocation(LOCATION_MZONE) and target:IsSequenceAbove(1) and target:IsSequenceBelow(4)
					and (not f or f(target,...))
			end
end
--target/value for a card in the battle area
function Auxiliary.BattleAreaBoolFunction(f,...)
	local ext_params={...}
	return	function(effect,target)
				return target:IsLocation(LOCATION_MZONE) and target:IsSequenceAbove(1) and target:IsSequenceBelow(4)
					and (not f or f(target,table.unpack(ext_params)))
			end
end
--
function loadutility(file)
	local f=loadfile("expansions/script/"..file)
	if f==nil then
		dofile("script/"..file)
	else
		f()
	end
end
loadutility("bit.lua")
loadutility("card.lua")
loadutility("duel.lua")
loadutility("group.lua")
loadutility("lua.lua")
loadutility("rule.lua")
--[[
	References

	Draw Phase
	Q. Is there a maximum hand size?
	A. No, you can have as many cards in your hand as you like.

	Breeding Phase
	Q. I move a Digimon from my breeding area to my battle area. Does the Digimon's [On Play] effect activate?
	A. No, it doesn't. Moving a Digimon to the battle area doesn't count as playing it.

	Main Phase
	Q. I digivolve a suspended Digimon. Does this unsuspend it?
	A. No. If you digivolve a suspended Digimon, it remains suspended.
	Q. If I digivolve into a Digimon that has an [On Play] effect, does it activate?
	A. No. [On Play] effects don't activate with digivolution.
	Q. If a card has a play/use cost of 11 or more, can I use it if your memory gauge is at zero?
	A. No. From zero, you will only be able to move your memory counter to 10 on your opponent's side, but you need to
	move it to 11.
	Q. Multiple card effects have activated at the same time. What order should I resolve them in?
	A. When multiple effects activate, the player who activated those effects decides the order they resolve in.
	Q. Both my opponent and I have activated multiple effects at the same time. What order should we resolve them in?
	A. When multiple players activate effects at the same time, the player whose turn it is starts by resolving their card
	effects in whatever order they like. Then, the other player resolves their card effects in whatever order they like.
	Q. I play an Option card, and paying the play/digivolve cost results in my memory counter moving to 1 on my opponent's
	side. Does the Option card's effect activate?
	A. Yes, it does. After resolving the effect on the card you paid for, or resolving effects resulting from that card, it
	becomes your opponent's turn.
	Q. If a card effect gives me more than 10 memory, what happens?
	A. You can't have more than 10 memory. Any memory exceeding 10 is lost.

	Keyword Effect <Blocker>
	Q. I have two Digimon with <Blocker>. Can I use both of them to block a single attack?
	A. No, you can't. Blocker can't be activated by two Digimon simultaneously.
	Q. Which comes first: resolving "when attacking" effects, or declaring the use of <Blocker>?
	A. Resolving "when attacking" effects comes first. You can decide whether or not to use <Blocker> after seeing how the
	situation plays out.

	Keyword Effect <Draw>
	Q. If I activate a <Draw> effect when my deck is empty, do I lose the game?
	A. No, you only lose the game if you can't draw a card from your deck during your draw phase. Any other situation won't
	cause you to lose the game.
	Q. There's 1 card left in my deck. What happens if I activate <Draw +2>?
	A. Draw as many cards as you can. If you run out of cards to draw, the effect ends.
	
	Effects that make you Gain or Lose Memory
	There are certain effects that can cause you to gain or lose memory. The memory gained or lost is gained or lost by the
	player who uses the card.
	For example, Hammer Spark has a security effect that says "Gain 2 memory" If that card is checked by your opponent's
	attack, you gain 2 memory. From your opponent's point of view, they lose 2 memory.
]]
