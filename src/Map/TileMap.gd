extends TileMap

@onready var middle_offset = tile_set.tile_size * 0.5

enum Layers {
	LANDSCAPE = 0,
	TOOLS = 1
}

func get_mouse_cell() -> Vector2:
	return local_to_map(get_local_mouse_position())
	
func get_mouse_cell_data(layer: Layers) -> TileData:
	var mouse_cell = get_mouse_cell()
	return get_cell_tile_data(layer, mouse_cell)
