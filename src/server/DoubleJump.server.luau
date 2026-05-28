-- [[
	제작: Jersito4 (기반) / Gemini CLI (서버 주입형 수정)
	날짜: 2026년 5월 28일
	
	설명:
		이 스크립트는 ServerScriptService에서 실행되며, 
		모든 플레이어에게 이단 점프(1.5배 높이) 기능을 부여합니다.
]]

local Players = game:GetService("Players")

-- // 설정 섹션 //
local Settings = {
	ExtraJumps = 1,
	FirstJumpMultiplier = 3.0,
	SecondJumpMultiplier = 5.5,
	WhiteList = {},
}

-- 화이트리스트 체크 함수
local function isWhitelisted(userId)
	if #Settings.WhiteList == 0 then return true end
	for _, id in ipairs(Settings.WhiteList) do
		if id == userId then return true end
	end
	return false
end

-- 캐릭터에 이단 점프 로직 주입 함수
local function injectDoubleJump(character)
	local player = Players:GetPlayerFromCharacter(character)
	if not player or not isWhitelisted(player.UserId) then return end
	
	-- 기존에 이미 주입되었는지 확인
	if character:FindFirstChild("DoubleJumpLogic") then return end
	
	-- 클라이언트 측에서 실행될 로직을 LocalScript로 생성하여 주입
	local script = Instance.new("LocalScript")
	script.Name = "DoubleJumpLogic"
	script.Source = [[
		local UserInputService = game:GetService("UserInputService")
		local player = game.Players.LocalPlayer
		local character = script.Parent
		local humanoid = character:WaitForChild("Humanoid")

		local Settings = {
			ExtraJumps = ]] .. Settings.ExtraJumps .. [[,
			FirstJumpMultiplier = ]] .. Settings.FirstJumpMultiplier .. [[,
			SecondJumpMultiplier = ]] .. Settings.SecondJumpMultiplier .. [[,
		}

		local currentJumpCount = 0
		local canDoubleJump = false
		local baseJumpPower = humanoid.JumpPower
		local baseJumpHeight = humanoid.JumpHeight

		local function applyJumpMultiplier(multiplier)
			if humanoid.UseJumpPower then
				humanoid.JumpPower = baseJumpPower * multiplier
			else
				humanoid.JumpHeight = baseJumpHeight * multiplier
			end
		end

		humanoid.StateChanged:Connect(function(oldState, newState)
			if newState == Enum.HumanoidStateType.Landed then
				currentJumpCount = 0
				canDoubleJump = false
				applyJumpMultiplier(Settings.FirstJumpMultiplier)
			elseif newState == Enum.HumanoidStateType.Jumping then
				currentJumpCount = 1
				canDoubleJump = true
			elseif newState == Enum.HumanoidStateType.Freefall then
				if currentJumpCount == 0 then
					canDoubleJump = true
				end
			end
		end)

		UserInputService.JumpRequest:Connect(function()
			if canDoubleJump and currentJumpCount <= Settings.ExtraJumps then
				currentJumpCount = currentJumpCount + 1
				if currentJumpCount == 2 then
					applyJumpMultiplier(Settings.SecondJumpMultiplier)
					humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
				end
			end
		end)
	]]
	script.Parent = character
end

-- 플레이어 접속 이벤트 연결
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(injectDoubleJump)
end)

-- 이미 접속해 있는 플레이어 처리
for _, player in ipairs(Players:GetPlayers()) do
	if player.Character then
		injectDoubleJump(player.Character)
	end
	player.CharacterAdded:Connect(injectDoubleJump)
end