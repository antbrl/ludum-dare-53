extends Node2D

@onready var launch_area = $LaunchArea
@onready var test_box = $TestBox

const snap_dist = 300.0
const max_speed = 1200.0

var box_selected = false
var box_in_area = true
var mouse_in_area = false
var click_pressed = false

var just_released = false
var last_box_pos = null

var anchor = null

func init(box):
	test_box = box

#func _ready():
#	assert(test_box != null, "call init first")
#	init($TestBox)

func capture():
	test_box.linear_velocity = Vector2(0, 0)
	box_selected = true

func release(delta):
	if (last_box_pos != null):
		just_released = false
		box_selected = false
		var current_velocity = (test_box.to_global(anchor) - last_box_pos)/delta
		if (current_velocity.length() > max_speed):
			current_velocity *= max_speed/current_velocity.length()
		test_box.linear_velocity = current_velocity

func _physics_process(delta):
	if (just_released):
		release(delta)
	elif (!box_selected && mouse_in_area && box_in_area && click_pressed):
		# Snapping
		if ((get_global_mouse_position() - test_box.global_position).length() <= snap_dist):
			anchor = Vector2(0, 0)
			capture()
	elif (box_selected && mouse_in_area && box_in_area):
		var cursor_pos = get_global_mouse_position()
		var box_pos    = test_box.to_global(anchor)
		var pos_diff   = cursor_pos - box_pos
		var com_anchor_vec = box_pos - test_box.global_position
		test_box.global_position += pos_diff
		test_box.angular_velocity += -.05 * pos_diff.cross(com_anchor_vec)
		last_box_pos = box_pos

func _on_launch_area_mouse_entered():
	mouse_in_area = true

func _on_launch_area_mouse_exited():
	mouse_in_area = false
	if box_selected == true:
		just_released = true

func _on_test_box_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			anchor = test_box.to_local(get_global_mouse_position())
			capture()

func _input(event):
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		click_pressed = event.is_pressed()
		if box_selected == true:
			just_released = true

func _on_launch_area_body_entered(body):
	if (body == test_box):
		box_in_area = true

func _on_launch_area_body_exited(body):
	if (body == test_box):
		box_in_area = false
