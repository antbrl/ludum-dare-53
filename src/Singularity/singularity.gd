extends PhysicsTool

class_name Singularity

const FAILURE_DISTANCE_SQ_THRESHOLD = 300

const modif = 5e5
const MAX_FORCE = Vector2(2e3, 2e3);


func add_physics_modifier(crate: Crate):
	var dir = self.position - crate.position
	var distance_sq = dir.length_squared()
	var force = modif * dir.normalized() / distance_sq
	force = force.clamp(-MAX_FORCE, MAX_FORCE)
	crate.apply_central_impulse(force)
	print('Force Applied')
	
	if distance_sq < FAILURE_DISTANCE_SQ_THRESHOLD:
		crate.suicide()

