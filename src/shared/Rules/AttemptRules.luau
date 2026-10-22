export type Snapshot = {
	power: number,
	windSeconds: number,
	slowdownSeconds: number,
	topSpeedStudsPerSecond: number,
	lengthStuds: number,
	fullSpeedSeconds: number,
	uncappedDistanceStuds: number,
	travelSeconds: number,
	distanceStuds: number,
	outcome: string,
}
local AttemptRules = {}

function AttemptRules.snapshot(power: number, config: any, course: any): Snapshot
	assert(type(power) == "number" and power == power and power >= 0 and power < math.huge, "invalid power")
	local windSeconds = config.baseWindSeconds + power * config.windSecondsPerPower
	assert(windSeconds > 0 and windSeconds < math.huge, "invalid wind duration")
	local slowdownSeconds = config.slowdownSeconds
	local topSpeed = config.topSpeedStudsPerSecond
	local fullSeconds = math.max(0, windSeconds - slowdownSeconds)
	local rampSeconds = math.min(windSeconds, slowdownSeconds)
	local fullDistance = topSpeed * fullSeconds
	local total = fullDistance + topSpeed * rampSeconds * rampSeconds / (2 * slowdownSeconds)
	local travelSeconds = windSeconds
	local finished = total >= course.lengthStuds
	if finished then
		if course.lengthStuds <= fullDistance then
			travelSeconds = course.lengthStuds / topSpeed
		else
			local rampDistance = course.lengthStuds - fullDistance
			local discriminant = math.max(0, rampSeconds * rampSeconds - 2 * slowdownSeconds * rampDistance / topSpeed)
			local rampTravel = (2 * slowdownSeconds * rampDistance / topSpeed) / (rampSeconds + math.sqrt(discriminant))
			travelSeconds = fullSeconds + rampTravel
		end
	end
	return table.freeze({
		power = power,
		windSeconds = windSeconds,
		slowdownSeconds = slowdownSeconds,
		topSpeedStudsPerSecond = topSpeed,
		lengthStuds = course.lengthStuds,
		fullSpeedSeconds = fullSeconds,
		uncappedDistanceStuds = total,
		travelSeconds = travelSeconds,
		distanceStuds = math.min(total, course.lengthStuds),
		outcome = if finished then "finished" else "exhausted",
	})
end

function AttemptRules.sample(snapshot: Snapshot, elapsedSeconds: number): (number, number, number)
	local elapsed = math.clamp(elapsedSeconds, 0, snapshot.travelSeconds)
	local fullElapsed = math.min(elapsed, snapshot.fullSpeedSeconds)
	local rampElapsed = math.max(0, elapsed - snapshot.fullSpeedSeconds)
	local rampStart = math.min(snapshot.windSeconds, snapshot.slowdownSeconds)
	local distance = snapshot.topSpeedStudsPerSecond
		* (fullElapsed + (rampStart * rampElapsed - rampElapsed * rampElapsed / 2) / snapshot.slowdownSeconds)
	local remaining = math.clamp((snapshot.windSeconds - elapsed) / snapshot.windSeconds, 0, 1)
	local speed = snapshot.topSpeedStudsPerSecond
		* math.min(1, (snapshot.windSeconds - elapsed) / snapshot.slowdownSeconds)
	if elapsedSeconds >= snapshot.travelSeconds then
		distance = snapshot.distanceStuds
		speed = 0
	end
	return math.clamp(distance, 0, snapshot.lengthStuds), math.max(0, speed), remaining
end

return table.freeze(AttemptRules)
