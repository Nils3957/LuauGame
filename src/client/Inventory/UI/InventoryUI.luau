local Players = game:GetService("Players")
local player = Players.LocalPlayer

local InventoryUI = {}

function InventoryUI.CreateMain()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "InventorySystem"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	
	-- 메인 프레임
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 500, 0, 400)
	mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
	mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
	mainFrame.BorderSizePixel = 0
	mainFrame.Parent = screenGui
	
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 10)
	uiCorner.Parent = mainFrame

	-- 상단 바 (제목 및 검색)
	local topBar = Instance.new("Frame")
	topBar.Name = "TopBar"
	topBar.Size = UDim2.new(1, 0, 0, 50)
	topBar.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
	topBar.BorderSizePixel = 0
	topBar.Parent = mainFrame
	
	local topCorner = Instance.new("UICorner")
	topCorner.CornerRadius = UDim.new(0, 10)
	topCorner.Parent = topBar

	local title = Instance.new("TextLabel")
	title.Text = "INVENTORY"
	title.Size = UDim2.new(0, 150, 1, 0)
	title.Position = UDim2.new(0, 20, 0, 0)
	title.TextColor3 = Color3.new(1, 1, 1)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 18
	title.BackgroundTransparency = 1
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = topBar

	-- 검색창
	local searchBox = Instance.new("TextBox")
	searchBox.Name = "SearchBox"
	searchBox.PlaceholderText = "아이템 검색..."
	searchBox.Size = UDim2.new(0, 200, 0, 30)
	searchBox.Position = UDim2.new(1, -220, 0.5, -15)
	searchBox.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
	searchBox.TextColor3 = Color3.new(1, 1, 1)
	searchBox.Font = Enum.Font.Gotham
	searchBox.TextSize = 14
	searchBox.Parent = topBar
	
	local searchCorner = Instance.new("UICorner")
	searchCorner.CornerRadius = UDim.new(0, 5)
	searchCorner.Parent = searchBox

	-- 아이템 그리드 (ScrollingFrame)
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Name = "ItemGrid"
	scrollFrame.Size = UDim2.new(1, -40, 1, -80)
	scrollFrame.Position = UDim2.new(0, 20, 0, 70)
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.ScrollBarThickness = 4
	scrollFrame.ScrollBarImageColor3 = Color3.new(0.5, 0.5, 0.5)
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	scrollFrame.Parent = mainFrame

	local gridLayout = Instance.new("UIGridLayout")
	gridLayout.CellSize = UDim2.new(0, 80, 0, 80)
	gridLayout.CellPadding = UDim2.new(0, 10, 0, 10)
	gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
	gridLayout.Parent = scrollFrame
	
	screenGui.Parent = player:WaitForChild("PlayerGui")
	screenGui.Enabled = false
	
	return screenGui
end

function InventoryUI.CreateSlot(parent, index)
	local slot = Instance.new("Frame")
	slot.Name = "Slot_" .. index
	slot.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
	slot.BorderSizePixel = 0
	slot.Parent = parent
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 5)
	corner.Parent = slot
	
	local icon = Instance.new("ImageLabel")
	icon.Name = "Icon"
	icon.Size = UDim2.new(0.8, 0, 0.8, 0)
	icon.Position = UDim2.new(0.1, 0, 0.1, 0)
	icon.BackgroundTransparency = 1
	icon.Parent = slot
	
	local amount = Instance.new("TextLabel")
	amount.Name = "Amount"
	amount.Size = UDim2.new(0.4, 0, 0.4, 0)
	amount.Position = UDim2.new(0.6, 0, 0.6, 0)
	amount.BackgroundTransparency = 1
	amount.TextColor3 = Color3.new(1, 1, 1)
	amount.TextScaled = true
	amount.Font = Enum.Font.GothamBold
	amount.Text = ""
	amount.Parent = slot
	
	return slot
end

return InventoryUI
