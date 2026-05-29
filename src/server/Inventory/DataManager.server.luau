local ProfileService = require(game:GetService("ReplicatedStorage").Shared.ProfileService)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local UpdateInventoryEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("UpdateInventory")

local PlayerData = {}
local ProfileStore = ProfileService.GetProfileStore("PlayerData_v1", {
	Inventory = {
		{ Id = "Sword_01", Amount = 1 },
		{ Id = "Apple", Amount = 5 }
	},
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
			
			-- 클라이언트에 초기 데이터 전송
			task.wait(1) -- 클라이언트 로딩 대기
			UpdateInventoryEvent:FireClient(player, profile.Data.Inventory)
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
