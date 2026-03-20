local runService = game:GetService("RunService")
local iFrameTicks
local iFrameStartTime
local iMaxFrames = 1
local iCPULoad
local iPhysicsLoad

while true do
	iFrameTicks = 0
	iFrameStartTime = os.clock()

	while os.clock() - iFrameStartTime < 1 do
		runService.Heartbeat:Wait()
		iFrameTicks += 1
	end

	if iFrameTicks > iMaxFrames then
		iMaxFrames = iFrameTicks
	end

	iCPULoad = math.round((1 - (iFrameTicks / iMaxFrames)) * 100)
	iPhysicsLoad = math.round(((1 - (workspace:GetRealPhysicsFPS()) / 60)) * 100)

	game.Workspace:SetAttribute("ServerCPULoad", iCPULoad + iPhysicsLoad)
end