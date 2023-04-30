extends Node2D

@onready var launch_area = $LaunchArea
@onready var crates = get_node("../Crates")

const snap_dist = 150.0
const max_speed = 1400.0

var mouse_in_area = false
var click_pressed = false

var just_released = false

var selected_crate          = null
var selected_crate_last_pos = null
var selected_crate_anchor   = null

func register_crate(new_crate):
	new_crate.connect("clicked", handle_click)
	new_crate.connect("killme", kill_crate) # TODO move to map

func _ready():
	for c in crates.get_children():
		register_crate(c)

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
	selected_crate = null

func _physics_process(delta):
	if (just_released):
		release(delta)
	elif (selected_crate == null && click_pressed): # Snapping
		selected_crate_anchor = Vector2(0, 0)
		var best = null
		for c in crates.get_children():
			var c_dist = (get_global_mouse_position() - c.global_position).length()
			if (c.in_launch_area && c_dist <= snap_dist):
				if (best == null || best > c_dist):
					best = c_dist
					selected_crate = c
		if best != null:
			capture(selected_crate)
	elif (selected_crate != null && mouse_in_area && selected_crate.in_launch_area):
		var cursor_pos = get_global_mouse_position()
		var crate_pos  = selected_crate.to_global(selected_crate_anchor)
		var pos_diff   = cursor_pos - crate_pos
		var com_anchor_vec = crate_pos - selected_crate.global_position
		selected_crate.global_position += pos_diff
		selected_crate.angular_velocity += -.05 * pos_diff.cross(com_anchor_vec)
		selected_crate_last_pos = crate_pos

func _on_launch_area_mouse_entered():
	mouse_in_area = true

func _on_launch_area_mouse_exited():
	mouse_in_area = false
	if selected_crate != null:
		just_released = true

func handle_click(crate):
	if (selected_crate == null):
		selected_crate_anchor = crate.to_local(get_global_mouse_position())
		capture(crate)

func _input(event):
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		click_pressed = event.is_pressed()
		if selected_crate != null:
			just_released = true

func _on_launch_area_body_entered(body):
	if (body.get_parent() == crates):
		body.set_launch_area(true)

func _on_launch_area_body_exited(body):
	if (body.get_parent() == crates):
		body.set_launch_area(false)

func _on_timer_timeout():
	pass

func kill_crate(crate):
	crate.queue_free()
