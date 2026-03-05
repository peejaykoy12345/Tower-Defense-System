local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local TowerData = require(ReplicatedStorage.Shared.TowerData)

local TowerUpgradeService = Knit.CreateService{
    Name = "TowerUpgradeService",
    Client = {}
}

function TowerUpgradeService:KnitStart()
    self.TowerInstancesService = Knit.GetService("TowerInstancesService")
end

function TowerUpgradeService.Client:RequestUpgrade(plr: Player, id)
    local tower = TowerUpgradeService.TowerInstancesService:GetTowerInstance(id)
    print(tower)
    if not tower then return end

    local data = TowerData[tower.Name]
    if not data then
        warn(`{tower.Name} is not in TowerData`)
        return false
    end

    print("Hi test")

    if data[tower.Level + 1] then
        print("Hi")
        TowerUpgradeService:Upgrade(tower)

        return true
    end

    return false
end

function TowerUpgradeService:Upgrade(tower)
    tower:Upgrade()
end

return TowerUpgradeService