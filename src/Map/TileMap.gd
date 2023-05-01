extends TileMap

signal build_tool(tool: Globals.Tool, pos: Vector2i, metadata: Dictionary)
signal destroy_tool(tool: Globals.Tool, pos: Vector2i)

@onready var middle_offset = tile_set.tile_size * 0.5

func _ready():
	set_layer_enabled(Globals.TileMapLayers.TOOL, false)
	set_layer_enabled(Globals.TileMapLayers.TOOL_WHITELIST_PORTAL, false)
	set_layer_enabled(Globals.TileMapLayers.TOOL_WHITELIST_SINGULARITY, false)
	set_layer_enabled(Globals.TileMapLayers.TOOL_WHITELIST_TRAMPOLINE, false)
	set_layer_enabled(Globals.TileMapLayers.TOOL_WHITELIST_BELT, false)
	set_layer_enabled(Globals.TileMapLayers.TOOL_WHITELIST_VACUUM, false)

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
	var layer = Globals.get_tool_whitelist_layer(tool)
	var data = get_cell_tile_data(layer, pos)
	if data == null:
		return null
	return {
		data = data,
		atlas_coords = get_cell_atlas_coords(layer, pos),
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
	var tool = tool_cell.get_custom_data('tool')
	assert(tool != 0, 'Missing cell data')
	destroy_tool.emit(tool, pos)

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

func update_tool_overlay(mode: Globals.Mode, tool: Globals.Tool) -> void:
	clear_layer(Globals.TileMapLayers.TOOL_OVERLAY)
	if mode != Globals.Mode.CONSTRUCTION:
		return
	for cell in get_used_cells_by_id(Globals.TileMapLayers.TOOL):
		set_cell(Globals.TileMapLayers.TOOL_OVERLAY, cell, Globals.TileSetSources.TOOL, Vector2i(1, 3))
	for cell in get_used_cells_by_id(Globals.get_tool_whitelist_layer(tool)):
		var tool_template = Globals.get_tool_template(tool)
		var tool_template_data: TileData = get_tool_template_data(cell, tool).data
		var atlas_coords = Vector2i(1, 3)
		if can_build_on_cell(cell, tool):
			match tool_template_data.get_custom_data('direction'):
				Globals.Direction.DOWN:
					atlas_coords = Vector2i(2, 2)
				Globals.Direction.RIGHT:
					atlas_coords = Vector2i(2, 3)
				Globals.Direction.LEFT:
					atlas_coords = Vector2i(3, 2)
				Globals.Direction.UP:
					atlas_coords = Vector2i(3, 3)
				Globals.Direction.DOWN_LEFT:
					atlas_coords = Vector2i(0, 4)
				Globals.Direction.UP_LEFT:
					atlas_coords = Vector2i(1, 4)
				Globals.Direction.UP_RIGHT:
					atlas_coords = Vector2i(3, 4)
				Globals.Direction.DOWN_RIGHT:
					atlas_coords = Vector2i(2, 4)
				_:
					atlas_coords = Vector2i(0, 3)
		elif  tool_template.directions.size() > 1:
			if tool_template.directions.size() == 2:
				atlas_coords = Vector2i(2, 1)
			else:
				atlas_coords = Vector2i(3, 1)
		set_cell(Globals.TileMapLayers.TOOL_OVERLAY, cell, Globals.TileSetSources.TOOL, atlas_coords)

func destroy_all_tools():
	for cell in get_used_cells(Globals.TileMapLayers.TOOL):
		_destroy(cell)
