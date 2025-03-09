local Players = game:GetService("Players")

local TweenService = game:GetService("TweenService")

local debounce = false

workspace.Door.hitbox.Touched:Connect(function(hit)
	if Players:GetPlayerFromCharacter(hit.Parent) then
		local Player = Players:GetPlayerFromCharacter(hit.Parent)
		
		if debounce == false then
			debounce = true
			TweenService:Create(workspace.Door.Door, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {CFrame = workspace.Door.OpenDoor.CFrame}):Play()
			task.wait(2)
			TweenService:Create(workspace.Door.Door, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {CFrame = workspace.Door.BackDoor.CFrame}):Play()
			task.wait(1)
			debounce = false
		end
	end
end)