-- ============================================
-- ROBLOX UNIVERSAL AIMBOT SCRIPT
-- ============================================
-- A universal aimbot script for Roblox games
-- Supports humanoid detection and smooth aiming

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- ============================================
-- CONFIGURATION
-- ============================================
local CONFIG = {
    ENABLED = false,
    FOV_SIZE = 500,
    AIM_SMOOTHNESS = 0.15,
    CHECK_DISTANCE = 500,
    AIM_KEY = Enum.KeyCode.E,
    TOGGLE_KEY = Enum.KeyCode.T,
    TARGET_PART = "Head", -- Part to aim at (Head, UpperTorso, etc)
    SHOW_FOV = true,
    FOV_COLOR = Color3.fromRGB(0, 255, 0),
}

local TARGET = nil
local PLAYER = Players.LocalPlayer
local CAMERA = workspace.CurrentCamera

-- ============================================
-- UTILITY FUNCTIONS
-- ============================================

--- Get all enemies in the game
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

--- Calculate distance between two points
local function getDistance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

--- Check if a player is within FOV
local function isInFOV(targetPosition)
    local screenPos, onScreen = CAMERA:WorldToScreenPoint(targetPosition)
    if not onScreen then return false end
    
    local fovDistance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(CAMERA.ViewportSize.X / 2, CAMERA.ViewportSize.Y / 2)).Magnitude
    return fovDistance <= CONFIG.FOV_SIZE
end

--- Get the closest enemy in FOV
local function getClosestEnemyInFOV()
    local enemies = getEnemies()
    local closestEnemy = nil
    local closestDistance = CONFIG.FOV_SIZE
    
    for _, player in pairs(enemies) do
        local targetPart = player.Character:FindFirstChild(CONFIG.TARGET_PART)
        if targetPart then
            local distance = getDistance(CAMERA.CFrame.Position, targetPart.Position)
            
            -- Check if within visual range
            if distance <= CONFIG.CHECK_DISTANCE and isInFOV(targetPart.Position) then
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

--- Aim at the target
local function aimAtTarget(target)
    if not target or not target.Character then
        TARGET = nil
        return
    end
    
    local targetPart = target.Character:FindFirstChild(CONFIG.TARGET_PART)
    if not targetPart then return end
    
    local targetPosition = targetPart.Position
    local cameraPosition = CAMERA.CFrame.Position
    local direction = (targetPosition - cameraPosition).Unit
    
    -- Smooth aiming
    local newCFrame = CFrame.new(cameraPosition, cameraPosition + direction)
    CAMERA.CFrame = CAMERA.CFrame:Lerp(newCFrame, CONFIG.AIM_SMOOTHNESS)
end

--- Draw FOV circle on screen
local function drawFOV()
    if not CONFIG.SHOW_FOV then return end
    
    -- This is a simple visualization - for actual FOV circle you'd need ScreenGui
    -- This is just a placeholder for the concept
end

--- Toggle aimbot on/off
local function toggleAimbot()
    CONFIG.ENABLED = not CONFIG.ENABLED
    print("Aimbot " .. (CONFIG.ENABLED and "ENABLED" or "DISABLED"))
end

-- ============================================
-- INPUT HANDLING
-- ============================================

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == CONFIG.TOGGLE_KEY then
        toggleAimbot()
    end
end)

UserInputService.InputChanged:Connect(function(input, gameProcessed)
    if gameProcessed or not CONFIG.ENABLED then return end
    
    if input.KeyCode == CONFIG.AIM_KEY then
        -- Find and aim at target
        TARGET = getClosestEnemyInFOV()
        if TARGET then
            aimAtTarget(TARGET)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.KeyCode == CONFIG.AIM_KEY then
        TARGET = nil
    end
end)

-- ============================================
-- MAIN LOOP
-- ============================================

RunService.RenderStepped:Connect(function()
    if not CONFIG.ENABLED then return end
    
    -- If actively aiming, keep updating target
    if TARGET and TARGET.Character then
        aimAtTarget(TARGET)
    end
end)

-- ============================================
-- STATUS
-- ============================================

print("=== ROBLOX UNIVERSAL AIMBOT ===")
print("Toggle: " .. CONFIG.TOGGLE_KEY.Name)
print("Aim Key: " .. CONFIG.AIM_KEY.Name)
print("FOV Size: " .. CONFIG.FOV_SIZE)
print("Target Part: " .. CONFIG.TARGET_PART)
print("=====================================")

return CONFIG
