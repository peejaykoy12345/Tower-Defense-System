local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RaycastHelper = require(ReplicatedStorage.Packages.RaycastHelper)

local TableUtils = require(script.Parent.TableUtils)
local TowerData = require(ReplicatedStorage.Shared.TowerData)

local TowersFolder = workspace.Towers

local TowerUtils = {}

local DEFAULT_DISTANCE_REQUIREMENT_FOR_TOWERS = 5

function TowerUtils:CanPlaceTower(towerName: string, cf: CFrame, ignoreList: {Instance}?): boolean
    local pos = cf.Position + Vector3.new(0, 1, 0) -- Some offset so that the raycast doesn't raycast go through the floor.

    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = ignoreList or {}
    local result = RaycastHelper.raycast({
        origin = pos,
        direction = Vector3.new(0, -4, 0),
        rayParams = rayParams
    })

    if not result or not result.Instance or result.Instance.Name ~= "TowerPlaceable" then
        return false
    end

    for _, tower in ipairs(TowersFolder:GetChildren()) do
        local distanceRequirementForTower = tower:GetAttribute("Distance Requirement For Tower") or DEFAULT_DISTANCE_REQUIREMENT_FOR_TOWERS

        local distance = (tower:GetPivot().Position - pos).Magnitude
        if distance < distanceRequirementForTower then 
            return false 
        end
    end

    return true
end

return TowerUtils