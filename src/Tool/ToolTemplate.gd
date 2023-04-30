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

func init(_available: bool, _quantity: int):
	available = _available
	quantity = _quantity

func get_quantity():
	return quantity

func set_quantity(_quantity: int):
	quantity = _quantity

func get_texture():
	return texture 
