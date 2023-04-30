extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var singularity: PhysicsTool = get_parent().get_parent().get_node("Singularity")
	singularity.add_physics_modifier(self)
