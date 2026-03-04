local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
-- Script is for testing stuff only.

local DefaultClass = require(ServerScriptService.Server.Classes.Enemies.Default)

local enemy = DefaultClass.new({Name = "Rig", Template = workspace.Fighter})
local baked = enemy.precomputeWaypoints(workspace.EnemyWaypoints:GetChildren())
enemy:SetPath(baked)
task.wait(5)
RunService.Heartbeat:Connect(function(dt)
    if enemy.finished then
        enemy:Destroy()
    else
        enemy:Step(dt)
    end
end)