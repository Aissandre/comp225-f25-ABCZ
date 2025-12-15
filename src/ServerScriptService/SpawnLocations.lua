local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SpawnLocations = workspace.Spawns:GetChildren()


local function onPlayerAdded(player)
	player.CharacterAdded:Connect(function(character)
		if #SpawnLocations>0 then
			local playerSpawnLocation = SpawnLocations[math.random(1, #SpawnLocations)]
			player.RespawnLocation = playerSpawnLocation
			table.remove(SpawnLocations, playerSpawnLocation)
			local rootPart = character:WaitForChild("HumanoidRootPart")
			rootPart:setPrimaryPartCFrame(playerSpawnLocation.CFrame * CFrame.new(0, 5, 0))
			--I tried to readd jumping :'(
			--player.Character:WaitForChild("Humanoid").Jump = true
			--player.Character:FindFirstChildWhichIsA("Humanoid").Jump = true
			end
		end)	
end

--Code modified by Clarissa S from various sources