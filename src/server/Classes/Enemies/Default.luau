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

    self.Humanoid = self.Model.Humanoid

    local hrp = self.Model.HumanoidRootPart

    self.hrp = hrp
    self.waypointIndex = 1
    self.finished = false

    return self
end

function Default:MoveToWaypoints(waypoints: {BasePart})
    
    self.Humanoid.WalkSpeed = self.Speed

    local function moveToNext()
        if self.waypointIndex > #waypoints then
            self.finished = true
            self:DamageBase()
            self:Destroy()
            return
        end

        local part = waypoints[self.waypointIndex]

        if not part or not part:IsA("BasePart") then
            warn("Invalid waypoint at index", self.waypointIndex)
            self.waypointIndex += 1
            moveToNext()
            return
        end

        self.Humanoid:MoveTo(part.Position)

        self.Humanoid.MoveToFinished:Once(function(reached)
            -- even if it fails slightly, we continue
            self.waypointIndex += 1
            moveToNext()
        end)
    end

    moveToNext()
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