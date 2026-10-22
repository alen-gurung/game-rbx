--!strict
-- Builds Workspace.DuckTestStrip from TestStripSpec. Replaces only a previous folder carrying this builder's ownership
-- attribute and never touches the baseplate, lighting or other authored content.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Layout = require(Shared.World.TestStripLayout)
local Course = require(Shared.Config.Course)
local TestStripSpec = require(script.Parent.TestStripSpec)

local FOLDER_NAME = "DuckTestStrip"
local OWNER = "GAME-001"

local TestStripBuilder = {}

local function color(rgb: { number }): Color3
	return Color3.fromRGB(rgb[1], rgb[2], rgb[3])
end

function TestStripBuilder.build(): Folder
	for _, child in workspace:GetChildren() do
		if child.Name == FOLDER_NAME and child:GetAttribute("OwnedBy") == OWNER then
			child:Destroy()
		end
	end
	local folder = Instance.new("Folder")
	folder.Name = FOLDER_NAME
	folder:SetAttribute("OwnedBy", OWNER)
	for _, spec in TestStripSpec.parts(Layout, Course.lengthStuds) do
		local part = Instance.new(spec.className) :: BasePart
		part.Name = spec.name
		part.Size = Vector3.new(spec.size[1], spec.size[2], spec.size[3])
		part.Position = Vector3.new(spec.position[1], spec.position[2], spec.position[3])
		part.Color = color(spec.color)
		part.Material = (Enum.Material :: any)[spec.material]
		part.TopSurface = Enum.SurfaceType.Smooth
		part.BottomSurface = Enum.SurfaceType.Smooth
		part.Anchored = true
		part.CanCollide = spec.canCollide
		part.CanTouch = spec.className == "SpawnLocation"
		if part:IsA("SpawnLocation") then
			part.Neutral = true
			part.Duration = 0
		end
		local label = spec.label
		if label then
			local gui = Instance.new("SurfaceGui")
			gui.Face = (Enum.NormalId :: any)[label.face]
			gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
			gui.PixelsPerStud = 50
			gui.LightInfluence = 0
			local text = Instance.new("TextLabel")
			text.Size = UDim2.fromScale(1, 1)
			text.BackgroundTransparency = 1
			text.Text = label.text
			text.TextScaled = true
			text.Font = Enum.Font.FredokaOne
			text.TextColor3 = color(label.textColor)
			text.Parent = gui
			gui.Parent = part
		end
		part.Parent = folder
	end
	folder.Parent = workspace
	return folder
end

return TestStripBuilder
