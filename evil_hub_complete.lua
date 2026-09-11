-- ============================================
-- EVIL HUB - COMPLETE UI WITH ALL FEATURES
-- ============================================
-- Full-featured GUI with aimbot, ESP, teleport, and tracking systems

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local PLAYER = Players.LocalPlayer
local MOUSE = PLAYER:GetMouse()
local CAMERA = workspace.CurrentCamera

-- ============================================
-- LOAD MODULES
-- ============================================
local Aimbot = loadstring(game:HttpGet("https://raw.githubusercontent.com/frxxzii/Evil-Hub/main/modules/aimbot_advanced.lua"))()
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/frxxzii/Evil-Hub/main/modules/esp.lua"))()
local Teleport = loadstring(game:HttpGet("https://raw.githubusercontent.com/frxxzii/Evil-Hub/main/modules/teleport.lua"))()
local Tracking = loadstring(game:HttpGet("https://raw.githubusercontent.com/frxxzii/Evil-Hub/main/modules/tracking.lua"))()

-- ============================================
-- MAIN CONFIG
-- ============================================
local CONFIG = {
    AIMBOT_ENABLED = false,
    ESP_ENABLED = false,
    TRACKING_ENABLED = false,
    UI_VISIBLE = true,
    CURRENT_TAB = "aimbot",
}

-- ============================================
-- CREATE MAIN UI
-- ============================================

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
mainPanel.Size = UDim2.new(0, 500, 0, 650)
mainPanel.Position = UDim2.new(0, 20, 0, 20)
mainPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainPanel.BorderColor3 = Color3.fromRGB(255, 0, 0)
mainPanel.BorderSizePixel = 3
mainPanel.Parent = screenGui

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainPanel

local titleText = Instance.new("TextLabel")
titleText.Name = "TitleText"
titleText.Size = UDim2.new(1, -100, 1, 0)
titleText.BackgroundTransparency = 1
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 20
titleText.Font = Enum.Font.GothamBold
titleText.Text = "⚡ EVIL HUB v2.0 ⚡"
titleText.TextXAlignment = Enum.TextXAlignment.Center
titleText.Parent = titleBar

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 45, 0, 45)
closeBtn.Position = UDim2.new(1, -50, 0, 2)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 22
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "✕"
closeBtn.Parent = titleBar

closeBtn.MouseButton1Click:Connect(function()
    mainPanel:Destroy()
    screenGui:Destroy()
end)

-- Tab Buttons
local tabFrame = Instance.new("Frame")
tabFrame.Name = "TabFrame"
tabFrame.Size = UDim2.new(1, 0, 0, 50)
tabFrame.Position = UDim2.new(0, 0, 0, 50)
tabFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
tabFrame.BorderSizePixel = 0
tabFrame.Parent = mainPanel

local tabs = {"AIMBOT", "ESP", "TELEPORT", "TRACKING"}
local tabSize = 1 / #tabs

for i, tabName in ipairs(tabs) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = tabName .. "Tab"
    tabBtn.Size = UDim2.new(tabSize, -2, 1, 0)
    tabBtn.Position = UDim2.new((i - 1) * tabSize, 2, 0, 0)
    tabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    tabBtn.BorderColor3 = Color3.fromRGB(100, 100, 100)
    tabBtn.BorderSizePixel = 1
    tabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabBtn.TextSize = 13
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.Text = tabName
    tabBtn.Parent = tabFrame
    
    tabBtn.MouseButton1Click:Connect(function()
        CONFIG.CURRENT_TAB = string.lower(tabName)
        -- Update all tab visuals
        for _, btn in pairs(tabFrame:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            end
        end
        tabBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end)
end

-- Content Scroll Frame
local contentScroll = Instance.new("ScrollingFrame")
contentScroll.Name = "ContentScroll"
contentScroll.Size = UDim2.new(1, -10, 1, -110)
contentScroll.Position = UDim2.new(0, 5, 0, 105)
contentScroll.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
contentScroll.BorderSizePixel = 0
contentScroll.CanvasSize = UDim2.new(0, 0, 0, 800)
contentScroll.ScrollBarThickness = 8
contentScroll.Parent = mainPanel

-- ============================================
-- UI HELPER FUNCTIONS
-- ============================================

local function createLabel(parent, text, yPos, height)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, height or 25)
    label.Position = UDim2.new(0, 5, 0, yPos)
    label.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    label.BorderColor3 = Color3.fromRGB(100, 100, 100)
    label.BorderSizePixel = 1
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    return label
end

local function createButton(parent, text, callback, yPos)
    local button = Instance.new("TextButton")
    button.Name = text
    button.Size = UDim2.new(1, -10, 0, 35)
    button.Position = UDim2.new(0, 5, 0, yPos)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    button.BorderColor3 = Color3.fromRGB(255, 0, 0)
    button.BorderSizePixel = 2
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 13
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

local function createToggleButton(parent, text, callback, yPos)
    local button = createButton(parent, text, callback, yPos)
    button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    return button
end

local function createInputBox(parent, placeholder, yPos)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -10, 0, 30)
    box.Position = UDim2.new(0, 5, 0, yPos)
    box.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    box.BorderColor3 = Color3.fromRGB(100, 100, 100)
    box.BorderSizePixel = 1
    box.TextColor3 = Color3.fromRGB(200, 200, 200)
    box.TextSize = 12
    box.Font = Enum.Font.Gotham
    box.PlaceholderText = placeholder
    box.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
    box.Parent = parent
    return box
end

-- ============================================
-- AIMBOT TAB
-- ============================================

local aimbotTab = Instance.new("Frame")
aimbotTab.Name = "AimbotTab"
aimbotTab.Size = UDim2.new(1, 0, 1, 0)
aimbotTab.BackgroundTransparency = 1
aimbotTab.Parent = contentScroll
aimbotTab.Visible = true

local yPos = 10

createLabel(aimbotTab, "╔════ AIMBOT ════╗", yPos, 25)
yPos = yPos + 30

local toggleAimBtn = createToggleButton(aimbotTab, "[OFF] Enable Aimbot", function()
    CONFIG.AIMBOT_ENABLED = not CONFIG.AIMBOT_ENABLED
    if CONFIG.AIMBOT_ENABLED then
        Aimbot:Enable()
        toggleAimBtn.Text = "[ON] Disable Aimbot"
        toggleAimBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    else
        Aimbot:Disable()
        toggleAimBtn.Text = "[OFF] Enable Aimbot"
        toggleAimBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end
end, yPos)
yPos = yPos + 40

createLabel(aimbotTab, "FOV: 300", yPos, 20)
yPos = yPos + 25

local fovBox = createInputBox(aimbotTab, "Enter FOV size", yPos)
fovBox.Text = "300"
yPos = yPos + 35

fovBox.FocusLost:Connect(function()
    local val = tonumber(fovBox.Text)
    if val then Aimbot:SetFOV(val) end
end)

createLabel(aimbotTab, "Smoothness: 0.15", yPos, 20)
yPos = yPos + 25

local smoothBox = createInputBox(aimbotTab, "Smoothness (0-1)", yPos)
smoothBox.Text = "0.15"
yPos = yPos + 35

smoothBox.FocusLost:Connect(function()
    local val = tonumber(smoothBox.Text)
    if val then Aimbot:SetSmoothness(val) end
end)

createLabel(aimbotTab, "Target Part: Head", yPos, 20)
yPos = yPos + 25

local targetBox = createInputBox(aimbotTab, "Head, UpperTorso, etc", yPos)
targetBox.Text = "Head"
yPos = yPos + 35

targetBox.FocusLost:Connect(function()
    if targetBox.Text ~= "" then Aimbot:SetTargetPart(targetBox.Text) end
end)

local togglePredictionBtn = createToggleButton(aimbotTab, "[ON] Prediction", function()
    -- Toggle prediction
end, yPos)
togglePredictionBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
yPos = yPos + 40

createLabel(aimbotTab, "╠════════════════╣", yPos, 15)
yPos = yPos + 20

createLabel(aimbotTab, "Keybinds:", yPos, 20)
yPos = yPos + 25

createLabel(aimbotTab, "• Hold E to aim", yPos, 20)
yPos = yPos + 25

createLabel(aimbotTab, "• Right Shift to toggle UI", yPos, 20)
yPos = yPos + 25

-- ============================================
-- ESP TAB
-- ============================================

local espTab = Instance.new("Frame")
espTab.Name = "ESPTab"
espTab.Size = UDim2.new(1, 0, 1, 0)
espTab.BackgroundTransparency = 1
espTab.Parent = contentScroll
espTab.Visible = false

yPos = 10

createLabel(espTab, "╔════ ESP ════╗", yPos, 25)
yPos = yPos + 30

local toggleESPBtn = createToggleButton(espTab, "[OFF] Enable ESP", function()
    CONFIG.ESP_ENABLED = not CONFIG.ESP_ENABLED
    if CONFIG.ESP_ENABLED then
        ESP:Enable()
        toggleESPBtn.Text = "[ON] Disable ESP"
        toggleESPBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    else
        ESP:Disable()
        toggleESPBtn.Text = "[OFF] Enable ESP"
        toggleESPBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end
end, yPos)
yPos = yPos + 40

createLabel(espTab, "Options:", yPos, 20)
yPos = yPos + 25

local toggleBoxesBtn = createButton(espTab, "[ON] Boxes", function()
    ESP:SetShowBoxes(not CONFIG.SHOW_BOXES)
end, yPos)
yPos = yPos + 40

local toggleNamesBtn = createButton(espTab, "[ON] Names", function()
    ESP:SetShowNames(not CONFIG.SHOW_NAMES)
end, yPos)
yPos = yPos + 40

local toggleDistanceBtn = createButton(espTab, "[ON] Distance", function()
    ESP:SetShowDistance(not CONFIG.SHOW_DISTANCE)
end, yPos)
yPos = yPos + 40

local toggleHealthBtn = createButton(espTab, "[ON] Health", function()
    ESP:SetShowHealth(not CONFIG.SHOW_HEALTH)
end, yPos)
yPos = yPos + 40

local toggleTracersBtn = createButton(espTab, "[ON] Tracers", function()
    ESP:SetShowTracers(not CONFIG.SHOW_TRACERS)
end, yPos)
yPos = yPos + 40

-- ============================================
-- TELEPORT TAB
-- ============================================

local teleportTab = Instance.new("Frame")
teleportTab.Name = "TeleportTab"
teleportTab.Size = UDim2.new(1, 0, 1, 0)
teleportTab.BackgroundTransparency = 1
teleportTab.Parent = contentScroll
teleportTab.Visible = false

yPos = 10

createLabel(teleportTab, "╔════ TELEPORT ════╗", yPos, 25)
yPos = yPos + 30

createLabel(teleportTab, "Teleport to Player:", yPos, 20)
yPos = yPos + 25

local playerBox = createInputBox(teleportTab, "Player name", yPos)
yPos = yPos + 35

createButton(teleportTab, "Teleport", function()
    if playerBox.Text ~= "" then
        Teleport:TeleportToPlayer(playerBox.Text)
    end
end, yPos)
yPos = yPos + 40

createLabel(teleportTab, "╠═════════════════╣", yPos, 15)
yPos = yPos + 20

createLabel(teleportTab, "Teleport to Coords:", yPos, 20)
yPos = yPos + 25

local xBox = createInputBox(teleportTab, "X", yPos)
yPos = yPos + 35

local yBox = createInputBox(teleportTab, "Y", yPos)
yPos = yPos + 35

local zBox = createInputBox(teleportTab, "Z", yPos)
yPos = yPos + 35

createButton(teleportTab, "Teleport to Coords", function()
    local x = tonumber(xBox.Text)
    local y = tonumber(yBox.Text)
    local z = tonumber(zBox.Text)
    if x and y and z then
        Teleport:TeleportToCoordinates(x, y, z)
    end
end, yPos)
yPos = yPos + 40

createLabel(teleportTab, "╠═════════════════╣", yPos, 15)
yPos = yPos + 20

createLabel(teleportTab, "Waypoints:", yPos, 20)
yPos = yPos + 25

local waypointBox = createInputBox(teleportTab, "Waypoint name", yPos)
yPos = yPos + 35

createButton(teleportTab, "Save Waypoint", function()
    if waypointBox.Text ~= "" then
        local pos = Teleport:GetCurrentPosition()
        Teleport:AddWaypoint(waypointBox.Text, pos.x, pos.y, pos.z)
    end
end, yPos)
yPos = yPos + 40

createButton(teleportTab, "Teleport to Waypoint", function()
    if waypointBox.Text ~= "" then
        Teleport:TeleportToWaypoint(waypointBox.Text)
    end
end, yPos)
yPos = yPos + 40

-- ============================================
-- TRACKING TAB
-- ============================================

local trackingTab = Instance.new("Frame")
trackingTab.Name = "TrackingTab"
trackingTab.Size = UDim2.new(1, 0, 1, 0)
trackingTab.BackgroundTransparency = 1
trackingTab.Parent = contentScroll
trackingTab.Visible = false

yPos = 10

createLabel(trackingTab, "╔════ TRACKING ════╗", yPos, 25)
yPos = yPos + 30

local toggleTrackingBtn = createToggleButton(trackingTab, "[OFF] Enable Tracking", function()
    CONFIG.TRACKING_ENABLED = not CONFIG.TRACKING_ENABLED
    if CONFIG.TRACKING_ENABLED then
        Tracking:EnableTracking()
        toggleTrackingBtn.Text = "[ON] Disable Tracking"
        toggleTrackingBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    else
        Tracking:DisableTracking()
        toggleTrackingBtn.Text = "[OFF] Enable Tracking"
        toggleTrackingBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end
end, yPos)
yPos = yPos + 40

createLabel(trackingTab, "Aim Tracking Stats:", yPos, 20)
yPos = yPos + 25

local aimStatsLabel = createLabel(trackingTab, "Shots: 0 | Hits: 0 | Accuracy: 0%", yPos, 40)
yPos = yPos + 45

createLabel(trackingTab, "╠═════════════════╣", yPos, 15)
yPos = yPos + 20

createLabel(trackingTab, "Tool Tracking:", yPos, 20)
yPos = yPos + 25

local toolStatsLabel = createLabel(trackingTab, "Tracking active tools...", yPos, 40)
yPos = yPos + 45

createLabel(trackingTab, "╠═════════════════╣", yPos, 15)
yPos = yPos + 20

createLabel(trackingTab, "Player Stats:", yPos, 20)
yPos = yPos + 25

local playerStatsBox = createInputBox(trackingTab, "Player name", yPos)
yPos = yPos + 35

createButton(trackingTab, "Get Stats", function()
    if playerStatsBox.Text ~= "" then
        local stats = Tracking:GetComprehensiveStats(playerStatsBox.Text)
        local statsText = "Aim: " .. (stats.aim_stats.accuracy or "N/A")
        aimStatsLabel.Text = statsText
    end
end, yPos)
yPos = yPos + 40

createButton(trackingTab, "Reset Stats", function()
    Tracking:ResetStats()
    aimStatsLabel.Text = "Stats reset!"
end, yPos)
yPos = yPos + 40

-- ============================================
-- TAB SWITCHING
-- ============================================

local function switchTab(tabName)
    for _, tab in pairs(contentScroll:GetChildren()) do
        if tab:IsA("Frame") then
            tab.Visible = false
        end
    end
    
    local targetTab = contentScroll:FindFirstChild(string.upper(tabName) .. "Tab")
    if targetTab then
        targetTab.Visible = true
    end
end

-- Update tab visibility based on config
RunService.RenderStepped:Connect(function()
    switchTab(CONFIG.CURRENT_TAB)
end)

-- ============================================
-- INPUT HANDLING
-- ============================================

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.RightShift then
        CONFIG.UI_VISIBLE = not CONFIG.UI_VISIBLE
        mainPanel.Visible = CONFIG.UI_VISIBLE
    end
end)

-- ============================================
-- STARTUP
-- ============================================

print("╔═══════════════════════════════════╗")
print("║   ⚡ EVIL HUB v2.0 LOADED ⚡    ║")
print("║                                   ║")
print("║  Aimbot | ESP | Teleport | Track ║")
print("║                                   ║")
print("║  Press Right Shift to toggle UI  ║")
print("╚═══════════════════════════════════╝")
