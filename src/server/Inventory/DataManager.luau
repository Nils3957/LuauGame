local ProfileService = require(game:GetService("ReplicatedStorage").Shared.ProfileService)
local Players = game:GetService("Players")

local PlayerData = {}
local ProfileStore = ProfileService.GetProfileStore("PlayerData_v1", {
	Inventory = {},
	Storage = {},
	Coins = 0
})

local function OnPlayerAdded(player)
	local profile = ProfileStore:LoadProfileAsync("Player_" .. player.UserId)
	if profile ~= nil then
		profile:AddUserId(player.UserId)
		profile:Reconcile()
		profile:ListenToRelease(function()
			PlayerData[player] = nil
			player:Kick("Data session released. Please rejoin.")
		end)
		if player:IsDescendantOf(Players) then
			PlayerData[player] = profile
			print(player.Name .. "'s data loaded!")
		else
			profile:Release()
		end
	else
		player:Kick("Failed to load data profile.")
	end
end

Players.PlayerAdded:Connect(OnPlayerAdded)
for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(OnPlayerAdded, player)
end

Players.PlayerRemoving:Connect(function(player)
	local profile = PlayerData[player]
	if profile ~= nil then
		profile:Release()
	end
end)

return PlayerData
