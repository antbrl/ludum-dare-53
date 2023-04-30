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

const VELOCITY_SQUARED_THRESHOLD = 50
func add_physics_modifier(crate: Crate):
	var dir_vector = Vector2.from_angle(PI - self.rotation)
	if crate.linear_velocity.dot(dir_vector) < 0:
		if crate.linear_velocity.project(dir_vector).length_squared() < VELOCITY_SQUARED_THRESHOLD:
			crate.linear_velocity = Vector2.ZERO
			return
		var portals = get_tree().get_nodes_in_group('portals')
		if portals.size() > 1:
			var other_portal = portals.filter(func(p): return p != self)[0]
			var angle_to = self.rotation + PI - other_portal.rotation
			var new_velocity = crate.linear_velocity.rotated(angle_to)
			crate.linear_velocity = new_velocity
			crate.rotation += angle_to
			crate.position = other_portal.position + Vector2.from_angle(PI - other_portal.rotation) * 5
