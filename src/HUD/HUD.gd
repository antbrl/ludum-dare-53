extends Control

@onready var level_label = $VBoxContainer/VBoxContainer/LevelNumber/LevelNumberValue

func set_level_number(level_number):
	level_label.text = str(level_number + 1)
