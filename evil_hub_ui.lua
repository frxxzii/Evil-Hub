-- ============================================
-- EVIL HUB - ROBLOX EXPLOIT UI
-- ============================================
-- Universal GUI for Roblox exploits
-- Designed for Xeno and similar executors

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local PLAYER = Players.LocalPlayer
local MOUSE = PLAYER:GetMouse()
local CAMERA = workspace.CurrentCamera

-- ============================================
-- UI CONFIGURATION
-- ============================================
local UI_CONFIG = {
    AIMBOT_ENABLED = false,
    AIMBOT_KEYBIND = Enum.KeyCode.E,
    TOGGLE_UI_KEY = Enum.KeyCode.RightShift,
    FOV_SIZE = 300,
    AIM_SMOOTHNESS = 0.2,
    CHECK_DISTANCE = 500,
    TARGET_PART = "Head",
    SHOW_FOV = true,
    ESP_ENABLED = false,
}

local TARGET = nil
local UI_VISIBLE = true

-- ============================================
-- CREATE UI
-- ============================================

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EvilHubUI"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999

if syn and syn.protect_gui then
    syn.protect_gui(screenGui)
elseif gethui then
    screenGui.Parent = gethui()
else
    screenGui.Parent = PLAYER:WaitForChild("PlayerGui")
end

-- ============================================
-- MAIN PANEL
-- ============================================

local mainPanel = Instance.new("Frame")
mainPanel.Name = "MainPanel"
mainPanel.Size = UDim2.new(0, 350, 0, 450)
mainPanel.Position = UDim2.new(0, 20, 0, 20)
mainPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainPanel.BorderColor3 = Color3.fromRGB(255, 0, 0)
mainPanel.BorderSizePixel = 2
mainPanel.Parent = screenGui

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainPanel

local titleText = Instance.new("TextLabel")
titleText.Name = "TitleText"
titleText.Size = UDim2.new(1, -40, 1, 0)
titleText.BackgroundTransparency = 1
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 18
titleText.Font = Enum.Font.GothamBold
titleText.Text = "⚡ EVIL HUB ⚡"
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.TextScaled = false
titleText.Parent = titleBar

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -38, 0, 2)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "✕"
closeBtn.Parent = titleBar

-- ScrollingFrame for content
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ScrollFrame"
scrollFrame.Size = UDim2.new(1, -10, 1, -50)
scrollFrame.Position = UDim2.new(0, 5, 0, 45)
scrollFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
scrollFrame.ScrollBarThickness = 8
scrollFrame.Parent = mainPanel

-- ============================================
-- UI HELPER FUNCTIONS
-- ============================================

local function createLabel(parent, text, position, size)
    local label = Instance.new("TextLabel")
    label.Size = size or UDim2.new(1, -10, 0, 25)
    label.Position = position or UDim2.new(0, 5, 0, 0)
    label.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    label.BorderColor3 = Color3.fromRGB(100, 100, 100)
    label.BorderSizePixel = 1
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    return label
end

local function createButton(parent, text, callback, position)
    local button = Instance.new("TextButton")
    button.Name = text
    button.Size = UDim2.new(1, -10, 0, 35)
    button.Position = position or UDim2.new(0, 5, 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    button.BorderColor3 = Color3.fromRGB(255, 0, 0)
    button.BorderSizePixel = 2
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.Text = text
    button.Parent = parent
    
    button.MouseButton1Click:Connect(callback)
    
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    end)
    
    return button
end

local function createToggleButton(parent, text, callback, position)
    local button = createButton(parent, text, callback, position)
    button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    return button
end

-- ============================================
-- POPULATE UI
-- ============================================

local yPos = 0

-- AIMBOT SECTION
local aimbotLabel = createLabel(scrollFrame, "╔═══ AIMBOT ═══╗", UDim2.new(0, 5, 0, yPos), UDim2.new(1, -10, 0, 25))
yPos = yPos + 30

local toggleAimbotBtn = createToggleButton(scrollFrame, "[OFF] Toggle Aimbot", function()
    UI_CONFIG.AIMBOT_ENABLED = not UI_CONFIG.AIMBOT_ENABLED
    toggleAimbotBtn.Text = (UI_CONFIG.AIMBOT_ENABLED and "[ON] " or "[OFF] ") .. "Toggle Aimbot"
    toggleAimbotBtn.BackgroundColor3 = UI_CONFIG.AIMBOT_ENABLED and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(255, 0, 0)
end, UDim2.new(0, 5, 0, yPos))
yPos = yPos + 40

local fovLabel = createLabel(scrollFrame, "FOV: 300", UDim2.new(0, 5, 0, yPos), UDim2.new(1, -10, 0, 20))
yPos = yPos + 25

local fovSlider = Instance.new("TextBox")
fovSlider.Name = "FOVSlider"
fovSlider.Size = UDim2.new(1, -10, 0, 25)
fovSlider.Position = UDim2.new(0, 5, 0, yPos)
fovSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
fovSlider.BorderColor3 = Color3.fromRGB(100, 100, 100)
fovSlider.BorderSizePixel = 1
fovSlider.TextColor3 = Color3.fromRGB(200, 200, 200)
fovSlider.TextSize = 12
fovSlider.Font = Enum.Font.Gotham
fovSlider.Text = "300"
fovSlider.PlaceholderText = "Enter FOV size"
fovSlider.Parent = scrollFrame

fovSlider.FocusLost:Connect(function()
    local value = tonumber(fovSlider.Text)
    if value then
        UI_CONFIG.FOV_SIZE = value
        fovLabel.Text = "FOV: " .. value
    end
    fovSlider.Text = UI_CONFIG.FOV_SIZE
end)

yPos = yPos + 30

local smoothLabel = createLabel(scrollFrame, "Smoothness: 0.2", UDim2.new(0, 5, 0, yPos), UDim2.new(1, -10, 0, 20))
yPos = yPos + 25

local smoothBox = Instance.new("TextBox")
smoothBox.Name = "SmoothBox"
smoothBox.Size = UDim2.new(1, -10, 0, 25)
smoothBox.Position = UDim2.new(0, 5, 0, yPos)
smoothBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
smoothBox.BorderColor3 = Color3.fromRGB(100, 100, 100)
smoothBox.BorderSizePixel = 1
smoothBox.TextColor3 = Color3.fromRGB(200, 200, 200)
smoothBox.TextSize = 12
smoothBox.Font = Enum.Font.Gotham
smoothBox.Text = "0.2"
smoothBox.PlaceholderText = "Enter smoothness"
smoothBox.Parent = scrollFrame

smoothBox.FocusLost:Connect(function()
    local value = tonumber(smoothBox.Text)
    if value then
        UI_CONFIG.AIM_SMOOTHNESS = math.clamp(value, 0, 1)
        smoothLabel.Text = "Smoothness: " .. UI_CONFIG.AIM_SMOOTHNESS
    end
    smoothBox.Text = UI_CONFIG.AIM_SMOOTHNESS
end)

yPos = yPos + 30

local targetPartLabel = createLabel(scrollFrame, "Target Part: Head", UDim2.new(0, 5, 0, yPos), UDim2.new(1, -10, 0, 20))
yPos = yPos + 25

local targetPartBox = Instance.new("TextBox")
targetPartBox.Name = "TargetPartBox"
targetPartBox.Size = UDim2.new(1, -10, 0, 25)
targetPartBox.Position = UDim2.new(0, 5, 0, yPos)
targetPartBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
targetPartBox.BorderColor3 = Color3.fromRGB(100, 100, 100)
targetPartBox.BorderSizePixel = 1
targetPartBox.TextColor3 = Color3.fromRGB(200, 200, 200)
targetPartBox.TextSize = 12
targetPartBox.Font = Enum.Font.Gotham
targetPartBox.Text = "Head"
targetPartBox.PlaceholderText = "Head, UpperTorso, etc"
targetPartBox.Parent = scrollFrame

targetPartBox.FocusLost:Connect(function()
    if targetPartBox.Text ~= "" then
        UI_CONFIG.TARGET_PART = targetPartBox.Text
        targetPartLabel.Text = "Target Part: " .. UI_CONFIG.TARGET_PART
    end
end)

yPos = yPos + 30

-- DIVIDER
createLabel(scrollFrame, "╠══════════════════╣", UDim2.new(0, 5, 0, yPos), UDim2.new(1, -10, 0, 15))
yPos = yPos + 20

-- ESP SECTION
local espLabel = createLabel(scrollFrame, "╔═══ ESP ═══╗", UDim2.new(0, 5, 0, yPos), UDim2.new(1, -10, 0, 25))
yPos = yPos + 30

local toggleESPBtn = createToggleButton(scrollFrame, "[OFF] Toggle ESP", function()
    UI_CONFIG.ESP_ENABLED = not UI_CONFIG.ESP_ENABLED
    toggleESPBtn.Text = (UI_CONFIG.ESP_ENABLED and "[ON] " or "[OFF] ") .. "Toggle ESP"
    toggleESPBtn.BackgroundColor3 = UI_CONFIG.ESP_ENABLED and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(255, 0, 0)
end, UDim2.new(0, 5, 0, yPos))
yPos = yPos + 40

-- INFO SECTION
createLabel(scrollFrame, "╔═══ INFO ═══╗", UDim2.new(0, 5, 0, yPos), UDim2.new(1, -10, 0, 25))
yPos = yPos + 30

local statusLabel = createLabel(scrollFrame, "Status: Ready", UDim2.new(0, 5, 0, yPos), UDim2.new(1, -10, 0, 25))
yPos = yPos + 30

local keybindLabel = createLabel(scrollFrame, "Toggle UI: RShift | Aim: E", UDim2.new(0, 5, 0, yPos), UDim2.new(1, -10, 0, 25))
yPos = yPos + 30

local creditsLabel = createLabel(scrollFrame, "Evil Hub v1.0 | By Frenzii", UDim2.new(0, 5, 0, yPos), UDim2.new(1, -10, 0, 25))

scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 100)

-- ============================================
-- AIMBOT FUNCTIONS
-- ============================================

local function getEnemies()
    local enemies = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= PLAYER and player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoidRootPart and humanoid and humanoid.Health > 0 then
                table.insert(enemies, player)
            end
        end
    end
    return enemies
end

local function getDistance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

local function isInFOV(targetPosition)
    local screenPos, onScreen = CAMERA:WorldToScreenPoint(targetPosition)
    if not onScreen then return false end
    
    local fovDistance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(CAMERA.ViewportSize.X / 2, CAMERA.ViewportSize.Y / 2)).Magnitude
    return fovDistance <= UI_CONFIG.FOV_SIZE
end

local function getClosestEnemyInFOV()
    local enemies = getEnemies()
    local closestEnemy = nil
    local closestDistance = UI_CONFIG.FOV_SIZE
    
    for _, player in pairs(enemies) do
        local targetPart = player.Character:FindFirstChild(UI_CONFIG.TARGET_PART)
        if targetPart then
            local distance = getDistance(CAMERA.CFrame.Position, targetPart.Position)
            
            if distance <= UI_CONFIG.CHECK_DISTANCE and isInFOV(targetPart.Position) then
                local screenPos = CAMERA:WorldToScreenPoint(targetPart.Position)
                local fovDistance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(CAMERA.ViewportSize.X / 2, CAMERA.ViewportSize.Y / 2)).Magnitude
                
                if fovDistance < closestDistance then
                    closestDistance = fovDistance
                    closestEnemy = player
                end
            end
        end
    end
    
    return closestEnemy
end

local function aimAtTarget(target)
    if not target or not target.Character then
        TARGET = nil
        return
    end
    
    local targetPart = target.Character:FindFirstChild(UI_CONFIG.TARGET_PART)
    if not targetPart then return end
    
    local targetPosition = targetPart.Position
    local cameraPosition = CAMERA.CFrame.Position
    local direction = (targetPosition - cameraPosition).Unit
    
    local newCFrame = CFrame.new(cameraPosition, cameraPosition + direction)
    CAMERA.CFrame = CAMERA.CFrame:Lerp(newCFrame, UI_CONFIG.AIM_SMOOTHNESS)
end

-- ============================================
-- INPUT HANDLING
-- ============================================

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == UI_CONFIG.TOGGLE_UI_KEY then
        UI_VISIBLE = not UI_VISIBLE
        mainPanel.Visible = UI_VISIBLE
    end
    
    if input.KeyCode == UI_CONFIG.AIMBOT_KEYBIND and UI_CONFIG.AIMBOT_ENABLED then
        TARGET = getClosestEnemyInFOV()
        if TARGET then
            statusLabel.Text = "Status: Locked on target"
        else
            statusLabel.Text = "Status: No target in FOV"
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.KeyCode == UI_CONFIG.AIMBOT_KEYBIND then
        TARGET = nil
        statusLabel.Text = "Status: Ready"
    end
end)

-- Close button
closeBtn.MouseButton1Click:Connect(function()
    mainPanel:Destroy()
    screenGui:Destroy()
end)

-- ============================================
-- MAIN LOOP
-- ============================================

RunService.RenderStepped:Connect(function()
    if UI_CONFIG.AIMBOT_ENABLED and TARGET and TARGET.Character then
        aimAtTarget(TARGET)
    end
end)

print("✓ Evil Hub UI Loaded Successfully!")
print("✓ Press RShift to toggle UI")
print("✓ Hold E to aim (when aimbot is enabled)")
