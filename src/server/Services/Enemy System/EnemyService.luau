local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Knit = require(ReplicatedStorage.Packages.Knit)

local EnemiesData = require(ReplicatedStorage.Shared.EnemiesData)

local EnemyClasses = ServerScriptService.Server.Classes.Enemies
local DefaultEnemy = require(EnemyClasses.Default)

local WaypointsFolder = workspace.Waypoints
local start = WaypointsFolder.Start
local waypoints = WaypointsFolder.EnemyWaypoints:GetChildren()

local EnemyService = Knit.CreateService({
    Name = "EnemyService",
    Client = {}
})

function EnemyService:SpawnEnemy(enemyName: string)
    local EnemyClassModule = EnemyClasses:FindFirstChild(enemyName)
    local EnemyClass
    if EnemyClassModule then
        EnemyClass = require(EnemyClassModule)
    else
        EnemyClass = DefaultEnemy
    end

    local EnemyData = EnemiesData[enemyName] 
    if not EnemyData then
        warn(`{enemyName} is not in enemies data`)
        return
    end

    local enemy = EnemyClass.new({
        Name = enemyName,
        Template = EnemyData.Template,
        Speed = EnemyData.Speed,
    })

    enemy.Model:PivotTo(CFrame.new(start.Position))
    task.spawn(function()
        enemy:MoveToWaypoints(waypoints)
    end)
end

return EnemyService