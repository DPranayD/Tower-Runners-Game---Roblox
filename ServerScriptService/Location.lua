local ReplicatedStorage = game:GetService("ReplicatedStorage")
local updateLocationEvent = ReplicatedStorage:WaitForChild("UpdateLocation")

-- Function to send a location update to the player's UI
local function onPlayerEnterArea(player, areaName)
	updateLocationEvent:FireClient(player, areaName)
end

-- Example: Setup to trigger when a player touches an area part
local function setupZoneDetection(zonePart, areaName)
	zonePart.Touched:Connect(function(hit)
		local character = hit.Parent
		local player = game.Players:GetPlayerFromCharacter(character)
		if player then
			onPlayerEnterArea(player, areaName)
		end
	end)
end

-- Example: Connect to specific area parts (adjust as needed)
local lobbyZone = game.Workspace.LobbyArea
setupZoneDetection(lobbyZone, "Lobby")

local tower1Zone = game.Workspace.ToBT_Area
setupZoneDetection(tower1Zone, "ToBT")

local tower2Zone = game.Workspace.ToEO_Area
setupZoneDetection(tower2Zone, "ToEO")
