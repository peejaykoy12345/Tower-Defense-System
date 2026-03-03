local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RaycastHelper = require(ReplicatedStorage.Packages.RaycastHelper)

local TowerData = ReplicatedStorage.Shared.TowerData

local TowerUtils = {}

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

    if result and result.Instance and result.Instance.Name == "TowerPlaceable" then
        return true
    end

    return false
end

return TowerUtils