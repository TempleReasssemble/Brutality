local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Enabled = false
local TeamCheck = true
local GroundCheck = true
local MobileAim = false
local Mode = "Orbit"
local AimAssistEnabled = false
local FOV_RADIUS = 250
local Smoothness = 0.15

local splash = Instance.new("ScreenGui")
splash.Name = "NeverloseSplash"
splash.ResetOnSpawn = false
splash.Parent = PlayerGui

local splashText = Instance.new("TextLabel", splash)
splashText.Size = UDim2.new(1, 0, 1, 0)
splashText.BackgroundTransparency = 1
splashText.Text = "N E V E R   L O S E"
splashText.Font = Enum.Font.GothamBold
splashText.TextScaled = true
splashText.TextColor3 = Color3.fromRGB(0, 140, 255)
splashText.TextTransparency = 1

local tweenIn = TweenService:Create(splashText, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
local tweenOut = TweenService:Create(splashText, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
tweenIn:Play()
tweenIn.Completed:Wait()
task.wait(1)
tweenOut:Play()
tweenOut.Completed:Wait()
splash:Destroy()

local screen = Instance.new("ScreenGui")
screen.Name = "Neverlose"
screen.ResetOnSpawn = false
screen.IgnoreGuiInset = true
screen.Parent = PlayerGui

local function makeButton(text, pos)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 60, 0, 60)
	b.Position = pos
	b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	b.TextColor3 = Color3.new(1, 1, 1)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	b.AutoButtonColor = true
	b.Parent = screen
	b.ClipsDescendants = true
	b.BorderSizePixel = 0
	local uic = Instance.new("UICorner", b)
	uic.CornerRadius = UDim.new(1, 0)
	return b
end

local enableBtn = makeButton("ON", UDim2.new(0, 20, 0, 100))
local modeBtn = makeButton("MODE", UDim2.new(0, 100, 0, 100))
local teamBtn = makeButton("TEAM", UDim2.new(0, 180, 0, 100))
local groundBtn = makeButton("GRND", UDim2.new(0, 260, 0, 100))
local mobileBtn = makeButton("MOB", UDim2.new(0, 340, 0, 100))
local aimAssistBtn = makeButton("AIM", UDim2.new(0, 420, 0, 100))

local hud = Instance.new("TextLabel")
hud.Name = "FeatureHUD"
hud.Size = UDim2.new(0, 300, 0, 100)
hud.Position = UDim2.new(0, 10, 0, 10)
hud.BackgroundTransparency = 1
hud.TextColor3 = Color3.new(1, 1, 1)
hud.Font = Enum.Font.GothamBold
hud.TextSize = 16
hud.TextXAlignment = Enum.TextXAlignment.Left
hud.TextYAlignment = Enum.TextYAlignment.Top
hud.Parent = screen
hud.Text = ""

local hue = 0
RunService.RenderStepped:Connect(function(dt)
	hue = hue + dt * 0.3
	if hue > 1 then hue = 0 end
	hud.TextColor3 = Color3.fromHSV(hue, 1, 1)
end)

local function updateHUD()
	if not Enabled then hud.Text = "" return end
	local t = string.format("Teleport (%s)\n", Mode)
	if TeamCheck then t ..= "Team Check\n" end
	if GroundCheck then t ..= "Ground Check\n" end
	if MobileAim then t ..= "Mobile Aim\n" end
	if AimAssistEnabled then t ..= "Aim Assist\n" end
	hud.Text = t
end

local fovCircle = Instance.new("Frame")
fovCircle.Size = UDim2.new(0, FOV_RADIUS * 2, 0, FOV_RADIUS * 2)
fovCircle.Position = UDim2.new(0.5, -FOV_RADIUS, 0.5, -FOV_RADIUS)
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.BackgroundTransparency = 1
fovCircle.BorderSizePixel = 2
fovCircle.BorderColor3 = Color3.fromRGB(0, 255, 255)
fovCircle.Visible = false
fovCircle.Parent = screen
local uicorner = Instance.new("UICorner", fovCircle)
uicorner.CornerRadius = UDim.new(1, 0)

local guiToggle = makeButton("☰", UDim2.new(0, 20, 0, 20))
guiToggle.Size = UDim2.new(0, 50, 0, 50)
guiToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local guiVisible = true
guiToggle.MouseButton1Click:Connect(function()
	guiVisible = not guiVisible
	for _, v in ipairs(screen:GetChildren()) do
		if v:IsA("TextButton") and v ~= guiToggle then
			v.Visible = guiVisible
		end
	end
end)

enableBtn.MouseButton1Click:Connect(function()
	Enabled = not Enabled
	enableBtn.BackgroundColor3 = Enabled and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(25, 25, 25)
	updateHUD()
end)

modeBtn.MouseButton1Click:Connect(function()
	if Mode == "Orbit" then Mode = "Under"
	elseif Mode == "Under" then Mode = "Back"
	else Mode = "Orbit" end
	modeBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
	updateHUD()
end)

teamBtn.MouseButton1Click:Connect(function()
	TeamCheck = not TeamCheck
	teamBtn.BackgroundColor3 = TeamCheck and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(25, 25, 25)
	updateHUD()
end)

groundBtn.MouseButton1Click:Connect(function()
	GroundCheck = not GroundCheck
	groundBtn.BackgroundColor3 = GroundCheck and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(25, 25, 25)
	updateHUD()
end)

mobileBtn.MouseButton1Click:Connect(function()
	MobileAim = not MobileAim
	mobileBtn.BackgroundColor3 = MobileAim and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(25, 25, 25)
	updateHUD()
end)

aimAssistBtn.MouseButton1Click:Connect(function()
	AimAssistEnabled = not AimAssistEnabled
	fovCircle.Visible = AimAssistEnabled
	aimAssistBtn.BackgroundColor3 = AimAssistEnabled and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(25, 25, 25)
	updateHUD()
end)

RunService.RenderStepped:Connect(function(dt)
	if not AimAssistEnabled then return end
	local nearest, nearestDist = nil, FOV_RADIUS
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			if TeamCheck and plr.Team == LocalPlayer.Team then
				continue
			end
			local pos, onScreen = Camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
			if onScreen then
				local mousePos = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
				local targetPos = Vector2.new(pos.X, pos.Y)
				local dist = (mousePos - targetPos).Magnitude
				if dist < nearestDist then
					nearestDist = dist
					nearest = plr
				end
			end
		end
	end
	if nearest and nearest.Character and nearest.Character:FindFirstChild("HumanoidRootPart") then
		local root = nearest.Character.HumanoidRootPart
		local camCF = Camera.CFrame
		local targetCF = CFrame.new(camCF.Position, root.Position)
		Camera.CFrame = camCF:Lerp(targetCF, Smoothness)
	end
end)-- Button Toggles
-------------------------------------------------------
enableBtn.MouseButton1Click:Connect(function()
	Enabled = not Enabled
	enableBtn.BackgroundColor3 = Enabled and Color3.fromRGB(0,200,0) or Color3.fromRGB(0,120,0)
	updateHUD()
end)

modeBtn.MouseButton1Click:Connect(function()
	if Mode == "Orbit" then Mode = "Under"
	elseif Mode == "Under" then Mode = "Back"
	else Mode = "Orbit" end
	modeBtn.BackgroundColor3 = Color3.fromRGB(0,100,150)
	updateHUD()
end)

teamBtn.MouseButton1Click:Connect(function()
	TeamCheck = not TeamCheck
	teamBtn.BackgroundColor3 = TeamCheck and Color3.fromRGB(150,50,50) or Color3.fromRGB(80,30,30)
	updateHUD()
end)

groundBtn.MouseButton1Click:Connect(function()
	GroundCheck = not GroundCheck
	groundBtn.BackgroundColor3 = GroundCheck and Color3.fromRGB(100,80,0) or Color3.fromRGB(50,40,0)
	updateHUD()
end)

mobileBtn.MouseButton1Click:Connect(function()
	MobileAim = not MobileAim
	mobileBtn.BackgroundColor3 = MobileAim and Color3.fromRGB(0,200,120) or Color3.fromRGB(0,100,80)
	updateHUD()
end)

aimAssistBtn.MouseButton1Click:Connect(function()
	AimAssist = not AimAssist
	aimAssistBtn.BackgroundColor3 = AimAssist and Color3.fromRGB(180,0,220) or Color3.fromRGB(120,0,150)
	updateHUD()
	fovCircle.Visible = AimAssist
end)

-------------------------------------------------------
-- FOV Circle for Aim Assist
-------------------------------------------------------
local fovCircle = Drawing.new("Circle")
fovCircle.Radius = 150
fovCircle.Thickness = 1.5
fovCircle.Transparency = 0.8
fovCircle.Color = Color3.fromRGB(0, 200, 255)
fovCircle.Filled = false
fovCircle.Visible = false

RunService.RenderStepped:Connect(function()
	local mousePos = UserInputService:GetMouseLocation()
	fovCircle.Position = mousePos
end)

-------------------------------------------------------
-- Aim Assist Logic (Camera smooth aim)
-------------------------------------------------------
local AIM_SPEED = 8  -- smoothing factor

RunService.RenderStepped:Connect(function(dt)
	if not AimAssist then return end

	local closest = nil
	local shortest = math.huge
	local mousePos = UserInputService:GetMouseLocation()

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = plr.Character.HumanoidRootPart
			local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
			if onScreen then
				local dist = (Vector2.new(pos.X,pos.Y) - mousePos).Magnitude
				if dist < fovCircle.Radius and dist < shortest then
					shortest = dist
					closest = plr
				end
			end
		end
	end

	if closest and closest.Character and closest.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = closest.Character.HumanoidRootPart
		local camCF = Camera.CFrame
		local targetCF = CFrame.new(camCF.Position, hrp.Position)
		Camera.CFrame = camCF:Lerp(targetCF, dt * AIM_SPEED)
	end
end)

-------------------------------------------------------
-- Initial HUD
-------------------------------------------------------
updateHUD()
