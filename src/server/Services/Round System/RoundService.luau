local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local RoundData = require(ReplicatedStorage.Shared.RoundData)

local RoundService = Knit.CreateService({
    Name = "RoundService",
    Client = {},
})

function RoundService:KnitInit()
    self.round = 1
end

function RoundService:KnitStart()
    self.EnemyService = Knit.GetService("EnemyService")
    self:SpawnRoundEnemies()
end

function RoundService:SpawnRoundEnemies()
    local data = RoundData[self.round]

    self.spawningCoroutine = coroutine.create(function()
        for _, enemyRoundData in ipairs(data) do
            local enemyName = enemyRoundData.Name
            local delayPerSpawn = enemyRoundData.DelayPerSpawn
            local count = enemyRoundData.Count
            for i = 1, count do
                self.EnemyService:SpawnEnemy(enemyName)
                task.wait(delayPerSpawn)
            end
        end
    end)

    coroutine.resume(self.spawningCoroutine)
end

return RoundService