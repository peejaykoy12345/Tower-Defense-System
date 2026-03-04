local ReplicatedStorage = game:GetService("ReplicatedStorage")

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
    self.Model.Parent = workspace

    local hrp = self.Model:WaitForChild("HumanoidRootPart")

    self.hrp = hrp
    self.waypointIndex = 1
    self.finished = false

    return self
end

function Default:MoveTo(waypoints: {BasePart})
    local humanoid = self.Model:WaitForChild("Humanoid")
    humanoid.WalkSpeed = self.Speed

    local function moveToNext()
        if self.waypointIndex > #waypoints then
            self.finished = true
            return
        end

        local part = waypoints[self.waypointIndex]

        if not part or not part:IsA("BasePart") then
            warn("Invalid waypoint at index", self.waypointIndex)
            self.waypointIndex += 1
            moveToNext()
            return
        end

        humanoid:MoveTo(part.Position)

        humanoid.MoveToFinished:Once(function(reached)
            -- even if it fails slightly, we continue
            self.waypointIndex += 1
            moveToNext()
        end)
    end

    moveToNext()
end

function Default:Destroy()
    self.active = false
    if self.Model then
        self.Model:Destroy()
    end
end

return Default