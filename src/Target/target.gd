extends Area2D
signal crate_dropped(crate)

func _on_target_body_entered(body: RigidBody2D):
	body.hit = true
	body.linear_velocity = Vector2.ZERO;
	emit_signal("crate_dropped", body)
