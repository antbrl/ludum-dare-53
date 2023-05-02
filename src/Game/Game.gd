extends Node

signal end_of_level(total_crates: int, hit_crates: int, remaining_tools: int)
signal game_over

var level_number
var mode = Globals.DEFAULT_MODE
var phase = Globals.Phase.TRIAL

var challenge_crates_left
var challenge_score = 0
var challenge_start_time = null
var challenge_duration = null

@onready var hud = $UI/HUD
@onready var action_ui = $UI/ActionUI
@onready var popup = $UI/Popup
@onready var viewport = $"../../"
@onready var time_panel = $UI/HUD/TimePanel
@onready var time_label = $UI/HUD/TimePanel/Label

@onready var map = $Map

var map_scene

var hit_crates = []

var welcome_textbox_displayed

func _ready():
	self.map = self.map.create_instance(true, map_scene)
	self.challenge_crates_left = map.n_challenge_crates
	if map.level_name == '':
		assert(false, 'Level name not defined in map')
	var target = map.get_node("Target")
	var launcher = map.get_node("Launch")

	assert(level_number != null, "init must be called before creating Level scene")

	target.connect("crate_dropped", crate_dropped)
	launcher.connect("crate_killed", crate_killed)
	launcher.connect("crate_followed_by_cam", crate_followed_by_cam)
	
	if level_number == 0:
		show_textbox('Welcome', 'Your job is to deliver crates to the customer.\nYou are now in TRIAL PHASE, meaning you can build tools to help you reach the customer.\nOnce you will reach the customer once, you will enter to CHALLENGE PHASE')
		welcome_textbox_displayed = true
	else:
		end_init()

func end_init():
	action_ui.init(map)
	hud.init(map.n_challenge_crates)
	popup.pop_message('Level ' + str(level_number + 1) + '\n' + map.level_name, 3.0)


func _process(delta):
	if (challenge_start_time != null):
		var challenge_time = Time.get_ticks_msec() - challenge_start_time
		var ms = str(challenge_time%1000)
		while ms.length() < 3:
			ms = ms + '0'
		time_label.text = str(floor(challenge_time/1000)) + '\'' + ms

func init(level_number, map: PackedScene):
	self.map_scene = map
	self.level_number = level_number

func crate_dropped(crate):
	if hit_crates.find(crate) != -1:
		return

	hit_crates.push_back(crate)
	$Hit.play_random_sound()
	if phase == Globals.Phase.TRIAL:
		go_to_challenge_phase()
	else:
		hud.hit()
		challenge_score += 1

func crate_killed(crate):
	if not crate.hit:
		$Miss.play_random_sound()

	action_ui.set_reset_crates_disabled(true)
	if phase == Globals.Phase.CHALLENGE:
		challenge_crates_left -= 1
		if challenge_crates_left == -1:
			challenge_duration = Time.get_ticks_msec() - challenge_start_time
			challenge_start_time = null 
			trigger_end_level_cutscene()
		
		if not crate.hit:
			hud.miss()

func crate_followed_by_cam(crate):
	action_ui.set_reset_crates_disabled(false)

func trigger_end_level_cutscene():
	var tween = create_tween()
	tween.tween_interval(1.0)
	tween.tween_property(viewport, 'modulate:a', 0, 1.0)
	tween.tween_interval(0.2)
	tween.tween_callback(_end_level)

func _end_level():
	viewport.modulate.a = 1
	emit_signal("end_of_level", map.n_challenge_crates, challenge_score, map.count_remaining_tools(), challenge_duration)

func go_to_challenge_phase():
	if level_number == 0:
		show_textbox('Congratulations !', 'By delivering a dummy crate to the customer, you know enter CHALLENGE PHASE. You will now have to throw 5 crates in a row.\nThe more you can deliver, the higher your score ! Good luck')
	popup.pop_message('Entering challenge mode', 3.0)
	time_panel.visible = true
	phase = Globals.Phase.CHALLENGE
	action_ui.go_to_challenge_phase()
	hud.go_to_challenge_phase()
	challenge_start_time = Time.get_ticks_msec()

func _on_tool_selected(tool_template):
	map.update_tool(tool_template)

func _on_action_ui_mode_change(mode):
	map.switch_mode(mode)

func _on_action_ui_reset_crates():
	map.reset_crates()

func _on_action_ui_reset_tools():
	map.reset_tools()

func show_textbox(title: String, message: String):
	$UI/TextBox.pop_text_box(title, message)	

func _on_text_box_popup_closed():
	if welcome_textbox_displayed:
		welcome_textbox_displayed = false
		end_init()
