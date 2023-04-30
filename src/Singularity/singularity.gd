extends PhysicsTool

class_name Singularity

const FAILURE_DISTANCE_SQ_THRESHOLD = 300



const modif = 5e5
const MAX_FORCE = Vector2(2e3, 2e3);
const MINIMUM_NEGLIGEABLE_FORCE = 10;

func update_influence_radius():
	var infuence_area: CircleShape2D = self.get_node("InfluenceArea").get_shape()
	infuence_area.set_radius(sqrt(modif/MINIMUM_NEGLIGEABLE_FORCE))
	

func _ready():
	print("Singularity appears...")
	update_influence_radius()


func add_physics_modifier(crate: Crate):
	var dir = self.position - crate.position
	var distance_sq = dir.length_squared()
	var force = modif * dir.normalized() / distance_sq
	force = force.clamp(-MAX_FORCE, MAX_FORCE)
	crate.apply_central_impulse(force)
	print('Force Applied')
	
	if distance_sq < FAILURE_DISTANCE_SQ_THRESHOLD:
		crate.suicide()

