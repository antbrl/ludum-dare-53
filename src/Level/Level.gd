extends Node

signal end_of_level
signal game_over

var level_number
var mode = Globals.DEFAULT_MODE

@onready var hud = $UI/HUD
@onready var truck = $Map/Truck
@onready var map = $Map

@onready var tools_dict = {
	Globals.Tool.TRAMPOLINE: $ToolTemplates/Trampoline,
	Globals.Tool.PORTAL: $Map/Tools/Trampoline
}

func _ready():
	assert(level_number != null, "init must be called before creating Level scene")
	hud.set_level_number(level_number)
	truck.connect("crate_dropped", end_level)

func init(level_number, nb_coins):
	self.level_number = level_number
	

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
