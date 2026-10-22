--!strict
-- Engine-free duck geometry, pose timing and follow-camera math. DuckModel/FollowCamera apply these numbers to
-- Roblox objects, and tools/preview.luau samples the same functions for the Claude Desktop motion preview.
-- Transforms use CFrame.new component order: { x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22 }.
-- Duck space: +X is forward along the strip, +Y up, +Z toward the camera side; studs and radians.

export type Matrix = { number }
export type PartSpec = {
	name: string,
	shape: string, -- "Block" | "Ball" | "Cylinder" (Cylinder axis along X)
	group: string, -- "body" | "key" | "footL"/"footR" (legs swing) | "soleL"/"soleR" (feet stay level on the arc)
	size: { number },
	position: { number },
	pitch: number?,
	color: { number },
	material: string,
}
export type PoseInput = {
	phase: string, -- "winding" | "running" | "ended"
	phaseSeconds: number,
	windupSeconds: number,
	distanceStuds: number,
	speedFraction: number,
	outcome: string?,
}
export type Pose = {
	height: number,
	pitch: number,
	roll: number,
	keyAngle: number,
	footSwing: number,
}

local PI = math.pi
local YELLOW = { 255, 204, 26 }
local WING = { 236, 176, 18 }
local ORANGE = { 255, 128, 20 }
local KEY = { 214, 178, 92 }
local BASE = { 236, 232, 222 }
local EYE = { 24, 24, 28 }

local KEY_PIVOT = { -2.6, 2.7, 0 }
local HIP_Y = 1.35
local ANKLE_DROP = 1.05 -- hip to ankle, studs
local ROLL_PIVOT_Z = -2.0 -- far-side foot edge: the flop tips away so its belly and feet face the camera

local DuckPose = {}

DuckPose.parts = table.freeze({
	{
		name = "Base",
		shape = "Block",
		group = "body",
		size = { 4.6, 0.5, 3.6 },
		position = { 0, 1.15, 0 },
		color = BASE,
		material = "SmoothPlastic",
	},
	{
		name = "Body",
		shape = "Block",
		group = "body",
		size = { 4.4, 2.6, 3.4 },
		position = { 0, 2.65, 0 },
		color = YELLOW,
		material = "SmoothPlastic",
	},
	{
		name = "Head",
		shape = "Ball",
		group = "body",
		size = { 2.8, 2.8, 2.8 },
		position = { 1.5, 4.6, 0 },
		color = YELLOW,
		material = "SmoothPlastic",
	},
	{
		name = "Beak",
		shape = "Block",
		group = "body",
		size = { 1.3, 0.55, 1.3 },
		position = { 3.1, 4.35, 0 },
		color = ORANGE,
		material = "SmoothPlastic",
	},
	{
		name = "EyeL",
		shape = "Ball",
		group = "body",
		size = { 0.55, 0.55, 0.55 },
		position = { 2.5, 5.05, 0.8 },
		color = EYE,
		material = "SmoothPlastic",
	},
	{
		name = "EyeR",
		shape = "Ball",
		group = "body",
		size = { 0.55, 0.55, 0.55 },
		position = { 2.5, 5.05, -0.8 },
		color = EYE,
		material = "SmoothPlastic",
	},
	{
		name = "Tail",
		shape = "Block",
		group = "body",
		size = { 1.2, 0.9, 2.2 },
		position = { -2.45, 3.75, 0 },
		pitch = 0.55,
		color = YELLOW,
		material = "SmoothPlastic",
	},
	{
		name = "WingL",
		shape = "Block",
		group = "body",
		size = { 2.2, 1.3, 0.3 },
		position = { -0.1, 2.85, 1.85 },
		color = WING,
		material = "SmoothPlastic",
	},
	{
		name = "WingR",
		shape = "Block",
		group = "body",
		size = { 2.2, 1.3, 0.3 },
		position = { -0.1, 2.85, -1.85 },
		color = WING,
		material = "SmoothPlastic",
	},
	{
		name = "KeyShaft",
		shape = "Cylinder",
		group = "key",
		size = { 1.3, 0.5, 0.5 },
		position = { -2.85, 2.7, 0 },
		color = KEY,
		material = "Metal",
	},
	{
		name = "KeyBow",
		shape = "Block",
		group = "key",
		size = { 0.3, 2.6, 0.7 },
		position = { -3.45, 2.7, 0 },
		color = KEY,
		material = "Metal",
	},
	{
		name = "KeyLobeTop",
		shape = "Ball",
		group = "key",
		size = { 1.2, 1.2, 1.2 },
		position = { -3.45, 3.95, 0 },
		color = KEY,
		material = "Metal",
	},
	{
		name = "KeyLobeBottom",
		shape = "Ball",
		group = "key",
		size = { 1.2, 1.2, 1.2 },
		position = { -3.45, 1.45, 0 },
		color = KEY,
		material = "Metal",
	},
	{
		name = "LegL",
		shape = "Block",
		group = "footL",
		size = { 0.5, 1.1, 0.5 },
		position = { 0.4, 0.85, 1.4 },
		color = ORANGE,
		material = "SmoothPlastic",
	},
	{
		name = "FootL",
		shape = "Block",
		group = "soleL",
		size = { 1.8, 0.4, 1.1 },
		position = { 0.85, 0.2, 1.45 },
		color = ORANGE,
		material = "SmoothPlastic",
	},
	{
		name = "LegR",
		shape = "Block",
		group = "footR",
		size = { 0.5, 1.1, 0.5 },
		position = { 0.4, 0.85, -1.4 },
		color = ORANGE,
		material = "SmoothPlastic",
	},
	{
		name = "FootR",
		shape = "Block",
		group = "soleR",
		size = { 1.8, 0.4, 1.1 },
		position = { 0.85, 0.2, -1.45 },
		color = ORANGE,
		material = "SmoothPlastic",
	},
} :: { PartSpec })

-- Presentation timing (seconds) and motion scales. Not balance: scored progress comes only from AttemptRules.
DuckPose.timing = table.freeze({
	windTurns = 2.5, -- key turns shown while winding
	keyRadiansPerStud = 1.18, -- key unwinds in step with distance, so it visibly slows with the duck
	strideStuds = 2.4, -- one full left/right foot cycle
	stallSeconds = 0.5,
	flopSeconds = 0.7,
	hopSeconds = 0.45,
	secondHopSeconds = 0.3,
	resultDelayExhaustedSeconds = 1.4,
	resultDelayFinishedSeconds = 0.9,
})

local function clamp01(value: number): number
	return math.clamp(value, 0, 1)
end

local function easeInOut(value: number): number
	local t = clamp01(value)
	return t * t * (3 - 2 * t)
end

local function easeOutBounce(value: number): number
	local t = clamp01(value)
	if t < 0.6 then
		local u = t / 0.6
		return u * u
	end
	local u = (t - 0.8) / 0.2
	return 1 - 0.08 * (1 - u * u)
end

function DuckPose.sample(input: PoseInput): Pose
	local timing = DuckPose.timing
	local wound = -timing.windTurns * 2 * PI
	local cycle = input.distanceStuds * 2 * PI / timing.strideStuds
	local speed = clamp01(input.speedFraction)
	local t = math.max(0, input.phaseSeconds)
	if input.phase == "winding" then
		local progress = clamp01(t / input.windupSeconds)
		return {
			height = 0.15 * math.sin(PI * progress) ^ 2,
			pitch = 0.14 * math.sin(PI * progress),
			roll = 0,
			keyAngle = wound * easeInOut(progress),
			footSwing = 0.12 * math.sin(progress * 6 * PI),
		}
	end
	local keyAngle = wound + input.distanceStuds * timing.keyRadiansPerStud
	local runningSwing = math.sin(cycle) * 0.7 * (0.4 + 0.6 * speed)
	if input.phase == "running" then
		local lunge = -0.14 * clamp01(1 - t / 0.25)
		return {
			height = math.abs(math.sin(cycle)) * 0.25 * (0.3 + 0.7 * speed),
			pitch = lunge - 0.05 * speed,
			roll = math.sin(t * 2 * PI * 2.2) * 0.07 * (1 - speed),
			keyAngle = keyAngle,
			footSwing = runningSwing,
		}
	end
	local settle = clamp01(1 - t / 0.3)
	if input.outcome == "finished" then
		local hop = 0
		if t < timing.hopSeconds then
			hop = math.sin(PI * t / timing.hopSeconds) * 1.2
		elseif t < timing.hopSeconds + timing.secondHopSeconds then
			hop = math.sin(PI * (t - timing.hopSeconds) / timing.secondHopSeconds) * 0.5
		end
		return {
			height = hop,
			pitch = 0.1 * math.sin(PI * clamp01(t / timing.hopSeconds)),
			roll = 0,
			keyAngle = keyAngle,
			footSwing = runningSwing * settle,
		}
	end
	local wobble = 0
	if t < timing.stallSeconds then
		wobble = math.sin(t * 2 * PI * 3) * 0.12 * (1 - t / timing.stallSeconds)
	end
	local flopEnd = timing.stallSeconds + timing.flopSeconds
	local flop = easeOutBounce((t - timing.stallSeconds) / timing.flopSeconds) * PI / 2 * 0.92
	-- Once on its side, the feet give a few feeble, fading kicks.
	local kick = if t > flopEnd
		then math.sin((t - flopEnd) * 2 * PI * 2.5) * 0.35 * clamp01(1 - (t - flopEnd) / 1.2)
		else 0
	return { height = 0, pitch = 0, roll = wobble + flop, keyAngle = keyAngle, footSwing = runningSwing * settle + kick }
end

local IDENTITY: Matrix = { 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1 }

local function multiply(a: Matrix, b: Matrix): Matrix
	local out = table.create(12, 0)
	for row = 0, 2 do
		for column = 0, 2 do
			local sum = 0
			for k = 0, 2 do
				sum += a[4 + row * 3 + k] * b[4 + k * 3 + column]
			end
			out[4 + row * 3 + column] = sum
		end
		out[1 + row] = a[1 + row] + a[4 + row * 3] * b[1] + a[5 + row * 3] * b[2] + a[6 + row * 3] * b[3]
	end
	return out
end

local function translate(x: number, y: number, z: number): Matrix
	return { x, y, z, 1, 0, 0, 0, 1, 0, 0, 0, 1 }
end

local function rotateX(angle: number): Matrix
	local c, s = math.cos(angle), math.sin(angle)
	return { 0, 0, 0, 1, 0, 0, 0, c, -s, 0, s, c }
end

local function rotateZ(angle: number): Matrix
	local c, s = math.cos(angle), math.sin(angle)
	return { 0, 0, 0, c, -s, 0, s, c, 0, 0, 0, 1 }
end

local function about(px: number, py: number, pz: number, rotation: Matrix): Matrix
	return multiply(multiply(translate(px, py, pz), rotation), translate(-px, -py, -pz))
end

DuckPose.multiply = multiply
DuckPose.translate = translate

-- Returns each part's transform in strip space for a duck whose start line point is at forward distance 0.
function DuckPose.partTransforms(pose: Pose, distanceStuds: number): { [string]: Matrix }
	local root = multiply(
		translate(distanceStuds, pose.height, 0),
		multiply(
			-- Wobble rocks on whichever side edge it tips toward; the flop always tips away from the camera.
			about(0, 0, if pose.roll >= 0 then ROLL_PIVOT_Z else -ROLL_PIVOT_Z, rotateX(-pose.roll)),
			-- Tip over the front toe or the back edge so no part sinks below the strip.
			about(if pose.pitch < 0 then 2.5 else -2.3, 0, 0, rotateZ(pose.pitch))
		)
	)
	local groups = {
		body = IDENTITY,
		key = about(KEY_PIVOT[1], KEY_PIVOT[2], KEY_PIVOT[3], rotateX(pose.keyAngle)),
		footL = about(0.4, HIP_Y, 0, rotateZ(pose.footSwing)),
		footR = about(0.4, HIP_Y, 0, rotateZ(-pose.footSwing)),
		-- Soles ride the ankle along the hip arc without tilting, so a swing can only lift them.
		soleL = translate(ANKLE_DROP * math.sin(pose.footSwing), ANKLE_DROP * (1 - math.cos(pose.footSwing)), 0),
		soleR = translate(ANKLE_DROP * math.sin(-pose.footSwing), ANKLE_DROP * (1 - math.cos(pose.footSwing)), 0),
	}
	local transforms = {}
	for _, part in DuckPose.parts do
		local p = part.position
		local localTransform = multiply(translate(p[1], p[2], p[3]), rotateZ(part.pitch or 0))
		transforms[part.name] = multiply(root, multiply(groups[part.group], localTransform))
	end
	return transforms
end

-- Follow camera: behind and to the +Z side, slightly above. Aiming below and ahead of the duck keeps it in the
-- upper-middle of the screen so the bottom HUD never covers it.
DuckPose.camera = table.freeze({
	offset = { -10, 5.2, 12 },
	lookAhead = { 6, 1.3, 0 },
	followRate = 6, -- 1/seconds, exponential smoothing
	fieldOfView = 70,
})

function DuckPose.cameraTarget(distanceStuds: number): ({ number }, { number })
	local camera = DuckPose.camera
	local eye = { distanceStuds + camera.offset[1], camera.offset[2], camera.offset[3] }
	local look = { distanceStuds + camera.lookAhead[1], camera.lookAhead[2], camera.lookAhead[3] }
	return eye, look
end

function DuckPose.smooth(current: { number }, target: { number }, deltaSeconds: number): { number }
	local alpha = 1 - math.exp(-DuckPose.camera.followRate * math.max(0, deltaSeconds))
	return {
		current[1] + (target[1] - current[1]) * alpha,
		current[2] + (target[2] - current[2]) * alpha,
		current[3] + (target[3] - current[3]) * alpha,
	}
end

export type Sampler = (snapshot: any, elapsedSeconds: number) -> (number, number, number)

-- Maps server attempt state plus elapsed times to a pose input, the duck's forward distance and the HUD wind
-- fraction. `sample` is AttemptRules.sample, injected so this module keeps no dependencies. Presentation may enter
-- the terminal phase a moment before the server's Ended message arrives; the server result stays authoritative.
function DuckPose.frame(
	state: string,
	snapshot: any,
	windupSeconds: number,
	sinceWindingSeconds: number,
	sinceReleaseSeconds: number?,
	sample: Sampler
): (PoseInput, number, number)
	if state == "Winding" or sinceReleaseSeconds == nil then
		local progress = clamp01(sinceWindingSeconds / windupSeconds)
		return {
			phase = "winding",
			phaseSeconds = sinceWindingSeconds,
			windupSeconds = windupSeconds,
			distanceStuds = 0,
			speedFraction = 0,
		},
			0,
			progress
	end
	local distance, speed, remaining = sample(snapshot, sinceReleaseSeconds)
	local ended = state == "Ended" or sinceReleaseSeconds >= snapshot.travelSeconds
	return {
		phase = if ended then "ended" else "running",
		phaseSeconds = if ended then sinceReleaseSeconds - snapshot.travelSeconds else sinceReleaseSeconds,
		windupSeconds = windupSeconds,
		distanceStuds = distance,
		speedFraction = if ended then 0 else speed / snapshot.topSpeedStudsPerSecond,
		outcome = snapshot.outcome,
	},
		distance,
		if ended then 0 else remaining
end

function DuckPose.resultDelaySeconds(outcome: string?): number
	return if outcome == "finished"
		then DuckPose.timing.resultDelayFinishedSeconds
		else DuckPose.timing.resultDelayExhaustedSeconds
end

return table.freeze(DuckPose)
