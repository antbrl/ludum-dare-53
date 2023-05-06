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

var prev_pos = null
var prev_rot = null
var launched = false
const epsilon = 2
const rot_epsilon = 1

const max_speed = 1400.0
const max_rot = 1000.0

var in_launch_area = false
var in_range_physic_tools: Array[PhysicsTool]

var hit = false

var crate_main_sound: AudioStreamPlayer
var crate_composite_sound: AudioStreamPlayer

func set_launch_area(v):
	in_launch_area = v
	if !in_launch_area:
		timer.start(depop_delay)

func play_throw_sound():
	$Sounds/Throw.play_random_sound()	

func thrown():
	timer.start(depop_delay)
	launched = true
#	nine_patch_rect.modulate = Color(0.5, 0.5, 0.5, 1.0)

enum CrateSkin {
	WOOD = 0,
	FRAGILE = 1,
	HUMAN = 2,
	PQ = 3,
	HOLED = 4,
	PACKAGE = 5
}

var SkinAtlasRegion = {
	CrateSkin.WOOD: Rect2(0, 0, 32, 32),
	CrateSkin.FRAGILE: Rect2(32, 0, 32, 32),
	CrateSkin.HUMAN: Rect2(64, 0, 32, 32),
	CrateSkin.PQ: Rect2(0, 32, 32, 32),
	CrateSkin.HOLED: Rect2(32, 32, 32, 32),
	CrateSkin.PACKAGE: Rect2(64, 32, 32, 32),
}

@onready var SkinMainSound = {
	CrateSkin.WOOD: shock_wood_sound,
	CrateSkin.FRAGILE: shock_wood_sound,
	CrateSkin.HUMAN: shock_wood_sound,
	CrateSkin.PQ: $Sounds/Shock/Pq,
	CrateSkin.HOLED: shock_wood_sound,
	CrateSkin.PACKAGE: shock_wood_sound
}

@onready var SkinCompositeSound = {
	CrateSkin.WOOD: [null],
	CrateSkin.FRAGILE: [$Sounds/Shock/Glass],
	CrateSkin.HUMAN: [$Sounds/Shock/Human],
	CrateSkin.PQ: [null],
	CrateSkin.HOLED: [null, $Sounds/Shock/Pan],
	CrateSkin.PACKAGE: [null, $Sounds/Shock/Glass, $Sounds/Shock/Pan]
}

func _ready():
	in_range_physic_tools = []
	prev_pos = position
	self.connect("clicked", launcher.handle_click)
	self.connect("killme", launcher.kill_crate)
	
	var picked_skin = randi() % len(CrateSkin)
	crate_main_sound = SkinMainSound[picked_skin]
	
	print(SkinAtlasRegion[picked_skin])
	$Sprite.region_enabled = true
	$Sprite.region_rect = SkinAtlasRegion[picked_skin]
	
	var composites = SkinCompositeSound[picked_skin]
	crate_composite_sound = composites[randi() % len(composites)]

func _physics_process(delta):
	if (linear_velocity.length() > max_speed):
		linear_velocity = linear_velocity.normalized()*max_speed
	if (abs(angular_velocity) > max_rot):
		angular_velocity = clamp(angular_velocity, -max_rot, max_rot)

func _process(delta):
	if !is_dying:
		for influence in in_range_physic_tools:
			influence.add_physics_modifier(self)
		# Keep alive if moving
		if (launched && prev_pos != null && prev_rot != null && ((prev_pos - position).length() > epsilon || prev_rot - rotation > rot_epsilon)):
			timer.start(depop_delay)
		if (global_position.y > 300):
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
	if !launched && in_launch_area && event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			emit_signal("clicked", self)

func _on_detection_area_entered(area):
	var tool = area as PhysicsTool
	if tool != null:
		in_range_physic_tools.append(tool)

func _on_detection_area_exited(area):
	var tool = area as PhysicsTool
	if tool != null:
		in_range_physic_tools.erase(tool)

func _on_body_entered(body):
	if $FirstShockSound.is_stopped():
		if shock_sound_cooldown.is_stopped():
			shock_sound_cooldown.start()
			crate_main_sound.play_random_sound()
			if crate_composite_sound != null:
				crate_composite_sound.play_random_sound()

var is_dying = false

func destroy():
	if not is_dying:
		is_dying = true
		freeze = true
		#$Sounds/Destroy.play_random_sound()
		var tween = create_tween()
		tween.tween_property(self, 'modulate:a', 0.0, 0.5)
		tween.tween_callback(queue_free)
