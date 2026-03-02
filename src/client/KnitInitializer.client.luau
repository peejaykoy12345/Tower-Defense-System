local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

Knit.AddControllersDeep(ReplicatedStorage.UI)
Knit.AddControllersDeep(script.Parent.Controllers)

Knit.Start():andThen(function()
    print("Knit started on Client!")
end):catch(warn)