local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Knit = require(ReplicatedStorage.Packages.Knit)
local TowerData = require(ReplicatedStorage.Shared.TowerData)

local TowerToolbarController = Knit.CreateController {
    Name = "TowerToolbarController"
}

local data = {
    "Fighter",
    "Fighter",
    "Fighter",
    "Fighter",
    "Fighter"
}

local plr = Players.LocalPlayer

function TowerToolbarController:KnitStart()
    local TowerToolbarScreenGUI = plr.PlayerGui:WaitForChild("SharedGUI"):WaitForChild("TowerToolbar")
    local Container = TowerToolbarScreenGUI.Frame

    for i, towerName in ipairs(data) do
        local frame = Container:FindFirstChild(i)
        if not frame then
            warn(`{i} button doesn't exist`)
            continue
        end

        local towerData = TowerData[towerName]
        if not towerData then 
            warn(`{towerName} is not in TowerData`)
            continue
        end

        local btn = frame.TextButton
        local TowerName = btn.TowerName
        local TowerPrice = btn.TowerPrice

        TowerName.Text = towerName
        TowerPrice.Text = "$" .. tostring(towerData.PRICE)
    end
end

return TowerToolbarController