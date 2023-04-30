extends Node

class_name ToolTemplate

@export var tool_id: int
@export var texture : Texture2D
@export var tool_name : String
@export var tool: Resource # Tool instance scene tempolate

var available: bool
var quantity : int

func _ready():
	pass

func init(quantity: int):
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
