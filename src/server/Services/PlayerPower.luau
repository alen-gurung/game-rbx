local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config.Attempt)
local powers: { [Player]: number } = {}
local PlayerPower = {}

function PlayerPower.read(player: Player): number
	if powers[player] == nil then
		powers[player] = Config.starterPower
	end
	if RunService:IsStudio() then
		local override = player:GetAttribute("DevPower")
		if type(override) == "number" and override == override and override >= 0 and override <= 10000 then
			return override
		end
	end
	return powers[player]
end

function PlayerPower.remove(player: Player)
	powers[player] = nil
end

return PlayerPower
