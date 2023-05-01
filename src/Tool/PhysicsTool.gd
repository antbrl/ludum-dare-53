extends Tool

class_name PhysicsTool


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func add_physics_modifier(crate: Crate):
	pass

func play_sound():
	$AudioPlayer.play_sound()
