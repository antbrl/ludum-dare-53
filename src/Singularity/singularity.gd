extends PhysicsTool


class_name Singularity

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var FAILURE_DISTANCE_SQ_THRESHOLD = 10
var FAILURE_VELOCITY_SQ_THRESHOLD = 4

var modif = 2e5
func add_physics_modifier(crate: RigidBody2D):
	var dir = self.position - crate.position
	var distance_sq = dir.length_squared()
	var force = modif * dir.normalized() / distance_sq
	crate.apply_central_impulse(force)
	
	if distance_sq < FAILURE_DISTANCE_SQ_THRESHOLD && crate.linear_velocity.length_squared() < FAILURE_VELOCITY_SQ_THRESHOLD:
		print('Perdu') # TODO ?

