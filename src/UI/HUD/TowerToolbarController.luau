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

function TowerToolbarController:ChangeSlotColor(slot: Frame, equipped: boolean)
    local TowerName: TextLabel = slot.TextButton.TowerName
    if equipped then
        TowerName.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        TowerName.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end

function TowerToolbarController:KnitStart()
    local TowerToolbarScreenGUI = plr.PlayerGui:WaitForChild("SharedGUI"):WaitForChild("TowerToolbar")
    local Container = TowerToolbarScreenGUI.Frame

    local equippedSlot: Frame?

    local function HandleEquipUnequip(slot: Frame)
        if equippedSlot == slot then
            self:ChangeSlotColor(slot, false)
        else
            self:ChangeSlotColor(slot, true)
            if equippedSlot then
                self:ChangeSlotColor(equippedSlot, false)
            end

            equippedSlot = slot
        end
    end

    for i, towerName in ipairs(data) do
        local slot = Container:FindFirstChild(i)
        if not slot then
            warn(`{i} button doesn't exist`)
            continue
        end

        local towerData = TowerData[towerName]
        if not towerData then 
            warn(`{towerName} is not in TowerData`)
            continue
        end

        local btn: TextButton = slot.TextButton
        local TowerName = btn.TowerName
        local TowerPrice = btn.TowerPrice

        TowerName.Text = towerName
        TowerPrice.Text = "$" .. tostring(towerData.PRICE)

        btn.Activated:Connect(function()
            print("Activated")
            HandleEquipUnequip(slot)
        end)
    end
end

return TowerToolbarController