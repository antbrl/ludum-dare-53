extends Node

signal end_of_level
signal game_over

var level_number
var mode = Globals.DEFAULT_MODE
var phase = Globals.Phase.TRIAL
var challenge_crates_left = 5

@onready var hud = $UI/HUD
@onready var action_ui = $UI/ActionUI

@onready var map = $Map

var map_scene

func _ready():
	self.map = self.map.create_instance(true, map_scene)
	var target = map.get_node("Target")

	assert(level_number != null, "init must be called before creating Level scene")
	hud.set_level_number(level_number)
	target.connect("crate_dropped", crate_dropped)
	
	action_ui.init(map)

func init(level_number, map: PackedScene):
	self.map_scene = map
	self.level_number = level_number

func crate_dropped():
	if phase == Globals.Phase.TRIAL:
		go_to_challenge_phase()
	else:
		challenge_crates_left -= 1
		if challenge_crates_left == 0:
			emit_signal("end_of_level")

func go_to_challenge_phase():
	phase = Globals.Phase.CHALLENGE

func _on_tool_selected(tool_template):
	map.update_tool(tool_template)

func _on_action_ui_mode_change(mode):
	map.switch_mode(mode)
