extends RigidBody2D

class_name Crate

@export var depop_delay = 1.5
signal killme(id)
signal clicked(id)

@onready var timer = $Timer
@onready var launcher = $"../../Launch"

var prev_pos = null
var prev_rot = null
var launched = false
const epsilon = 2
const rot_epsilon = 1

var in_launch_area = false
var in_range_physic_tools: Array[PhysicsTool]

var hit = false

func set_launch_area(v):
	in_launch_area = v
	if !in_launch_area:
		timer.start(depop_delay)

func thrown():
	timer.start(depop_delay)
	launched = true
	get_node("Sprite2D").modulate = Color(0.5, 0.5, 0.5, 1.0)

func _ready():
	in_range_physic_tools = []
	prev_pos = position
	self.connect("clicked", launcher.handle_click)
	self.connect("killme", launcher.kill_crate)

func _physics_process(delta):
	for influence in in_range_physic_tools:
		influence.add_physics_modifier(self)
	# Keep alive if moving
	if (launched && prev_pos != null && prev_rot != null && ((prev_pos - position).length() > epsilon || prev_rot - rotation > rot_epsilon)):
		timer.start(depop_delay)
	if (global_position.length() > 5000):
		print("OOB kill")
		emit_signal("killme", self)
	prev_pos = position
	prev_rot = rotation

func _on_timer_timeout():
	print("inactivity timeout kill")
	suicide()
	
func suicide():
	emit_signal("killme", self)

func _on_input_event(viewport, event, shape_idx):
	if !launched && in_launch_area && event is InputEventMouseButton:
		if event.is_pressed():
			emit_signal("clicked", self)


func _on_detection_area_entered(area):
	in_range_physic_tools.append(area)
	print('Object Entered')


func _on_detection_area_exited(area):
	in_range_physic_tools.erase(area)
	print('Object Left')
