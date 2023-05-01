extends Control

signal next_level

var level_number
var nb_coins

var total_crates
var hit_crates
var remaining_tools
var challenge_time

@onready var level_label = $CenterContainer/HBoxContainer/VBoxContainer/HBoxContainer/LevelNumber
@onready var result = $CenterContainer/HBoxContainer/VBoxContainer/Result
@onready var score_label = $CenterContainer/HBoxContainer/VBoxContainer/Score
@onready var bonus_label = $CenterContainer/HBoxContainer/VBoxContainer/Bonus
@onready var time_label = $CenterContainer/HBoxContainer/VBoxContainer/TimeLabel
@onready var comment_label = $CenterContainer/HBoxContainer/VBoxContainer/Comment
@onready var crate_icon = preload("res://src/HUD/crate_icon.tscn")

func _ready():
	assert(
		level_number != null,
		"init must be called before creating EndLevel scene"
	)
	level_label.text = str(level_number + 1)
	
	result.modulate.a = 0
	score_label.modulate.a = 0
	comment_label.modulate.a = 0
	bonus_label.modulate.a = 0
	time_label.modulate.a = 0
	
	for i in range(total_crates):
		var crate_icon_instance = crate_icon.instantiate()
		result.add_child(crate_icon_instance)

	score_label.text = str(0) + '/' + str(total_crates)
	
	var ratio = float(self.hit_crates) / float(self.total_crates)
	var comment
	var clap_index = null
	if ratio == 1.0:
		comment = 'Perfect!!!'
		clap_index = 2
	elif ratio > 0.75:
		comment = 'Awesome!'
		clap_index = 1
	elif ratio > 0.5:
		comment = 'Ok'
		clap_index = 0
	elif ratio > 0.25:
		comment = 'Focus...'
	else:
		comment = "Seriously?"
	comment_label.text = comment
	
	bonus_label.text = 'Bonus: +' + str(remaining_tools) + ' (unused items)'
	
	time_label.text = 'Challenge time: +' + str(floor(challenge_time/1000)) + '\'' + str(challenge_time%1000)
	
	var tween = create_tween()
	tween.tween_interval(0.8)
	tween.tween_callback(func(): result.modulate.a = 1; score_label.modulate.a = 1)
	for i in range(total_crates):
		var crate = result.get_child(i)
		tween.tween_interval(0.5)
		var node_name = "Hit" if i < hit_crates else "Miss"
		var sound_player = $Sounds/Hit if i < hit_crates else $Sounds/Miss
		tween.tween_callback(func(): crate.get_node(node_name).visible = true; sound_player.play())
		if i < hit_crates:
			tween.tween_callback(func(): score_label.text = str(i + 1) + '/' + str(total_crates))
	tween.tween_interval(0.9)
	tween.tween_callback(func(): bonus_label.modulate.a = 1)
	tween.tween_interval(0.9)
	tween.tween_callback(func(): time_label.modulate.a = 1)
	tween.tween_interval(0.9)
	tween.tween_callback(func(): comment_label.modulate.a = 1; $Sounds/Result.play(); if clap_index != null: $Sounds/Clap.play_sound(clap_index))
  
func init(level_number, total_crates, hit_crates, remaining_tools, challenge_time):
	self.level_number = level_number
	self.total_crates = total_crates
	self.hit_crates = hit_crates
	self.remaining_tools = remaining_tools
	self.challenge_time = challenge_time

func _on_NextLevelButton_pressed():
	emit_signal("next_level")
