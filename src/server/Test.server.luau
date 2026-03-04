local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
-- Script is for testing stuff only.

local DefaultClass = require(ServerScriptService.Server.Classes.Enemies.Default)

local enemy = DefaultClass.new({Name = "Rig", Template = ReplicatedStorage.Fighter})
task.wait(5)

local waypoints = workspace.EnemyWaypoints:GetChildren()

enemy:MoveTo(waypoints)