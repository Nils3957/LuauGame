-[[ Made by coolcapidog
Channel ->> https://www.youtube.com/c/coolcapidog
You can change the settings but you shouldn't change anything except settings.
]]
----------------------------------------- Settings
local MaxJumps = 2
local JumpCooldown = 0.2
----------------------------------------- Settings
local UIS = game:GetService("UserInputService")
local Player = game.Players.LocalPlayer
local Char = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Char:WaitForChild("Humanoid")
local NumJumps = 0
local canjump = false
-- Animation setup
local DoubleJumpAnim = Instance.new("Animation")
DoubleJumpAnim.AnimationId = "rbxassetid://70966912277694"
local DoubleJumpTrack = Humanoid:LoadAnimation(DoubleJumpAnim)
DoubleJumpTrack.Priority = Enum.AnimationPriority.Action
-- Sound setup
local JumpSound = Instance.new("Sound")
JumpSound.SoundId = "rbxassetid://95557305310775"
JumpSound.Volume = 0.2
JumpSound.Parent = Char:WaitForChild("HumanoidRootPart")

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
	elseif Enum.HumanoidStateType.Freefall == newstate then
		wait(JumpCooldown)
		canjump = true
	elseif Enum.HumanoidStateType.Jumping == newstate then
		canjump = false
		NumJumps += 1
		-- Only on double jump
		if NumJumps == 2 then
			JumpSound:Play()
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