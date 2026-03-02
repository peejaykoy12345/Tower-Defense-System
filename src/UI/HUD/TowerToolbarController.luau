local UserInputService = game:GetService("UserInputService")
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

local validSlotKeys = {
    [Enum.KeyCode.One] = "1",
    [Enum.KeyCode.Two] = "2",
    [Enum.KeyCode.Three] = "3",
    [Enum.KeyCode.Four] = "4",
    [Enum.KeyCode.Five] = "5",
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

    local TowerPlacementController = Knit.GetController("TowerPlacementController")

    local function handleUnequip(slot: Frame)
        self:ChangeSlotColor(slot, false)
        TowerPlacementController:UnpreviewTower()
        equippedSlot = nil
    end

    local function HandleEquipUnequip(slot: Frame)
        if equippedSlot == slot then
            handleUnequip(slot)
        else
            self:ChangeSlotColor(slot, true)
            if equippedSlot then
                handleUnequip(slot)
            end

            local towerName = slot.TextButton.TowerName.Text

            local towerData = TowerData[towerName]
            if not towerData then 
                warn(`{towerName} is not in TowerData`)
                return
            end

            TowerPlacementController:PreviewTower(towerData[1].Model)
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
    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent then return end

        local slotNumber = validSlotKeys[input.KeyCode]
        if not slotNumber then return end

        local slot = Container:FindFirstChild(slotNumber)
        if not slot then
            warn(`{slotNumber} button doesn't exist`)
            return
        end

        HandleEquipUnequip(slot)
    end)
end

return TowerToolbarController