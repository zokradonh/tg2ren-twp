--- 
-- TODOs for Salescounter rework:
-- streamline any income/expense into useful categories like autoroute, salescounter and service
-- also display current attractivity/ranking
-- remove messages for buying goods

BALANCE_PREFIX = "Balance"
--BALANCE_TYPES = {"Autoroute", "Salescounter", "Service"}
--BALANCE_SUFFIXES = {"", "Last", "Total"}

function Run()
	CopyAlias("","Workshop")
	
	-- initialize: turn off messages for workshop
	if not HasProperty("Workshop","MsgSell") then
		SetProperty("Workshop","MsgSell",0)
	end
	
	-- differentiate rogue buildings
	local BldType = BuildingGetType("Workshop")
	if GL_BUILDING_TYPE_THIEF == BldType or GL_BUILDING_TYPE_ROBBER == BldType or GL_BUILDING_TYPE_PIRATESNEST == BldType then
		ms_showbalanceworkshop_ShowForRogue("Workshop")
	else
		ms_showbalanceworkshop_ShowForWorkshop("Workshop")
	end 
end

function ShowForWorkshop(BldAlias)
	local BalanceTypes = {"Autoroute", "Salescounter", "Service", "Wages"}
	local Balances = {}
	local TotalBalance = 0
	for i=1, 4 do
		Balances[i] = GetProperty(BldAlias, BALANCE_PREFIX..BalanceTypes[i]) or 0
		TotalBalance = TotalBalance + Balances[i]
	end
	
	local Wages = economy_CalculateWages(BldAlias)
	local Ranking, RankingGoods, RankingCrafty, RankingCharisma, Attractivity = economy_CalculateSalesRanking(BldAlias)
	
	-- TODO add buttons for more information about (1) current attractivity and (b) current prices  
	local Choice = MsgBox("dynasty", BldAlias,
			"@B[ATTR,@L_MEASURE_SHOWBALANCE_SHEET_ATTRACTIVITY_+0,]",--.."@B[PRIC,@L_MEASURE_SHOWBALANCE_SHEET_PRICES_+0,]", 
			"@L_MEASURE_SHOWBALANCE_SHEET_HEAD_+0",
			"@L_MEASURE_SHOWBALANCE_SHEET_BODY_+1",
			GetID(BldAlias), -- %1GG
			TotalBalance, -- %2t total balance
			Wages, -- %3t Wages
			Ranking, -- %4i Ranking
			Balances[1], -- %5t Autoroute 
			Balances[2], -- %6t Salescounter
			Balances[3] -- %7t Services
			)
	if Choice == "ATTR" then
		MsgBoxNoWait("dynasty", BldAlias,
			"@L_MEASURE_SHOWBALANCE_SHEET_ATTRACTIVITY_+0",
			"@L_MEASURE_SHOWBALANCE_SHEET_ATTRACTIVITY_+1",
			Ranking, RankingCharisma, RankingCrafty, RankingGoods, Attractivity
			)
	elseif Choice == "PRIC" then
		-- TODO get estimated prices for each offered item
		MsgBoxNoWait("dynasty", BldAlias,
			"@L_MEASURE_SHOWBALANCE_SHEET_ATTRACTIVITY_+0",
			"@L_MEASURE_SHOWBALANCE_SHEET_ATTRACTIVITY_+1",
			Ranking, RankingCharisma, RankingCrafty, RankingGoods, Attractivity
			)
	end
end

function ShowForRogue(BldAlias)
	local BalanceTypes = {"Autoroute", "Theft", "Wages"}
	local Balances = {}
	local TotalBalance = 0
	for i=1, 3 do
		Balances[i] = GetProperty(BldAlias, BALANCE_PREFIX..BalanceTypes[i]) or 0
		TotalBalance = TotalBalance + Balances[i]
	end
	
	local Wages = economy_CalculateWages(BldAlias)
	
	local Choice = MsgBox("dynasty", BldAlias,
			"", --panel param 
			"@L_MEASURE_SHOWBALANCE_SHEET_HEAD_+0",
			"@L_MEASURE_SHOWBALANCE_SHEET_BODY_+2",
			GetID(BldAlias), -- %1GG
			TotalBalance, -- %2t total balance
			Wages, -- %3t Wages
			Balances[1], -- %4t Autoroute
			Balances[2] -- %5t Theft
			)
end

