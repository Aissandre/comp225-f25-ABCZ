local PathfindingService = game:GetService("PathfindingService")
local RunService         = game:GetService("RunService")

local npcFolder = script.Parent
local rootNode  = workspace:WaitForChild("Nodes"):WaitForChild("startNode")

local function getNodeChildren(node)
	local children = {}
	for _, child in ipairs(node:GetChildren()) do
		if child:IsA("BasePart") then
			table.insert(children, child)
		end
	end
	return children
end

local function chooseChild(parent)
	local kids = getNodeChildren(parent)
	
	if #kids == 0 then 
		return nil 
	end
	
	return kids[math.random(1, #kids)]
end

local function moveToWithTimeout(hum: Humanoid, pos: Vector3, timeout: number?)
	timeout = timeout or 8
	hum:MoveTo(pos)

	local done = false
	local conn; conn = hum.MoveToFinished:Connect(function(reached)
		done = reached == true
	end)

	local t0 = time()
	while not (done) and (time() - t0 < timeout) do
		RunService.Heartbeat:Wait()
	end
	
	if conn then 
		conn:Disconnect() 
	end
	
	return done
end

local function getRootPart(model: Model): BasePart?
	return model:FindFirstChild("Torso")
end

local function prepareRig(npcModel: Model, hum: Humanoid): BasePart?
	local rootPart = getRootPart(npcModel)
	if not rootPart then 
		return nil 
	end

	if not npcModel.PrimaryPart then
		npcModel.PrimaryPart = rootPart
	end

	hum.PlatformStand = false
	hum.Sit           = false
	hum.AutoRotate    = true
	hum.WalkSpeed     = (hum.WalkSpeed > 0) and hum.WalkSpeed or 12

	return rootPart
end

local function createPathFor(model: Model): Path
	local size = model:GetExtentsSize()
	return PathfindingService:CreatePath({
		AgentRadius  = math.max(2, math.min(size.X, size.Z) * 0.35),
		AgentHeight  = math.max(4, size.Y * 0.9),
		AgentCanJump = true
	})
end

local function followPath(hum: Humanoid, rootPart: BasePart, model: Model, goal: Vector3): boolean
	local path = createPathFor(model)
	local ok = pcall(function()
		path:ComputeAsync(rootPart.Position, goal)
	end)
	if not ok or path.Status ~= Enum.PathStatus.Success then
		return false
	end

	local blocked = false
	local blkConn = path.Blocked:Connect(function() blocked = true end)

	for _, wp in ipairs(path:GetWaypoints()) do
		if blocked then break end
		if wp.Action == Enum.PathWaypointAction.Jump then
			hum.Jump = true
			task.defer(function() hum.Jump = false end)
		end
		if not moveToWithTimeout(hum, wp.Position, 8) then
			blkConn:Disconnect()
			return false
		end
	end

	blkConn:Disconnect()
	return not blocked
end

local function randomPathfind(npcModel: Model)
	local hum = npcModel:FindFirstChildOfClass("Humanoid")
	if not hum then
		return
	end

	local rootPart = prepareRig(npcModel, hum)
	if not rootPart then
		return
	end

	task.wait(math.random() * 0.3) -- desync starts a bit

	local cur = rootNode
	while npcModel.Parent do
		local nxt = chooseChild(cur)
		if nxt then
			if not followPath(hum, rootPart, npcModel, nxt.Position) then
				task.wait(0.2)
			end
			cur = nxt
		else
			cur = rootNode
			task.wait(0.3)
		end
		task.wait(0.05 + math.random() * 0.05)
	end
end

for _, child in ipairs(npcFolder:GetChildren()) do
	if child:IsA("Model") and child:FindFirstChildOfClass("Humanoid") then
		task.spawn(randomPathfind, child)
	end
end

-- By Andre --
-- Credits: RoDevs Discord and Roblox Pathfinding Documentation --