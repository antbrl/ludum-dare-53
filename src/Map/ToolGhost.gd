extends Sprite2D

@onready var tile_map = $"../TileMap"
@onready var mouse_cell = tile_map.get_mouse_cell()

func _ready():
	visible = Globals.DEFAULT_MODE == Globals.Mode.CONSTRUCTION

func _process(delta):
	var new_mouse_cell = tile_map.get_mouse_cell()
	if mouse_cell != new_mouse_cell:
		var tween = create_tween()
		tween.tween_property(self, "position", tile_map.map_to_local(new_mouse_cell), 0.05)
	mouse_cell = new_mouse_cell
