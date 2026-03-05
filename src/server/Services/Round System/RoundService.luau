local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Knit = require(ReplicatedStorage.Packages.Knit)

local RoundData = require(ReplicatedStorage.Shared.RoundData)

local RoundService = Knit.CreateService({
    Name = "RoundService",
    Client = {},
})

function RoundService:KnitInit()
    self.enemyId = 1
    self.round = 1
    self.enemies = {}

    self.waypoints = workspace.Waypoints.EnemyWaypoints:GetChildren()
end

function RoundService:KnitStart()
    self.EnemyService = Knit.GetService("EnemyService")
    self:SpawnRoundEnemies()

     RunService.Heartbeat:Connect(function()
        for id, enemy in pairs(self.enemies) do
            if enemy.finished then 
                self.enemies[id] = nil
                continue 
            end

            enemy:Update(self.waypoints)
        end
    end)
end

function RoundService:SpawnRoundEnemies()
    local data = RoundData[self.round]

    self.spawningCoroutine = coroutine.create(function()
        for _, enemyRoundData in ipairs(data) do
            local enemyName = enemyRoundData.Name
            local delayPerSpawn = enemyRoundData.DelayPerSpawn
            local count = enemyRoundData.Count
            for i = 1, count do
                local enemy = self.EnemyService:SpawnEnemy(enemyName)
                enemy:MoveToWaypoints(self.waypoints)
                local id = self:GiveEnemyId(enemy)
                self.enemies[id] = enemy
                task.wait(delayPerSpawn)
            end
        end
    end)

    coroutine.resume(self.spawningCoroutine)
end

function RoundService:GiveEnemyId(enemy)
    local id = self.enemyId
    enemy.Model:SetAttribute("ID", id)
    self.enemyId += 1
    
    if self.enemyId > 10000 then
        self.enemyId = 1
    end
    
    return id
end

return RoundService