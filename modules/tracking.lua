-- ============================================
-- EVIL HUB - TRACKING SYSTEM
-- ============================================
-- Complete tracking system for aim and tool tracking

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local PLAYER = Players.LocalPlayer
local CAMERA = workspace.CurrentCamera

-- ============================================
-- TRACKING CONFIG
-- ============================================
local TRACKING = {
    ENABLED = false,
    AIM_TRACKING_ENABLED = false,
    TOOL_TRACKING_ENABLED = false,
    
    -- Aim Tracking Data
    AIM_TRACKS = {},
    CURRENT_AIM_TARGET = nil,
    AIM_HISTORY = {},
    MAX_HISTORY = 30,
    
    -- Tool Tracking Data
    TOOL_TRACKS = {},
    CURRENT_TOOL_TARGET = nil,
    TOOL_HISTORY = {},
    
    -- Accuracy Stats
    ACCURACY_DATA = {
        shots_fired = 0,
        shots_hit = 0,
        accuracy_percentage = 0,
    },
    
    -- Velocity Tracking
    VELOCITY_DATA = {},
}

-- ============================================
-- AIM TRACKING FUNCTIONS
-- ============================================

local function recordAimTrack(targetPlayer, targetPart, distance, hitOrMiss)
    if not targetPlayer or not targetPart then return end
    
    local track = {
        player = targetPlayer.Name,
        targetPart = targetPart.Name,
        distance = distance,
        timestamp = tick(),
        hit = hitOrMiss,
        position = targetPart.Position,
        cameraPosition = CAMERA.CFrame.Position,
    }
    
    table.insert(TRACKING.AIM_HISTORY, track)
    
    -- Keep history manageable
    if #TRACKING.AIM_HISTORY > TRACKING.MAX_HISTORY then
        table.remove(TRACKING.AIM_HISTORY, 1)
    end
    
    -- Update accuracy
    TRACKING.ACCURACY_DATA.shots_fired = TRACKING.ACCURACY_DATA.shots_fired + 1
    if hitOrMiss then
        TRACKING.ACCURACY_DATA.shots_hit = TRACKING.ACCURACY_DATA.shots_hit + 1
    end
    
    TRACKING.ACCURACY_DATA.accuracy_percentage = 
        (TRACKING.ACCURACY_DATA.shots_hit / TRACKING.ACCURACY_DATA.shots_fired) * 100
end

local function getAimStats()
    return {
        shots_fired = TRACKING.ACCURACY_DATA.shots_fired,
        shots_hit = TRACKING.ACCURACY_DATA.shots_hit,
        accuracy = string.format("%.2f%%", TRACKING.ACCURACY_DATA.accuracy_percentage),
        total_tracks = #TRACKING.AIM_HISTORY,
    }
end

local function getAimTrackingData()
    local stats = {}
    for player, tracks in pairs(TRACKING.AIM_TRACKS) do
        stats[player] = {
            total_shots = tracks.shots or 0,
            total_hits = tracks.hits or 0,
            accuracy = tracks.accuracy or 0,
            last_distance = tracks.last_distance or 0,
            avg_distance = tracks.avg_distance or 0,
        }
    end
    return stats
end

local function calculateAimingAccuracy(targetPlayer)
    if not targetPlayer or not TRACKING.AIM_TRACKS[targetPlayer.Name] then
        return 0
    end
    
    local playerData = TRACKING.AIM_TRACKS[targetPlayer.Name]
    if playerData.shots == 0 then return 0 end
    
    return (playerData.hits / playerData.shots) * 100
end

-- ============================================
-- TOOL TRACKING FUNCTIONS
-- ============================================

local function trackToolUsage(player, tool, action)
    if not player or not tool then return end
    
    local toolTrack = {
        player = player.Name,
        tool = tool.Name,
        action = action, -- "equipped", "fired", "unequipped"
        timestamp = tick(),
        position = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and 
                   player.Character.HumanoidRootPart.Position or Vector3.new(0, 0, 0),
    }
    
    table.insert(TRACKING.TOOL_HISTORY, toolTrack)
    
    if #TRACKING.TOOL_HISTORY > TRACKING.MAX_HISTORY then
        table.remove(TRACKING.TOOL_HISTORY, 1)
    end
    
    -- Track tool statistics
    if not TRACKING.TOOL_TRACKS[player.Name] then
        TRACKING.TOOL_TRACKS[player.Name] = {}
    end
    
    local playerTools = TRACKING.TOOL_TRACKS[player.Name]
    if not playerTools[tool.Name] then
        playerTools[tool.Name] = {
            equipped_times = 0,
            fired_times = 0,
            unequipped_times = 0,
        }
    end
    
    if action == "equipped" then
        playerTools[tool.Name].equipped_times = playerTools[tool.Name].equipped_times + 1
    elseif action == "fired" then
        playerTools[tool.Name].fired_times = playerTools[tool.Name].fired_times + 1
    elseif action == "unequipped" then
        playerTools[tool.Name].unequipped_times = playerTools[tool.Name].unequipped_times + 1
    end
end

local function getToolTrackingData()
    return TRACKING.TOOL_TRACKS
end

local function getToolHistory(playerName, limit)
    limit = limit or 10
    local history = {}
    local count = 0
    
    for i = #TRACKING.TOOL_HISTORY, 1, -1 do
        if TRACKING.TOOL_HISTORY[i].player == playerName and count < limit then
            table.insert(history, 1, TRACKING.TOOL_HISTORY[i])
            count = count + 1
        end
    end
    
    return history
end

-- ============================================
-- VELOCITY TRACKING
-- ============================================

local function trackPlayerVelocity(player)
    if not player or not player.Character then return end
    
    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    if not TRACKING.VELOCITY_DATA[player.Name] then
        TRACKING.VELOCITY_DATA[player.Name] = {
            lastPosition = rootPart.Position,
            lastTime = tick(),
            velocity = Vector3.new(0, 0, 0),
            speed = 0,
        }
    end
    
    local data = TRACKING.VELOCITY_DATA[player.Name]
    local currentTime = tick()
    local deltaTime = currentTime - data.lastTime
    
    if deltaTime > 0 then
        data.velocity = (rootPart.Position - data.lastPosition) / deltaTime
        data.speed = data.velocity.Magnitude
        data.lastPosition = rootPart.Position
        data.lastTime = currentTime
    end
    
    return data
end

local function getPlayerVelocity(playerName)
    return TRACKING.VELOCITY_DATA[playerName] or {speed = 0, velocity = Vector3.new(0, 0, 0)}
end

-- ============================================
-- COMPREHENSIVE TRACKING STATS
-- ============================================

local function getComprehensiveStats(playerName)
    local stats = {
        aim_stats = {},
        tool_stats = {},
        velocity = {},
        position = {},
    }
    
    -- Aim stats
    if TRACKING.AIM_TRACKS[playerName] then
        stats.aim_stats = {
            shots = TRACKING.AIM_TRACKS[playerName].shots or 0,
            hits = TRACKING.AIM_TRACKS[playerName].hits or 0,
            accuracy = string.format("%.2f%%", calculateAimingAccuracy(
                Players:FindFirstChild(playerName)
            )),
        }
    end
    
    -- Tool stats
    if TRACKING.TOOL_TRACKS[playerName] then
        stats.tool_stats = TRACKING.TOOL_TRACKS[playerName]
    end
    
    -- Velocity
    if TRACKING.VELOCITY_DATA[playerName] then
        local vel = TRACKING.VELOCITY_DATA[playerName]
        stats.velocity = {
            speed = string.format("%.2f", vel.speed),
            x = string.format("%.2f", vel.velocity.X),
            y = string.format("%.2f", vel.velocity.Y),
            z = string.format("%.2f", vel.velocity.Z),
        }
    end
    
    -- Position
    local player = Players:FindFirstChild(playerName)
    if player and player.Character then
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        if root then
            stats.position = {
                x = string.format("%.2f", root.Position.X),
                y = string.format("%.2f", root.Position.Y),
                z = string.format("%.2f", root.Position.Z),
            }
        end
    end
    
    return stats
end

local function getAllTrackingData()
    local allData = {}
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= PLAYER then
            allData[player.Name] = getComprehensiveStats(player.Name)
        end
    end
    
    return allData
end

-- ============================================
-- AUTO TRACKING LOOP
-- ============================================

RunService.RenderStepped:Connect(function()
    if not TRACKING.ENABLED then return end
    
    -- Track all players
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= PLAYER and player.Character then
            trackPlayerVelocity(player)
        end
    end
end)

-- ============================================
-- PUBLIC API
-- ============================================

local TrackingModule = {}

function TrackingModule:EnableTracking()
    TRACKING.ENABLED = true
    return "Tracking Enabled"
end

function TrackingModule:DisableTracking()
    TRACKING.ENABLED = false
    return "Tracking Disabled"
end

function TrackingModule:RecordAimTrack(targetPlayer, targetPart, distance, hit)
    recordAimTrack(targetPlayer, targetPart, distance, hit)
    return "Aim track recorded"
end

function TrackingModule:GetAimStats()
    return getAimStats()
end

function TrackingModule:GetAimTrackingData()
    return getAimTrackingData()
end

function TrackingModule:TrackToolUsage(player, tool, action)
    trackToolUsage(player, tool, action)
    return "Tool usage tracked"
end

function TrackingModule:GetToolTrackingData()
    return getToolTrackingData()
end

function TrackingModule:GetToolHistory(playerName, limit)
    return getToolHistory(playerName, limit)
end

function TrackingModule:GetPlayerVelocity(playerName)
    return getPlayerVelocity(playerName)
end

function TrackingModule:GetComprehensiveStats(playerName)
    return getComprehensiveStats(playerName)
end

function TrackingModule:GetAllTrackingData()
    return getAllTrackingData()
end

function TrackingModule:GetAimHistory()
    return TRACKING.AIM_HISTORY
end

function TrackingModule:ResetStats()
    TRACKING.ACCURACY_DATA = {
        shots_fired = 0,
        shots_hit = 0,
        accuracy_percentage = 0,
    }
    TRACKING.AIM_HISTORY = {}
    TRACKING.TOOL_HISTORY = {}
    return "Stats reset"
end

return TrackingModule
