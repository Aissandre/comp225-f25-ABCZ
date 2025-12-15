local NPCFolder = script.Parent  -- or: workspace:WaitForChild("NPCs")

local function applyProperties(npc: Model)
	local hum = npc:FindFirstChildOfClass("Humanoid")
	if not hum then return end

	-- hide overhead name
	hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	
	
	-- change skin tone via BodyColors
	local bc = npc:FindFirstChildOfClass("BodyColors") or npc:FindFirstChild("Body Colors")
	if bc then
		local skin = BrickColor.new("New Yeller")
		local legs = BrickColor.new("Lime green")
		bc.HeadColor = skin
		bc.LeftArmColor = skin
		bc.RightArmColor = skin
		bc.LeftLegColor = legs
		bc.RightLegColor = legs
		bc.TorsoColor = BrickColor.new("Cyan")
	end
	
	-- force R6 rig type
	hum.RigType = Enum.HumanoidRigType.R6
	
	-- applying animations
	
end

-- apply to existing
for _, m in ipairs(NPCFolder:GetChildren()) do
	if m:IsA("Model") then 
		applyProperties(m) 
	end
end
