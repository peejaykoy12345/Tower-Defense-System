local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local RaycastHelper = require(ReplicatedStorage.Packages.RaycastHelper)

local ModelUtils = require(ReplicatedStorage.Shared.Utilities.ModelUtils)

local TowerPlacementController = Knit.CreateController {
    Name = "TowerPlacementController"
}

local plr = Players.LocalPlayer
local cam = workspace.CurrentCamera

local heartbeatConnection: RBXScriptSignal?
local currentTowerModel: Model?

function TowerPlacementController:PreviewTower(template: Model)
    local TowerModel = template:Clone()
    
    -- Torso can collide is being set to true by humanoid. 
    -- So we have to make it false everytime.
    local torso = TowerModel:FindFirstChild("Torso")
    if torso then
        local hum = TowerModel.Humanoid
        hum.StateChanged:Connect(function(old, new)
            torso.CanCollide = false
        end)
    end

    ModelUtils:SetPartsCanCollide(TowerModel:GetChildren(), false)
    TowerModel.Parent = workspace

    ModelUtils:SetPartsTransparency(TowerModel:GetChildren(), 0.4, {TowerModel.HumanoidRootPart})

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

        TowerModel:PivotTo(CFrame.new(worldPos))
    end)
end

function TowerPlacementController:UnpreviewTower()
    if currentTowerModel then
        currentTowerModel:Destroy()
    end

    if heartbeatConnection then
        heartbeatConnection:Disconnect()
    end
end

return TowerPlacementController