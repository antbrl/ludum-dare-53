extends RigidBody2D

@export var depop_delay = 1.5
signal killme(id)

var prev_pos = null
var prev_rot = null
var launched = false

# Called when the node enters the scene tree for the first time.
func _ready():
	prev_pos = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var singularity: PhysicsTool = get_parent().get_parent().get_node("Singularity")
	singularity.add_physics_modifier(self)
	if (prev_pos != null && prev_rot != null && ((prev_pos - position).length() > .01 || prev_rot - rotation > .01)):
		$Timer.start(depop_delay)
	if (global_position.length() > 5000):
		print("OOB kill")
		emit_signal("killme", self)
	prev_pos = position
	prev_rot = rotation

func _on_timer_timeout():
	emit_signal("killme", self)
