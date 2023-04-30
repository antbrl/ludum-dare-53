extends RigidBody2D

@export var depop_delay = 1.5
signal killme(id)
signal clicked(id)

@onready var timer = $Timer

var prev_pos = null
var prev_rot = null
var launched = false
const epsilon = 2
const rot_epsilon = 1

var in_launch_area = false

func set_launch_area(v):
	in_launch_area = v
	if !in_launch_area:
		timer.start(depop_delay)

func thrown():
	timer.start(depop_delay)
	launched = true
	get_node("Sprite2D").modulate = Color(0.5, 0.5, 0.5, 1.0)

func _ready():
	prev_pos = position

func _physics_process(delta):
	var singularity: PhysicsTool = get_parent().get_parent().get_node("Singularity")
	singularity.add_physics_modifier(self)
	# Keep alive if moving
	if (launched && prev_pos != null && prev_rot != null && ((prev_pos - position).length() > epsilon || prev_rot - rotation > rot_epsilon)):
		timer.start(depop_delay)
	if (global_position.length() > 5000):
		print("OOB kill")
		emit_signal("killme", self)
	prev_pos = position
	prev_rot = rotation

func _on_timer_timeout():
	print("inactivity kill")
	emit_signal("killme", self)

func _on_input_event(viewport, event, shape_idx):
	if !launched && in_launch_area && event is InputEventMouseButton:
		if event.is_pressed():
			emit_signal("clicked", self)
