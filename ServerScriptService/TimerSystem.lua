local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local TimerDataStore = DataStoreService:GetDataStore("Timer")
local key = "___125"
local StopTimer = game.ReplicatedStorage.StopTimer


local function onPlayerAdded(player)
	-- Timer setup for "Tower of Beginner Trials" and "Tower of Enraging Obstacles"
	local ToBT_Timer = Instance.new("NumberValue")
	ToBT_Timer.Name = "ToBT_Timer"
	ToBT_Timer.Value = 0
	ToBT_Timer.Parent = player

	local ToEO_Timer = Instance.new("NumberValue")
	ToEO_Timer.Name = "ToEO_Timer"
	ToEO_Timer.Value = 0
	ToEO_Timer.Parent = player

	local playerUserId = player.UserId

	-- Load saved data
	local success, errormessage = pcall(function()
		local data = TimerDataStore:GetAsync(key .. playerUserId)
		if data then
			ToBT_Timer.Value = data.ToBT_Timer or 0
			ToEO_Timer.Value = data.ToEO_Timer or 0
			print("Loaded timer values for", player.Name, "ToBT:", ToBT_Timer.Value, "ToEO:", ToEO_Timer.Value)
		end
	end)

	if not success then
		warn("Failed to load data for player:", player.Name, errormessage)
	end
end

local function onPlayerRemoving(player)
	local playerUserId = player.UserId
	local ToBT_Timer = player:FindFirstChild("ToBT_Timer")
	local ToEO_Timer = player:FindFirstChild("ToEO_Timer")

	-- Safely retrieve each timer's value
	local ToBT_Value = ToBT_Timer and ToBT_Timer.Value or 0
	local ToEO_Value = ToEO_Timer and ToEO_Timer.Value or 0

	print("Values to save for", player.Name, "ToBT:", ToBT_Value, "ToEO:", ToEO_Value) -- Debugging log

	local success, errormessage = pcall(function()
		TimerDataStore:SetAsync(key .. playerUserId, {
			["ToBT_Timer"] = ToBT_Value, -- Save each timer value separately
			["ToEO_Timer"] = ToEO_Value
		})
	end)

	if success then
		print("Saved timer values for", player.Name, "ToBT:", ToBT_Value, "ToEO:", ToEO_Value) -- Debugging log
	else
		warn("Failed to save data for player:", player.Name, errormessage)
	end
end



-- Handling timer updates sent from the client script
local function onUpdateTimerValue(player, timerType, newValue)
	local timer = player:FindFirstChild(timerType)
	if timer then
		timer.Value = newValue
	end
end

-- Connect to player events
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

-- Create RemoteEvent for timer updates
local UpdateTimerValue = Instance.new("RemoteEvent")
UpdateTimerValue.Name = "UpdateTimerValue"
UpdateTimerValue.Parent = game.ReplicatedStorage
UpdateTimerValue.OnServerEvent:Connect(onUpdateTimerValue)

game:BindToClose(function()
	for _, player in pairs(Players:GetPlayers()) do
		onPlayerRemoving(player)
	end
end)
