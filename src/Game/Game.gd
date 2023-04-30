extends Node

signal end_of_level
signal game_over

var level_number
var mode = Globals.DEFAULT_MODE
var phase = Globals.Phase.TRIAL

var challenge_crates_left = 5
var challenge_score = 0

@onready var hud = $UI/HUD
@onready var action_ui = $UI/ActionUI
@onready var popup = $UI/Popup

@onready var map = $Map

var map_scene

func _ready():
	self.map = self.map.create_instance(true, map_scene)
	var target = map.get_node("Target")
	var launcher = map.get_node("Launch")

	assert(level_number != null, "init must be called before creating Level scene")
	hud.set_level_number(level_number)
	target.connect("crate_dropped", crate_dropped)
	launcher.connect("crate_killed", crate_killed)
	
	action_ui.init(map)

func init(level_number, map: PackedScene):
	self.map_scene = map
	self.level_number = level_number

func crate_dropped():
	if phase == Globals.Phase.TRIAL:
		go_to_challenge_phase()
	else:
		challenge_score += 1
		hud.update_package_counter(challenge_score)

func crate_killed():
	if phase == Globals.Phase.CHALLENGE:
		challenge_crates_left -= 1
		if challenge_crates_left == 0:
			emit_signal("end_of_level")

func go_to_challenge_phase():
	popup.pop_message('Now, 5 packages in a row', 3.0)
	phase = Globals.Phase.CHALLENGE
	action_ui.go_to_challenge_phase()
	hud.go_to_challenge_phase(challenge_crates_left)

func _on_tool_selected(tool_template):
	map.update_tool(tool_template)

func _on_action_ui_mode_change(mode):
	map.switch_mode(mode)
