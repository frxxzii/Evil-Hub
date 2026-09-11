-- ============================================
-- EVIL HUB - TELEPORT MODULE
-- ============================================
-- Teleportation features including player teleport, coordinate teleport, and waypoint system

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local PLAYER = Players.LocalPlayer
local CHARACTER = PLAYER.Character or PLAYER.CharacterAdded:Wait()

-- ============================================
-- TELEPORT CONFIG
-- ============================================
local TELEPORT = {
    ENABLED = false,
    WAYPOINTS = {},
    SPEED = 50,
}

-- ============================================
-- TELEPORT FUNCTIONS
-- ============================================

local function teleportToPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then
        return "Player not found"
    end
    
    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    local playerRoot = CHARACTER:FindFirstChild("HumanoidRootPart")
    
    if not targetRoot or not playerRoot then
        return "Missing HumanoidRootPart"
    end
    
    playerRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0)
    return "Teleported to " .. targetPlayer.Name
end

local function teleportToCoordinates(x, y, z)
    local playerRoot = CHARACTER:FindFirstChild("HumanoidRootPart")
    
    if not playerRoot then
        return "Missing HumanoidRootPart"
    end
    
    playerRoot.CFrame = CFrame.new(x, y, z)
    return "Teleported to " .. x .. ", " .. y .. ", " .. z
end

local function addWaypoint(name, x, y, z)
    TELEPORT.WAYPOINTS[name] = {x = x, y = y, z = z}
    return "Waypoint '" .. name .. "' saved"
end

local function teleportToWaypoint(name)
    if not TELEPORT.WAYPOINTS[name] then
        return "Waypoint not found"
    end
    
    local waypoint = TELEPORT.WAYPOINTS[name]
    return teleportToCoordinates(waypoint.x, waypoint.y, waypoint.z)
end

local function getWaypoints()
    local waypointList = {}
    for name, _ in pairs(TELEPORT.WAYPOINTS) do
        table.insert(waypointList, name)
    end
    return waypointList
end

local function deleteWaypoint(name)
    if not TELEPORT.WAYPOINTS[name] then
        return "Waypoint not found"
    end
    TELEPORT.WAYPOINTS[name] = nil
    return "Waypoint '" .. name .. "' deleted"
end

-- ============================================
-- PUBLIC API
-- ============================================

local TeleportModule = {}

function TeleportModule:TeleportToPlayer(playerName)
    local targetPlayer = Players:FindFirstChild(playerName)
    return teleportToPlayer(targetPlayer)
end

function TeleportModule:TeleportToCoordinates(x, y, z)
    return teleportToCoordinates(x, y, z)
end

function TeleportModule:AddWaypoint(name, x, y, z)
    return addWaypoint(name, x, y, z)
end

function TeleportModule:TeleportToWaypoint(name)
    return teleportToWaypoint(name)
end

function TeleportModule:GetWaypoints()
    return getWaypoints()
end

function TeleportModule:DeleteWaypoint(name)
    return deleteWaypoint(name)
end

function TeleportModule:GetCurrentPosition()
    local root = CHARACTER:FindFirstChild("HumanoidRootPart")
    if root then
        return {x = root.Position.X, y = root.Position.Y, z = root.Position.Z}
    end
    return nil
end

return TeleportModule
