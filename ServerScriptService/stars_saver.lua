local Players = game:GetService("Players")
local dataStoreService = game:GetService("DataStoreService")
local StarsDataStore = dataStoreService:GetDataStore("Stars")
local key = "___125"

-- Function to create the Score IntValue when the player joins
local function onPlayerAdded(player)
	-- Create an IntValue to store the player's score
	local e = Instance.new("NumberValue")
	e.Name = "E_Stars"
	e.Value = 0 -- Initial score value is set to 0
	e.Parent = player

	local m = Instance.new("NumberValue")
	m.Name = "M_Stars"
	m.Value = 0
	m.Parent = player

	local h = Instance.new("NumberValue")
	h.Name = "H_Stars"
	h.Value = 0
	h.Parent = player

	local c = Instance.new("NumberValue")
	c.Name = "C_Stars"
	c.Value = 0
	c.Parent = player

	local hc = Instance.new("NumberValue")
	hc.Name = "HC_Stars"
	hc.Value = 0
	hc.Parent = player

	local playerUserId = player.UserId

	local data
	local success, errormessage = pcall(function()
		data = StarsDataStore:GetAsync(key..playerUserId)
	end)
	if success and data then
		e.Value = data.e or 0  -- Default to 0 if the key doesn't exist
		m.Value = data.m or 0
		h.Value = data.h or 0
		c.Value = data.c or 0
		hc.Value = data.hc or 0
	elseif not success then
		warn("Failed to load data for player " .. player.Name .. ": " .. errormessage)
	end
end

local function onPlayerRemoved(player)
	local playerUserId = player.UserId

	local success, errormessage = pcall(function()
		StarsDataStore:SetAsync(key..playerUserId, {
			["e"] = player["E_Stars"].Value,
			["m"] = player["M_Stars"].Value,
			["h"] = player["H_Stars"].Value,
			["c"] = player["C_Stars"].Value,
			["hc"] = player["HC_Stars"].Value,
		})
	end)
	if not success then
		warn("Failed to save data for player " .. player.Name .. ": " .. errormessage)
	end
end

local function BindtoClosed()
	for _, player in pairs(Players:GetPlayers()) do
		local playerUserId = player.UserId

		local success, errormessage = pcall(function()
			StarsDataStore:SetAsync(key..playerUserId, {
				["e"] = player["E_Stars"].Value,
				["m"] = player["M_Stars"].Value,
				["h"] = player["H_Stars"].Value,
				["c"] = player["C_Stars"].Value,
				["hc"] = player["HC_Stars"].Value,
			})
		end)
		if not success then
			warn("Failed to save data for player " .. player.Name .. ": " .. errormessage)
		end
	end
end

-- Connect the PlayerAdded event to the function
Players.PlayerAdded:Connect(onPlayerAdded)

Players.PlayerRemoving:Connect(onPlayerRemoved)

-- Correctly bind the close event
game:BindToClose(BindtoClosed)
