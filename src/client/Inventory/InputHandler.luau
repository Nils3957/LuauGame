local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local InventoryUI = require(script.Parent.UI.InventoryUI)
local ItemDatabase = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Inventory"):WaitForChild("ItemDatabase"))

local player = Players.LocalPlayer
local inventoryGui = InventoryUI.CreateMain()
local mainFrame = inventoryGui.MainFrame
local scrollFrame = mainFrame.ItemGrid
local searchBox = mainFrame.TopBar.SearchBox

-- 초기 슬롯 생성 (20칸)
local slots = {}
for i = 1, 20 do
	slots[i] = InventoryUI.CreateSlot(scrollFrame, i)
end

local function ToggleInventory()
	inventoryGui.Enabled = not inventoryGui.Enabled
	UserInputService.MouseIconEnabled = inventoryGui.Enabled
	
	if inventoryGui.Enabled then
		-- 열릴 때 데이터 동기화 요청 가능
		print("Inventory Opened")
	end
end

-- 검색 기능
searchBox:GetPropertyChangedSignal("Text"):Connect(function()
	local filter = searchBox.Text:lower()
	-- 실제 아이템 데이터와 연동하여 슬롯 필터링 로직 추가 예정
	print("Filtering for: " .. filter)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.I then
		ToggleInventory()
	end
end)

print("Advanced Programmatic Inventory Ready. Press 'I' to toggle.")
