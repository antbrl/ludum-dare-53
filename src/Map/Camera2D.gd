extends Camera2D

var followed = null
var default_position = null

const DEFAULT_TRANSITION_MOVE_DURATION = 0.8
const CINEMATIC_TRANSITION_MOVE_DURATION = 2.0

const DEFAULT_TRANSITION_ZOOM_DURATION = 0.5
const CINEMATIC_TRANSITION_ZOOM_DURATION = 1

const DEFAULT_ZOOM_SPEED = 2

const DEFAULT_FOLLOW_ZOOM = Vector2(4, 4)
const CINEMATIC_FOLLOW_ZOOM = Vector2(1, 1)

var transition_move_duration = DEFAULT_TRANSITION_MOVE_DURATION
var transition_zoom_duration = DEFAULT_TRANSITION_ZOOM_DURATION
const total_transition_duration = 1.0

const transition_move_duration_back = 0.5
const transition_zoom_duration_back= 0.5
const total_transition_duration_back = 0.5

const default_zoom = Vector2(2, 2)
var follow_zoom = DEFAULT_FOLLOW_ZOOM
const min_zoom = Vector2(1, 1)
const max_zoom = Vector2(6, 6)

const control_speed = 1000
var zoom_speed = DEFAULT_ZOOM_SPEED

var transition_status = null
var transition_from = null
var zoom_from = null
var go_back_to_start_on_followed_reached = false

@onready var bounds = get_node("../Bounds")
@onready var backToDefault = $BackToDefault

@onready var left   = get_node("../Bounds/Left")
@onready var right  = get_node("../Bounds/Right")
@onready var top    = get_node("../Bounds/Top")
@onready var bottom = get_node("../Bounds/Bottom")

@onready var left_c   = null
@onready var right_c  = null
@onready var top_c    = null
@onready var bottom_c = null

var ghost_left   = null
var ghost_right  = null
var ghost_top    = null
var ghost_bottom = null
var ghost_shift  = 20

func _ready():
	left_c       = left.global_position.x + left.get_rect().end.x
	right_c      = right.global_position.x + right.get_rect().position.x
	top_c        = top.global_position.y + top.get_rect().end.y
	bottom_c     = bottom.global_position.y + bottom.get_rect().position.y
	ghost_left   = left.duplicate()
	ghost_right  = right.duplicate()
	ghost_top    = top.duplicate()
	ghost_bottom = bottom.duplicate()
	ghost_left.global_position -= Vector2(ghost_shift, 0)
	ghost_right.global_position += Vector2(ghost_shift, 0)
	ghost_top.global_position -= Vector2(0, ghost_shift)
	ghost_bottom.global_position += Vector2(0, ghost_shift)
	limit_left   = left_c
	limit_right  = right_c
	limit_top    = top_c
	limit_bottom = bottom_c
	global_position = Vector2(0, -200)
	default_position = global_position
	zoom = default_zoom

	
func cinematic_view_to(object):
	follow(object)
	transition_move_duration = CINEMATIC_TRANSITION_MOVE_DURATION
	transition_zoom_duration = CINEMATIC_TRANSITION_ZOOM_DURATION
	follow_zoom = CINEMATIC_FOLLOW_ZOOM
	self.go_back_to_start_on_followed_reached = true

func back_to_default():
	self.go_back_to_start_on_followed_reached = false
	transition_move_duration = CINEMATIC_TRANSITION_MOVE_DURATION
	transition_zoom_duration = CINEMATIC_TRANSITION_ZOOM_DURATION
	follow_zoom = CINEMATIC_FOLLOW_ZOOM
	followed = null
	transition_from = global_position
	transition_status = 0.0
	zoom_from = zoom

func follow(object):
	self.go_back_to_start_on_followed_reached = false
	transition_move_duration = DEFAULT_TRANSITION_MOVE_DURATION
	transition_zoom_duration = DEFAULT_TRANSITION_ZOOM_DURATION
	zoom_speed = DEFAULT_ZOOM_SPEED
	follow_zoom = DEFAULT_FOLLOW_ZOOM
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
				followed_object_reached()
		else:
			if transition_status < transition_zoom_duration_back:
				zoom = Tween.interpolate_value(zoom_from, default_zoom - zoom_from, transition_status, transition_zoom_duration_back, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
			if (transition_status > total_transition_duration_back - transition_move_duration_back):
				var move_transition_status = transition_status - (total_transition_duration_back - transition_move_duration_back)
				var transition_to = default_position
				global_position = Tween.interpolate_value(transition_from, transition_to - transition_from, move_transition_status, transition_move_duration_back, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
			if (transition_status > total_transition_duration_back):
				#zoom = default_zoom
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
		var prev_pos = global_position
		global_position += delta*control_speed*buffer.normalized() 
		position = Vector2(clamp(position.x,limit_left+get_viewport_rect().size.x/(2*zoom.x),limit_right-get_viewport_rect().size.x/(2*zoom.x)),clamp(position.y,limit_top+get_viewport_rect().size.y/(2*zoom.y),limit_bottom-get_viewport_rect().size.y/(2*zoom.y)))
		var zoom_diff = 0.0
		if (Input.is_action_pressed("zoom-in")):
			zoom_diff += 1
		if (Input.is_action_pressed("zoom-out")):
			zoom_diff -= 1
		zoom += zoom * Vector2(1, 1)*delta*zoom_diff*zoom_speed
		zoom = clamp(zoom, min_zoom, max_zoom)
		
func followed_object_reached():
	if go_back_to_start_on_followed_reached:
		self.go_back_to_start_on_followed_reached = false
		backToDefault.start()
		

func _on_timer_timeout():
	back_to_default()
	backToDefault.stop()

