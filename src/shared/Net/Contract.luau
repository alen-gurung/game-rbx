export type AttemptState = {
	seq: number,
	state: string,
	attemptId: number?,
	courseId: string?,
	power: number?,
	snapshot: any?,
	windupSeconds: number?,
	windingServerTime: number?,
	releaseServerTime: number?,
	outcome: string?,
	distance: number?,
	cancelled: boolean?,
}

return table.freeze({
	folderName = "DuckAttemptRemotes",
	messages = table.freeze({
		RequestSync = table.freeze({
			direction = "C2S",
			payload = "nil",
			states = { "Ready", "Winding", "Running", "Ended" },
			rateLimitSeconds = 0.2,
		}),
		RequestLaunch = table.freeze({
			direction = "C2S",
			payload = "nil",
			states = { "Ready" },
			rateLimitSeconds = 0.2,
		}),
		RequestRetry = table.freeze({
			direction = "C2S",
			payload = "{attemptId: finite integer}",
			states = { "Ended" },
			rateLimitSeconds = 0.2,
		}),
		RequestCancel = table.freeze({
			direction = "C2S",
			payload = "{attemptId: finite integer}",
			states = { "Winding", "Running" },
			rateLimitSeconds = 0.2,
		}),
		AttemptState = table.freeze({
			direction = "S2C",
			payload = "AttemptState",
			states = { "Ready", "Winding", "Running", "Ended" },
			rateLimitSeconds = 0.2,
		}),
	}),
})
