local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

Knit.AddServicesDeep(ServerScriptService.Server.Services)

Knit.Start():andThen(function()
    print("Knit started on Server!")
end):catch(warn)