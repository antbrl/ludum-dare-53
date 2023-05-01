extends PhysicsTool

const PUSH_FORCE = 200

@onready var animation_player = $"../AnimationPlayer"

var forceVector: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	forceVector = Vector2(0, -1)
#	animation_player.play("RESET")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_physics_modifier(crate: Crate):
	print('Force Applied')
	crate.apply_central_impulse(forceVector * PUSH_FORCE)
	animation_player.stop()
	animation_player.play("spring")

