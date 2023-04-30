extends Control

@onready var label = $Label

func pop_message(message: String, time: float):
	label.text = message
	modulate.a = 0
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1, 1.0)
	tween.tween_interval(time)
	tween.tween_property(self, "modulate:a", 0, 1.0)
