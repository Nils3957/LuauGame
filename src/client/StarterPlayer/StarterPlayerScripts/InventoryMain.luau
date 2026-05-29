--!strict
-- [[ 인벤토리 시스템: 베이스라인 + 정보창 추가 ]]
print("[InventorySystem] 스크립트 실행 시작!")

local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 시각적 가시성을 위한 테마 설정
local THEME = {
	MAIN_BG = Color3.fromRGB(20, 20, 20),
	HEADER_BG = Color3.fromRGB(35, 35, 40),
	PANEL_BG = Color3.fromRGB(30, 30, 35), -- 정보창 배경
	SLOT_BG = Color3.fromRGB(150, 150, 150),
	ACCENT = Color3.fromRGB(0, 160, 255),
	TEXT = Color3.fromRGB(240, 240, 240)
}

-- UI 관리 변수
local screenGui: ScreenGui
local mainFrame: Frame
local header: Frame
local infoPanel: Frame
local slotFrames = {}

local FREEZE_ACTION = "InventoryFreezeAction"

local function SetGameInput(enabled: boolean)
	if enabled then
		ContextActionService:BindAction(FREEZE_ACTION, function() return Enum.ContextActionResult.Sink end, false, Enum.UserInputType.MouseWheel, Enum.UserInputType.Touch)
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	else
		ContextActionService:UnbindAction(FREEZE_ACTION)
	end
end

-- [[ UI 구성 함수 ]]
local function BuildUI()
	local existing = playerGui:FindFirstChild("InventorySystem")
	if existing then existing:Destroy() end

	screenGui = Instance.new("ScreenGui")
	screenGui.Name = "InventorySystem"
	screenGui.ResetOnSpawn = false
	screenGui.Enabled = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = playerGui

	-- [1] 메인 창 (정보창을 위해 넓이 620으로 확장)
	mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 620, 0, 550)
	mainFrame.Position = UDim2.new(0.5, -310, 0.5, -275)
	mainFrame.BackgroundColor3 = THEME.MAIN_BG
	mainFrame.BackgroundTransparency = 0.3
	mainFrame.BorderSizePixel = 0
	mainFrame.Active = true
	mainFrame.ZIndex = 1
	mainFrame.Parent = screenGui
	Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

	-- [2] 헤더 영역
	header = Instance.new("Frame", mainFrame)
	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0, 80)
	header.BackgroundColor3 = THEME.HEADER_BG
	header.BorderSizePixel = 0
	header.Active = true
	header.ZIndex = 5
	header.Parent = mainFrame
	Instance.new("UICorner", header).CornerRadius = UDim.new(0, 10)

	local title = Instance.new("TextLabel", header)
	title.Text = "INVENTORY"
	title.Size = UDim2.new(0.4, 0, 1, 0)
	title.Position = UDim2.new(0, 20, 0, 0)
	title.TextColor3 = THEME.TEXT
	title.Font = Enum.Font.GothamBold
	title.TextSize = 20
	title.BackgroundTransparency = 1
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.ZIndex = 6

	local closeButton = Instance.new("TextButton", header)
	closeButton.Name = "CloseButton"
	closeButton.Text = "X"
	closeButton.Size = UDim2.new(0, 30, 0, 30)
	closeButton.Position = UDim2.new(1, -40, 0.5, -15)
	closeButton.BackgroundTransparency = 1
	closeButton.TextColor3 = THEME.TEXT
	closeButton.Font = Enum.Font.GothamBold
	closeButton.TextSize = 18
	closeButton.ZIndex = 7
	closeButton.Active = true
	closeButton.MouseButton1Click:Connect(function()
		screenGui.Enabled = false
		SetGameInput(false)
	end)

	-- [[ 3. 우측 아이템 상세 정보 패널 ]]
	infoPanel = Instance.new("Frame")
	infoPanel.Name = "InfoPanel"
	infoPanel.Size = UDim2.new(0, 180, 1, -100)
	infoPanel.Position = UDim2.new(0, 420, 0, 90) -- 스크롤 우측
	infoPanel.BackgroundColor3 = THEME.PANEL_BG
	infoPanel.BorderSizePixel = 0
	infoPanel.ZIndex = 2
	infoPanel.Parent = mainFrame
	Instance.new("UICorner", infoPanel).CornerRadius = UDim.new(0, 8)

	local infoName = Instance.new("TextLabel", infoPanel)
	infoName.Name = "ItemName"
	infoName.Size = UDim2.new(1, -20, 0, 40)
	infoName.Position = UDim2.new(0, 10, 0, 10)
	infoName.BackgroundTransparency = 1
	infoName.TextColor3 = THEME.TEXT
	infoName.Font = Enum.Font.GothamBold
	infoName.TextSize = 16
	infoName.TextWrapped = true
	infoName.Text = "아이템 선택"
	infoName.ZIndex = 3

	local infoDesc = Instance.new("TextLabel", infoPanel)
	infoDesc.Name = "ItemDesc"
	infoDesc.Size = UDim2.new(1, -20, 1, -60)
	infoDesc.Position = UDim2.new(0, 10, 0, 50)
	infoDesc.BackgroundTransparency = 1
	infoDesc.TextColor3 = THEME.TEXT
	infoDesc.Font = Enum.Font.Gotham
	infoDesc.TextSize = 14
	infoDesc.TextXAlignment = Enum.TextXAlignment.Left
	infoDesc.TextYAlignment = Enum.TextYAlignment.Top
	infoDesc.TextWrapped = true
	infoDesc.Text = "아이템을 클릭하면 상세 정보가 이곳에 표시됩니다."
	infoDesc.ZIndex = 3

	-- [[ 4. 스크롤 프레임 구성 ]]
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Name = "ItemGridScroll"
	scrollFrame.Size = UDim2.new(0, 400, 1, -100) -- 너비를 400으로 축소
	scrollFrame.Position = UDim2.new(0, 10, 0, 90)
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.ScrollBarThickness = 8
	scrollFrame.ScrollBarImageColor3 = THEME.ACCENT
	scrollFrame.Active = true
	scrollFrame.ZIndex = 2
	scrollFrame.Parent = mainFrame

	-- UIGridLayout 생성
	local gridLayout = Instance.new("UIGridLayout")
	gridLayout.CellSize = UDim2.new(0, 70, 0, 70)
	gridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
	gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
	gridLayout.FillDirectionMaxCells = 5
	gridLayout.Parent = scrollFrame

	-- [매우 중요] 로블록스의 AutomaticCanvasSize 버그 방지를 위해 수동 동기화 추가
	gridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		local contentHeight = gridLayout.AbsoluteContentSize.Y
		local paddingHeight = 20 -- 하단 여백
		scrollFrame.CanvasSize = UDim2.new(0, 0, 0, contentHeight + paddingHeight)
	end)
	-- 초기 CanvasSize 강제 할당 (안전장치)
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 1000)

	-- [[ 5. 50개 슬롯 생성 ]]
	table.clear(slotFrames)
	for i = 1, 50 do
		-- 클릭 이벤트를 받기 위해 TextButton으로 변경
		local slot = Instance.new("TextButton")
		slot.Name = "Slot_" .. i
		slot.Size = UDim2.new(0, 70, 0, 70)
		slot.Text = "" 
		slot.BackgroundColor3 = THEME.SLOT_BG
		slot.BorderSizePixel = 0
		slot.ZIndex = 3

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 8)
		corner.Parent = slot

		-- 숫자를 띄워서 눈으로 확실히 보이게 함
		local numLabel = Instance.new("TextLabel")
		numLabel.Size = UDim2.new(1, 0, 1, 0)
		numLabel.BackgroundTransparency = 1
		numLabel.Text = tostring(i)
		numLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
		numLabel.Font = Enum.Font.GothamBold
		numLabel.TextSize = 14
		numLabel.ZIndex = 4
		numLabel.Parent = slot
		
		-- 슬롯 클릭 이벤트
		slot.MouseButton1Click:Connect(function()
			infoName.Text = "아이템 " .. i
			infoDesc.Text = "이것은 " .. i .. "번째 슬롯의 아이템입니다."
		end)

		slot.Parent = scrollFrame
		slotFrames[i] = slot
	end

	print("[InventorySystem] 50개 슬롯 생성 및 정보창 적용 완료!")

	-- [[ 6. 드래그 로직 (간단하고 확실한 버전) ]]
	local dragging = false
	local dragStart = Vector3.new()
	local startPos = UDim2.new()

	header.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = mainFrame.Position

			local endConn: RBXScriptConnection
			endConn = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					endConn:Disconnect()
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			mainFrame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
end

-- [[ 토글 로직 ]]
local function ToggleInventory()
	if not screenGui then return end
	screenGui.Enabled = not screenGui.Enabled
	SetGameInput(screenGui.Enabled)
end

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.KeyCode == Enum.KeyCode.L then
		ToggleInventory()
	end
end)

BuildUI()
print("INVENTORY SYSTEM READY - BASELINE WITH INFO PANEL")
