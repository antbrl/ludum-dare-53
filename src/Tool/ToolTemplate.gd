extends Resource

class_name ToolTemplate

@export var texture : Texture2D
@export var tool_name : String
@export var tool_id: Globals.Tool
@export var directions: Array[Globals.Direction] = []
@export var scene: PackedScene


func get_texture():
	return texture 

func get_tool_name():
	return tool_name

func get_tool_id():
	return tool_id
