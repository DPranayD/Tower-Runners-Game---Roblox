game.Players.PlayerAdded:Connect(function(plr)
	local check = Instance.new("ObjectValue", plr)
	check.Name = "CurrentCheckpoint"

	plr.CharacterAdded:Connect(function(chr) -- everytime a player dies and respawns
		if not check.Value then return end -- if there's not a checkpoint
		chr.HumanoidRootPart.CFrame = check.Value.CFrame + Vector3.new(0, 5, 0) -- tp the player to the checkpoint 
	end)
end)