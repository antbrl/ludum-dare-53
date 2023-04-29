extends Node2D

@onready var tool_ghost = $Navigation2D/ToolGhost
@onready var tile_map = $Navigation2D/TileMap
var mode = Globals.DEFAULT_MODE

func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("build"):
		if mode == Globals.Mode.CONSTRUCTION:
			tile_map.tryBuildAtMouse(0)
	elif event.is_action_pressed("destroy"):
		if mode == Globals.Mode.CONSTRUCTION:
			tile_map.tryDestroyAtMouse()

func switch_mode(_mode: Globals.Mode):
	mode = _mode
	tool_ghost.visible = mode == Globals.Mode.CONSTRUCTION

func build_tool():
	var mouse_cell = tile_map.get_mouse_cell_data()

func destroy_tool():
	pass
