-- ============================================
-- EVIL HUB - NEW UI STYLE (Like your image)
-- ============================================
-- Simplified, clean UI with horizontal tabs

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local PLAYER = Players.LocalPlayer
local CAMERA = workspace.CurrentCamera

-- ============================================
-- LOAD MODULES
-- ============================================
local pcall_load = pcall
local Aimbot = {}
local ESP = {}
local Teleport = {}
local Tracking = {}

-- Safe module loading
pcall(function()
    Aimbot = loadstring(game:HttpGet("https://raw.githubusercontent.com/frxxzii/Evil-Hub/main/modules/aimbot_advanced.lua"))() or {}
end)
pcall(function()
    ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/frxxzii/Evil-Hub/main/modules/esp.lua"))() or {}
end)
pcall(function()
    Teleport = loadstring(game:HttpGet("https://raw.githubusercontent.com/frxxzii/Evil-Hub/main/modules/teleport.lua"))() or {}
end)
pcall(function()
    Tracking = loadstring(game:HttpGet("https://raw.githubusercontent.com/frxxzii/Evil-Hub/main/modules/tracking.lua"))() or {}
end)

-- ============================================
-- CONFIG
-- ============================================
local UI_CONFIG = {
    CURRENT_TAB = "AIMBOT",
    AIMBOT_ENABLED = false,
    ESP_ENABLED = false,
    TELEPORT_ENABLED = false,
    TRACKING_ENABLED = false,
}

-- ============================================
-- CREATE MAIN SCREEN GUI
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
-- MAIN FRAME
-- ============================================

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 750, 0, 600)
mainFrame.Position = UDim2.new(0, 75, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
mainFrame.BorderSizePixel = 3
mainFrame.Parent = screenGui

-- ============================================
-- TITLE BAR
-- ============================================

local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 60)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 24
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "⚡ EVIL HUB v2.0 ⚡"
titleLabel.TextXAlignment = Enum.TextXAlignment.Center
titleLabel.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 45, 0, 45)
closeBtn.Position = UDim2.new(1, -50, 0, 7)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 24
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "✕"
closeBtn.Parent = titleBar

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- ============================================
-- TAB BAR
-- ============================================

local tabBar = Instance.new("Frame")
tabBar.Name = "TabBar"
tabBar.Size = UDim2.new(1, 0, 0, 60)
tabBar.Position = UDim2.new(0, 0, 0, 60)
tabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
tabBar.BorderSizePixel = 0
tabBar.Parent = mainFrame

local tabSize = 1 / 4

local tabs = {"AIMBOT", "ESP", "TELEPORT", "TRACKING"}
local tabButtons = {}

for i, tabName in ipairs(tabs) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = tabName .. "Btn"
    tabBtn.Size = UDim2.new(tabSize, 0, 1, 0)
    tabBtn.Position = UDim2.new((i - 1) * tabSize, 0, 0, 0)
    tabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    tabBtn.BorderColor3 = Color3.fromRGB(100, 100, 100)
    tabBtn.BorderSizePixel = 1
    tabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabBtn.TextSize = 14
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.Text = tabName
    tabBtn.Parent = tabBar
    
    tabButtons[tabName] = tabBtn
    
    tabBtn.MouseButton1Click:Connect(function()
        UI_CONFIG.CURRENT_TAB = tabName
        
        -- Update all tab colors
        for _, btn in pairs(tabButtons) do
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        
        -- Highlight selected tab
        tabBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
end

-- Set AIMBOT as default selected
tabButtons["AIMBOT"].BackgroundColor3 = Color3.fromRGB(255, 0, 0)
tabButtons["AIMBOT"].TextColor3 = Color3.fromRGB(255, 255, 255)

-- ============================================
-- CONTENT AREA
-- ============================================

local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -10, 1, -140)
contentFrame.Position = UDim2.new(0, 5, 0, 125)
contentFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

-- ============================================
-- AIMBOT TAB CONTENT
-- ============================================

local aimbotContent = Instance.new("Frame")
aimbotContent.Name = "AimbotContent"
aimbotContent.Size = UDim2.new(1, 0, 1, 0)
aimbotContent.BackgroundTransparency = 1
aimbotContent.Parent = contentFrame
aimbotContent.Visible = true

-- Create TextLabel for aimbot status
local aimbotStatusLabel = Instance.new("TextLabel")
aimbotStatusLabel.Name = "StatusLabel"
aimbotStatusLabel.Size = UDim2.new(1, -20, 0, 50)
aimbotStatusLabel.Position = UDim2.new(0, 10, 0, 20)
aimbotStatusLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
aimbotStatusLabel.BorderColor3 = Color3.fromRGB(100, 100, 100)
aimbotStatusLabel.BorderSizePixel = 1
aimbotStatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
aimbotStatusLabel.TextSize = 14
aimbotStatusLabel.Font = Enum.Font.Gotham
aimbotStatusLabel.Text = "Aimbot Status: DISABLED\nFOV: 300 | Smoothness: 0.15"
aimbotStatusLabel.TextXAlignment = Enum.TextXAlignment.Left
aimbotStatusLabel.Parent = aimbotContent

local toggleAimbotBtn = Instance.new("TextButton")
toggleAimbotBtn.Name = "ToggleBtn"
toggleAimbotBtn.Size = UDim2.new(0, 150, 0, 40)
toggleAimbotBtn.Position = UDim2.new(0, 10, 0, 90)
toggleAimbotBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
toggleAimbotBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleAimbotBtn.TextSize = 14
toggleAimbotBtn.Font = Enum.Font.GothamBold
toggleAimbotBtn.Text = "Enable"
toggleAimbotBtn.BorderSizePixel = 0
toggleAimbotBtn.Parent = aimbotContent

toggleAimbotBtn.MouseButton1Click:Connect(function()
    UI_CONFIG.AIMBOT_ENABLED = not UI_CONFIG.AIMBOT_ENABLED
    if UI_CONFIG.AIMBOT_ENABLED then
        if Aimbot.Enable then Aimbot:Enable() end
        toggleAimbotBtn.Text = "Disable"
        toggleAimbotBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        aimbotStatusLabel.Text = "Aimbot Status: ENABLED\nFOV: 300 | Smoothness: 0.15"
        aimbotStatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        if Aimbot.Disable then Aimbot:Disable() end
        toggleAimbotBtn.Text = "Enable"
        toggleAimbotBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        aimbotStatusLabel.Text = "Aimbot Status: DISABLED\nFOV: 300 | Smoothness: 0.15"
        aimbotStatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

-- ============================================
-- ESP TAB CONTENT
-- ============================================

local espContent = Instance.new("Frame")
espContent.Name = "ESPContent"
espContent.Size = UDim2.new(1, 0, 1, 0)
espContent.BackgroundTransparency = 1
espContent.Parent = contentFrame
espContent.Visible = false

local espStatusLabel = Instance.new("TextLabel")
espStatusLabel.Name = "StatusLabel"
espStatusLabel.Size = UDim2.new(1, -20, 0, 50)
espStatusLabel.Position = UDim2.new(0, 10, 0, 20)
espStatusLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
espStatusLabel.BorderColor3 = Color3.fromRGB(100, 100, 100)
espStatusLabel.BorderSizePixel = 1
espStatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
espStatusLabel.TextSize = 14
espStatusLabel.Font = Enum.Font.Gotham
espStatusLabel.Text = "ESP Status: DISABLED\nBoxes: ON | Names: ON | Health: ON"
espStatusLabel.TextXAlignment = Enum.TextXAlignment.Left
espStatusLabel.Parent = espContent

local toggleESPBtn = Instance.new("TextButton")
toggleESPBtn.Name = "ToggleBtn"
toggleESPBtn.Size = UDim2.new(0, 150, 0, 40)
toggleESPBtn.Position = UDim2.new(0, 10, 0, 90)
toggleESPBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
toggleESPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleESPBtn.TextSize = 14
toggleESPBtn.Font = Enum.Font.GothamBold
toggleESPBtn.Text = "Enable"
toggleESPBtn.BorderSizePixel = 0
toggleESPBtn.Parent = espContent

toggleESPBtn.MouseButton1Click:Connect(function()
    UI_CONFIG.ESP_ENABLED = not UI_CONFIG.ESP_ENABLED
    if UI_CONFIG.ESP_ENABLED then
        if ESP.Enable then ESP:Enable() end
        toggleESPBtn.Text = "Disable"
        toggleESPBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        espStatusLabel.Text = "ESP Status: ENABLED\nBoxes: ON | Names: ON | Health: ON"
        espStatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        if ESP.Disable then ESP:Disable() end
        toggleESPBtn.Text = "Enable"
        toggleESPBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        espStatusLabel.Text = "ESP Status: DISABLED\nBoxes: ON | Names: ON | Health: ON"
        espStatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

-- ============================================
-- TELEPORT TAB CONTENT
-- ============================================

local teleportContent = Instance.new("Frame")
teleportContent.Name = "TeleportContent"
teleportContent.Size = UDim2.new(1, 0, 1, 0)
teleportContent.BackgroundTransparency = 1
teleportContent.Parent = contentFrame
teleportContent.Visible = false

local teleportLabel = Instance.new("TextLabel")
teleportLabel.Name = "InfoLabel"
teleportLabel.Size = UDim2.new(1, -20, 0, 40)
teleportLabel.Position = UDim2.new(0, 10, 0, 20)
teleportLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
teleportLabel.BorderColor3 = Color3.fromRGB(100, 100, 100)
teleportLabel.BorderSizePixel = 1
teleportLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
teleportLabel.TextSize = 12
teleportLabel.Font = Enum.Font.Gotham
teleportLabel.Text = "Enter player name to teleport or coordinates (X, Y, Z)"
teleportLabel.TextXAlignment = Enum.TextXAlignment.Left
teleportLabel.Parent = teleportContent

local playerInputBox = Instance.new("TextBox")
playerInputBox.Name = "PlayerInput"
playerInputBox.Size = UDim2.new(0, 200, 0, 35)
playerInputBox.Position = UDim2.new(0, 10, 0, 70)
playerInputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
playerInputBox.TextColor3 = Color3.fromRGB(200, 200, 200)
playerInputBox.TextSize = 12
playerInputBox.Font = Enum.Font.Gotham
playerInputBox.PlaceholderText = "Player name"
playerInputBox.BorderSizePixel = 1
playerInputBox.Parent = teleportContent

local tpPlayerBtn = Instance.new("TextButton")
tpPlayerBtn.Name = "TPPlayerBtn"
tpPlayerBtn.Size = UDim2.new(0, 150, 0, 35)
tpPlayerBtn.Position = UDim2.new(0, 220, 0, 70)
tpPlayerBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
tpPlayerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tpPlayerBtn.TextSize = 12
tpPlayerBtn.Font = Enum.Font.GothamBold
tpPlayerBtn.Text = "Teleport"
tpPlayerBtn.BorderSizePixel = 0
tpPlayerBtn.Parent = teleportContent

tpPlayerBtn.MouseButton1Click:Connect(function()
    if playerInputBox.Text ~= "" and Teleport.TeleportToPlayer then
        Teleport:TeleportToPlayer(playerInputBox.Text)
    end
end)

-- ============================================
-- TRACKING TAB CONTENT
-- ============================================

local trackingContent = Instance.new("Frame")
trackingContent.Name = "TrackingContent"
trackingContent.Size = UDim2.new(1, 0, 1, 0)
trackingContent.BackgroundTransparency = 1
trackingContent.Parent = contentFrame
trackingContent.Visible = false

local trackingStatusLabel = Instance.new("TextLabel")
trackingStatusLabel.Name = "StatusLabel"
trackingStatusLabel.Size = UDim2.new(1, -20, 0, 50)
trackingStatusLabel.Position = UDim2.new(0, 10, 0, 20)
trackingStatusLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
trackingStatusLabel.BorderColor3 = Color3.fromRGB(100, 100, 100)
trackingStatusLabel.BorderSizePixel = 1
trackingStatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
trackingStatusLabel.TextSize = 14
trackingStatusLabel.Font = Enum.Font.Gotham
trackingStatusLabel.Text = "Tracking Status: DISABLED\nAim Tracking | Tool Tracking | Stats"
trackingStatusLabel.TextXAlignment = Enum.TextXAlignment.Left
trackingStatusLabel.Parent = trackingContent

local toggleTrackingBtn = Instance.new("TextButton")
toggleTrackingBtn.Name = "ToggleBtn"
toggleTrackingBtn.Size = UDim2.new(0, 150, 0, 40)
toggleTrackingBtn.Position = UDim2.new(0, 10, 0, 90)
toggleTrackingBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
toggleTrackingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleTrackingBtn.TextSize = 14
toggleTrackingBtn.Font = Enum.Font.GothamBold
toggleTrackingBtn.Text = "Enable"
toggleTrackingBtn.BorderSizePixel = 0
toggleTrackingBtn.Parent = trackingContent

toggleTrackingBtn.MouseButton1Click:Connect(function()
    UI_CONFIG.TRACKING_ENABLED = not UI_CONFIG.TRACKING_ENABLED
    if UI_CONFIG.TRACKING_ENABLED then
        if Tracking.EnableTracking then Tracking:EnableTracking() end
        toggleTrackingBtn.Text = "Disable"
        toggleTrackingBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        trackingStatusLabel.Text = "Tracking Status: ENABLED\nAim Tracking | Tool Tracking | Stats"
        trackingStatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        if Tracking.DisableTracking then Tracking:DisableTracking() end
        toggleTrackingBtn.Text = "Enable"
        toggleTrackingBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        trackingStatusLabel.Text = "Tracking Status: DISABLED\nAim Tracking | Tool Tracking | Stats"
        trackingStatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

-- ============================================
-- TAB SWITCHING LOGIC
-- ============================================

RunService.RenderStepped:Connect(function()
    local tabs = {
        AIMBOT = aimbotContent,
        ESP = espContent,
        TELEPORT = teleportContent,
        TRACKING = trackingContent,
    }
    
    for tabName, tab in pairs(tabs) do
        tab.Visible = (tabName == UI_CONFIG.CURRENT_TAB)
    end
end)

-- ============================================
-- INPUT HANDLING
-- ============================================

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.RightShift then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

-- ============================================
-- STARTUP MESSAGE
-- ============================================

print("╔═══════════════════════════════════╗")
print("║   ⚡ EVIL HUB v2.0 LOADED ⚡    ║")
print("║                                   ║")
print("║  Aimbot | ESP | Teleport | Track ║")
print("║                                   ║")
print("║  Press Right Shift to toggle UI  ║")
print("║  Hold E to aim (aimbot enabled)  ║")
print("╚═══════════════════════════════════╝")
