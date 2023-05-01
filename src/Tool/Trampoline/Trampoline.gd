extends PhysicsTool

const PUSH_FORCE = 500

@onready var animation_player = $"../AnimationPlayer"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_physics_modifier(crate: Crate):
	var forceVector = Vector2.UP.rotated(self.rotation)
	crate.apply_central_impulse(forceVector * PUSH_FORCE)
	animation_player.stop()
	animation_player.play("spring")

