extends RigidBody2D

class_name Crate

@export var depop_delay = 1.5
signal killme(id)
signal clicked(id)

@onready var timer = $Timer
@onready var launcher = $"../../Launch"
@onready var nine_patch_rect = $NinePatchRect

@onready var shock_wood_sound = $Sounds/Shock/Wood
@onready var shock_sound_cooldown = $ShockSoundCooldown
@onready var shock_composite = $Sounds/Shock/Composite

var prev_pos = null
var prev_rot = null
var launched = false
const epsilon = 2
const rot_epsilon = 1

var in_launch_area = false
var in_range_physic_tools: Array[PhysicsTool]

var hit = false

var crate_composite_sound: AudioStreamPlayer

func set_launch_area(v):
	in_launch_area = v
	if !in_launch_area:
		timer.start(depop_delay)

func thrown():
	$Sounds/Throw.play_random_sound()
	timer.start(depop_delay)
	launched = true
#	nine_patch_rect.modulate = Color(0.5, 0.5, 0.5, 1.0)

func _ready():
	in_range_physic_tools = []
	prev_pos = position
	self.connect("clicked", launcher.handle_click)
	self.connect("killme", launcher.kill_crate)
	
	if randi() % 2 == 0:
		var audio_player_i = randi() % shock_composite.get_child_count()
		crate_composite_sound = shock_composite.get_child(audio_player_i)

func _physics_process(delta):
	if !is_dying:
		for influence in in_range_physic_tools:
			influence.add_physics_modifier(self)
		# Keep alive if moving
		if (launched && prev_pos != null && prev_rot != null && ((prev_pos - position).length() > epsilon || prev_rot - rotation > rot_epsilon)):
			timer.start(depop_delay)
		if (global_position.y > 50):
			print("OOB kill")
			emit_signal("killme", self)
		prev_pos = position
		prev_rot = rotation

func _on_timer_timeout():
	print("inactivity timeout kill")
	suicide()
	
func suicide():
	if not is_dying:
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

func _on_body_entered(body):
	if shock_sound_cooldown.is_stopped():
		shock_sound_cooldown.start()
		shock_wood_sound.play_random_sound()
		if crate_composite_sound != null:
			crate_composite_sound.play_random_sound()

var is_dying = false

func destroy():
	if not is_dying:
		is_dying = true
		freeze = true
		$Sounds/Destroy.play_random_sound()
		var tween = create_tween()
		tween.tween_property(self, 'modulate:a', 0.0, 0.5)
		tween.tween_callback(queue_free)
