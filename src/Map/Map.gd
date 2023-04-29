extends Node2D

@onready var tool_ghost = $Navigation2D/ToolGhost

func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

func switch_mode(mode: Globals.Mode):
	tool_ghost.visible = mode == Globals.Mode.CONSTRUCTION
