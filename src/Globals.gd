extends Node

enum Mode {
	THROW = 0,
	CONSTRUCTION = 1
}

const DEFAULT_MODE = Mode.THROW

enum Tool {
	NONE = 0,
	PORTAL = 1,
	TRAMPOLINE = 2,
}

const DEFAULT_TOOL = Tool.TRAMPOLINE

enum TileMapLayers {
	BACKGROUND = 0,
	STRUCTURE = 1,
	GROUND = 2,
	DETAILS = 3,
	TOOL = 4,
	TOOL_WHITELIST_PORTAL = 5,
	TOOL_WHITELIST_TRAMPOLINE = 6,
}

enum TileSetSources {
	TOOL = 0,
	ALL = 1,
	BACKGROUND = 2,
}

enum Direction {
	NONE = 0,
	LEFT = 1,
	UP = 2,
	RIGHT = 3,
	BOTTOM = 4,
}
