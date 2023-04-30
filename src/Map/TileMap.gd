extends TileMap

signal build_tool(tool: Globals.Tool, pos: Vector2i, metadata: Dictionary)
signal destroy_tool(tool: Globals.Tool, pos: Vector2i)

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
	var data = get_cell_tile_data(layer, pos)
	if data == null:
		return null
	return {
		data = data,
		atlas_coords = get_cell_atlas_coords(layer, pos)
	}

func _build(pos: Vector2i, tool: Globals.Tool):
	var tool_template_data = get_tool_template_data(pos, tool)
	set_cell(Globals.TileMapLayers.TOOL, pos, Globals.TileSetSources.TOOL, tool_template_data.atlas_coords)
	var tile_data: TileData = tool_template_data.data
	var metadata = {
		direction = tile_data.get_custom_data('direction')
	}
	build_tool.emit(tool, pos, metadata)

func _destroy(pos: Vector2i):
	var tool_cell = get_cell_tile_data(Globals.TileMapLayers.TOOL, pos)
	set_cell(Globals.TileMapLayers.TOOL, pos, -1, Vector2i(-1, -1))
	destroy_tool.emit(tool_cell.get_custom_data('tool'), pos)

func try_build_at_mouse(tool: Globals.Tool) -> bool:
	var pos = get_mouse_cell()
	if not can_build_on_cell(pos, tool):
		return false
	_build(pos, tool)
	return true

func try_destroy_at_mouse() -> bool:
	var pos = get_mouse_cell()
	if not can_destroy_on_cell(pos):
		return false
	_destroy(pos)
	return true
