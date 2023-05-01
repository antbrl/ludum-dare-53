extends StaticBody2D

const VELOCITY = 128

@export var direction: Globals.Direction = Globals.Direction.NONE:
	get:
		return direction
	set(value):
		direction = value
		_update_placement()

func _update_placement():
	var modif: int
	match direction:
		Globals.Direction.RIGHT:
			modif = -1
		_:
			modif = 1
	self.constant_linear_velocity = Vector2.RIGHT * VELOCITY * modif
	$AnimatedSprite2D.scale = Vector2(modif, 1)

func _ready():
	_update_placement()
