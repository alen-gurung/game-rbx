--!strict
-- Builds the local Part duck from DuckPose.parts and applies DuckPose transforms. Cosmetic and non-colliding.
local DuckPose = require(script.Parent.DuckPose)

export type DuckModel = {
	model: Model,
	setPose: (self: DuckModel, pose: DuckPose.Pose, distanceStuds: number) -> (),
	destroy: (self: DuckModel) -> (),
}

local DuckModel = {}

function DuckModel.new(parent: Instance, origin: CFrame): DuckModel
	local model = Instance.new("Model")
	model.Name = "WindUpDuck"
	local parts: { [string]: BasePart } = {}
	for _, spec in DuckPose.parts do
		local part = Instance.new("Part")
		part.Name = spec.name
		part.Shape = (Enum.PartType :: any)[spec.shape]
		part.Size = Vector3.new(spec.size[1], spec.size[2], spec.size[3])
		part.Color = Color3.fromRGB(spec.color[1], spec.color[2], spec.color[3])
		part.Material = (Enum.Material :: any)[spec.material]
		part.TopSurface = Enum.SurfaceType.Smooth
		part.BottomSurface = Enum.SurfaceType.Smooth
		part.Anchored = true
		part.CanCollide = false
		part.CanQuery = false
		part.CanTouch = false
		part.CastShadow = true
		part.Parent = model
		parts[spec.name] = part
	end
	model.Parent = parent

	local self = { model = model } :: any

	function self.setPose(_: DuckModel, pose: DuckPose.Pose, distanceStuds: number)
		for name, m in DuckPose.partTransforms(pose, distanceStuds) do
			local part = parts[name]
			if part then
				part.CFrame = origin
					* CFrame.new(m[1], m[2], m[3], m[4], m[5], m[6], m[7], m[8], m[9], m[10], m[11], m[12])
			end
		end
	end

	function self.destroy(_: DuckModel)
		model:Destroy()
	end

	return self :: DuckModel
end

return DuckModel
