extends Camera2D

var followed = null
var default_position = null

func _ready():
	default_position = global_position

func back_to_default():
	followed = null
	global_position = default_position

func follow(object):
	followed = object

func _physics_process(delta):
	if followed != null:
		global_position = followed.global_position
