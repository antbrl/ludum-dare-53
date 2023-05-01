extends Node

@onready var game_settings = preload("res://src/Game/game_settings.tres")

func get_tool_template(tool: Globals.Tool) -> ToolTemplate:
	for t in game_settings.tool_templates:
		if t.tool_id == tool:
			return t
	return null

func get_tool_whitelist_layer(tool: Globals.Tool):
	match tool:
		Globals.Tool.PORTAL:
			return Globals.TileMapLayers.TOOL_WHITELIST_PORTAL
		Globals.Tool.TRAMPOLINE:
			return Globals.TileMapLayers.TOOL_WHITELIST_TRAMPOLINE
		Globals.Tool.SINGULARITY:
			return Globals.TileMapLayers.TOOL_WHITELIST_SINGULARITY
		Globals.Tool.VACUUM:
			return Globals.TileMapLayers.TOOL_WHITELIST_VACUUM
		Globals.Tool.BELT:
			return Globals.TileMapLayers.TOOL_WHITELIST_BELT
		_:
			assert(false, 'Missing tool')

enum Phase {
	TRIAL = 0,
	CHALLENGE = 1
}

enum Mode {
	THROW = 0,
	CONSTRUCTION = 1,
	CINEMATIC = 2
}

const DEFAULT_MODE = Mode.THROW

enum Tool {
	NONE = 0,
	PORTAL = 1,
	TRAMPOLINE = 2,
	SINGULARITY = 3,
	VACUUM = 4,
	BELT = 5,
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
	TOOL_WHITELIST_SINGULARITY = 7,
	TOOL_OVERLAY = 8,
	TOOL_WHITELIST_VACUUM = 9,
	TOOL_WHITELIST_BELT = 10,
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
	DOWN = 4,
	DOWN_LEFT = 5,
	UP_LEFT = 6,
	UP_RIGHT = 7,
	DOWN_RIGHT = 8,
}
