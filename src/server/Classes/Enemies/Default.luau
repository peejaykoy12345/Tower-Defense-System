local Base = workspace.Base

local Default = {}
Default.__index = Default

type enemyParams = {
    Name: string,
    Template: Model,
    Speed: number,
}

function Default.new(enemyParams: enemyParams)
    local self = setmetatable({}, Default)

    self.Name = enemyParams.Name
    self.Speed = enemyParams.Speed or 16
    self.Model = enemyParams.Template:Clone()
    self.Model.Parent = workspace.Enemies

    local hrp = self.Model.HumanoidRootPart

    self.hrp = hrp
    self.waypointIndex = 1
    self.finished = false

    self:_InitHumanoid()

    return self
end

-- Optimize the humanoid
function Default:_InitHumanoid()
    local humanoid = self.Model.Humanoid
    self.Humanoid = humanoid

    humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)

    humanoid.AutoRotate = false
end

function Default:MoveToWaypoints(waypoints: {BasePart})
    local bv: BodyVelocity = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e6, 0, 1e6)
    bv.Parent = self.hrp

    local bg: BodyGyro = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(0, 1e6, 0)
    bg.P = 3000
    bg.D = 500
    bg.Parent = self.hrp

    self.bv = bv
    self.bg = bg

    task.spawn(function()
        self:MoveToNext(waypoints)
    end)
end

function Default:MoveToNext(waypoints: {BasePart})
    if self.waypointIndex > #waypoints then
        self.finished = true
        self:DamageBase()
        self:Destroy()
        return
    end

    local part: BasePart = waypoints[self.waypointIndex]

    if not part or not part:IsA("BasePart") then
        warn("Invalid waypoint at index", self.waypointIndex)
        return
    end

    local targetPos: Vector3 = part.Position
    local direction: Vector3 = (targetPos - self.hrp.Position).Unit

    self.bv.Velocity = direction * self.Speed
    self.bg.CFrame = CFrame.lookAt(
        self.hrp.Position,
        Vector3.new(targetPos.X, self.hrp.Position.Y, targetPos.Z)
    )

    self.currentTargetPos = targetPos
    self.currentDirection = direction
end

function Default:Update(waypoints: {BasePart})
    if self.finished then return end
    if not self.currentTargetPos or not self.currentDirection then return end

    local toTarget = self.currentTargetPos - self.hrp.Position
    local ToTarget = Vector3.new(toTarget.X, 0, toTarget.Z)
    local Direction = Vector3.new(self.currentDirection.X, 0, self.currentDirection.Z)

    local dot = ToTarget:Dot(Direction)
    if dot <= 0 then
        self.waypointIndex += 1
        self:MoveToNext(waypoints)
    end
end

function Default:DamageBase()
    local damage = self.Model.Humanoid.Health

    Base.Health.Value = math.max(Base.Health.Value - damage, 0)
end

function Default:Destroy()
    self.active = false
    if self.Model then
        self.Model:Destroy()
    end
end

return Default