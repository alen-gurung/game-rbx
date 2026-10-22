-- World placement of the GAME-001 test strip (presentation layout, not balance). The strip runs along +X from the
-- start line; scored length comes from Config/Course. Studs.
return table.freeze({
	startX = 0, -- start line
	surfaceY = 0.4, -- strip top; the baseplate top is at Y = 0
	centerZ = 0,
	widthStuds = 10,
	markerSpacingStuds = 10,
})
