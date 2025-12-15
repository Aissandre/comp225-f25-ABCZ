local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local MAX_LEVEL = 5

local function onPlayerAdded(player)
	player.CharacterAdded:Connect(function(character)
		humanoid:SetAttribute("SwordLevel", 1)
	end)
end

--set custom sword level
local function setCharacterSwordLevel(humanoid, level)
	-- Set the character attribute
	if (humanoid:GetAttribute("SwordLevel") < MAX_LEVEL) then
	humanoid:SetAttribute("SwordLevel", level)
	end
end	

--returns SwordLevel attribute
local function getCharacterSwordLevel(character)
	return humanoid:GetAttribute("SwordLevel") or 1
end

--Clarissa S