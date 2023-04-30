extends Node

class_name ToolTemplate

@export var texture : Texture2D
@export var tool_name : String

var tool_id: int
var available: bool
var quantity : int

func _ready():
	pass

func init(tool_id: int, quantity: int):
	self.tool_id = tool_id
	self.quantity = quantity
	self.available = quantity > 0

func get_quantity():
	return quantity

func set_quantity(_quantity: int):
	quantity = _quantity

func get_texture():
	return texture 

func get_tool_name():
	return tool_name
