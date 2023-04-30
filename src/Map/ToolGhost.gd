extends Node2D

@onready var sprite = $Sprite
@onready var hover_hint = $HoverHint
@onready var map = $"../"
@onready var tile_map = $"../TileMap"
@onready var mouse_cell = tile_map.get_mouse_cell()

func _ready():
	visible = Globals.DEFAULT_MODE == Globals.Mode.CONSTRUCTION

func _process(delta):
	var new_mouse_cell = tile_map.get_mouse_cell()
	if mouse_cell != new_mouse_cell:
		update()
	
	sprite.position = position

func update():
	var new_mouse_cell = tile_map.get_mouse_cell()

	# Mouse on new cell
	var tween = create_tween()
	tween.tween_property(self, "position", tile_map.map_to_local(new_mouse_cell), 0.05)
	mouse_cell = new_mouse_cell

	sprite.modulate = Color(1, 1, 1, 0.45)
	if not tile_map.can_build_on_cell(mouse_cell, map.current_tool):
		sprite.modulate = Color(0.92, 0, 0.14, 0.45)

func tool_changed(tool_texture: Texture2D):
	sprite.texture = tool_texture
	hover_hint.set_position(sprite.get_rect().position)
	hover_hint.set_size(sprite.get_rect().size)
