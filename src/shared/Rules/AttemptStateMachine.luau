export type State = "Ready" | "Winding" | "Running" | "Ended"

local transitions = {
	Ready = { Launch = "Winding" },
	Winding = { WindupDone = "Running", Cancel = "Ready" },
	Running = { TravelDone = "Ended", Cancel = "Ready" },
	Ended = { Retry = "Ready" },
}
local AttemptStateMachine = {}

function AttemptStateMachine.transition(state: string, event: string): (boolean, string, string?)
	local events = transitions[state]
	local target = if events then events[event] else nil
	if not target then
		return false, state, "invalid transition: " .. state .. " / " .. event
	end
	return true, target, nil
end

return table.freeze(AttemptStateMachine)
