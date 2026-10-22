local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Contract = require(ReplicatedStorage:WaitForChild("Shared").Net.Contract)
local DuckRun = require(script.Parent.Parent.Presentation.DuckRun)
local FollowCamera = require(script.Parent.Parent.Presentation.FollowCamera)
local AttemptHud = require(script.Parent.Parent.UI.AttemptHud)
local DuckPose = require(script.Parent.Parent.Presentation.DuckPose)
local AttemptController = {}

function AttemptController.start()
	local player = Players.LocalPlayer
	local remotes = {}
	local folder = ReplicatedStorage:WaitForChild(Contract.folderName)
	for name in Contract.messages do
		remotes[name] = folder:WaitForChild(name)
	end
	local camera = FollowCamera.new()
	local presentationFolder = Instance.new("Folder")
	presentationFolder.Name = "LocalDuckAttempt"
	presentationFolder.Parent = workspace
	local data: any = { seq = -1, state = "Ready" }
	local highestAttemptId = 0
	local interruptedAttemptId = nil
	local session = nil
	local generation = 0
	local resultAttemptId = nil
	local resultVisible = false
	local connections = {}
	local deathConnection = nil
	local stopped = false
	local hud = AttemptHud.new(player:WaitForChild("PlayerGui"), function(action: string)
		if action == "RequestLaunch" then
			remotes[action]:FireServer()
		elseif data.attemptId then
			remotes[action]:FireServer({ attemptId = data.attemptId })
		end
	end)

	local function cleanup()
		generation += 1
		if session then
			session:destroy()
			session = nil
		end
		presentationFolder:ClearAllChildren()
		camera:stop()
	end

	local function interrupt()
		interruptedAttemptId = data.attemptId
		if data.attemptId and (data.state == "Winding" or data.state == "Running") then
			remotes.RequestCancel:FireServer({ attemptId = data.attemptId })
		end
		cleanup()
		resultVisible = false
		hud:setState({ state = "Ready" })
	end

	local function characterAdded(character: Model)
		if deathConnection then
			deathConnection:Disconnect()
			deathConnection = nil
		end
		local humanoid = character:WaitForChild("Humanoid", 10)
		if stopped or player.Character ~= character or not humanoid or not humanoid:IsA("Humanoid") then
			return
		end
		deathConnection = humanoid.Died:Connect(interrupt)
		if data.state == "Ready" or interruptedAttemptId then
			local current = workspace.CurrentCamera
			if current then
				current.CameraSubject = humanoid
				current.CameraType = Enum.CameraType.Custom
			end
		end
	end

	table.insert(connections, player.CharacterRemoving:Connect(interrupt))
	table.insert(connections, player.CharacterAdded:Connect(characterAdded))
	if player.Character then
		task.spawn(characterAdded, player.Character)
	end
	table.insert(
		connections,
		remotes.AttemptState.OnClientEvent:Connect(function(nextData: Contract.AttemptState)
			if type(nextData) ~= "table" or type(nextData.seq) ~= "number" or nextData.seq <= data.seq then
				return
			end
			if nextData.attemptId and nextData.attemptId < highestAttemptId then
				return
			end
			data = nextData
			if data.attemptId then
				highestAttemptId = math.max(highestAttemptId, data.attemptId)
			end
			if data.state == "Ready" then
				interruptedAttemptId = nil
				resultAttemptId = nil
				resultVisible = false
				cleanup()
				hud:setState(data)
				return
			end
			if data.attemptId == interruptedAttemptId then
				return
			end
			if not session then
				local ok, result = pcall(function()
					camera:start()
					return DuckRun.new(presentationFolder, data, camera, function(fraction: number)
						hud:setWind(fraction)
					end, function(message: any)
						warn("Duck presentation failed: " .. tostring(message))
						cleanup()
						-- A cosmetic failure must not hide an authoritative result or its Retry.
						if data.state == "Ended" then
							resultVisible = true
							hud:setState(data, true)
						end
					end)
				end)
				if ok then
					session = result
				else
					warn(result)
					cleanup()
				end
			else
				session:update(data)
			end
			hud:setState(data, resultVisible)
			if data.state == "Ended" and resultAttemptId ~= data.attemptId then
				resultAttemptId = data.attemptId
				local attemptId = data.attemptId
				local elapsed = workspace:GetServerTimeNow()
					- (data.releaseServerTime or 0)
					- data.snapshot.travelSeconds
				local delaySeconds = if session
					then math.max(0, DuckPose.resultDelaySeconds(data.outcome) - elapsed)
					else 0
				-- Only a newer state or attempt invalidates the result; presentation cleanup does not. The follow camera
				-- keeps framing the stopped duck until Retry returns to Ready.
				task.delay(delaySeconds, function()
					if stopped or data.state ~= "Ended" or data.attemptId ~= attemptId then
						return
					end
					resultVisible = true
					hud:setState(data, true)
				end)
			end
		end)
	)
	table.insert(
		connections,
		script.Destroying:Connect(function()
			stopped = true
			cleanup()
			for _, connection in connections do
				connection:Disconnect()
			end
			if deathConnection then
				deathConnection:Disconnect()
			end
			hud:destroy()
			presentationFolder:Destroy()
		end)
	)
	remotes.RequestSync:FireServer()
end

return AttemptController
