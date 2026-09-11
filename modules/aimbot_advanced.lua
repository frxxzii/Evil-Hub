-- ============================================
-- EVIL HUB - ADVANCED AIMBOT MODULE
-- ============================================
-- Enhanced aimbot with prediction and advanced features

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local PLAYER = Players.LocalPlayer
local CAMERA = workspace.CurrentCamera

-- ============================================
-- ADVANCED AIMBOT CONFIG
-- ============================================
local AIMBOT = {
    ENABLED = false,
    PREDICT = true,
    PREDICTION_FACTOR = 0.135,
    AIM_PART = "Head",
    SMOOTHNESS = 0.15,
    FOV_RADIUS = 300,
    MAX_DISTANCE = 500,
    IGNORE_WALLS = false,
    TARGET = nil,
    HISTORY = {},
}

-- ============================================
-- PREDICTION ALGORITHM
-- ============================================

local function predictTargetPosition(targetPart, velocity)
    if not AIMBOT.PREDICT or not velocity then
        return targetPart.Position
    end
    
    -- Calculate travel time
    local distance = (targetPart.Position - CAMERA.CFrame.Position).Magnitude
    local bulletSpeed = 100 -- Adjust based on game
    local travelTime = distance / bulletSpeed
    
    -- Predict future position
    local predictedPos = targetPart.Position + (velocity * travelTime * AIMBOT.PREDICTION_FACTOR)
    return predictedPos
end

local function getVelocity(targetPart)
    if not AIMBOT.HISTORY[targetPart] then
        AIMBOT.HISTORY[targetPart] = {pos = targetPart.Position, vel = Vector3.new(0, 0, 0)}
    end
    
    local lastData = AIMBOT.HISTORY[targetPart]
    local currentPos = targetPart.Position
    local velocity = (currentPos - lastData.pos) / RunService.RenderStepped:Wait()
    
    AIMBOT.HISTORY[targetPart] = {pos = currentPos, vel = velocity}
    return velocity
end

-- ============================================
-- RAYCASTING FOR WALL CHECK
-- ============================================

local function isLineOfSight(targetPart)
    if AIMBOT.IGNORE_WALLS then return true end
    
    local rayOrigin = CAMERA.CFrame.Position
    local rayDirection = (targetPart.Position - rayOrigin).Unit * 500
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {PLAYER.Character}
    
    local result = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    
    if result then
        return result.Instance:IsDescendantOf(targetPart.Parent)
    end
    
    return true
end

-- ============================================
-- TARGET DETECTION
-- ============================================

local function getEnemies()
    local enemies = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= PLAYER and player.Character then
            local character = player.Character
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            local humanoid = character:FindFirstChild("Humanoid")
            
            if humanoidRootPart and humanoid and humanoid.Health > 0 then
                table.insert(enemies, {player = player, rootPart = humanoidRootPart})
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
    
    local fovVector = Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(CAMERA.ViewportSize.X / 2, CAMERA.ViewportSize.Y / 2)
    return fovVector.Magnitude <= AIMBOT.FOV_RADIUS
end

local function getClosestTarget()
    local enemies = getEnemies()
    local closestEnemy = nil
    local closestDistance = AIMBOT.FOV_RADIUS
    
    for _, enemyData in pairs(enemies) do
        local player = enemyData.player
        local rootPart = enemyData.rootPart
        
        if player.Character then
            local targetPart = player.Character:FindFirstChild(AIMBOT.AIM_PART)
            if targetPart then
                local distance = getDistance(CAMERA.CFrame.Position, rootPart.Position)
                
                if distance <= AIMBOT.MAX_DISTANCE and isInFOV(targetPart.Position) and isLineOfSight(targetPart) then
                    local screenPos = CAMERA:WorldToScreenPoint(targetPart.Position)
                    local fovDistance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(CAMERA.ViewportSize.X / 2, CAMERA.ViewportSize.Y / 2)).Magnitude
                    
                    if fovDistance < closestDistance then
                        closestDistance = fovDistance
                        closestEnemy = player
                    end
                end
            end
        end
    end
    
    return closestEnemy
end

-- ============================================
-- AIMING LOGIC
-- ============================================

local function aimAtTarget(target)
    if not target or not target.Character then
        AIMBOT.TARGET = nil
        return
    end
    
    local targetPart = target.Character:FindFirstChild(AIMBOT.AIM_PART)
    if not targetPart then return end
    
    -- Get velocity for prediction
    local velocity = getVelocity(targetPart)
    
    -- Predict target position
    local predictedPosition = predictTargetPosition(targetPart, velocity)
    
    local cameraPosition = CAMERA.CFrame.Position
    local direction = (predictedPosition - cameraPosition).Unit
    
    -- Smooth camera movement
    local newCFrame = CFrame.new(cameraPosition, cameraPosition + direction)
    CAMERA.CFrame = CAMERA.CFrame:Lerp(newCFrame, AIMBOT.SMOOTHNESS)
end

-- ============================================
-- PUBLIC API
-- ============================================

local AimbotModule = {}

function AimbotModule:Enable()
    AIMBOT.ENABLED = true
    return "Aimbot Enabled"
end

function AimbotModule:Disable()
    AIMBOT.ENABLED = false
    AIMBOT.TARGET = nil
    return "Aimbot Disabled"
end

function AimbotModule:SetFOV(fov)
    AIMBOT.FOV_RADIUS = fov
    return "FOV set to " .. fov
end

function AimbotModule:SetSmoothness(smooth)
    AIMBOT.SMOOTHNESS = math.clamp(smooth, 0, 1)
    return "Smoothness set to " .. AIMBOT.SMOOTHNESS
end

function AimbotModule:SetPrediction(enabled)
    AIMBOT.PREDICT = enabled
    return "Prediction " .. (enabled and "Enabled" or "Disabled")
end

function AimbotModule:SetTargetPart(part)
    AIMBOT.AIM_PART = part
    return "Target part set to " .. part
end

function AimbotModule:SetMaxDistance(distance)
    AIMBOT.MAX_DISTANCE = distance
    return "Max distance set to " .. distance
end

function AimbotModule:GetTarget()
    return AIMBOT.TARGET
end

function AimbotModule:IsEnabled()
    return AIMBOT.ENABLED
end

-- ============================================
-- INPUT HANDLING
-- ============================================

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.E and AIMBOT.ENABLED then
        AIMBOT.TARGET = getClosestTarget()
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.E then
        AIMBOT.TARGET = nil
    end
end)

-- ============================================
-- MAIN LOOP
-- ============================================

RunService.RenderStepped:Connect(function()
    if AIMBOT.ENABLED and AIMBOT.TARGET and AIMBOT.TARGET.Character then
        aimAtTarget(AIMBOT.TARGET)
    end
end)

return AimbotModule
