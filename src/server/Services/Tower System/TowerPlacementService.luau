local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local TowerUtils = require(ReplicatedStorage.Shared.Utilities.TowerUtils)
local TowerData = require(ReplicatedStorage.Shared.TowerData)

local TowerClasses = ServerScriptService.Server.Classes.Towers
local DefaultTowerClass = require(TowerClasses.Default)

local TowerPlacementService = Knit.CreateService {
    Name = "TowerPlacementService",
    Client = {}
}

function TowerPlacementService:KnitStart()
    self.TowerInstancesService = Knit.GetService("TowerInstancesService")
end


function TowerPlacementService.Client:RequestPlaceTower(plr: Player, towerName: string, cf: CFrame): boolean
    if not TowerUtils:CanPlaceTower(towerName, cf) then return false end

    local tower = TowerPlacementService:PlaceTower(towerName, cf)

    return tower
end

function TowerPlacementService:PlaceTower(towerName: string, cf: CFrame)
    local towerData = TowerData[towerName]
    if not towerData then 
        warn(`{towerName} is not in TowerData`)
        return
    end

    local ClassModule = TowerClasses:FindFirstChild(towerName)
    local Class
    if ClassModule then
        Class = require(ClassModule)
    else
        Class = DefaultTowerClass
    end

    local tower = Class.new({Name = towerName, CFrame = cf,})
    self.TowerInstancesService:AddTowerInstance(tower)
    tower:StartAttacking()

    return tower
end

return TowerPlacementService