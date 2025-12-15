-- ServerScriptService/CollisionGroupsSetup.lua
local PhysicsService = game:GetService("PhysicsService")
local Players = game:GetService("Players")

-- create groups (safe even if they already exist)
pcall(function() PhysicsService:CreateCollisionGroup("Player") end)
pcall(function() PhysicsService:CreateCollisionGroup("NPC") end)

-- ensure they don't collide
PhysicsService:CollisionGroupSetCollidable("Player", "NPC", false)
PhysicsService:CollisionGroupSetCollidable("NPC", "NPC", false)

-- helper
local function setCollisionGroupRecursive(model: Model, groupName: string)
	for _, part in ipairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			PhysicsService:SetPartCollisionGroup(part, groupName)
		end
	end
end

-- set for NPCs
local NPC_FOLDER = workspace:WaitForChild("NPCs")
for _, npc in ipairs(NPC_FOLDER:GetChildren()) do
	if npc:IsA("Model") and npc:FindFirstChildOfClass("Humanoid") then
		setCollisionGroupRecursive(npc, "NPC")
	end
end
NPC_FOLDER.ChildAdded:Connect(function(npc)
	task.wait(0.2)
	if npc:IsA("Model") and npc:FindFirstChildOfClass("Humanoid") then
		setCollisionGroupRecursive(npc, "NPC")
	end
end)

-- set for players when they spawn
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(char)
		task.wait(0.2) -- wait for limbs
		setCollisionGroupRecursive(char, "Player")
	end)
end)