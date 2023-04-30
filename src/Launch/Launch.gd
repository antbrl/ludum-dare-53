extends Node2D

@onready var launch_area = $LaunchArea
@onready var crate = $TestBox

const snap_dist = 150.0
const max_speed = 1400.0

var crate_selected = false
var crate_in_area = true
var mouse_in_area = false
var click_pressed = false

var just_released = false
var last_crate_pos = null

var anchor = null

func init(new_crate):
	print(new_crate)
	crate = new_crate
	crate_in_area = launch_area.overlaps_body(crate)
	crate.connect("input_event", _on_crate_input_event)

func capture():
	crate.linear_velocity = Vector2(0, 0)
	crate_selected = true

func release(delta):
	if (last_crate_pos != null):
		just_released = false
		crate_selected = false
		var current_velocity = (crate.to_global(anchor) - last_crate_pos)/delta
		if (current_velocity.length() > max_speed):
			current_velocity *= max_speed/current_velocity.length()
		crate.linear_velocity = current_velocity

func _physics_process(delta):
	if (just_released):
		release(delta)
	elif (!crate_selected && mouse_in_area && crate_in_area && click_pressed):
		# Snapping
		if ((get_global_mouse_position() - crate.global_position).length() <= snap_dist):
			anchor = crate.to_local(get_global_mouse_position())
			capture()
	elif (crate_selected && mouse_in_area && crate_in_area):
		var cursor_pos = get_global_mouse_position()
		var crate_pos  = crate.to_global(anchor)
		var pos_diff   = cursor_pos - crate_pos
		var com_anchor_vec = crate_pos - crate.global_position
		crate.global_position += pos_diff
		crate.angular_velocity += -.05 * pos_diff.cross(com_anchor_vec)
		last_crate_pos = crate_pos

func _on_launch_area_mouse_entered():
	mouse_in_area = true

func _on_launch_area_mouse_exited():
	mouse_in_area = false
	if crate_selected == true:
		just_released = true

func _on_crate_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			anchor = crate.to_local(get_global_mouse_position())
			capture()

func _input(event):
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		click_pressed = event.is_pressed()
		if crate_selected == true:
			just_released = true

func _on_launch_area_body_entered(body):
	if (body == crate):
		crate_in_area = true

func _on_launch_area_body_exited(body):
	if (body == crate):
		crate_in_area = false
