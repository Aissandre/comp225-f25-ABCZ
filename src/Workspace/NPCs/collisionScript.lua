local PhysicsService = game:GetService("PhysicsService")

local NPC_GROUP = "NPC"

if not pcall(function() PhysicsService:CreateCollisionGroup(NPC_GROUP) end) then
	-- ignore if exists
end

PhysicsService:CollisionGroupSetCollidable(NPC_GROUP, NPC_GROUP, false)

local function setupNPC(npc)
	for _, part in ipairs(npc:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanQuery = true -- still detectable by rays
			part.CanTouch = false
			part.CanCollide = true
			PhysicsService:SetPartCollisionGroup(part, NPC_GROUP)
		end
	end
end

workspace.NPCs.ChildAdded:Connect(function(npc)
	if npc:IsA("Model") then 
		setupNPC(npc) 
	end
end)

for _, npc in ipairs(workspace.NPCs:GetChildren()) do
	setupNPC(npc)
end

-- Andre collision Script --