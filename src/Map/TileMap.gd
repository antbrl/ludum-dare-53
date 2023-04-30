extends TileMap

@onready var middle_offset = tile_set.tile_size * 0.5

func get_mouse_cell() -> Vector2i:
	return local_to_map(get_local_mouse_position())

func can_build_on_cell(pos: Vector2i, tool: Globals.Tool) -> bool:
	# Checks if cell is whitelisted
	var tool_template_data = get_tool_template_data(pos, tool)
	if tool_template_data == null:
		return false
	
	# Checks if another tool is already dropped on that tile
	var tool_cell = get_cell_tile_data(Globals.TileMapLayers.TOOL, pos)
	if tool_cell != null:
		return false

	return true

func can_destroy_on_cell(pos: Vector2i) -> bool:
	# Checks if another tool is already dropped on that tile
	var tool_cell = get_cell_tile_data(Globals.TileMapLayers.TOOL, pos)
	if tool_cell == null:
		return false
	return true

func get_tool_template_data(pos: Vector2i, tool: Globals.Tool):
	var layer: Globals.TileMapLayers
	match tool:
		Globals.Tool.PORTAL:
			layer = Globals.TileMapLayers.TOOL_WHITELIST_PORTAL
		Globals.Tool.TRAMPOLINE:
			layer = Globals.TileMapLayers.TOOL_WHITELIST_TRAMPOLINE
		_:
			return null
	return {
		data = get_cell_tile_data(layer, pos),
		atlas_coords = get_cell_atlas_coords(layer, pos)
	}

func _build(pos: Vector2i, tool: Globals.Tool):
	var tool_template_data = get_tool_template_data(pos, tool)
	set_cell(Globals.TileMapLayers.TOOL, pos, Globals.TileSetSources.TOOL, tool_template_data.atlas_coords)

func _destroy(pos: Vector2i):
	set_cell(Globals.TileMapLayers.TOOL, pos, -1, Vector2i(-1, -1))

func try_build_at_mouse(tool: Globals.Tool):
	var pos = get_mouse_cell()
	if not can_build_on_cell(pos, tool):
		return
	_build(pos, tool)

func try_destroy_at_mouse():
	var pos = get_mouse_cell()
	if not can_destroy_on_cell(pos):
		return
	_destroy(pos)
