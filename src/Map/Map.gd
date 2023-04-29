extends Node2D

@onready var tool_ghost = $Navigation2D/ToolGhost
var mode = Globals.DEFAULT_MODE

func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("build"):
		if mode == Globals.Mode.CONSTRUCTION:
			build_tool()
	elif event.is_action_pressed("destroy"):
		if mode == Globals.Mode.CONSTRUCTION:
			destroy_tool()
func switch_mode(_mode: Globals.Mode):
	mode = _mode
	tool_ghost.visible = mode == Globals.Mode.CONSTRUCTION

func build_tool():
	pass

func destroy_tool():
	pass
