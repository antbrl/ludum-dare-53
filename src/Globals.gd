extends Node

@onready var game_settings = preload("res://src/Game/game_settings.tres")
@onready var tile_set = preload("res://assets/tileset/tileset.tres")

func get_tool_template(tool: Globals.Tool) -> ToolTemplate:
	for t in game_settings.tool_templates:
		if t.tool_id == tool:
			return t
	return null

func get_tool_tile_coords(tool: Globals.Tool, direction = Globals.Direction.NONE):
	var source = tile_set.get_source(Globals.TileSetSources.TOOL)
	var best_atlas_coords = null
	for tile_index in source.get_tiles_count():
		var atlas_coords = source.get_tile_id(tile_index)
		var tile_data = source.get_tile_data(atlas_coords, 0)
		if tile_data != null and tile_data.get_custom_data('tool') == tool:
			best_atlas_coords = atlas_coords
			for alt_index in source.get_alternative_tiles_count(atlas_coords):
				var alt_tile = source.get_alternative_tile_id(atlas_coords, alt_index)
				tile_data = source.get_tile_data(atlas_coords, alt_tile)
				print(tile_data.get_custom_data('direction'), ' ', direction)
				if tile_data.get_custom_data('direction') == direction:
					return [atlas_coords, alt_tile]
	return [best_atlas_coords, 0]

func get_tool_next_direction(tool: Globals.Tool, direction: Globals.Direction) -> Globals.Direction:
	var directions = get_tool_template(tool).directions
	if directions.is_empty():
		return direction
	var index = directions.find(direction)
	if index == -1:
		return directions[0]
	return directions[(index + 1) % directions.size()]

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
