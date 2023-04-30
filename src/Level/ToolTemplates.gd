extends Node

signal new_tool

# Called when the node enters the scene tree for the first time.
func _ready():
	for tool_template in get_children():
		emit_signal("new_tool", tool_template)
