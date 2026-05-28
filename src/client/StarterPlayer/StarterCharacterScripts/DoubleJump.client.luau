-- [[
	제작: Jersito4 (기반) / Gemini CLI (기능 수정)
	날짜: 2026년 5월 28일 (Sync Triggered)
--]]

local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- // Jersito4 스타일 설정 섹션 //
local Settings = {
	ExtraJumps = 1,      -- 추가로 점프할 수 있는 횟수 (1이면 이단 점프)
	JumpMultiplier = 1.5, -- 이단 점프 시 높이 배율 (1.5배)
	WhiteList = {},      -- 특정 유저만 허용할 경우 ID 입력
}

-- // 로직 변수 //
local currentJumpCount = 0
local canDoubleJump = false
local baseJumpPower = humanoid.JumpPower

-- 화이트리스트 체크 함수
local function isWhitelisted(userId)
	if #Settings.WhiteList == 0 then return true end
	for _, id in ipairs(Settings.WhiteList) do
		if id == userId then return true end
	end
	return false
end

if not isWhitelisted(player.UserId) then return end

-- 상태 감지 및 리셋
humanoid.StateChanged:Connect(function(oldState, newState)
	if newState == Enum.HumanoidStateType.Landed then
		currentJumpCount = 0
		canDoubleJump = false
		humanoid.JumpPower = baseJumpPower -- 점프력 원상복구
	elseif newState == Enum.HumanoidStateType.Jumping then
		currentJumpCount = 1
		canDoubleJump = true
	elseif newState == Enum.HumanoidStateType.Freefall then
		if currentJumpCount == 0 then
			canDoubleJump = true
		end
	end
end)

-- 점프 요청 처리
UserInputService.JumpRequest:Connect(function()
	if canDoubleJump and currentJumpCount <= Settings.ExtraJumps then
		currentJumpCount = currentJumpCount + 1
		
		if currentJumpCount > 1 then
			-- 이단 점프 시 설정된 배율만큼 높이 증가
			humanoid.JumpPower = baseJumpPower * Settings.JumpMultiplier
			humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)
