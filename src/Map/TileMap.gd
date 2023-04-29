extends TileMap

@onready var middle_offset = tile_set.tile_size * 0.5

func get_mouse_cell() -> Vector2:
	return local_to_map(get_local_mouse_position())

func can_build_on_cell(pos: Vector2, tool: Globals.Tool) -> bool:
	# Checks if cell is whitelisted
	var tool_template_data = get_tool_template_data(pos, tool)
	if tool_template_data == null:
		return false
	
	# Checks if another tool is already dropped on that tile
	var tool_cell = get_cell_tile_data(Globals.TileMapLayers.TOOL, pos)
	if tool_cell != null:
		return false
	
#	# Checks if a wall is dropped at this cell and tool cannot be built on a wall
#	var wall_cell = get_cell_tile_data(Globals.TileMapLayers.STRUCTURE, pos)
#	if wall_cell != null && tool not in Globals.WallableTools:
#		return false
#
#	# Checks if a ground is dropped at this cell
#	var ground_cell = get_cell_tile_data(Globals.TileMapLayers.GROUND, poss)
#	if ground_cell != null:
#		return false

	return true

func can_destroy_on_cell(pos: Vector2) -> bool:
	# Checks if another tool is already dropped on that tile
	var tool_cell = get_cell_tile_data(Globals.TileMapLayers.TOOL, pos)
	if tool_cell == null:
		return false
	return true

func get_tool_template_data(pos: Vector2, tool: Globals.Tool):
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

func _build(pos: Vector2, tool: Globals.Tool):
	var tool_template_data = get_tool_template_data(pos, tool)
	if tool_template_data == null:
		return
	
#	var cell_data = (tool_template_data.data as TileData)
	set_cell(Globals.TileMapLayers.TOOL, pos, Globals.TileSetSources.TOOL, tool_template_data.atlas_coords)

func _destroy(pos: Vector2):
	print('DESTROYED')

func tryBuildAtMouse(tool: Globals.Tool):
	var pos = get_mouse_cell()
	if not can_build_on_cell(pos, tool):
		return
	_build(pos, tool)

func tryDestroyAtMouse():
	var pos = get_mouse_cell()
	if not can_destroy_on_cell(pos):
		return
	_destroy(pos)

func buildAtMouse(tool: Globals.Tool):
	var pos = get_mouse_cell()
	assert(can_build_on_cell(pos, tool), 'Cannot build on that tile')
	_build(pos, tool)

func destroyAtMouse():
	var pos = get_mouse_cell()
	assert(can_destroy_on_cell(pos), 'Cannot destroy on that tile')
	_destroy(pos)
