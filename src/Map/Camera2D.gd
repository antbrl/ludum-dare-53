extends Camera2D

var followed = null
var default_position = null

const transition_move_duration = 0.8
const transition_zoom_duration = 0.5
const total_transition_duration = 1.0

const transition_move_duration_back = 0.5
const transition_zoom_duration_back= 0.5
const total_transition_duration_back = 0.5

const default_zoom = Vector2(1, 1)
const follow_zoom = Vector2(2, 2)

const control_speed = 1000
const zoom_speed = 2

var transition_status = null
var transition_from = null
var zoom_from = null

@onready var bounds = get_node("../Bounds")

func _ready():
	default_position = global_position

func back_to_default():
	followed = null
	transition_from = global_position
	transition_status = 0.0
	zoom_from = zoom

func follow(object):
	followed = object
	transition_from = global_position
	transition_status = 0.0
	zoom_from = zoom

func _physics_process(delta):
	if transition_status != null:
		transition_status += delta
		if (followed != null):
			if transition_status < transition_move_duration:
				var transition_to = followed.global_position
				global_position = Tween.interpolate_value(transition_from, transition_to - transition_from, transition_status, transition_move_duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
			else:
				global_position = followed.global_position
			if (transition_status > total_transition_duration - transition_zoom_duration):
				var zoom_transition_status = transition_status - (total_transition_duration - transition_zoom_duration)
				zoom = Tween.interpolate_value(zoom_from, follow_zoom - zoom_from, zoom_transition_status, transition_zoom_duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
			if (transition_status > total_transition_duration):
				zoom = follow_zoom
				transition_status = null
		else:
			if transition_status < transition_zoom_duration_back:
				zoom = Tween.interpolate_value(zoom_from, default_zoom - zoom_from, transition_status, transition_zoom_duration_back, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
			if (transition_status > total_transition_duration_back - transition_move_duration_back):
				var move_transition_status = transition_status - (total_transition_duration_back - transition_move_duration_back)
				var transition_to = default_position
				global_position = Tween.interpolate_value(transition_from, transition_to - transition_from, move_transition_status, transition_move_duration_back, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
			if (transition_status > total_transition_duration_back):
				zoom = default_zoom
				transition_status = null
	elif followed != null:
		global_position = followed.global_position
	else:
		var buffer = Vector2(0, 0)
		if (Input.is_action_pressed("ui_right")):
			buffer += Vector2(1, 0)
		if (Input.is_action_pressed("ui_left")):
			buffer += Vector2(-1, 0)
		if (Input.is_action_pressed("ui_up") && !Input.is_action_pressed("zoom-in")):
			buffer += Vector2(0, -1)
		if (Input.is_action_pressed("ui_down") && !Input.is_action_pressed("zoom-out")):
			buffer += Vector2(0, 1)
		var predicted_pos = global_position + delta*control_speed*buffer.normalized()
		if (bounds.get_node("CollisionShape2D").shape.get_rect().has_point(predicted_pos)):
			global_position = predicted_pos
		var zoom_diff = 0.0
		if (Input.is_action_pressed("zoom-in")):
			zoom_diff += 1
		if (Input.is_action_pressed("zoom-out")):
			zoom_diff -= 1
		zoom += Vector2(1, 1)*delta*zoom_diff*zoom_speed
