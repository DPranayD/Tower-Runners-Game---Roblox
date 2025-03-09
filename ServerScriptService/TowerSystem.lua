local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local TCDataStore = DataStoreService:GetDataStore("Completed")
local key = "___125"

-- Function to handle data loading for a player
local function onPlayerAdded(player)
	-- Tower of Beginner Trials
	local ToBT = Instance.new("NumberValue")
	ToBT.Name = "ToBT_Tower"
	ToBT.Value = 0
	ToBT.Parent = player

	local ToBT_checks = Instance.new("NumberValue")
	ToBT_checks.Name = "ToBT_checkpoint"
	ToBT_checks.Value = 0
	ToBT_checks.Parent = player

	local ToBT_Mode = Instance.new("NumberValue")
	ToBT_Mode.Name = "ToBT_Mode"
	ToBT_Mode.Value = 0
	ToBT_Mode.Parent = player

	-- Tower of Enraging Obstacles
	local ToEO = Instance.new("NumberValue")
	ToEO.Name = "ToEO_Tower"
	ToEO.Value = 0
	ToEO.Parent = player

	local ToEO_checks = Instance.new("NumberValue")
	ToEO_checks.Name = "ToEO_checkpoint"
	ToEO_checks.Value = 0
	ToEO_checks.Parent = player
	
	local ToEO_Mode = Instance.new("NumberValue")
	ToEO_Mode.Name = "ToEO_Mode"
	ToEO_Mode.Value = 0
	ToEO_Mode.Parent = player

	local playerUserId = player.UserId

	local success, errormessage = pcall(function()
		local data = TCDataStore:GetAsync(key .. playerUserId)
		if data then
			-- Load the saved values if they exist
			ToBT.Value = data.ToBT or 0
			ToBT_checks.Value = data.ToBT_checks or 0
			ToBT_Mode.Value = data.ToBT_Mode or 0
			ToEO.Value = data.ToEO or 0
			ToEO_checks.Value = data.ToEO_checks or 0
			ToEO_Mode.Value = data.ToEO_Mode or 0

			print("Data loaded for", player.Name)
		end
	end)

	if not success then
		warn("Data loading error for player " .. player.Name .. ": " .. errormessage)
	end
end

-- Function to handle data saving when a player leaves
local function onPlayerRemoving(player)
	local playerUserId = player.UserId

	local ToBT = player:FindFirstChild("ToBT_Tower")
	local ToBT_checks = player:FindFirstChild("ToBT_checkpoint")
	local ToBT_Mode = player:FindFirstChild("ToBT_Mode")
	local ToEO = player:FindFirstChild("ToEO_Tower")
	local ToEO_checks = player:FindFirstChild("ToEO_checkpoint")
	local ToEO_Mode = player:FindFirstChild("ToEO_Mode")

	if ToBT and ToBT_checks and ToBT_Mode and ToEO and ToEO_checks and ToEO_Mode then
		local success, errormessage = pcall(function()
			TCDataStore:SetAsync(key .. playerUserId, {
				["ToBT"] = ToBT.Value,
				["ToBT_checks"] = ToBT_checks.Value,
				["ToBT_Mode"] = ToBT_Mode.Value,
				["ToEO"] = ToEO.Value,
				["ToEO_checks"] = ToEO_checks.Value,
				["ToEO_Mode"] = ToEO_Mode.Value,
			})
		end)

		if success then
			print("Data saved for", player.Name)
		else
			warn("Data saving error for player " .. player.Name .. ": " .. errormessage)
		end
	else
		warn("Could not save data for player " .. player.Name .. " because some values were missing.")
	end
end

-- Save data for all players when the game closes
local function saveAllPlayerData()
	for _, player in pairs(Players:GetPlayers()) do
		onPlayerRemoving(player)
	end
end



-- Connect to player events
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)



game:BindToClose(saveAllPlayerData)
