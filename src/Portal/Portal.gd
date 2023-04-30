@tool

extends Node2D

@export var direction: Globals.Direction = Globals.Direction.NONE:
	get:
		return direction
	set(value):
		direction = value
		_update_placement()

func _update_placement():
	match direction:
		Globals.Direction.RIGHT:
			rotation_degrees = 180
		Globals.Direction.UP:
			rotation_degrees = 90
		Globals.Direction.DOWN:
			rotation_degrees = 270
		_:
			rotation_degrees = 0
