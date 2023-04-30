extends PhysicsTool

class_name Singularity

const FAILURE_DISTANCE_SQ_THRESHOLD = 20
const FAILURE_VELOCITY_SQ_THRESHOLD = 4

const modif = 2e5
const MAX_VELOCITY = Vector2(500, 500);


func add_physics_modifier(crate: Crate):
	var dir = self.position - crate.position
	var distance_sq = dir.length_squared()
	var force = modif * dir.normalized() / distance_sq
	force = force.clamp(-MAX_VELOCITY, MAX_VELOCITY)
	crate.apply_central_impulse(force)
	
	if distance_sq < FAILURE_DISTANCE_SQ_THRESHOLD && crate.linear_velocity.length_squared() < FAILURE_VELOCITY_SQ_THRESHOLD:
		crate.suicide()
		print("singularity kill")

