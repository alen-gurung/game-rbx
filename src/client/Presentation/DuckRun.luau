--!strict
-- One attempt's local duck presentation: builds the duck, drives pose and camera each frame from server timestamps,
-- and reports the wind fraction. Cosmetic only; it never sends requests. destroy() is idempotent.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local AttemptRules = require(Shared.Rules.AttemptRules)
local Layout = require(Shared.World.TestStripLayout)
local DuckPose = require(script.Parent.DuckPose)
local DuckModel = require(script.Parent.DuckModel)

export type DuckRun = {
	update: (self: DuckRun, data: any) -> (),
	destroy: (self: DuckRun) -> (),
}

local DuckRun = {}

function DuckRun.new(
	parent: Instance,
	initialData: any,
	camera: any,
	onWind: (fraction: number) -> (),
	onError: (message: any) -> ()
): DuckRun
	local data = initialData
	local origin = CFrame.new(Layout.startX, Layout.surfaceY, Layout.centerZ)
	local duck = DuckModel.new(parent, origin)
	local connection: RBXScriptConnection? = nil
	local destroyed = false
	local self = {} :: any

	local function render(deltaSeconds: number)
		local now = workspace:GetServerTimeNow()
		local sinceRelease = if data.releaseServerTime then now - data.releaseServerTime else nil
		local input, distance, wind = DuckPose.frame(
			data.state,
			data.snapshot,
			data.windupSeconds,
			now - (data.windingServerTime or now),
			sinceRelease,
			AttemptRules.sample
		)
		duck:setPose(DuckPose.sample(input), distance)
		camera:update(deltaSeconds, distance)
		onWind(wind)
	end

	function self.update(_: DuckRun, nextData: any)
		data = nextData
	end

	function self.destroy(_: DuckRun)
		if destroyed then
			return
		end
		destroyed = true
		if connection then
			connection:Disconnect()
			connection = nil
		end
		duck:destroy()
	end

	camera:start(origin, 0)
	render(0)
	connection = RunService.RenderStepped:Connect(function(deltaSeconds: number)
		local ok, message = pcall(render, deltaSeconds)
		if not ok and not destroyed then
			self:destroy()
			onError(message)
		end
	end)
	return self :: DuckRun
end

return DuckRun
