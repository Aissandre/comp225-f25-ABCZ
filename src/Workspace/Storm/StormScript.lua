--https://www.youtube.com/watch?v=zwaUwnY4p5g
--code by Zane

local playerInCircle = {} --used to track players within the storm
local stormDamage = 5 --per second
local shrinkRate = 0 --meters per tenth of a second
local timeBeforeShrink = 30
local shrinkRate2 = 0.2
local run = false --local variable used to track if the storm should be active or not
local size = Vector3.new(500,500,500) --storm default size

script.Parent.Touched:Connect(function()
	--This is an empty shell that does nothing. It is needed because it allows the getTouchingParts() function to work with canCollide = false.
end)

task.spawn(function()
	task.wait(1)
	reset()
	start()
end)

--Used chatGPT to fix this function since I was having issues with for looping properly (that is why its sorta wack)
function stormTick()
	table.clear(playerInCircle)

	-- collect players in circle
	for i, part in ipairs(script.Parent:GetTouchingParts()) do
		local character = part.Parent
		local humanoidRoot = character:FindFirstChild("HumanoidRootPart")
		local humanoid = character:FindFirstChild("Humanoid")
		if humanoidRoot and part == humanoidRoot and humanoid then
			local player = game.Players:GetPlayerFromCharacter(character)
			if player then
				table.insert(playerInCircle, player)
			end
		end
	end

	-- all players
	local playerOutOfCircle = game.Players:GetPlayers()

	-- remove players in circle from outOfCircle
	for i = #playerOutOfCircle, 1, -1 do
		local p = playerOutOfCircle[i]
		for _, inCircle in ipairs(playerInCircle) do
			if p == inCircle then
				table.remove(playerOutOfCircle, i)
				break
			end
		end
	end

	-- damage remaining players
	for _, player in ipairs(playerOutOfCircle) do
		if player.Character then
			local humanoid = player.Character:FindFirstChild("Humanoid")
			if humanoid and humanoid.Health > 0 then
				--print("Damaging", player.Name)
				humanoid:TakeDamage(stormDamage)
			end
		end
	end
end

function shrink()
	
	local visibleStorm --holds the visible storm part
	local Storm = script.Parent
	
	if Storm.Size.Z <= 30 then
		return
	end
	
	for i,v in script.Parent:GetChildren() do
		if v.Name == "Visible" then
			visibleStorm = v
		end
	end
	
	if visibleStorm then
		visibleStorm.Size -= Vector3.new(0, shrinkRate, shrinkRate)
	end
	if Storm then
		Storm.Size -= Vector3.new(0, shrinkRate, shrinkRate)
	end
	
end

function reset()
	run = false
	local visibleStorm --holds the visible storm part
	local Storm = script.Parent

	for i,v in script.Parent:GetChildren() do
		if v.Name == "Visible" then
			visibleStorm = v
		end
	end

	if visibleStorm then
		visibleStorm.Size = size + Vector3.new(0,1,1)
	end
	if Storm then
		Storm.Size = size
	end
end

function start()
	local stopwatch = 0
	
	run = true
	while run == true do --every second call stormTick()
		for i = 1, 10 do
			task.wait(0.1)
			if shrinkRate >= 0 then
				shrink()
			end
		end
		stormTick()
		stopwatch = stopwatch + 1
		if stopwatch >= timeBeforeShrink then
			shrinkRate = shrinkRate2
		end
	end
end

function stop()
	--print("stopped")
	run = false
end