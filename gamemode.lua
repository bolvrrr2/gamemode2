-- GAMEMODE: bolvrrr2
-- Escape de la ola + Robar Brainrot

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Wave = Workspace:WaitForChild("Wave")
local BrainrotFolder = Workspace:WaitForChild("BrainrotItems")

-- CONFIG
local ROUND_TIME = 45
local INTERMISSION = 10
local WAVE_SPEED = 25
local BRAINROT_AMOUNT = 10

local GameRunning = false
local Connections = {}

-- Spawnear Brainrot
local function spawnBrainrot()
	for i = 1, BRAINROT_AMOUNT do
		local brainrot = BrainrotFolder.Brainrot:Clone()
		brainrot.Position = Vector3.new(
			math.random(-80, 80),
			5,
			math.random(-80, 80)
		)
		brainrot.Parent = BrainrotFolder
	end
end

-- Limpiar Brainrot
local function clearBrainrot()
	for _, item in pairs(BrainrotFolder:GetChildren()) do
		if item.Name == "Brainrot" then
			item:Destroy()
		end
	end
end

-- Iniciar ola
local function startWave()
	local startPos = Wave.Position
	local direction = Vector3.new(0, 0, -1)

	local moveConnection
	moveConnection = RunService.Heartbeat:Connect(function(dt)
		if not GameRunning then
			moveConnection:Disconnect()
			return
		end
		Wave.Position += direction * WAVE_SPEED * dt
	end)

	table.insert(Connections, moveConnection)
end

-- Matar si toca la ola
Wave.Touched:Connect(function(hit)
	if not GameRunning then return end

	local character = hit.Parent
	local humanoid = character:FindFirstChild("Humanoid")

	if humanoid then
		humanoid.Health = 0
	end
end)

-- Recolectar Brainrot
local function setupBrainrotTouch(brainrot)
	brainrot.Touched:Connect(function(hit)
		local player = Players:GetPlayerFromCharacter(hit.Parent)
		if player then
			brainrot:Destroy()
			print(player.Name .. " robó Brainrot 🧠")
		end
	end)
end

-- Loop principal
while true do
	print("⏳ Intermisión...")
	wait(INTERMISSION)

	GameRunning = true
	print("🔥 RONDA INICIADA - bolvrrr2")

	Wave.Position = Vector3.new(0, 10, 120)
	clearBrainrot()
	spawnBrainrot()

	for _, brainrot in pairs(BrainrotFolder:GetChildren()) do
		if brainrot.Name == "Brainrot" then
			setupBrainrotTouch(brainrot)
		end
	end

	startWave()

	wait(ROUND_TIME)

	GameRunning = false
	print("🏁 RONDA TERMINADA")

	-- Reset jugadores
	for _, player in pairs(Players:GetPlayers()) do
		if player.Character and player.Character:FindFirstChild("Humanoid") then
			player.Character.Humanoid.Health = 0
		end
	end

	clearBrainrot()

	wait(5)
end
