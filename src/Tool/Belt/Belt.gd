extends StaticBody2D

@export var leftwards = true

const VELOCITY = 128

func _ready():
	var modif = -1 if leftwards else 1
	self.constant_linear_velocity = Vector2.RIGHT * VELOCITY * modif
	$AnimatedSprite2D.scale = Vector2(modif, 1)
