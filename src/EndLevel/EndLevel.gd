extends Control

signal next_level

var level_number
var nb_coins

var total_crates
var hit_crates

@onready var level_label = $CenterContainer/VBoxContainer/CenterContainer/HBoxContainer/LevelNumber
@onready var coin_label = $CenterContainer/VBoxContainer/CenterContainer2/HBoxContainer2/CoinsNumber
@onready var result = $CenterContainer/VBoxContainer/CenterContainer2/Result
@onready var score_label = $CenterContainer/VBoxContainer/Score
@onready var comment_label = $CenterContainer/VBoxContainer/Comment
@onready var crate_icon = preload("res://src/HUD/crate_icon.tscn")

func _ready():
	assert(
		level_number != null,
		"init must be called before creating EndLevel scene"
	)
	level_label.text = str(level_number + 1)
	
	result.visible = false
	score_label.visible = false
	comment_label.visible = false
	
	for i in range(total_crates):
		var crate_icon_instance = crate_icon.instantiate()
		result.add_child(crate_icon_instance)

	score_label.text = str(0) + '/' + str(total_crates)
	
	var ratio = float(self.hit_crates) / float(self.total_crates)
	var comment
	if ratio == 1.0:
		comment = 'Perfect !!!'
	elif ratio > 0.75:
		comment = 'Awesome !'
	elif ratio > 0.5:
		comment = 'Ok'
	elif ratio > 0.25:
		comment = 'Apply yourself...'
	else:
		comment = "YOU'RE FIRED !"
	comment_label.text = comment
		
	var tween = create_tween()
	tween.tween_interval(0.8)
	tween.tween_callback(func(): result.visible = true; score_label.visible = true)
	for i in range(total_crates):
		var crate = result.get_child(i)
		tween.tween_interval(0.5)
		var node_name = "Hit" if i < hit_crates else "Miss"
		tween.tween_callback(func(): crate.get_node(node_name).visible = true)
		if i < hit_crates:
			tween.tween_callback(func(): score_label.text = str(i + 1) + '/' + str(total_crates))
	tween.tween_interval(0.5)
	tween.tween_callback(func(): comment_label.visible = true)

func init(level_number, total_crates, hit_crates):
	self.level_number = level_number
	self.total_crates = total_crates
	self.hit_crates = hit_crates

func _on_NextLevelButton_pressed():
	emit_signal("next_level")
