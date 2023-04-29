extends Node2D

@onready var launch_area = get_node("LaunchArea")
@onready var test_box = get_node("TestBox")

const force = 500
const max_dist = 300.0
const full_follow_dist = 50
const max_speed = 2000.0

var mouse_in_area = false
var box_selected = false 
var box_in_area = true # TODO

var just_released = false
var last_box_pos = null

var cursor_status = false

# Used for rotation
var capture_point = null

func capture():
	test_box.gravity_scale = 1
	box_selected = true
	print("captured")

func release(delta, max):
	if (last_box_pos != null):
		test_box.gravity_scale = 1
		box_selected = false
		if max:
			test_box.linear_velocity = (get_global_mouse_position() - test_box.to_global(capture_point)).normalized()*max_speed
		else:
			# When the package is lost due to the distance, give it the max allowed speed
			var current_velocity = (test_box.to_global(capture_point) - last_box_pos)/delta
			if (current_velocity.length() > max_speed):
				current_velocity *= max_speed/current_velocity.length()
			test_box.linear_velocity = current_velocity
	print("released")

func _physics_process(delta):
	if (just_released):
		just_released = false
		release(delta, false)
	elif (!box_selected && mouse_in_area && box_in_area && cursor_status):
		# Assistanat
		if ((get_global_mouse_position() - test_box.global_position).length() <= max_dist):
			capture_point = Vector2(0, 0)
			capture()
	elif (mouse_in_area && box_selected && box_in_area):
		var cursor_pos = get_global_mouse_position()
		var box_pos    = test_box.to_global(capture_point)
		var pos_diff   = cursor_pos - box_pos
		
		if (pos_diff.length() > max_dist):
			release(delta, true)
		
		# Moving an object gets harder past a certain distance
		var adjusted_pos_diff_length = max(pos_diff.length(), full_follow_dist) - full_follow_dist
		var dist_modifier = clamp(adjusted_pos_diff_length, 0.0, max_dist)/max_dist
		var strength = force*(1.0 - dist_modifier)**3
		
		test_box.global_position += pos_diff.normalized() * clamp(strength, 0, pos_diff.length())
		
		# Rotation
		var drag_vec = pos_diff
		var com_anchor_vec = box_pos - test_box.global_position
		test_box.angular_velocity += -.05 * drag_vec.cross(com_anchor_vec)
		
		last_box_pos = box_pos

	if (box_selected && test_box.linear_velocity.length() != 0 && (get_global_mouse_position() - test_box.to_global(capture_point)).length() < full_follow_dist):
		test_box.linear_velocity = Vector2(0, 0)

func _on_launch_area_mouse_entered():
	mouse_in_area = true

func _on_launch_area_mouse_exited():
	mouse_in_area = false

func _on_test_box_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			capture_point = test_box.to_local(get_global_mouse_position())
			capture()

func _input(event):
	# TODO scroll wheel
	if event is InputEventMouseButton:
		cursor_status = event.is_pressed()
		if box_selected == true && !cursor_status:
			just_released = true
