extends PhysicsTool

const PUSH_FORCE = 500
@onready var animation_player = $AnimationPlayer

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
		Globals.Direction.DOWN_LEFT:
			rotation_degrees = 315
		Globals.Direction.UP_LEFT:
			rotation_degrees = 45
		Globals.Direction.UP_RIGHT:
			rotation_degrees = 135
		Globals.Direction.DOWN_RIGHT:
			rotation_degrees = 225
		_:
			rotation_degrees = 0

func add_physics_modifier(crate: Crate):
	var forceVector = Vector2.UP.rotated(self.rotation)
	crate.apply_central_impulse(forceVector * PUSH_FORCE)
	animation_player.stop()
	animation_player.play("spring")
	$AudioPlayer.play_random_sound()

