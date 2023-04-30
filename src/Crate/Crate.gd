extends RigidBody2D

@export var depop_delay = 1.5
signal killme(id)
signal clicked(id)

var prev_pos = null
var prev_rot = null
var launched = false
const epsilon = 2
const rot_epsilon = 1

var in_launch_area = false

func set_launch_area(v):
	in_launch_area = v
	if in_launch_area:
		$Timer.stop()
	else:
		$Timer.start(depop_delay)

# Called when the node enters the scene tree for the first time.
func _ready():
	prev_pos = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var singularity: PhysicsTool = get_parent().get_parent().get_node("Singularity")
	singularity.add_physics_modifier(self)
	if (!in_launch_area && prev_pos != null && prev_rot != null && ((prev_pos - position).length() > epsilon || prev_rot - rotation > rot_epsilon)):
		$Timer.start(depop_delay)
	if (global_position.length() > 5000):
		print("OOB kill")
		emit_signal("killme", self)
	prev_pos = position
	prev_rot = rotation

func _on_timer_timeout():
	emit_signal("killme", self)

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			emit_signal("clicked", self)
