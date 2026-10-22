--!strict
-- Owns the local camera and character controls for one attempt; stop() restores both and is idempotent.
local Players = game:GetService("Players")
local DuckPose = require(script.Parent.DuckPose)

export type FollowCamera = {
	start: (self: FollowCamera, origin: CFrame, distanceStuds: number) -> (),
	update: (self: FollowCamera, deltaSeconds: number, distanceStuds: number) -> (),
	stop: (self: FollowCamera) -> (),
	isActive: (self: FollowCamera) -> boolean,
}

local cachedControls: any? = nil

local function controls(): any?
	if cachedControls then
		return cachedControls
	end
	local player = Players.LocalPlayer
	local ok, module = pcall(function()
		local playerModule = player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule", 5)
		return if playerModule then (require :: any)(playerModule):GetControls() else nil
	end)
	if not ok then
		warn("Character controls unavailable: " .. tostring(module))
		return nil
	end
	cachedControls = module
	return module
end

local function vector(values: { number }): Vector3
	return Vector3.new(values[1], values[2], values[3])
end

local FollowCamera = {}

function FollowCamera.new(): FollowCamera
	local active = false
	local origin = CFrame.identity
	local eye: { number } = { 0, 0, 0 }
	local look: { number } = { 0, 0, 0 }
	local savedFieldOfView = 70
	local self = {} :: any

	local function apply()
		local camera = workspace.CurrentCamera
		if camera then
			camera.CFrame = CFrame.lookAt(origin * vector(eye), origin * vector(look))
		end
	end

	function self.start(_: FollowCamera, newOrigin: CFrame, distanceStuds: number)
		local camera = workspace.CurrentCamera
		if not camera then
			return
		end
		if not active then
			savedFieldOfView = camera.FieldOfView
			local playerControls = controls()
			if playerControls then
				playerControls:Disable()
			end
		end
		active = true
		origin = newOrigin
		eye, look = DuckPose.cameraTarget(distanceStuds)
		camera.CameraType = Enum.CameraType.Scriptable
		camera.FieldOfView = DuckPose.camera.fieldOfView
		apply()
	end

	function self.update(_: FollowCamera, deltaSeconds: number, distanceStuds: number)
		if not active then
			return
		end
		local targetEye, targetLook = DuckPose.cameraTarget(distanceStuds)
		eye = DuckPose.smooth(eye, targetEye, deltaSeconds)
		look = DuckPose.smooth(look, targetLook, deltaSeconds)
		apply()
	end

	function self.stop(_: FollowCamera)
		if not active then
			return
		end
		active = false
		local camera = workspace.CurrentCamera
		if camera then
			local character = Players.LocalPlayer.Character
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			camera.CameraType = Enum.CameraType.Custom
			camera.FieldOfView = savedFieldOfView
			if humanoid then
				camera.CameraSubject = humanoid
			end
		end
		local playerControls = controls()
		if playerControls then
			playerControls:Enable()
		end
	end

	function self.isActive(_: FollowCamera): boolean
		return active
	end

	return self :: FollowCamera
end

return FollowCamera
