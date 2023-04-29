extends Control

signal mode_change(mode: Globals.Mode)

@onready var level_label = $VBoxContainer/VBoxContainer/LevelNumber/LevelNumberValue
var mode = Globals.DEFAULT_MODE

func set_level_number(level_number):
	level_label.text = str(level_number + 1)

func _on_switch_mode_button_pressed():
	if mode == Globals.Mode.THROW:
		mode = Globals.Mode.CONSTRUCTION
	else:
		mode = Globals.Mode.THROW
	emit_signal("mode_change", mode)
