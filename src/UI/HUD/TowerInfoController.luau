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
    self.MainFrame.UpgradeButton.Activated:Connect(function()
        if not self.currentTower then return end

        local _, success = self.TowerUpgradeService:RequestUpgrade(self.currentTower.Model:GetAttribute("ID")):await()
        if success then
            local data = TowerData[self.currentTower.Name]
            if not data then 
                warn(`{self.currentTower.Name} is not in tower data`)
                return
            end
            self:UpdateGUI(self.currentTower, data[self.currentTower.Level])
        end
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

function TowerInfoController:UpdateGUI(tower, levelData)
    self.MainFrame.TowerNameRow.TowerNameValue.Text = tower.Name
    self.MainFrame.AttackRangeRow.AttackRangeValue.Text = tostring(levelData.RANGE_RADIUS)
    self.MainFrame.DamageRow.DamageValue.Text = tostring(levelData.DAMAGE)
    self.MainFrame.CooldownRow.CooldownValue.Text = tostring(levelData.ATTACK_COOLDOWN)
end

function TowerInfoController:Close()
    self.currentTower = nil
    self.MainFrame.Visible = false
end

return TowerInfoController