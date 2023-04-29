extends Node

enum Mode {
	THROW = 0,
	CONSTRUCTION = 1
}

const DEFAULT_MODE = Mode.THROW

enum Tool {
	TRAMPOLINE = 0
}

const WallableTools: Array[Tool] = []

enum TileMapLayers {
	BACKGROUND = 0,
	STRUCTURE = 1,
	GROUND = 2,
	DETAILS = 3,
	TOOL = 4
}

enum TileSetSources {
	ALL = 1,
	BACKGROUND = 2,
	TOOLS = 3
}
