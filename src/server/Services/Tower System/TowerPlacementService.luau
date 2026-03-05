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

    local ClassModule = TowerClasses:FindFirstAncestor(towerName)
    local Class
    if ClassModule then
        Class = require(ClassModule)
    else
        Class = DefaultTowerClass
    end

    local tower = Class.new({Name = towerName, CFrame = cf,})
    tower:StartAttacking()
end

return TowerPlacementService