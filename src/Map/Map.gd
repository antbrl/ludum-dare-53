extends Node2D

@onready var tile_map = $Navigation2D/TileMap

enum Layers {
	LANDSCAPE = 0,
	TOOLS = 1
}

func _ready():
	pass # Replace with function body.

func _process(delta):
	print(cell_under_mouse())

func cell_under_mouse():
	var mouse_cell = tile_map.local_to_map(tile_map.get_local_mouse_position())
	return tile_map.get_cell_tile_data(Layers.TOOLS, mouse_cell)
