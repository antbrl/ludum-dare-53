extends Node2D

signal tool_built(tool: Globals.Tool)
signal tool_destroyed(tool: Globals.Tool)

@onready var tool_ghost = $ToolGhost
@onready var tile_map = $TileMap
@onready var launch_area = $Launch

var mode = Globals.DEFAULT_MODE
var current_tool = Globals.DEFAULT_TOOL

func _ready():
	launch_area.init($Crates/Crate)

func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("build"):
		if mode == Globals.Mode.CONSTRUCTION:
			if tile_map.try_build_at_mouse(current_tool):
				emit_signal("tool_built", current_tool)
				tool_ghost.update()
	elif event.is_action_pressed("destroy"):
		if mode == Globals.Mode.CONSTRUCTION:
			if tile_map.try_destroy_at_mouse():
				emit_signal("tool_destroyed", current_tool)
				tool_ghost.update()

func switch_mode(_mode: Globals.Mode):
	mode = _mode
	tool_ghost.visible = mode == Globals.Mode.CONSTRUCTION
