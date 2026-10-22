local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Contract = require(ReplicatedStorage.Shared.Net.Contract)
local Remotes = {}

function Remotes.create(): { [string]: RemoteEvent }
	assert(not ReplicatedStorage:FindFirstChild(Contract.folderName), "Attempt remote folder already exists")
	local folder = Instance.new("Folder")
	folder.Name = Contract.folderName
	local events = {}
	for name in Contract.messages do
		local event = Instance.new("RemoteEvent")
		event.Name = name
		event.Parent = folder
		events[name] = event
	end
	folder.Parent = ReplicatedStorage
	return events
end

return Remotes
