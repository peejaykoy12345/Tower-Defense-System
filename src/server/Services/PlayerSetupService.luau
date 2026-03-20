local PhysicsService = game:GetService("PhysicsService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local ModelUtils = require(ReplicatedStorage.Shared.Utilities.ModelUtils)

local PlayerSetupService = Knit.CreateService{
    Name = "PlayerSetupService",
    Client = {}
}

function PlayerSetupService:KnitInit()
    Players.PlayerAdded:Connect(function(plr)
        plr.CharacterAdded:Connect(function(char)
            ModelUtils:SetCharacterCollisionGroup(char, "Player")
        end)
    end)
end

return PlayerSetupService