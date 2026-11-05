--[[
    VD Clean - Repaired Client Foundation
    Compatible with Roblox Studio LocalScripts and environments that execute
    ordinary Roblox client APIs.

    IMPORTANT:
    - This is a clean, standalone replacement foundation, not a reconstruction
      of missing code from the supplied behavior trace.
    - Client-side character changes may be overridden by the server.
    - Game-specific combat, remote manipulation, aim assistance, and bypass
      features from the trace are intentionally not implemented.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    warn("[VD Clean] LocalPlayer unavailable. Run this as a client LocalScript.")
    return
end

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local GUI_NAME = "VDClean_Repaired"

-- Remove an earlier copy so rerunning the script does not duplicate the UI.
local previous = PlayerGui:FindFirstChild(GUI_NAME)
if previous then
    previous:Destroy()
end

local state = {
    enabled = true,
    walkSpeed = false,
    jumpPower = false,
    noClip = false,
    fullbright = false,
    customFov = false,
    speedValue = 24,
    jumpValue = 60,
    fovValue = 80,
}

local connections = {}
local collisionSnapshot = {}
local original = {
    lighting = {
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        GlobalShadows = Lighting.GlobalShadows,
    },
    cameraFov = nil,
    cameraMinZoom = LocalPlayer.CameraMinZoomDistance,
    cameraMaxZoom = LocalPlayer.CameraMaxZoomDistance,
}

local function track(connection)
    table.insert(connections, connection)
    return connection
end

local function getCharacter()
    return LocalPlayer.Character
end

local function getHumanoid()
    local character = getCharacter()
    return character and character:FindFirstChildOfClass("Humanoid")
end

local function getRoot()
    local character = getCharacter()
    return character and character:FindFirstChild("HumanoidRootPart")
end

local function applyMovement()
    local humanoid = getHumanoid()
    if not humanoid then return end

    if state.walkSpeed then
        humanoid.WalkSpeed = state.speedValue
    end
    if state.jumpPower then
        humanoid.UseJumpPower = true
        humanoid.JumpPower = state.jumpValue
    end
end

local function setFullbright(enabled)
    if enabled then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.GlobalShadows = false
    else
        for property, value in pairs(original.lighting) do
            Lighting[property] = value
        end
    end
end

local function setFov(enabled)
    local camera = workspace.CurrentCamera
    if not camera then return end

    if enabled then
        if original.cameraFov == nil then
            original.cameraFov = camera.FieldOfView
        end
        camera.FieldOfView = state.fovValue
    elseif original.cameraFov ~= nil then
        camera.FieldOfView = original.cameraFov
        original.cameraFov = nil
    end
end

-- Build a small, dependency-free interface. This avoids remote loadstring
-- dependencies and works as a normal Studio client LocalScript.
local gui = Instance.new("ScreenGui")
gui.Name = GUI_NAME
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = PlayerGui

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(270, 350)
main.Position = UDim2.new(0, 24, 0.5, -175)
main.BackgroundColor3 = Color3.fromRGB(13, 18, 29)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 190, 255)
stroke.Transparency = 0.25
stroke.Thickness = 1.3
stroke.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 38)
title.Position = UDim2.fromOffset(10, 4)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "DIVINE MESS  /  VD CLEAN"
title.TextColor3 = Color3.fromRGB(220, 245, 255)
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -20, 0, 18)
subtitle.Position = UDim2.fromOffset(10, 35)
subtitle.BackgroundTransparency = 1
subtitle.Font = Enum.Font.Gotham
subtitle.Text = "CLIENT UTILITIES  •  RIGHT SHIFT TO HIDE"
subtitle.TextColor3 = Color3.fromRGB(115, 155, 175)
subtitle.TextSize = 9
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = main

local list = Instance.new("Frame")
list.Name = "Controls"
list.Size = UDim2.new(1, -20, 1, -68)
list.Position = UDim2.fromOffset(10, 60)
list.BackgroundTransparency = 1
list.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 7)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = list

local function makeButton(label, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 31)
    button.BackgroundColor3 = Color3.fromRGB(25, 34, 49)
    button.BorderSizePixel = 0
    button.AutoButtonColor = true
    button.Font = Enum.Font.GothamMedium
    button.TextColor3 = Color3.fromRGB(225, 235, 245)
    button.TextSize = 11
    button.Text = label
    button.Parent = list

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 7)
    buttonCorner.Parent = button

    button.Activated:Connect(callback)
    return button
end

local function makeToggle(label, initial, callback)
    local enabled = initial
    local button

    local function refresh()
        button.Text = label .. (enabled and "   [ON]" or "   [OFF]")
        button.BackgroundColor3 = enabled
            and Color3.fromRGB(0, 105, 135)
            or Color3.fromRGB(25, 34, 49)
    end

    button = makeButton("", function()
        enabled = not enabled
        callback(enabled)
        refresh()
    end)
    refresh()

    return function(value)
        enabled = value
        callback(enabled)
        refresh()
    end
end

makeToggle("Walk speed (24)", false, function(enabled)
    state.walkSpeed = enabled
    if not enabled then
        local humanoid = getHumanoid()
        if humanoid then humanoid.WalkSpeed = 16 end
    else
        applyMovement()
    end
end)

makeToggle("Jump power (60)", false, function(enabled)
    state.jumpPower = enabled
    if not enabled then
        local humanoid = getHumanoid()
        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = 50
        end
    else
        applyMovement()
    end
end)

makeToggle("No-collision (local)", false, function(enabled)
    state.noClip = enabled
    if not enabled then
        for part, canCollide in pairs(collisionSnapshot) do
            if part and part.Parent then
                part.CanCollide = canCollide
            end
        end
        table.clear(collisionSnapshot)
    end
end)

makeToggle("Fullbright", false, function(enabled)
    state.fullbright = enabled
    setFullbright(enabled)
end)

makeToggle("Camera FOV (80)", false, function(enabled)
    state.customFov = enabled
    setFov(enabled)
end)

makeButton("Reset local character settings", function()
    state.walkSpeed = false
    state.jumpPower = false
    state.noClip = false

    local humanoid = getHumanoid()
    if humanoid then
        humanoid.WalkSpeed = 16
        humanoid.UseJumpPower = true
        humanoid.JumpPower = 50
    end

    local character = getCharacter()
    for part, canCollide in pairs(collisionSnapshot) do
        if part and part.Parent then part.CanCollide = canCollide end
    end
    table.clear(collisionSnapshot)
end)

makeButton("Restore visuals", function()
    state.fullbright = false
    state.customFov = false
    setFullbright(false)
    setFov(false)
end)

makeButton("Unload interface", function()
    for _, connection in ipairs(connections) do
        if connection and connection.Connected then
            connection:Disconnect()
        end
    end

    local humanoid = getHumanoid()
    if humanoid then
        humanoid.WalkSpeed = 16
        humanoid.UseJumpPower = true
        humanoid.JumpPower = 50
    end

    local character = getCharacter()
    for part, canCollide in pairs(collisionSnapshot) do
        if part and part.Parent then part.CanCollide = canCollide end
    end
    table.clear(collisionSnapshot)

    setFullbright(false)
    setFov(false)
    LocalPlayer.CameraMinZoomDistance = original.cameraMinZoom
    LocalPlayer.CameraMaxZoomDistance = original.cameraMaxZoom
    gui:Destroy()
end)

-- Drag support for mouse and touch.
local dragging = false
local dragInput
local dragStart
local startPosition

track(main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = main.Position

        local ended
        ended = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                if ended then ended:Disconnect() end
            end
        end)
    end
end))

track(main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end))

track(UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end))

track(UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        main.Visible = not main.Visible
    end
end))

-- Reapply enabled movement settings after respawn.
track(LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.25)
    applyMovement()
end))

-- NoClip is applied only to the local character and restored when disabled.
track(RunService.Stepped:Connect(function()
    if not state.noClip then return end

    local character = getCharacter()
    if not character then return end

    for _, object in ipairs(character:GetDescendants()) do
        if object:IsA("BasePart") then
            if collisionSnapshot[object] == nil then
                collisionSnapshot[object] = object.CanCollide
            end
            object.CanCollide = false
        end
    end
end))

-- Keep the original UI state clean when the script's GUI is removed.
track(gui.Destroying:Connect(function()
    for _, connection in ipairs(connections) do
        if connection and connection.Connected then
            connection:Disconnect()
        end
    end
end))

print("[VD Clean] Repaired client foundation loaded. RightShift toggles the UI.")
