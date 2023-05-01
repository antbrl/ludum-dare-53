extends Node

signal end_of_level(total_crates: int, hit_crates: int)
signal game_over

var level_number
var mode = Globals.DEFAULT_MODE
var phase = Globals.Phase.TRIAL

var challenge_crates_left
var challenge_score = 0

@onready var hud = $UI/HUD
@onready var action_ui = $UI/ActionUI
@onready var popup = $UI/Popup
@onready var viewport = $"../../"

@onready var map = $Map

var map_scene

var hit_crates = []

func _ready():
	self.map = self.map.create_instance(true, map_scene)
	var target = map.get_node("Target")
	var launcher = map.get_node("Launch")

	assert(level_number != null, "init must be called before creating Level scene")

	target.connect("crate_dropped", crate_dropped)
	launcher.connect("crate_killed", crate_killed)
	
	self.challenge_crates_left = map.n_challenge_crates
	
	action_ui.init(map)
	hud.init(self.level_number, self.challenge_crates_left)

func init(level_number, map: PackedScene):
	self.map_scene = map
	self.level_number = level_number

func crate_dropped(crate):
	if hit_crates.find(crate) != -1:
		return

	hit_crates.push_back(crate)
	if phase == Globals.Phase.TRIAL:
		go_to_challenge_phase()
	else:
		hud.hit()
		challenge_score += 1

func crate_killed(crate):
	if phase == Globals.Phase.CHALLENGE:
		challenge_crates_left -= 1
		if challenge_crates_left == -1:
			trigger_end_level_cutscene()
		
		if not crate.hit:
			hud.miss()

func trigger_end_level_cutscene():
	var tween = create_tween()
	tween.tween_interval(1.0)
	tween.tween_property(viewport, 'modulate:a', 0, 1.0)
	tween.tween_interval(0.2)
	tween.tween_callback(_end_level)

func _end_level():
	viewport.modulate.a = 1
	emit_signal("end_of_level", map.n_challenge_crates, challenge_score)

func go_to_challenge_phase():
	popup.pop_message('Now, 5 packages in a row', 3.0)
	phase = Globals.Phase.CHALLENGE
	action_ui.go_to_challenge_phase()
	hud.go_to_challenge_phase()

func _on_tool_selected(tool_template):
	map.update_tool(tool_template)

func _on_action_ui_mode_change(mode):
	map.switch_mode(mode)
