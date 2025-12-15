--Made by Zane

game.Players.PlayerAdded:Connect(function(player)
	player:SetAttribute("playerLobby", 0) --0 = lobby, 1 = game1, 2 = game2

	-- player:SetAttribute("playerLobby", 1) player:GetAttribute("playerLobby")
end)