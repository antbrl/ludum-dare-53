extends Node2D

@onready var sprite = $Sprite
@onready var hover_hint = $HoverHint
@onready var map = $"../"
@onready var tile_map = $"../TileMap"
@onready var mouse_cell = tile_map.get_mouse_cell()
@onready var preview = $Preview

var tool_template: ToolTemplate


func set_tool_template(value):
	tool_template = value
	var instance = tool_template.scene.instantiate()
#	instance.process_mode = PROCESS_MODE_DISABLED
	for node in preview.get_children():
		preview.remove_child(node)
		node.queue_free()
	preview.add_child(instance)
	_update_hover_hint()

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
	
	if tile_map.get_cell_tile_data(Globals.TileMapLayers.TOOL_OVERLAY, mouse_cell) == null or tile_map.get_cell_tile_data(Globals.TileMapLayers.TOOL, mouse_cell) != null:
		preview.modulate = Color(1, 1, 1, 0)
		return
	
	var node = preview.get_child(0)
	if node != null and tool_template != null:
		var tile_data_dict = tile_map.get_tool_template_data(mouse_cell, tool_template.tool_id)
		var direction = Globals.Direction.DOWN
		if tile_data_dict != null:
			var tile_data: TileData = tile_data_dict.data
			direction = tile_data.get_custom_data('direction')
		node.direction = direction

	preview.modulate = Color(1, 1, 1, 0.45)
	if not tile_map.can_build_on_cell(mouse_cell, map.current_tool):
		preview.modulate = Color(0.92, 0, 0.14, 0.45)

func _update_hover_hint():
	pass
#	sprite.texture = tool_texture
#	hover_hint.set_position(sprite.get_rect().position)
#	hover_hint.set_size(sprite.get_rect().size)
#	hover_hint.set_position(preview.get_rect().position)
#	hover_hint.set_size(preview.get_rect().size)
