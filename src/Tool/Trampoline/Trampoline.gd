extends PhysicsTool

const PUSH_FORCE = 200

var forceVector: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	forceVector = Vector2(0, -1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_physics_modifier(crate: Crate):
	print('Force Applied')
	crate.apply_central_impulse(forceVector * PUSH_FORCE)

