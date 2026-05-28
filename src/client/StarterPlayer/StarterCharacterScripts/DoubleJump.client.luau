--[[ Made by coolcapidog
Channel ->> https://www.youtube.com/c/coolcapidog
Edited by Gemini CLI: Removed sounds, added 1.5x jump height multiplier.
]]
----------------------------------------- Settings
local MaxJumps = 2
local JumpCooldown = 0.2
local JumpMultiplier = 1.5 -- 이단 점프 높이 배율
----------------------------------------- Settings
local UIS = game:GetService("UserInputService")
local Player = game.Players.LocalPlayer
local Char = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Char:WaitForChild("Humanoid")
local NumJumps = 0
local canjump = false

local baseJumpPower = Humanoid.JumpPower -- 기본 점프력 저장

-- Animation setup
local DoubleJumpAnim = Instance.new("Animation")
DoubleJumpAnim.AnimationId = "rbxassetid://70966912277694"
local DoubleJumpTrack = Humanoid:LoadAnimation(DoubleJumpAnim)
DoubleJumpTrack.Priority = Enum.AnimationPriority.Action

-- Particle setup
local function createDoubleJumpParticles()
	local HRP = Char:WaitForChild("HumanoidRootPart")

	local Attachment = Instance.new("Attachment")
	Attachment.Position = Vector3.new(0, -2, 0)
	Attachment.Parent = HRP

	local Particles = Instance.new("ParticleEmitter")
	Particles.Parent = Attachment
	Particles.Texture = "rbxassetid://243160943" -- smoke/cloud texture
	Particles.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 200)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
	})
	Particles.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.8),
		NumberSequenceKeypoint.new(0.5, 1.2),
		NumberSequenceKeypoint.new(1, 0),
	})
	Particles.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.4),
		NumberSequenceKeypoint.new(0.5, 0.7),
		NumberSequenceKeypoint.new(1, 1),
	})
	Particles.LightEmission = 0.1
	Particles.LightInfluence = 0.8
	Particles.Speed = NumberRange.new(5, 10)
	Particles.SpreadAngle = Vector2.new(60, 60)
	Particles.Lifetime = NumberRange.new(0.2, 0.4) -- disappears quickly
	Particles.Rate = 0
	Particles.RotSpeed = NumberRange.new(-45, 45)
	Particles.Rotation = NumberRange.new(0, 360)

	Particles:Emit(8) -- less particles
	game:GetService("Debris"):AddItem(Attachment, 1)
end

Humanoid.StateChanged:Connect(function(oldstate, newstate)
	if Enum.HumanoidStateType.Landed == newstate then
		NumJumps = 0
		canjump = false
		-- 착지 시 점프력 원상복구
		Humanoid.JumpPower = baseJumpPower
	elseif Enum.HumanoidStateType.Freefall == newstate then
		task.wait(JumpCooldown)
		canjump = true
	elseif Enum.HumanoidStateType.Jumping == newstate then
		canjump = false
		NumJumps += 1
		-- Only on double jump
		if NumJumps == 2 then
			-- 이단 점프 시 1.5배 높이 적용
			Humanoid.JumpPower = baseJumpPower * JumpMultiplier
			DoubleJumpTrack:Stop()
			DoubleJumpTrack:Play(0)
			createDoubleJumpParticles()
		end
	end
end)

UIS.JumpRequest:Connect(function()
	if canjump and NumJumps < MaxJumps then
		Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)
