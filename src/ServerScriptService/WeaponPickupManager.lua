local ENABLED_TRANSPARENCY = 0.5
local DISABLED_TRANSPARENCY = 1
local Players = game:GetService("Players")
local MAX_LEVEL = 5
local weaponPickupsFolder = workspace:WaitForChild("WeaponPickups")
local weaponPickups = weaponPickupsFolder:GetChildren()

local smokeItem = game.ServerStorage.SmokeGrenade
local Players = game:GetService("Players")

local function onTouchSwordPickup(otherPart, pickup, light, particles)
	if pickup:GetAttribute("Enabled") then
		local character = otherPart.Parent
		local humanoid = character:FindFirstChildWhichIsA("Humanoid")
		if humanoid then
			--local currentLevel = humanoid:GetAttribute("SwordLevel") or 1
			--local newLevel = math.min(currentLevel + 1, MAX_LEVEL)
			--if newLevel ~= currentLevel then
			--	humanoid:SetAttribute("SwordLevel", newLevel)
			--end
			
			local smokeClone = smokeItem:Clone()
			smokeClone.Parent = Players:GetPlayerFromCharacter(humanoid.Parent).Backpack
			
			pickup.Transparency = DISABLED_TRANSPARENCY
			light.Brightness = 0
			particles.Enabled = false
			pickup:SetAttribute("Enabled", false)
			
			task.wait(math.random(25, 30))
			pickup.Transparency = ENABLED_TRANSPARENCY
			pickup.Brightness = 20
			pickup.Enabled = true
			pickup:SetAttribute("Enabled", true)
		end
	end
end

wait(10, 15)
for _, weaponPickup in ipairs(weaponPickups) do
	weaponPickup:SetAttribute("Enabled", true)
	weaponPickup.Transparency = ENABLED_TRANSPARENCY
	local light = weaponPickup:FindFirstChild("SurfaceLight")
	light.Brightness = 20
	local particles = weaponPickup:FindFirstChild("ParticleEmitter")
	particles.Enabled = true
	weaponPickup.Touched:Connect(function(otherPart)
		onTouchSwordPickup(otherPart, weaponPickup, light, particles)
	end)
end

--code by Roblox website, edited by Clarissa S
--https://create.roblox.com/docs/tutorials/use-case-tutorials/scripting/intermediate-scripting/create-a-health-pickup

