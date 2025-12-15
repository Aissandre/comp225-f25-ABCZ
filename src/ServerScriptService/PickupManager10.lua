local ENABLED_TRANSPARENCY = 0.5
local DISABLED_TRANSPARENCY = 1

-- Set this value to the amount you want each pickup to heal
local HEALTH_RESTORED = 10

local healthPickupsFolder = workspace:WaitForChild("HealthPickups")
local healthPickupsFolder10 = healthPickupsFolder:WaitForChild("HealthPickups10")
local healthPickups = healthPickupsFolder10:GetChildren()

local function onTouchHealthPickup(otherPart, healthPickup, healthLight, healthParticles)
	if healthPickup:GetAttribute("Enabled") then
		local character = otherPart.Parent
		local humanoid = character:FindFirstChildWhichIsA("Humanoid")
		if humanoid then
			-- Heal the player, but do not exceed MaxHealth
			humanoid.Health = math.min(humanoid.Health + HEALTH_RESTORED, humanoid.MaxHealth)
			healthPickup.Transparency = DISABLED_TRANSPARENCY
			healthLight.Brightness = 0
			healthParticles.Enabled = false
		
			healthPickup:SetAttribute("Enabled", false)
			task.wait(math.random(20, 60))
			healthPickup.Transparency = ENABLED_TRANSPARENCY
			healthLight.Brightness = 20
			healthParticles.Enabled = true
			healthPickup:SetAttribute("Enabled", true)
			
		end
	end
end

wait(15, 30)
for _, healthPickup in ipairs(healthPickups) do
	healthPickup:SetAttribute("Enabled", true)
	healthPickup.Transparency = ENABLED_TRANSPARENCY
	local healthLight = healthPickup:FindFirstChild("SurfaceLight")
	healthLight.Brightness = 20
	local healthParticles = healthPickup:FindFirstChild("ParticleEmitter")
	healthParticles.Enabled = true
	healthPickup.Touched:Connect(function(otherPart)
		onTouchHealthPickup(otherPart, healthPickup, healthLight, healthParticles)
	end)
end

--code by Roblox website, edited by Clarissa S
--https://create.roblox.com/docs/tutorials/use-case-tutorials/scripting/intermediate-scripting/create-a-health-pickup

