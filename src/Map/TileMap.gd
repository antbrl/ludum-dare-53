extends TileMap

@onready var middle_offset = tile_set.tile_size * 0.5

func get_mouse_cell() -> Vector2:
	return local_to_map(get_local_mouse_position())
	
func get_mouse_cell_data(layer: Globals.TileMapLayers) -> TileData:
	var mouse_cell = get_mouse_cell()
	return get_cell_tile_data(layer, mouse_cell)

func canBuildAtMouse(tool: Globals.Tool) -> bool:
	# Checks if another tool is already dropped on that tile
	var tool_cell = get_mouse_cell_data(Globals.TileMapLayers.TOOL)
	if tool_cell != null:
		return false
	
	# Checks if a wall is dropped at this cell and tool cannot be built on a wall
	var wall_cell = get_mouse_cell_data(Globals.TileMapLayers.STRUCTURE)
	if wall_cell != null && tool not in Globals.WallableTools:
		return false
	
	# Checks if a ground is dropped at this cell
	var ground_cell = get_mouse_cell_data(Globals.TileMapLayers.GROUND)
	if ground_cell != null:
		return false

	return true

func canDestroyAtMouse() -> bool:
	# Checks if another tool is already dropped on that tile
	var tool_cell = get_mouse_cell_data(Globals.TileMapLayers.TOOL)
	if tool_cell == null:
		return false
	return true

func _build(pos: Vector2, tool: Globals.Tool):
	set_cell(Globals.TileMapLayers.TOOL, pos, Globals.TileSetSources.TOOLS, Vector2(tool, 0))

func _destroy(pos: Vector2):
	print('DESTROYED')

func tryBuildAtMouse(tool: Globals.Tool):
	if not canBuildAtMouse(tool):
		return
	_build(get_mouse_cell(), tool)

func tryDestroyAtMouse():
	if not canDestroyAtMouse():
		return
	_destroy(get_mouse_cell())

func buildAtMouse(tool: Globals.Tool):
	assert(canBuildAtMouse(tool), 'Cannot build on that tile')
	_build(get_mouse_cell(), tool)

func destroyAtMouse():
	assert(canDestroyAtMouse(), 'Cannot destroy on that tile')
	_destroy(get_mouse_cell())
