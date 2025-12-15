--Rescripted by Luckymaxer
--EUROCOW WAS HERE BECAUSE I MADE THE PARTICLES AND THEREFORE THIS ENTIRE SWORD PRETTY AND LOOK PRETTY WORDS AND I'D LIKE TO DEDICATE THIS TO MY FRIENDS AND HI LUCKYMAXER PLS FIX SFOTH SWORDS TY LOVE Y'ALl
--Updated for R15 avatars by StarWars
--Re-updated by TakeoHonorable
--EDITED BY ZANE PEDERSON SO THAT IT DOESN'T SUCK

Tool = script.Parent
Handle = Tool:WaitForChild("Handle")

local hitConnection
local hitDebounce = false

function Create(ty)
	return function(data)
		local obj = Instance.new(ty)
		for k, v in pairs(data) do
			if type(k) == 'number' then
				v.Parent = obj
			else
				obj[k] = v
			end
		end
		return obj
	end
end

local BaseUrl = "rbxassetid://"

Players = game:GetService("Players")
Debris = game:GetService("Debris")
RunService = game:GetService("RunService")

DamageValues = {
	SlashDamage = 10,
}

Damage = DamageValues.SlashDamage

--For R15 avatars
Animations = {
	R15Slash = 522635514,
	R15Lunge = 522638767
}

Grips = {
	Up = CFrame.new(0, 0, -1.70000005, 0, 0, 1, 1, 0, 0, 0, 1, 0),
	Out = CFrame.new(0, 0, -1.70000005, 0, 1, 0, 1, -0, 0, 0, 0, -1)
}

Sounds = {
	Slash = Handle:WaitForChild("SwordSlash"),
	Lunge = Handle:WaitForChild("SwordLunge"),
	Unsheath = Handle:WaitForChild("Unsheath")
}

ToolEquipped = false

--For Omega Rainbow Katana thumbnail to display a lot of particles.
for i, v in pairs(Handle:GetChildren()) do
	if v:IsA("ParticleEmitter") then
		v.Rate = 20
	end
end

Tool.Grip = Grips.Up
Tool.Enabled = true

function IsTeamMate(Player1, Player2)
	return (Player1 and Player2 and not Player1.Neutral and not Player2.Neutral and Player1.TeamColor == Player2.TeamColor)
end

function TagHumanoid(humanoid, player)
	local Creator_Tag = Instance.new("ObjectValue")
	Creator_Tag.Name = "creator"
	Creator_Tag.Value = player
	Debris:AddItem(Creator_Tag, 2)
	Creator_Tag.Parent = humanoid
end

function UntagHumanoid(humanoid)
	for i, v in pairs(humanoid:GetChildren()) do
		if v:IsA("ObjectValue") and v.Name == "creator" then
			v:Destroy()
		end
	end
end

function Blow(Hit)
	if not Hit or not Hit.Parent or not CheckIfAlive() or not ToolEquipped then
		return
	end

	local character = Hit.Parent
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return
	end

	-- STOP MULTIPLE HITS:
	if hitConnection then
		hitConnection:Disconnect()
		hitConnection = nil
	end

	-- original damage checks
	local RightArm = Character:FindFirstChild("Right Arm") or Character:FindFirstChild("RightHand")
	if not RightArm then return end

	local RightGrip = RightArm:FindFirstChild("RightGrip")
	if not RightGrip or (RightGrip.Part0 ~= Handle and RightGrip.Part1 ~= Handle) then
		return
	end

	if character == Character then return end
	if humanoid.Health == 0 then return end

	local player = Players:GetPlayerFromCharacter(character)
	if player and (player == Player or IsTeamMate(Player, player)) then
		return
	end

	UntagHumanoid(humanoid)
	TagHumanoid(humanoid, Player)
	humanoid:TakeDamage(Damage)
end

Tool.Enabled = true

function Activated()
	if not Tool.Enabled or not ToolEquipped or not CheckIfAlive() then
		return
	end

	Tool.Enabled = false
	Attack()

	Damage = DamageValues.SlashDamage
	local SlashAnim = (Tool:FindFirstChild("R15Slash") or Create("Animation"){
		Name = "R15Slash",
		AnimationId = BaseUrl .. Animations.R15Slash,
		Parent = Tool
	})

	local LungeAnim = (Tool:FindFirstChild("R15Lunge") or Create("Animation"){
		Name = "R15Lunge",
		AnimationId = BaseUrl .. Animations.R15Lunge,
		Parent = Tool
	})
	Tool.Enabled = true
end

function CheckIfAlive()
	return (((Player and Player.Parent and Character and Character.Parent and Humanoid and Humanoid.Parent and Humanoid.Health > 0 and Torso and Torso.Parent) and true) or false)
end

function Equipped()
	Character = Tool.Parent
	Player = Players:GetPlayerFromCharacter(Character)
	Humanoid = Character:FindFirstChildOfClass("Humanoid")
	Torso = Character:FindFirstChild("Torso") or Character:FindFirstChild("HumanoidRootPart")
	if not CheckIfAlive() then
		return
	end
	ToolEquipped = true
	Sounds.Unsheath:Play()
end

function Unequipped()
	Tool.Grip = Grips.Up
	ToolEquipped = false
end

function SwingDamage()
	if hitDebounce then return end
	hitDebounce = true

	-- Enable Blow only during swing
	hitConnection = Handle.Touched:Connect(Blow)

	-- Time window sword is "active"
	task.delay(0.3, function()
		if hitConnection then
			hitConnection:Disconnect()
			hitConnection = nil
		end
		hitDebounce = false
	end)
end

function Attack()
	Damage = DamageValues.SlashDamage
	Sounds.Slash:Play()
	SwingDamage() -- <--- call hit window during attack animation

	if Humanoid.RigType == Enum.HumanoidRigType.R6 then
		local Anim = Instance.new("StringValue")
		Anim.Name = "toolanim"
		Anim.Value = "Slash"
		Anim.Parent = Tool
	else
		local Anim = Tool:FindFirstChild("R15Slash")
		if Anim then
			Humanoid:LoadAnimation(Anim):Play()
		end
	end	
end

Tool.Activated:Connect(Activated)
Tool.Equipped:Connect(Equipped)
Tool.Unequipped:Connect(Unequipped)