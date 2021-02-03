--Overwritten Group functions
--select a specified card from a group
--Note: Overwritten to notify a player if there are no cards to select
local group_filter_select=Group.FilterSelect
function Group.FilterSelect(g,player,f,min,max,ex,...)
	if not g:IsExists(f,1,ex,...) then Duel.Hint(HINT_MESSAGE,player,ERROR_NOTARGETS) end
	return group_filter_select(g,player,f,min,max,ex,...)
end
--select a card from a group
--Note: Overwritten to notify a player if there are no cards to select
local group_select=Group.Select
function Group.Select(g,player,min,max,ex)
	if g:GetCount()==0 then Duel.Hint(HINT_MESSAGE,player,ERROR_NOTARGETS) end
	return group_select(g,player,min,max,ex)
end
--select a number of cards from a group at random
--Note: Overwritten to notify a player if there are no cards to select
local group_random_select=Group.RandomSelect
function Group.RandomSelect(g,player,min)
	if g:GetCount()==0 then Duel.Hint(HINT_MESSAGE,player,ERROR_NOTARGETS) end
	return group_random_select(g,player,min)
end
