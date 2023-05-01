@tool

extends PhysicsTool

@export var direction: Globals.Direction = Globals.Direction.NONE:
	get:
		return direction
	set(value):
		direction = value
		_update_placement()

func _update_placement():
	match direction:
		Globals.Direction.RIGHT:
			rotation_degrees = 180
		Globals.Direction.UP:
			rotation_degrees = 90
		Globals.Direction.DOWN:
			rotation_degrees = 270
		_:
			rotation_degrees = 0

@export var OUTPUT_VELOCITY = 500
func add_physics_modifier(crate: Crate):
	var dir_vector = Vector2.from_angle(self.rotation)
	if crate.linear_velocity.dot(dir_vector) < 0:
		var portals = get_tree().get_nodes_in_group('portals')
		if portals.size() > 1:
			var other_portal = portals.filter(func(p): return p != self)[0]
			var angle_to = self.rotation + PI - other_portal.rotation
			var other_portal_vector = Vector2.from_angle(other_portal.rotation)
			crate.linear_velocity = other_portal.OUTPUT_VELOCITY * other_portal_vector
			crate.position = other_portal.position + other_portal_vector * 4
			$AudioPlayer.play_random_sound()
