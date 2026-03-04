local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Default = {}
Default.__index = Default

type enemyParams = {
    Name: string,
    Template: Model,
    Speed: number,
}

function Default.precomputeWaypoints(waypoints: {BasePart}): {Vector3}
    local baked = {}
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = waypoints

    for _, wp in ipairs(waypoints) do
        local pos = wp.Position
        local result = workspace:Raycast(
            Vector3.new(pos.X, 500, pos.Z),
            Vector3.new(0, -1000, 0),
            rayParams
        )
        local y = result and result.Position.Y or pos.Y
        table.insert(baked, Vector3.new(pos.X, y, pos.Z))
    end

    return baked
end

function Default.new(enemyParams: enemyParams)
    local self = setmetatable({}, Default)

    self.Name = enemyParams.Name
    self.Speed = enemyParams.Speed or 16
    self.Model = enemyParams.Template:Clone()
    self.Model.Parent = workspace

    local hrp = self.Model:WaitForChild("HumanoidRootPart")
    local cf, sz = self.Model:GetBoundingBox()
    self.hrpGroundOffset = hrp.Position.Y - (cf.Position.Y - sz.Y / 2)

    self.hrp = hrp
    self.waypointIndex = 1
    self.elapsed = 0
    self.duration = 0
    self.startPos = hrp.Position
    self.targetPos = hrp.Position
    self.active = false
    self.finished = false

    return self
end

function Default:SetPath(bakedWaypoints: {Vector3})
    self.waypoints = bakedWaypoints
    self:_nextWaypoint()
end

function Default:_nextWaypoint()
    if not self.waypoints or self.waypointIndex > #self.waypoints then
        self.finished = true
        self.active = false
        return
    end

    local target = self.waypoints[self.waypointIndex]
    local hrpPos = self.hrp.Position

    self.startPos = hrpPos
    self.targetPos = Vector3.new(target.X, target.Y + self.hrpGroundOffset, target.Z)

    local distance = Vector3.new(hrpPos.X, 0, hrpPos.Z) - Vector3.new(target.X, 0, target.Z)
    self.duration = distance.Magnitude / self.Speed
    self.elapsed = 0
    self.active = true
end

function Default:Step(dt: number)
    if not self.active then return end

    self.elapsed += dt
    local alpha = math.clamp(self.elapsed / self.duration, 0, 1)

    self.hrp.CFrame = CFrame.new(self.startPos:Lerp(self.targetPos, alpha))

    if alpha >= 1 then
        self.waypointIndex += 1
        self:_nextWaypoint()
    end
end

function Default:Destroy()
    self.active = false
    if self.Model then
        self.Model:Destroy()
    end
end

return Default