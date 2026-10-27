-- Behaviour trace of a Unknown obfuscator script
-- NOTE: reconstructed from observed behaviour; branches that were not taken
--       during the trace are missing and conditions are only noted in comments.
-- run status: finished
-- 860 statements recorded in 0.24s
-- URLs requested:
--   https://raw.githubusercontent.com/kezodxyz/KezodX/refs/heads/main/Library.lua
--   https://raw.githubusercontent.com/kezodxyz/KezodX/refs/heads/main/addons/ThemeManager.lua
--   https://raw.githubusercontent.com/kezodxyz/KezodX/refs/heads/main/addons/SaveManager.lua
-- remotes fired/invoked:
--   Activatepower
--   Deactivatepower

-- [deobf] folded 0 repeated calls into 0 helper functions and 9 unrolled runs into loops
local response = game:HttpGet("https://raw.githubusercontent.com/kezodxyz/KezodX/refs/heads/main/Library.lua")
local KezodX = loadstring(response)()
local response2 = game:HttpGet("https://raw.githubusercontent.com/kezodxyz/KezodX/refs/heads/main/addons/ThemeManager.lua")
local KezodX2 = loadstring(response2)()
local response3 = game:HttpGet("https://raw.githubusercontent.com/kezodxyz/KezodX/refs/heads/main/addons/SaveManager.lua")
local KezodX3 = loadstring(response3)()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
Players.LocalPlayer:WaitForChild("PlayerGui")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Attacks = Remotes:WaitForChild("Attacks")
Attacks:WaitForChild("BasicAttack")
local Generator = Remotes:WaitForChild("Generator")
Generator:WaitForChild("SkillCheckResultEvent")
local Items = Remotes:FindFirstChild("Items")
local TwistofFate = Items:FindFirstChild("Twist of Fate")
TwistofFate:FindFirstChild("Fire")
local Flashlight = Items:FindFirstChild("Flashlight")
Flashlight:FindFirstChild("GotBlinded")
RaycastParams.new().FilterType = Enum.RaycastFilterType.Blacklist
Remotes:WaitForChild("EmoteHandler")
local Circle = Drawing.new("Circle")
local VD_VeilTarget = Instance.new("Highlight")
local Circle2 = Drawing.new("Circle")
Circle.Color = Color3.fromRGB(255, 0, 255)
Circle.Thickness = 1.5
Circle.Filled = false
Circle.Visible = false
VD_VeilTarget.Name = "VD_VeilTarget"
VD_VeilTarget.FillColor = Color3.fromRGB(255, 0, 0)
VD_VeilTarget.OutlineColor = Color3.fromRGB(255, 255, 255)
VD_VeilTarget.FillTransparency = 0.5
VD_VeilTarget.OutlineTransparency = 0
Circle2.Thickness = 2
Circle2.Radius = 5
Circle2.Color = Color3.fromRGB(255, 0, 255)
Circle2.Filled = true
Circle2.Visible = false
local KYS_ParryRange = Instance.new("CylinderHandleAdornment")
KYS_ParryRange.Name = "KYS_ParryRange"
KYS_ParryRange.Radius = 8
KYS_ParryRange.InnerRadius = 7.85
KYS_ParryRange.Height = 0.01
KYS_ParryRange.Color3 = Color3.fromRGB(255, 80, 80)
KYS_ParryRange.AlwaysOnTop = false
local Terrain = workspace:FindFirstChildOfClass("Terrain")
KYS_ParryRange.Adornee = Terrain
KYS_ParryRange.Transparency = 1
local CoreGui = game:GetService("CoreGui")
KYS_ParryRange.Parent = CoreGui

task.spawn(function(...)
	local Remotes2 = ReplicatedStorage:WaitForChild("Remotes", 5)
	local Items2 = Remotes2:WaitForChild("Items", 5)
	local ParryingDagger = Items2:WaitForChild("Parrying Dagger", 5)
	local lastRemotes = ParryingDagger:WaitForChild("lastRemotes", 5)

	lastRemotes.OnClientEvent:Connect(function()
		task.delay(60, function()
		end)
	end)
end)

local players = Players:GetPlayers()

for k, v in pairs(players) do
	v.CharacterAdded:Connect(function(character)
	end)

	local changedSignal = v:GetPropertyChangedSignal("Team")

	changedSignal:Connect(function()
	end)
end

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character9)
	end)

	local changedSignal2 = player:GetPropertyChangedSignal("Team")

	changedSignal2:Connect(function()
	end)
end)

task.spawn(function()
	task.wait(5)
	local players2 = Players:GetPlayers()

	for k2, v2 in pairs(players2) do
	end

	task.wait(5)
	-- [envlog] the statements above repeat forever (loop)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
end)

UserInputService.InputEnded:Connect(function(input2, gameProcessed2)
end)

getgenv().KYS_SetToFSilentAim = function()
	local hui = gethui()
	local ToFTargetSelector = hui:FindFirstChild("ToFTargetSelector")
	ToFTargetSelector:Destroy()
	local ToFTargetSelector2 = Instance.new("ScreenGui")
	ToFTargetSelector2.Name = "ToFTargetSelector"
	ToFTargetSelector2.ResetOnSpawn = false
	ToFTargetSelector2.IgnoreGuiInset = true
	ToFTargetSelector2.Parent = hui
	local Main = Instance.new("Frame")
	Main.Name = "Main"
	Main.Size = UDim2.new(0, 180, 0, 126)
	Main.Position = UDim2.new(0.5, -120, 0, 110)
	Main.BackgroundColor3 = Color3.fromRGB(16, 18, 24)
	Main.BorderSizePixel = 0
	Main.Active = true
	Main.Parent = ToFTargetSelector2
	local UICorner = Instance.new("UICorner", Main)
	UICorner.CornerRadius = UDim.new(0, 8)
	local UIStroke = Instance.new("UIStroke", Main)
	UIStroke.Color = Color3.fromRGB(96, 72, 160)
	UIStroke.Thickness = 1
	local Frame2 = Instance.new("Frame")
	Frame2.Size = UDim2.new(1, 0, 0, 28)
	Frame2.BackgroundColor3 = Color3.fromRGB(24, 26, 34)
	Frame2.BorderSizePixel = 0
	Frame2.Parent = Main
	local UICorner2 = Instance.new("UICorner", Frame2)
	UICorner2.CornerRadius = UDim.new(0, 8)
	local Frame3 = Instance.new("Frame")
	Frame3.Size = UDim2.new(1, 0, 0, 10)
	Frame3.Position = UDim2.new(0, 0, 1, -10)
	Frame3.BackgroundColor3 = Color3.fromRGB(24, 26, 34)
	Frame3.BorderSizePixel = 0
	Frame3.Parent = Frame2
	local Frame4 = Instance.new("Frame")
	Frame4.Size = UDim2.new(1, -34, 1, 0)
	Frame4.BackgroundTransparency = 1
	Frame4.Parent = Frame2
	local TextButton = Instance.new("TextButton")
	TextButton.Size = UDim2.new(0, 28, 1, 0)
	TextButton.Position = UDim2.new(1, -30, 0, 0)
	TextButton.BackgroundTransparency = 1
	TextButton.Text = "-"
	TextButton.TextColor3 = Color3.fromRGB(185, 190, 205)
	TextButton.Font = Enum.Font.GothamBold
	TextButton.TextSize = 14
	TextButton.Parent = Frame2
	local TextLabel = Instance.new("TextLabel")
	TextLabel.Size = UDim2.new(1, -44, 1, 0)
	TextLabel.Position = UDim2.new(0, 10, 0, 0)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = "TOF TARGET MODE"
	TextLabel.TextColor3 = Color3.fromRGB(210, 215, 230)
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.TextSize = 10
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.Parent = Frame2
	local Frame5 = Instance.new("Frame")
	Frame5.Size = UDim2.new(1, -16, 0, 86)
	Frame5.Position = UDim2.new(0, 8, 0, 34)
	Frame5.BackgroundTransparency = 1
	Frame5.Parent = Main
	local UIListLayout = Instance.new("UIListLayout", Frame5)
	UIListLayout.FillDirection = Enum.FillDirection.Vertical
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 5)

	TextButton.MouseButton1Click:Connect(function()
		TextButton.Text = "+"
		Frame5.Visible = false
		Main.Size = UDim2.new(0, 180, 0, 28)
	end)

	local TextButton2 = Instance.new("TextButton")
	TextButton2.Size = UDim2.new(1, 0, 0, 25)
	TextButton2.BorderSizePixel = 0
	TextButton2.Font = Enum.Font.GothamBold
	TextButton2.TextSize = 11
	TextButton2.Text = "KILLER        K"
	TextButton2.TextXAlignment = Enum.TextXAlignment.Center
	TextButton2.LayoutOrder = 1
	TextButton2.Parent = Frame5
	local UICorner3 = Instance.new("UICorner", TextButton2)
	UICorner3.CornerRadius = UDim.new(0, 6)
	local UIStroke2 = Instance.new("UIStroke", TextButton2)
	UIStroke2.Color = Color3.fromRGB(58, 62, 78)
	UIStroke2.Thickness = 1

	TextButton2.MouseButton1Click:Connect(function()
		KezodX:Notify({ Title = "ToF Target", Description = "Killer", Time = 2 })
	end)

	TextButton2.InputEnded:Connect(function(input3, gameProcessed3)
	end)

	local TextButton3 = Instance.new("TextButton")
	TextButton3.Size = UDim2.new(1, 0, 0, 25)
	TextButton3.BorderSizePixel = 0
	TextButton3.Font = Enum.Font.GothamBold
	TextButton3.TextSize = 11
	TextButton3.Text = "SURVIVOR      J"
	TextButton3.TextXAlignment = Enum.TextXAlignment.Center
	TextButton3.LayoutOrder = 2
	TextButton3.Parent = Frame5
	local UICorner4 = Instance.new("UICorner", TextButton3)
	UICorner4.CornerRadius = UDim.new(0, 6)
	local UIStroke3 = Instance.new("UIStroke", TextButton3)
	UIStroke3.Color = Color3.fromRGB(58, 62, 78)
	UIStroke3.Thickness = 1

	TextButton3.MouseButton1Click:Connect(function()
		KezodX:Notify({ Title = "ToF Target", Description = "Survivors", Time = 2 })
	end)

	TextButton3.InputEnded:Connect(function(input4, gameProcessed4)
	end)

	local TextButton4 = Instance.new("TextButton")
	TextButton4.Size = UDim2.new(1, 0, 0, 25)
	TextButton4.BorderSizePixel = 0
	TextButton4.Font = Enum.Font.GothamBold
	TextButton4.TextSize = 11
	TextButton4.Text = "ZOMBIE        L"
	TextButton4.TextXAlignment = Enum.TextXAlignment.Center
	TextButton4.LayoutOrder = 3
	TextButton4.Parent = Frame5
	local UICorner5 = Instance.new("UICorner", TextButton4)
	UICorner5.CornerRadius = UDim.new(0, 6)
	local UIStroke4 = Instance.new("UIStroke", TextButton4)
	UIStroke4.Color = Color3.fromRGB(58, 62, 78)
	UIStroke4.Thickness = 1

	TextButton4.MouseButton1Click:Connect(function()
		KezodX:Notify({ Title = "ToF Target", Description = "Zombie", Time = 2 })
	end)

	TextButton4.InputEnded:Connect(function(input5, gameProcessed5)
	end)

	TextButton3.BackgroundColor3 = Color3.fromRGB(30, 32, 40)
	TextButton3.TextColor3 = Color3.fromRGB(155, 160, 175)
	TextButton2.BackgroundColor3 = Color3.fromRGB(180, 45, 45)
	TextButton2.TextColor3 = Color3.fromRGB(255, 180, 180)
	TextButton4.BackgroundColor3 = Color3.fromRGB(30, 32, 40)
	TextButton4.TextColor3 = Color3.fromRGB(155, 160, 175)

	Frame4.InputBegan:Connect(function(input6, gameProcessed6)
	end)

	Frame4.InputEnded:Connect(function(input7, gameProcessed7)
	end)

	UserInputService.InputChanged:Connect(function(input8, gameProcessed8)
	end)

	local connection = RunService.Heartbeat:Connect(function(deltaTime)
	end)
end

getgenv().KYS_ToFClearLaser = function()
end

getgenv().KYS_ToFSetTargetMode = function()
end

KezodX.ForceCheckbox = false
KezodX.ShowToggleFrameInKeybinds = true
KezodX.Scheme.AccentColor = Color3.fromRGB(0, 255, 255)
KezodX.Scheme.BackgroundColor = Color3.fromRGB(8, 12, 20)
KezodX.Scheme.MainColor = Color3.fromRGB(14, 20, 35)
KezodX.Scheme.OutlineColor = Color3.fromRGB(0, 180, 255)
KezodX.Scheme.FontColor = Color3.fromRGB(180, 240, 255)

local Window = KezodX:CreateWindow({
	Title = "Kanzyu_Script",
	AutoShow = true,
	CornerRadius = 20,
	EnableCompacting = true,
	EnableSidebarResize = true,
	Footer = "TT kanzyu_script | YT kanzyu_script",
	Icon = "136681914611819",
	IconSize = UDim2.fromOffset(50, 50),
	NotifySide = "Right",
	SidebarCompacted = true,
	Size = UDim2.fromOffset(450, 1000)
})

local Tab = Window:AddTab("Info", "info", "Information, Credit")
local Tab2 = Window:AddTab("ESP", "eye", "Esp player, object, stats")
local Tab3 = Window:AddTab("Player", "user", "Ability Survivor & Killer")
local Tab4 = Window:AddTab("Misc", "sliders-horizontal", "Movement, Emote, Fun")
local Tab5 = Window:AddTab("Visual", "sparkles", "Graphics, MorphAva, Time")
local Tab6 = Window:AddTab("UI Settings", "settings-2", "Config, Theme, UiSetting")
local LeftGroupbox = Tab:AddLeftGroupbox("Script Info", "info")
local RightGroupbox = Tab:AddRightGroupbox("Credits", "user")
local LeftGroupbox2 = Tab2:AddLeftGroupbox("ESP Cham", "scan-eye")
local RightGroupbox2 = Tab2:AddRightGroupbox("ESP Status", "scan-eye")
local RightTabbox = Tab3:AddRightTabbox()
local Tab7 = RightTabbox:AddTab("Survivor", "user")
local Tab8 = RightTabbox:AddTab("Killer", "skull")
local LeftGroupbox3 = Tab3:AddLeftGroupbox("AimBot", "crosshair")
local LeftGroupbox4 = Tab3:AddLeftGroupbox("Twist of Fate", "target")
local LeftGroupbox5 = Tab3:AddLeftGroupbox("Parry", "swords")
local LeftGroupbox6 = Tab3:AddLeftGroupbox("Crosshair", "crosshair")
local LeftGroupbox7 = Tab4:AddLeftGroupbox("Movement", "move")
local RightGroupbox3 = Tab4:AddRightGroupbox("Fake Chat Tag", "message-circle")
local LeftGroupbox8 = Tab5:AddLeftGroupbox("Graphics", "sun")
local LeftGroupbox9 = Tab5:AddLeftGroupbox("Morph Avatar", "user")
local RightGroupbox4 = Tab5:AddRightGroupbox("Clock & Ambient", "alarm-clock-check")
local RightGroupbox5 = Tab5:AddRightGroupbox("Zoom Out", "fullscreen")
local LeftGroupbox10 = Tab6:AddLeftGroupbox("Menu", "wrench")
local Remotes3 = ReplicatedStorage:FindFirstChild("Remotes")
local Mechanics = Remotes3:FindFirstChild("Mechanics")
Mechanics:FindFirstChild("Fall")
local descendants = workspace:GetDescendants()

for i, v4 in ipairs(descendants) do
end

workspace.DescendantAdded:Connect(function(descendant)
end)

workspace.DescendantRemoving:Connect(function(descendant2)
end)

hookmetamethod(game, "__namecall", function()
	-- [envlog] error: Script:2: attempt to call a nil value
end)

UserInputService.InputBegan:Connect(function(input9, gameProcessed9)
end)

UserInputService.InputEnded:Connect(function(input10, gameProcessed10)
end)

UserInputService.InputBegan:Connect(function(input11, gameProcessed11)
end)

UserInputService.InputEnded:Connect(function(input12, gameProcessed12)
end)

RunService.RenderStepped:Connect(function(deltaTime2)
	Players.LocalPlayer.Character:GetAttribute("spearmode")
	Circle.Visible = false
	VD_VeilTarget.Parent = nil
	Circle2.Visible = false
end)

task.spawn(function()
	task.wait(0.2)
	task.wait(0.2)
	-- [envlog] the statements above repeat forever (loop)
end)

local TextChatService = game:GetService("TextChatService")

TextChatService.OnIncomingMessage = function()
	Instance.new("TextChatMessageProperties")
end

Lighting.ChildAdded:Connect(function(child)
end)

local BypassGenUI = Players.LocalPlayer.PlayerGui:FindFirstChild("BypassGenUI")
BypassGenUI:Destroy()
local BypassGenUI3 = Instance.new("ScreenGui")
BypassGenUI3.Name = "BypassGenUI"
BypassGenUI3.ResetOnSpawn = false
BypassGenUI3.IgnoreGuiInset = true
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
BypassGenUI3.Parent = PlayerGui
local BypassGenButton = Instance.new("ImageButton")
BypassGenButton.Name = "BypassGenButton"
BypassGenButton.Size = UDim2.new(0, 60, 0, 60)
BypassGenButton.Position = UDim2.new(0.88, 0, 0.55, 0)
BypassGenButton.AnchorPoint = Vector2.new(0.5, 0.5)
BypassGenButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
BypassGenButton.BackgroundTransparency = 0.15
BypassGenButton.AutoButtonColor = true
BypassGenButton.Visible = false
BypassGenButton.ZIndex = 10
BypassGenButton.Parent = BypassGenUI3
local UICorner6 = Instance.new("UICorner", BypassGenButton)
UICorner6.CornerRadius = UDim.new(1, 0)
local UIStroke5 = Instance.new("UIStroke", BypassGenButton)
UIStroke5.Color = Color3.fromRGB(0, 255, 255)
UIStroke5.Thickness = 2
UIStroke5.Transparency = 0.2
local TextLabel2 = Instance.new("TextLabel", BypassGenButton)
TextLabel2.Size = UDim2.new(1, 0, 1, 0)
TextLabel2.BackgroundTransparency = 1
TextLabel2.Text = "K"
TextLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel2.TextScaled = true
TextLabel2.Font = Enum.Font.GothamBlack
TextLabel2.ZIndex = 11

BypassGenButton.MouseButton1Click:Connect(function()
end)

Players.LocalPlayer.CharacterAdded:Connect(function(character2)
	task.wait(0.5)
	local BypassGenUI2 = Players.LocalPlayer.PlayerGui:FindFirstChild("BypassGenUI")
	BypassGenUI2:Destroy()
	local BypassGenUI4 = Instance.new("ScreenGui")
	BypassGenUI4.Name = "BypassGenUI"
	BypassGenUI4.ResetOnSpawn = false
	BypassGenUI4.IgnoreGuiInset = true
	local PlayerGui4 = Players.LocalPlayer:WaitForChild("PlayerGui")
	BypassGenUI4.Parent = PlayerGui4
	local BypassGenButton2 = Instance.new("ImageButton")
	BypassGenButton2.Name = "BypassGenButton"
	BypassGenButton2.Size = UDim2.new(0, 60, 0, 60)
	BypassGenButton2.Position = UDim2.new(0.88, 0, 0.55, 0)
	BypassGenButton2.AnchorPoint = Vector2.new(0.5, 0.5)
	BypassGenButton2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	BypassGenButton2.BackgroundTransparency = 0.15
	BypassGenButton2.AutoButtonColor = true
	BypassGenButton2.Visible = false
	BypassGenButton2.ZIndex = 10
	BypassGenButton2.Parent = BypassGenUI4
	local UICorner7 = Instance.new("UICorner", BypassGenButton2)
	UICorner7.CornerRadius = UDim.new(1, 0)
	local UIStroke6 = Instance.new("UIStroke", BypassGenButton2)
	UIStroke6.Color = Color3.fromRGB(0, 255, 255)
	UIStroke6.Thickness = 2
	UIStroke6.Transparency = 0.2
	local TextLabel3 = Instance.new("TextLabel", BypassGenButton2)
	TextLabel3.Size = UDim2.new(1, 0, 1, 0)
	TextLabel3.BackgroundTransparency = 1
	TextLabel3.Text = "K"
	TextLabel3.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel3.TextScaled = true
	TextLabel3.Font = Enum.Font.GothamBlack
	TextLabel3.ZIndex = 11

	BypassGenButton2.MouseButton1Click:Connect(function()
	end)

	BypassGenButton2.Visible = false
end)

UserInputService.InputBegan:Connect(function(input13, gameProcessed13)
end)

UserInputService.InputBegan:Connect(function(input14, gameProcessed14)
end)

task.spawn(function()
	task.wait(2)
	Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	task.wait(2)
	-- [envlog] the statements above repeat forever (loop)
end)

Players.LocalPlayer.CharacterAdded:Connect(function(character3)
	task.wait(0.8)
	connection3:Disconnect()

	RunService.Heartbeat:Connect(function(deltaTime12)
	end)
end)

Players.LocalPlayer.CharacterAdded:Connect(function(character4)
	task.wait(0.8)
end)

Players.LocalPlayer.CharacterAdded:Connect(function(character5)
	task.wait(1)
	workspace.CurrentCamera.FieldOfView = 70
end)

Players.LocalPlayer.CharacterAdded:Connect(function(character6)
	task.wait(0.5)
	Players.LocalPlayer.CameraMaxZoomDistance = 128
	Players.LocalPlayer.CameraMinZoomDistance = 0.5
	local Humanoid5 = character6:FindFirstChildOfClass("Humanoid")
	local Animator2 = Humanoid5:FindFirstChildOfClass("Animator")

	Animator2.AnimationPlayed:Connect(function()
	end)
end)

RunService.Heartbeat:Connect(function(deltaTime3)
end)

RunService.RenderStepped:Connect(function(deltaTime4)
	Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	local players3 = Players:GetPlayers()

	for k6, v8 in pairs(players3) do
		v8.Character:FindFirstChildOfClass("Humanoid")
	end
	-- [envlog] error: Script:2: attempt to compare number < userdata
end)

RunService.RenderStepped:Connect(function(deltaTime5)
end)

local Humanoid = Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
local Animator = Humanoid:FindFirstChildOfClass("Animator")

Animator.AnimationPlayed:Connect(function()
end)

RunService.RenderStepped:Connect(function(deltaTime6)
end)

LeftGroupbox:AddLabel("Script: kanzyu")
LeftGroupbox:AddLabel("Version: 1.1.1")
LeftGroupbox:AddLabel("Game: Violence District")

LeftGroupbox:AddButton("Copy Saluran Link", function()
	setclipboard("https://whatsapp.com/channel/0029VbCz0u94IBh9AIJTiJ1R")
	KezodX:Notify({ Title = "Saluran link copied!", Duration = 3 })
end)

LeftGroupbox:AddLabel("Join discord for more info")
LeftGroupbox:AddLabel("Discord:")

LeftGroupbox:AddButton("Copy Discord Link", function()
	setclipboard("https://discord.gg/ec6DGUgNC")
	KezodX:Notify({ Title = "Discord link copied!", Duration = 3 })
end)

RightGroupbox:AddLabel("Developer:")
RightGroupbox:AddLabel("• Kanzyu_script")
RightGroupbox:AddDivider()
RightGroupbox:AddLabel("Library:")
RightGroupbox:AddLabel("• Obsidian UI")
RightGroupbox:AddDivider()
RightGroupbox:AddLabel("Support the dev:")

RightGroupbox:AddButton("Copy Support Link", function()
	setclipboard("https://saweria.co/kanzyuscrpt")
	KezodX:Notify({ Title = "Thanks for the support!", Duration = 3 })
end)

for _, item in ipairs({
	{ text = "SurvivorESP", text2 = "ESP Survivor", text3 = "SurvivorESPColor", title = "Survivor Color", r = 0, g = 0, b = 139 },
	{ text = "KillerESP", text2 = "ESP Killer", text3 = "KillerESPColor", title = "Killer Color", r = 255, g = 60, b = 60 },
	{ text = "ESPGenerator", text2 = "Generator", text3 = "GeneratorColor", title = "Generator Color", r = 255, g = 170, b = 0 },
	{ text = "ESPHook", text2 = "Hook", text3 = "HookColor", title = "Hook Color", r = 204, g = 204, b = 0 },
	{ text = "ESPSCP", text2 = "SCP", text3 = "SCPColor", title = "SCP Color", r = 255, g = 255, b = 102 },
	{ text = "ESPPallet", text2 = "Pallet", text3 = "PalletColor", title = "Pallet Color", r = 144, g = 238, b = 144 },
	{ text = "ESPWindow", text2 = "Window", text3 = "WindowColor", title = "Window Color", r = 74, g = 255, b = 181 },
}) do
	local Checkbox = LeftGroupbox2:AddCheckbox(item.text, {
		Text = item.text2,
		Default = false,
		Callback = function()
		end
	})

	Checkbox:AddColorPicker(item.text3, {
		Title = item.title,
		Default = Color3.fromRGB(item.r, item.g, item.b),
		Callback = function()
		end
	})
end

LeftGroupbox2:AddSlider("ESPDistance", {
	Text = "ESP Radius",
	Default = 100,
	Max = 1000,
	Min = 10,
	Rounding = 0,
	Callback = function()
	end
})

for _, item in ipairs({
	{ text = "EnableStatus", text2 = "Enable Status ESP", default = false },
	{ text = "ShowName", text2 = "Show Name", default = true },
	{ text = "ShowItemESP", text2 = "Show Item", default = true },
	{ text = "ShowDistance", text2 = "Show Distance", default = true },
	{ text = "ShowHealth", text2 = "Show Health", default = false },
}) do
	RightGroupbox2:AddCheckbox(item.text, {
		Text = item.text2,
		Default = item.default,
		Callback = function()
		end
	})
end

RightGroupbox2:AddSlider("StatusRadius", {
	Text = "Status Radius",
	Default = 100,
	Max = 500,
	Min = 20,
	Rounding = 0,
	Callback = function()
	end
})

local Checkbox8 = LeftGroupbox6:AddCheckbox("CrosshairEnabled", {
	Text = "Enable Crosshair",
	Default = false,
	Callback = function()
	end
})

Checkbox8:AddColorPicker("CrosshairColor", {
	Title = "Crosshair Color",
	Default = Color3.fromRGB(255, 255, 255),
	Transparency = 0,
	Callback = function()
	end
})

LeftGroupbox6:AddDropdown("Style", {
	Text = "Style",
	Default = 1,
	Multi = false,
	Values = { "Plus", "Dot", "Circle" },
	Callback = function()
	end
})

for _, item in ipairs({
	{ text = "CrosshairPosX", text2 = "Position X" },
	{ text = "CrosshairPosY", text2 = "Position Y" },
}) do
	LeftGroupbox6:AddSlider(item.text, {
		Text = item.text2,
		Default = 0,
		Max = 100,
		Min = -100,
		Rounding = 0,
		Callback = function()
		end
	})
end

Tab7:AddCheckbox("Skill", {
	Text = "Auto Skill Check",
	Default = false,
	Callback = function(state)
		if state then
			RunService.RenderStepped:Connect(function(deltaTime7)
			end)
		end
	end
})

Tab7:AddDropdown("SkillCheckModeDropdown", {
	Text = "Skill Check Mode",
	Default = 1,
	Multi = false,
	Values = { "Legit", "Instant" },
	Callback = function()
	end
})

Tab7:AddCheckbox("GenBypassToggle", {
	Text = "Genboost",
	Default = false,
	Tooltip = "Otomatis repair semua titik generator di dekatmu.",
	Callback = function(state)
		if state then
			BypassGenButton.Visible = UserInputService.TouchEnabled
		else
			BypassGenButton.Visible = false
		end
	end
})

Tab7:AddCheckbox("AutoPalletDrop", {
	Text = "Auto Drop Pallet",
	Default = false,
	Tooltip = "otomatis menjatuhkan pallet",
	Callback = function()
	end
})

Tab7:AddSlider("AutoPalletDist", {
	Text = "Auto Pallet Distance",
	Default = 6,
	Max = 50,
	Min = 5,
	Rounding = 0,
	Callback = function()
	end
})

for _, item in ipairs({
	{ text = "AutoFleeKiller", text2 = "Auto Flee Killer", tooltip = "otomatis tp menjauh dari killer" },
	{ text = "AntiFallDamage", text2 = "Anti Fall Damage", tooltip = "memblokir efek slow ketika jatuh" },
	{ text = "GodMode", text2 = "Anti KnockDown", tooltip = "memaksa berdiri ketika KnockDown" },
	{ text = "FastVault", text2 = "Fast Vault", tooltip = "percepat animasi lompat" },
}) do
	Tab7:AddCheckbox(item.text, {
		Text = item.text2,
		Default = false,
		Tooltip = item.tooltip,
		Callback = function()
		end
	})
end

Tab7:AddSlider("VaultSpeed", {
	Text = "Animation Speed",
	Default = 1.2,
	Max = 5,
	Min = 1,
	Rounding = 1,
	Callback = function()
	end
})

Tab7:AddCheckbox("AntiVault", {
	Text = "Disable Local Vault",
	Default = false,
	Tooltip = "Mencegah karaktermu melakukan vault (berguna agar tidak salah tekan saat dikejar)",
	Callback = function()
	end
})

Tab7:AddDivider()

Tab7:AddButton({
	Text = "instan escape",
	Func = function()
		Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		local descendants2 = workspace:GetDescendants()

		for i2, v5 in ipairs(descendants2) do
		end

		warn("fininshline not found")
	end
})

Tab8:AddLabel("Veil Spear Assist")

for _, item in ipairs({
	{ text = "VeilEnabled", text2 = "Enable Veil Assist", default = false },
	{ text = "VeilShowFOV", text2 = "Show FOV Circle", default = true },
	{ text = "VeilShowLaser", text2 = "Show Target Laser", default = true },
	{ text = "VeilAutoPredict", text2 = "Auto Predict", default = false },
	{ text = "VeilInfLakeMist", text2 = "Infinite LakeMist", default = false },
	{ text = "VeilInfPursuit", text2 = "Infinite Pursuit", default = false },
}) do
	Tab8:AddToggle(item.text, {
		Text = item.text2,
		Default = item.default,
		Callback = function()
		end
	})
end

for _, item in ipairs({
	{ text = "VeilFOV", text2 = "FOV", default = 150, max = 500, min = 10, rounding = 0 },
	{ text = "VeilSpearSpeed", text2 = "Spear Speed", default = 165, max = 300, min = 20, rounding = 0 },
	{ text = "VeilGravity", text2 = "Gravity", default = 5, max = 200, min = 0, rounding = 1 },
	{ text = "VeilMaxDist", text2 = "Max Distance", default = 200, max = 500, min = 10, rounding = 0 },
	{ text = "VeilPredictFactor", text2 = "Prediction Factor", default = 1, max = 3, min = 0, rounding = 2 },
}) do
	Tab8:AddSlider(item.text, {
		Text = item.text2,
		Default = item.default,
		Max = item.max,
		Min = item.min,
		Rounding = item.rounding,
		Callback = function()
		end
	})
end

Tab8:AddDropdown("VeilTargetPart", {
	Text = "Target Part",
	Default = 1,
	Multi = false,
	Values = { "Torso", "Head", "Root" },
	Callback = function()
	end
})

Tab8:AddDivider()

Tab8:AddCheckbox("BlockAllVaults", {
	Text = "Block All Vaults",
	Default = false,
	Tooltip = "memicu Entity Blocker (Mencegah Survivor Vault)",
	Callback = function()
	end
})

Tab8:AddCheckbox("AntiBlindToggle", {
	Text = "Anti Blind (Flashlight)",
	Default = false,
	Callback = function()
	end
})

Tab8:AddCheckbox("AutoStalk", {
	Text = "Auto Stalk (myers)",
	Default = false,
	Callback = function(state)
		if state then
			local connection2 = RunService.Heartbeat:Connect(function(deltaTime8)
			end)
		else
			connection2:Disconnect()
		end
	end
})

Tab8:AddCheckbox("BypassCooldown", {
	Text = "Bypass Cooldown(Abyss)",
	Default = false,
	Callback = function(state)
		if state then
			warn("Fungsi corruptHandler tidak ditemukan di memori.")
			KezodX:Notify({ Title = "Bypass Cooldown", Description = "Diaktifkan", Duration = 3 })
		else
			KezodX:Notify({ Title = "Bypass Cooldown", Description = "Dinonaktifkan", Duration = 3 })
		end
	end
})

Tab8:AddCheckbox("BypassLeapCooldown", {
	Text = "Bypass Cooldown(Hidden)",
	Default = false,
	Callback = function(state)
		if state then
			task.spawn(function()
				warn("Function tidak ditemukan.")
			end)
		end
	end
})

Tab8:AddCheckbox("KillAll", {
	Text = "Auto Kill All",
	Default = false,
	Callback = function()
	end
})

Tab8:AddCheckbox("AttackAim", {
	Text = "AimLock Attack",
	Default = false,
	Callback = function(state)
		if state then
			RunService.RenderStepped:Connect(function(deltaTime9)
			end)
		end
	end
})

Tab8:AddDropdown("AttackAimMode", {
	Text = "Aimlock Mode",
	Default = 1,
	Multi = false,
	Values = { "Normal", "Spear" },
	Callback = function()
	end
})

for _, item in ipairs({
	{ text = "SpearGravity", text2 = "Spear Gravity", default = 50, max = 200, min = 10 },
	{ text = "SpearSpeed", text2 = "Spear Speed", default = 100, max = 300, min = 20 },
}) do
	Tab8:AddSlider(item.text, {
		Text = item.text2,
		Default = item.default,
		Max = item.max,
		Min = item.min,
		Rounding = 0,
		Callback = function()
		end
	})
end

Tab8:AddDivider()

Tab8:AddDropdown("MaskedPowerSelect", {
	Text = "Select Power",
	Default = 1,
	Multi = false,
	Values = { "Cobra", "Richter", "Brandon", "Rabbit", "Alex" },
	Callback = function()
	end
})

Tab8:AddButton("Activate Power", function()
	ReplicatedStorage:FindFirstChild("Remotes", true)
	ReplicatedStorage.Remotes:FindFirstChild("Killers", true)
	ReplicatedStorage.Remotes.Killers:FindFirstChild("Masked", true)
	local Activatepower = ReplicatedStorage.Remotes.Killers.Masked:FindFirstChild("Activatepower")
	Activatepower:FireServer(false)
end)

Tab8:AddButton("Deactivate Power", function()
	ReplicatedStorage:FindFirstChild("Remotes", true)
	ReplicatedStorage.Remotes:FindFirstChild("Killers", true)
	ReplicatedStorage.Remotes.Killers:FindFirstChild("Masked", true)
	local Deactivatepower = ReplicatedStorage.Remotes.Killers.Masked:FindFirstChild("Deactivatepower")
	Deactivatepower:FireServer()
end)

local Checkbox9 = LeftGroupbox5:AddCheckbox("AutoParry", {
	Text = "Auto Parry",
	Default = false,
	Callback = function(state)
		KYS_ParryRange.Transparency = 1

		if state then
			KYS_ParryRange.Transparency = 1
		end
	end
})

Checkbox9:AddColorPicker("ParryRangeColor", {
	Title = "Parry Range Color",
	Default = Color3.fromRGB(255, 80, 80),
	Transparency = 0,
	Callback = function(state)
		if state then
			KYS_ParryRange.Color3 = state
		else
			KYS_ParryRange.Color3 = false
		end
	end
})

LeftGroupbox5:AddCheckbox("ShowParryRange", {
	Text = "Show Parry Range",
	Default = true,
	Callback = function(state)
		if not state then
			KYS_ParryRange.Transparency = 1
		end
	end
})

LeftGroupbox5:AddSlider("ParryDistance", {
	Text = "Distance",
	Default = 8,
	Max = 20,
	Min = 5,
	Rounding = 0,
	Callback = function()
	end
})

LeftGroupbox5:AddCheckbox("AggressiveMode", {
	Text = "Aggressive Mode",
	Default = false,
	Tooltip = "Parry lebih agresif: menunggu mendekat jika dalam jarak deteksi",
	Callback = function()
	end
})

LeftGroupbox5:AddSlider("FaceSensitivity", {
	Text = "Face Sensitivity Killer",
	Default = 0.7,
	Max = 1,
	Min = -1,
	Rounding = 2,
	Callback = function()
	end
})

LeftGroupbox3:AddToggle("GunAimEnabled", {
	Text = "Aim Lock",
	Default = false,
	Callback = function()
	end
})

LeftGroupbox3:AddDropdown("GunAimTarget", {
	Text = "Target",
	Default = 1,
	Values = { "Killer", "Survivor", "SCP" },
	Callback = function()
	end
})

LeftGroupbox3:AddDropdown("GunAimPart", {
	Text = "Aim Part",
	Default = 2,
	Values = { "Head", "HumanoidRootPart", "Torso" },
	Callback = function()
	end
})

for _, item in ipairs({
	{ text = "GunAimFOV", text2 = "FOV", default = 250, max = 1000, min = 50, rounding = 0 },
	{ text = "GunAimPredict", text2 = "Prediction", default = 0.12, max = 1, min = 0, rounding = 2 },
}) do
	LeftGroupbox3:AddSlider(item.text, {
		Text = item.text2,
		Default = item.default,
		Max = item.max,
		Min = item.min,
		Rounding = item.rounding,
		Callback = function()
		end
	})
end

LeftGroupbox4:AddToggle("ToFAimToggle", {
	Text = "Silent Aim Twist of Fate",
	Default = false,
	Callback = function(state)
		if state then
			gethui()
		else
			ToFTargetSelector2:Destroy()
			connection:Disconnect()
		end
	end
})

LeftGroupbox4:AddDropdown("ToFAimTarget", {
	Text = "Target Mode",
	Default = 1,
	Values = { "Killer", "Survivors", "Zombie" },
	Callback = function()
	end
})

for _, item in ipairs({
	{ text = "ToFAimPredict", text2 = "Aim Prediction", default = true },
	{ text = "ToFAimLaser", text2 = "Show Laser", default = true },
	{ text = "ToFAimWallCheck", text2 = "Wall Check", default = false },
	{ text = "ToFAimBlockKnocked", text2 = "Block When Knocked", default = true },
}) do
	LeftGroupbox4:AddToggle(item.text, {
		Text = item.text2,
		Default = item.default,
		Callback = function()
		end
	})
end

LeftGroupbox4:AddSlider("ToFPredictSpeed", {
	Text = "Predict Bullet Speed",
	Default = 400,
	Max = 1500,
	Min = 100,
	Rounding = 0,
	Callback = function()
	end
})

LeftGroupbox4:AddSlider("ToFVerticalDot", {
	Text = "Vertical Dot (Survivor/Zombie)",
	Default = 0.5,
	Max = 1,
	Min = -1,
	Rounding = 2,
	Callback = function()
	end
})

LeftGroupbox4:AddDropdown("ToFKeybind", {
	Text = "Toggle Key",
	Default = 1,
	Values = { "None", "Q", "E", "R", "T", "F", "G", "H", "J", "K", "L", "X", "Z" },
	Callback = function()
	end
})

LeftGroupbox7:AddCheckbox("WalkSpeedToggle", {
	Text = "Walk Speed",
	Default = false,
	Callback = function(state)
		if state then
			local connection3 = RunService.Heartbeat:Connect(function(deltaTime10)
			end)
		else
			local Humanoid2 = Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			Humanoid2.WalkSpeed = 16
		end
	end
})

LeftGroupbox7:AddButton({
	Text = "Fly GUI",
	Func = function()
		local children = game.CoreGui:GetChildren()

		for k4, v6 in pairs(children) do
			local result4 = v6.Name:lower()
			result4:find("fly")
		end

		KezodX:Notify({ Title = "Fly", Description = "Fly GUI terbuka", Time = 3 })
	end
})

LeftGroupbox7:AddSlider("WalkSpeedSlider", {
	Text = "Walk Speed Value",
	Default = 1000,
	Max = 1000,
	Min = 16,
	Rounding = 1,
	Callback = function()
	end
})

LeftGroupbox7:AddCheckbox("NoClipToggle", {
	Text = "No Clip",
	Default = false,
	Callback = function(state)
		if state then
			local connection4 = RunService.RenderStepped:Connect(function(deltaTime11)
			end)
		else
			connection4:Disconnect()
			local descendants3 = Players.LocalPlayer.Character:GetDescendants()

			for k5, v7 in pairs(descendants3) do
				v7.CanCollide = true
			end
		end
	end
})

LeftGroupbox7:AddCheckbox("JumpPowerToggle", {
	Text = "Custom Jump Power",
	Default = false,
	Callback = function(state)
		if state then
			local Humanoid3 = Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			Humanoid3.JumpPower = 50
		else
			local Humanoid4 = Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			Humanoid4.JumpPower = 50
		end
	end
})

LeftGroupbox7:AddSlider("JumpPowerSlider", {
	Text = "Jump Power Value",
	Default = 50,
	Max = 300,
	Min = 0,
	Rounding = 0,
	Callback = function()
	end
})

RightGroupbox3:AddToggle("FakeTagEnabled", {
	Text = "Enable Fake Tag",
	Default = false,
	Callback = function()
	end
})

RightGroupbox3:AddInput("FakeTagText", {
	Text = "Chat Tag",
	Default = "[Kanzyu_script]",
	Finished = true,
	Numeric = false,
	Placeholder = "[Kanzyu_script]",
	Callback = function()
	end
})

LeftGroupbox9:AddButton({
	Text = "Apply Korless",
	Callback = function(state)
		task.wait()
		game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		game.Players.LocalPlayer.Character:FindFirstChild("Right Leg")
		task.wait(0.1)
		game.Players.LocalPlayer.Character.Head.Transparency = 1

		if state then
			local face = game.Players.LocalPlayer.Character.Head:FindFirstChild("face")
			face:Destroy()
			game.Players.LocalPlayer.Character["Right Leg"].Transparency = 1
			local KorlessHead = Instance.new("MeshPart")
			KorlessHead.Name = "KorlessHead"
			KorlessHead.Size = Vector3.new(1.5, 1.5, 1.5)
			KorlessHead.CanCollide = false
			KorlessHead.MeshId = "rbxassetid://902942096"
			KorlessHead.TextureID = "rbxassetid://902843398"
			KorlessHead.CFrame = (game.Players.LocalPlayer.Character["Right Leg"].CFrame * CFrame.new(0, 0.5, 0))
			KorlessHead.Parent = game.Players.LocalPlayer.Character
			local WeldConstraint = Instance.new("WeldConstraint")
			WeldConstraint.Part0 = game.Players.LocalPlayer.Character["Right Leg"]
			WeldConstraint.Part1 = KorlessHead
			WeldConstraint.Parent = KorlessHead

			local connection5 = game.Players.LocalPlayer.CharacterAdded:Connect(function(character7)
				task.wait(1)
				task.wait()
				game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
				game.Players.LocalPlayer.Character:FindFirstChild("Right Leg")
				task.wait(0.1)
				game.Players.LocalPlayer.Character.Head.Transparency = 1
				local face3 = game.Players.LocalPlayer.Character.Head:FindFirstChild("face")
				face3:Destroy()
				game.Players.LocalPlayer.Character["Right Leg"].Transparency = 1
				local KorlessHead2 = Instance.new("MeshPart")
				KorlessHead2.Name = "KorlessHead"
				KorlessHead2.Size = Vector3.new(1.5, 1.5, 1.5)
				KorlessHead2.CanCollide = false
				KorlessHead2.MeshId = "rbxassetid://902942096"
				KorlessHead2.TextureID = "rbxassetid://902843398"
				KorlessHead2.CFrame = (game.Players.LocalPlayer.Character["Right Leg"].CFrame * CFrame.new(0, 0.5, 0))
				KorlessHead2.Parent = game.Players.LocalPlayer.Character
				local WeldConstraint3 = Instance.new("WeldConstraint")
				WeldConstraint3.Part0 = game.Players.LocalPlayer.Character["Right Leg"]
				WeldConstraint3.Part1 = KorlessHead2
				WeldConstraint3.Parent = KorlessHead2
			end)
		else
			local face2 = game.Players.LocalPlayer.Character.Head:FindFirstChild("face")
			face2:Destroy()
			game.Players.LocalPlayer.Character["Right Leg"].Transparency = 1
			local KorlessHead3 = Instance.new("MeshPart")
			KorlessHead3.Name = "KorlessHead"
			KorlessHead3.Size = Vector3.new(1.5, 1.5, 1.5)
			KorlessHead3.CanCollide = false
			KorlessHead3.MeshId = "rbxassetid://902942096"
			KorlessHead3.TextureID = "rbxassetid://902843398"
			KorlessHead3.CFrame = (game.Players.LocalPlayer.Character["Right Leg"].CFrame * CFrame.new(0, 0.5, 0))
			KorlessHead3.Parent = game.Players.LocalPlayer.Character
			local WeldConstraint2 = Instance.new("WeldConstraint")
			WeldConstraint2.Part0 = game.Players.LocalPlayer.Character["Right Leg"]
			WeldConstraint2.Part1 = KorlessHead3
			WeldConstraint2.Parent = KorlessHead3
			connection5:Disconnect()

			game.Players.LocalPlayer.CharacterAdded:Connect(function(character8)
				task.wait(1)
				task.wait()
				game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
				game.Players.LocalPlayer.Character:FindFirstChild("Right Leg")
				task.wait(0.1)
				game.Players.LocalPlayer.Character.Head.Transparency = 1
				local face4 = game.Players.LocalPlayer.Character.Head:FindFirstChild("face")
				face4:Destroy()
				game.Players.LocalPlayer.Character["Right Leg"].Transparency = 1
				local KorlessHead4 = Instance.new("MeshPart")
				KorlessHead4.Name = "KorlessHead"
				KorlessHead4.Size = Vector3.new(1.5, 1.5, 1.5)
				KorlessHead4.CanCollide = false
				KorlessHead4.MeshId = "rbxassetid://902942096"
				KorlessHead4.TextureID = "rbxassetid://902843398"
				KorlessHead4.CFrame = (game.Players.LocalPlayer.Character["Right Leg"].CFrame * CFrame.new(0, 0.5, 0))
				KorlessHead4.Parent = game.Players.LocalPlayer.Character
				local WeldConstraint4 = Instance.new("WeldConstraint")
				WeldConstraint4.Part0 = game.Players.LocalPlayer.Character["Right Leg"]
				WeldConstraint4.Part1 = KorlessHead4
				WeldConstraint4.Parent = KorlessHead4
			end)
		end

		KezodX:Notify({ Title = "Kanzyu_script", Description = "Korless Morph Applied", Time = 3 })
	end
})

LeftGroupbox8:AddToggle("HideName", {
	Text = "Streamer Mode",
	Default = false,
	Callback = function(state)
		if state then
			local PlayerGui2 = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
			local descendants4 = PlayerGui2:GetDescendants()

			for i3, v11 in ipairs(descendants4) do
				tostring(v11.Text):find(Players.LocalPlayer.Name, 1, true)
				v11.Visible = false
			end

			local connection6 = PlayerGui2.DescendantAdded:Connect(function(descendant3)
				task.defer(function()
				end, descendant3)
			end)
		else
			connection6:Disconnect()
			local PlayerGui3 = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
			local descendants5 = PlayerGui3:GetDescendants()

			for i4, v12 in ipairs(descendants5) do
				tostring(v12.Text):find(Players.LocalPlayer.Name, 1, true)
				v12.Visible = true
			end
		end
	end
})

LeftGroupbox8:AddCheckbox("Fullbright", {
	Text = "Fullbright",
	Default = false,
	Callback = function(state)
		if state then
			Lighting.Brightness = 2
			Lighting.ClockTime = 14
			Lighting.Ambient = Color3.new(1, 1, 1)
			Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
			Lighting.GlobalShadows = true
		else
			Lighting.Brightness = 1
			Lighting.ClockTime = 0
			Lighting.Ambient = Lighting.Ambient
			Lighting.OutdoorAmbient = Lighting.OutdoorAmbient
		end
	end
})

LeftGroupbox8:AddCheckbox("NoShadow", {
	Text = "No Shadow",
	Default = false,
	Callback = function()
	end
})

LeftGroupbox8:AddCheckbox("LowGraphics", {
	Text = "Low Graphics",
	Default = false,
	Callback = function(state)
		if state then
			settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
		else
			settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
		end
	end
})

LeftGroupbox8:AddCheckbox("NoScreenEffects", {
	Text = "No Screen Effects",
	Default = false,
	Callback = function(state)
		if state then
			local children2 = Lighting:GetChildren()

			for k9, v13 in pairs(children2) do
				v13.Enabled = false
				v13.Enabled = false
				v13.Enabled = false
				v13.Enabled = false
				v13.Enabled = false
			end
		else
			v13.Enabled = false
		end
	end
})

LeftGroupbox8:AddCheckbox("CleanSky", {
	Text = "Clean Sky",
	Default = false,
	Callback = function(state)
		if state then
			local children3 = Lighting:GetChildren()

			for i5, v14 in ipairs(children3) do
				v14:Destroy()
			end
		end
	end
})

RightGroupbox5:AddCheckbox("ThirdPersonToggle", {
	Text = "Third Person View",
	Default = false,
	Callback = function()
	end
})

RightGroupbox5:AddToggle("UnlimitedZoom", {
	Text = "Unlimited Zoom Out",
	Default = false,
	Callback = function(state)
		if state then
			Players.LocalPlayer.CameraMaxZoomDistance = 1000
			Players.LocalPlayer.CameraMinZoomDistance = 0
		else
			Players.LocalPlayer.CameraMaxZoomDistance = 128
			Players.LocalPlayer.CameraMinZoomDistance = 0.5
		end
	end
})

RightGroupbox5:AddSlider("MaxZoomDistance", {
	Text = "Max Zoom Distance",
	Default = 1000,
	Max = 5000,
	Min = 100,
	Rounding = 0,
	Callback = function()
	end
})

RightGroupbox5:AddToggle("CustomFOV", {
	Text = "Custom FOV",
	Default = false,
	Callback = function()
		workspace.CurrentCamera.FieldOfView = 70
	end
})

RightGroupbox5:AddSlider("CameraFOV", {
	Text = "Camera FOV",
	Default = 70,
	Max = 120,
	Min = 40,
	Rounding = 0,
	Callback = function()
	end
})

RightGroupbox4:AddSlider("ClockTime", {
	Text = "Clock Time",
	Default = 14,
	Max = 24,
	Min = 0,
	Rounding = 0,
	Callback = function(state)
		Lighting.Ambient = Color3.fromRGB(255, 255, 255)
		Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
		Lighting.Brightness = 2

		if state then
			Lighting.ClockTime = state
		else
			Lighting.ClockTime = false
		end
	end
})

RightGroupbox4:AddSlider("Brightness", {
	Text = "Brightness",
	Default = 2,
	Max = 5,
	Min = 0,
	Rounding = 1,
	Callback = function(state)
		Lighting.Ambient = Color3.fromRGB(255, 255, 255)
		Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)

		if state then
			Lighting.Brightness = state
		else
			Lighting.Brightness = false
		end

		Lighting.ClockTime = false
	end
})

LeftGroupbox10:AddToggle("ShowCustomCursor", {
	Text = "Custom Cursor",
	Default = true,
	Callback = function(state)
		if state then
			KezodX.ShowCustomCursor = state
		else
			KezodX.ShowCustomCursor = false
		end
	end
})

LeftGroupbox10:AddDropdown("NotificationSide", {
	Text = "Notification Side",
	Default = "Right",
	Values = { "Left", "Right" },
	Callback = function(state)
		if state then
			KezodX:SetNotifySide(state)
		else
			KezodX:SetNotifySide(false)
		end
	end
})

LeftGroupbox10:AddDropdown("DPIDropdown", {
	Text = "DPI Scale",
	Default = "85%%",
	Values = { "50%", "75%", "85%", "100%", "125%", "150%" },
	Callback = function(arg234)
		local result5 = arg234:gsub("%%", "")
		KezodX:SetDPIScale(tonumber(result5))
	end
})

LeftGroupbox10:AddToggle("HeaderGlowToggle", {
	Text = "Glow AccentBar",
	Default = true,
	Callback = function(state)
		if state then
			Window:SetHeaderGlow(state)
		else
			Window:SetHeaderGlow(false)
		end
	end
})

LeftGroupbox10:AddToggle("ShowProfile", {
	Text = "Show Profile",
	Default = true,
	Callback = function(state)
		if state then
			Window:SetProfileVisible(state)
		else
			Window:SetProfileVisible(false)
		end
	end
})

LeftGroupbox10:AddDivider()
local Label = LeftGroupbox10:AddLabel("Menu bind")
Label:AddKeyPicker("MenuKeybind", { Text = "Menu keybind", Default = "RightShift", NoUI = true })

LeftGroupbox10:AddButton("Unload script", function()
	KezodX:Unload()
end)

KezodX2:SetLibrary(KezodX)
KezodX3:SetLibrary(KezodX)
KezodX3:IgnoreThemeSettings()
KezodX3:SetIgnoreIndexes({})
KezodX2:SetFolder("Kanzyu_script")
KezodX3:SetFolder("Kanzyu_script/configs")
KezodX3:BuildConfigSection(Tab6)
KezodX2:ApplyToTab(Tab6)
KezodX3:LoadAutoloadConfig()
