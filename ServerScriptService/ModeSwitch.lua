local ModeChangeEvent = game.ReplicatedStorage:WaitForChild("ModeChangeEvent")
local checkUpdater = game.ReplicatedStorage:WaitForChild("checkUpdater")

-- Utility function to update checkpoints
local function updateCheckpoints(folder, modeValue)
	if not folder then
		warn("Checkpoint folder is nil")
		return
	end

	for _, checkpoint in ipairs(folder:GetChildren()) do
		if checkpoint:IsA("BasePart") then
			if modeValue == 2 then
				checkpoint.Transparency = 1
				checkpoint.CanTouch = false
				checkpoint.CanCollide = false
			else
				checkpoint.Transparency = 0
				checkpoint.CanTouch = true
				checkpoint.CanCollide = true
			end
		end
	end
end

-- Handle mode changes
ModeChangeEvent.OnServerEvent:Connect(function(player, newModeValue, tower)
	print("ModeChangeEvent triggered for player: " .. player.Name)
	print("New Mode Value:", newModeValue, "Tower:", tower)

	if tower == "ToBT" then
		local mode = player:FindFirstChild("ToBT_Mode")
		local ToBT_Checks = game.Workspace:FindFirstChild("ToBT_Checkpoints")

		if mode and ToBT_Checks then
			mode.Value = newModeValue
			updateCheckpoints(ToBT_Checks, newModeValue)
			print("ToBT mode changed to " .. newModeValue .. " for player: " .. player.Name)
		elseif not mode then
			warn("ToBT_Mode value not found for player: " .. player.Name)
		elseif not ToBT_Checks then
			warn("ToBT_Checkpoints folder not found in Workspace.")
		end
	end

	if tower == "ToEO" then
		local mode = player:FindFirstChild("ToEO_Mode")
		local ToEO_Checks = game.Workspace:FindFirstChild("ToEO_Checkpoints")

		if mode and ToEO_Checks then
			mode.Value = newModeValue
			updateCheckpoints(ToEO_Checks, newModeValue)
			print("ToEO mode changed to " .. newModeValue .. " for player: " .. player.Name)
		elseif not mode then
			warn("ToEO_Mode value not found for player: " .. player.Name)
		elseif not ToEO_Checks then
			warn("ToEO_Checkpoints folder not found in Workspace.")
		end
	end
end)

-- Handle checkpoint updates
checkUpdater.OnServerEvent:Connect(function(player, newCheck, tower)
	if tower == "ToBT" then
		local check = player:FindFirstChild("ToBT_checkpoint")

		if check then
			check.Value = newCheck
		else
			warn("ToBT_checkpoint value not found for player: " .. player.Name)
		end
	elseif tower == "ToEO" then
		local check = player:FindFirstChild("ToEO_checkpoint")

		if check then
			check.Value = newCheck
		else
			warn("ToEO_checkpoint value not found for player: ".. player.Name)
		end
	end
end)
