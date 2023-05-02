extends Control

signal popup_hidden()

@onready var panel = $Panel
@onready var label = $Panel/HBoxContainer/Label

func _ready():
	modulate.a = 0

func pop_message(message: String, time: float):
	label.text = message
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1, 1.0)
	tween.tween_interval(time)
	tween.tween_property(self, "modulate:a", 0, 1.0)
	tween.tween_callback(_end_pop)

func _end_pop():
	emit_signal("popup_hidden")
