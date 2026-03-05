local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TowerData = require(ReplicatedStorage.Shared.TowerData)

local Enemies = workspace.Enemies

local Default = {}
Default.__index = Default

type params = {
    Name: string,
    CFrame: CFrame,
}

function Default.new(params: params)
    local data = TowerData[params.Name]
    if not data then
        warn(`{params.Name} is not in TowerData`)
        return
    end

    local self = setmetatable({}, Default)
    self.Name = params.Name
    self.Model = data.Model:Clone()
    self.Model:PivotTo(params.CFrame)
    self.Model.Parent = workspace.Towers

    self.data = data
    self.Level = 1
    self:SetStats()

    self.Attacking = true
    self.hrp = self.Model.HumanoidRootPart

    return self
end

function Default:StartAttacking()
    self.coroutine = coroutine.create(function()
        while self.Attacking do
            self:Attack()
            task.wait(self.AttackCooldown)
        end
    end)

    coroutine.resume(self.coroutine)
end

function Default:Attack()
    local targets = self:GetEnemies()
    if #targets <= 0 then return end

    local targetHumanoid = targets[1].Humanoid
    local targetRoot = targets[1]:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end

    self.hrp.CFrame = CFrame.new(self.hrp.Position, Vector3.new(targetRoot.Position.X, self.hrp.Position.Y, targetRoot.Position.Z)) 

    targetHumanoid:TakeDamage(self.Damage)
end

function Default:GetEnemies()
    local targets = {}

    for _, enemy in ipairs(Enemies:GetChildren()) do
        if (enemy.HumanoidRootPart.Position - self.hrp.Position).Magnitude <= self.Range then
            table.insert(targets, enemy)
        end
    end

    return targets
end

function Default:Upgrade()
    self.Level += 1
    self:SetStats()
end

function Default:SetStats()
    local data = self.data

    self.Range = data[self.Level].RANGE_RADIUS
    self.AttackCooldown = data[self.Level].ATTACK_COOLDOWN
    self.Damage = data[self.Level].DAMAGE

    print("SetStats")
end

return Default