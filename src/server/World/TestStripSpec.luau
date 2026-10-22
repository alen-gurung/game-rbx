--!strict
-- Engine-free description of the GAME-001 test strip. TestStripBuilder instantiates it, and tools/preview.luau renders
-- the same list. Positions are part centers in world studs; colors are RGB 0-255.
export type StripPart = {
	name: string,
	className: string, -- "Part" | "SpawnLocation"
	size: { number },
	position: { number },
	color: { number },
	material: string,
	canCollide: boolean,
	label: { text: string, face: string, textColor: { number } }?,
}

local WOOD = { 222, 190, 140 }
local WOOD_LINE = { 168, 132, 92 }
local WHITE = { 246, 246, 240 }
local BLACK = { 30, 30, 34 }
local PAD = { 96, 164, 226 }
local SIGN = { 54, 70, 96 }
local ARCH = { 236, 84, 72 }

local TestStripSpec = {}

function TestStripSpec.parts(layout: any, lengthStuds: number): { StripPart }
	local y = layout.surfaceY
	local z = layout.centerZ
	local x0 = layout.startX
	local width = layout.widthStuds
	local half = width / 2
	local parts: { StripPart } = {}
	local function add(part: StripPart)
		table.insert(parts, part)
	end

	add({
		name = "StartPad",
		className = "Part",
		size = { 14, y, width + 6 },
		position = { x0 - 9, y / 2, z },
		color = PAD,
		material = "SmoothPlastic",
		canCollide = true,
	})
	add({
		name = "Spawn",
		className = "SpawnLocation",
		size = { 5, 0.2, 5 },
		position = { x0 - 11, y + 0.1, z },
		color = PAD,
		material = "SmoothPlastic",
		canCollide = true,
	})
	add({
		name = "Strip",
		className = "Part",
		size = { lengthStuds + 8, y, width },
		position = { x0 + lengthStuds / 2 + 2, y / 2, z },
		color = WOOD,
		material = "WoodPlanks",
		canCollide = true,
	})
	for _, side in { 1, -1 } do
		add({
			name = if side > 0 then "RailNear" else "RailFar",
			className = "Part",
			size = { lengthStuds + 8, 0.5, 0.4 },
			position = { x0 + lengthStuds / 2 + 2, y + 0.25, z + side * (half + 0.2) },
			color = WHITE,
			material = "SmoothPlastic",
			canCollide = false,
		})
	end
	add({
		name = "StartLine",
		className = "Part",
		size = { 0.5, 0.05, width },
		position = { x0, y + 0.025, z },
		color = WHITE,
		material = "SmoothPlastic",
		canCollide = false,
	})

	local spacing = layout.markerSpacingStuds
	local marker = spacing
	while marker < lengthStuds do
		add({
			name = "Line" .. marker,
			className = "Part",
			size = { 0.3, 0.05, width },
			position = { x0 + marker, y + 0.025, z },
			color = WOOD_LINE,
			material = "SmoothPlastic",
			canCollide = false,
		})
		add({
			name = "Sign" .. marker,
			className = "Part",
			size = { 2.6, 1.6, 0.25 },
			position = { x0 + marker, y + 1.6, z - half - 1.2 },
			color = SIGN,
			material = "SmoothPlastic",
			canCollide = false,
			label = { text = tostring(marker), face = "Back", textColor = WHITE },
		})
		add({
			name = "Post" .. marker,
			className = "Part",
			size = { 0.3, 0.8, 0.3 },
			position = { x0 + marker, y + 0.4, z - half - 1.2 },
			color = SIGN,
			material = "SmoothPlastic",
			canCollide = false,
		})
		marker += spacing
	end

	-- Finish: a checkered band at the scored course end, framed by an arch wide of the duck's path.
	local cells = width
	for row = 0, 1 do
		for cell = 0, cells - 1 do
			add({
				name = "Check" .. row .. "_" .. cell,
				className = "Part",
				size = { 1, 0.06, 1 },
				position = { x0 + lengthStuds - 0.5 + row, y + 0.03, z - half + 0.5 + cell },
				color = if (row + cell) % 2 == 0 then WHITE else BLACK,
				material = "SmoothPlastic",
				canCollide = false,
			})
		end
	end
	for _, side in { 1, -1 } do
		add({
			name = if side > 0 then "ArchNear" else "ArchFar",
			className = "Part",
			size = { 0.8, 9, 0.8 },
			position = { x0 + lengthStuds, y + 4.5, z + side * (half + 1) },
			color = ARCH,
			material = "SmoothPlastic",
			canCollide = true,
		})
	end
	add({
		name = "ArchBanner",
		className = "Part",
		size = { 0.4, 1.8, width + 2.8 },
		position = { x0 + lengthStuds, y + 9, z },
		color = ARCH,
		material = "SmoothPlastic",
		canCollide = false,
		label = { text = "FINISH", face = "Left", textColor = WHITE },
	})
	return parts
end

return table.freeze(TestStripSpec)
