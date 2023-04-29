extends TileMap

@onready var middle_offset = tile_set.tile_size * 0.5

func get_mouse_cell() -> Vector2:
	return local_to_map(get_local_mouse_position())
	
func get_mouse_cell_data(layer: Globals.TileMapLayers) -> TileData:
	var mouse_cell = get_mouse_cell()
	return get_cell_tile_data(layer, mouse_cell)

func canBuildAtMouse(tool: Globals.Tool) -> bool:
	# Checks if another tool is already dropped on that tile
	var tool_cell = get_mouse_cell_data(Globals.TileMapLayers.TOOLS)
	if tool_cell == null:
		return false
	
	# Checks if a wall is dropped at this cell and tool cannot be built on a wall
	var wall_cell = get_mouse_cell_data(Globals.TileMapLayers.WALLS)
	if wall_cell != null && tool not in Globals.WallableTools:
		return false
	return true

func canDestroyAtMouse() -> bool:
	# Checks if another tool is already dropped on that tile
	var tool_cell = get_mouse_cell_data(Globals.TileMapLayers.TOOLS)
	if tool_cell == null:
		return false
	return true

func _build(pos: Vector2, tool: Globals.Tool):
	pass

func _destroy(pos: Vector2):
	pass

func tryBuildAtMouse(tool: Globals.Tool):
	if not canBuildAtMouse(tool):
		return
	_build(get_mouse_cell(), tool)

func tryDestroyAtMouse(tool: Globals.Tool):
	if not canDestroyAtMouse():
		return
	_destroy(get_mouse_cell())

func buildAtMouse(tool: Globals.Tool):
	assert(canBuildAtMouse(tool), 'Cannot build on that tile')
	_build(get_mouse_cell(), tool)

func destroyAtMouse():
	assert(canDestroyAtMouse(), 'Cannot destroy on that tile')
	_destroy(get_mouse_cell())
