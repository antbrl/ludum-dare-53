extends Camera2D

var followed = null
var default_position = null

const transition_duration = 1.0
const default_zoom = Vector2(1, 1)
const follow_zoom = Vector2(2, 2)

var transition_status = null
var transition_from = null
var zoom_from = null

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
		var transition_to = default_position
		if (followed != null):
			transition_to = followed.global_position
			zoom = Tween.interpolate_value(zoom_from, follow_zoom - zoom_from, transition_status, transition_duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		else:
			zoom = Tween.interpolate_value(zoom_from, default_zoom - zoom_from, transition_status, transition_duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		global_position = Tween.interpolate_value(transition_from, transition_to - transition_from, transition_status, transition_duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		if (transition_status > transition_duration):
			transition_status = null
	elif followed != null:
		global_position = followed.global_position
		pass
