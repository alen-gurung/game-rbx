local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage.Shared
local Config = require(Shared.Config.Attempt)
local Course = require(Shared.Config.Course)
local Rules = require(Shared.Rules.AttemptRules)
local Machine = require(Shared.Rules.AttemptStateMachine)
local Contract = require(Shared.Net.Contract)
local PlayerPower = require(script.Parent.Parent.Services.PlayerPower)

type Record = {
	data: Contract.AttemptState,
	lastRequests: { [string]: number },
	connections: { RBXScriptConnection },
	deathConnection: RBXScriptConnection?,
}
local AttemptFeature = {}

function AttemptFeature.start(remotes: { [string]: RemoteEvent })
	local records: { [Player]: Record } = {}
	local nextAttemptId = 0

	local function send(player: Player, record: Record)
		record.data.seq += 1
		remotes.AttemptState:FireClient(player, table.clone(record.data))
	end

	local function ready(player: Player, record: Record, cancelled: boolean)
		record.data = { seq = record.data.seq, state = "Ready", cancelled = cancelled }
		send(player, record)
	end

	local function cancel(player: Player, record: Record)
		local ok = Machine.transition(record.data.state, "Cancel")
		if ok or record.data.state == "Ended" then
			ready(player, record, true)
		end
	end

	local function alive(player: Player): boolean
		local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		return humanoid ~= nil and humanoid.Health > 0
	end

	local function launch(player: Player, record: Record)
		nextAttemptId += 1
		local attemptId = nextAttemptId
		local power = PlayerPower.read(player)
		local snapshot = Rules.snapshot(power, Config, Course)
		record.data = {
			seq = record.data.seq,
			state = "Winding",
			attemptId = attemptId,
			courseId = Course.id,
			power = power,
			snapshot = snapshot,
			windupSeconds = Config.windupSeconds,
			windingServerTime = workspace:GetServerTimeNow(),
		}
		send(player, record)
		task.delay(record.data.windupSeconds, function()
			if records[player] ~= record or record.data.attemptId ~= attemptId or record.data.state ~= "Winding" then
				return
			end
			if not alive(player) then
				cancel(player, record)
				return
			end
			local ok, state = Machine.transition(record.data.state, "WindupDone")
			if not ok then
				return
			end
			record.data.state = state
			record.data.releaseServerTime = workspace:GetServerTimeNow()
			send(player, record)
			task.delay(snapshot.travelSeconds, function()
				if
					records[player] ~= record
					or record.data.attemptId ~= attemptId
					or record.data.state ~= "Running"
				then
					return
				end
				if not alive(player) then
					cancel(player, record)
					return
				end
				local accepted, ended = Machine.transition(record.data.state, "TravelDone")
				if not accepted then
					return
				end
				record.data.state = ended
				record.data.outcome = snapshot.outcome
				record.data.distance = snapshot.distanceStuds
				send(player, record)
			end)
		end)
	end

	local function add(player: Player)
		if records[player] then
			return
		end
		local record: Record = { data = { seq = 0, state = "Ready" }, lastRequests = {}, connections = {} }
		records[player] = record
		local function characterAdded(character: Model)
			if record.deathConnection then
				record.deathConnection:Disconnect()
				record.deathConnection = nil
			end
			local humanoid = character:WaitForChild("Humanoid", 10)
			if
				records[player] ~= record
				or player.Character ~= character
				or not humanoid
				or not humanoid:IsA("Humanoid")
			then
				return
			end
			record.deathConnection = humanoid.Died:Connect(function()
				cancel(player, record)
			end)
		end
		table.insert(record.connections, player.CharacterAdded:Connect(characterAdded))
		table.insert(
			record.connections,
			player.CharacterRemoving:Connect(function()
				if record.deathConnection then
					record.deathConnection:Disconnect()
					record.deathConnection = nil
				end
				cancel(player, record)
			end)
		)
		if player.Character then
			task.spawn(characterAdded, player.Character)
		end
	end

	Players.PlayerAdded:Connect(add)
	Players.PlayerRemoving:Connect(function(player: Player)
		local record = records[player]
		if record then
			records[player] = nil
			for _, connection in record.connections do
				connection:Disconnect()
			end
			if record.deathConnection then
				record.deathConnection:Disconnect()
			end
		end
		PlayerPower.remove(player)
	end)
	for _, player in Players:GetPlayers() do
		add(player)
	end

	for name, definition in Contract.messages do
		if definition.direction ~= "C2S" then
			continue
		end
		remotes[name].OnServerEvent:Connect(function(player: Player, ...: any)
			local record = records[player]
			if not record then
				return
			end
			local args = table.pack(...)
			local now = workspace:GetServerTimeNow()
			-- Every request counts toward the rate limit; rate-limited requests are dropped without a reply so a
			-- spamming client can't amplify state traffic. Other rejections resend state so the client resyncs.
			local previous = record.lastRequests[name]
			record.lastRequests[name] = now
			if previous and now - previous < definition.rateLimitSeconds then
				return
			end
			if not table.find(definition.states, record.data.state) then
				send(player, record)
				return
			end
			if name == "RequestSync" or name == "RequestLaunch" then
				if args.n ~= 0 then
					send(player, record)
					return
				end
			else
				local payload = args[1]
				if args.n ~= 1 or type(payload) ~= "table" then
					send(player, record)
					return
				end
				for key in payload do
					if key ~= "attemptId" then
						send(player, record)
						return
					end
				end
				local attemptId = payload.attemptId
				if
					type(attemptId) ~= "number"
					or attemptId ~= attemptId
					or attemptId < 1
					or attemptId > 9007199254740991
					or attemptId % 1 ~= 0
					or attemptId ~= record.data.attemptId
				then
					send(player, record)
					return
				end
			end
			if
				name == "RequestLaunch" and (not alive(player) or not Machine.transition(record.data.state, "Launch"))
			then
				send(player, record)
				return
			end
			if name == "RequestLaunch" then
				launch(player, record)
			elseif name == "RequestRetry" then
				if Machine.transition(record.data.state, "Retry") then
					ready(player, record, false)
				else
					send(player, record)
				end
			elseif name == "RequestCancel" then
				cancel(player, record)
			else
				send(player, record)
			end
		end)
	end
end

return AttemptFeature
