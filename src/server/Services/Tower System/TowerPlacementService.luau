local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local TowerUtils = require(ReplicatedStorage.Shared.Utilities.TowerUtils)
local TowerData = require(ReplicatedStorage.Shared.TowerData)

local TowerPlacementService = Knit.CreateService {
    Name = "TowerPlacementService",
    Client = {}
}

function TowerPlacementService.Client:RequestPlaceTower(plr: Player, towerName: string, cf: CFrame)
    if not TowerUtils:CanPlaceTower(towerName, cf) then return end

    TowerPlacementService:PlaceTower(towerName, cf)
end

function TowerPlacementService:PlaceTower(towerName: string, cf: CFrame)
    local towerData = TowerData[towerName]
    if not towerData then 
        warn(`{towerName} is not in TowerData`)
        return
    end

    local towerModel = towerData[1].Model:Clone()
    towerModel:PivotTo(cf)
    towerModel.Parent = workspace
end

return TowerPlacementService