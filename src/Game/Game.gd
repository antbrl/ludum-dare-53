extends Node

signal end_of_level
signal game_over

var level_number
var mode = Globals.DEFAULT_MODE

@onready var hud = $UI/HUD
@onready var action_ui = $UI/ActionUI

@onready var map = $Map
@onready var target = $Map/Target

var map_scene

func _ready():
	self.map = self.map.create_instance(true, map_scene)
	self.target = map.get_node("Target")

	assert(level_number != null, "init must be called before creating Level scene")
	hud.set_level_number(level_number)
	target.connect("crate_dropped", end_level)
	
	action_ui.init(map)

func init(level_number, map: PackedScene):
	self.map_scene = map
	self.level_number = level_number

func end_level():
	emit_signal("end_of_level")

func _on_tool_selected(tool_template):
	map.update_tool(tool_template)

func _on_action_ui_mode_change(mode):
	map.switch_mode(mode)
