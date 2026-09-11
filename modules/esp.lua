-- ============================================
-- EVIL HUB - ESP MODULE
-- ============================================
-- Enemy ESP with boxes, names, distance, and health display

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local PLAYER = Players.LocalPlayer
local CAMERA = workspace.CurrentCamera

-- ============================================
-- ESP CONFIG
-- ============================================
local ESP = {
    ENABLED = false,
    SHOW_BOXES = true,
    SHOW_NAMES = true,
    SHOW_DISTANCE = true,
    SHOW_HEALTH = true,
    SHOW_TRACERS = true,
    BOX_COLOR = Color3.fromRGB(255, 0, 0),
    TRACER_COLOR = Color3.fromRGB(0, 255, 0),
    TEXT_COLOR = Color3.fromRGB(255, 255, 255),
    FRIENDLY_COLOR = Color3.fromRGB(0, 255, 0),
    ENEMY_COLOR = Color3.fromRGB(255, 0, 0),
    TRACERS = {},
    DRAWINGS = {},
}

-- ============================================
-- DRAWING LIBRARY CHECK
-- ============================================

local Drawing = Drawing or {}
local hasDrawing = pcall(function() return Drawing.new("Line") end)

if hasDrawing then
    Drawing.new("Line"):Destroy()
end

-- ============================================
-- UTILITY FUNCTIONS
-- ============================================

local function worldToScreen(position)
    local screenPos, onScreen = CAMERA:WorldToScreenPoint(position)
    return Vector2.new(screenPos.X, screenPos.Y), onScreen
end

local function getDistance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

local function getHealthPercentage(humanoid)
    if humanoid then
        return (humanoid.Health / humanoid.MaxHealth) * 100
    end
    return 0
end

-- ============================================
-- ESP DRAWING FUNCTIONS
-- ============================================

local function drawBox(character, color)
    if not hasDrawing or not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local head = character:FindFirstChild("Head")
    local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
    
    if not head or not torso then return end
    
    -- Get world positions
    local headPos = head.Position
    local torsoPos = torso.Position
    local rootPos = humanoidRootPart.Position
    
    -- Convert to screen space
    local headScreen, headOnScreen = worldToScreen(headPos)
    local torsoScreen, torsoOnScreen = worldToScreen(torsoPos)
    local rootScreen, rootOnScreen = worldToScreen(rootPos)
    
    if not (headOnScreen and torsoOnScreen and rootOnScreen) then return end
    
    -- Calculate box dimensions
    local height = (headScreen - torsoScreen).Magnitude
    local width = height / 2
    
    -- Draw box outline
    local topLeft = headScreen - Vector2.new(width / 2, height / 2)
    local topRight = headScreen + Vector2.new(width / 2, -height / 2)
    local bottomLeft = headScreen - Vector2.new(width / 2, -height / 2)
    local bottomRight = headScreen + Vector2.new(width / 2, height / 2)
    
    if Drawing.new then
        -- Top line
        local line1 = Drawing.new("Line")
        line1.From = topLeft
        line1.To = topRight
        line1.Color = color
        line1.Thickness = 2
        table.insert(ESP.DRAWINGS, line1)
        
        -- Right line
        local line2 = Drawing.new("Line")
        line2.From = topRight
        line2.To = bottomRight
        line2.Color = color
        line2.Thickness = 2
        table.insert(ESP.DRAWINGS, line2)
        
        -- Bottom line
        local line3 = Drawing.new("Line")
        line3.From = bottomRight
        line3.To = bottomLeft
        line3.Color = color
        line3.Thickness = 2
        table.insert(ESP.DRAWINGS, line3)
        
        -- Left line
        local line4 = Drawing.new("Line")
        line4.From = bottomLeft
        line4.To = topLeft
        line4.Color = color
        line4.Thickness = 2
        table.insert(ESP.DRAWINGS, line4)
    end
end

local function drawTracer(character, color)
    if not hasDrawing or not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local screenPos, onScreen = worldToScreen(humanoidRootPart.Position)
    if not onScreen then return end
    
    if Drawing.new then
        local tracer = Drawing.new("Line")
        tracer.From = Vector2.new(CAMERA.ViewportSize.X / 2, CAMERA.ViewportSize.Y)
        tracer.To = screenPos
        tracer.Color = color
        tracer.Thickness = 1
        tracer.Transparency = 0.7
        table.insert(ESP.DRAWINGS, tracer)
    end
end

local function drawText(screenPos, text, color)
    if not hasDrawing then return end
    
    if Drawing.new then
        local textObj = Drawing.new("Text")
        textObj.Position = screenPos
        textObj.Text = text
        textObj.Color = color
        textObj.Size = 13
        textObj.Font = 2
        textObj.Outline = true
        textObj.OutlineColor = Color3.new(0, 0, 0)
        table.insert(ESP.DRAWINGS, textObj)
    end
end

-- ============================================
-- ESP UPDATE FUNCTION
-- ============================================

local function updateESP()
    -- Clear old drawings
    for _, drawing in pairs(ESP.DRAWINGS) do
        if drawing then
            pcall(function() drawing:Remove() end)
        end
    end
    ESP.DRAWINGS = {}
    
    if not ESP.ENABLED then return end
    
    -- Process all players
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= PLAYER and player.Character then
            local character = player.Character
            local humanoid = character:FindFirstChild("Humanoid")
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and humanoid.Health > 0 and humanoidRootPart then
                local color = ESP.ENEMY_COLOR
                
                -- Draw boxes
                if ESP.SHOW_BOXES then
                    drawBox(character, color)
                end
                
                -- Draw tracers
                if ESP.SHOW_TRACERS then
                    drawTracer(character, ESP.TRACER_COLOR)
                end
                
                -- Draw text information
                local screenPos, onScreen = worldToScreen(humanoidRootPart.Position)
                if onScreen then
                    local infoText = ""
                    
                    if ESP.SHOW_NAMES then
                        infoText = infoText .. player.Name .. "\n"
                    end
                    
                    if ESP.SHOW_DISTANCE then
                        local distance = getDistance(CAMERA.CFrame.Position, humanoidRootPart.Position)
                        infoText = infoText .. string.format("%.1f m\n", distance)
                    end
                    
                    if ESP.SHOW_HEALTH then
                        local health = string.format("%.0f%%", getHealthPercentage(humanoid))
                        infoText = infoText .. "[" .. health .. "]"
                    end
                    
                    if infoText ~= "" then
                        drawText(screenPos, infoText, color)
                    end
                end
            end
        end
    end
end

-- ============================================
-- PUBLIC API
-- ============================================

local ESPModule = {}

function ESPModule:Enable()
    ESP.ENABLED = true
    return "ESP Enabled"
end

function ESPModule:Disable()
    ESP.ENABLED = false
    for _, drawing in pairs(ESP.DRAWINGS) do
        if drawing then
            pcall(function() drawing:Remove() end)
        end
    end
    ESP.DRAWINGS = {}
    return "ESP Disabled"
end

function ESPModule:SetBoxColor(r, g, b)
    ESP.BOX_COLOR = Color3.fromRGB(r, g, b)
    return "Box color updated"
end

function ESPModule:SetShowBoxes(show)
    ESP.SHOW_BOXES = show
    return "Boxes " .. (show and "Enabled" or "Disabled")
end

function ESPModule:SetShowNames(show)
    ESP.SHOW_NAMES = show
    return "Names " .. (show and "Enabled" or "Disabled")
end

function ESPModule:SetShowDistance(show)
    ESP.SHOW_DISTANCE = show
    return "Distance " .. (show and "Enabled" or "Disabled")
end

function ESPModule:SetShowHealth(show)
    ESP.SHOW_HEALTH = show
    return "Health " .. (show and "Enabled" or "Disabled")
end

function ESPModule:SetShowTracers(show)
    ESP.SHOW_TRACERS = show
    return "Tracers " .. (show and "Enabled" or "Disabled")
end

function ESPModule:IsEnabled()
    return ESP.ENABLED
end

-- ============================================
-- MAIN LOOP
-- ============================================

RunService.RenderStepped:Connect(function()
    updateESP()
end)

return ESPModule
