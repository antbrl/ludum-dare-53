extends Node

signal end_of_level
signal game_over

var level_number
var mode = Globals.DEFAULT_MODE

@onready var hud = $UI/HUD
@onready var truck = $Map/Truck
@onready var map = $Map

@onready var action_ui = $UI/ActionUI
@onready var templates = $ToolTemplates
@onready var tools_dict = {
	Globals.Tool.TRAMPOLINE: $ToolTemplates/Trampoline,
	Globals.Tool.PORTAL: $ToolTemplates/Portal
}

var tools_quantity

func _ready():
	assert(level_number != null, "init must be called before creating Level scene")
	hud.set_level_number(level_number)
	truck.connect("crate_dropped", end_level)
	
	for tool in tools_dict.keys():
		var tool_template = tools_dict.get(tool)
		
		var quantity = tools_quantity.get(tool, 0)
		
		tool_template.init(quantity)
		print(tool_template)
	action_ui.init(templates.get_children())

func init(level_number, tools_quantity):
	self.level_number = level_number
	self.tools_quantity = tools_quantity

func end_level():
	emit_signal("end_of_level")

func _on_hud_mode_change(mode):
	map.switch_mode(mode)

func _on_map_tool_built(tool, pos, metadata):
	var tool_template = tools_dict.get(tool)
	assert(tool_template, 'No tool template associated to tool ' + str(tool))
	tool_template.quantity -= 1


func _on_map_tool_destroyed(tool, pos):
	var tool_template = tools_dict.get(tool)
	assert(tool_template, 'No tool template associated to tool ' + str(tool))
	tool_template.quantity += 1
