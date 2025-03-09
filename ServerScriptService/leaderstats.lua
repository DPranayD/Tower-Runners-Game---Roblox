local dataStoreService = game:GetService("DataStoreService")
local towersDataStore = dataStoreService:GetDataStore("Towers1")
local cashDataStore = dataStoreService:GetDataStore("Cash1")

game.Players.PlayerAdded:Connect(function(player)
	local leaderstats = Instance.new("Folder", player)
	leaderstats.Name = "leaderstats"
	
	local towers = Instance.new("IntValue", leaderstats)
	towers.Name = "Towers"
	towers.Value = 0
	
	local cash = Instance.new("IntValue", leaderstats)
	cash.Name = "Cash"
	cash.Value = 0
	
	local playerUserId = player.UserId
	
	--Loading Data
	local towersData
	local success, errormessage = pcall(function()
		towersData = towersDataStore:GetAsync(playerUserId)
	end)
	if success then
		towers.Value = towersData
	end
	
	local cashData
	local success, errormessage = pcall(function()
		cashData = cashDataStore:GetAsync(playerUserId)
	end)
	if success then
		cash.Value = cashData
	end
	
end)

--Saving Data

game.Players.PlayerRemoving:Connect(function(player)
	local playerUserId = player.UserId
	
	local towersValue = player.leaderstats.Towers.Value
	
	local success, errormessage = pcall(function()
		towersDataStore:SetAsync(playerUserId, towersValue)
	end)
	
	local cashValue = player.leaderstats.Cash.Value
	
	local success, errormessage = pcall(function()
		cashDataStore:SetAsync(playerUserId, cashValue)
	end)
end)

game:BindToClose(function()
	for _, player in pairs(game.Players:GetPlayers()) do
		local player_UserId = player.UserId
		
		local towersValue = player.leaderstats.Towers.Value
		
		local success, errormessage = pcall(function()
			towersValue:SetAsync(player_UserId, towersValue)
		end)
		
		local cashValue = player.leaderstats.Cash.Value
		
		local success, errormessage = pcall(function()
			cashDataStore:SetAsync(player_UserId, cashValue)
		end)
	end
end)