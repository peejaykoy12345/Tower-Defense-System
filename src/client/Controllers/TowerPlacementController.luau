local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local GoodSignal = require(ReplicatedStorage.Packages.GoodSignal)
local RaycastHelper = require(ReplicatedStorage.Packages.RaycastHelper)

local UtilitiesFolder = ReplicatedStorage.Shared.Utilities
local ModelUtils = require(UtilitiesFolder.ModelUtils)
local TowerUtils = require(UtilitiesFolder.TowerUtils)


local TowerPlacementController = Knit.CreateController {
    Name = "TowerPlacementController"
}

local plr = Players.LocalPlayer
local cam = workspace.CurrentCamera

local uisConnection: RBXScriptSignal?
local heartbeatConnection: RBXScriptSignal?
local currentTowerModel: Model?

function TowerPlacementController:KnitStart()
    self.TowerPlacementService = Knit.GetService("TowerPlacementService")
    self.TowerInfoController = Knit.GetController("TowerInfoController")
end

function TowerPlacementController:PreviewTower(template: Model)
    local TowerModel = template:Clone()
    
    -- Torso can collide is being set to true by humanoid. 
    -- So we have to make it false everytime.
    local torso = TowerModel:FindFirstChild("Torso")
    if torso then
        local hum = TowerModel.Humanoid
        hum.StateChanged:Connect(function()
            torso.CanCollide = false
        end)
    end

    self.currentRotation = CFrame.Angles(0, math.rad(0), 0)

    ModelUtils:SetPartsCanCollide(TowerModel:GetChildren(), false)
    TowerModel.Parent = workspace

    ModelUtils:SetPartsTransparency(TowerModel:GetChildren(), 0.4, {TowerModel.HumanoidRootPart})

    self:ConnectUserInputService()

    currentTowerModel = TowerModel

    heartbeatConnection = RunService.Heartbeat:Connect(function()
        local mouseX, mouseY = plr:GetMouse().X, plr:GetMouse().Y
        local ray = cam:ScreenPointToRay(mouseX, mouseY)

        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        raycastParams.FilterDescendantsInstances = {plr.Character, TowerModel} 

        local result = RaycastHelper.raycast({
            origin = ray.Origin,
            direction = ray.Direction * 1000,
            rayParams = raycastParams
        })

        if not result then return end

        local worldPos = result.Position

        TowerModel:PivotTo(CFrame.new(worldPos) * self.currentRotation)

        local towerName, cf = self:GetTowerNameAndCFrame()
        if not TowerUtils:CanPlaceTower(towerName, cf) then 
            ModelUtils:SetPartsColor(currentTowerModel:GetChildren(), Color3.fromRGB(150, 0, 0))
        else
            ModelUtils:SetPartsColor(currentTowerModel:GetChildren(), Color3.fromRGB(0, 150, 0))
        end
    end)
end

function TowerPlacementController:GetTowerNameAndCFrame()
    local towerName = currentTowerModel.Name
    local cf = currentTowerModel:GetPivot()

    return towerName, cf
end

function TowerPlacementController:ConnectUserInputService()
    uisConnection = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent then return end

        if input.KeyCode == Enum.KeyCode.R then
            self:RotatePreviewTower()
        end

        if input.UserInputType == Enum.UserInputType.MouseButton1 and currentTowerModel then
            local towerName, cf = self:GetTowerNameAndCFrame()
            if not TowerUtils:CanPlaceTower(towerName, cf) then return end

            local _, tower = self.TowerPlacementService:RequestPlaceTower(towerName, cf, {currentTowerModel}):await()
            if tower then
                local ClickDetector = Instance.new("ClickDetector")
                ClickDetector.Parent = tower.Model

                ClickDetector.MouseClick:Connect(function()
                    self.TowerInfoController:OpenGui(tower)
                end)
            end
        end
    end)
end


function TowerPlacementController:RotatePreviewTower()
    if not currentTowerModel then return end  

    local rotationIncrement = CFrame.Angles(0, math.rad(45), 0)
    self.currentRotation *= rotationIncrement
end

function TowerPlacementController:UnpreviewTower()
    if currentTowerModel then
        currentTowerModel:Destroy()
        currentTowerModel = nil
    end

    if heartbeatConnection then
        heartbeatConnection:Disconnect()
        heartbeatConnection = nil
    end

    if uisConnection then
        uisConnection:Disconnect()
        uisConnection = nil
    end
end

return TowerPlacementController