local Players = game:GetService("Players") -- retrieve the "Players" service from the Players folder
local TeleportService = game:GetService("TeleportService")

local placeId = 120423619100278  -- ID to teleport to

local function onPlayerAdded(player)
	local function onCharacterAdded(character)
		local humanoid = character:WaitForChild("Humanoid")
		local function onDied()
			local function teleportPlayersToPrivateServer(player)
				task.wait(0.5)
				TeleportService:TeleportAsync(placeId, {player})
			end
			teleportPlayersToPrivateServer(player)
		end
		humanoid.Died:Connect(onDied) -- connects the "onDied" function to the "Died" event of the humanoid
	end
	player.CharacterAdded:Connect(onCharacterAdded)
	player:LoadCharacter() --resets character
end
Players.PlayerAdded:Connect(onPlayerAdded)


--code by Clarissa S & Zane P