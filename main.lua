local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-------------------------------------------------------
-- Splash Screen
-------------------------------------------------------
local splash = Instance.new("ScreenGui", PlayerGui)
splash.Name = "NeverloseSplash"
splash.ResetOnSpawn = false

local splashText = Instance.new("TextLabel", splash)
splashText.Size = UDim2.new(1,0,1,0)
splashText.BackgroundTransparency = 1
splashText.Text = "N E V E R   L O S E"
splashText.Font = Enum.Font.GothamBold
splashText.TextScaled = true
splashText.TextColor3 = Color3.fromRGB(0, 140, 255)
splashText.TextTransparency = 1

TweenService:Create(splashText, TweenInfo.new(1), {TextTransparency = 0}):Play()
task.wait(1.5)
TweenService:Create(splashText, TweenInfo.new(1.5), {TextTransparency = 1}):Play()
task.wait(1.5)
splash:Destroy()

-------------------------------------------------------
-- Main Neverlose GUI
-------------------------------------------------------
local screen = Instance.new("ScreenGui", PlayerGui)
screen.Name = "Neverlose"
screen.ResetOnSpawn = false
screen.IgnoreGuiInset = true

-- Toggle button (separate)
local toggleBtn = Instance.new("ImageButton", screen)
toggleBtn.Name = "ToggleGUI"
toggleBtn.Size = UDim2.new(0,50,0,50)
toggleBtn.Position = UDim2.new(1,-70,1,-70)
toggleBtn.Image = "rbxassetid://7072719303" -- circle icon
toggleBtn.BackgroundTransparency = 1

local guiVisible = true
toggleBtn.MouseButton1Click:Connect(function()
	guiVisible = not guiVisible
	for _, child in ipairs(screen:GetChildren()) do
		if child:IsA("Frame") or child:IsA("TextButton") or child:IsA("ImageButton") then
			if child ~= toggleBtn then
				child.Visible = guiVisible
			end
		end
	end
end)

-------------------------------------------------------
-- Main circular buttons container
-------------------------------------------------------
local function createCircleButton(name, pos, color, text)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Parent = screen
	btn.Size = UDim2.new(0,55,0,55)
	btn.Position = pos
	btn.BackgroundColor3 = color
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextColor3 = Color3.new(1,1,1)
	btn.TextSize = 10
	btn.AutoButtonColor = false
	btn.BorderSizePixel = 0
	btn.AnchorPoint = Vector2.new(0.5, 0.5)
	btn.BackgroundTransparency = 0
	btn.TextWrapped = true
	btn.ZIndex = 2
	btn.ClipsDescendants = true
	btn.TextScaled = true
	btn.UICorner = Instance.new("UICorner", btn)
	btn.UICorner.CornerRadius = UDim.new(1,0)
	return btn
end

-- Example circle buttons
local enableBtn = createCircleButton("EnableBtn", UDim2.new(0,70,0,120), Color3.fromRGB(0,120,0), "Enable")
local modeBtn = createCircleButton("ModeBtn", UDim2.new(0,140,0,120), Color3.fromRGB(0,100,150), "Mode")
local teamBtn = createCircleButton("TeamBtn", UDim2.new(0,210,0,120), Color3.fromRGB(150,50,50), "Team")
local groundBtn = createCircleButton("GroundBtn", UDim2.new(0,280,0,120), Color3.fromRGB(100,80,0), "Ground")
local mobileBtn = createCircleButton("MobileBtn", UDim2.new(0,350,0,120), Color3.fromRGB(0,100,80), "MobileAim")
local aimAssistBtn = createCircleButton("AimAssistBtn", UDim2.new(0,420,0,120), Color3.fromRGB(120,0,150), "AimAssist")

-------------------------------------------------------
-- Rainbow HUD
-------------------------------------------------------
local hud = Instance.new("TextLabel", screen)
hud.Size = UDim2.new(0, 250, 0, 100)
hud.Position = UDim2.new(0, 10, 0, 10)
hud.BackgroundTransparency = 1
hud.TextColor3 = Color3.new(1,1,1)
hud.Font = Enum.Font.GothamBold
hud.TextSize = 16
hud.TextXAlignment = Enum.TextXAlignment.Left
hud.TextYAlignment = Enum.TextYAlignment.Top
hud.Text = ""

-- Rainbow effect
task.spawn(function()
	while task.wait(0.05) do
		local t = tick() * 2
		hud.TextColor3 = Color3.fromHSV(t % 1, 1, 1)
	end
end)

-------------------------------------------------------
-- Feature Variables
-------------------------------------------------------
local Enabled = false
local Mode = "Orbit"
local TeamCheck = true
local GroundCheck = true
local MobileAim = false
local AimAssist = false

-------------------------------------------------------
-- Update HUD Function
-------------------------------------------------------
local function updateHUD()
	local txt = ""
	if Enabled then
		txt ..= string.format("Teleport (%s)\n", Mode)
		if TeamCheck then txt ..= "Team Check\n" end
		if GroundCheck then txt ..= "Ground Check\n" end
		if MobileAim then txt ..= "Mobile Aim\n" end
		if AimAssist then txt ..= "Aim Assist\n" end
	end
	hud.Text = txt
end

-------------------------------------------------------
-- Button Toggles
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
