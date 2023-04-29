extends Control

signal mode_change(mode: Globals.Mode)

@onready var level_label = $VBoxContainer/VBoxContainer/LevelNumber/LevelNumberValue
@onready var switch_mode_button = $VBoxContainer/VBoxContainer/VBoxContainer/SwitchModeButton
var mode = Globals.DEFAULT_MODE

func set_level_number(level_number):
	level_label.text = str(level_number + 1)

func _on_switch_mode_button_pressed():
	if mode == Globals.Mode.THROW:
		switch_mode(Globals.Mode.CONSTRUCTION)
	else:
		switch_mode(Globals.Mode.THROW)

func switch_mode(_mode: Globals.Mode):
	mode = _mode
	if mode == Globals.Mode.THROW:
		switch_mode_button.text = 'Construction mode'
	else:
		switch_mode_button.text = 'Throw mode'
	emit_signal("mode_change", mode)
