extends AnimatableBody2D
signal crate_dropped(crate)

func _on_target_body_entered(body):
	body.hit = true
	emit_signal("crate_dropped", body)
