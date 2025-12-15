local Players = game:GetService("Players")
local activePlayers = {}
local TeleportService = game:GetService("TeleportService")

local placeId = 120423619100278  -- ID to teleport to


local function onPlayerAdded(player)
	table.insert(activePlayers, player)
end

local function onPlayerRemoving(player)
	local index = table.find(activePlayers, player)
	if index then
		table.remove(activePlayers, table.find(activePlayers, player))
	end
	if #activePlayers == 1 then
		local lastPlayer = activePlayers[1]
		
		local winScreen = lastPlayer:WaitForChild("PlayerGui"):WaitForChild("WinScreen").Main
		winScreen.Visible = true
		
		local function teleportPlayersToPrivateServer(player)
			task.wait(2)
			TeleportService:TeleportAsync(placeId, {player})
		end
		teleportPlayersToPrivateServer(lastPlayer)
	end
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

--Code by Clarissa S and Zane Pederson
	
