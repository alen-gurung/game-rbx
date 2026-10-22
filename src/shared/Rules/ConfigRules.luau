local ConfigRules = {}

local function finite(value: any): boolean
	return type(value) == "number" and value == value and math.abs(value) < math.huge
end

function ConfigRules.validate(attemptConfig: any, courseConfig: any): (boolean, { string })
	local errors = {}
	if type(attemptConfig) ~= "table" or type(courseConfig) ~= "table" then
		return false, { "configs must be tables" }
	end
	for _, name in { "windupSeconds", "baseWindSeconds", "topSpeedStudsPerSecond", "slowdownSeconds" } do
		if not finite(attemptConfig[name]) or attemptConfig[name] <= 0 then
			table.insert(errors, name .. " must be finite and positive")
		end
	end
	for _, name in { "starterPower", "windSecondsPerPower" } do
		if not finite(attemptConfig[name]) or attemptConfig[name] < 0 then
			table.insert(errors, name .. " must be finite and nonnegative")
		end
	end
	if type(courseConfig.id) ~= "string" or not string.find(courseConfig.id, "%S") then
		table.insert(errors, "course id must be nonempty")
	end
	if not finite(courseConfig.lengthStuds) or courseConfig.lengthStuds <= 0 then
		table.insert(errors, "lengthStuds must be finite and positive")
	end
	return #errors == 0, errors
end

return table.freeze(ConfigRules)
