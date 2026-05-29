local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local inventoryGui = nil -- UI 에셋이 Rojo로 동기화된 후 참조될 변수

local function ToggleInventory()
	if not inventoryGui then
		-- 임시로 화면 중앙에 텍스트 표시 (UI가 아직 없는 경우를 대비)
		print("Inventory Toggled! (UI Asset pending sync)")
		return
	end
	inventoryGui.Enabled = not inventoryGui.Enabled
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.I then
		ToggleInventory()
	end
end)

print("Inventory Key Handler Loaded. Press 'I' to toggle.")
