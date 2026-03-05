local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local TowerInstancesService = Knit.CreateService{
    Name = "TowerInstancesService",
    Client = {}
}

function TowerInstancesService:KnitInit()
    self.instances = {}
    self.towerId = 1
end

function TowerInstancesService:AddTowerInstance(tower)
    local id = self:GetNewTowerId(tower)
    self.instances[id] = tower
end

function TowerInstancesService:RemoveTowerInstance(id: number)
    self.instances[id] = nil
end

function TowerInstancesService.Client:GetTowerInstance(plr: Player, id: number)
    local tower = TowerInstancesService:GetTowerInstance(id)
    print(tower)
    return tower
end

function TowerInstancesService:GetTowerInstance(id: number)
    return self.instances[id]
end

function TowerInstancesService:GetNewTowerId(tower)
    local id = self.towerId
    self.towerId += 1
    tower.Model:SetAttribute("ID", id)

    return id
end

return TowerInstancesService