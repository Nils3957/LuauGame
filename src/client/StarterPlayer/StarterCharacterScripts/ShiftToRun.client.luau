-- || Made by @a2x4440 || --
-- Edited by Gemini CLI --

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local animator = humanoid:WaitForChild("Animator")

local camera = workspace.CurrentCamera

local RunConfig = require(game.ReplicatedStorage:WaitForChild("RunConfig"))

local UIS = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")

local runAnimation = Instance.new("Animation")
runAnimation.Name = "RunAnimation"
runAnimation.AnimationId = RunConfig.RunAnimationId

local sprintAnimation = Instance.new("Animation")
sprintAnimation.Name = "SprintAnimation"
sprintAnimation.AnimationId = RunConfig.SprintAnimationId
local runTrack = animator:LoadAnimation(runAnimation)
local sprintTrack = animator:LoadAnimation(sprintAnimation)

runTrack.Priority = Enum.AnimationPriority.Action
sprintTrack.Priority = Enum.AnimationPriority.Action

-- 모바일 GUI가 없어도 진행되도록 수정
local mobileGui = player:WaitForChild("PlayerGui"):FindFirstChild("MobileGui")

local sprintTask = nil -- Sprint 전환을 위한 변수 추가

local function Sprint()
	if RunConfig.Walking and RunConfig.Running and RunConfig.CanSprint then
		RunConfig.Sprinting = true

		local sprintTween = tweenService:Create(humanoid, TweenInfo.new(RunConfig.TransitionSpeed, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {WalkSpeed = RunConfig.SprintSpeed})
		local fovTween = tweenService:Create(camera, TweenInfo.new(RunConfig.TransitionSpeed, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {FieldOfView = RunConfig.SprintFov})
		sprintTween:Play()
		fovTween:Play()
		sprintTrack:Play()
	end
end

local function Walk()
	RunConfig.Running = false
	RunConfig.Sprinting = false

	local walkTween = tweenService:Create(humanoid, TweenInfo.new(RunConfig.TransitionSpeed, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {WalkSpeed = RunConfig.WalkSpeed})
	local fovTween = tweenService:Create(camera, TweenInfo.new(RunConfig.TransitionSpeed, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {FieldOfView = RunConfig.WalkFov})
	walkTween:Play()
	fovTween:Play()
	runTrack:Stop()
	sprintTrack:Stop()
	
	if sprintTask then
		task.cancel(sprintTask)
		sprintTask = nil
	end
end

local function Run()
	if RunConfig.Walking and RunConfig.CanRun then
		RunConfig.Running = true
		
		local runTween = tweenService:Create(humanoid, TweenInfo.new(RunConfig.TransitionSpeed, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {WalkSpeed = RunConfig.RunSpeed})
		local FovTween = tweenService:Create(camera, TweenInfo.new(RunConfig.TransitionSpeed, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {FieldOfView = RunConfig.RunFov})
		runTween:Play()
		FovTween:Play()
		runTrack:Play()
	end
end


UIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if input.KeyCode == RunConfig.RunKey then
		Run()
		
		-- 기존 코드를 수정하여 task를 변수에 저장
		sprintTask = task.spawn(function()
			task.wait(RunConfig.SprintTransitionSpeed)
			if RunConfig.Running then
				Sprint()
			end
		end)
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.KeyCode == RunConfig.RunKey then
		Walk()
	end
end)

-- 모바일 GUI가 있을 때만 이벤트 연결
if mobileGui then
	mobileGui.RunButton.MouseButton1Down:Connect(function()
		Run()
	end)

	mobileGui.RunButton.MouseButton1Up:Connect(function()
		Walk()
	end)
end

runService.RenderStepped:Connect(function()
	if humanoid.MoveDirection.Magnitude > 0 then
		RunConfig.Walking = true
	else
		RunConfig.Walking = false
		
		if RunConfig.Running then
			Walk()
		end
	end
end)

if mobileGui and UIS.TouchEnabled and not UIS.KeyboardEnabled and not UIS.MouseEnabled then
	mobileGui.Enabled = true
end