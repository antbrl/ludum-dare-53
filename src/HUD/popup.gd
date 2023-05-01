extends Control

@onready var panel = $Panel
@onready var label = $Panel/Label

func _ready():
	modulate.a = 0

func pop_message(message: String, time: float):
	label.text = message
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1, 1.0)
	tween.tween_interval(time)
	tween.tween_property(self, "modulate:a", 0, 1.0)
