extends Sprite2D

@onready var tile_map = $"../TileMap"

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_cell = tile_map.get_mouse_cell()
	position = tile_map.map_to_local(mouse_cell)
