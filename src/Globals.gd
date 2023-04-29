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
	WALLS = 0,
	TOOLS = 1,
	COSMETIC = 2
}
