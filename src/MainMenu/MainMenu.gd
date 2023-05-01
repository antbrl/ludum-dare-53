extends Control

signal start_game
signal select_level
signal show_credits
signal quit_game


func _on_Start_pressed():
	emit_signal("start_game")
	queue_free()

func _on_level_selection_pressed():
	emit_signal("select_level")
	queue_free()

func _on_Credits_pressed():
	emit_signal("show_credits")
	queue_free()

func _on_Quit_pressed():
	emit_signal("quit_game")
	queue_free()
