--// Neverlose Full Script (with Rainbow HUD + GUI Toggle Button)
-- Functional parts unchanged

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-------------------------------------------------------
-- Splash Screen
-------------------------------------------------------
local splash = Instance.new("ScreenGui")
splash.Name = "NeverloseSplash"
splash.Parent = PlayerGui
splash.ResetOnSpawn = false

local splashText = Instance.new("TextLabel", splash)
splashText.Size = UDim2.new(1,0,1,0)
splashText.BackgroundTransparency = 1
splashText.Text = "N E V E R   L O S E"
splashText.Font = Enum.Font.GothamBold
splashText.TextScaled = true
splashText.TextColor3 = Color3.fromRGB(0,140,255)
splashText.TextTransparency = 1

local tweenIn = TweenService:Create(splashText, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
local tweenOut = TweenService:Create(splashText, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})

tweenIn:Play()
tweenIn.Completed:Wait()
task.wait(1)
tweenOut:Play()
tweenOut.Completed:Wait()
splash:Destroy()

-------------------------------------------------------
-- Variables
-------------------------------------------------------
local OrbitEnabled = false
local OrbitRadius = 15
local OrbitSpeed = 0.25
local VerticalOffset = 5
local Mode = "Orbit"
local TeammateCheck = true
local GroundCheck = true
local MobileAim = false
local CurrentTarget = nil
local GUIVisible = true

-------------------------------------------------------
-- Main Screen
-------------------------------------------------------
local screen = Instance.new("ScreenGui", PlayerGui)
screen.Name = "Neverlose"
screen.ResetOnSpawn = false

local frame = Instance.new("Frame", screen)
frame.Size = UDim2.new(0, 230, 0, 180)
frame.Position = UDim2.new(0, 30, 0, 120)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.Active = true
frame.Draggable = true
frame.BackgroundTransparency = 0.25
frame.BorderSizePixel = 0
frame.ClipsDescendants = true
frame.Name = "MainFrame"

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 25)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "NEVERLOSE"
title.TextColor3 = Color3.fromRGB(0, 140, 255)
title.TextSize = 18

-------------------------------------------------------
-- Circular Button Maker
-------------------------------------------------------
local function makeCircle(text, pos)
	local circle = Instance.new("TextButton", frame)
	circle.Size = UDim2.new(0, 45, 0, 45)
	circle.Position = pos
	circle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	circle.TextColor3 = Color3.fromRGB(255,255,255)
	circle.Font = Enum.Font.GothamBold
	circle.TextSize = 12
	circle.Text = text
	circle.AutoButtonColor = true
	circle.BorderSizePixel = 0
	local corner = Instance.new("UICorner", circle)
	corner.CornerRadius = UDim.new(1, 0)
	return circle
end

-------------------------------------------------------
-- Buttons (Circular)
-------------------------------------------------------
local enableBtn = makeCircle("EN", UDim2.new(0, 15, 0, 35))
local modeBtn = makeCircle("MD", UDim2.new(0, 70, 0, 35))
local teamBtn = makeCircle("TM", UDim2.new(0, 125, 0, 35))
local groundBtn = makeCircle("GR", UDim2.new(0, 180, 0, 35))
local mobileBtn = makeCircle("MB", UDim2.new(0, 15, 0, 90))
local swapBtn = makeCircle("SW", UDim2.new(0, 70, 0, 90))

local targetLabel = Instance.new("TextLabel", frame)
targetLabel.Size = UDim2.new(1, -20, 0, 30)
targetLabel.Position = UDim2.new(0, 10, 0, 140)
targetLabel.BackgroundTransparency = 1
targetLabel.Font = Enum.Font.GothamBold
targetLabel.TextSize = 14
targetLabel.TextColor3 = Color3.new(1,1,1)
targetLabel.Text = "Target: None"

-------------------------------------------------------
-- HUD (Top-Left Indicator)
-------------------------------------------------------
local hud = Instance.new("TextLabel", screen)
hud.Size = UDim2.new(0, 300, 0, 100)
hud.Position = UDim2.new(0, 10, 0, 10)
hud.BackgroundTransparency = 1
hud.TextColor3 = Color3.new(1,1,1)
hud.Font = Enum.Font.GothamBold
hud.TextSize = 16
hud.TextXAlignment = Enum.TextXAlignment.Left
hud.TextYAlignment = Enum.TextYAlignment.Top

-- 🌈 Rainbow effect (smoothly cycles through colors)
RunService.RenderStepped:Connect(function()
	local t = tick() * 0.5
	hud.TextColor3 = Color3.fromHSV((t % 1), 1, 1)
end)

-------------------------------------------------------
-- GUI Toggle Button (Separate)
-------------------------------------------------------
local toggleBtn = Instance.new("TextButton", screen)
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 25, 1, -75)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
toggleBtn.Text = "NL"
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 16
toggleBtn.Active = true
toggleBtn.Draggable = true
toggleBtn.BorderSizePixel = 0
local corner = Instance.new("UICorner", toggleBtn)
corner.CornerRadius = UDim.new(1,0)

-- Fade toggle
local function fadeGUI(show)
	local goal = show and 1 or 0
	local tween = TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.25 + (1 - goal)})
	for _, obj in ipairs(frame:GetDescendants()) do
		if obj:IsA("TextLabel") or obj:IsA("TextButton") then
			TweenService:Create(obj, TweenInfo.new(0.4), {TextTransparency = 1 - goal, BackgroundTransparency = 1 - goal}):Play()
		end
	end
	tween:Play()
end

toggleBtn.MouseButton1Click:Connect(function()
	GUIVisible = not GUIVisible
	frame.Visible = GUIVisible
	fadeGUI(GUIVisible)
	-- indicator color for visibility
	toggleBtn.BackgroundColor3 = GUIVisible and Color3.fromRGB(0,140,255) or Color3.fromRGB(50,50,50)
end)

-------------------------------------------------------
-- Functions (unchanged)
-------------------------------------------------------
local function updateHUD()
	if not OrbitEnabled then hud.Text = "" return end
	local text = string.format("Teleport (%s)\n", Mode)
	if TeammateCheck then text ..= "Team Check\n" end
	if GroundCheck then text ..= "Ground Check\n" end
	if MobileAim then text ..= "Mobile Aim\n" end
	hud.Text = text
end

local function isOnGround(root)
	if not root then return false end
	if root.Position.Y < -300 then return false end
	local params = RaycastParams.new()
	params.FilterDescendantsInstances = {root.Parent}
	params.FilterType = Enum.RaycastFilterType.Exclude
	local result = workspace:Raycast(root.Position, Vector3.new(0, -10, 0), params)
	return result ~= nil
end

local function findTarget()
	local best, closest = nil, math.huge
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") then
			if (not TeammateCheck or plr.Team ~= LocalPlayer.Team) then
				local root = plr.Character.HumanoidRootPart
				local dist = (root.Position - Character.HumanoidRootPart.Position).Magnitude
				if dist < closest then
					best = plr
					closest = dist
				end
			end
		end
	end
	return best
end

local function swapTarget()
	CurrentTarget = findTarget()
	targetLabel.Text = CurrentTarget and ("Target: " .. CurrentTarget.Name) or "Target: None"
end

local function resetSystem()
	CurrentTarget = nil
	targetLabel.Text = "Target: None"
	updateHUD()
end

-------------------------------------------------------
-- Button Events (unchanged)
-------------------------------------------------------
enableBtn.MouseButton1Click:Connect(function()
	OrbitEnabled = not OrbitEnabled
	enableBtn.BackgroundColor3 = OrbitEnabled and Color3.fromRGB(0,120,0) or Color3.fromRGB(40,40,40)
	updateHUD()
	if not OrbitEnabled then resetSystem() end
end)

modeBtn.MouseButton1Click:Connect(function()
	if Mode == "Orbit" then Mode = "Under"
	elseif Mode == "Under" then Mode = "Back"
	else Mode = "Orbit" end
	modeBtn.BackgroundColor3 = Color3.fromRGB(0,120,255)
	updateHUD()
end)

teamBtn.MouseButton1Click:Connect(function()
	TeammateCheck = not TeammateCheck
	teamBtn.BackgroundColor3 = TeammateCheck and Color3.fromRGB(0,120,0) or Color3.fromRGB(120,0,0)
	updateHUD()
end)

groundBtn.MouseButton1Click:Connect(function()
	GroundCheck = not GroundCheck
	groundBtn.BackgroundColor3 = GroundCheck and Color3.fromRGB(0,120,0) or Color3.fromRGB(120,0,0)
	updateHUD()
end)

mobileBtn.MouseButton1Click:Connect(function()
	MobileAim = not MobileAim
	mobileBtn.BackgroundColor3 = MobileAim and Color3.fromRGB(0,120,255) or Color3.fromRGB(40,40,40)
	updateHUD()
end)

swapBtn.MouseButton1Click:Connect(swapTarget)

UserInputService.InputBegan:Connect(function(input, gpe)
	if not gpe and input.KeyCode == Enum.KeyCode.T then
		swapTarget()
	end
end)

-------------------------------------------------------
-- Core Behavior (unchanged)
-------------------------------------------------------
RunService.Heartbeat:Connect(function()
	if not OrbitEnabled then return end
	Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	if not Character:FindFirstChild("HumanoidRootPart") then return end
	if not CurrentTarget or not CurrentTarget.Character or not CurrentTarget.Character:FindFirstChild("HumanoidRootPart") then
		swapTarget()
		return
	end

	local targetRoot = CurrentTarget.Character.HumanoidRootPart
	local humanoid = CurrentTarget.Character:FindFirstChild("Humanoid")

	if not humanoid or humanoid.Health <= 0 then
		swapTarget()
		return
	end
	if GroundCheck and not isOnGround(targetRoot) then
		swapTarget()
		return
	end

	local hrp = Character.HumanoidRootPart
	local lookAt = targetRoot.Position

	if Mode == "Orbit" then
		local time = tick() * OrbitSpeed
		local pos = targetRoot.Position + Vector3.new(math.cos(time)*OrbitRadius, VerticalOffset, math.sin(time)*OrbitRadius)
		hrp.CFrame = CFrame.new(pos, lookAt)

	elseif Mode == "Under" then
		local pos = targetRoot.Position - Vector3.new(0, 5, 0)
		hrp.CFrame = CFrame.new(pos, lookAt)

	elseif Mode == "Back" then
		local cf = targetRoot.CFrame
		local pos = (cf.Position - cf.LookVector * 5)
		hrp.CFrame = CFrame.new(pos, cf.Position)
	end

	if MobileAim then
		local cam = workspace.CurrentCamera
		cam.CFrame = CFrame.new(cam.CFrame.Position, lookAt)
	end
end)
