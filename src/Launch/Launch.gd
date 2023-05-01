extends Node2D

signal crate_killed(crate)
signal crate_followed_by_cam(crate)

@onready var launch_area = $LaunchArea
@onready var collision_shape = $LaunchArea/LaunchCollisionShape
@onready var crates = $"../Crates"
@onready var cam = $"../Camera2D"
@onready var game = $"../.."

const snap_dist = 150.0
const max_speed = 1400.0
const max_rot = 1000.0

var mouse_in_area = false
var click_pressed = false

var just_released = false

var selected_crate          = null
var selected_crate_last_pos = null
var selected_crate_anchor   = null

var disabled_in_throw = false
var disabled_due_to_mode = (Globals.DEFAULT_MODE == Globals.Mode.THROW)
var disabled = disabled_in_throw || disabled_due_to_mode

var followed_crate

var crate_scene = preload("res://src/Crate/Crate.tscn")

func set_disabled_mode(v):
	disabled_due_to_mode = v
	disabled = disabled_due_to_mode || disabled_in_throw

func set_disabled_throw(v):
	disabled_in_throw = v
	disabled = disabled_due_to_mode || disabled_in_throw

func capture(id):
	selected_crate = id
	selected_crate.linear_velocity = Vector2(0, 0)

func release(delta):
	assert(selected_crate != null, "no crate selected")
	if (selected_crate_last_pos != null):
		var current_velocity = (selected_crate.to_global(selected_crate_anchor) - selected_crate_last_pos)/delta
		if (current_velocity.length() > max_speed):
			current_velocity *= max_speed/current_velocity.length()
		selected_crate.linear_velocity = current_velocity
	else:
		selected_crate.linear_velocity = Vector2(0, 0)
	just_released = false
	selected_crate.thrown()
	cam.follow(selected_crate)
	followed_crate = selected_crate
	emit_signal("crate_followed_by_cam", followed_crate)
	selected_crate = null
	set_disabled_throw(true)

func _physics_process(delta):
	click_pressed = Input.is_action_pressed("click")
	if (just_released):
		release(delta)
	elif (selected_crate == null && click_pressed && !disabled): # Snapping
		selected_crate_anchor = Vector2(0, 0)
		var best = null
		for c in crates.get_children():
			var c_dist = (get_global_mouse_position() - c.global_position).length()
			if (!c.launched && c.in_launch_area && c_dist <= snap_dist):
				if (best == null || best > c_dist):
					best = c_dist
					selected_crate = c
		if best != null:
			capture(selected_crate)
	elif (selected_crate != null && mouse_in_area && selected_crate.in_launch_area && !disabled):
		var cursor_pos = get_global_mouse_position()
		var crate_pos  = selected_crate.to_global(selected_crate_anchor)
		var pos_diff   = cursor_pos - crate_pos
		var com_anchor_vec = crate_pos - selected_crate.global_position
		selected_crate.global_position += pos_diff
		selected_crate.angular_velocity += -1 * pos_diff.normalized().cross(com_anchor_vec)
		selected_crate.angular_velocity = clamp(selected_crate.angular_velocity, -max_rot, max_rot)
		selected_crate_last_pos = crate_pos

func _on_launch_area_mouse_entered():
	mouse_in_area = true

func _on_launch_area_mouse_exited():
	var glob_rect = collision_shape.get_shape().get_rect()
	glob_rect.position = glob_rect.position + collision_shape.global_position
	var mouse_is_inside = glob_rect.has_point(launch_area.get_global_mouse_position())
	if mouse_is_inside:
		return

	mouse_in_area = false
	if selected_crate != null:
		just_released = true

func handle_click(crate):
	if (selected_crate == null && !disabled):
		selected_crate_anchor = crate.to_local(get_global_mouse_position())
		capture(crate)

func _input(event):
	if !disabled && event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if selected_crate != null:
			just_released = true
	elif event.is_action_pressed("interrupt"):
		interrupt()

func interrupt():
	if disabled and followed_crate != null and game.mode == Globals.Mode.THROW:
		cam.back_to_default()
		kill_crate(followed_crate)

func _on_launch_area_body_entered(body):
	if (body.get_parent() == crates):
		body.set_launch_area(true)

func _on_launch_area_body_exited(body):
	if (body.get_parent() == crates):
		body.set_launch_area(false)
		if (body == selected_crate):
			just_released = true

func kill_crate(crate):
	emit_signal("crate_killed", crate)
	crate.destroy()
	if game.phase == Globals.Phase.TRIAL || game.challenge_crates_left >= 0:
		var new_crate = crate_scene.instantiate()
		new_crate.global_position = launch_area.to_global(Vector2(-200, -500))
		crates.add_child(new_crate)
	cam.back_to_default()
	set_disabled_throw(false)
