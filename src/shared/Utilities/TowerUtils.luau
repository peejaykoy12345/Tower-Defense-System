local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TowerData = ReplicatedStorage.Shared.TowerData

local TowerUtils = {}

function TowerUtils:CanPlaceTower(towerName: string, cf: CFrame): boolean
    return true
end

return TowerUtils