extends PhysicsTool

@onready var input: Node2D = $Input
@onready var output: Node2D = $Output
@onready var direction = input.global_position.direction_to(output.global_position)

const modif = 5e6
const MAX_FORCE = Vector2(2e3, 2e3)
const DETECTION_RADIUS = 20
@export var OUTPUT_VELOCITY = 600
func add_physics_modifier(crate: Crate):
	var dir = input.global_position - crate.position
	var distance = dir.length()
	var entering = distance <= DETECTION_RADIUS
	if entering:
		crate.position = output.global_position + direction * 8
		crate.linear_velocity = direction * OUTPUT_VELOCITY
	else:
		var force = modif * dir.normalized() / distance
		force = force.clamp(-MAX_FORCE, MAX_FORCE)
		crate.apply_central_impulse(force)

