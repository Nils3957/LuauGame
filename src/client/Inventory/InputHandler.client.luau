local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local InventoryUI = require(script.Parent.UI.InventoryUI)
local inventoryGui = InventoryUI.CreateMain()
local mainFrame = inventoryGui:WaitForChild("MainFrame")
local scrollFrame = mainFrame:WaitForChild("ItemGrid")

local function ToggleInventory()
	inventoryGui.Enabled = not inventoryGui.Enabled
	UserInputService.MouseIconEnabled = inventoryGui.Enabled
	
	print("!!! INVENTORY TOGGLED !!! Current State:", inventoryGui.Enabled)
	
	if inventoryGui.Enabled then
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	else
		-- 필요 시 마우스 잠금 로직 추가
	end
end

-- 키 입력 감지 (L 키)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.KeyCode == Enum.KeyCode.L then
		print("L KEY DETECTED - TOGGLING INVENTORY")
		ToggleInventory()
	end
end)

-- 초기 슬롯 생성 (25칸)
for i = 1, 25 do
	InventoryUI.CreateSlot(scrollFrame, i)
end

print("Inventory System Reverted to Stable Version. Press 'L' to toggle.")