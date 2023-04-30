extends Control

@onready var level_label = $VBoxContainer/VBoxContainer/LevelNumber/LevelNumberValue
@onready var package_counter = $VBoxContainer/VBoxContainer/PackageCounter
@onready var package_counter_number = $VBoxContainer/VBoxContainer/PackageCounter/Number

var max_number

func update_package_counter(current_number):
	package_counter_number.text = str(current_number) + '/' + str(max_number)

func set_level_number(level_number):
	level_label.text = str(level_number + 1)

func go_to_challenge_phase(max_number):
	self.max_number = max_number
	update_package_counter(0)
	var tween = create_tween()
	tween.tween_property(package_counter, "modulate:a", 1.0, 2.0)

