local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Knit = require(ReplicatedStorage.Packages.Knit)

local TowerData = require(ReplicatedStorage.Shared.TowerData)

local TowerInfoController = Knit.CreateController{
    Name = "TowerInfoController"
}

local plr = Players.LocalPlayer

function TowerInfoController:KnitInit()
    self.ScreenGUI = plr:WaitForChild("PlayerGui"):WaitForChild("SharedGUI"):WaitForChild("TowerInfoGui")
    self.MainFrame = self.ScreenGUI.TowerInfoFrame

    self.ScreenGUI.Close.Activated:Connect(function()
        self:Close()
    end)
end

function TowerInfoController:KnitStart()
    self.TowerUpgradeService = Knit.GetService("TowerUpgradeService")
    self.TowerInstancesService = Knit.GetService("TowerInstancesService")
    self.MainFrame.UpgradeButton.Activated:Connect(function()
        if not self.currentTower then return end

        local _, success = self.TowerUpgradeService:RequestUpgrade(self.currentTower.Model:GetAttribute("ID")):await()
        if not success then return end

        local data = TowerData[self.currentTower.Name]
        if not data then 
            warn(`{self.currentTower.Name} is not in tower data`)
            return
        end
        
        local success, newTower = self.TowerInstancesService:GetTowerInstance(self.currentTower.Model:GetAttribute("ID")):await()
        if not success or not newTower then return end
        
        self:UpdateGUI(newTower, data[newTower.Level])
    end)
end

function TowerInfoController:OpenGui(tower)
    self.currentTower = tower
    local towerName = tower.Name

    local data = TowerData[towerName]
    if not data then 
        warn(`{towerName} is not in tower data`)
        return
    end

    self.MainFrame.Visible = true

    local levelData = data[tower.Level]
    self:UpdateGUI(tower, levelData)
end

function TowerInfoController:UpdateGUI(tower, data)
    self.MainFrame.TowerNameRow.TowerNameValue.Text = tower.Name
    self.MainFrame.AttackRangeRow.AttackRangeValue.Text = tostring(data.RANGE_RADIUS)
    self.MainFrame.DamageRow.DamageValue.Text = tostring(data.DAMAGE)
    self.MainFrame.CooldownRow.CooldownValue.Text = tostring(data.ATTACK_COOLDOWN)
end

function TowerInfoController:Close()
    self.currentTower = nil
    self.MainFrame.Visible = false
end

return TowerInfoController